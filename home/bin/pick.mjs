#!/usr/bin/env node

const re = new RegExp(process.argv[2])

process.stdin.setEncoding('utf8')

process.stdin.on('data', function (data) {
  const a = String(data).match(re)
  process.stdout.write(a[1])
})

process.stdin.on('end', function () {
  process.exit()
})
