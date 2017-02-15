"----------------------------------------------------
" vim-plug
"----------------------------------------------------
" filetype off                  " required
" filetype plugin indent off    " required

" set the runtime path to include Vundle and initialize
call plug#begin('~/.vim/plugged')

Plug 'haya14busa/incsearch.vim'
Plug 'osyo-manga/vim-anzu'
Plug 'osyo-manga/vim-over'
Plug 'scrooloose/syntastic'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'tomtom/tcomment_vim'
Plug 'Yggdroot/indentLine'
Plug 'itchyny/lightline.vim'
Plug 'jceb/vim-orgmode'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
" Initialize plugin system
call plug#end()

" Yggdroot/indentLine
let g:indentLine_color_term = 5


" anzu
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
set statusline=%{anzu#search_status()}

" not fold in markdown
let g:vim_markdown_folding_disabled = 1

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
set history=100
set ignorecase
set smartcase
set wrapscan

" Regard hypen separete word as as one word
" e.g) a-b
set isk+=-

let g:ackprg = 'rg --vimgrep --smart-case'

" incsearch.vim
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

"----------------------------------------------------
" Face
"----------------------------------------------------
set title
nnoremap j gj
nnoremap k gk
set showcmd
set laststatus=2
set showmatch
syntax on
set hlsearch
set wildmenu

set textwidth=0
set nowrap

" Show Full width
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

set t_Co=256

colorscheme elflord

let g:lightline = {
      \ 'colorscheme': 'solarized'
      \ }

"----------------------------------------------------
" Indent
"----------------------------------------------------
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab


"----------------------------------------------------
" Using X11
"----------------------------------------------------

autocmd InsertLeave * call system('fcitx-remote -c')

" Clipboard paste
nnoremap gp :.!xsel -bo<CR>
vmap <C-c> :w !xsel -ib<CR><CR>

"----------------------------------------------------
" Always show auto complete
"----------------------------------------------------

set completeopt=menuone
for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_",'\zs')
   exec "imap " . k . " " . k . "<C-n><C-p>"
endfor

"----------------------------------------------------
" Remap keys
"----------------------------------------------------

" Emacs-like key binding
inoremap <C-a> <Home>
inoremap <C-b> <Left>
inoremap <C-d> <Del>
inoremap <C-e> <End>
inoremap <C-f> <Right>
inoremap <C-k> <ESC>lc$

cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <C-k> <C-\>estrpart(getcmdline(), 0, getcmdpos()-1)<CR>

" like Spacemacs
let mapleader = "\<Space>"
nnoremap <Leader>bb :Buffers<CR>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>fr :FZFMru<CR>
nnoremap <Leader>fs :w<CR>
nnoremap <Leader><Leader> :Commands<CR>
nnoremap <Leader>pf :GFiles<CR>
nnoremap <Leader>q! :qa!<CR>
nnoremap <Leader>qq :qa<CR>
nnoremap <Leader>sap :Ack<Space><C-r><C-w>
nnoremap <Leader>t :tag<Space><C-r><C-w>
nnoremap <Leader>wd :q<CR>
nnoremap <Leader>wm <C-w><C-w>:q<CR>
nnoremap <Leader>w- :new<CR><C-w><C-w>
nnoremap <Leader>w/ :vs<CR>
nnoremap <Leader>ww <C-w><C-w>

nnoremap <Leader>rl :OverCommandLine<CR>s/
nnoremap <Leader>rf :OverCommandLine<CR>%s/


command! FZFMru call fzf#run({
\  'source':  v:oldfiles,
\  'sink':    'e',
\  'options': '-m -x +s',
\  'down':    '40%'})

nnoremap go o<ESC>k


"---------------------------------------------------
" Others
"----------------------------------------------------
set nocompatible
set vb t_vb= " do not beep
set hidden " not discard undo after buffers were killed
autocmd BufWritePre * :%s/\s\+$//e " remove trairing whitespace on save

" remember cursor position
" autocmd BufReadPost *
"     \ if line("'\"") > 0 && line("'\"") <= line("$") |
"     \   exe "normal g`\"" |
"     \ endif

set ambiwidth=double " for full width problem

set ttimeoutlen=1 " fast move

