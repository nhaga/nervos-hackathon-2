<template>
  <div class="">
    <Background></Background>
    <div class="context absolute w-full h-full z-5">
      <div class="relative h-full">
        <div class="flex justify-end px-10">
          <Network></Network>
        </div>
        <div class="flex relative w-full">
          <div class="flex md:m-8 bg-black bg-opacity-20 w-full rounded-3xl">
            <!-- Sidebar -->
            <Sidebar class="hidden lg:block"></Sidebar>
            <!-- Main -->
            <div class="w-full flex">
              <div class="bg-black bg-opacity-20 w-full">
                <router-view></router-view>
              </div>
            </div>
            <!-- RightBar -->
            <Rightbar class="hidden lg:flex"></Rightbar>
          </div>
        </div>
      </div>
    </div>
    <Bottom class="visible lg:invisible"></Bottom>
  </div>
</template>

<script>
import Bottom from './Bottom.vue'
import Sidebar from './Sidebar.vue'
import Network from '../components/Network.vue'
import Background from './Background.vue'
import Rightbar from './Rightbar.vue'
import { useStore } from 'vuex'
export default {
  components: { Sidebar, Network, Background, Rightbar, Bottom },

  setup () {
    const store = useStore()
    store.dispatch('getTradeContract')
    store.dispatch('updateVault')
    store.dispatch('updateApprovals')
  }
}
</script>
