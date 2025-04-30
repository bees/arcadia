<template>
  <div id="user-view" v-if="peers && user">
    <div class="main">
      <ContentContainer :containerTitle="t('general.description')" class="description">
        <BBCodeRenderer :content="user.description" />
      </ContentContainer>
      <span class="bold">{{ t('torrent.clients_and_ips') }}</span>
      <PeerTable :peers class="peer-table" />
    </div>
    <UserSidebar :user class="sidebar" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getMe, type Peer, type PublicUser, type User } from '@/services/api/userService'
import PeerTable from '@/components/user/PeerTable.vue'
import { useUserStore } from '@/stores/user'
import { useRoute } from 'vue-router'
import UserSidebar from '@/components/user/UserSidebar.vue'
import BBCodeRenderer from '@/components/BBCodeRenderer.vue'
import ContentContainer from '@/components/ContentContainer.vue'
import { useI18n } from 'vue-i18n'

const peers = ref<Peer[] | null>(null)
const user = ref<User | PublicUser | null>(null)

const userStore = useUserStore()
const route = useRoute()
const { t } = useI18n()

onMounted(async () => {
  if (parseInt(route.params.id.toString()) == userStore.id) {
    ;({ peers: peers.value, user: user.value } = await getMe())
    userStore.setUser(user.value as User)
  }
})
</script>

<style scoped>
#user-view {
  display: flex;
}
.main {
  width: 75%;
  margin-right: 10px;
}
.description {
  margin-bottom: 15px;
}
.peer-table {
  margin-top: 5px;
}
.sidebar {
  width: 25%;
}
</style>
