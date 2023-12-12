const path = require('path');
const fs = require('fs');

const Initiator = artifacts.require("Initiator");
const Finalizer = artifacts.require("Finalizer");
const DataStorage = artifacts.require("DataStorage");
const SimpleERC20Token = artifacts.require("SimpleERC20Token");
const SimpleERC721Token = artifacts.require("SimpleERC721Token");
const SamplesStorage = artifacts.require("SamplesStorage");
const SamplesCalculateAverage = artifacts.require("SamplesCalculateAverage");

module.exports = async function (deployer, network) {
  console.log('Make deploy on Network: ', network);

  let deployTime = Date.now();
  console.log("Start time: ", deployTime);

  await deployer.deploy(Initiator, deployer.options.from);
  await deployer.deploy(Finalizer, deployer.options.from);
  await deployer.deploy(DataStorage);
  await deployer.deploy(SimpleERC20Token);
  await deployer.deploy(SimpleERC721Token);
  await deployer.deploy(SamplesStorage);
  await deployer.deploy(SamplesCalculateAverage);

  initiatorAddress = Initiator.address;
  finalizerAddress = Finalizer.address;
  dataStorageAddress = DataStorage.address;
  simpleERC20Token = SimpleERC20Token.address;
  simpleERC721Token = SimpleERC721Token.address;
  samplesStorageAddress = SamplesStorage.address;
  samplesCalculateAverageAddress = SamplesCalculateAverage.address;

  console.log('Total deploy time:');
  console.log(Date.now() - deployTime);

  writeFile(network, initiatorAddress, finalizerAddress, dataStorageAddress, simpleERC20Token, simpleERC721Token, samplesStorageAddress, samplesCalculateAverageAddress);
}

function writeFile(network, initiatorAddress, finalizerAddress, dataStorageAddress, simpleERC20Token, simpleERC721Token, samplesStorageAddress, samplesCalculateAverageAddress) {
  let folderPath = path.resolve(__dirname, '..', 'contractAddresses', network);
  let content = {};

  try {
    if(!fs.existsSync(folderPath)){
      fs.mkdirSync(folderPath, {recursive:true});
    }
    if(!fs.existsSync(folderPath+'/addresses.json')) {
        fs.openSync(folderPath+'/addresses.json', 'w');
    }
    content["Initiator"] = initiatorAddress;
    content["Finalizer"] = finalizerAddress;
    content["DataStorage"] = dataStorageAddress;
    content["SimpleERC20Token"] = simpleERC20Token;
    content["SimpleERC721Token"] = simpleERC721Token;
    content["SamplesStorage"] = samplesStorageAddress;
    content["SamplesCalculateAverage"] = samplesCalculateAverageAddress;
    fs.writeFileSync(folderPath+'/addresses.json', JSON.stringify(content));
  }

  catch (err) {
    console.log(err);
  }
}
