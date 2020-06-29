
const TNT = require('./lib/index');
const fs = require('fs');

let tnt = new TNT({
    username: 'username',
    password: 'password',
    accounts: {
        DE: {number:'0000000', lineOfBusiness: 1}
    }
});

let mockXML = ``;

let consignment = tnt.newConsignment();

consignment.setSenderAddress({
    company_name: "Sender Company",
    contact_name: "Sender Name",
    address1: "Sender Street",
    //address2: "Sender Address Line 2",
    //address3: "Sender Address Line 3",
    city: "Sender City",
    postcode: "Sender Zip",
    country: "Sender Country",
    //vat_no: "GB000000000",
    contact_telephone: "Sender Phone",
    //contact_email: "email@example.com"
});

consignment.setDeliveryAddress({
    company_name: "Recipient Company",
    contact_name: "Recipient Name",
    address1: 'Recipient Street',
    city: 'Recipient City',
    postcode: 'Recipient Zip',
    country: 'Recipient Country',
    contact_telephone: "Recipient Phone",
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

consignment.setCollectionDate('2020-06-30 16:00');

const start = async function() {
    let labelXml = "";
    if( mockXML.length == 0){
        const services = await consignment.queryAvailableServices();
        consignment.setService(services[services.length-2]);
        console.log('Available Services:', services);

        //doShip == true -> shipment send live env
        //doShip == false -> shipment was not send dev env
        const testing = !true;        
        const consignmentNum = await consignment.createConsignment(testing);
        console.log('TNT Consignment Number:', consignmentNum);

        labelXml = await consignment.fetchLabelXml();
        console.log('TNT labelXml:', labelXml);
    }
    else {
        labelXml = mockXML;
    }
    
    const labelHtml = await tnt.renderLabel(labelXml);
    //console.log("labelHtml", labelHtml);
}

start();
/*
cons.setService(services[0]);

const consignmentNum = await cons.createConsignment();
console.log('TNT Consignment Number:', consignmentNum);

const labelXml = await cons.fetchLabelXml();

const labelPdf = await tnt.renderLabel(labelXml, {
    width: "101mm",
    height: "152mm"
});

await fs.outputFile('./label.pdf', labelPdf);

console.log("consignment",consignment);
*/