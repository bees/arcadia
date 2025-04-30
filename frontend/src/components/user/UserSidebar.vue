<template>
  <div id="user-sidebar">
    <Image
      :src="user.avatar ?? '/default_user_avatar.svg'"
      :alt="user.username + '\'s avatar'"
      preview
    >
      <template #previewicon>
        <i class="pi pi-search"></i>
      </template>
    </Image>
    <ContentContainer>
      <!-- TODO: put values into separate containers -->
      {{ user }}
    </ContentContainer>
  </div>
</template>

<script setup lang="ts">
import type { PublicUser, User } from '@/services/api/userService'
import { Image } from 'primevue'
import ContentContainer from '../ContentContainer.vue'

defineProps<{
  user: User | PublicUser
}>()
</script>

<style scoped></style>
<style>
#user-sidebar {
  .p-image-preview {
    width: 100% !important;
    border-radius: 7px;
    img {
      width: 100% !important;
      border-radius: 7px;
    }
  }
}
</style>
