<template>
  <div id="app-container">
    <div
      class="navbars-container"
      v-if="['/login', '/register'].indexOf($router.currentRoute.value.path) < 0"
    >
      <TopBar />
      <MenuBar class="menu-bar" />
      <SearchBars class="search-bars" />
    </div>
    <div id="view-container">
      <router-view></router-view>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import MenuBar from './components/MenuBar.vue'
import TopBar from './components/TopBar.vue'
import SearchBars from './components/SearchBars.vue'
import { useUserStore } from './stores/user'
import { getMe } from './services/api/userService'
import { onBeforeMount } from 'vue'

// enable dark mode by default
document.documentElement.classList.add('dark-theme')

onBeforeMount(async () => {
  const user = localStorage.getItem('user')
  if (user) {
    // refresh user on page reload
    const profile = await getMe()
    localStorage.setItem('user', JSON.stringify(profile.user))
    const userStore = useUserStore()
    userStore.setUser(profile.user)
  } else {
    const router = useRouter()
    router.push('/login')
  }
})
</script>

<style>
.navbars-container {
  width: 100%;
}
.menu-bar {
  margin-top: 10px;
}
.search-bars {
  margin-top: 10px;
  margin-bottom: 20px;
}
</style>
