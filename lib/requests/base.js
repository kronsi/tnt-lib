const trixml = require('trixml');

class BaseRequest {
    constructor(consignment) {
        this.consignment = consignment;

        this.initTxml();
        this.initCredentials();
        this.setCollectionDate();
    }

    initCredentials() {}
    initTxml() {
        this.txml = trixml.newDoc();
    }

    toString() {
        return this.txml.toXML({pretty:true});
    }

    setCollectionDate() {}
    setDeliveryAddress() {}
    setSenderAddress() {}
    setCollectionDate() {}
    setBoxes() {}
    setService() {}

    isNational() {
        return this.txml.consignment.sender.country.value == this.txml.consignment.delivery.country.value;
    }

}

module.exports = BaseRequest;
