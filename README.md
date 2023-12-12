# evm_based_bc_interoperability_semantics

This project contains "demonstration" smart contracts for defining semantics in interoperability between blockchains based on Ethereum Virtual Machine (EVM).

Smart contracts include use cases:
- Token Transfer
- Data synchronization
- Cross-chain execution of smart contracts

## Configure truffle.js
In order to correctly deploy smart contracts, the ```truffle.js``` file must be configured by specifying the private keys of the accounts responsible for the deployments in the different chains. (```privateKeyChainA, privateKeyChainB```). Once this is done, you must specify the blockchains on which you want to deploy. In particular, for each blockcahin it is necessary to indicate the chain ID, the gas to be used, the connection URL and the address (it must relate to the private keys specified above).
