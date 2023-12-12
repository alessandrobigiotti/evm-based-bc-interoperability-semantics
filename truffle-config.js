const HDWalletProvider = require('@truffle/hdwallet-provider');

// The private keys should be stored in another way
var privateKeyChainA = ['PUT YOUR PV KEY HERE'];
var privateKeyChainB = ['PUT YOUR PV KEY HERE'];

module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

    networks: {
        chainA: {
            network_id: "ID CHAIN A",
            gas: "GAS VALUE",
            provider: () => new HDWalletProvider(privateKeyChainA, 'URL_CHAIN_A'),
            from: 'PUBLIC ADDRESS RELATED TO PV KEY CHAIN A'
        },
        chainB: {
            network_id: "ID CHAIN B",
            gas: "GAS VALUE",
            provider: () => new HDWalletProvider(privateKeyChainB, 'URL_CHAIN_B'),
            from: 'PUBLIC ADDRESS RELATED TO PV KEY CHAIN B'
        },
    },

    // Configure your compilers
    compilers: {
        solc: {
            version: "0.8.12",    // Fetch exact version from solc-bin (default: truffle's version)
            // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
            settings: {          // See the solidity docs for advice about optimization and evmVersion
                optimizer: {
                    enabled: true,
                    runs: 1000
                },
            //  evmVersion: "byzantium"
            }
        }
    },

  plugins: [
    'truffle-contract-size'
  ]
};
