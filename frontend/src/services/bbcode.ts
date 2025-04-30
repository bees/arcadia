import bbobHTML from '@bbob/html'
import presetHTML5 from '@bbob/preset-html5'
import DOMPurify from 'dompurify'

export function parseBBCode(bbcode: string): string {
  if (!bbcode) return ''

  const html = bbobHTML(bbcode, presetHTML5())

  // sanitize html to prevent xss attacks
  return DOMPurify.sanitize(html)
}
