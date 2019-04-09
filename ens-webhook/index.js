const express = require('express')
const bodyParser = require("body-parser");
const app = express()

const Web3 = require('web3');

const web3 = new Web3('https://mainnet.infura.io/v3/9eb801a4e6b94c2ca3cbd977e8249901');

// const main = () => {
//     web3.eth.ens.getAddress('ethereum.eth').then((contract) => {
//         console.log(contract);
//     });
// }
// main();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.get('/', (request, response) => {
    response.json({
        success: true
    })
})

app.post('/webhook', (request, response) => {
    try {
        const status = request.body.status

        if (status === "firing") {
            // Do ENS Lookup here,
            // Send email
            const ethDomain = 'ethereum.eth';

            web3.eth.ens.getAddress(ethDomain).then((address) => {
                console.log('Alert received!')
                console.log(`Looking up ENS ${ethDomain}...`)
                console.log(`Sending notification to address ${address}`)
            });
        }
    } catch (e) {
        console.log('Exception occured!')
        console.log(e)
    }

    response.json({
        success: true
    })
})

app.listen(8082)