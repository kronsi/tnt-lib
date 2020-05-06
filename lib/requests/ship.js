const Promise = require('bluebird');
const request = Promise.promisify(require('request'));
const fs = require('fs');
const path = require('path');
const trixml = require('trixml');
const moment = require('moment');
const BaseRequest = require('./base');
const libxslt = require('libxslt');
Promise.promisifyAll(libxslt);

const url = "https://express.tnt.com/expressconnect/shipping/ship";
const template = fs.readFileSync(path.resolve(__dirname, './ship.xml'), 'utf8');

class ShipRequest extends BaseRequest {
    initTxml() {
        this.txml = trixml.parseSync(template);
    }

    async manifest(connumbers) {
        this.txml.ACTIVITY.empty();
        connumbers.sort();
        for (let connumber of connumbers) {
            this.txml.ACTIVITY.PRINT.MANIFEST.addChild('CONNUMBER', connumber);
        }
        this.txml.CONSIGNMENTBATCH.CONSIGNMENT.remove();
        let confirmation = await this.request();
        let res = await this.request(`GET_MANIFEST:${confirmation}`);
        return res;
        // let stylesheet = await libxslt.parseFileAsync(path.resolve(__dirname, '../manifest/HTMLManifestRenderer.xsl'));
        // let html = await stylesheet.apply(res);
        // return html;
    }

    async ship() {
        this.txml.ACTIVITY.empty();
        this.txml.ACTIVITY.SHIP.CONREF(this.txml.CONSIGNMENTBATCH.CONSIGNMENT.CONREF.value);

        let confirmation = await this.request();
        let res = await this.request(`GET_RESULT:${confirmation}`);
        let txml = trixml.parseSync(res);

        if (txml.SHIP.SUCCESS.value !== 'Y') {
            let e = Error("CREATE activity failure");
            e.body = res;
            throw e;
        }
    }

    async book(showBookingRef = true, emailRequired = false) {
        this.txml.ACTIVITY.empty();
        this.txml.ACTIVITY.BOOK({
            ShowBookingRef: showBookingRef?'Y':'N',
            EMAILREQD: emailRequired?'Y':'N'
        });
        this.txml.ACTIVITY.BOOK.CONREF(this.txml.CONSIGNMENTBATCH.CONSIGNMENT.CONREF.value);

        let confirmation = await this.request();
        let res = await this.request(`GET_RESULT:${confirmation}`);
        let txml = trixml.parseSync(res);

        if (txml.BOOK.SUCCESS.value !== 'Y') {
            let e = Error("CREATE activity failure");
            e.body = res;
            throw e;
        }
    }

    async createConsignment(doShip, showBookingRef, emailRequired) {
        this.txml.ACTIVITY.empty();
        this.txml.ACTIVITY.CREATE.CONREF(this.txml.CONSIGNMENTBATCH.CONSIGNMENT.CONREF.value);
        this.txml.ACTIVITY.RATE.CONREF(this.txml.CONSIGNMENTBATCH.CONSIGNMENT.CONREF.value);
        this.txml.ACTIVITY.BOOK({
            ShowBookingRef: showBookingRef?'Y':'N',
            EMAILREQD: emailRequired?'Y':'N'
        });
        this.txml.ACTIVITY.BOOK.CONREF(this.txml.CONSIGNMENTBATCH.CONSIGNMENT.CONREF.value);
        this.txml.ACTIVITY.SHIP.CONREF(this.txml.CONSIGNMENTBATCH.CONSIGNMENT.CONREF.value);

        let confirmation = await this.request();
        let res = await this.request(`GET_RESULT:${confirmation}`);
        let txml = trixml.parseSync(res);

        if (txml.CREATE.SUCCESS.value !== 'Y') {
            let e = Error("CREATE activity failure");
            e.body = res;
            throw e;
        }
        this.txml.ACTIVITY.CREATE.remove();
        this.consignment.connumber = txml.CREATE.CONNUMBER.value;

        // if (txml.RATE.PRICE.RESULT.value !== 'Y') {
        //     let e = Error("RATE activity failure");
        //     e.body = res;
        //     throw e;
        // }
        // this.txml.ACTIVITY.RATE.remove();
        this.consignment.rate = {
            price: txml.RATE.PRICE.RATE.value,
            service: txml.RATE.PRICE.SERVICEDESC.value,
            serviceCode: txml.RATE.PRICE.SERVICE.value
        };

        if (doShip) {
            let bookSuccess = txml.BOOK.CONSIGNMENT.SUCCESS.value === 'Y';
            let shipSuccess = txml.SHIP.CONSIGNMENT.SUCCESS.value === 'Y';

            let tries = 0;
            while (!bookSuccess) {
                console.log('BOOK failure', tries);
                if (++tries > 3) {
                    let e = Error("Repeated BOOK activity failures");
                    e.body = res;
                    throw e;
                }
                this.txml.ACTIVITY.empty();
                this.txml.ACTIVITY.BOOK({
                    ShowBookingRef: showBookingRef?'Y':'N',
                    EMAILREQD: emailRequired?'Y':'N'
                });
                this.txml.ACTIVITY.BOOK.CONNUMBER(this.consignment.connumber);
                res = await this.request();
                txml = trixml.parseSync(res);
                shipSuccess = txml.BOOK.CONSIGNMENT.SUCCESS.value === 'Y';
            }
            this.consignment.bookingRef = txml.BOOK.CONSIGNMENT.BOOKINGREF.value;

            tries = 0;
            while (!shipSuccess) {
                console.log('SHIP failure', tries);
                if (++tries > 3) {
                    let e = Error("Repeated SHIP activity failures");
                    e.body = res;
                    throw e;
                }
                this.txml.ACTIVITY.empty();
                this.txml.ACTIVITY.SHIP.CONNUMBER(this.consignment.connumber);
                res = await this.request();
                txml = trixml.parseSync(res);
                shipSuccess = txml.SHIP.CONSIGNMENT.SUCCESS.value === 'Y';
            }
            this.consignment.shipped = true;
        }

        return this.consignment.connumber;
    }

