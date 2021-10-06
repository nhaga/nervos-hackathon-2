<template>
  <div class="w-full flex flex-wrap">
    <div class="w-full p-4 text-center text-gray-300 font-semibold text-3xl">
      Wallet
    </div>

    <Price class="w-1/2"></Price>
    <Collateral class="w-1/2"></Collateral>
    <Gauge class="w-full"></Gauge>
  </div>
</template>

<script>
import Collateral from '../widgets/Collateral.vue'
import Price from '../widgets/Price.vue'
import Gauge from '../widgets/Gauge.vue'

export default {
  components: { Price, Collateral, Gauge, }
}
</script>

<style>
</style>