vim.api.nvim_exec(":source ~/.vimrc", false)

require("packer").startup(function()
	use("wbthomason/packer.nvim")

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	use("editorconfig/editorconfig-vim")
	use("haya14busa/vim-asterisk")
	use({
		"phaazon/hop.nvim",
		branch = "v1", -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
		end,
	})
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use("junegunn/fzf.vim")
	use("junegunn/vim-easy-align")
	use("mileszs/ack.vim")
	use("osyo-manga/vim-over")
	use("plasticboy/vim-markdown")
	use("tomtom/tcomment_vim")
	use("Yggdroot/indentLine")
	use("tpope/vim-surround")
	use("tpope/vim-fugitive")
	use("hashivim/vim-terraform")
	use("aklt/plantuml-syntax")
	use("ruanyl/vim-gh-line")
	use("HerringtonDarkholme/yats.vim")
	use("MaxMEllon/vim-jsx-pretty")
	use("acro5piano/vim-graphql")
	use("acro5piano/import-js-from-history")
	use("rust-lang/rust.vim")
	use({ "prettier/vim-prettier", run = "yarn install" })
	use({ "neoclide/coc.nvim", branch = "release" })
	use("mindriot101/vim-yapf")
	use("SirVer/ultisnips")
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
	})
	use({
		"AckslD/nvim-neoclip.lua",
		requires = {
			{ "nvim-telescope/telescope.nvim" },
			{ "tami5/sqlite.lua", module = "sqlite" },
		},
	})
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })
	use({ "ckipp01/stylua-nvim" }) -- requires "pacman -S stylua"
end)

require("neoclip").setup({
	keys = {
		telescope = {
			i = {
				paste = "<cr>",
			},
		},
	},
})
require("lualine").setup()
require("nvim-tree").setup()

local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<esc>"] = actions.close,
			},
		},
	},
})

require("hop").setup()

vim.api.nvim_set_keymap("n", "<Leader>e", "<cmd>HopWordMW<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>gd", "<cmd>DiffviewOpen<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>td", ":tabclose<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>gf", "<cmd>GFilesMonorepo<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>gg", "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>ag", "<cmd>Telescope grep_string<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>jd", "<cmd>NvimTreeFindFile<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>bb", "<cmd>Buffers<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>tr", "<cmd>Telescope resume<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>fr", "<cmd>Telescope oldfiles<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader><Space>", "<cmd>Telescope command_history<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>pp", "", {
	noremap = true,
	silent = true,
	callback = function()
		require("telescope").extensions.neoclip.default()
	end,
})

vim.g.terraform_fmt_on_save = true
vim.g.rustfmt_autosave = true
