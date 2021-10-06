<template>
  <div class="flex flex-grow flex-col px-4 pt-4">
    <div class="text-gray-400 mb-2 font-semibold">
      Market Depth
      <RefreshButton class="ml-2 w-3 text-gray-400" @click="getBook"
        >Get</RefreshButton
      >
    </div>
    <div
      class="
        flex flex-col
        bg-white bg-opacity-10
        rounded-xl
        py-4
        text-white
        border border-opacity-10
      "
    >
      <div class="flex flex-row">
        <div class="w-32 text-gray-400 text-xs text-right">IV</div>
        <div class="w-14 text-gray-400 text-xs text-right">bid size</div>
        <div class="w-14 text-center">BID</div>
        <div class="w-14 text-center">ASK</div>
        <div class="w-14 text-gray-400 text-xs">ask size</div>
        <div class="flex-grow text-gray-400 text-xs">IV</div>
      </div>
      <div
        v-for="(row, idx) in book"
        :key="idx"
        class="
          flex
          cursor-pointer
          hover:bg-white hover:bg-opacity-10
          border-t border-gray-400 border-opacity-10
        "
      >
        <div
          class="w-32 text-gray-500 flex flex-row items-end justify-end px-2"
        >
          {{ row.bidIV }}
        </div>
        <div
          class="w-14 text-gray-300 flex flex-row items-end justify-end px-2"
          @click="
            value.price = row.bid;
            value.side = 'sell';
          "
        >
          {{ row.bidSize }}
        </div>
        <div
          class="
            w-14
            text-center text-xl
            font-bold
            flex flex-row
            items-end
            justify-center
          "
          @click="
            value.price = row.bid;
            value.side = 'sell';
          "
        >
          {{ row.bid }}
        </div>
        <div
          class="
            w-14
            text-center text-xl
            font-bold
            flex flex-row
            items-end
            justify-center
          "
          @click="
            value.price = row.ask;
            value.side = 'buy';
          "
        >
          {{ row.ask }}
        </div>
        <div
          class="
            w-14
            text-left text-gray-300
            flex flex-row
            items-end
            justify-start
            px-2
          "
          @click="
            value.price = row.ask;
            value.side = 'buy';
          "
        >
          {{ row.askSize }}
        </div>
        <div
          class="
            flex-grow
            text-gray-500
            flex flex-row
            items-end
            justify-start
            px-2
          "
        >
          {{ row.askIV }}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import getTradeContract from '../utils/getTradeContract'
import { bsIV } from '../utils/blackScholes'
import RefreshButton from '../components/RefreshButton.vue'


export default {
  props: ['modelValue'],
  emits: ['update:modelValue'],
  components: { RefreshButton },
  setup (props, { emit }) {
    const value = computed({
      get () {
        return props.modelValue
      },
      set (value) {
        emit('update:modelValue', value)
      }
    })

    const store = useStore()
    const price = computed(() => store.getters.price)
    const strike = computed(() => store.getters.price)
    const expiry = computed(() => store.getters.expiry)

    const orderBook = computed(() => store.getters.allOpenOrders)
    const expiryDate = ref(null)
    const T = computed(() => (expiry.value - new Date()) / (1000 * 3600 * 24) / 365)


    onMounted(async () => {
      getBook()
      const tradeContract = await getTradeContract()
      tradeContract.events.Orderbook({})
        .on('data', async function (event) {
          store.commit('updateOrderbook', event.returnValues[0])
        })
        .on('error', console.error)
    })


    async function getBook () {
      const tradeContract = await getTradeContract()
      let res = await tradeContract.methods.getOrderbook().call()
      if (res) {
        store.commit('updateOrderbook', res)
      }
    }




    const book = computed(() => {
      let bids = orderBook.value.filter(item => item.side == "Buy").sort((a, b) => b.price - a.price)
      let asks = orderBook.value.filter(item => item.side == "Sell").sort((a, b) => a.price - b.price)
      let bidPrices = [...new Set(bids.map(item => item.price))]
      let askPrices = [...new Set(asks.map(item => item.price))]


      const rows = []
      for (let i = 0; i < Math.max(bidPrices.length, askPrices.length); i++) {
        let bid = (bids.length - 1 >= i) ? bidPrices[i] : 0
        let ask = (asks.length - 1 >= i) ? askPrices[i] : 0
        let row = {
          bidIV: (bid) ? (bsIV(price.value, strike.value, 0, T.value, bid) * 100).toLocaleString() : 0,
          bidSize: (bid) ? bids.filter(item => item.price == bid).reduce((a, b) => a + parseInt(b.size), 0) : 0,
          bid,
          ask,
          askSize: (ask) ? asks.filter(item => item.price == ask).reduce((a, b) => a + parseInt(b.size), 0) : 0,
          askIV: (ask) ? (bsIV(price.value, strike.value, 0, T.value, ask) * 100).toLocaleString() : 0.0,
        }
        rows.push(row)
      }
      return rows

    })

    return { book, price, expiryDate, getBook, T, value, orderBook }
  }
}
</script>
