"----------------------------------------------------
" vundle
"----------------------------------------------------
filetype off                  " required
filetype plugin indent off    " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'

Plugin 'elixir-lang/vim-elixir'
Plugin 'haya14busa/incsearch.vim'
Plugin 'haya14busa/vim-asterisk'
Plugin 'LeafCage/yankround.vim'
Plugin 'osyo-manga/vim-anzu'
Plugin 'osyo-manga/vim-over'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'severin-lemaignan/vim-minimap'
Plugin 'terryma/vim-expand-region'
Plugin 'tomtom/tcomment_vim'
Plugin 'Yggdroot/indentLine'

" All of your Plugins must be added before the following line
call vundle#end()            " required

"----------------------------------------------------
" vim-asterisk
"----------------------------------------------------
map *   <Plug>(asterisk-*)
map #   <Plug>(asterisk-#)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)

"----------------------------------------------------
" yankround.vim
"----------------------------------------------------
nmap p <Plug>(yankround-p)
xmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap gp <Plug>(yankround-gp)
xmap gp <Plug>(yankround-gp)
nmap gP <Plug>(yankround-gP)
nmap <C-k> <Plug>(yankround-prev)
nmap <C-j> <Plug>(yankround-next)

"----------------------------------------------------
" Yggdroot/indentLine
"----------------------------------------------------
let g:indentLine_color_term = 5

"----------------------------------------------------
" vim-over
"----------------------------------------------------
nmap <C-h> :OverCommandLine<CR>s/
nmap <ESC><C-h> :OverCommandLine<CR>%s/


"----------------------------------------------------
" incsearch.vim
"----------------------------------------------------
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)


"----------------------------------------------------
" anzu
"----------------------------------------------------
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
set statusline=%{anzu#search_status()}

"----------------------------------------------------
" Charcode
"----------------------------------------------------
" 文字コードの自動認識
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
" 改行コードの自動認識
set fileformats=unix,dos,mac

"----------------------------------------------------
" Basic
"----------------------------------------------------
" viとの互換性をとらない(vimの独自拡張機能を使う為)
set nocompatible
" ビープ音を鳴らさない
set vb t_vb=
" バックスペースキーで削除できるものを指定
" indent  : 行頭の空白
" eol     : 改行
" start   : 挿入モード開始位置より手前の文字
set backspace=indent,eol,start

"----------------------------------------------------
" Backup
"----------------------------------------------------
" バックアップをとらない
set nobackup
" ファイルの上書きの前にバックアップする
" (ただし、backup がオンでない限り、バックアップは上書きに成功した後削除される)
set writebackup
" バックアップをとるディレクトリ
"set backupdir=~/backup
" スワップファイルを作るディレクトリ
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
" Automatically show Quickfix window after vimgrep
autocmd QuickFixCmdPost *grep* cwindow


"----------------------------------------------------
" 表示関係
"----------------------------------------------------
" タイトルをウインドウ枠に表示する
set title
" 行番号を表示しない
set nonumber
" カーソルを表示行で移動する。物理行移動は<C-n>,<C-p>
nnoremap j gj
nnoremap k gk
" タブ文字を CTRL-I で表示し、行末に $ で表示する
"set list
" 入力中のコマンドをステータスに表示する
set showcmd
" ステータスラインを常に表示
set laststatus=2
" 括弧入力時の対応する括弧を表示
set showmatch
" シンタックスハイライトを有効にする
syntax on
" 検索文字列のハイライトを有効にする
set hlsearch
" コメント文の色を変更
highlight Comment ctermfg=DarkCyan
" コマンドライン補完を拡張モードにする
set wildmenu

" 入力されているテキストの最大幅
" (行がそれより長くなると、この幅を超えないように空白の後で改行される)を無効にする
set textwidth=0
" ウィンドウの幅より長い行は折り返さない
set nowrap

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

" ステータスラインに表示する情報の指定
set statusline=%n\:%y%F\ \|%{(&fenc!=''?&fenc:&enc).'\|'.&ff.'\|'}%m%r%=<%l/%L:%p%%>
" ステータスラインの色
highlight StatusLine   term=NONE cterm=NONE ctermfg=black ctermbg=white

" 行末のスペースを強調表示
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END


"----------------------------------------------------
" インデント
"----------------------------------------------------
" オートインデントを有効にする
set autoindent

" タブが対応する空白の数
set tabstop=4
" タブが対応する空白の数
set softtabstop=4
" インデントの各段階に使われる空白の数
set shiftwidth=4
" タブを挿入するとき、代わりに空白を使う
set expandtab

"----------------------------------------------------
" Using fcitx
"----------------------------------------------------

autocmd InsertLeave * call DeactIm()

function DeactIm()
    call system('fcitx-remote -c')
endfunction

"----------------------------------------------------
" Always show auto complete
"----------------------------------------------------

set completeopt=menuone
for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_",'\zs')
  exec "imap " . k . " " . k . "<C-N><C-P>"
endfor

" imap <expr> <TAB> pumvisible() ? "\<Down>" : "\<Tab>"

"----------------------------------------------------
" Remap keys
"----------------------------------------------------

" ; と : を入れ替える
nnoremap ; :
vmap ; :

" Emacs-like key binding when command-mode

cnoremap <C-a> <Home>
" 一文字戻る
cnoremap <C-b> <Left>
" カーソルの下の文字を削除
cnoremap <C-d> <Del>
" 行末へ移動
cnoremap <C-e> <End>
" 一文字進む
cnoremap <C-f> <Right>
" コマンドライン履歴を一つ進む
cnoremap <C-n> <Down>
" コマンドライン履歴を一つ戻る
cnoremap <C-p> <Up>
" 前の単語へ移動
cnoremap <M-b> <S-Left>
" 次の単語へ移動
cnoremap <M-f> <S-Right>
" Kill-ring
cnoremap <C-k> <C-\>estrpart(getcmdline(), 0, getcmdpos()-1)<CR>
" C-g => Escape
cmap <C-g> <ESC>
imap <C-g> <ESC>
vmap <C-g> <ESC>


" NERDTree
nnoremap <silent><C-e> :NERDTreeToggle<CR>

" Clipboard paste
nnoremap gp :.!xsel -bo<CR>

" Insert newline
nnoremap go A<CR><ESC>k

"----------------------------------------------------
" その他
"----------------------------------------------------
" バッファを切替えてもundoの効力を失わない
set hidden

" カーソル位置を記憶する
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" 起動時のメッセージを表示しない
set shortmess+=I
" 罫線の表示をしない
set nocursorline
set nocursorcolumn
" 全角記号崩れの対策
set ambiwidth=double

vmap <C-c> :w !xsel -ib<CR><CR>

if expand("%") =~ "sql"
    set filetype=sql
endif

set ttimeoutlen=1

" Ignore whitespace in diff
if &diff
    " diff mode
    set diffopt+=iwhite
endif

filetype plugin indent on    " required
