#!/usr/bin/env node

import { createServer } from 'http'
import { exec } from 'child_process'
import { networkInterfaces } from 'os'

const nic = process.argv[2] || 'wlan0'

const log = (t, level = 'INFO') =>
  console.log(
    `[${new Date().toLocaleTimeString()}] [${level}] ` + JSON.stringify(t),
  )

log({ msg: `using network interface: ${nic}` })

createServer((req, res) => {
  log({ headers: req.headers, ip: req.socket.remoteAddress })
  exec('xclip -selection clipboard -o', (err, stdout) => {
    if (err) {
      log(err, 'ERROR')
    }
    const pasted = String(stdout).trim()
    log({ pasted })
    res.setHeader('Content-Type', 'text/html; charset=utf-8')
    res.end(render(pasted))
  })
}).listen(2000, '0.0.0.0', () => {
  const nets = networkInterfaces()
  log({ msg: `Please Visit http://${nets[`${nic}`][0]['address']}:2000` })
  log({ msg: 'listening on :2000' })
})

const html = String.raw

/**
 * @param {string} content - the content to be pasted
 */
const render = (content) => html`
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <title>Clipboard</title>
      <style>
        .button {
          position: fixed;
          bottom: 0;
          width: 100%;
        }
        button {
          font-size: 2rem;
          padding: 0.5rem 1rem;
          border: 1px solid #ccc;
          border-radius: 0.5rem;
          background: #eee;
          cursor: pointer;
          width: 88%;
          margin: 2rem auto;
          display: block;
        }
        textarea {
          width: 100%;
          height: 300px;
        }
      </style>
      <script>
        function onClick() {
          const textarea = document.querySelector('textarea')
          textarea.select()
          document.execCommand('copy')
          textarea.blur()
        }
      </script>
    </head>
    <body>
      <!-- prettier-ignore -->
      <textarea id="content">${content}</textarea>
      <div class="button">
        <button onclick="onClick()">Copy</button>
      </div>
    </body>
  </html>
`
