vim.api.nvim_exec(":source ~/.vimrc", false)

require("packer").startup(function()
	use("wbthomason/packer.nvim")

	use("kyazdani42/nvim-web-devicons")
	use("nvim-lualine/lualine.nvim")
	use("editorconfig/editorconfig-vim")
	use("haya14busa/vim-asterisk")
	use({ "phaazon/hop.nvim", branch = "v1" })
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
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
	use("kyazdani42/nvim-tree.lua")
	use("AckslD/nvim-neoclip.lua")
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })
	use("ckipp01/stylua-nvim") -- requires "pacman -S stylua"
	use("ibhagwan/fzf-lua")
	use("L3MON4D3/LuaSnip")
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
require("nvim-tree").setup({
	view = {
		width = 40,
		signcolumn = "no",
		mappings = {
			custom_only = true,
			list = {
				{ key = "d", action = "remove" },
				{ key = "m", action = "rename" },
				{ key = "c", action = "copy" },
				{ key = "p", action = "paste" },
				{ key = "a", action = "create" },
				{ key = "y", action = "copy_path" },
				{ key = ",", action = "dir_up" },
				{ key = ".", action = "cd" },
				{ key = "u", action = "parent_node" },
				{ key = "o", action = "system_open" },
				{ key = { "<CR>" }, action = "edit" },
				{ key = "P", action = "parent_node" },
				{ key = "<Tab>", action = "preview" },
				{ key = "I", action = "toggle_git_ignored" },
				{ key = "H", action = "toggle_dotfiles" },
				{ key = "[", action = "prev_sibling" },
				{ key = "]", action = "next_sibling" },
			},
		},
	},
})

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

local normal_keymap = {
	["<Leader>e"] = "<cmd>HopWordMW<cr>",
	["<Leader>gd"] = "<cmd>DiffviewOpen<cr>",
	["<Leader>td"] = ":tabclose<cr>",
	["<Leader>ga"] = "<cmd>require('fzf-lua').git_files()<cr>",
	["<Leader>gg"] = "<cmd>lua require('fzf-lua').live_grep()<cr>",
	["<Leader>ag"] = "<cmd>lua require('fzf-lua').grep_cword()<cr>",
	["<Leader>j"] = "<cmd>NvimTreeFindFile<cr>",
	["<Leader>b"] = "<cmd>lua require('fzf-lua').buffers()<cr>",
	["<Leader>k"] = ":bp|bd #<CR>",
	["<Leader>t"] = "<cmd>lua require('fzf-lua').resume()<cr>",
	["<Leader>fr"] = "<cmd>lua require('fzf-lua').oldfiles()<cr>",
	["<Leader><Space>"] = "<cmd>lua require('fzf-lua').command_history()<cr>",
	["<Leader>c"] = "<cmd>lua require('fzf-lua').commands()<cr>",
	["<C-w><C-k>"] = ":q<CR>",
	["<C-w><CR>"] = "<C-w><C-w>:q<CR>", -- maps to C-w C-m
	["<C-w>/"] = ":vsplit<CR><C-w><C-w><C-6><C-w><C-w>",
	["<C-w>-"] = ":new<CR><C-6><C-w><C-w>",
}

for key, value in pairs(normal_keymap) do
	vim.api.nvim_set_keymap("n", key, value, { noremap = false, silent = true })
end

vim.g.nvim_tree_highlight_opened_files = true

local function regexEscape(str)
	return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end
local function get_working_path_from_git_root()
	local handle = io.popen("git rev-parse --show-toplevel")
	local root = handle:read("*a"):gsub("\n", "")
	handle:close()
	current_dir = os.getenv("PWD")
	return current_dir:gsub(regexEscape(root), ""):gsub("^/", "")
end
vim.api.nvim_set_keymap("n", "<Leader>gf", "", {
	noremap = true,
	silent = true,
	callback = function()
		local relative_path = get_working_path_from_git_root()
		if relative_path == "" then
			require("fzf-lua").git_files()
		else
			require("fzf-lua").git_files({ fzf_opts = { ["--query"] = relative_path } })
		end
	end,
})

vim.api.nvim_set_keymap("n", "<Leader>pp", "", {
	noremap = true,
	silent = true,
	callback = function()
		require("telescope").extensions.neoclip.default()
	end,
})

vim.g.terraform_fmt_on_save = true
vim.g.rustfmt_autosave = true
