<template>
  <transition name="fade">
    <div v-show="prompt" class="fixed inset-0 z-30">
      <!-- background -->
      <div
        v-show="prompt"
        @click="prompt = !prompt"
        class="
          bg-filter bg-gray-700
          opacity-90
          fixed
          inset-0
          w-full
          h-full
          z-20
        "
      ></div>
      <!-- background -->
      <main class="flex flex-col items-center justify-center h-full w-full">
        <transition name="fade-up-down">
          <div v-show="prompt" class="modal-wrapper flex items-center z-30">
            <slot></slot>
          </div>
        </transition>
      </main>
    </div>
  </transition>
</template>

<script>
import { computed } from 'vue'
export default {
  props: ['modelValue'],
  emits: ['update:modelValue'],

  setup (props, { emit }) {

    const prompt = computed({
      get () {
        return props.modelValue
      },
      set (value) {
        emit('update:modelValue', value)
      }
    })
    return { prompt }
  }
}
</script>
