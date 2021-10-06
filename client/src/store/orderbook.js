/* eslint-disable */
import Web3 from 'web3'

class Order {
  constructor (orderId, side, price, size, timestamp, trader, state) {
    this.orderId = orderId
    this.side = (side == 1) ? "Buy" : "Sell"
    this.price = Web3.utils.fromWei(price)
    this.size = size
    this.timestamp = new Date(timestamp * 1000).toISOString().substring(0, 10)
    this.trader = trader
    this.state = state
  }
}


export default {
  state: () => ({
    orderbook: [],
  }),
  mutations: {
    updateOrderbook (state, data) {
      state.orderbook = data
    }
  },
  getters: {
    orderbook: state => state.orderbook,
    allOpenOrders: (state, getters ) => getters.orderbook.filter(row => row.state == 0).map(row => new Order(...row)),
    ownOrders: (state, rootGetters) => state.orderbook.filter(row => row[5].toLowerCase() == rootGetters.account),
    openOrders: (state, getters ) => getters.ownOrders.filter(row => row.state == 0).map(row => new Order(...row)),
    filledOrders: (state, getters) => getters.ownOrders.filter(row => row.state == 1).map(row => new Order(...row)),
    bestBid: (state, getters) => Math.max(...getters.allOpenOrders.filter(row => row.side == 'Buy').map(item => parseFloat(item.price))),
    bestAsk: (state, getters) => Math.min(...getters.allOpenOrders.filter(row => row.side == 'Sell').map(item => parseFloat(item.price))),
    position: (state, getters) => getters.filledOrders.map(row => (row.side == 'Buy') ? row.size : -row.size).reduce((a, b) => a + b, 0),
    mtm: (state, getters) => -Math.max(getters.price - getters.strike, 0) * getters.position,
    
    
  }
}
