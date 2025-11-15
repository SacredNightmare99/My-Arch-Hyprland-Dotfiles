return {
  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Theme
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

  -- Notifications
  {
    "rcarriga/nvim-notify",
    lazy = true,
    config = function()
      vim.notify = require("notify")
    end,
  },

  -- noice.nvim (modern UI)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
        },
      })
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      local db = require("dashboard")
      db.setup({
        theme = "hyper",
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {
            { desc = "Files",     group = "@property", action = "Telescope find_files", key = "f" },
            { desc = "Live grep", group = "@string",   action = "Telescope live_grep",  key = "g" },
            { desc = "Neo-tree",  group = "@constant", action = "Neotree toggle",       key = "n" },
          },
        },
      })
    end,
  },
}
