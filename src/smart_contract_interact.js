const Web3 = require('web3')
const web3 = new Web3('http://localhost:8545')

const fs = require('fs')

// const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'))
let rawdata = fs.readFileSync('ABI.json')
const abi = JSON.parse(rawdata)

// GET ACCOUNTS 
var accounts = new Array()
web3.eth.getAccounts().then(value =>{
  for(let i=0; i<10; i++)
    accounts[i] = value[i]
}).catch(err => {
  console.log('- Getted Error:', err)
})
console.log('- List Accounts', accounts) 


// address wich compile smart contract (ganache: usualy accounts[0])
const contractOwnerAddress = accounts[0]
// address with you want to use to call and send method RPC
const fromAccount = accounts[1]
// put your deployed Smart contract address
const contractAddress = "0x791d3220AF0ef4C9f47A2EBe3d652a4fCDb1eB99"
const contract  = new web3.eth.Contract(abi, contractAddress, {
  defaultGasPrice: '200000' // default gas price in wei
})

// create function to add partner smart contract
async function addPartner(address, partnerid, GLN, name, partnerAddress, proof, typeofPartner){
  console.log('- Calling addPartner smart contract.....')
  await contract.methods
    .addPartner(address, partnerid, GLN, name, partnerAddress, proof, typeofPartner)
    .send({from: contractOwnerAddress, gas: "200000"}, async (err, receipt) =>{
      if(!err){
        console.log(receipt)
      }else console.log('- Error:\n', err)
    })
    .then((receipt)=>{
      console.log('- Promise:\n', receipt)
    })
    .catch(async (cause)=>{
      console.log('- Catched Errror:\n')
  })
  console.log('- Called!')  
}

async function getPartner(addr) {
  await contract.method
}


addPartner("0x6a997d1e8d8403378a3f96fc17c8ceeaedaee67a","farm1", "012345", "Fresh Mekong", "HCMC", "VietGAP", "FARM")

// create function to get partner smart contract
function getPartner() {

}