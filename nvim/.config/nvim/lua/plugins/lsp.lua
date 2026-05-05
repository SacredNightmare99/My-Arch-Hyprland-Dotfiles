return {
  -- Mason: package manager for LSP servers, formatters, linters
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- Mason-lspconfig bridge (new API: automatic_enable via vim.lsp.enable)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- Lua
          "lua_ls",
          -- Web
          "html", "cssls", "jsonls",
          "ts_ls",
          -- C / C++
          "clangd",
          -- Python
          "pyright",
          -- Go
          "gopls",
          -- Java
          "jdtls",
          -- Kotlin
          "kotlin_language_server",
          -- LaTeX
          "texlab",
        },
        -- Automatically call vim.lsp.enable() for installed servers
        automatic_enable = true,
      })
    end,
  },

  -- LSP configuration (via Neovim 0.11 native vim.lsp.config API)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "j-hui/fidget.nvim",
      "folke/trouble.nvim",
    },

    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local on_attach = require("core.lsp").on_attach

      -- Enable folding capabilities for nvim-ufo
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- Progress indicator
      require("fidget").setup({})
      -- Diagnostics panel
      require("trouble").setup({})

      -- Shared config applied to ALL servers via the wildcard "*"
      vim.lsp.config("*", {
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- Server-specific settings
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
        },
      })

      vim.lsp.config("ts_ls", {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
        },
      })

      vim.lsp.config("jsonls", {
        settings = {
          json = {
            validate = { enable = true },
          },
        },
      })
    end,
  },

  -- Flutter-tools (Dart/Flutter LSP — managed outside Mason)
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

      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      require("flutter-tools").setup({
        lsp = {
          on_attach = on_attach,
          capabilities = capabilities,
          flags = { debounce_text_changes = 150 },
        },
        decorations = {
          statusline = {
            app_version = true,
            device = true,
          },
        },
        widget_guides = { enabled = true },
        closing_tags = { enabled = true },
      })
    end,
  },
}
