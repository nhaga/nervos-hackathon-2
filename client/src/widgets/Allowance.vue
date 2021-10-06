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
      <p class="text-3xl text-white">{{ currencyAllowance }}</p>
      <Button @click="getAllowance">Update</Button>
    </div>
  </div>
</template>

<script>
import { ref, computed } from 'vue'
import { useStore } from 'vuex'
//import Web3 from 'web3'
import Button from '../components/Button.vue'
import getCurrencyContract from '../utils/getCurrencyContract'
import { address } from '../constants/collateralContract.js'



export default {
  components: { Button },
  setup () {
    const store = useStore()

    const allowance = ref(0)
    const currencyAllowance = computed(() => store.getters.currencyAllowance)

    async function getAllowance () {
      store.dispatch('approveCurrency')
      const web3 = store.state.web3
      const currencyContract = await getCurrencyContract(web3)
      const res = await currencyContract.methods.allowance(store.state.account, address).call()
      allowance.value = web3.utils.fromWei(res, 'ether')



    }

    return { getAllowance, allowance, currencyAllowance }

  }
}
</script>
