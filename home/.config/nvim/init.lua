local os = require("os")

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("ibhagwan/fzf-lua")
	use("kyazdani42/nvim-web-devicons")
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
	use("ruanyl/vim-gh-line")
	use("kyoh86/vim-ripgrep")
	use("gpanders/editorconfig.nvim")
	use("aklt/plantuml-syntax")
	use("preservim/vim-markdown")
	use("phaazon/hop.nvim")
	use("windwp/nvim-ts-autotag")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("goolord/alpha-nvim")
	use("lukas-reineke/cmp-rg")
	use("gbprod/yanky.nvim")
	use("stevearc/dressing.nvim") -- for yanky to work nicely
	use("monaqa/dial.nvim")
	use("marko-cerovac/material.nvim") -- Material theme which supports treesitter
	use("onsails/lspkind.nvim")
	use("Vonr/align.nvim")
	use("/home/kazuya/ghq/github.com/acro5piano/cmp-mozc")

	-- use("github/copilot.vim")
	-- use("zbirenbaum/copilot.lua")
	-- use("zbirenbaum/copilot-cmp")
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
vim.o.completeopt = "menu,menuone,noselect"
vim.o.mouse = false
vim.o.cedit = "<C-q>"

vim.g.material_style = "darker"
require("material").setup({
	disable = {
		background = true, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
	},
	high_visibility = {
		lighter = true, -- Enable higher contrast text for lighter style
		darker = true, -- Enable higher contrast text for darker style
	},
})
vim.cmd("colorscheme material")

vim.g["fern#default_hidden"] = 1

-- Restore cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec('silent! normal! g`"zv', false)
	end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec('silent! normal! g`"zv', false)
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec(":%s/ \\+$//e", false)
	end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "Podfile", "Appfile", "Matchfile", "Fastfile" },
	callback = function()
		vim.api.nvim_exec("setlocal ft=ruby", false)
	end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "quickfix" },
	callback = function()
		vim.keymap.set("n", "p", "<CR>zz<C-w>p", { buffer = true })
		vim.keymap.set("n", "P", "<CR>zz<C-w>pj", { buffer = true })
	end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "*.gql", "*.graphql" },
	callback = function()
		vim.keymap.set(
			"n",
			"gh",
			"/\\(\\(type\\)\\|\\(input\\)\\|\\(enum\\)\\|\\(scalar\\)\\) <C-r><C-w>[\\n| ]<CR>:nohl<CR>",
			{ buffer = true }
		)
		vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
	end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "*.md" },
	callback = function()
		vim.api.nvim_exec(":set wrap", false)
	end,
})

local function has(command)
	local handle = io.popen("which " .. command)
	if handle == nil then
		return false
	end
	local result = handle:read("*a")
	handle:close()
	return string.find(result, "/") ~= nil
end

-- WARNING: This could be a perfomance bottleneck. Keep it in mind.
if has("fcitx5-remote") then
	vim.api.nvim_create_autocmd({ "InsertLeave" }, {
		pattern = { "*" },
		callback = function()
			os.execute("fcitx5-remote -c")
		end,
	})
end

local function prettier_bin()
	local bin = vim.fn.findfile("node_modules/.bin/prettier", vim.fn.getcwd() .. ";")
	if bin == "" then
		return "prettier"
	end
	return bin
end

