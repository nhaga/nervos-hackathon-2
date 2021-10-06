import Web3 from 'web3'
import getCurrencyContract from '../utils/getCurrencyContract'
import getTradeContract from '../utils/getTradeContract'
import DEFAULT_SEND_OPTIONS from '../constants/configs'


export default {
  state: () => ({
    currencyAllowance: 0,
    tokenAllowance: 0
  }),
  actions: {
    async updateApprovals ({ state }) {
      const currencyContract = await getCurrencyContract()
      const account = window.ethereum.selectedAddress
      const collateralContract = await getTradeContract()
      const res = await currencyContract.methods.allowance(account, collateralContract.options.address).call({
        from: window.ethereum.selectedAddress
      })
      console.log(res)
      state.currencyAllowance = Web3.utils.fromWei(res, 'ether')
    },
    async approveCurrency ({ dispatch }) {
      const currencyContract = await getCurrencyContract()
      const contract = await getTradeContract()
      await currencyContract.methods.approve(
        contract.options.address,
        Web3.utils.toWei('1000000', "ether")
      ).send({
        ...DEFAULT_SEND_OPTIONS,
        from: window.ethereum.selectedAddress
      }).then((res) => {
        console.log(res)
        dispatch('updateApprovals')
      })
    }
  },
  getters: {
    currencyAllowance: state => state.currencyAllowance
  }
}