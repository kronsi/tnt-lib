const Promise = require('bluebird');
const request = Promise.promisify(require('request'));
const fs = require('fs');
const path = require('path');
const trixml = require('trixml');
const moment = require('moment');
const BaseRequest = require('./base');

const url = "https://express.tnt.com/expressconnect/pricing/getprice";
const template = fs.readFileSync(path.resolve(__dirname, './price.xml'), 'utf8');

class PriceRequest extends BaseRequest {
    initTxml() {
        this.txml = trixml.parseSync(template);
    }

    async request() {
        let xml_in = this.toString();
        //console.log("xml_in", xml_in);
        let res = await request({
            url,
            method: 'post',
            headers: {'Content-Type':'text/xml'},
            body: xml_in,
            auth: {
                user: this.consignment.tnt.username,
                pass: this.consignment.tnt.password,
                sendImmediately: true
            }
        });

        if (!res.body || res.statusCode > 299) {
            throw Error(`Bad response: ${res.statusCode} - ${res.body}`);
        }

        if (/^<\?xml/i.test(res.body)) {
            let xml = trixml.parseSync(res.body);

            if (xml.errors.parseError.errorReason.value) {
                let e = Error(xml.errors.parseError.errorReason.value);
                e.line = xml.errors.parseError.errorLine.value;
                e.linepos = xml.errors.parseError.errorLinepos.value;
                e.srcText = xml.errors.parseError.errorSrcText.value;
                e.body = res.body;
                throw e;
            }
/*
            if (xml.errors.brokenRule.description.value && ['P78'].indexOf(xml.errors.brokenRule.code.value) === -1) {
                let e = Error(xml.errors.brokenRule.description.value);
                e.rateId = xml.errors.brokenRule.rateId.value;
                e.messageType = xml.errors.brokenRule.messageType.value;
                e.code = xml.errors.brokenRule.code.value;
                e.body = res.body;
                throw e;
            }*/
        }

        return res.body;
    }

    setCollectionDate(date) {
        let mom = moment(date || new Date());
        this.txml.priceCheck.collectionDateTime(mom.toISOString());
    }

    setAddress(txml, address) {
        txml.country(address.country);
        txml.town(address.city);
        txml.postcode(address.postcode);
    }

    setSenderAddress(address) {
        this.setAddress(this.txml.priceCheck.sender, address);
    }

    setDeliveryAddress(address) {
        this.setAddress(this.txml.priceCheck.delivery, address);
    }

    setBoxes(boxes) {
        let details = this.txml.priceCheck.consignmentDetails;

        let totalWeight = 0;
        let totalVolume = 0;

        for (let box of boxes) {
            let length = box.depth_cm/100;
            let height = box.height_cm/100;
            let width = box.width_cm/100;

            let piece = this.txml.priceCheck.addChild('pieceLine');
            piece.numberOfPieces(1);
            piece.pieceMeasurements.get('length')(length);
            piece.pieceMeasurements.width(width);
            piece.pieceMeasurements.height(height);
            piece.pieceMeasurements.weight(box.weight_kg);
            piece.pallet('false');

            totalWeight += box.weight_kg;
            totalVolume += (length * width * height);
        }

        details.totalWeight(Math.max(totalWeight,0.001).toFixed(4));
        details.totalVolume(Math.max(totalVolume,0.001).toFixed(4));
        details.totalNumberOfPieces(boxes.length);
    }

    setService(service, options = []) {
        this.txml.priceCheck.product.id(service);

        for (let optionCode of options) {
            let option = this.txml.priceCheck.product.options.addChild('option');
            option.optionCode(optionCode);
        }
    }

    async queryAvailableServices() {
        let res = await this.request();
        let xml = trixml.parseSync(res);
        return xml.priceResponse.ratedServices.ratedService.map(service => {
            let description = service.product.productDesc.value
            let options = service.product.options.option.map(option => ({
                code: option.optionCode.value,
                desc: option.optionDesc.value
            })).filter(x=>x.code);

            if (options.length > 0) {
                description += " - " + options.map(o=>o.desc).join(', ');
            }

            return {
                id: service.product.id.value,
                options: options.map(o=>o.code),
                description,
                price: service.totalPriceExclVat.value
            };
        }).filter(s=>s.id.length > 0);
    }

    initCredentials() {
        this.txml.priceCheck.account.accountNumber(this.consignment.account.number);
    }
}

module.exports = PriceRequest;
