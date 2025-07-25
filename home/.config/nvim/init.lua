local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- { dir = "/home/kazuya/ghq/github.com/acro5piano/nvim-format-buffer" },
  "acro5piano/nvim-format-buffer",
  -- { dir = "/home/kazuya/ghq/github.com/acro5piano/cmp-path-chdir" },
  "acro5piano/cmp-path-chdir",

  -- "wbthomason/packer.nvim",
  "ibhagwan/fzf-lua",
  "kyazdani42/nvim-web-devicons",
  "terrortylor/nvim-comment",
  "nvim-lualine/lualine.nvim",
  "bronson/vim-visual-star-search",
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp",
  "dcampos/nvim-snippy",
  "dcampos/cmp-snippy",
  "ruanyl/vim-gh-line",
  "kyoh86/vim-ripgrep",
  "gpanders/editorconfig.nvim",
  "aklt/plantuml-syntax",
  "preservim/vim-markdown",
  "phaazon/hop.nvim",
  "windwp/nvim-ts-autotag",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-treesitter/nvim-treesitter-textobjects",
  "goolord/alpha-nvim",
  "lukas-reineke/cmp-rg",
  "gbprod/yanky.nvim",
  "stevearc/dressing.nvim", -- for yanky to work nicely
  "monaqa/dial.nvim",
  "onsails/lspkind.nvim",
  "kylechui/nvim-surround", -- better replacement of "tpope/vim-surround"
  "stevearc/oil.nvim",
  "mechatroner/rainbow_csv",
  "echasnovski/mini.align",
  "lewis6991/gitsigns.nvim",
  "xiyaowong/nvim-cursorword",
  "lukas-reineke/indent-blankline.nvim",
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    config = function()
      require("tiny-inline-diagnostic").setup({ preset = "simple" })
      vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
    end,
  },

  -- Themes
  "folke/tokyonight.nvim",
})

local my_util = require("my-util")

vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.wrap = false
vim.o.signcolumn = "yes"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.foldenable = false
vim.o.completeopt = "menu,menuone,noselect"
vim.o.selectmode = "mouse,key"
vim.o.cedit = "<C-q>"
vim.o.mouse = ""

vim.o.backup = false
vim.o.swapfile = false
vim.o.undofile = false
vim.o.autochdir = false

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

require("tokyonight").setup({
  transparent = true,
  style = "moon",
})
vim.cmd("colorscheme tokyonight")

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

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.js", "*.ts", "*.tsx" },
  callback = function()
    if my_util.command_exists("EslintFixAll") then
      vim.api.nvim_exec(":EslintFixAll", false)
    end
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
  pattern = { "*.gql", "*.graphql", "*.graphqls" },
  callback = function()
    for _, key in ipairs({ "m" }) do
      vim.keymap.set(
        "n",
        key,
        "/\\(\\(type\\)\\|\\(input\\)\\|\\(enum\\)\\|\\(scalar\\)\\) <C-r><C-w>[\\n| ]<CR>:nohl<CR>",
        { buffer = true }
      )
    end
    vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*.tf", "*.hcl" },
  callback = function()
    vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*.sql" },
  callback = function()
    vim.api.nvim_buf_set_option(0, "commentstring", "-- %s")
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*.prql" },
  callback = function()
    vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { ".clinerules" },
  callback = function()
    vim.api.nvim_exec("setlocal ft=markdown", false)
    vim.api.nvim_exec("setlocal wrap", false)
  end,
})

-- vim.api.nvim_create_autocmd({ "BufReadPost" }, {
--   pattern = { "*.md" },
--   callback = function()
--     vim.api.nvim_exec(":set wrap", false)
--   end,
-- })

local function has(command)
  -- We need redirect because stderr is annoying
  -- https://github.com/neovim/neovim/issues/21376
  local handle = io.popen("which 2>&1 " .. command)
  if handle == nil then
    return false
  end
  local result = handle:read("*a")
  handle:close()
  return string.find(result, "which: no") == nil
end

