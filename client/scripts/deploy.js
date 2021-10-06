const { existsSync } = require('fs');
const Web3 = require('web3');
const { PolyjuiceHttpProvider, PolyjuiceAccounts } = require("@polyjuice-provider/web3");

const contractName = '../../build/contracts/Asset.json'
let compiledContractArtifact = require(contractName);

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

(async () => {
    const balance = BigInt(await web3.eth.getBalance(deployerAccount.address));

    if (balance === 0n) {
        console.log(`Insufficient balance. Can't deploy contract. Please deposit funds to your Ethereum address: ${deployerAccount.address}`);
        return;
    }

    console.log(`Deploying contract...`);

    const deployTx = new web3.eth.Contract(compiledContractArtifact.abi).deploy({
        data: getBytecodeFromArtifact(compiledContractArtifact),
        arguments: ["0x84c57202bCe3c784A1723F680dD38Cf6a2292d92", "0x84c57202bCe3c784A1723F680dD38Cf6a2292d92"]
    }).send({
        from: deployerAccount.address,
        gas: 6000000,
    });

    deployTx.on('transactionHash', hash => console.log(`Transaction hash: ${hash}`));

    const contract = await deployTx;

    console.log(`Deployed Asset contract address: ${contract.options.address}`);

    tx = await contract.methods.addOption(2021, 12, 15, 3100).send({
            from: deployerAccount.address,
            gas: 6000000,
        })

    optionContract = await contract.methods.activeOptionAddress().call()
    console.log(`Deployed Options contract address: ${optionContract}`)



})();

function getBytecodeFromArtifact(contractArtifact) {
    return contractArtifact.bytecode || contractArtifact.data?.bytecode?.object
}