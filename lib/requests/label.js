const Promise = require('bluebird');
const request = Promise.promisify(require('request'));
const fs = require('fs-extra');
const path = require('path');
const trixml = require('trixml');
const moment = require('moment');
const BaseRequest = require('./base');

const url = "https://express.tnt.com/expresslabel/documentation/getlabel";
const template = fs.readFileSync(path.resolve(__dirname, './label.xml'), 'utf8');


function legacyCodeToNewCode(service, options = []) {
    const map = {
        '1' : {service: 'EX', type: 'N', options: []},
        'S' : {service: 'EX', type: 'N', options: ['SA']},
        'AM' : {service: 'EX12', type: 'N', options: []},
        'BT' : {service: 'EX10', type: 'N', options: []},
        'BN' : {service: 'EX09', type: 'N', options: ['SN']},
        '09D' : {service: 'EX09', type: 'D', options: []},
        '10D' : {service: 'EX10', type: 'D', options: []},
        '12D' : {service: 'EX12', type: 'D', options:[]},
        '15D' : {service: 'EX', type: 'D', options:[]},
        '09N' : {service: 'EX09', type: 'N', options:[]},
        '10N' : {service: 'EX10', type: 'N', options:[]},
        '12N' : {service: 'EX12', type: 'N', options:[]},
        '15N' : {service: 'EX', type: 'N', options:[]},
        '48N' : {service: 'EC', type: 'N', options:[]}
    };

    let newCode = map[service];
    if (!newCode) {
        return {service, options}
    }

    let codeClone = Object.assign({}, newCode);
    codeClone.options = Array.from(codeClone.options);
    codeClone.options.push(...options);

    return codeClone;
}


class LabelRequest extends BaseRequest {
    initTxml() {
        this.txml = trixml.parseSync(template);
    }

    async request() {
        let xml_in = this.toString();
        let res = await request({
            url,
            method: 'post',
            headers: {
                'Content-Type': 'text/xml'
            },
            body: xml_in
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

            if (xml.brokenRules.errorDescription.value) {
                let e = Error(xml.brokenRules.errorDescription.value);
                e.code = xml.brokenRules.errorCode.value;
                e.body = res.body;
                throw e;
            }
        }

        return res.body;
    }

    async fetchLabelXml() {
        if (!this.consignment.connumber) {
            await this.consignment.create();
        }
        let condigits = this.consignment.connumber.match(/\d+/)[0];
        this.txml.consignment.consignmentIdentity.consignmentNumber(condigits);
        return await this.request();
    }

    async renderLabel(xml) {
        let stylesheet = await libxslt.parseFile(path.resolve(__dirname, '../label/HTMLRoutingLabelRenderer.xsl'));
        let html = await stylesheet.apply(xml);
        let pdfOut = await pdf.create(html, {
            base: 'file:///' + path.resolve(process.cwd()) + '/',
            width: '275px',
            height: '390px'
        }).toBufferAsync();
        return pdfOut;
    }

    setCollectionDate(date) {
        let mom = moment(date || new Date());
        this.txml.consignment.collectionDateTime(mom.toISOString());
    }

    setDeliveryAddress(address) {
        return this.setAddress(this.txml.consignment.delivery, address);
    }

    setSenderAddress(address) {
        return this.setAddress(this.txml.consignment.sender, address);
    }

    setAddress(txml, address) {
        txml.get('name')(address.company_name || address.contact_name);
        txml.addressLine1(address.address1);
        txml.addressLine2(address.address2);
        txml.addressLine3(address.address3);
        txml.town(address.city);
        txml.exactMatch('Y');
        txml.province(address.county);
        txml.postcode(address.postcode);
        txml.country(address.country);
    }

    setBoxes(boxes) {
        this.txml.consignment.totalNumberOfPieces(boxes.length);

        let nextSequence = 0;
        for (let box of boxes) {
            let length = (box.depth_cm/100).toFixed(3);
            let height = (box.height_cm/100).toFixed(3);
            let width = (box.width_cm/100).toFixed(3);

            let piece = this.txml.consignment.addChild('pieceLine');
            piece.identifier(box.id);
            piece.goodsDescription(box.description);
            piece.pieceMeasurements.get('length')(length);
            piece.pieceMeasurements.width(width);
            piece.pieceMeasurements.height(height);
            piece.pieceMeasurements.weight(box.weight_kg);
            piece.pieces.sequenceNumbers(++nextSequence);
            piece.pieces.pieceReference(box.id);
        }
    }

    setService(service, options = []) {
        let newCode = legacyCodeToNewCode(service, options);
        let prod = this.txml.consignment.product;
        prod.id(newCode.service);
        prod.lineOfBusiness(this.consignment.account.lineOfBusiness);
        for (let option of newCode.options) {
            prod.addChild('option', option);
        }
        if (newCode.type) {
            prod.type(newCode.type);
        }
    }

    initCredentials() {
        this.txml.consignment.account.accountNumber(this.consignment.account.number);
    }
}

module.exports = LabelRequest;
