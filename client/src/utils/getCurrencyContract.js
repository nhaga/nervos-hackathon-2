import { address, ABI } from '../constants/currencyContract.js'
import getWeb3 from './getWeb3.js'

async function getCurrencyContract () {
  const web3 = getWeb3()
  return await new web3.eth.Contract(ABI, address)  
}

export default getCurrencyContract