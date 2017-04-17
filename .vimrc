"----------------------------------------------------
" vim-plug
"----------------------------------------------------
" filetype off                  " required
" filetype plugin indent off    " required

" set the runtime path to include Vundle and initialize
call plug#begin('~/.vim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'godlygeek/tabular'
Plug 'haya14busa/incsearch.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mileszs/ack.vim'
Plug 'mattn/emmet-vim'
Plug 'pelodelfuego/vim-swoop'
Plug 'osyo-manga/vim-anzu'
Plug 'osyo-manga/vim-over'
Plug 'plasticboy/vim-markdown'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'Shougo/neocomplete.vim'
Plug 'tomtom/tcomment_vim'
Plug 'posva/vim-vue'
Plug 'Yggdroot/indentLine'
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

source ~/.vim/neocomplete.config.vim

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
autocmd FileType vue syntax sync fromstart
set title
nnoremap j gj
nnoremap k gk
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
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
filetype indent on


"----------------------------------------------------
" Using X11
"----------------------------------------------------

autocmd InsertLeave * call system('fcitx-remote -c')

" Clipboard paste
nnoremap gp :.!xsel -o<CR>
nnoremap gp :.!xsel -bo<CR>
map <C-c> :w !xsel -i<CR><CR>
" vmap <C-c> :w !xsel -bi<CR><CR>

"----------------------------------------------------
" Code autocomplete
"----------------------------------------------------
inoremap {<CR> {<CR>}<Up><End><CR>
inoremap II if<Space>()<Space>{<CR>}<Up><End><Left><Left><Left>
inoremap FE foreach<Space>()<Space>{<CR>}<Up><End><Left><Left><Left>
inoremap zl ->
inoremap zh <-
inoremap </ </<C-x><C-o>
inoremap clg console.log()<Left>

"----------------------------------------------------
" Remap keys
"----------------------------------------------------

" Emacs-like key binding
inoremap <C-a> <Home>
inoremap <C-b> <Left>
inoremap <C-d> <Del>
inoremap <C-e> <End>
inoremap <C-f> <Right>
inoremap <C-k> <C-c>lc$
" キーワード補完には <C-x> <C-n> を使う
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <Down> <C-n>
inoremap <Up> <C-p>

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
nnoremap <Leader>aw :Ack <C-r><C-w>
nnoremap <Leader>aa :Ack<Space>
nnoremap <Leader>bb :Buffers<CR>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>fr :FZFMru<CR>
nnoremap <Leader>fd :e $MYVIMRC<CR>
nnoremap <Leader>fs :w<CR>
nnoremap <Leader>gf :GFiles<CR>
nnoremap <Leader>q! :qa!<CR>
nnoremap <Leader>qq :qa<CR>
nnoremap <Leader>rf :OverCommandLine<CR>s/
nnoremap <Leader>rl :OverCommandLine<CR>s/
vnoremap <Leader>r :OverCommandLine<CR>s/
nnoremap <Leader><Leader> :<C-p><HOME>
vnoremap <Leader><Leader> :<C-p><HOME>
nnoremap <Leader>tj :exe("tjump ".expand('<cword>'))<CR>
nnoremap <Leader>t/ :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <Leader>wd :q<CR>
nnoremap <Leader>wm <C-w><C-w>:q<CR>
nnoremap <Leader>w- :new<CR><C-w><C-w>
nnoremap <Leader>w/ :vs<CR>
nnoremap <Leader>ww <C-w><C-w>
nnoremap <Leader>jd :NERDTreeFind<CR>

nnoremap <Leader>d. :.!date +\%Y-\%m-\%d<CR>
nnoremap <Leader>dt a<Space><C-r>=strftime("%H:%M")<CR><ESC>

nnoremap <ESC><ESC> :nohl<CR>

nmap <F1> <ESC>
imap <F1> <ESC>
vmap <F1> <ESC>

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
set ambiwidth=double " for full width problem
set ttimeoutlen=1 " fast move
set modeline
setlocal iskeyword+=-

autocmd BufWritePre * :%s/\s\+$//e " remove trairing whitespace on save
" remember cursor position
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

autocmd BufReadPost * syntax sync fromstart
autocmd FileType vue syntax sync fromstart

set showcmd

