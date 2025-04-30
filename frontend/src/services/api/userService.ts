import type { components } from '@/api-schema/schema'
import api from './api.ts'

export type Profile = components['schemas']['Profile']

export type Peer = components['schemas']['Peer']

export type User = components['schemas']['User']

export type PublicUser = components['schemas']['PublicUser']

export const getMe = async (): Promise<Profile> => {
  try {
    return (await api.get<Profile>('/me')).data
  } catch (error) {
    console.error('API Error:', error)
    throw error
  }
}
