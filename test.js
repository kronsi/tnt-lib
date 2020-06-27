
const TNT = require('./lib/index');
const fs = require('fs');

let tnt = new TNT({
    username: 'username',
    password: 'password',
    accounts: {
        DE: {number:'account', lineOfBusiness: 1}
    }
});

let mockXML = `<?xml version="1.0" encoding="UTF-8"?>
<labelResponse>
    <consignment key="CON1">
        <pieceLabelData>
            <pieceNumber>1</pieceNumber>
            <weightDisplay code="1.0" renderInstructions="yes">1.00kg</weightDisplay>
            <pieceReference><![CDATA[1]]></pieceReference>
            <barcode symbology="128C">811693463001104990847310</barcode>
            <twoDBarcode symbology="pdf417"><![CDATA[811693463|811693463||1||Sender Company|Sender Street|Sender City|Sender Zip|Sender Country||Recipient Company|Recipient Street|Recipient City|Recipient Zip|Recipient Country|100|EP|N||||||||N|||Item 1|1|1.0|0.0010000000000000002|N|29 Jun 2020|15:00:00]]></twoDBarcode>
        </pieceLabelData>
        <consignmentLabelData>
            <consignmentNumber>811693463</consignmentNumber>
            <sender>
                <name><![CDATA[Sender Company]]></name>
                <addressLine1><![CDATA[Sender Street]]></addressLine1>
                <addressLine2><![CDATA[]]></addressLine2>
                <town><![CDATA[Sender City]]></town>
                <province><![CDATA[]]></province>
                <postcode><![CDATA[Sender Zip]]></postcode>
                <country><![CDATA[Sender Country]]></country>
            </sender>
            <delivery>
                <name><![CDATA[Recipient Company]]></name>
                <addressLine1><![CDATA[Recipient Street]]></addressLine1>
                <addressLine2><![CDATA[]]></addressLine2>
                <town><![CDATA[Recipient City]]></town>
                <province><![CDATA[]]></province>
                <postcode><![CDATA[Recipient Zip]]></postcode>
                <country><![CDATA[Recipient Country]]></country>
            </delivery>
            <account>
                <accountNumber>000000000</accountNumber>
                <accountCountry>DE</accountCountry>
            </account>
            <totalNumberOfPieces>1</totalNumberOfPieces>
            <product id="EP">Express</product>
            <collectionDate>2020-06-29</collectionDate>
            <marketDisplay code="1" renderInstructions="yes"><![CDATA[DOM]]></marketDisplay>
            <transportDisplay code="3" renderInstructions="yes"><![CDATA[ROAD]]></transportDisplay>
            <freeCirculationDisplay code="" renderInstructions="highlighted"><![CDATA[C]]></freeCirculationDisplay>
            <sortSplitText><![CDATA[1]]></sortSplitText>
            <xrayDisplay code="" renderInstructions="no"/>
            <originDepot>
                <depotCode>BIE</depotCode>
            </originDepot>
            <transitDepots>
                <transitDepot>
                    <depotCode>HNJ</depotCode>
                </transitDepot>
            </transitDepots>
            <destinationDepot>
                <depotCode>EF3</depotCode>
                <dueDayOfMonth>30</dueDayOfMonth>
                <dueDate>2020-06-30</dueDate>
            </destinationDepot>
            <microzone code="" renderInstructions="no"/>
            <clusterCode>5C</clusterCode>
            <legalComments></legalComments>
            <cashAmount code="0.0" renderInstructions="no"/>
            <bulkShipment code="" renderInstructions="no"/>
        </consignmentLabelData>
    </consignment>
</labelResponse>`;

let consignment = tnt.newConsignment();

consignment.setSenderAddress({
    company_name: "Company",
    address1: "Sender Address Line 1",
    //address2: "Sender Address Line 2",
    //address3: "Sender Address Line 3",
    city: "City",
    postcode: "ZipCode",
    country: "Country",
    //vat_no: "GB000000000",
    contact_name: "Max Mustermann",
    contact_telephone: "+491212121",
    //contact_email: "email@example.com"
});

consignment.setDeliveryAddress({
    company_name: "Company",
    address1: 'Deliver Address Line 1',
    city: 'City',
    postcode: 'ZipCode',
    country: 'Country',
    contact_name: "Name...",
    contact_telephone: "+49 12312121",
});

consignment.setBoxes([
    {
        id: 1,
        description: 'Item 1',
        depth_cm: 10,
        height_cm: 10,
        width_cm: 10,
        weight_kg: 1,
    }
])

consignment.setCollectionDate('2020-06-29 16:00');

const start = async function() {
    let labelXml = "";
    if( mockXML.length == 0 ){
        const services = await consignment.queryAvailableServices();
        consignment.setService(services[services.length-2]);
        console.log('Available Services:', services);

        const consignmentNum = await consignment.createConsignment();
        console.log('TNT Consignment Number:', consignmentNum);

        labelXml = await consignment.fetchLabelXml();
        console.log('TNT labelXml:', labelXml);
    }
    else {
        labelXml = mockXML;
    }
    
    const labelHtml = await tnt.renderLabel(labelXml);
    console.log("labelHtml", labelHtml);
}

start();
