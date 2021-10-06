import { address, ABI } from '../constants/tradeContract.js'
import getWeb3 from './getWeb3.js'

async function getTradeContract () {
  const web3 = await getWeb3()
  return await new web3.eth.Contract(ABI, address)  
}

export default getTradeContract