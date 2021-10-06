<template>
  <div class="py-1">
    <span class="px-1 text-sm text-white">{{ label }}</span>
    <input
      type="text"
      v-model="value"
      disabled
      class="
        text-white text-md
        bg-opacity-20
        px-3
        py-2
        rounded-lg
        w-full
        bg-white
        focus:outline-none
      "
    />
  </div>
</template>

<script>
import { computed } from 'vue'
export default {
  props: ['modelValue', 'label'],
  setup (props) {
    const value = computed({
      get: () => props.modelValue,
      set () { }
    })

    return { value }
  }
}
</script>
