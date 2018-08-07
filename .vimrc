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
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'itchyny/lightline.vim'
Plug 'vim-scripts/taglist.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mileszs/ack.vim'
Plug 'mattn/emmet-vim'
Plug 'jwalton512/vim-blade'
Plug 'osyo-manga/vim-anzu'
Plug 'osyo-manga/vim-over'
Plug 'plasticboy/vim-markdown'
Plug 'scrooloose/nerdtree'
" TODO: new complete engine
" Plug 'Valloric/YouCompleteMe'
Plug 'Shougo/neocomplete.vim'
Plug 'tomtom/tcomment_vim'
Plug 'posva/vim-vue'
Plug 'digitaltoad/vim-pug'
Plug 'Yggdroot/indentLine'
Plug 'wsdjeg/FlyGrep.vim'

Plug 'w0rp/ale'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'MaxMEllon/vim-jsx-pretty', {
  \ 'for': 'typescript',
  \ 'autoload': {
  \   'filetypes': ['typescript']
  \ }}
Plug 'prettier/vim-prettier'
Plug 'jparise/vim-graphql'
Plug 'flowtype/vim-flow'
" Initialize plugin system
call plug#end()

" Yggdroot/indentLine
let g:indentLine_color_term = 5

let g:jsx_ext_required = 0

" anzu
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
" set statusline=%{anzu#search_status()}

source ~/.vim/neocomplete.config.vim

"----------------------------------------------------
" Asynchronous Lint Engine (ALE)
"----------------------------------------------------
" Limit linters used for JavaScript.
let g:ale_linters = {
\  'javascript': ['flow', 'eslint'],
\  'python': ['flake8', 'mypy'],
\}
let g:ale_completion_enabled = 1
highlight clear ALEErrorSign " otherwise uses error bg color (typically red)
highlight clear ALEWarningSign " otherwise uses error bg color (typically red)
let g:ale_sign_error = 'X' " could use emoji
let g:ale_sign_warning = '?' " could use emoji
let g:ale_statusline_format = ['X %d', '? %d', '']
" %linter% is the name of the linter that provided the message
" %s is the error or warning message
let g:ale_echo_msg_format = '%linter% says %s'
let g:ale_lint_delay = 700
" Map keys to navigate between lines with errors and warnings.
nnoremap <leader>an :ALENextWrap<cr>
nnoremap <leader>ap :ALEPreviousWrap<cr>

let g:ale_python_flake8_executable = $PWD . 'bin/flake8'

"----------------------------------------------------
" Flow
"----------------------------------------------------
"Use locally installed flow
let local_flow = finddir('node_modules', '.;') . '/.bin/flow'
if matchstr(local_flow, "^\/\\w") == ''
    let local_flow= getcwd() . "/" . local_flow
endif
if executable(local_flow)
  let g:flow#flowpath = getcwd() . "/node_modules/.bin/flow"
endif
let g:flow#showquickfix = 0

let g:javascript_plugin_flow = 1

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

let g:ackprg = 'rg --vimgrep --smart-case'

" incsearch.vim
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-fuzzy-/)
map z/ <Plug>(incsearch-stay)
vmap *  <Plug>(asterisk-g*)

"----------------------------------------------------
" Face
"----------------------------------------------------
autocmd FileType vue syntax sync fromstart
set title
nnoremap j gj
nnoremap k gk
set laststatus=2
set showmatch
set hlsearch
set wildmenu

syntax on
if expand('%') == '.flowconfig'
    set filetype=lisp
endif

set textwidth=0
set nowrap

" Show Full width
match Todo /　/

set t_Co=256

colorscheme elflord

" left のふたつ目が設定できないのできもいけどこれで。
let g:lightline = {
    \ 'colorscheme': 'solarized',
    \ 'active': {
    \   'left': [
    \     [ 'readonly', 'filename', 'modified' ]
    \   ]
    \ },
    \ }

set breakindent

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
nnoremap <Space>pb :.!clp<CR>
nnoremap <Space>pp :.!xclip -o -selection primary<CR>
map <C-c> :w !cl<CR><CR>

"----------------------------------------------------
" Code autocomplete
"----------------------------------------------------

