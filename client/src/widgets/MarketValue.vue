<template>
  <div
    class="
      bg-black bg-opacity-20
      rounded-3xl
      flex
      py-4
      border-t border-gray-400 border-opacity-10
    "
  >
    <div class="p-4 mx-auto">
      <p class="text-xl text-white">${{ price.toLocaleString() }}</p>
      <p class="text-xs text-gray-400">ETH/USD</p>
      <p>{{ mtm }}</p>
      <p>{{ bestBid }} {{ bestAsk }}</p>
    </div>
  </div>
</template>

<script>
/* eslint-disable */
import { computed } from 'vue'
import { useStore } from 'vuex'

export default {
  setup () {
    const store = useStore()
    const price = computed(() => store.getters.price)
    const filledOrders = computed(() => store.getters.filledOrders)
    const strike = computed(() => store.getters.strike)
    const bestBid = computed(() => store.getters.bestBid)
    const bestAsk = computed(() => store.getters.bestAsk)
    const mtm = computed(() => {
      let position = filledOrders.value.map(item => {
        let side = (item.side = "Buy") ? 1 : -1
        return item.size * side
      }).reduce((a, b) => a + b, 0)
      return position
    })
    return { price, mtm, bestBid, bestAsk }
  }

}
</script>

