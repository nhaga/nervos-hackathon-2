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
      <p class="mt-2 text-xl text-white">${{ intrinsic }}</p>
      <p class="text-xs text-gray-400">Intrinsic Value</p>
    </div>
  </div>
</template>

<script>
import { computed } from 'vue'
import { useStore } from 'vuex'

export default {
  setup () {
    const store = useStore()
    const price = computed(() => store.getters.price)
    const strike = computed(() => store.getters.strike)
    const intrinsic = computed(() => price.value - strike.value)
    return { price, intrinsic }
  }

}
</script>

