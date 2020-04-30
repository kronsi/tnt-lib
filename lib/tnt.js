const Promise = require('bluebird');
const path = require('path');
const TNTConsignment = require('./tnt-consignment');
const libxslt = require('libxslt');
Promise.promisifyAll(libxslt);
const pdf = require('html-pdf');
Promise.promisifyAll(require('html-pdf/lib/pdf').prototype);

class TNT {
    constructor({accounts, username, password}) {
        this.accounts = accounts;
        this.username = username;
        this.password = password;
    }

    newConsignment() {
        return new TNTConsignment({tnt: this});
    }

    async renderLabel(xml, options = {}) {
        Object.assign({
            width: '275px',
            height: '390px'
        }, options);

        let stylesheet = await libxslt.parseFileAsync(path.resolve(__dirname, './label/HTMLRoutingLabelRenderer.xsl'));
        let html = await stylesheet.apply(xml);
        let pdfOut = await pdf.create(html, {
            base: 'file:///' + path.resolve(__dirname) + '/',
            width: options.width,
            height: options.height
        }).toBufferAsync();
        return pdfOut;
    }
}

module.exports = TNT;
