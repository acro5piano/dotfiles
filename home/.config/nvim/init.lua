local os = require("os")

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
	use("kyoh86/vim-ripgrep")
	use("gpanders/editorconfig.nvim")
	use("aklt/plantuml-syntax")
	use("preservim/vim-markdown")
end)

local my_util = require("my-util")

vim.g.mapleader = " "
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.wrap = false
vim.o.signcolumn = "yes"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.foldenable = false
vim.api.nvim_exec("highlight SignColumn ctermbg=black", false)

vim.g["fern#default_hidden"] = 1

-- Restore cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec('silent! normal! g`"zv', false)
	end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "*.fish" },
	callback = function()
		vim.api.nvim_exec("setlocal ft=graphql", false)
	end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "quickfix" },
	callback = function()
		vim.keymap.set("n", "p", "<CR>zz<C-w>p", { buffer = true })
		vim.keymap.set("n", "P", "<CR>zz<C-w>pj", { buffer = true })
	end,
})

-- WARNING: This could be a perfomance bottleneck. Keep it in mind.
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
	pattern = { "*" },
	callback = function()
		os.execute("fcitx5-remote -c")
	end,
})

require("nvim-format-buffer").setup({
	format_rules = {
		{ pattern = { "*.lua" }, command = "stylua -" },
		{ pattern = { "*.py" }, command = "black -q - | isort -" },
		{
			pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.mjs", "*.mts" },
			command = "prettier --parser typescript 2>/dev/null",
		},
		{ pattern = { "*.md" }, command = "prettier --parser markdown 2>/dev/null" },
		{ pattern = { "*.md" }, command = "prettier --parser markdown 2>/dev/null" },
		-- { pattern = { "*.html" }, command = "prettier --parser html 2>/dev/null" },
		{ pattern = { "*.css" }, command = "prettier --parser css" },
		{ pattern = { "*.rs" }, command = "rustfmt --edition 2021" },
		{ pattern = { "*.sql" }, command = "sql-formatter --config ~/sql-formatter.json" }, -- requires `npm -g i sql-formatte`
	},
})

local fzf_lua = require("fzf-lua")

-- The reason I added  'opts' as a paraameter is so you can
-- call this function with your own parameters / customizations
-- for example: 'git_files_cwd_aware({ cwd = <another git repo> })'
local function git_files_cwd_aware(opts)
	opts = opts or {}
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

-- TODO: make this to lua
vim.api.nvim_exec("command! -nargs=+ -complete=file Ripgrep :call ripgrep#search(<q-args>)", false)

vim.keymap.set("", "<F1>", "<ESC>")
vim.keymap.set("i", "<F1>", "<ESC>")

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<C-w><CR>", string.rep("<C-w><C-w>:q<CR>", 3)) -- maps to C-w C-m
vim.keymap.set("n", "<C-w>/", ":vsplit<CR><C-w><C-l>")
vim.keymap.set("n", "<ESC><ESC>", ":nohl<CR>")
vim.keymap.set("n", "gh", vim.lsp.buf.definition)
vim.keymap.set("n", "g/", fzf_lua.blines)
vim.keymap.set("n", "<Leader>aa", ":Ripgrep ")
vim.keymap.set("n", "<Leader>ag", fzf_lua.grep_cword)
vim.keymap.set("n", "<Leader>aw", ":Ripgrep <C-r><C-w>")
vim.keymap.set("n", "<Leader>b", fzf_lua.buffers)
vim.keymap.set("n", "<Leader>fe", ":e!<CR>")
vim.keymap.set("n", "<Leader>fl", fzf_lua.quickfix)
vim.keymap.set("n", "<Leader>fr", fzf_lua.oldfiles)
vim.keymap.set("n", "<Leader>fs", ":w!<CR>")
vim.keymap.set("n", "<Leader>ga", fzf_lua.git_files)
vim.keymap.set("n", "<Leader>gf", git_files_cwd_aware)
vim.keymap.set("n", "<Leader>gg", fzf_lua.live_grep)
vim.keymap.set("n", "<Leader>gl", fzf_lua.git_bcommits)
vim.keymap.set("n", "<Leader>gs", fzf_lua.git_status)
vim.keymap.set("n", "<Leader>la", fzf_lua.lsp_code_actions)
vim.keymap.set("n", "<Leader>ld", fzf_lua.lsp_document_diagnostics)
vim.keymap.set("n", "<Leader>lh", vim.lsp.buf.hover)
vim.keymap.set("n", "<Leader>ln", vim.lsp.diagnostic.goto_next)
vim.keymap.set("n", "<Leader>lp", vim.lsp.diagnostic.goto_prev)
vim.keymap.set("n", "<Leader>lw", fzf_lua.lsp_workspace_diagnostics)
vim.keymap.set("n", "<Leader>li", vim.lsp.diagnostic.show_line_diagnostics)
vim.keymap.set("n", "<Leader>pb", ":.!clp<CR>")
vim.keymap.set("n", "<Leader>wp", ":set wrap!<CR>")
vim.keymap.set("n", "<Leader>!", ":qa!<CR>")
vim.keymap.set("n", "<Leader>q", ":qa<CR>")
vim.keymap.set("n", "<Leader>rl", ":s/")
vim.keymap.set("n", "<Leader>rr", ":%s/")
vim.keymap.set("n", "<Leader><Space>", fzf_lua.command_history)
vim.keymap.set("n", "<Leader>wq", ":wq<CR>")
vim.keymap.set("n", "<Leader>x", fzf_lua.commands)
vim.keymap.set("n", "Q", "@q")
vim.keymap.set("n", "|", "x~f_")
vim.keymap.set("n", "<Backspace>", ":Fern %:h<CR>")

