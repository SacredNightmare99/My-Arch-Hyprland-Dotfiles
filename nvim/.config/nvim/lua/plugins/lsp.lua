return {
  -- Mason
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason-LSPConfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },

  -- LSP base + autoinstall
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "j-hui/fidget.nvim",
      "folke/trouble.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local on_attach = require("core.lsp").on_attach

      -- Fidget: LSP progress
      require("fidget").setup({})

      mason_lspconfig.setup({
        ensure_installed = { "lua_ls", "jsonls", "html", "cssls" },
      })

      mason_lspconfig.setup_handlers({
        function(server)
          local opts = {
            on_attach = on_attach,
            capabilities = capabilities,
          }

          if server == "lua_ls" then
            opts.settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
              },
            }
          end

          lspconfig[server].setup(opts)
        end,
      })

      -- Trouble setup
      require("trouble").setup({})
    end,
  },

  -- Flutter
  {
    "akinsho/flutter-tools.nvim",
    ft = { "dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local on_attach = require("core.lsp").on_attach
      require("flutter-tools").setup({
        lsp = {
          on_attach = on_attach,
          capabilities = capabilities,
          flags = { debounce_text_changes = 150 },
        },
      })
    end,
  },
}
