import type { components } from '@/api-schema/schema'
import api from './api.ts'

export type Peer = components['schemas']['Peer']

export const getMyPeers = async (): Promise<Peer[]> => {
  try {
    return (await api.get<Peer[]>('/me/peers')).data
  } catch (error) {
    console.error('API Error:', error)
    throw error
  }
}
