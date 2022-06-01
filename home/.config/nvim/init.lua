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
	use("github/copilot.vim")
	use("digitaltoad/vim-pug")
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
			custom_only = false,
			list = {
				{ key = "d", action = "remove" },
				{ key = "m", action = "rename" },
				{ key = "c", action = "copy" },
				{ key = "p", action = "paste" },
				{ key = "a", action = "create" },
				{ key = ",", action = "dir_up" },
				{ key = ".", action = "cd" },
				{ key = "u", action = "parent_node" },
				{ key = "o", action = "system_open" },
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
	["<Leader>ag"] = "<cmd>lua require('fzf-lua').grep_cword()<cr>",
	["<Leader>b"] = "<cmd>lua require('fzf-lua').buffers()<cr>",
	["<Leader>fr"] = "<cmd>lua require('fzf-lua').oldfiles()<cr>",
	["<Leader>ga"] = "<cmd>require('fzf-lua').git_files()<cr>",
	["<Leader>d"] = "<cmd>lua require('fzf-lua').git_status()<cr>",
	["<Leader>gg"] = "<cmd>lua require('fzf-lua').live_grep()<cr>",
	["<Leader>j"] = "<cmd>NvimTreeFindFile<cr>",
	["<Leader>k"] = ":bp|bd #<CR>",
	["<Leader>lr"] = "<cmd>lua require('fzf-lua').resume()<cr>",
	["<Leader>td"] = ":tabclose<cr>",
	["<Leader>ac"] = "<Plug>(coc-codeaction-cursor)",
	["<Leader><Space>"] = "<cmd>lua require('fzf-lua').command_history()<cr>",
	["<M-x>"] = "<cmd>lua require('fzf-lua').commands()<cr>",
	["<C-w><C-k>"] = ":q<CR>",
	["<C-w><CR>"] = string.rep("<C-w><C-w>:q<CR>", 3), -- maps to C-w C-m
	["<C-w>/"] = ":vsplit<CR><C-w><C-l><C-6><C-w><C-h>",
	["<C-w><C-n>"] = ":vsplit<CR><C-w><C-l><C-6><C-w><C-h>",
	["<C-w>-"] = ":new<CR><C-6><C-w><C-w>",
}

for key, value in pairs(normal_keymap) do
	vim.api.nvim_set_keymap("n", key, value, { noremap = false, silent = true })
end

local insert_keymap = {
	["<c-u>"] = "<cmd>lua require('luasnip').jump(-1)<Cr>",
}

for key, value in pairs(insert_keymap) do
	vim.api.nvim_set_keymap("i", key, value, { noremap = false, silent = true })
	vim.api.nvim_set_keymap("s", key, value, { noremap = false, silent = true })
end

local visual_keymap = {
	["D"] = "S<div>", -- sarround with <div>
}

for key, value in pairs(visual_keymap) do
	vim.api.nvim_set_keymap("v", key, value, { noremap = false, silent = true })
end

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
vim.api.nvim_set_keymap("n", "<Leader>o", "", {
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

require("fzf-lua").setup({
	winopts = {
		height = 0.9, -- window height
		width = 0.95, -- window width
	},
	keymap = {
		builtin = {
			["<C-k>"] = "preview-page-up",
			["<C-j>"] = "preview-page-down",
		},
		fzf = {
			["ctrl-k"] = "preview-page-up",
			["ctrl-j"] = "preview-page-down",
		},
	},
	previewers = {
		git_diff = {
			pager = "delta --true-color=never", -- I don't know why, but --true-color=never is needed in nvim + tmux environment
		},
	},
})

vim.api.nvim_create_user_command("NeoClipPick", function(opts)
	require("telescope").extensions.neoclip.default()
end, {})

vim.g.terraform_fmt_on_save = true
vim.g.rustfmt_autosave = true

require("snippets")
