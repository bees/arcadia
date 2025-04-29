<template>
  <div class="card">
    <DataTable :value="peers" tableStyle="min-width: 50rem">
      <Column field="first_seen_at" header="First seen"></Column>
      <Column field="last_seen_at" header="Last seen"></Column>
      <Column field="ip" header="IP"></Column>
      <Column field="port" header="Port"></Column>
      <Column field="real_downloaded" header="Real Upload"></Column>
      <Column field="real_uploaded" header="Real Download"></Column>
    </DataTable>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import { getMyPeers, type Peer } from '@/services/api/peersService'

const peers = ref<Peer[]>()

onMounted(async () => {
  peers.value = await getMyPeers()
})
</script>

<style></style>
