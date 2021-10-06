<template>
  <div class="w-96 flex flex-col p-4 gap-y-2">
    <Price></Price>
    <Collateral></Collateral>
    <Gauge></Gauge>
  </div>
</template>

<script>
import Collateral from '../widgets/Collateral.vue'
import Price from '../widgets/Price.vue'
import Gauge from '../widgets/Gauge.vue'

export default {
  components: { Price, Collateral, Gauge }
}
</script>
