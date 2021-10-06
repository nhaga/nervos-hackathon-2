import { address, ABI } from '../constants/assetContract.js'

async function getAssetContract (web3) {
  return await new web3.eth.Contract(ABI, address)  
}

export default getAssetContract