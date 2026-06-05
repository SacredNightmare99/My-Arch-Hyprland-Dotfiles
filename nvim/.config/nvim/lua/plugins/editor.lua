return {
  -- Treesitter (new API — highlight/indent are built into Neovim)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- The new nvim-treesitter is a parser installer only.
      -- Highlight and indent are built into Neovim via vim.treesitter.
      require("nvim-treesitter").setup({})

      -- Enable treesitter-based highlighting and indentation (built-in)
      vim.treesitter.start = vim.treesitter.start or function() end -- guard
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      -- Auto-install parsers on first load
      local parsers = {
        -- Core
        "lua", "vim", "vimdoc", "query", "regex",
        -- Markup / Data
        "markdown", "markdown_inline", "html", "css", "json", "yaml", "toml", "latex",
        -- Your languages
        "c", "cpp", "java", "kotlin", "dart", "python", "go", "gomod", "gosum",
        "javascript", "typescript", "tsx", "rust",
        -- Shell / Config
        "bash", "dockerfile", "gitignore",
      }

      local installed = require("nvim-treesitter").get_installed()
      local to_install = vim.tbl_filter(function(p)
        return not vim.list_contains(installed, p)
      end, parsers)

      if #to_install > 0 then
        require("nvim-treesitter").install(to_install)
      end
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Autopairs + cmp integration
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
      local ok_cmp, cmp = pcall(require, "cmp")
      if ok_cmp then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- Formatter: conform.nvim
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          -- Markup / Data
          markdown = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          -- Lua
          lua = { "stylua" },
          -- C / C++
          c = { "clang-format" },
          cpp = { "clang-format" },
          -- Python
          python = { "black" },
          -- Go
          go = { "gofumpt" },
          -- Java
          java = { "google-java-format" },
          -- Kotlin
          kotlin = { "ktlint" },
          -- Dart (handled by flutter-tools LSP, but as fallback)
          dart = { "dart_format" },
          -- JS / TS
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          -- LaTeX
          tex = { "latexindent" },
        },
        format_on_save = {
          timeout_ms = 2000,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },

  -- Comment.nvim
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("Comment").setup()
    end,
  },

  -- nvim-surround
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- nvim-ufo (folding)
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup({
        provider_selector = function(_, _, _)
          return { "treesitter", "indent" }
        end,
      })

      -- Keymaps for ufo
      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
      vim.keymap.set("n", "zK", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Peek fold" })
    end,
  },

  -- render-markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },

  -- vimtex (LaTeX support)
  {
    "lervag/vimtex",
    ft = { "tex" },
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
    end,
  },
}
