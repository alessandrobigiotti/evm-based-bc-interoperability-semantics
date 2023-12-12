const path = require('path');
const fs = require('fs');

const Initiator = artifacts.require("Initiator");
const Finalizer = artifacts.require("Finalizer");
const DataStorage = artifacts.require("DataStorage");
const SimpleToken = artifacts.require("SimpleERC20Token");
const SimpleERC721 = artifacts.require("SimpleERC721Token");
const SamplesStorage = artifacts.require("SamplesStorage");
const SamplesCalculateAverage = artifacts.require("SamplesCalculateAverage");


module.exports = async function (deployer, network) {
    console.log("Initializing smart contracts...");

    let contractAddresses = getContractAddresses(network);

    console.log(contractAddresses);

    for (key in contractAddresses) {
        if (key == 'Initiator'){
            let InitiatorInstance = await Initiator.at(contractAddresses[key]);
            await InitiatorInstance.addService(contractAddresses["DataStorage"], "SYNC_DATA");
            await InitiatorInstance.addService(contractAddresses["SimpleERC20Token"], "ERC20_TRANSFER");
            await InitiatorInstance.addService(contractAddresses["SimpleERC721Token"], "ERC721_TRANSFER");
            await InitiatorInstance.addService(contractAddresses["SamplesStorage"], "CCSCEStorage");
            await InitiatorInstance.addService(contractAddresses["SamplesCalculateAverage"], "CCSCEAggregate");

        }
        else if (key == 'Finalizer') {
            let FinalizerInstance = await Finalizer.at(contractAddresses[key]);
            await FinalizerInstance.addService(contractAddresses["DataStorage"], "SYNC_DATA");
            await FinalizerInstance.addService(contractAddresses["SimpleERC20Token"], "ERC20_TRANSFER");
            await FinalizerInstance.addService(contractAddresses["SimpleERC721Token"], "ERC721_TRANSFER");
            await FinalizerInstance.addService(contractAddresses["SamplesStorage"], "CCSCEStorage");
            await FinalizerInstance.addService(contractAddresses["SamplesCalculateAverage"], "CCSCEAggregate");
        }
    }
}

function getContractAddresses(network) {
  let folderPath = path.resolve(__dirname, '..', 'contractAddresses', network);

  try {

    let addresses = fs.readFileSync(folderPath+'/addresses.json');
    let addressesJson = JSON.parse(addresses);

    return addressesJson;
  }
  catch(err) {
    console.log(err);
  }
}
