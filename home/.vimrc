" vim:set shiftwidth=2 :
"----------------------------------------------------
" vim-plug
"----------------------------------------------------
" filetype off                  " required
" filetype plugin indent off    " required

" set the runtime path to include Vundle and initialize
call plug#begin('~/.vim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'haya14busa/vim-asterisk'
Plug 'easymotion/vim-easymotion'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mileszs/ack.vim'
Plug 'osyo-manga/vim-over'
Plug 'plasticboy/vim-markdown'
Plug 'scrooloose/nerdtree'
Plug 'tomtom/tcomment_vim'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'hashivim/vim-terraform'
Plug 'aklt/plantuml-syntax'

Plug 'ruanyl/vim-gh-line'

Plug 'HerringtonDarkholme/yats.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'acro5piano/vim-graphql'
Plug 'jxnblk/vim-mdx-js'

Plug 'acro5piano/import-js-from-history'

if has('nvim')
  Plug 'rust-lang/rust.vim'
  Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'josa42/vim-lightline-coc'
  " Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' }
  Plug 'mindriot101/vim-yapf'

  " Want to migrate to https://github.com/norcalli/snippets.nvim
  Plug 'SirVer/ultisnips'
endif

" Initialize plugin system
call plug#end()

" vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 0

set incsearch

" Yggdroot/indentLine
let g:indentLine_color_term = 8

let g:jsx_ext_required = 0

" Easy Motion
let g:EasyMotion_do_mapping = 0

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
    \     [ 'readonly', 'filename', 'modified', 'coc_errors', 'coc_warnings' ],
    \   ],
    \ },
    \ }

if has('nvim')
  call lightline#coc#register()
endif

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

inoremap <c-x><c-k> <c-x><c-k>
inoremap <c-x><c-k> <c-x><c-k>

" like Spacemacs
let mapleader = "\<Space>"
nnoremap j gj
nnoremap k gk

nnoremap \| x~f_
nnoremap Q @q
nnoremap <Leader>/ :TComment<CR>
nnoremap <Leader><Leader> :History:<CR>
nnoremap <Leader>aa :Ack<Space>
nnoremap <Leader>ag :Rg <C-r><C-w><CR>


" COC
inoremap <silent><expr> <c-l> coc#refresh()
nmap <Leader>ac :CocAction<CR>
nmap <Leader>ap <Plug>(coc-diagnostic-prev)
nmap <Leader>an <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> <Leader>aj <Plug>(coc-definition)
nmap <silent> <Leader>at <Plug>(coc-type-definition)
nmap <silent> <Leader>am <Plug>(coc-implementation)
nmap <silent> <Leader>ar <Plug>(coc-references)
nmap <silent> <Leader>ah <Plug>(coc-type-definition)
nmap <silent> <Leader>ac :CocAction<CR>

nnoremap <Leader>aw :Ack <C-r><C-w>
nnoremap <Leader>bb :Buffers<CR>
nnoremap <Leader>bd :bp\|bd #<CR>
nnoremap <Leader>jo :Lines <C-R><C-W><CR>
nnoremap <Leader>bt :BTags<CR>
nnoremap <Leader>fj :FlowJumpToDef<CR>
nnoremap <Leader>fr :History<CR>
nnoremap <Leader>h/ :History/<CR>
nnoremap <Leader>fe :e!<CR>
nnoremap <Leader>fs :w<CR>
nnoremap <Leader>ft :set ft=txt<CR>
nnoremap <Leader>fm :set ft=markdown<CR>
nnoremap <Leader>wp :set wrap!<CR>
nnoremap <Leader>gb :GitBlame<CR>
nnoremap <Leader>gl :GitLog10<CR>
nnoremap <Leader>gf :GFilesMonorepo<CR>
nnoremap <Leader>ga :GFiles<CR>
nnoremap <Leader>gs :call fzf#vim#gitfiles('?')<CR><HOME>
nnoremap <Leader>gd :GitDiff<CR>
nnoremap <Leader>ij :ImportJsFZF<CR>
" nnoremap <Leader>ll :Limelight<CR>
nnoremap <Leader>ut :UndotreeToggle<CR>:UndotreeFocus<CR>
nnoremap <Leader>jd :NERDTreeFind<CR>
" nnoremap <Leader>jj :call LanguageClient#textDocument_definition()<CR>
nnoremap <Leader>mm :Marks<CR>
nnoremap <Leader>q! :qa!<CR>
nnoremap <Leader>qq :qa<CR>
nnoremap <Leader>rg :MYRG<CR>
nnoremap <Leader>rl :OverCommandLine<CR>s/
nnoremap <Leader>rr :OverCommandLine<CR>%s/
nnoremap <Leader>sn :Snippets<CR>
nnoremap <Leader>tt :call fzf#vim#tags(expand('<cword>'))<CR><HOME>
nnoremap <Leader>w- :new<CR><C-w><C-w>
nnoremap <Leader>gg :GrepFile<CR>
nnoremap <Leader>w/ :vs<CR>
nnoremap <Leader>wd :q<CR>
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k
nnoremap <Leader>wl <C-w>l
nnoremap <Leader>wm <C-w><C-w>:q<CR>
vnoremap <Leader>/ :TComment<CR>
vnoremap <Leader>jq :!jq --monochrome-output .<CR>

