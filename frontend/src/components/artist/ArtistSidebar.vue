<template>
  <div class="artist-sidebar">
    <Image class="artist-pictures" v-if="artist.pictures?.length" :src="artist.pictures[0]" preview>
      <template #previewicon>
        <i class="pi pi-search"></i>
      </template>
    </Image>
    <ContentContainer v-if="artist.description">
      <div class="description">
        <BBCodeRenderer :content="artist.description" />
      </div>
    </ContentContainer>
  </div>
</template>
<script setup lang="ts">
import ContentContainer from '@/components/ContentContainer.vue'
import BBCodeRenderer from '@/components/BBCodeRenderer.vue'
import { type Artist } from '@/services/api/artistService'
import { Image } from 'primevue'

defineProps<{
  artist: Artist
}>()
</script>
<style scoped>
.artist-sidebar {
  display: flex;
  flex-direction: column;
  align-items: center;
}
.content-container {
  margin-top: 10px;
  width: 100%;
}
.description {
  max-height: 50vh;
  overflow-y: scroll;
}
</style>
<style>
.artist-sidebar .artist-pictures {
  img {
    width: 100%;
    border-radius: 7px;
  }
}
</style>
