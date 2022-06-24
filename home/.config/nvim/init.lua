vim.g.mapleader = " "

require("packer").startup(function()
	use("wbthomason/packer.nvim")
	use("ibhagwan/fzf-lua")
	use("kyazdani42/nvim-web-devicons")
	use("ckipp01/stylua-nvim") -- requires "pacman -S stylua"
	use("jparise/vim-graphql")
	use("terrortylor/nvim-comment")
	use("nvim-lualine/lualine.nvim")
	use("bronson/vim-visual-star-search")
end)

vim.o.tabstop = 2
vim.o.wrap = false
vim.o.signcolumn = "yes"
vim.g.netrw_liststyle = 3
vim.api.nvim_exec("highlight SignColumn ctermbg=black", false)

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.lua" },
	callback = require("stylua-nvim").format_file,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "netrw" },
	callback = function()
		vim.keymap.set("n", "<C-o>", ":Rex<CR>", { buffer = true })
	end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec('silent! normal! g`"zv', false)
	end,
})

vim.keymap.set("", "<F1>", "<ESC>")

vim.keymap.set("n", "<C-w><CR>", string.rep("<C-w><C-w>:q<CR>", 3)) -- maps to C-w C-m
vim.keymap.set("n", "|", "x~f_")
vim.keymap.set("n", "Q", "@q")
vim.keymap.set("n", "<Leader>k", require("fzf-lua").git_status)
vim.keymap.set("n", "<ESC><ESC>", ":nohl<CR>")
vim.keymap.set("n", "<Leader>ag", require("fzf-lua").grep_cword)
vim.keymap.set("n", "<Leader>bd", ":bp|bd #<CR>")
vim.keymap.set("n", "<Leader>bl", require("fzf-lua").buffers)
vim.keymap.set("n", "<Leader>fe", ":e!<CR>")
vim.keymap.set("n", "<Leader>fr", require("fzf-lua").oldfiles)
vim.keymap.set("n", "<Leader>fs", ":w!<CR>")
vim.keymap.set("n", "<Leader>fd", ":Explore<CR>")
vim.keymap.set("n", "<Leader>ga", require("fzf-lua").git_files)
vim.keymap.set("n", "<Leader>gf", require("fzf-lua").git_files)
vim.keymap.set("n", "<Leader>gg", require("fzf-lua").live_grep)
vim.keymap.set("n", "<Leader>gl", require("fzf-lua").git_bcommits)
vim.keymap.set("n", "<Leader>gs", require("fzf-lua").git_status)
vim.keymap.set("n", "<Leader>q", ":qa<CR>")
vim.keymap.set("n", "<Leader>wq", ":wq<CR>")
vim.keymap.set("n", "<Leader>x", require("fzf-lua").commands)
vim.keymap.set("n", "<Leader>!", ":qa!<CR>")
vim.keymap.set("n", "<Leader><Space>", require("fzf-lua").command_history)

vim.keymap.set("v", "<C-c>", ":w !cl<CR><CR>")

require("lualine").setup({
	options = { theme = "gruvbox" },
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "filename" },
		lualine_c = { "branch", "diff", "diagnostics" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		-- lualine_y = { "progress" },
		lualine_y = {},
		lualine_z = { "location" },
	},
})
