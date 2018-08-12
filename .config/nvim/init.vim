source ~/.vimrc

function! ImportJs()
    let l:command = "cat .import-list | egrep '\\b".expand("<cword>")."\\b'"

    let l:curPos = getpos('.')
    call cursor(2, 1)
    exec 's/\s*/\r/'

    call setline(3, systemlist(command)[0])
    call cursor(l:curPos[1] + 1, l:curPos[2])
endfunction
