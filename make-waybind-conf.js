// TODO: xwayland + xremap not works anymore, so I'm trying to remap keys using waybind, but it is not ideal
//   1. Not filter applications. I want to apply it to specific applications (like only for Chromium)
//      It can be accomplished by combination of `swaymsg --type subscribe --monitor '["window"]' | jq -r '.. | select(.focused?) | .name|test("Chromium")')'`
//   2. Waybind does not support modifier to remapped keys, such as M-a to C-a
//   3. Waybind does not support combination to remapped keys, such as C-k to Shift+End -> C-x
// So, the following config generator is just exploring its feature.

const { dump } = require('js-yaml')
const { writeFileSync } = require('fs')

// https://github.com/arnarg/waybind/blob/master/src/ecodes.go

const rebinds = [
  ['KEY_CAPSLOCK', 'KEY_N', 'KEY_DOWN'],
  ['KEY_CAPSLOCK', 'KEY_P', 'KEY_UP'],
  ['KEY_CAPSLOCK', 'KEY_F', 'KEY_RIGHT'],
  ['KEY_CAPSLOCK', 'KEY_B', 'KEY_LEFT'],
  ['KEY_CAPSLOCK', 'KEY_E', 'KEY_END'],
  ['KEY_CAPSLOCK', 'KEY_S', 'KEY_F3'],
  ['KEY_CAPSLOCK', 'KEY_H', 'KEY_BACKSPACE'],
].map(([modifier, from, to]) => ({
  from,
  with_modifiers: [
    {
      modifier,
      to,
    },
  ],
}))

writeFileSync(
  './etc/waybind/config.yml',
  dump({
    device: '/dev/input/event4',
    rebinds,
  }),
  'utf8',
)
