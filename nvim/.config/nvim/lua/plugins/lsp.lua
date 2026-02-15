return {
  -- Mason
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason-lspconfig bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "jsonls", "html", "cssls", "textlab" },
      })
    end,
  },

  -- LSP
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
      local mason_lspconfig = require("mason-lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local on_attach = require("core.lsp").on_attach

      require("fidget").setup({})
      require("trouble").setup({})

      -- Installed servers via Mason
      local servers = mason_lspconfig.get_installed_servers()

      for _, server in ipairs(servers) do
        -- Get the default server config (NEW API)
        local default_config = vim.lsp.config[server]
        if not default_config then
          vim.notify("No LSP config found for: " .. server, vim.log.levels.WARN)
          goto continue
        end

        -- Override defaults
        local custom = {
          on_attach = on_attach,
          capabilities = capabilities,
        }

        -- Special case: Lua language server
        if server == "lua_ls" then
          custom.settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
            },
          }
        end

        -- Merge Mason config + overrides
        local final_config = vim.tbl_deep_extend(
          "force",
          default_config,
          custom
        )

        -- Start LSP with new API
        vim.lsp.start(final_config)

        ::continue::
      end
    end,
  },

  -- Flutter-tools
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

      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

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