vim.keymap.set("i", "{<CR>", "{<CR>}<Up><End><CR>")
vim.keymap.set("i", "[<CR>", "[<CR>]<Up><End><CR>")
-- vim.keymap.set("i", "({<CR>", "({<CR>})<Up><End><CR>") -- it prevents nvim-cmp to insert ()
-- vim.keymap.set("i", "([<CR>", "([<CR>])<Up><End><CR>") -- it prevents nvim-cmp to insert ()
vim.keymap.set("i", "z.", "=>")
vim.keymap.set("i", "zl", "->")
vim.keymap.set("i", "zc", "console.log()<Left>")
vim.keymap.set("i", "zd", '<C-r>=strftime("%Y-%m-%d")<CR><Space>')
vim.keymap.set("i", "zt", '<C-r>=strftime("%H:%M")<CR><Space>')
vim.keymap.set("i", "zf", "<C-r>=expand('%:t:r')<CR>")
vim.keymap.set("i", "zw", "<C-r>=expand('%:p:h:t')<CR>")
vim.keymap.set("i", "<Down>", "<C-n>")
vim.keymap.set("i", "<Up>", "<C-p>")

-- indent with Tab/S-tab
vim.keymap.set("i", "<S-Tab>", "<C-d>", { noremap = false })
vim.keymap.set("i", "<Tab>", "<C-t>", { noremap = false })

-- emacs-like key bindings
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>")
vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>")
vim.keymap.set({ "i", "c" }, "<C-d>", "<Del>")
vim.keymap.set({ "i", "c" }, "<C-e>", "<End>")
vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>")
vim.keymap.set({ "i", "c" }, "<C-n>", "<Down>")
vim.keymap.set({ "i", "c" }, "<C-p>", "<Up>")
vim.keymap.set("i", "<C-k>", "<C-c>lC")

vim.keymap.set("c", "<C-k>", "<C-\\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>")
vim.keymap.set("c", "<C-g>", "<C-f>")

vim.keymap.set("v", "<Leader>ag", fzf_lua.grep_visual)
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
		expand = function(args)
			require("snippy").expand_snippet(args.body) -- For `snippy` users.
		end,
	},
	preselect = cmp.PreselectMode.None, -- https://github.com/hrsh7th/nvim-cmp/issues/355#issuecomment-944910279
	sources = {
		{ name = "nvim_lsp" },
		{
			name = "buffer",
			options = {
				get_bufnrs = vim.api.nvim_list_bufs,
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

fzf_lua.setup({
	winopts = {
		height = 0.9, -- window height
		width = 0.9, -- window width
		hl = { border = "Normal" },
	},
	keymap = {
		fzf = {
			-- fzf '--bind=' options
			-- If we have empty table here, fzf-lua respects fzf built-in keymap for c-f and c-b.
		},
	},
	previewers = {
		git_diff = {
			pager = "delta --true-color=never", -- I don't know why, but --true-color=never is needed in nvim + tmux environment
		},
	},
})

-- used in snippet
UpperFirstLetter = my_util.upper_first_letter

-- vim.keymap.set("n", "<Leader>fd", require("explorer").reveal)