require("nvim-format-buffer").setup({
	format_rules = {
		{ pattern = { "*.lua" }, command = "stylua -" },
		{ pattern = { "*.py" }, command = "black -q - | isort -" },
		{
			pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.mjs", "*.mts" },
			command = prettier_bin() .. " --parser typescript 2>/dev/null",
		},
		{ pattern = { "*.md" }, command = prettier_bin() .. " --parser markdown 2>/dev/null | perl -pe 's/\\t/  /g'" },
		{ pattern = { "*.css" }, command = prettier_bin() .. " --parser css" },
		{ pattern = { "*.graphql" }, command = prettier_bin() .. " --parser graphql" },
		{ pattern = { "*.rs" }, command = "rustfmt --edition 2021" },
		{ pattern = { "*.sql" }, command = "sql-formatter --config ~/sql-formatter.json" }, -- requires `npm -g i sql-formatter`
		{ pattern = { "*.tf" }, command = "terraform fmt -" },
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
-- vim.keymap.set("n", "g/", fzf_lua.blines)
vim.keymap.set("n", "g/", fzf_lua.lines) -- experimental: try something new!
vim.keymap.set("n", "gp", ":YankyRingHistory<CR>")
vim.keymap.set("n", "gm", fzf_lua.lsp_definitions)
vim.keymap.set("n", "<Leader>aa", ":Ripgrep ")
vim.keymap.set("n", "<Leader>ag", fzf_lua.grep_cword)
vim.keymap.set("n", "<Leader>ai", function()
	fzf_lua.grep_cword({ query = "import" })
end)
vim.keymap.set("n", "<Leader>aw", ":Ripgrep <C-r><C-w>")
vim.keymap.set("n", "<Leader>b", fzf_lua.buffers)
-- vim.keymap.set("n", "<Leader>b", ":b <TAB>")
vim.keymap.set("n", "<Leader>fe", ":e!<CR>")
vim.keymap.set("n", "<Leader>fl", fzf_lua.quickfix)
vim.keymap.set("n", "<Leader>fr", fzf_lua.oldfiles)
vim.keymap.set("n", "<Leader>fs", ":w!<CR>")
vim.keymap.set("n", "<Leader>fn", ":Fern %:h<CR>")
vim.keymap.set("n", "<Leader>ga", fzf_lua.git_files)
vim.keymap.set("n", ",", ":HopWord<CR>")
vim.keymap.set("n", "<Leader>gf", git_files_cwd_aware)
vim.keymap.set("n", "<Leader>gg", fzf_lua.live_grep)
vim.keymap.set("n", "<Leader>gl", fzf_lua.git_bcommits)
vim.keymap.set("n", "<Leader>gs", fzf_lua.git_status)
vim.keymap.set("n", "<Leader>la", fzf_lua.lsp_code_actions)
vim.keymap.set("n", "<Leader>ld", fzf_lua.lsp_document_diagnostics)
vim.keymap.set("n", "<Leader>lh", vim.lsp.buf.hover)
vim.keymap.set("n", "<Leader>ln", vim.diagnostic.goto_next)
vim.keymap.set("n", "<Leader>lp", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<Leader>lw", fzf_lua.lsp_workspace_diagnostics)
vim.keymap.set("n", "<Leader>li", vim.diagnostic.open_float)
vim.keymap.set("n", "<Leader>pb", ":.!clp<CR>")
vim.keymap.set("n", "<Leader>wp", ":set wrap!<CR>")
vim.keymap.set("n", "<Leader>!", ":qa!<CR>")
vim.keymap.set("n", "<Leader>q", ":qa<CR>")
vim.keymap.set("n", "<Leader>rl", ":s/")
vim.keymap.set("n", "<Leader>rr", ":%s/")
vim.keymap.set("n", "<Leader><Space>", fzf_lua.command_history)
vim.keymap.set("n", "<Leader>wq", ":wq<CR>")
vim.keymap.set({ "n", "v" }, "<Leader>/", ":CommentToggle<CR>")
vim.keymap.set("n", "<Leader>x", fzf_lua.commands)
vim.keymap.set("n", "Q", "@q") -- qq to record, Q to replay
vim.keymap.set("n", "|", "x~f_")
vim.keymap.set("n", "<Backspace>", ":Fern %:h<CR>")
vim.keymap.set("n", "<C-S-G>", ':let @+=fnamemodify(expand("%"), ":~:.")<CR> | :echo "filepath copied!"<CR>')

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

-- indent with Tab/S-tab
vim.keymap.set("i", "<S-Tab>", "<C-d>", { noremap = false })
vim.keymap.set("i", "<Tab>", "<C-t>", { noremap = false })

-- emacs-like key bindings
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>")
vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>")
vim.keymap.set({ "i", "c" }, "<C-d>", "<Del>")
vim.keymap.set({ "i", "c" }, "<C-e>", "<End>")
vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>")
vim.keymap.set("c", "<C-n>", "<Down>")
vim.keymap.set("c", "<C-p>", "<Up>")
vim.keymap.set("i", "<C-n>", "<C-c>gja")
vim.keymap.set("i", "<C-p>", "<C-c>gka")
vim.keymap.set("i", "<C-k>", "<C-c>lC")

vim.keymap.set("c", "<C-k>", "<C-\\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>")
vim.keymap.set("c", "<C-g>", "<C-f>")

vim.keymap.set("v", "<Leader>ag", fzf_lua.grep_visual)
vim.keymap.set("v", "<C-c>", ":w !cl<CR><CR>")
vim.api.nvim_set_keymap("v", "B", "S*gvS*", { noremap = false, silent = true })
vim.api.nvim_set_keymap("v", "D", 'S<div>$i<ESC>$i className=""<Left>', { noremap = false, silent = true })
vim.keymap.set("v", ",", require("hop").hint_words)

-- Aligns to a string, looking left and with previews
vim.keymap.set("x", "a", function()
	require("align").align_to_string(true, false, true)
end, { noremap = false, silent = true })

vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal())
vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal())
vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual())
vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual())