if has("fcitx5-remote") then
  -- WARNING: This could be a perfomance bottleneck. Keep it in mind.
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
  verbose = false,
  format_rules = {
    { pattern = { "*.lua" }, command = "stylua -" },
    { pattern = { "*.py" }, command = "ruff format - | isort -" },
    { pattern = { "*.rs" }, command = "rustfmt --edition 2021" },
    { pattern = { "*.sql" }, command = "sql-formatter" }, -- requires `npm -g i sql-formatter`
    { pattern = { "*.tf" }, command = "terraform fmt -" },
    { pattern = { ".clinerules" }, command = "prettier --parser markdown" },
    -- It removes comment, so disabled for now
    -- { pattern = { "*.prql" }, command = "prqlc fmt -" },
    {
      pattern = {
        "*.js",
        "*.jsx",
        "*.ts",
        "*.tsx",
        "*.mjs",
        "*.mts",
        "*.astro",
        "*.gql",
        "*.graphql",
        "*.graphqls",
        "*.css",
        "*.md",
        "*.html",
      },
      command = function()
        return prettier_bin() .. " --stdin-filepath 2>/dev/null " .. "'" .. vim.api.nvim_buf_get_name(0) .. "'"
      end,
    },
  },
})

local fzf_lua = require("fzf-lua")

local git_files_cwd_aware = require("git-files-cwd-aware")

function replace_html_special_chars()
  local line = vim.api.nvim_get_current_line()
  local html_special_chars = {
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&apos;",
  }
  local replaced_line = string.gsub(line, "[&<>\"']", html_special_chars)
  vim.api.nvim_set_current_line(replaced_line)
end

local function go_to_first_definition()
  vim.lsp.buf.definition({
    on_list = function(options)
      if options.items and #options.items > 0 then
        local filtered = {}
        for _, item in ipairs(options.items) do
          -- Filter out items whose filename contains 'node_modules'
          if not (item.filename and string.match(item.filename, "node_modules")) then
            table.insert(filtered, item)
          end
        end
        if #filtered == 0 then
          -- If all definitions are in node_modules, pick the first item.
          table.insert(filtered, options.items[1])
        end
        vim.fn.setqflist(filtered, "r")
        vim.cmd("cfirst")
      else
        print("No definition found")
      end
    end,
  })
end

-- TODO: make this to lua
vim.api.nvim_exec("command! -nargs=+ -complete=file Ripgrep :call ripgrep#search(<q-args>)", false)

