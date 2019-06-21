const Web3 = require('web3');
const web3 = new Web3('http://localhost:8545');

// get accounts
web3.eth.getAccounts().then(async (value) => {
    const accounts = await value;
    console.log(accounts);
}).catch (err => {console.log(err)});

//console.log(accounts);

exports.contractOwner = '0xFaCA3a2c52947F0C2b9002f87116BB9133E7A7Eb';
exports.contractAddress = "0x57Fc31362b380607e3650566167DFD66D491CB60";
exports.accounts = [ '0xFaCA3a2c52947F0C2b9002f87116BB9133E7A7Eb',
'0xaAde934FA64008bE11aF69F7B299047A478A02e8',
'0x7A8E9875CB4cC56322FE2f3df3f504D9eB562529',
'0x71Cbf0A53C9C0Da0c85B8574E416EE939C4E3cEb',
'0x4b377d6196907B9fF4Dfe3Cb79F3b4a7beD53847',
'0x327b5d06CB091c3422Eb9B192fa7E8505AB9003f',
'0x9ECcA461a6B8F4113F91879a690FF8D3bc9703bF',
'0x309b0f83b4A8C6722a4af4Ea44F7b3772c2E49A4',
'0x03BC97F1A7958F155A10Ab25975c2fB2DEBeADcd',
'0x1d7cCF56fe788379652B627fd1Dfc433E7A57D8B' ]


/*
    To get accounts, open Terminal
    $node 
    copy this code
    const Web3 = require('web3');
    const web3 = new Web3('http://localhost:8545');
    web3.eth.getAccounts().then(result =>{
        console.log(result);
    });
*/