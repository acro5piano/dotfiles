vim.api.nvim_exec(':source ~/.vimrc', false)

require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use 'editorconfig/editorconfig-vim'
  use 'haya14busa/vim-asterisk'
  use 'easymotion/vim-easymotion'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

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
  use 'mindriot101/vim-yapf'
  use 'SirVer/ultisnips'
  use {
    "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
      }
    }
  use {
    "AckslD/nvim-neoclip.lua",
    requires = {
      {'nvim-telescope/telescope.nvim'},
    },
    config = function()
      require('neoclip').setup()
    end
  }
end)

require('neoclip').setup()
require('lualine').setup()

local actions = require("telescope.actions")
require("telescope").setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
  }
}

vim.api.nvim_set_keymap('n', '<Leader>gg', '<cmd>Telescope live_grep<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>gf', '<cmd>Telescope git_files<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>ag', '<cmd>Telescope grep_string<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>bb', '<cmd>Telescope buffers show_all_buffers=true sort_lastused=true default_selection_index=2 <cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>tr', '<cmd>Telescope resume<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fr', '<cmd>Telescope oldfiles<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader><Space>', '<cmd>Telescope command_history<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>pp', '', { noremap = true, silent = true , callback = function()
  require('telescope').extensions.neoclip.default()
end})
