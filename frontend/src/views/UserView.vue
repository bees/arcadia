<template>
  <PeerTable v-if="peers" :peers />
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getMe, type Peer, type PublicUser, type User } from '@/services/api/userService'
import PeerTable from '@/components/user/PeerTable.vue'
import { useUserStore } from '@/stores/user'
import { useRoute } from 'vue-router'

const peers = ref<Peer[] | null>(null)
const user = ref<User | PublicUser>()

const userStore = useUserStore()
const route = useRoute()

onMounted(async () => {
  if (parseInt(route.params.id.toString()) == userStore.id) {
    ;({ peers: peers.value, user: user.value } = await getMe())
    userStore.setUser(user.value as User)
  }
})
</script>

<style></style>
