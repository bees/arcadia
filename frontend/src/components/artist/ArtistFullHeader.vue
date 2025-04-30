<template>
  <ContentContainer class="header-wrapper artist-full-header">
    <div class="header">
      <Image
        class="artist-pictures"
        v-if="artist.pictures?.length"
        :src="artist.pictures[0]"
        preview
      >
        <template #previewicon>
          <i class="pi pi-search"></i>
        </template>
      </Image>
      <div class="textual-information">
        <div class="name">{{ artist.name }}</div>
        <div class="description">
          <BBCodeRenderer :content="artist.description" />
        </div>
      </div>
    </div>
  </ContentContainer>
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
.header-wrapper {
  margin-bottom: 15px;
}
.header {
  display: flex;
  height: 35vh;
}
.artist-pictures {
  margin-right: 10px;
}
.name {
  font-weight: bold;
  font-size: 2em;
}
.description {
  margin-top: 10px;
  max-height: 80%;
  overflow-y: scroll;
}
</style>
<style>
.artist-full-header .artist-pictures img {
  max-width: 20em;
  max-height: 20em;
  border-radius: 7px;
}
</style>
