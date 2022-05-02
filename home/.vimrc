" vim:set shiftwidth=2 :
"----------------------------------------------------
" vim-plug
"----------------------------------------------------
" filetype off                  " required
" filetype plugin indent off    " required

" set the runtime path to include Vundle and initialize

" vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 0

let g:graphql_javascript_tags = ['gql']

" Yggdroot/indentLine
let g:indentLine_color_term = 8

let g:jsx_ext_required = 0

" UltiSnips
let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']

" Prettier
let g:prettier#config#tab_width = '2'
let g:prettier#config#config_precedence = 'prefer-file'
let g:prettier#config#use_tabs = 'false'
let g:prettier#config#semi = 'false'
let g:prettier#config#trailing_comma = 'all'
let g:prettier#config#arrow_parens = 'always'

" COC
set updatetime=300
set shortmess+=c
set signcolumn=yes

"----------------------------------------------------
" Charcode
"----------------------------------------------------
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
set fileformats=unix,dos,mac

"----------------------------------------------------
" Backup
"----------------------------------------------------
set nobackup
set writebackup
set directory=/tmp

"----------------------------------------------------
" Search
"----------------------------------------------------
set history=1000
set ignorecase
set smartcase
set wrapscan
set hlsearch
set incsearch

let g:ackprg = 'rg --vimgrep --smart-case'

map *  <Plug>(asterisk-*)
map #  <Plug>(asterisk-#)
map g* <Plug>(asterisk-z*)
map g# <Plug>(asterisk-z#)

"----------------------------------------------------
" Face
"----------------------------------------------------
autocmd FileType vue syntax sync fromstart
set title
set laststatus=2
set showmatch
set wildmenu

syntax on

set textwidth=0
set nowrap

" Show Full width
match Todo /　/

set t_Co=256

colorscheme elflord

set breakindent

" https://stackoverflow.com/questions/15277241/changing-vim-gutter-color
highlight SignColumn ctermbg=black

"----------------------------------------------------
" Indent
"----------------------------------------------------
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
filetype indent on


"----------------------------------------------------
" Copy/Paste
"----------------------------------------------------

" Clipboard copy / paste
nnoremap <Space>pb :.!clp<CR>
map <C-c> :w !cl<CR><CR>

"----------------------------------------------------
" Code autocomplete
"----------------------------------------------------

