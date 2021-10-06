<template>
  <div class="flex flex-col flex-grow mx-4 w-1/3 pt-4">
    <div class="text-gray-400 mb-2 font-semibold">Enter Order</div>
    <div
      class="
        flex flex-col
        bg-red-400 bg-opacity-20
        rounded-xl
        py-4
        text-white
        border border-opacity-10
      "
      :class="{ 'bg-green-500': side == 'buy' }"
    >
      <div class="flex flex-col w-full px-4 mb-4">
        <div class="flex flex-row">
          <button
            class="rounded-md w-1/2 bg-opacity-50"
            :class="{
              'border-red-100 border border-opacity-50': side == 'sell',
            }"
            @click="side = 'sell'"
          >
            SELL
          </button>

          <button
            class="rounded-md w-1/2 bg-opacity-50"
            :class="{
              'border-green-100 border  border-opacity-50': side == 'buy',
            }"
            @click="side = 'buy'"
          >
            BUY
          </button>
        </div>
      </div>

      <div v-if="type == 'limit'" class="flex flex-row w-full px-4">
        <div class="text-gray-400 text-sm mb-1 w-1/2">Price</div>
        <div class="w-20 h-10">
          <div class="relative flex flex-row w-full h-8">
            <input
              v-model="price"
              type="number"
              step="0.1"
              min="0.1"
              class="
                w-full
                font-semibold
                text-center text-gray-300
                bg-gray-200 bg-opacity-10
                rounded-md
                outline-none
                focus:outline-none
                hover:text-white
                focus:text-white
              "
            />
          </div>
        </div>
      </div>

      <div class="flex flex-row w-full px-4">
        <div class="w-1/2 text-gray-400 text-sm mb-1">Size</div>
        <div class="w-20 h-10">
          <div class="relative flex flex-row w-full h-8">
            <input
              type="number"
              v-model="size"
              step="1"
              min="1"
              class="
                w-full
                font-semibold
                text-center text-gray-200
                bg-gray-200 bg-opacity-10
                rounded-md
                outline-none
                focus:outline-none
                hover:text-white
                focus:text-white
              "
            />
          </div>
        </div>
      </div>

      <template v-if="canEnter">
        <div class="flex flex-col w-full p-4">
          <div
            class="
              flex flex-col
              rounded-mdw-full
              bg-white bg-opacity-25
              rounded-md
              p-4
              text-sm
            "
          >
            <div v-if="side == 'buy'">
              You get {{ size }} oLTokens<br />
              You pay {{ totalCost.toLocaleString() }} USDC<br />
            </div>
            <div v-else>
              You get {{ size }} oSToken<br />
              You Receive {{ totalCost.toLocaleString() }} USDC<br />
            </div>
          </div>
        </div>
        <div class="p-4 w-full">
          <Button class="w-full" @click="enterOrder">Insert Order</Button>
        </div>
      </template>
      <div class="flex flex-col w-full p-4" v-else>
        <div
          class="
            flex flex-col
            rounded-mdw-full
            bg-red-400 bg-opacity-25
            rounded-md
            p-4
          "
        >
          <div v-if="side == 'buy'">
            Not enough balance to place this bid order
          </div>
          <div v-else>
            <p>Not enough balance to transfer 150% of ask value to vault</p>

            <p class="text-xs text-gray-300">
              (The premium received will stay in vault to make the collateral
              150% of market price...)
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
/* eslint-disable */

import Button from './Button.vue'
import { ref, watch, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import getTradeContract from '../utils/getTradeContract'
import Web3 from 'web3'
import { createToast } from 'mosha-vue-toastify'
import 'mosha-vue-toastify/dist/style.css'


export default {
  props: ['order'],
  components: { Button },
  setup (props) {
    const store = useStore()
    const account = computed(() => store.getters.account)
    const walletBalance = computed(() => store.getters.walletBalance)


    const price = ref(2)
    const type = ref('limit')
    const size = ref(1)
    const side = ref('buy')
    const totalCost = computed(() => price.value * size.value)

    const canEnter = computed(() => {
      if (side.value == 'buy' & totalCost.value <= walletBalance.value) {
        return true
      } else if (side.value == 'sell' & totalCost.value * 1.5 <= walletBalance.value) {
        return true
      } else {
        return false
      }

    })



    watch(props.order, (val) => {
      price.value = val.price
      size.value = val.size
      side.value = val.side
    })

    async function enterOrder () {
      let orderSide = (side.value == 'sell') ? 2 : 1
      let orderPrice = Web3.utils.toWei(price.value.toString())
      console.log(orderPrice)
      const tradeContract = await getTradeContract()
      let res = await tradeContract.methods.enterOrder(orderSide, orderPrice, size.value).send({
        from: account.value,
        gas: 3000000,
        gasPrice: Web3.utils.toWei("2", 'gwei')
      }).then(() => store.dispatch('updateVault'))
    }

    return {
      orderTypeMarket: ref(true),
      side,
      type,
      price,
      size,
      totalCost,
      canEnter,
      enterOrder
    }

  }
}
</script>