local augend = require("dial.augend")
require("dial.config").augends:register_group({
	default = {
		augend.integer.alias.decimal,
		augend.integer.alias.hex,
		augend.date.alias["%Y/%m/%d"],
		augend.date.alias["%Y-%m-%d"],
		augend.date.alias["%H:%M"],
		augend.constant.new({
			elements = { "or", "and" },
			word = true,
			cyclic = false,
		}),
		augend.constant.new({
			elements = { "||", "&&" },
			word = false,
			cyclic = false,
		}),
	},
})

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

-- This handler function forces to select the first element of lsp definitions if multiple candidates exist.
-- Without this, nvim-cmp shows a quickfix list to select a code position to jump, which is really annoying.
local shrink_lsp_definition_result = function(err, result, method, ...)
	if vim.tbl_islist(result) and #result > 1 then
		return vim.lsp.handlers["textDocument/definition"](err, { result[1] }, method, ...)
	end
	vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
end

local lsp = require("lspconfig")
lsp.pyright.setup({})
lsp.tsserver.setup({
	handlers = {
		["textDocument/definition"] = shrink_lsp_definition_result,
	},
})
lsp.solargraph.setup({
	settings = {
		solargraph = {
			diagnostics = false,
		},
	},
})
require("lspconfig").lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
	handlers = {
		["textDocument/definition"] = shrink_lsp_definition_result,
	},
})
lsp.rust_analyzer.setup({})
lsp.terraformls.setup({})
lsp.graphql.setup({
	filetypes = { "graphql", "typescript", "typescriptreact", "javascriptreact" },
})

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
		-- { name = "cmdline" },
		{ name = "snippy" },
		{
			name = "rg",
			keyword_length = 3,
		},
		{
			name = "mozc",
			keyword_length = 3,
		},
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-l>"] = cmp.mapping.complete(),
		["<C-j>"] = cmp.mapping.confirm({ select = true }), -- To enable auto-import
	},
	formatting = {
		format = require("lspkind").cmp_format({
			mode = "text_symbol",
			maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

			-- The function below will be called before any actual modifications from lspkind
			-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
			before = function(_, vim_item)
				return vim_item
			end,
		}),
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
			-- Do not delete this empty block!
			-- or, fzf-lua don't respect fzf built-in keymap for c-f and c-b.
		},
	},
	grep = {
		rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512 --hidden",
	},
	previewers = {
		git_diff = {
			pager = "delta --true-color=never", -- I don't know why, but --true-color=never is needed in nvim + tmux environment
		},
	},
})

require("hop").setup()

require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	highlight = { enable = true },
	indent = { enable = true },
	autotag = { enable = true },
})

require("nvim-ts-autotag").setup()

-- used in snippet
UpperFirstLetter = my_util.upper_first_letter

require("alpha").setup(require("alpha.themes.startify").config)
require("yanky").setup({
	highlight = {
		on_put = false,
		on_yank = false,
	},
})