    async request(what) {
        let xml_in = what || this.toString();
        let res = await request({
            url,
            method: 'post',
            form: {xml_in}
        });

        if (!res.body || res.statusCode > 299) {
            throw Error(`Bad response: ${res.statusCode} - ${res.body}`);
        }

        if (what === undefined) {
            let match = res.body.match(/^COMPLETE:(\d+)$/);
            if (!match) {
                throw Error(`Bad response: ${res.statusCode} - ${res.body}`);
            }

            return match[1];

        } else {
            if (!/^<\?xml/i.test(res.body)) {

                let e = Error("Expected XML response");
                e.body = res.body;
                throw e;

            } else {
                let xml = trixml.parseSync(res.body);

                if (xml.error_reason.value) {
                    throw Error(xml.error_reason.value);
                }

                if (xml.ERROR.DESCRIPTION.value) {
                    let e = Error(xml.ERROR.DESCRIPTION.value);
                    e.code = xml.ERROR.CODE.value
                    e.source = xml.ERROR.SOURCE.value
                    throw e;
                }
            }

            return res.body;
        }
    }

    setService(code, options = []) {
        this.txml.CONSIGNMENTBATCH.CONSIGNMENT.DETAILS.SERVICE(code);
        // this.txml.CONSIGNMENTBATCH.CONSIGNMENT.DETAILS.OPTIONS(options);
    }

    setCollectionDate(date) {
        let mom = moment(date || new Date());
        this.txml.CONSIGNMENTBATCH.SENDER.COLLECTION.SHIPDATE(mom.format("DD/MM/YYYY"));
    }

    setAddress(txml, address) {
        let telephone = String(address.contact_telephone || "")
                .replace(/\s+/g, '')
                .replace(/\+44\(0\)/, '0')
                .replace(/[^\d]/g, '')
                .substr(0,16); // optional;
        let tellocal = telephone.substr(-9);
        let remainlen = telephone.length - tellocal.length;
        let teldialcode = remainlen > 0 ? telephone.substr(0, remainlen) : "";
        if (!teldialcode.length) {
            teldialcode = tellocal.substr(0, 1);
            tellocal = tellocal.substr(1);
        }

        txml.COMPANYNAME(address.company_name);
        txml.STREETADDRESS1(address.address1);
        txml.STREETADDRESS2(address.address2);
        txml.STREETADDRESS3(address.address3);
        txml.CITY(address.city);
        txml.PROVINCE(address.county);
        txml.POSTCODE(address.postcode);
        txml.COUNTRY(address.country);
        txml.VAT(address.vat_no);
        txml.CONTACTNAME(address.contact_name);
        txml.CONTACTDIALCODE(teldialcode); // 7 chars max
        txml.CONTACTTELEPHONE(tellocal); // 9 chars max
        txml.CONTACTEMAIL(address.contact_email);
    }

    setDeliveryAddress(address) {
        return this.setAddress(this.txml.CONSIGNMENTBATCH.CONSIGNMENT.DETAILS.RECEIVER, address);
    }

    setSenderAddress(address) {
        return this.setAddress(this.txml.CONSIGNMENTBATCH.SENDER, address);
    }

    setBoxes(boxes) {
        this.txml.CONSIGNMENTBATCH.CONSIGNMENT.DETAILS.ITEMS(boxes.length);

        let totalWeight = 0;
        let totalVolume = 0;

        for (let box of boxes) {
            let length = (box.depth_cm/100).toFixed(3);
            let height = (box.height_cm/100).toFixed(3);
            let width = (box.width_cm/100).toFixed(3);

            let pkg = this.txml.CONSIGNMENTBATCH.CONSIGNMENT.DETAILS.addChild('PACKAGE');
            pkg.ITEMS(1);
            pkg.DESCRIPTION(box.description);
            pkg.LENGTH(length);
            pkg.HEIGHT(height);
            pkg.WIDTH(width);
            pkg.WEIGHT(box.weight_kg);

            totalWeight += box.weight_kg;
            totalVolume += (length * height * width);
        }

        this.txml.CONSIGNMENTBATCH.CONSIGNMENT.DETAILS.TOTALWEIGHT(Math.max(totalWeight,0.001).toFixed(4));
        this.txml.CONSIGNMENTBATCH.CONSIGNMENT.DETAILS.TOTALVOLUME(Math.max(totalVolume,0.001).toFixed(4));
    }

    initCredentials() {
        this.txml.LOGIN.COMPANY(this.consignment.tnt.username);
        this.txml.LOGIN.PASSWORD(this.consignment.tnt.password);
        this.txml.CONSIGNMENTBATCH.SENDER.ACCOUNT(this.consignment.account.number);
    }
}

module.exports = ShipRequest;