vim.keymap.set("", "<F1>", "<ESC>")
vim.keymap.set("i", "<F1>", "<ESC>")

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<C-w><CR>", string.rep("<C-w><C-w>:q<CR>", 3)) -- maps to C-w C-m
vim.keymap.set("n", "<C-w>/", ":vsplit<CR><C-w><C-l><C-6>")
vim.keymap.set("n", "<C-w>-", "<C-w>s<C-w><C-j><C-6>")
vim.keymap.set("n", "<ESC><ESC>", ":nohl<CR>")
vim.keymap.set("n", "m", go_to_first_definition)
-- vim.keymap.set("n", "g/", fzf_lua.blines)
vim.keymap.set("n", "g/", fzf_lua.live_grep) -- experimental: try something new!
vim.keymap.set("n", "gp", ":YankyRingHistory<CR>")
vim.keymap.set("n", "gm", fzf_lua.lsp_definitions)
vim.keymap.set("n", "gw", fzf_lua.grep_cword)
vim.keymap.set("n", "ga", fzf_lua.git_files)
vim.keymap.set("n", "6", "<C-6>", { nowait = true })
vim.keymap.set("n", "'", ":w<CR>", { nowait = true })
vim.keymap.set("n", "<Leader>g", ":Ripgrep ")
vim.keymap.set("n", "<Leader>w", ":Ripgrep <C-r><C-w>")
vim.keymap.set("n", "<Leader>b", fzf_lua.buffers)
vim.keymap.set("n", ";", fzf_lua.buffers)
vim.keymap.set("n", "<Leader>e", ":e!<CR>")
vim.keymap.set("n", "<Leader>c", fzf_lua.resume) -- remember with "continue". TODO: this is not used anymore, let's assign more good one
vim.keymap.set("n", "gl", fzf_lua.quickfix)
vim.keymap.set("n", "<Leader>r", fzf_lua.oldfiles)
vim.keymap.set("n", "<Leader>f", git_files_cwd_aware.git_files_cwd_aware)
vim.keymap.set("n", "go", git_files_cwd_aware.git_files_cwd_aware)
vim.keymap.set("n", "<Leader>s", ":w!<CR>")
vim.keymap.set("n", ",", ":HopWord<CR>")
vim.keymap.set("n", "gl", fzf_lua.git_bcommits)
vim.keymap.set("n", "gs", fzf_lua.git_status)
vim.keymap.set("n", "<Leader>a", fzf_lua.lsp_code_actions)
vim.keymap.set("n", "<Leader>lq", vim.lsp.buf.references) -- named after "lsp quicifix"
vim.keymap.set("n", "<Leader>f", fzf_lua.lsp_references)
vim.keymap.set("n", "<Leader>l[", vim.lsp.buf.rename)
vim.keymap.set("n", "<Leader>h", vim.lsp.buf.hover)
vim.keymap.set("n", "<Leader>n", vim.diagnostic.goto_next)
vim.keymap.set("n", "<Leader>lp", vim.diagnostic.goto_prev)
vim.keymap.set("n", "g[", vim.diagnostic.goto_prev) -- inspired with the spellcheck and markdown
vim.keymap.set("n", "g]", vim.diagnostic.goto_next)
vim.keymap.set("n", "<Leader>li", vim.diagnostic.open_float)
vim.keymap.set("n", "<Leader>m", ":TmpMarkdown<CR>")
vim.keymap.set("n", "<Leader>p", ":PasteBuffers<CR>")
vim.keymap.set("n", "<Leader>v", ":.!clp<CR>")
vim.keymap.set("n", "<Leader>wp", ":set wrap!<CR>")
vim.keymap.set("n", "<Leader>!", ":qa!<CR>")
vim.keymap.set("n", "<Leader>q", ":qa<CR>")
vim.keymap.set("n", "<Leader>rl", ":s/")
vim.keymap.set({ "n", "v" }, "<S-y>", '"+y')
vim.keymap.set("n", "gr", ":%s/", { nowait = true })
vim.keymap.set("n", "<Leader><Space>", fzf_lua.command_history)
vim.keymap.set("n", "<Leader>wq", ":wq<CR>")
vim.keymap.set({ "n", "v" }, "<Leader>/", ":CommentToggle<CR>")
vim.keymap.set("n", "<Leader>x", fzf_lua.commands)
vim.keymap.set("n", "Q", "@q") -- qq to record, Q to replay
vim.keymap.set("n", "|", "x~f_")
vim.keymap.set("n", "<Leader>d", require("oil").open)
vim.keymap.set("n", "<Backspace>", require("oil").open)
vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
vim.keymap.set("n", "<C-g>", function()
  vim.cmd("cd .")
  vim.cmd("normal! \x07") -- \x07 is Ctrl+G
end)
vim.keymap.set("n", "<C-S-G>", ':let @+=fnamemodify(expand("%"), ":~:.")<CR> | :echo "filepath copied!"<CR>')
vim.keymap.set("n", "gy", function()
  -- Get the file path relative to git root
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if not handle then
    vim.notify("Failed to execute git command", vim.log.levels.ERROR)
    return
  end

  local git_root = handle:read("*l")
  handle:close()

  if not git_root then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return
  end

  local current_file = vim.fn.expand("%:p")
  local relative_path = string.sub(current_file, string.len(git_root) + 2) -- +2 to remove the trailing slash

  vim.fn.setreg("+", relative_path)
  vim.notify("Git relative path copied: " .. relative_path, vim.log.levels.INFO)
end)
vim.keymap.set("n", "&", replace_html_special_chars)
vim.keymap.set("n", "<F12>", "~W")
vim.keymap.set("n", "S", "ggVG:w !cl<CR><CR>")

vim.keymap.set("i", "z.", "=>")
vim.keymap.set("i", "z;", "z.") -- Needed for zod validation. My fingers are too lazy to fix the 5 years mapping - e.g.) z.string().uuid()
vim.keymap.set("i", "zl", "->")
vim.keymap.set("i", "zc", "console.log()<Left>")
vim.keymap.set("i", "zd", '<C-r>=strftime("%Y-%m-%d")<CR><Space>')
vim.keymap.set("i", "zt", '<C-r>=strftime("%H:%M")<CR><Space>')
vim.keymap.set("i", "zf", "<C-r>=expand('%:t:r')<CR>")
vim.keymap.set("i", "zw", "<C-r>=expand('%:p:h:t')<CR>")

-- Return/Space triggered auto close braces
local function get_left_2_chars()
  -- add "_" to let close function work in the first col
  local line = "_" .. vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local left_2_char = line:sub(col, col + 1)
  return left_2_char
