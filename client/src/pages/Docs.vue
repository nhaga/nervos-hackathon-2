<template>
  <section class="text-white">
    <div class="container items-center px-2 py-2 mx-auto lg:px-24">
      <div class="flex flex-wrap">
        <div class="p-1 xl:w-1/3">
          <div class="flex flex-col h-full p-4">
            <div class="flex items-center mb-3">
              <h1
                class="
                  text-xl
                  font-semibold
                  leading-none
                  tracking-tighter
                  text-white
                  title-font
                "
              >
                NervOpt
              </h1>
            </div>
            <div class="flex-grow">
              <p class="leading-relaxed text-blueGray-700 ext-base">
                Nervopt Contract has one active call option on Ether at each
                moment, with fixed expiries on the 15th of March, June,
                September and December. Each strike will be set as the spot
                price 115% on the expiry of the previous option.
              </p>
            </div>
          </div>
        </div>

        <div class="p-1 xl:w-1/3">
          <div class="flex flex-col h-full p-4">
            <div class="flex items-center mb-3">
              <h1
                class="
                  text-xl
                  font-semibold
                  leading-none
                  tracking-tighter
                  text-White
                  title-font
                "
              >
                What Is a Call Option?
              </h1>
            </div>
            <div class="flex-grow">
              <p class="leading-relaxed text-blueGray-700 ext-base">
                Call options are financial contracts that give the option buyer
                the right, but not the obligation, to buy an asset at a
                specified price within a specific time period. A call buyer
                profits when the underlying asset increases in price.
              </p>
            </div>
          </div>
        </div>
        <div class="p-1 xl:w-1/3">
          <div class="flex flex-col h-full p-4">
            <div class="flex items-center mb-3">
              <h1
                class="
                  text-xl
                  font-semibold
                  leading-none
                  tracking-tighter
                  text-white
                  title-font
                "
              >
                ckDAI
              </h1>
            </div>
            <div class="flex-grow">
              <p class="font-medium leading-relaxed text-blueGray-700 ext-base">
                All options are cash settled in ckDAI and the requires vault
                amount (collateral) is also in ckDAI
              </p>
            </div>
          </div>
        </div>

        <div class="p-1 w-full">
          <div class="flex flex-col h-full p-4">
            <div class="flex items-center mb-3">
              <h1
                class="
                  text-xl
                  font-semibold
                  leading-none
                  tracking-tighter
                  text-white
                  title-font
                "
              >
                Mechanics
              </h1>
            </div>
            <div class="flex-grow">
              <p class="font-medium leading-relaxed text-blueGray-700 ext-base">
                <ol>
                  <li>(1) Orders are enteres into an orderbook in the smartcontract</li>
                  <li>(2) Buy orders will have the value of the bid transfered and stored in an escrow account until filled</li>
                  <li>(3) Sell orders will have 150% of the value of the ask stored in the vault account</li>
                  <li>(4) Sell orders will have 150% of the value of the ask stored in the vault account</li>
                  <li>(5) Order cancellation before filled will revert the transfers set out in (3) and (4)</li>
                  <li>(6) At any time, call sellers must keep as collateral (in vault) 140% of the max between the instrinsic value of the call option (underlying asset price - strike) and the best available bid</li>
                  <li>(7) If the value of the collateral is below 140%, the position can be liquidated, where 115% of the current value going to the long position holder, 5% going to the liquidator and the rest is returned to the short position holder</li>
                  <li>(8) Long position holders with receive an ERC20 OLToken and short position holders will receive an ERC20 OSToken</li>
                </ol>

              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <div class="text-white p-4 flex gap-x-2">
    <Faucet class="w-full lg:w-1/2"></Faucet>
    <Admin v-if="isOwner" class="w-full lg:w-1/2"></Admin>
  </div>
</template>

<script>
import Faucet from '../widgets/Faucet.vue'
import Admin from '../widgets/Admin.vue'
import { useStore } from 'vuex'
import { computed } from 'vue'

export default {
  components: { Faucet, Admin },
  setup () {
    const store = useStore()
    const account = computed(() => store.getters.account)
    const isOwner = computed(() => store.getters.isOwner)
    return { store, account, isOwner }
  }

}
</script>
