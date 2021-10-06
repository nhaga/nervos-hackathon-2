<template>
  <div
    class="
      bg-black bg-opacity-20
      rounded-3xl
      flex flex-col
      py-4
      justify-center
      items-center
      border-t border-gray-400 border-opacity-10
    "
  >
    <div class="w-full px-8 text-white">
      Market Value: {{ mtm }}
      <Tooltip>Position</Tooltip>
    </div>

    <div class="chart-gauge">
      <svg viewBox="0 0 400 200" width="200" height="100">
        <g transform="translate(190, 190)">
          <path
            class="arc chart-firs"
            fill="#8a162a"
            opacity="0.7"
            d="M-170,2.0818995585505004e-14A170,170 0 0,1 -85.00000000000007,-147.22431864335454L-61.00000000000006,-105.6550992617015A122,122 0 0,0 -122,1.494069094959771e-14Z"
          ></path>
          <path
            class="arc chart-second"
            fill="yellow"
            opacity="0.4"
            d="M-81.29321430203304,-149.30309209270828A170,170 0 0,1 84.99999999999989,-147.22431864335465L60.99999999999992,-105.65509926170157A122,122 0 0,0 -58.339836146164885,-107.14692491359065Z"
          ></path>
          <path
            class="arc chart-third"
            fill="green"
            opacity="0.8"
            d="M88.65366346483636,-145.05353478720724A170,170 0 0,1 170,-1.9262832252003132e-13L122,-1.382391491026107e-13A122,122 0 0,0 63.6220408394708,-104.09724261199578Z"
          ></path>
          <!--<circle class="needle-center" cx="0" cy="0" r="8"></circle>-->

          <g stroke="black" stroke-width="12" stroke-linecap="round">
            <line x1="-130" y1="0" x2="0" y2="0" :transform="angle" />
          </g>
        </g>
      </svg>
    </div>
    <div class="text-white">Vault Health {{ health }}%</div>
  </div>
</template>

<script>
import { ref, computed } from 'vue'
import { useStore } from 'vuex'
import Tooltip from '../components/Tooltip.vue'

export default {
  components: { Tooltip },
  setup () {
    const store = useStore()

    const value = computed(() => Math.min(Math.max(health.value - 150, 0), 150))
    const range = ref(150)

    const angle = computed(() => {
      return 'rotate(' + (value.value * 180 / range.value) + ' 0 0)'
    })

    const mtm = computed(() => store.getters.mtm)
    const health = computed(() => store.getters.health)

    return { health, value, range, angle, mtm }
  }
}
</script>


<style scoped>
button {
  border: none;
  background: rgba(0, 0, 0, 0.8);
  color: #fff;
  margin: 0 1px;
  outline: 0;
  cursor: pointer;
  text-transform: uppercase;
  box-shadow: 0 4px 6px 0 rgba(0, 0, 0, 0.3);
  border-radius: 2px;
  font-size: 22px;
  width: 40px;
  height: 40px;
}

button:active {
  background-color: #fff;
  color: #000;
}

#svg {
  height: 100px;
  padding: 0px;
  margin: 0px;
}

.bar {
  padding-top: 50px;
  width: 100%;
  position: relative;
}
</style>
