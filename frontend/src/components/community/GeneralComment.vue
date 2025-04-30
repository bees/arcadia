<template>
  <ContentContainer class="comment-container">
    <div class="comment">
      <div class="user">
        <img
          class="avatar"
          :src="comment.created_by.avatar ?? '/default_user_avatar.svg'"
          :alt="comment.created_by.username + '\'s avatar'"
        />
        <RouterLink :to="`/user/${comment.created_by.id}`">
          <span class="username">
            {{ comment.created_by.username }}
          </span>
        </RouterLink>
        <span class="time-ago">
          {{ $timeAgo(comment.created_at) }}
        </span>
      </div>
      <div class="comment-body">
        <BBCodeRenderer :content="comment.content" />
      </div>
    </div>
  </ContentContainer>
</template>

<script setup lang="ts">
import ContentContainer from '@/components/ContentContainer.vue'
import BBCodeRenderer from '@/components/BBCodeRenderer.vue'
import type { TitleGroupCommentHierarchy } from '@/services/api/commentService'

defineProps<{
  comment: TitleGroupCommentHierarchy
}>()
</script>

<style scoped>
.comment-container {
  margin-top: 10px;
}
.comment {
  display: flex;
}
.user {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 10px;
  margin-right: 7px;
  background-color: var(--color-background-primary);
  border-radius: 7px;
}
.avatar {
  width: 7em;
  border-radius: 7px;
}
.comment-body {
  padding: 7px;
}
.username {
  color: var(--color-primary);
}
.time-ago {
  font-size: 0.8em;
  margin-top: 5px;
}
</style>
