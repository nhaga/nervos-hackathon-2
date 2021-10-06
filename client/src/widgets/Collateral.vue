<template>
  <div class="bg-black bg-opacity-20 rounded-3xl py-4 border-opacity-10">
    <div class="flex flex-col px-4">
      <div class="text-white w-full h-8 flex font-semibold">
        <div class="w-14 text-center"></div>

        <div class="w-20 flex justify-center items-center gap-2">
          <img class="w-4" src="@/assets/dai.svg" />
          <span> ckDAI </span>
        </div>
      </div>
      <div class="text-white w-full h-8 flex">
        <div class="w-14 text-right flex">Wallet</div>
        <div class="w-20 flex flex-row item-center justify-end">
          {{ parseFloat(walletBalance).toLocaleString() }}
        </div>
      </div>
      <div class="text-white w-full h-8 flex">
        <div class="w-14 text-right flex">Escrow</div>
        <div class="w-20 flex flex-row item-center justify-end">
          {{ parseFloat(escrowBalance).toLocaleString() }}
        </div>
      </div>

      <div class="text-white w-full h-8 flex">
        <div class="w-14 text-right flex">Vault</div>
        <template v-if="currencyAllowance > 0">
          <div class="w-20 text-right">
            {{ parseFloat(vaultBalance).toLocaleString() }}
          </div>
          <div class="flex justify-center items-start w-10">
            <EditButton
              class="text-white"
              @click="currencyModal = !currencyModal"
            ></EditButton>
          </div>
        </template>
        <Button v-else @click="approve">Approve</Button>
      </div>
    </div>

    <Modal v-model="currencyModal">
      <!-- light mode -->
      <div class="max-w-2xl mx-auto sm:px-6 lg:px-8">
        <div class="overflow-hidden shadow-md">
          <!-- card header -->
          <div
            class="
              px-6
              py-4
              bg-white
              border-b border-gray-200
              font-bold
              uppercase
            "
          >
            Change Amount Stored in Vault
          </div>

          <!-- card body -->
          <div class="p-6 bg-white border-b border-gray-200">
            <span class="mr-2"> Amount </span>
            <input
              type="text"
              v-model="currencyDepositAmount"
              class="
                border border-gray-300
                w-20
                p-2
                my-2
                rounded-md
                focus:outline-none
                focus:ring-2
                ring-blue-200
              "
            />
          </div>

          <!-- card footer -->
          <div
            class="
              p-6
              bg-white
              border-gray-200
              text-right
              flex
              justify-around
              gap-x-4
            "
          >
            <!-- button link -->
            <Button @click="currencyWithdraw">Withdraw</Button>
            <Button @click="currencyDeposit">Deposit</Button>
          </div>
        </div>
      </div>
      <!--

      -->
    </Modal>
  </div>
</template>

<script>
import { ref, computed } from 'vue'
import { useStore } from 'vuex'
import Web3 from 'web3'
import Button from '../components/Button.vue'
import EditButton from '../components/EditButton.vue'
import Modal from '../components/Modal.vue'
import getTradeContract from '../utils/getTradeContract'


export default {
  components: { Button, EditButton, Modal },
  setup () {
    const store = useStore()
    const currencyAllowance = computed(() => store.getters.currencyAllowance)


    const currencyModal = ref(false)

    const account = computed(() => store.getters.account)
    const walletBalance = computed(() => store.getters.walletBalance)
    const vaultBalance = computed(() => store.getters.vaultBalance)
    const escrowBalance = computed(() => store.getters.escrowBalance)
    const currencyDepositAmount = ref(5)

    async function approve () {
      store.dispatch('approveCurrency')
    }

    async function currencyDeposit () {
      const contract = await getTradeContract()
      const value = Web3.utils.toWei(currencyDepositAmount.value.toString(), "ether")
      contract.methods.depositCurrency(value)
        .send({
          from: account.value,
          gas: 300000,
          gasPrice: Web3.utils.toWei("2", 'gwei')
        })
        .then(() => {
          store.dispatch('updateVault')
          store.dispatch('updateApprovals')
          currencyDepositAmount.value = 0
          currencyModal.value = false

        })

    }

    async function currencyWithdraw () {
      const contract = await getTradeContract()
      const value = Web3.utils.toWei(currencyDepositAmount.value.toString(), "ether")
      contract.methods.withdrawCurrency(value)
        .send({
          from: account.value,
          gas: 300000,
          gasPrice: Web3.utils.toWei("2", 'gwei')
        })
        .then(() => {
          store.dispatch('updateVault')
          store.dispatch('updateApprovals')
          currencyDepositAmount.value = 0
          currencyModal.value = false
        })

    }


    return {
      currencyModal,
      walletBalance,
      vaultBalance,
      escrowBalance,
      currencyDepositAmount,
      currencyDeposit,
      currencyWithdraw,
      approve,
      currencyAllowance
    }
  }
}
</script>
