const path = require('path');
const trixml = require('trixml');
const fs = require('fs-extra');
const moment = require('moment');

const LabelRequest = require('./requests/label');
const ShipRequest = require('./requests/ship');
const PriceRequest = require('./requests/price');

class TNTConsignment {
    constructor({tnt}) {
        this.tnt = tnt;

        this.connumber = null;
        this.rate = null;
        this.account = '';

        this.shipRequest = new ShipRequest(this);
        this.labelRequest = new LabelRequest(this);
        this.priceRequest = new PriceRequest(this);
    }

    setDeliveryAddress(address) {
        let cc = String(address.country).toUpperCase();
        this.account = this.tnt.accounts[cc] || this.tnt.accounts.ROW;

        this.shipRequest.setDeliveryAddress(address);
        this.labelRequest.setDeliveryAddress(address);
        this.priceRequest.setDeliveryAddress(address);
        this.shipRequest.initCredentials();
        this.labelRequest.initCredentials();
        this.priceRequest.initCredentials();
    }

    setSenderAddress(address) {
        this.shipRequest.setSenderAddress(address);
        this.labelRequest.setSenderAddress(address);
        this.priceRequest.setSenderAddress(address);
    }

    setCollectionDate(date) {
        this.shipRequest.setCollectionDate(date);
        this.labelRequest.setCollectionDate(date);
        this.priceRequest.setCollectionDate(date);
    }

    setBoxes(boxes) {
        for (let box of boxes) {
            box.height_cm = Math.max(box.height_cm, 1);
            box.width_cm = Math.max(box.width_cm, 1);
            box.depth_cm = Math.max(box.depth_cm, 1);
        }
        this.shipRequest.setBoxes(boxes);
        this.labelRequest.setBoxes(boxes);
        this.priceRequest.setBoxes(boxes);
    }

    setService(service, options) {
        if (typeof service === 'object' && service.options && service.id) {
            options = service.options;
            service = service.id;
        }
        this.shipRequest.setService(service, options);
        this.labelRequest.setService(service, options);
        this.priceRequest.setService(service, options);
    }

    async queryAvailableServices() {
        return this.priceRequest.queryAvailableServices();
    }

    async createConsignment(doShip = true, showBookingRef = true, emailRequired = false) {
        return this.shipRequest.createConsignment(doShip, showBookingRef, emailRequired);
    }

    async renderLabel(labelXml) {
        return this.labelRequest.renderLabel(labelXml);
    }

    async fetchLabelXml() {
        return this.labelRequest.fetchLabelXml();
    }

    async ship() {
        return this.shipRequest.ship();
    }

    async book() {
        return this.shipRequest.book();
    }

    async manifest(connumbers) {
        return this.shipRequest.manifest(connumbers);
    }

    async renderManifest(xml, marketType) {
        return this.shipRequest.renderManifest(xml, marketType);
    }
}

module.exports = TNTConsignment;
