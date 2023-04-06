#!/usr/bin/env node

import { readFile, writeFile } from 'fs/promises'

const todayStr = new Date().toISOString().split('T')[0].replace(/-/g, '')
const baseTitle = `release-${todayStr}`
const cacheFile = `/tmp/${baseTitle}`

const existing = await readFile(cacheFile, 'utf8')
  .then(parseInt)
  .catch(() => 0)
const next = existing + 1

await writeFile(cacheFile, next.toString(), 'utf8')

console.log(`${baseTitle}-${next}`)