end
local function get_right_1_char()
  -- add "_" to let close function work in the last col
  local line = vim.api.nvim_get_current_line() .. "_"
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local right_char = line:sub(col + 1, col + 1)
  return right_char
end
vim.keymap.set("i", "<CR>", function()
  local left_2_char = get_left_2_chars()
  local right_char = get_right_1_char()
  if right_char ~= " " and right_char ~= "_" then
    return "<CR>"
  end
  if left_2_char == "({" then
    return "})<Left><Left><CR><UP><END><CR>"
  end
  if left_2_char == " {" then
    return "}<Left><CR><UP><END><CR>"
  end
  if left_2_char == "_{" then
    return "}<Left><CR><UP><END><CR>"
  end
  if left_2_char == " (" then
    return ")<Left><CR><UP><END><CR>"
  end
  if left_2_char == "_(" then
    return ")<Left><CR><UP><END><CR>"
  end
  return "<CR>"
end, { expr = true })
vim.keymap.set("i", "<Space>", function()
  local left_2_char = get_left_2_chars()
  local right_char = get_right_1_char()
  if right_char ~= " " and right_char ~= "_" then
    return "<Space>"
  end
  if left_2_char == "{{" then
    return "}}<Left><Left><Space><Left><Space>"
  end
  if left_2_char == "({" then
    return "})<Left><Left><Space><Left><Space>"
  end
  if left_2_char == " {" or left_2_char == "_{" then
    return "}<Left><Space><Left><Space>"
  end
  if left_2_char == "_(" or left_2_char == "_(" then
    return ")<Left><Space><Left><Space>"
  end
  return "<Space>"
end, { expr = true })

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
vim.keymap.set("i", "<C-n>", "<C-o>j")
vim.keymap.set("i", "<C-p>", "<C-o>k")
vim.keymap.set("i", "<C-k>", "<C-c>lC")
vim.keymap.set("c", "<C-k>", "<C-\\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>")

vim.keymap.set("v", "<Leader>ag", fzf_lua.grep_visual)
vim.keymap.set("v", "<C-c>", ":w !cl<CR><CR>")
vim.keymap.set("v", ",", require("hop").hint_words)
vim.keymap.set("v", "K", "^o$")

-- vim.keymap.set not works with them
vim.api.nvim_set_keymap("v", "D", 'SDci"', {})
vim.api.nvim_set_keymap("v", "T", "ST", {})
vim.api.nvim_set_keymap("n", "<Leader>t", 'va"STds"', {})

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
  },
})

require("lualine").setup({
  options = { theme = "gruvbox" },
  sections = {
    lualine_a = { "filename" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { "filetype" },
    lualine_z = { "location" },
  },
})
require("nvim_comment").setup({ create_mappings = false })

vim.lsp.handlers["textDocument/definition"] = function(err, result, method, ...)
  if not result then
    return
  end
  if vim.tbl_islist(result) and #result > 1 then
    result = { result[1] }
  end
  vim.lsp.util.jump_to_location(result[1] or result, "utf-8", true)
end

local lsp = require("lspconfig")
lsp.pyright.setup({})
lsp.denols.setup({
  root_dir = lsp.util.root_pattern("deno.json"),
  init_options = {
    lint = true,
    unstable = true,
    suggest = {
      imports = {
        hosts = {
          ["https://deno.land"] = true,
          ["https://cdn.nest.land"] = true,
          ["https://crux.land"] = true,
        },
      },
    },
  },
  on_attach = function()
    local active_clients = vim.lsp.get_active_clients()
    for _, client in pairs(active_clients) do
      -- stop tsserver if denols is already active
      if client.name == "tsserver" then
        client.stop()
      end
    end
  end,
})

-- require("lspconfig").denols.setup({})
lsp.ts_ls.setup({
  root_dir = lsp.util.root_pattern("package.json"),
})

lsp.solargraph.setup({
  settings = {
    solargraph = {
      diagnostics = false,
    },
  },
})
if has("lua-language-server") then
  lsp.lua_ls.setup({
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
  })
end
lsp.rust_analyzer.setup({})
-- lsp.terraformls.setup({})
-- lsp.graphql.setup({
-- 	filetypes = {
-- 		"graphql",
-- 	},
-- 	cmd = { "graphql-lsp", "server", "-m", "stream" },
-- })
lsp.eslint.setup({
  filetypes = { "typescript", "typescriptreact", "javascriptreact" },
})
lsp.astro.setup({})
-- lsp.emmet_language_server.setup({})

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
    { name = "path_chdir" },

    { name = "snippy" },
    {
      name = "rg",
      keyword_length = 3,
    },
    -- { name = "cody", keyword_length = 3 },
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
        vim_item.dup = { buffer = 1, path = 1, nvim_lsp = 0 }
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
  -- Unfortunately fzf-tmux is too slow...
  -- fzf_bin = "fzf-tmux",
  winopts = {
    -- hl = { border = "Normal" },
    fullscreen = true, -- start fullscreen?
    preview = {
      horizontal = "right:60%", -- right|left:size
      -- default = "bat_native",
    },
  },
  keymap = {
    fzf = {
      "--color=hl:-1:reverse,hl+:-1:reverse",
    },
    builtin = {
      ["<Esc>"] = "hide", -- hide fzf-lua, `:FzfLua resume` to continue
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
  lines = {
    previewer = false,
  },
})

require("hop").setup()

require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  ignore_install = { "ipk", "ipkg" },
  highlight = {
    enable = true,
    disable = function(lang)
      local buf_name = vim.fn.expand("%")
      if lang == "csv" or lang == "po" then
        return true
      end
    end,
  },
  indent = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.outer",
        ["as"] = "@scope",
      },
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "<c-v>", -- blockwise
      },
      include_surrounding_whitespace = true,
    },
  },
})

