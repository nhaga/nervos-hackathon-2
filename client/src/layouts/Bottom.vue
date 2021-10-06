<template>
  <VueBottomNavigation
    :options="options"
    v-model="selected"
    foregroundColor="#8a162a  "
  >
    <template #title="{ props }">
      <b class="text-black">{{ props.title }}</b>
    </template>
    <template #icon="{ props }">
      <Icon :name="props.icon"></Icon>
    </template>
  </VueBottomNavigation>
</template>

<script>
import { ref } from 'vue'
import Icon from '../components/Icon.vue'

import VueBottomNavigation from "../components/BottomNavigation.vue"

export default {
  components: { VueBottomNavigation, Icon },
  setup () {
    return {
      selected: ref(1),
      options: [
        { id: 1, icon: "home", title: "Home", path: '/' },
        { id: 2, icon: "trade", title: "Trade", path: '/trade' },
        { id: 3, icon: "liquidation", title: "Liquidation", path: '/liquidation' },
        { id: 4, icon: "wallet", title: "Wallet", path: '/wallet' },
      ]
    }
  }
}
</script>
