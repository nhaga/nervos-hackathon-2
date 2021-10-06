<template>
  <div class="flex-grow p-4">
    <div class="text-gray-400 mb-2 font-semibold">Pending Orders</div>
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
      <table class="table-auto w-full text-center">
        <thead>
          <tr class="font-normal text-gray-300 text-opacity-60">
            <td>Side</td>
            <td>Price</td>
            <td>Size</td>
            <td>Amount</td>
            <td></td>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="row in openOrders"
            :key="row.tradeId"
            class="
              hover:bg-black hover:bg-opacity-20
              h-10
              font-light
              border-t border-gray-400 border-opacity-10
            "
          >
            <td>{{ row.side }}</td>
            <td>{{ row.price }}</td>
            <td>{{ row.size }}</td>
            <td>{{ row.size * row.price }}</td>
            <td class="flex gap-x-2">
              <Button @click="cancelOrder(row.orderId)">Cancel</Button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="text-gray-400 mb-2 font-semibold mt-4">Open Positions</div>
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
      <table class="table-auto w-full text-center">
        <thead>
          <tr class="font-normal text-gray-300 text-opacity-60">
            <td>Side</td>
            <td>Price</td>
            <td>Size</td>
            <td>Filled on</td>
            <td></td>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="row in filledOrders"
            :key="row.orderId"
            class="
              hover:bg-black hover:bg-opacity-20
              h-10
              font-light
              border-t border-gray-400 border-opacity-10
            "
          >
            <td>{{ row.side }}</td>
            <td>{{ row.price }}</td>
            <td>{{ row.size }}</td>
            <td class="text-xs">{{ row.timestamp }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import { computed } from 'vue'
import { useStore } from 'vuex'
import Button from '../components/Button.vue'
import Web3 from 'web3'
import getTradeContract from '../utils/getTradeContract'

export default {
  components: { Button },
  setup () {
    const store = useStore()
    const account = computed(() => store.getters.account)


    async function cancelOrder (orderId) {
      const tradeContract = await getTradeContract(store.state.web3)
      let res = await tradeContract.methods.cancelOrder(orderId).send({
        from: account.value,
        gas: 300000,
        gasPrice: Web3.utils.toWei("2", 'gwei')
      }).then(() => store.dispatch('updateVault'))
      console.log(res)

    }


    const orderbook = computed(() => store.getters.orderbook)
    const openOrders = computed(() => store.getters.openOrders)
    const filledOrders = computed(() => store.getters.filledOrders)


    return { openOrders, filledOrders, cancelOrder, orderbook }


  }

}
</script>

<style>
</style>