require("nvim-ts-autotag").setup({})

-- used in snippet
UpperFirstLetter = my_util.upper_first_letter

require("alpha").setup(require("alpha.themes.startify").config)
require("yanky").setup({
  highlight = {
    on_put = false,
    on_yank = false,
  },
})

require("nvim-surround").setup({
  surrounds = {
    ["E"] = { -- emphasize
      add = { "**", "**" },
    },
    ["D"] = {
      add = { '<div className="">', "</div>" },
    },
    ["T"] = {
      add = { "{t`", "`}" },
    },
    ["<"] = {
      add = { "<>", "</>" },
    },
    [">"] = {
      add = { "<>", "</>" },
    },
  },
})

require("oil").setup({
  view_options = {
    show_hidden = true,
  },
})

require("mini.align").setup({
  mappings = {
    start = "[a",
    start_with_preview = "",
  },
})

-- Define a command to transform the code
vim.api.nvim_create_user_command("TransformZodSchemaIntoType", function()
  local line = vim.api.nvim_get_current_line()
  local schema_line = line:match("^export const (.+Schema) = ")
  if schema_line then
    -- Insert the type definition line above the current line
    local type_definition = "export type I" .. schema_line .. " = z.infer<typeof " .. schema_line .. ">"
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { type_definition })
  end
end, {})

-- TmpMarkdown command
vim.api.nvim_create_user_command("TmpMarkdown", function()
  local timestamp = os.date("%Y%m%d_%H%M%S")
  local filename = timestamp .. ".md"
  local filepath = os.getenv("HOME") .. "/tmp-markdown/" .. filename

  -- Create directory if it doesn't exist
  vim.fn.mkdir(os.getenv("HOME") .. "/tmp-markdown", "p")

  -- Open the file in a new buffer
  vim.cmd("edit " .. filepath)
  vim.cmd("PasteBuffers")
end, {})

-- PasteBuffers command
vim.api.nvim_create_user_command("PasteBuffers", function()
  local cwd = vim.fn.getcwd()
  local buffers = vim.api.nvim_list_bufs()
  local filenames = {}

  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local filepath = vim.api.nvim_buf_get_name(buf)
      if filepath ~= "" then
        -- Check if file is under current working directory
        if string.sub(filepath, 1, string.len(cwd)) == cwd then
          -- Get relative path from cwd
          local relative_path = string.sub(filepath, string.len(cwd) + 2) -- +2 to remove leading slash
          table.insert(filenames, "- " .. relative_path)
        end
      end
    end
  end

  -- Insert filenames at cursor position
  if #filenames > 0 then
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, row, row, false, filenames)
  end
end, {})

require("gitsigns").setup()

require("ibl").setup({
  indent = { char = "|" },
  scope = { enabled = false },
})

require("fzf-lua").register_ui_select()
