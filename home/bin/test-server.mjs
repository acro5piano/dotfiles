#!/usr/bin/env node

import { createServer } from 'http'

const log = (t, level = 'INFO') =>
  console.log(
    `[${new Date().toLocaleTimeString()}] [${level}] ` +
      JSON.stringify(t, undefined, 2),
  )

createServer((req, res) => {
  log({ headers: req.headers })
  res.end('ok')
}).listen(2000, '0.0.0.0', () => {
  log({ msg: 'listening on :2000' })
})
