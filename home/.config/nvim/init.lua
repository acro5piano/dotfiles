-- local use = vim.fn['use']
--
-- vim.call('plug#begin', '~/.config/nvim/plugged')
--
--
-- -- use
--
-- vim.call('plug#end')

vim.api.nvim_set_keymap('n', '<Space>qq', ':q<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Space>q!', ':q!CR>', { noremap = true })

require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'itchyny/lightline.vim'
  use 'editorconfig/editorconfig-vim'
  use 'haya14busa/vim-asterisk'
  use 'easymotion/vim-easymotion'
  use { 'junegunn/fzf', run = function () vim.fn['fzf#install']() end }
  use 'junegunn/fzf.vim'
  use 'junegunn/vim-easy-align'
  use 'mileszs/ack.vim'
  use 'osyo-manga/vim-over'
  use 'plasticboy/vim-markdown'
  use 'scrooloose/nerdtree'
  use 'tomtom/tcomment_vim'
  use 'Yggdroot/indentLine'
  use 'tpope/vim-surround'
  use 'tpope/vim-fugitive'
  use 'hashivim/vim-terraform'
  use 'aklt/plantuml-syntax'
  use 'ruanyl/vim-gh-line'
  use 'HerringtonDarkholme/yats.vim'
  use 'MaxMEllon/vim-jsx-pretty'
  use 'acro5piano/vim-graphql'
  use 'jxnblk/vim-mdx-js'
  use 'acro5piano/import-js-from-history'
  use 'rust-lang/rust.vim'
  use { 'prettier/vim-prettier', run = 'yarn install' }
  use { 'neoclide/coc.nvim', branch = 'release'}
  use 'josa42/vim-lightline-coc'
  use 'mindriot101/vim-yapf'
  use 'SirVer/ultisnips'
  -- use { 'fatih/vim-go', run = ':GoUpdateBinaries' }
end)


vim.api.nvim_exec(':source ~/.vimrc', false)
