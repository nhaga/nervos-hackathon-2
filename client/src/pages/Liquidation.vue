<template>
  <div class="py-4">
    <div class="mb-2 text-center text-gray-300 font-semibold text-3xl">
      Positions in Liquidation
    </div>

    <div class="w-full flex flex-wrap  lg:p-6 ">
      <!-- Text -->
      <div class="w-full lg:w-1/2 text-white p-4 text-sm">
        <p>
          Open positions can be liquidated when the collateral health
          (Collateral Value / Positions Market Value) of the holder falls below
          150%
        </p>
        <p class="mt-4">
          Liquidated positions will be closed at Instrinsic value * 120%, where:
          <ul>
            <li>- 115% going to long position holder</li>
            <li>- 5% goes to liquidator</li>

          </ul>
        </p>

        <p class="mt-4">
          Anyone can liquidate elegible open position by paying the gas fees

        </p>
      </div>


      <!-- Table -->
      <div
        class="
          bg-white bg-opacity-5
          text-white
          rounded-3xl
          py-2
          w-full
          border border-opacity-10
        "
      >

        <table class="table-auto w-full text-center">

          <thead>
            <tr class="font-normal text-gray-300 text-opacity-60">
              <td class="hidden lg:table-cell">
                Account
                  <Tooltip>Account of the short position</Tooltip>


                </td>
              <td class="hidden lg:table-cell">Size
                  <Tooltip>Size of the position in ETH</Tooltip>


              </td>
              <td class="hidden lg:table-cell">
                Collateral
              <Tooltip>Collateral Health</Tooltip>

                </td>
              <td class="hidden lg:table-cell">
                Profit
              <Tooltip>Gain in USD for the Liquidator (minus gas)</Tooltip>

                </td>
              <td class="hidden lg:table-cell"></td>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="row in forLiquidation"
              :key="row.tradeId"
              class="
                hover:bg-black hover:bg-opacity-20
                lg:h-10
                font-light
                lg:border-t border-gray-400 border-opacity-10
                border-b-4 lg:border-b-0
                flex lg:table-row flex-row lg:flex-row flex-wrap lg:flex-no-wrap mb-10 lg:mb-0
              "
            >
              <td class="w-full lg:w-auto p-3  text-center  block lg:table-cell relative lg:static border-b border-gray-400 border-opacity-10 lg:border-0">
                <span class="lg:hidden absolute top-0 left-0 px-2 py-1 text-xs font-bold uppercase">Account</span>
                {{ row.account }}
                </td>
              <td class="w-full lg:w-auto p-3  text-center  block lg:table-cell relative lg:static border-b border-gray-400 border-opacity-10 lg:border-0">
                <span class="lg:hidden absolute top-0 left-0 px-2 py-1 text-xs font-bold uppercase">Size</span>
                {{ row.size }}
                </td>
              <td class="w-full lg:w-auto p-3  text-center  block lg:table-cell relative lg:static border-b border-gray-400 border-opacity-10 lg:border-0">
                <span class="lg:hidden absolute top-0 left-0 px-2 py-1 text-xs font-bold uppercase">Collateral</span>
                {{ row.collateral }}
                </td>
              <td class="w-full lg:w-auto p-3  text-center  block lg:table-cell relative lg:static border-b border-gray-400 border-opacity-10 lg:border-0">
                <span class="lg:hidden absolute top-0 left-0 px-2 py-1 text-xs font-bold uppercase">Profit</span>
                {{ row.profit }}
                </td>
              <td class="w-full lg:w-auto p-3  text-center  block lg:table-cell relative lg:static border-b border-gray-400 border-opacity-10 lg:border-0">
                <Button class="w-full" @click="liquidate(row.tradeId)">Liquidate</Button>
                </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
/* eslint-disable */
import Button from '../components/Button.vue'
import { useStore } from 'vuex'
import { computed } from 'vue'
import Tooltip from '../components/Tooltip.vue'

import getTradeContract from '../utils/getTradeContract'

export default {
  components: { Button, Tooltip },
  setup () {
    const store = useStore()
    const price = computed(() => store.getters.price)
    const forLiquidation = computed(() => {
      let trades = store.getters.orderbook.filter(item => item[6] == 1 && item[1] == 2)
      return trades.map(item => {
        return {
          tradeId: item[0],
          account: item[5],
          size: item[3],
          collateral: '140%',
          profit: 2.5
        }
      })
    })

    async function liquidate (tradeId) {
      const tradeContract = await getTradeContract()
      let res = await tradeContract.methods.liquidatePosition(tradeId).call()
      console.log(res)

    }

    async function getTradersForLiquidation () {
      const tradeContract = await getTradeContract()
      let res = await tradeContract.methods.getTradersForLiquidation(3000).call()
      console.log(res)
    }

    return { getTradersForLiquidation, forLiquidation, liquidate }
  }
}
</script>

<style>
</style>