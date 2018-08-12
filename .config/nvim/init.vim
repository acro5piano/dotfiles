source ~/.vimrc

command! ImportJsMake call ImportJsMake()
function! ImportJsMake()
    call system("touch ~/.import-js-list")
    call system("git ls | xargs grep import | grep 'from' | egrep -v 'yarn|d.ts|.json|flow-typed' | perl -pe 's/^.+://' | grep -v '^\/\/' | grep -v '{$' | perl -nale 'print if length($_) < 80' > /tmp/.import-js-list")
    call system("cat /tmp/.import-js-list ~/.import-js-list | sort | uniq > /tmp/import-js-list-concatenated")
    call system("cat /tmp/import-js-list-concatenated > ~/.import-js-list")
endfunction

command! ImportJs call ImportJs()
function! ImportJs() abort
    let l:command = "cat ~/.import-js-list | egrep '\\b".expand("<cword>")."\\b'"

    let l:curPos = getpos('.')
    call cursor(2, 1)
    exec 's/\s*/\r/'

    let l:lines = systemlist(command)
    let l:lineToImport = 0
    if len(l:lines) > 1
        let l:lineToImport = inputlist(map(deepcopy(lines), { i, x -> i.': '.x }))
    endif
    call setline(3, l:lines[l:lineToImport])
    call cursor(l:curPos[1] + 1, l:curPos[2])
endfunction
