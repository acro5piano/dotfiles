local my_util = require("my-util")

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("ibhagwan/fzf-lua")
	use("kyazdani42/nvim-web-devicons")
	use("jparise/vim-graphql")
	use("terrortylor/nvim-comment")
	use("nvim-lualine/lualine.nvim")
	use("bronson/vim-visual-star-search")
	use("lambdalisue/fern.vim")
	use("acro5piano/nvim-format-buffer")
	use("neovim/nvim-lspconfig")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-nvim-lsp")
	use("tpope/vim-surround")
	use("dcampos/nvim-snippy")
	use("dcampos/cmp-snippy")
	use("github/copilot.vim")
	use("ruanyl/vim-gh-line")
end)

vim.g.mapleader = " "
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.wrap = false
vim.o.signcolumn = "yes"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.api.nvim_exec("highlight SignColumn ctermbg=black", false)

vim.g["fern#default_hidden"] = 1

-- Restore cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec('silent! normal! g`"zv', false)
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.lua" },
	callback = require("nvim-format-buffer").create_format_fn("stylua -"),
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.py" },
	callback = require("nvim-format-buffer").create_format_fn("yapf"),
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
	callback = require("nvim-format-buffer").create_format_fn("prettier --parser typescript"),
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.css" },
	callback = require("nvim-format-buffer").create_format_fn("prettier --parser css"),
})

-- The reason I added  'opts' as a paraameter is so you can
-- call this function with your own parameters / customizations
-- for example: 'git_files_cwd_aware({ cwd = <another git repo> })'
local function git_files_cwd_aware(opts)
	opts = opts or {}
	local fzf_lua = require("fzf-lua")
	-- git_root() will warn us if we're not inside a git repo
	-- so we don't have to add another warning here, if
	-- you want to avoid the error message change it to:
	-- local git_root = fzf_lua.path.git_root(opts, true)
	local git_root = fzf_lua.path.git_root(opts)
	if not git_root then
		return
	end
	local relative = fzf_lua.path.relative(vim.loop.cwd(), git_root)
	opts.fzf_opts = { ["--query"] = git_root ~= relative and relative .. "/" or nil }
	return fzf_lua.git_files(opts)
end

vim.keymap.set("", "<F1>", "<ESC>")

vim.keymap.set("n", "<C-w><CR>", string.rep("<C-w><C-w>:q<CR>", 3)) -- maps to C-w C-m
vim.keymap.set("n", "<ESC><ESC>", ":nohl<CR>")
vim.keymap.set("n", "gh", vim.lsp.buf.definition)
vim.keymap.set("n", "<Leader>ag", require("fzf-lua").grep_cword)
vim.keymap.set("n", "<Leader>b", require("fzf-lua").buffers)
vim.keymap.set("n", "<Leader>fd", ":Fern %:h<CR>")
vim.keymap.set("n", "<Leader>fe", ":e!<CR>")
vim.keymap.set("n", "<Leader>fr", require("fzf-lua").oldfiles)
vim.keymap.set("n", "<Leader>fs", ":w!<CR>")
vim.keymap.set("n", "<Leader>ga", require("fzf-lua").git_files)
vim.keymap.set("n", "<Leader>gf", git_files_cwd_aware)
vim.keymap.set("n", "<Leader>gg", require("fzf-lua").live_grep)
vim.keymap.set("n", "<Leader>gl", require("fzf-lua").git_bcommits)
vim.keymap.set("n", "<Leader>gs", require("fzf-lua").git_status)
vim.keymap.set("n", "<Leader>la", require("fzf-lua").lsp_code_actions)
vim.keymap.set("n", "<Leader>ld", require("fzf-lua").lsp_document_diagnostics)
vim.keymap.set("n", "<Leader>lw", require("fzf-lua").lsp_workspace_diagnostics)
vim.keymap.set("n", "<Leader>ln", vim.lsp.diagnostic.goto_next)
vim.keymap.set("n", "<Leader>lp", vim.lsp.diagnostic.goto_prev)
vim.keymap.set("n", "<Leader>!", ":qa!<CR>")
vim.keymap.set("n", "<Leader>q", ":qa<CR>")
vim.keymap.set("n", "<Leader><Space>", require("fzf-lua").command_history)
vim.keymap.set("n", "<Leader>wq", ":wq<CR>")
vim.keymap.set("n", "<Leader>x", require("fzf-lua").commands)
vim.keymap.set("n", "Q", "@q")
vim.keymap.set("n", "|", "x~f_")

vim.keymap.set("i", "{<CR>", "{<CR>}<Up><End><CR>")
vim.keymap.set("i", "[<CR>", "[<CR>]<Up><End><CR>")
vim.keymap.set("i", "({<CR>", "({<CR>})<Up><End><CR>")
vim.keymap.set("i", "([<CR>", "([<CR>])<Up><End><CR>")
vim.keymap.set("i", "z.", "=>")
vim.keymap.set("i", "zl", "->")
vim.keymap.set("i", "zc", "console.log()<Left>")
vim.keymap.set("i", "zd", '<C-r>=strftime("%Y-%m-%d")<CR><Space>')
vim.keymap.set("i", "zt", '<C-r>=strftime("%H:%M")<CR><Space>')
vim.keymap.set("i", "zf", "<C-r>=expand('%:t:r')<CR>")
vim.keymap.set("i", "zw", "<C-r>=expand('%:p:h:t')<CR>")

vim.keymap.set("i", "<C-a>", "<Home>")
vim.keymap.set("i", "<C-b>", "<Left>")
vim.keymap.set("i", "<C-d>", "<Del>")
vim.keymap.set("i", "<C-e>", "<End>")
vim.keymap.set("i", "<C-f>", "<Right>")
vim.keymap.set("i", "<C-n>", "<Down>")
vim.keymap.set("i", "<C-p>", "<Up>")

vim.keymap.set("v", "<C-c>", ":w !cl<CR><CR>")
vim.api.nvim_set_keymap("v", "D", 'S<div>$i<ESC>$i className=""<Left>', { noremap = false, silent = true })

require("lualine").setup({
	options = { theme = "gruvbox" },
	sections = {
		lualine_a = { "filename" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {},
		lualine_x = {},
		lualine_y = { "encoding", "fileformat", "filetype" },
		lualine_z = { "location" },
	},
})
require("nvim_comment").setup()

local lsp = require("lspconfig")
lsp.pyright.setup({})
lsp.tsserver.setup({
	handlers = {
		["textDocument/definition"] = function(err, result, method, ...)
			if vim.tbl_islist(result) and #result > 1 then
				local filtered_result = my_util.filter(result, my_util.filter_react_dts)
				return vim.lsp.handlers["textDocument/definition"](err, filtered_result, method, ...)
			end
			vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
		end,
	},
})
lsp.solargraph.setup({})
lsp.sumneko_lua.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "describe" },
			},
		},
	},
})
lsp.rust_analyzer.setup({})

local cmp = require("cmp")
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("snippy").expand_snippet(args.body) -- For `snippy` users.
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{
			name = "buffer",
			options = {
				get_bufnrs = function()
					return vim.api.nvim_list_bufs()
				end,
			},
		},
		{ name = "path" },
		{ name = "cmdline" },
		{ name = "snippy" },
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-l>"] = cmp.mapping.complete(),
	},
})
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "path" },
		{ name = "cmdline" },
	},
})

require("snippy").setup({
	mappings = {
		is = {
			["<C-s>"] = "expand_or_advance",
			["<C-w>"] = "previous", -- maybe I'll never use this mapping
		},
	},
})

UpperFirstLetter = my_util.upper_first_letter
