<template>
  <div class="p-4">
    <Button @click="get">Get</Button>
  </div>
</template>

<script>
import Button from '../components/Button'
import getCurrencyContract from '../utils/getCurrencyContract'

export default {
  components: { Button },
  setup () {

    async function get () {
      const currencyContract = await getCurrencyContract()
      const account = window.ethereum.selectedAddress
      currencyContract.methods.claimTestToken(account).send({ from: account, gas: 6000000 })
        .then((res) => console.log(res))
      /* eslint-disable */
      const walletBalance = await currencyContract.methods.balanceOf(account).call()


      console.log(currencyContract)

    }

    return { get }

  }

}
</script>

<style>
</style>