command! -bang -nargs=* MYRG
  \ call fzf#vim#grep(
  \   "rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1,
  \   fzf#vim#with_preview('up', 'ctrl-/'), <bang>0)

" See https://github.com/junegunn/fzf.vim#example-advanced-ripgrep-integration
function! RipgrepFzf(query)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s '
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview('up', spec))
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>)

command! RequireToImport execute("normal 0cwimport<ESC>f=cf(from <ESC>$x0j")
command! TTagnize execute("normal vitS`vitS{at")

nnoremap <ESC><ESC> :nohl<CR>

map <Leader>e <Plug>(easymotion-overwin-w)
map <Leader>l <Plug>(easymotion-overwin-line)

nmap <F1> <ESC>
imap <F1> <ESC>
vmap <F1> <ESC>

"--------------
" FZF customization
"--------------
let g:fzf_layout = {'down': '40%'}

" ported from https://github.com/junegunn/fzf.vim/blob/master/autoload/fzf/vim.vim#L546
function! s:get_git_root()
  let l:root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  if v:shell_error
      return ''
  endif
  return l:root
endfunction

let g:fzf_action = {
  \ 'alt-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let s:preview_bind = join([
    \ '--bind "ctrl-o:execute-silent:nvim-open '.v:servername.' {1} & "',
    \ ])

function! s:gitfiles_monorepo()
  let l:root = s:get_git_root()
  let l:path = substitute(getcwd(), l:root, '', '')
  let l:path = substitute(l:path, '/', '', '')

  let l:options = '-m '.s:preview_bind.' --no-unicode --preview "bat --color=always --style plain {1}" --prompt "GitFiles> " '
  if l:path != ''
    let l:options .= '--query '.l:path.'/'
  endif

  call fzf#run({
  \ 'source':  'git ls-files | uniq',
  \ 'sink': 'e',
  \ 'dir': l:root,
  \ 'options': l:options,
  \ 'down': g:fzf_layout['down'],
  \})
endfunction
command! GFilesMonorepo call s:gitfiles_monorepo()

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
command! GitLog10 call s:git_log_100()

function! s:git_diff()
    let fileName = '/tmp/__git_diff.diff'
    call system('git diff HEAD > '.fileName)
    :exe ':view '.fileName
endfunction
command! GitDiff call s:git_diff()


"---------------------------------------------------
" File alias
"----------------------------------------------------
autocmd BufEnter,BufNew *.json set ft=java
autocmd BufEnter,BufNew *.tera set filetype=html
autocmd BufEnter,BufNew *.toml set filetype=yaml


"---------------------------------------------------
" Others
"----------------------------------------------------
" set nocompatible
set vb t_vb= " do not beep
set hidden " not discard undo after buffers were killed
set ambiwidth=double " for full width problem
set ttimeoutlen=1 " fast move
set modeline

" set undofile
" set undodir=/tmp
" au BufWritePre /tmp/* setlocal noundofile

autocmd BufWritePre * :%s/\s\+$//e " remove trairing whitespace on save

if has('nvim')
    autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.graphql,*.gql,*.md,*.vue Prettier
endif

" remember cursor position
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

autocmd FileType vue syntax sync fromstart

set backspace=indent,eol,start

set showcmd

autocmd BufWritePre *.py Yapf

let g:terraform_fmt_on_save=1
let g:rustfmt_autosave = 1

command! Rubocop !bundle exec rubocop -a %
command! ESLint !yarn eslint --fix %
command! PrettierPhp !yarn prettier --tab-width 4 --write %

command! VSCode !code %
command! VSCodeDir !code %:p:h
filetype plugin on

" For css completion
" autocmd FileType typescript.tsx,typescript,typescriptreact,javascript,javascript.jsx,jsx,tsx setlocal omnifunc=csscomplete#CompleteCSS

au InsertLeave * set nopaste

" https://stackoverflow.com/questions/15277241/changing-vim-gutter-color
highlight SignColumn ctermbg=black
autocmd FileType nerdtree setlocal signcolumn=no
