import Web3 from 'web3'
import { PolyjuiceHttpProvider } from '@polyjuice-provider/web3';


const WEB3_PROVIDER_URL = 'https://godwoken-testnet-web3-rpc.ckbapp.dev';


export default function getWeb3 () {
	const provider = new PolyjuiceHttpProvider(WEB3_PROVIDER_URL, {web3Url: WEB3_PROVIDER_URL});
	const web3 = new Web3(provider || Web3.givenProvider);
	window.ethereum.enable()
  return web3
}

