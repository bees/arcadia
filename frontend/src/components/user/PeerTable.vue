<template>
  <DataTable :value="peers">
    <Column field="first_seen_at" header="First seen"></Column>
    <Column field="last_seen_at" header="Last seen"></Column>
    <Column field="ip" header="IP"></Column>
    <Column field="port" header="Port"></Column>
    <Column field="real_downloaded" header="Real Upload"></Column>
    <Column field="real_uploaded" header="Real Download"></Column>
  </DataTable>
</template>

<script setup lang="ts">
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import type { Peer } from '@/services/api/userService'

defineProps<{
  peers: Peer[]
}>()
</script>

<style></style>
