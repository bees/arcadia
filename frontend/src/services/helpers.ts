import type { EditionGroupInfoLite } from './api/torrentService'

export const timeAgo = (date: string) => {
  const diff = (Date.now() - new Date(date).getTime()) / 1000
  return diff < 60
    ? `${Math.floor(diff)}s ago`
    : diff < 3600
      ? `${Math.floor(diff / 60)}m ago`
      : diff < 86400
        ? `${Math.floor(diff / 3600)}h ago`
        : `${Math.floor(diff / 86400)}d ago`
}
export const bytesToReadable = (bytes: number): string => {
  const units = ['B', 'KiB', 'MiB', 'GiB', 'TiB']
  let size = bytes
  let unitIndex = 0

  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024
    unitIndex++
  }

  return `${size.toFixed(unitIndex === 0 ? 0 : 2)} ${units[unitIndex]}`
}
export const getEditionGroupSlug = (editionGroup: EditionGroupInfoLite): string => {
  let slug = ''

  if (editionGroup.additional_information?.date_from) {
    slug +=
      new Date(editionGroup.additional_information.date_from).toISOString().split('T')[0] + ' to '
  }
  slug += new Date(editionGroup.release_date).toISOString().split('T')[0]

  if (editionGroup.additional_information?.first_item) {
    slug +=
      ' (' +
      editionGroup.additional_information.first_item +
      ' to ' +
      editionGroup.additional_information.last_item +
      ')'
  }
  slug += ' - ' + editionGroup.name
  if (editionGroup.additional_information?.label) {
    slug += ' / ' + editionGroup.additional_information?.label
  }
  if (editionGroup.additional_information?.catalogue_number) {
    slug += ' / ' + editionGroup.additional_information?.catalogue_number
  }
  if (editionGroup.source) {
    slug += ' / ' + editionGroup.source
  }
  slug += editionGroup.distributor ? ' / ' + editionGroup.distributor : ''
  return slug
}
export const getFeatures = (contentType: string): string[] => {
  if (contentType == 'book' || contentType == 'music') {
    return ['Cue', 'Booklet']
  } else if (contentType == 'tv_show' || contentType == 'movie') {
    return ['HDR', 'DV', 'Commentary', 'Remux', '3D']
  } else {
    return []
  }
}
export const getLanguages = () => {
  return ['English', 'French', 'German', 'Italian', 'Spanish', 'Swedish']
}
export const getPlatforms = () => {
  return ['Linux', 'MacOS', 'Windows']
}
export const getSources = (contentType: string) => {
  const sources = ['Web']
  console.log(contentType)
  switch (contentType) {
    case 'Book': {
      sources.push('Physical Book')
      break
    }
    case 'Music': {
      sources.push('Vinyl', 'Blu-Ray', 'CD', 'Soundboard', 'SACD', 'DAT', 'Cassette')
      break
    }
    case 'Movie': {
      sources.push('Blu-Ray', 'DVD9', 'DVD5', 'HD-DVD', 'HD-TV', 'PDTV', 'VHS', 'TV', 'LaserDisc')
      break
    }
    case 'TV-Show': {
      sources.push('Blu-Ray', 'DVD9', 'DVD5', 'HD-DVD', 'HD-TV', 'PDTV', 'VHS', 'TV', 'LaserDisc')
      break
    }
    case 'Collection': {
      sources.push(
        'Blu-Ray',
        'DVD9',
        'DVD5',
        'HD-DVD',
        'HD-TV',
        'PDTV',
        'VHS',
        'TV',
        'LaserDisc',
        'Physical Book',
        'Vinyl',
        'CD',
        'Soundboard',
        'SACD',
        'DAT',
        'Cassette',
      )
      break
    }
  }
  sources.push('Mixed')
  return sources
}
export const isValidUrl = (url: string) => {
  try {
    new URL(url)
    return true
  } catch {
    return false
  }
}
