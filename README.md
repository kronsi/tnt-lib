# TNT Lib

## Install

`npm i @kronsi/tnt`

## Example Usage

```js
const TNT = require('@kronsi/tnt');

let tnt = new TNT({
    username: 'yourusername',
    password: 'yourpassword',
    accounts: {
        GB: {number:'0000000000', lineOfBusiness: 1},
        ROW: {number: '000000000', lineOfBusiness: 2}
    }
});

let consignment = tnt.newConsignment();

consignment.setSenderAddress({
    company_name: "Sender Company",
    address1: "Sender Address Line 1",
    address2: "Sender Address Line 2",
    address3: "Sender Address Line 3",
    city: "Sender City",
    county: "Sender County",
    postcode: "XX000XX",
    country: "GB",
    vat_no: "GB000000000",
    contact_name: "Sender Contact",
    contact_telephone: "00000000000",
    contact_email: "email@example.com"
});

consignment.setDeliveryAddress({
    company_name: "Company Name",
    address1: 'Address Line 1',
    city: 'City',
    postcode: 'XX000XX',
    country: 'GB',
    contact_name: "Contact Name",
    contact_telephone: "00000000000",
});

consignment.setBoxes([
    {
        id: 1,
        description: 'Item 1',
        depth_cm: 120,
        height_cm: 50,
        width_cm: 10,
        weight_kg: 3,
    },
    {
        id: 2,
        description: 'Item 2',
        depth_cm: 100,
        height_cm: 100,
        width_cm: 10,
        weight_kg: 3.2,
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

```

## Credits

Originally forked from [mikuso](https://github.com/mikuso/tnt-lib).

replaced libxslt by saxon-js in case of maintanance 