inoremap {<CR> {<CR>}<Up><End><CR>
inoremap [<CR> [<CR>];<Up><End><CR>
inoremap ({<CR> ({<CR>})<Up><End><CR>
inoremap ([<CR> ([<CR>]);<Up><End><CR>
inoremap z. =>
inoremap zc console.log()<Left>
inoremap zl ->
" inoremap zp extract(\Psy\Shell::debug(get_defined_vars()));
" inoremap zr require 'pry'; binding.pry
" autocmd FileType xml,html inoremap </ </<C-x><C-o>
inoremap zd <C-r>=strftime("%Y-%m-%d")<CR><Space>
inoremap zt <C-r>=strftime("%H:%M")<CR><Space>
inoremap z[ from IPython import embed; embed()
inoremap zf <C-r>=expand('%:t:r')<CR>
inoremap zw <C-r>=expand('%:p:h:t')<CR>

"----------------------------------------------------
" Remap keys
"----------------------------------------------------

tnoremap <silent> <C-g> <C-\><C-n>

inoremap <S-TAB> <C-d>
inoremap <TAB> <C-t>

" Emacs-like key binding
" キーワード補完には <C-x> <C-n> を使う
inoremap <C-a> <Home>
inoremap <C-b> <Left>
inoremap <C-d> <Del>
inoremap <C-e> <End>
inoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <C-k> <C-\>estrpart(getcmdline(), 0, getcmdpos()-1)<CR>
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <Down> <C-n>
inoremap <Up> <C-p>
inoremap <C-k> <C-o>:call setline(line('.'), col('.') == 1 ? '' : getline('.')[:col('.') - 2])<CR>

" like Spacemacs
let mapleader = "\<Space>"
nnoremap j gj
nnoremap k gk

nnoremap \| x~f_
nnoremap Q @q
nnoremap <Leader>/ :TComment<CR>

" COC
inoremap <silent><expr> <c-l> coc#refresh()
nmap <Leader>ac :CocAction<CR>
nmap <Leader>ap <Plug>(coc-diagnostic-prev)
nmap <Leader>an <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> <Leader>aj <Plug>(coc-definition)
nmap <silent> <Leader>ar <Plug>(coc-references)
nmap <silent> <Leader>ah <Plug>(coc-type-definition)
nmap <silent> <Leader>ac :CocAction<CR>

nnoremap <Leader>fe :e!<CR>
nnoremap <Leader>fs :w<CR>
nnoremap <Leader>ft :set ft=txt<CR>
nnoremap <Leader>fm :set ft=markdown<CR>
nnoremap <Leader>wp :set wrap!<CR>
nnoremap <Leader>gb :GitBlame<CR>
nnoremap <Leader>gl :GitLog100<CR>
nnoremap <Leader>gs :call fzf#vim#gitfiles('?')<CR><HOME>
nnoremap <Leader>ij :ImportJsFZF<CR>
nnoremap <Leader>q! :qa!<CR>
nnoremap <Leader>qq :qa<CR>
nnoremap <Leader>rl :OverCommandLine<CR>s/
nnoremap <Leader>rr :OverCommandLine<CR>%s/
vnoremap <Leader>/ :TComment<CR>

command! RequireToImport execute("normal 0cwimport<ESC>f=cf(from <ESC>$x0j")
command! TTagnize execute("normal vitS`vitS{at")

nnoremap <ESC><ESC> :nohl<CR>

nmap <F1> <ESC>
imap <F1> <ESC>
vmap <F1> <ESC>

"--------------
" Git
"--------------
function! s:git_blame()
    let fileName = '/tmp/__git_blame.'.expand('%:t')
    call system('git blame '.expand('%').' > '.fileName)
    :exe ':view '.fileName
endfunction
command! GitBlame call s:git_blame()

function! s:git_log_100()
    let fileName = '/tmp/__git_log.'.expand('%:t').'.diff'
    call system('git log -p -100 '.expand('%').' > '.fileName)
    :exe ':view '.fileName
endfunction
command! GitLog100 call s:git_log_100()

"---------------------------------------------------
" File alias
"----------------------------------------------------
autocmd BufEnter,BufNew *.json set ft=java
autocmd BufEnter,BufNew *.tera set filetype=html
autocmd BufEnter,BufNew *.toml set filetype=yaml

"---------------------------------------------------
" Others
"----------------------------------------------------
set nocompatible
set vb t_vb= " do not beep
set hidden " not discard undo after buffers were killed
set ttimeoutlen=1 " fast move
set modeline

autocmd BufWritePre * :%s/\s\+$//e " remove trairing whitespace on save

if has('nvim')
    autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.graphql,*.gql,*.md,*.vue,*.html Prettier
    autocmd BufWritePre *.py Yapf
endif

" Experimental: maximize pane when focus
autocmd FocusGained * silent! !tmux-zoom

" " remember cursor position
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

autocmd FileType vue syntax sync fromstart

set backspace=indent,eol,start

set showcmd

autocmd BufWritePre *.lua lua require("stylua-nvim").format_file()

command! Rubocop !bundle exec rubocop -a %
command! ESLint !yarn eslint --fix %
command! PrettierPhp !yarn prettier --tab-width 4 --write %

command! VSCode !code %
command! VSCodeDir !code %:p:h
filetype plugin on

" For css completion
" autocmd FileType typescript.tsx,typescript,typescriptreact,javascript,javascript.jsx,jsx,tsx setlocal omnifunc=csscomplete#CompleteCSS

au InsertLeave * set nopaste

