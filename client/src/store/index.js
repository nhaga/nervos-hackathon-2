import { createStore } from 'vuex'
import { NETWORKS } from '../constants/networks'
import {AddressTranslator} from 'nervos-godwoken-integration';
import getTradeContract from '../utils/getTradeContract'

import vault from './vault'
import approvals from './approvals'
import orderbook from './orderbook'
import getWeb3 from '../utils/getWeb3.js'



const store = createStore({
  modules: [vault, approvals, orderbook],
  state () {
    return {
      web3: null,
      account: null,
      account2: null,
      networkId: null,
      network: null,
      balance: 0,
      //
      tradeContract: null,
      expiry: new Date(),
      strike: null,
      //
      price: 3102,
    }
  },
  actions: {
    updateNetwork ({ state }) {
      console.log('accountsChanges')
      const web3 = getWeb3()
      state.web3 = web3
      
      const getInfo = async () => {
        const account = window.ethereum.selectedAddress //await web3.eth.getCoinbase()
        state.account = account
        state.account2 = (new AddressTranslator()).ethAddressToGodwokenShortAddress(account);

        const networkId = await web3.eth.net.getId()
        state.networkId = networkId
        state.network = NETWORKS[networkId]
        const balance = await web3.eth.getBalance(state.account2)
        state.balance = balance / 100_000_000
        
      }
      getInfo()
    },
    async getTradeContract ({ state }) {
      const tradeContract = await getTradeContract()
      let expiry = await tradeContract.methods.expiry().call()
      state.expiry = new Date(expiry * 1000)
      state.strike = await tradeContract.methods.strike().call()
    }
  },
  mutations: {    
  },
  getters: {
    account: state => state.account,
    account2: state => state.account2,
    network: state => state.network,
    networkId: state => state.networkId,
    balance: state => state.balance,
    price: state => state.price,
    strike: state => state.strike,
    expiry: state => state.expiry,
    isOwner: state => state.account == '0x54Ee86bD6787BfB386c8Cfc7Bd29ee440382a7a6'.toLowerCase()
  }
})

export default store