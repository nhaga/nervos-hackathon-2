const { existsSync } = require('fs');

const Web3 = require('web3');

const { PolyjuiceHttpProvider, PolyjuiceAccounts } = require("@polyjuice-provider/web3");

const CONTRACT = "0x3F79EB0DF648E822E50388bf546F611032f17339"


const DEPLOYER_PRIVATE_KEY = '31e06251ba2c749b42dcc12e05cc71c490ec9b3ca503192fc7189180e14fc11b'; // Replace this with your Ethereum private key with funds on Layer 2.

const polyjuiceConfig = {
    web3Url: 'https://godwoken-testnet-web3-rpc.ckbapp.dev'
    //web3Url: 'http://localhost:8024'
};

const provider = new PolyjuiceHttpProvider(
    polyjuiceConfig.web3Url,
    polyjuiceConfig,
);
const web3 = new Web3(provider);

web3.eth.accounts = new PolyjuiceAccounts(polyjuiceConfig);
const deployerAccount = web3.eth.accounts.wallet.add(DEPLOYER_PRIVATE_KEY);
web3.eth.Contract.setProvider(provider, web3.eth.accounts);





const contractName = '../../build/contracts/Asset.json'

let compiledContractArtifact = require(contractName);

function getBytecodeFromArtifact(contractArtifact) {
    return contractArtifact.bytecode || contractArtifact.data?.bytecode?.object
}

const ABI = compiledContractArtifact.abi

contract = new web3.eth.Contract(ABI, CONTRACT);

(async () => {
  tx = await contract.methods.addOption(2021, 12, 15, 3100).send({
        from: deployerAccount.address,
        gas: 6000000,
    })

  optionContract = await contract.methods.activeOptionAddress().call()
  console.log(optionContract)

})();

