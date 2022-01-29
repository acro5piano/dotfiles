#!/usr/bin/env node

import { createServer } from 'http'
import { exec } from 'child_process'
import { networkInterfaces } from 'os'

const log = (t) =>
  console.log(`[${new Date().toLocaleTimeString()}] ` + JSON.stringify(t))

createServer((req, res) => {
  log({ headers: req.headers, ip: req.socket.remoteAddress })
  exec('wl-paste -t text', (_err, stdout) => {
    const pasted = String(stdout).trim()
    log({ pasted })
    res.end(pasted)
  })
}).listen(2000, '0.0.0.0', () => {
  const nets = networkInterfaces()
  log({ msg: `Please Visit http://${nets['wlan0'][0]['address']}:2000` })
  log({ msg: 'listening on :2222' })
})
