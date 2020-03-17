const path = require("path");
var HDWalletProvider = require("truffle-hdwallet-provider");
require('dotenv').config();
var mnemonic = process.env.MNEMONIC;
var apiKey = process.env.API_KEY;

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*"
    },
    rinkeby: {
      provider: () =>
        new HDWalletProvider(
          mnemonic,
          `https://rinkeby.infura.io/v3/` + apiKey
        ),
      network_id: 4,
      networkCheckTimeout: 10
    },
  },
  compilers: {
    solc: {
      version: "0.6.2",
      optimizer: {
        enabled: true,
        runs: 1000
      },
      evmVersion: "homestead"
    }
  }
};
