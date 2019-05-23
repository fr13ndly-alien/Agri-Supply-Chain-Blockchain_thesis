const HDWalletProvider = require('truffle-hdwallet-provider');
const infuraKey = "a93ffc...<PUT YOUR INFURA-KEY HERE>";
// const fs = require('fs');
// const mnemonic = fs.readFileSync(".secret").toString().trim();
const mnemonic = "brass priority tribe indicate mimic guard finish gown lamp trip essence ice";
module.exports = {
  networks: {
    // Useful for testing. The `development` name is special - truffle uses it by default
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
    },
    // Useful for deploying to a public network.
    // NB: It's important to wrap the provider as a function.
    ropsten: {
      //provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/${infuraKey}`),
      provider: () => new HDWalletProvider(
        mnemonic,
        `https://ropsten.infura.io/${infuraKey}`,
        0,
        1,
        true,
        "m/44'/889'/0'/0/", // Connect with HDPath same as TOMO
      ),
      network_id: 3,       // Ropsten's id
      gas: 5500000,        // Ropsten has a lower block limit than mainnet
      // confirmations: 2,    // # of confs to wait between deployments. (default: 0)
      // timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      // skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },
    // Useful for deploying to TomoChain testnet
    tomotestnet: {
      provider: () => new HDWalletProvider(
        mnemonic,
        "https://testnet.tomochain.com",
        0,
        1,
        true,
        "m/44'/60'/0'/0/",
      ),
      network_id: 89,
      gas: 3000000,
      gasPrice: 10000000000000,  // TomoChain requires min 10 TOMO to deploy, to fight spamming attacks
      skipDryRun: true,
    },
    // Useful for deploying to TomoChain mainnet
    tomomainnet: {
      provider: () => new HDWalletProvider(
        mnemonic,
        "https://rpc.tomochain.com",
        0,
        1,
        true,
        "m/44'/889'/0'/0/",
      ),
      network_id: "88",
      gas: 3000000,
      gasPrice: 10000000000000,  // TomoChain requires min 10 TOMO to deploy, to fight spamming attacks
    },
    // Useful for private networks
    // private: {
      // provider: () => new HDWalletProvider(mnemonic, `https://network.io`),
      // network_id: 2111,   // This network is yours, in the cloud.
      // production: true    // Treats this network as if it was a public net. (default: false)
    // }
  },
  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },
  // Configure your compilers
  compilers: {
    solc: {
      version: "0.4.25",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    }
  }
}
