--=====================
-- Basic settings
--=====================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.mouse = "a"
vim.opt.autoread = true

--=====================
-- Plugin manager (vim-plug still works with init.lua)
--=====================
vim.cmd [[
call plug#begin('~/.vim/plugged')

" Gruvbox Theme
Plug 'morhetz/gruvbox'

" vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File explorer
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

" Telescope (Ctrl+P like fuzzy finder)
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

" Dart / Flutter
Plug 'dart-lang/dart-vim-plugin'
Plug 'akinsho/flutter-tools.nvim'

" LSP + completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'windwp/nvim-autopairs'

" Treesitter (better highlighting)
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Optional plugins
Plug 'folke/which-key.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'

call plug#end()
]]

--=====================
-- Theme
--=====================
vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")

--=====================
-- nvim-tree
--=====================
require("nvim-tree").setup {
  update_cwd = true,
  respect_buf_cwd = true,
}
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

--=====================
-- Telescope
--=====================
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { noremap = true, silent = true })

--=====================
-- Treesitter
--=====================
require("nvim-treesitter.configs").setup {
  ensure_installed = { "dart", "lua", "vim", "json", "c", "html", "css", "typescript", "asm" },
  highlight = { enable = true },
}

--=====================
-- LSP + Flutter setup
--=====================
local on_attach = function(_, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-.>', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

require("flutter-tools").setup {
  lsp = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
  },
}

-- Workaround: Restart dartls automatically if it crashes on text edits
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = false,
  }
)

--=====================
-- Autopairs
--=====================
require("nvim-autopairs").setup {}

--=====================
-- Auto-restart Dart LSP on RangeError
--=====================
local default_handler = vim.lsp.handlers["window/showMessage"]
vim.lsp.handlers["window/showMessage"] = function(err, result, ctx, config)
  if result.message and result.message:match("RangeError: The edit extends past the end of the code") then
    vim.schedule(function()
      vim.cmd("LspRestart")
      print("⚡ dartls restarted due to RangeError")
    end)
  else
    default_handler(err, result, ctx, config)
  end
end

--=====================
-- Completion (nvim-cmp)
--=====================
local cmp = require("cmp")
cmp.setup {
  mapping = {
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  },
  sources = { { name = "nvim_lsp" } },
}

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

--=====================
-- gitsigns
--=====================
require("gitsigns").setup()

--=====================
-- which-key
--=====================
require("which-key").setup {}

--=====================
-- Keymaps like VS Code
--=====================
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- Format Dart before save
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.dart",
--   callback = function() vim.lsp.buf.format() end,
-- })

-- Format Dart before save safely
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.dart",
  callback = function()
    -- use async to avoid blocking didChange notifications
    vim.lsp.buf.format({ async = false })
  end,
})

--=====================
-- Airline config
--=====================
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g["airline#extensions#branch#enabled"] = 1
vim.g["airline_theme"] = "molokai"
vim.g.airline_powerline_fonts = 1
vim.g.airline_symbols = {
  linenr = "",
  branch = "",
  paste = "ρ",
  whitespace = "Ξ",
}

