#!/usr/bin/env node

import { createServer } from 'http'
import { exec } from 'child_process'
import { networkInterfaces } from 'os'

const nic = process.argv[2] || 'wlan0'

console.log(nic)

const log = (t, level = 'INFO') =>
  console.log(
    `[${new Date().toLocaleTimeString()}] [${level}] ` + JSON.stringify(t),
  )

createServer((req, res) => {
  log({ headers: req.headers, ip: req.socket.remoteAddress })
  exec('xclip -selection clipboard -o', (err, stdout) => {
    if (err) {
      log(err, 'ERROR')
    }
    const pasted = String(stdout).trim()
    log({ pasted })
    res.end(pasted)
  })
}).listen(2000, '0.0.0.0', () => {
  const nets = networkInterfaces()
  log({ msg: `Please Visit http://${nets[`${nic}`][0]['address']}:2000` })
  log({ msg: 'listening on :2000' })
})
