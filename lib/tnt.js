const Promise = require('bluebird');
const path = require('path');
const TNTConsignment = require('./tnt-consignment');
const libxslt = require('libxslt');
Promise.promisifyAll(libxslt);
const pdf = require('html-pdf');
Promise.promisifyAll(require('html-pdf/lib/pdf').prototype);
const trixml = require('trixml');

class TNT {
    constructor({accounts, username, password}) {
        this.accounts = accounts;
        this.username = username;
        this.password = password;
    }

    newConsignment() {
        return new TNTConsignment({tnt: this});
    }

    async manifest(connumbers) {
        if (!(connumbers instanceof Array)) {
            connumbers = [connumbers];
        }
        const cons = new TNTConsignment({tnt: this});
        return await cons.manifest(connumbers);
    }

    async renderManifest(xml, marketType, format = 'html') {
        let stylesheet = await libxslt.parseFileAsync(path.resolve(__dirname, './manifest/HTMLSummaryManifestRenderer.xsl'));
        let txml = trixml.parseSync(xml);
        marketType = marketType.toUpperCase();
        txml.CONSIGNMENT.forEach(cons => {
            if (cons.attr('marketType') !== marketType) {
                cons.remove();
            }
        });
        const html = await stylesheet.apply(txml.toXML());

        switch (format) {
            default:
            case 'html':
                return html;
                break;
            case 'pdf':
                return await pdf.create(html, {
                    base: 'file:///' + path.resolve(__dirname) + '/',
                    width: '210mm',
                    height: '297mm'
                }).toBufferAsync();
                break;
        }
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
