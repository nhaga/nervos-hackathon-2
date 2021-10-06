const { existsSync } = require('fs');
const Web3 = require('web3');
const { PolyjuiceHttpProvider, PolyjuiceAccounts } = require("@polyjuice-provider/web3");


const currencyFilename = '../build/contracts/Token.json'
compiledCurrencyContractArtifact = require(currencyFilename);

const DEPLOYER_PRIVATE_KEY = '31e06251ba2c749b42dcc12e05cc71c490ec9b3ca503192fc7189180e14fc11b'; // Replace this with your Ethereum private key with funds on Layer 2.

const polyjuiceConfig = {
    web3Url: 'https://godwoken-testnet-web3-rpc.ckbapp.dev'
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

    const deployTx = new web3.eth.Contract(compiledCurrencyContractArtifact.abi).deploy({
        data: getBytecodeFromArtifact(compiledCurrencyContractArtifact),
        arguments: ["DAI", "DAI", Web3.utils.toWei('50000', 'ether')]
    }).send({
        from: deployerAccount.address,
        gas: 6_000_000,
    });

    deployTx.on('transactionHash', hash => console.log(`Transaction hash: ${hash}`));

    const contract = await deployTx;

    console.log(`Deployed contract address: ${contract.options.address}`);
    
})();

function getBytecodeFromArtifact(contractArtifact) {
    return contractArtifact.bytecode || contractArtifact.data?.bytecode?.object
}