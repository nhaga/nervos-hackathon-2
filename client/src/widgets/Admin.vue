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
      <p class="text-xl text-white">Admin Section</p>
      <Button>Settle All Trades</Button>
    </div>
  </div>
</template>

<script>
import { ref, computed } from 'vue'
import Button from '../components/Button.vue'

export default {
  components: { Button },
  setup () {
    const expiries = [
      { expiry: '2021-06-30', active: false, strikes: [2800] },
      { expiry: '2021-07-31', active: false, strikes: [2900, 3100] },
      { expiry: '2021-08-31', active: false, strikes: [3000, 3100] },
      { expiry: '2021-09-30', active: true, strikes: [2900, 3000, 3100,] }
    ]

    const strikes = computed(() => {
      let data = expiries.find(item => item.expiry == selectedExpiry.value)
      return (data) ? data.strikes : [1, 2, 3]
    })



    const selectedExpiry = ref(null)

    return { expiries, selectedExpiry, strikes }
  }

}
</script>

<style scoped>
input:checked + svg {
  display: block;
}
</style>