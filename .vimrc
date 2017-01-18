"----------------------------------------------------
" vundle
"----------------------------------------------------
filetype off                  " required
filetype plugin indent off    " required

" set the runtime path to include Vundle and initialize
call plug#begin('~/.vim/plugged')

" let Vundle manage Vundle, required
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'osyo-manga/vim-anzu'
Plug 'osyo-manga/vim-over'
Plug 'scrooloose/syntastic'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'rking/ag.vim'
Plug 'tomtom/tcomment_vim'
Plug 'Yggdroot/indentLine'
Plug 'vim-airline/vim-airline'
" Initialize plugin system
call plug#end()

"----------------------------------------------------
" Plugins
"----------------------------------------------------

" vim-asterisk
map *   <Plug>(asterisk-*)
map #   <Plug>(asterisk-#)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)

" Yggdroot/indentLine
let g:indentLine_color_term = 5

" vim-over
nmap <C-h> :OverCommandLine<CR>s/
nmap <ESC><C-h> :OverCommandLine<CR>%s/

" incsearch.vim
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" anzu
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
set statusline=%{anzu#search_status()}

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
" コマンド、検索パターンを100個まで履歴に残す
set history=100
" 検索の時に大文字小文字を区別しない
set ignorecase
" 検索の時に大文字を検索する
set smartcase
" 最後まで検索したら先頭に戻る
set wrapscan
" Regard a-b as one word
set isk+=-


"----------------------------------------------------
" Display
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

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

set t_Co=256


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
    exec "imap " . k . " " . k . "<C-N><C-P>"
endfor

"----------------------------------------------------
" Remap keys
"----------------------------------------------------

" Emacs-like key binding when command-mode
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
cnoremap <C-k> <C-\>estrpart(getcmdline(), 0, getcmdpos()-1)<CR>


" like Spacemacs
let mapleader = "\<Space>"
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>x :Commands<CR>
nnoremap <Leader>f :GFiles<CR>
command! FZFMru call fzf#run({
\  'source':  v:oldfiles,
\  'sink':    'e',
\  'options': '-m -x +s',
\  'down':    '40%'})
nnoremap <Leader>r :FZFMru<CR>
nnoremap <Leader>a :Ag<Space>
nnoremap <Leader>k :bd<CR>

nnoremap <Leader>t :tag<Space><C-r><C-w>

"---------------------------------------------------
" Others
"----------------------------------------------------
set nocompatible
set vb t_vb= " do not beep
set hidden " not discard undo after buffers were killed
autocmd BufWritePre * :%s/\s\+$//e " remove trairing whitespace on save

" remember cursor position
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

set ambiwidth=double " for full width problem

set ttimeoutlen=1 " fast move

" Ignore whitespace in diff mode
if &diff
    " diff mode
    set diffopt+=iwhite
endif

" Automatically show Quickfix window after vimgrep
autocmd QuickFixCmdPost *grep* cwindow


filetype plugin indent on    " required
