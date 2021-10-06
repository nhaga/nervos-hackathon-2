<template>
  <div class="w-40">
    <div class="w-6 mx-auto mt-4">
      <img src="@/assets/nervos.png" />
    </div>

    <div class="text-center text-white p-2 font-semibold text-xl uppercase">
      NervOpt
    </div>
    <div class="overflow-y-auto overflow-x-hidden flex-grow">
      <ul class="flex flex-col py-6 space-y-1 text-gray-400">
        <li v-for="link in links" :key="link">
          <router-link
            class="
              flex flex-row
              cursor-pointer
              items-center
              justify-center
              h-8
              hover:text-white
            "
            :class="{
              'font-semibold text-gray-50 border-r-2': $route.path == link.path,
            }"
            :to="link.path"
            >{{ link.label }}</router-link
          >
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  setup () {
    return {
      links: [
        { label: 'Home', path: '/' },
        { label: 'Trade', path: '/trade' },
        { label: 'Liquidation', path: '/liquidation' },
      ]
    }
  }
}
</script>
