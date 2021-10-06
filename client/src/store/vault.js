import Web3 from 'web3'
import getCurrencyContract from '../utils/getCurrencyContract'
import getCollateralContract from '../utils/getTradeContract'

export default {
  state: () => ({
    walletBalance: 0,
    vaultBalance: 0,
    escrowBalance: 0,
  }),
  actions: {
    async updateVault ({ state }) {
      const currencyContract = await getCurrencyContract()
      const account = window.ethereum.selectedAddress

      const walletBalance = await currencyContract.methods.balanceOf(account).call()
      state.walletBalance = Web3.utils.fromWei(walletBalance.toString(), "ether")

      const collateralContract = await getCollateralContract()
      const vaultBalance = await collateralContract.methods.currencyBalanceOf(account).call()
      state.vaultBalance = Web3.utils.fromWei(vaultBalance.toString(), "ether")      


      const escrowBalance = await collateralContract.methods.escrowBalanceOf(account).call()
      state.escrowBalance = Web3.utils.fromWei(escrowBalance.toString(), "ether")      
    }
  },
  getters: {
    walletBalance: state => state.walletBalance,
    vaultBalance: state => state.vaultBalance,
    escrowBalance: state => state.escrowBalance,
    health: (state, getters) => getters.vaultBalance / getters.mtm * 100
  }
}