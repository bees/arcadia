<template>
  <Form :initialValues="form" @submit="login">
    <div class="flex flex-col gap-1">
      <InputText
        class="form-item"
        name="username"
        type="text"
        :placeholder="$t('user.username')"
        v-model="form.username"
      />
    </div>
    <div class="flex flex-col gap-1">
      <Password
        class="form-item"
        name="password"
        v-model="form.password"
        :placeholder="$t('user.password')"
        :feedback="false"
      />
    </div>
    <div>
      <Checkbox class="form-item" v-model="form.remember_me" binary />
      <label for="ingredient1"> {{ $t('auth.remember_me') }} </label>
    </div>
    <Button
      class="form-item"
      type="submit"
      severity="secondary"
      label="Submit"
      @click="handleLogin"
    />
  </Form>
</template>
<script setup lang="ts">
import InputText from 'primevue/inputtext'
import Password from 'primevue/password'
import { Form } from '@primevue/forms'
import Button from 'primevue/button'
import Checkbox from 'primevue/checkbox'
import { login } from '@/services/api/authService'
import { useUserStore } from '@/stores/user'
import { useRouter } from 'vue-router'
import { getMe } from '@/services/api/userService'

const form = {
  username: '',
  password: '',
  remember_me: false,
}

const router = useRouter()
const userStore = useUserStore()

const handleLogin = async () => {
  login(form).then(async (data) => {
    localStorage.setItem('token', data.token)
    const profile = await getMe()
    localStorage.setItem('user', JSON.stringify(profile.user))
    userStore.setUser(profile.user)
    router.push('/')
  })
}
</script>
