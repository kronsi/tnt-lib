const Promise = require('bluebird');
const path = require('path');
const TNTConsignment = require('./tnt-consignment');
const fs = require("fs");
const SaxonJS = require("saxon-js");
const pdf = require('html-pdf');
const uuid = require("uuid").v4;
Promise.promisifyAll(require('html-pdf/lib/pdf').prototype);
const trixml = require('trixml');
const request = Promise.promisify(require('request'));

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
        //let stylesheet = await libxslt.parseFileAsync(path.resolve(__dirname, './manifest/HTMLSummaryManifestRenderer.xsl'));
        
        let temp = await fs.readFileSync( path.resolve(__dirname, './manifest/HTMLSummaryManifestRenderer.xsl') );
        await fs.writeFileSync('sync.xml', xml, { mode: 0o755 });
        console.log("stylesheet", stylesheet);
        process.exit();
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
                    format: "A4",
                    border: {
                        "top": "0in",            // default is 0, units: mm, cm, in, px
                        "right": "0.7in",
                        "bottom": "0in",
                        "left": "0.7in"
                    }
                }).toBufferAsync();
                break;
        }
    }

    async renderLabel(xml, options = {}) {
        options = Object.assign({
            width: '275px',
            height: '390px'
        }, options);

        options.base = 'file:///' + path.resolve(__dirname) + '/';
        const filename = uuid();
        await fs.writeFileSync(`./tempfiles/${filename}.xml`, xml, { mode: 0o755 });
        return await SaxonJS.transform({
            stylesheetFileName: path.resolve(__dirname, './label/HTMLRoutingLabelRenderer.sef.json'),
            sourceFileName: `./tempfiles/${filename}.xml`,
            destination: "serialized"
        }, "async")
        .then (output => {
            fs.unlinkSync(`./tempfiles/${filename}.xml`);
            return output.principalResult;
        }).catch( (err) => {
            fs.unlinkSync(`./tempfiles/${filename}.xml`);
            console.log("err", err);
        });        
    }

    async lookupTown({country, town, postcode}) {
        const txml = trixml.newDoc('townSearchRequest');
        txml.appId('PC');
        txml.appVersion('1.0');
        const ts = txml.townsearch;
        ts.country(country || 'DE');
        ts.town(town || '');
        ts.postcode(postcode || '');
        const xml_in = txml.toXML({pretty:true});

        let res = await request({
            url: 'https://express.tnt.com/expressconnect/pricing/gettownpost',
            method: 'post',
            headers: {'Content-Type':'text/xml'},
            body: xml_in,
            auth: {
                user: this.username,
                pass: this.password,
                sendImmediately: true
            }
        });

        if (!res.body || res.statusCode > 299) {
            throw Error(`Bad response: ${res.statusCode} - ${res.body}`);
        }

        if (!/^<\?xml/i.test(res.body)) {
            const err = Error(`Bad response`);
            err.body = res.body;
            throw err;
        }

        let xml = trixml.parseSync(res.body);

        if (xml.errors.runtimeError.errorReason.value) {
            let e = Error(xml.errors.runtimeError.errorReason.value || "Runtime Error");
            e.srcText = xml.errors.runtimeError.errorSrcText.value;
            e.body = res.body;
            throw e;
        }

        if (xml.errors.parseError.errorReason.value) {
            let e = Error(xml.errors.parseError.errorReason.value || "Parse Error");
            e.line = xml.errors.parseError.errorLine.value;
            e.linepos = xml.errors.parseError.errorLinepos.value;
            e.srcText = xml.errors.parseError.errorSrcText.value;
            e.body = res.body;
            throw e;
        }

        return xml.searchResult.map(sr => ({
            startPC: sr.searchPCStartRange.value,
            endPC: sr.searchPCEndRange.value,
            town: sr.searchTown.value,
        }));
    }

    async track(connumber) {

    }
}

module.exports = TNT;
