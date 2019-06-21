//import Partner from './object/Partner.js';
//import TraceData from './object/TraceData.js';
// code above use for js core, in case of nodejs, use require
const Partner 	= require('./object/Partner.js');
const TraceData = require('./object/TraceData.js');
const config 	= require ('./app-config.js');
const Web3 		= require('web3');
const web3 		= new Web3('http://localhost:8545');
const fs 		= require('fs');

// const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'))
let rawdata = fs.readFileSync('ABI.json');
const abi = JSON.parse(rawdata);

// get contract
const contract = new web3.eth.Contract(abi, config.contractAddress, {
	defaultGasPrice: '200000'// default gas price in wei
});


// create function to add partner smart contract
function addPartner(pAddr, partnerid, GLN, name, partnerAddress, proof, typeofPartner) {
	console.log('- Calling addPartner smart contract.....');
	contract.methods
		.addPartner(pAddr, partnerid, GLN, name, partnerAddress, proof, typeofPartner)
		.send({ from: config.contractOwner, gas: "200000" },(err, receipt) => {
			if (!err) {
				//console.log(receipt)
				console.log('- Successful');				
			} else console.log('- Error:\n', err);
		})
		.then((receipt) => {
			//console.log('- Promise:\n', receipt)
		})
		.catch(async (cause) => {
			console.log('- Catched Errror:\n');
		});
	console.log('- Called!');
}

function getPartner(pAddr) {
	contract.methods
		.getPartner(pAddr)
		.call().then(result => {
			console.log(result);
		});
}

function addTraceData (fromAddr, dateCreate, desc, previousBarcode, publicBarcode) {
	contract.methods
		.storeTraceData(dateCreate, desc, previousBarcode, publicBarcode)
		.send({ from: fromAddr, gas: "200000" },(err, receipt) => {
			if (!err) {
				//console.log(receipt)
				console.log('- addTraceData Successful');				
			} else console.log('- addTraceData Error:\n', err);
		})
		.then((receipt) => {
			console.log('- Promise:\n', receipt)
		})
		.catch(async (cause) => {
			console.log('- Catched Errror:\n'+ cause);
		});
}

function getTraceData (publicBarcode) {
	contract.methods
		.getTraceData(publicBarcode)
		.call().then(result => {
			console.log(result);
		})
}



//addPartner(config.accounts[1], "farm1", "012345", "Fresh Mekong", "HCMC", "VietGAP", "FARM")
//getPartner("0x6a997d1e8d8403378a3f96fc17c8ceeaedaee67a");
//addTraceData(config.accounts[1], '26/06/2019', '2tons rice', '384723123439', '123535345345');
getTraceData('123535345345');


// create function to get partner smart contract