-- =====================
-- Basic settings
-- =====================
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.mouse = "a"
vim.opt.autoread = true
vim.o.background = "dark"

-- =====================
-- Bootstrap lazy.nvim
-- =====================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =====================
-- Plugins
-- =====================
require("lazy").setup({

  -- Theme (modern Lua version)
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({})
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox",
          globalstatus = true,
          section_separators = { left = "", right = "" },
          component_separators = { left = "│", right = "│" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- neo-tree (replaces nvim-tree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<C-n>", ":Neotree toggle<CR>", desc = "Toggle NeoTree" },
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = false,
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
          filtered_items = { visible = false, hide_dotfiles = false },
          follow_current_file = { enabled = true },
          hijack_netrw_behavior = "open_default",
          window = {
            mappings = {
              ["<tab>"] = function(state)
                local node = state.tree:get_node()
                if node.type == "file" then
                  require("neo-tree.sources.filesystem.commands").open(state, { open_cmd = "vsplit" })
                end
              end,
              ["<cr>"] = "open",
              ["l"] = "open",
              ["h"] = "close_node",
            },
          },
        },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-p>",      "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help" },
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = { "dart", "lua", "vim", "json", "c", "html", "css", "typescript", "go", "python" },
      highlight = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Mason (LSP installer)
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  { "williamboman/mason-lspconfig.nvim", dependencies = { "mason.nvim" } },

  -- LSP base config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Attach Dart later in flutter-tools, this covers others
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "jsonls", "html", "cssls" },
        handlers = {
          function(server)
            lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
          end,
        },
      })
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = {
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        },
        sources = { { name = "nvim_lsp" } },
      })
    end,
  },

  -- Autopairs + cmp integration
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
      local ok, cmp = pcall(require, "cmp")
      if ok then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- Formatter: conform.nvim
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          dart = { "dart_format" },
          lua = { "stylua" },
          json = { "jq" },
        },
        format_on_save = {
          timeout_ms = 2000,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- Flutter
  {
    "akinsho/flutter-tools.nvim",
    ft = { "dart" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("flutter-tools").setup({
        lsp = {
          capabilities = capabilities,
          flags = { debounce_text_changes = 150 },
        },
      })
    end,
  },

  -- Git tools
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("gitsigns").setup() end,
  },
  { "tpope/vim-fugitive",                cmd = { "Git", "G" } },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function() require("which-key").setup() end,
  },

}, { checker = { enabled = false } })

-- =====================
-- Keymaps
-- =====================
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- =====================
-- Global LSP keymaps (apply to every LSP automatically)
-- =====================
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspKeymaps", {}),
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-.>", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = false })
    end, opts)
  end,
})
