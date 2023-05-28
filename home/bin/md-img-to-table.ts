#!/usr/bin/env -S deno run --allow-read

import { assertEquals } from 'https://deno.land/std@0.114.0/testing/asserts.ts'
import { dedent } from 'https://raw.githubusercontent.com/tamino-martinius/node-ts-dedent/master/src/index.ts'

function convert(lines: string) {
  const tds = lines
    .split('\n')
    .map((line) => {
      const matches = line.match(/(https:.+.\))/)
      const src = matches?.[1]
      if (!src) {
        return ''
      }
      return dedent`
        <td>
          <img src="${src}" />
        </td>
      `
    })
    .join('\n')
  return dedent`
    <table>
      ${tds}
    </table>
  `
}

if (Deno.args[0] === 'test') {
  const expected = dedent`
    <table>
      <td>
        <img src="https://image.test/uploads/000000000000000000000000000000000000.png" />
      </td>
      <td>
        <img src="https://image.test/uploads/000000000000000000000000000000000001.png" />
      </td>
      <td>
        <img src="https://image.test/uploads/000000000000000000000000000000000002.png" />
      </td>
    </table>
  `
  const fixture = dedent`
    ![image.png](https://image.test/uploads/000000000000000000000000000000000000.png =WxH)
    ![image.png](https://image.test/uploads/000000000000000000000000000000000001.png =WxH)
    ![image.png](https://image.test/uploads/000000000000000000000000000000000002.png =WxH)
  `
  assertEquals(convert(fixture), expected)
} else {
  const stdin = new TextDecoder().decode(await Deno.readAll(Deno.stdin))
  console.log(convert(stdin.trim()))
}
