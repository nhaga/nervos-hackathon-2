<template>
  <div
    class="
      m-4
      flex flex-col
      bg-white bg-opacity-10
      rounded-xl
      p-4
      text-white
      border border-opacity-10
    "
  >
    <div>Price: {{ price }}</div>
    <div>Option: {{ option }}</div>
    <div>IV: {{ iv }}</div>
  </div>
</template>

<script>
import { computed } from 'vue'
import { useStore } from 'vuex'
/* eslint-disable */
import { bsCall, bsIV } from '../utils/blackScholes'


export default {
  setup () {
    const store = useStore()
    const price = computed(() => store.getters.price)
    const option = computed(() => bsCall(price.value, 3500, 0, 0.25, 1))
    const iv = computed(() => bsIV(price.value, 3500, 0, 1, option.value))


    return { price, option, iv }
  }

}
</script>

<style>
</style>