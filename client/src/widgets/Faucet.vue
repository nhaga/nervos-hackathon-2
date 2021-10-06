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
      <p class="text-xl text-white">Fake DAI Faucet to use Dapp</p>
      <Button @click="fundAccount">Fund Account with 100</Button>
    </div>
  </div>
</template>

<script>
import getCurrencyContract from '../utils/getCurrencyContract'
import Button from '../components/Button.vue'
import { useStore } from 'vuex'
import DEFAULT_SEND_OPTIONS from '../constants/configs'



export default {
  components: { Button },
  setup () {
    const store = useStore()

    async function fundAccount () {
      const currencyContract = await getCurrencyContract()
      const account = window.ethereum.selectedAddress

      currencyContract.methods.claimTestToken(account)
        .send({
          ...DEFAULT_SEND_OPTIONS,
          from: account,
        }).then((res) => {
          console.log(res)
          store.dispatch('updateVault')
        })
    }

    return { fundAccount }

  }

}
</script>

<style>
</style>