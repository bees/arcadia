<template>
  <!-- use this component for mutation of display dates (i.e. not TZ aware) -->
  <div>
    <DatePicker v-model="dateObject" />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import DatePicker from 'primevue/datepicker'

const model = defineModel<string>()

const dateObject = computed({
  get() {
    const isValidDateStr = !isNaN(Date.parse(model.value ?? ''))
    return isValidDateStr ? new Date(model.value ?? '') : null
  },
  set(newValue) {
    model.value = newValue?.toISOString().slice(0, -1)
  },
})
</script>
