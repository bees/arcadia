<template>
  <DataTable :value="peers">
    <Column field="first_seen_at" header="First seen">
      <template #body="slotProps">
        {{ timeAgo(slotProps.data.first_seen_at) }}
      </template>
    </Column>
    <Column field="last_seen_at" header="Last seen">
      <template #body="slotProps">
        {{ timeAgo(slotProps.data.last_seen_at) }}
      </template>
    </Column>
    <Column field="ip" header="IP"></Column>
    <Column field="port" header="Port"></Column>
    <Column field="user_agent" header="User Agent"></Column>
    <Column field="real_downloaded" header="Real Upload">
      <template #body="slotProps">
        {{ bytesToReadable(slotProps.data.real_downloaded) }}
      </template>
    </Column>
    <Column field="real_uploaded" header="Real Download">
      <template #body="slotProps">
        {{ bytesToReadable(slotProps.data.real_uploaded) }}
      </template>
    </Column>
  </DataTable>
</template>

<script setup lang="ts">
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import type { Peer } from '@/services/api/userService'
import { bytesToReadable, timeAgo } from '@/services/helpers'

defineProps<{
  peers: Peer[]
}>()
</script>

<style></style>