inoremap {<CR> {<CR>}<Up><End><CR>
inoremap z. =>
inoremap zc console.log()<Left>
inoremap zf foreach<Space>()<Space>{<CR>}<Up><End><Left><Left><Left>
inoremap zh <-
" inoremap zi if<Space>()<Space>{<CR>}<Up><End><Left><Left><Left>
inoremap zl ->
inoremap zp extract(\Psy\Shell::debug(get_defined_vars()));
inoremap </ </<C-x><C-o>
inoremap zd <C-r>=strftime("%Y-%m-%d")<CR><Space>
inoremap zt <C-r>=strftime("%H:%M")<CR><Space>
inoremap z[ from IPython import embed; embed()

"----------------------------------------------------
" Remap keys
"----------------------------------------------------

inoremap <S-TAB> <C-d>
inoremap <TAB> <C-t>
" Emacs-like key binding
inoremap <C-a> <Home>
inoremap <C-b> <Left>
inoremap <C-d> <Del>
inoremap <C-e> <End>
inoremap <C-f> <Right>
" キーワード補完には <C-x> <C-n> を使う
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <Down> <C-n>
inoremap <Up> <C-p>

inoremap <C-k> <C-o>:call setline(line('.'), col('.') == 1 ? '' : getline('.')[:col('.') - 2])<CR>

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
nnoremap <Leader><Leader> :<C-p><HOME>
nnoremap <Leader>aw :Ack <C-r><C-w>
nnoremap <Leader>aa :Ack<Space>
nnoremap <Leader>aj :ALEGoToDefinition<CR>
nnoremap <Leader>an :ALENext<CR>
nnoremap <Leader>ap :ALEPrevious<CR>
nnoremap <Leader>bb :Buffers<CR>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>fr :FZFMru<CR>
nnoremap <Leader>fd :e $MYVIMRC<CR>
nnoremap <Leader>fs :w<CR>
nnoremap <Leader>gf :GFiles<CR>
nnoremap <Leader>gd :GitDiff<CR><C-l>
nnoremap <Leader>gb :GitBlame<CR>
nnoremap <Leader>mm :Marks<CR>
nnoremap <Leader>q! :qa!<CR>
nnoremap <Leader>qq :qa<CR>
nnoremap <Leader>pp :Prettier<CR>
nnoremap <Leader>fj :FlowJumpToDef<CR>
nnoremap <Leader>rr :OverCommandLine<CR>%s/
nnoremap <Leader>rl :OverCommandLine<CR>s/
nnoremap <Leader>t/ :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <Leader>t- :new<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <Leader>tt :call fzf#vim#tags(expand('<cword>'))<CR>
nnoremap <Leader>tl :Tlist<CR>
nnoremap <Leader>wd :q<CR>
nnoremap <Leader>wm <C-w><C-w>:q<CR>
nnoremap <Leader>w- :new<CR><C-w><C-w>
nnoremap <Leader>w/ :vs<CR>
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wl <C-w>l
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k
nnoremap <Leader>wo <C-w><C-w>
nnoremap <Leader>jd :NERDTreeFind<CR>
nnoremap <Leader>/ :TComment<CR>
vnoremap <Leader>/ :TComment<CR>

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

"--------------
" Git
"--------------
function! s:git_blame()
    let fileName = '/tmp/__git_blame.'.expand('%:t')
    call system('git blame '.expand('%').' > '.fileName)
    :exe ':e '.fileName
endfunction
command! GitBlame call s:git_blame()

function! s:git_diff()
    call system('git diff '.expand('%').' > /tmp/__git_diff.diff')
    :silent !ccat /tmp/__git_diff.diff | less
endfunction
command! GitDiff call s:git_diff()

"---------------------------------------------------
" Others
"----------------------------------------------------
set nocompatible
set vb t_vb= " do not beep
set hidden " not discard undo after buffers were killed
set ambiwidth=double " for full width problem
set ttimeoutlen=1 " fast move
set modeline

autocmd BufWritePre * :%s/\s\+$//e " remove trairing whitespace on save

" Prettier Too heavy

" when running at every change you may want to disable quickfix
" let g:prettier#quickfix_enabled = 0
" let g:prettier#autoformat = 0
"
" " `PrettierAsync` does not work
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.graphql,*.md,*.vue Prettier

" remember cursor position
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

autocmd FileType vue syntax sync fromstart

set backspace=indent,eol,start

set showcmd

autocmd BufWritePre *.py 0,$!yapf
