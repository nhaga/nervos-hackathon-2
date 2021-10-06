<template>
  <div class="py-4">
    <div class="mb-10 text-center">
      <div class="text-gray-300 font-semibold text-3xl">
        Trade Active Call Option
      </div>
      <div class="text-gray-400">
        <span class="text-white font-bold">{{ strike }}</span> strike for
        <span class="text-white font-bold">{{
          expiry.toISOString().substring(0, 10)
        }}</span>
      </div>
    </div>

    <div class="flex flex-wrap w-full">
      <Orderbook v-model="order"></Orderbook>
      <EnterOrder :order="order"></EnterOrder>
      <Orders></Orders>
    </div>
  </div>
</template>

<script>
import Orderbook from '../widgets/Orderbook.vue'
import EnterOrder from '../components/EnterOrder.vue'
import Orders from '../widgets/Orders.vue'
import { ref, computed } from 'vue'
import { useStore } from 'vuex'


export default {
  components: { EnterOrder, Orderbook, Orders },
  setup () {
    const store = useStore()
    const strike = computed(() => store.getters.strike)
    const expiry = computed(() => store.getters.expiry)



    const order = ref({
      side: 'buy',
      type: 'market',
      price: 2,
      size: 1
    })


    return {
      order,
      strike,
      expiry
    }
  }

}
</script>
