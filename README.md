# Interoperability Between EVM-based Blockchains

This project contains "demonstration" smart contracts for defining semantics in interoperability between blockchains based on Ethereum Virtual Machine (EVM). The source code refers to the publication [Interoperability Between EVM-based Blockchains](https://link.springer.com/chapter/10.1007/978-3-031-57853-3_9)

Smart contracts include use cases:
- Token Transfer (ERC20 and ERC721)
- Data synchronization
- Cross-chain execution of smart contracts

## Configure truffle.js
In order to correctly deploy smart contracts, the ```truffle.js``` file must be configured by specifying the private keys of the accounts responsible for the deployments in the different chains. (```privateKeyChainA, privateKeyChainB```). Once this is done, you must specify the blockchains on which you want to deploy. In particular, for each blockcahin it is necessary to indicate the chain ID, the gas to be used, the connection URL and the address (it must relate to the private keys specified above).

### Install node modules
After the configuration is done, it is necessary to install all node modules and dependencies. To do so type from the main directory:
```
$ npm install
```
If the installation ends correctly, it is possible to deploy all smart contracts under the contract folder by executing the ```compileDeployContracts.sh``` under the scripts folder.

**NOTICE:** If you want to deploy and tests the smart contracts on [Remix](https://remix.ethereum.org) it is necessary to update the Openzeppelin dependencies. To do so you have to modify the Initiator, Finalizer, SimpleERC20Token and SimpleERC721Token smart contracts as follows:
- Initiator and Finalizer: replace the {Strings} import with:
  - ```import {Strings} from "@openzeppelin/contracts@4.9.3/utils/Strings.sol";```
- SimpleERC20Token: replace the ERC20 import with:
  - ```import "@openzeppelin/contracts@4.9.3/token/ERC20/ERC20.sol";```
- SimpleERC721Token: replace the ERC721 import with:
  - ```import "@openzeppelin/contracts@4.9.3/token/ERC721/ERC721.sol";```
  - ```import "@openzeppelin/contracts@4.9.3/token/ERC721/extensions/ERC721Burnable.sol";```

## Reference

The content can be used to conduct research or provide further testing and use cases. Please be careful to cite the source from which this work comes:

Plain:

A. Bigiotti, L. Mostarda, A. Navarra, A. Pinna, R. Tonelli, and M. Vaccargiu, *“Interoperability between evm-based blockchains”*, in Advanced Information Networking and Applications, L. Barolli, Ed. Cham: Springer Nature Switzerland, 2024, pp. 98–109.

Bibtex:

```
@InProceedings{10.1007/978-3-031-57853-3_9,
    author={Bigiotti, Alessandro and Mostarda, Leonardo and Navarra, Alfredo and
       Pinna, Andrea and Tonelli, Roberto and Vaccargiu, Matteo},
    editor={Barolli, Leonard},
    title={Interoperability Between EVM-Based Blockchains},
    booktitle={Advanced Information Networking and Applications},
    year={2024},
    publisher={Springer Nature Switzerland},
    address={Cham},
    pages={98--109},
    isbn={978-3-031-57853-3}
}
```
## Disclaimer
THIS SOFTWARE IS PROVIDED AS IS WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
