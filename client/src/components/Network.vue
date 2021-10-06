<template>
  <div class="flex flex-shrink-0 items-center space-x-4 text-white">
    <div class="flex flex-col items-end">
      <div class="text-md font-medium">{{ network }}</div>
      <div class="text-sm font-regular truncate w-52 text-gray-300">
        <span class="font-semibold">ETH</span> {{ account }}
      </div>
      <div class="text-sm font-regular truncate w-52 text-gray-300">
        <span class="font-semibold">Poly</span> {{ account2 }}
      </div>
      <div class="text-sm font-regular truncate w-52 text-gray-300">
        <span class="font-semibold">Balance</span>
        {{ balance }}
      </div>
    </div>
  </div>
</template>

<script>
import { computed, onMounted } from 'vue'
import { useStore } from 'vuex'

export default {
  setup () {
    const store = useStore()

    /*
    window.ethereum.on('accountsChanged', () => {
      store.dispatch('updateNetwork')
      store.dispatch('updateVault')
      store.dispatch('updateApprovals')
    })

    window.ethereum.on('chainChanged', () => {
      store.dispatch('updateNetwork')
      store.dispatch('updateVault')
      store.dispatch('updateApprovals')
    })
    */

    const account = computed(() => store.getters.account)
    const account2 = computed(() => store.getters.account2)
    const balance = computed(() => store.getters.balance)
    const network = computed(() => store.getters.network)
    const networkId = computed(() => store.getters.networkId)

    onMounted(store.dispatch('updateNetwork'))




    return { account, account2, network, networkId, balance }




  }
}
</script>
