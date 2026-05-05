return {
  -- File explorer: neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        window = {
          position = "left",
          width = 35,
          mappings = {
            ["<cr>"] = "open",
            ["l"] = "open",
            ["h"] = "close_node",
            ["<tab>"] = "open_vsplit",
            ["s"] = "open_split",
            ["P"] = { "toggle_preview", config = { use_float = true } },
          },
        },
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
          },
          follow_current_file = { enabled = true },
          hijack_netrw_behavior = "open_default",
          use_libuv_file_watcher = true,
        },
        default_component_configs = {
          indent = {
            with_expanders = true,
          },
          git_status = {
            symbols = {
              added = "",
              modified = "",
              deleted = "✖",
              renamed = "󰁕",
              untracked = "",
              ignored = "",
              unstaged = "󰄱",
              staged = "",
              conflict = "",
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
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            width = 0.87,
            height = 0.80,
          },
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "build/",
            "dist/",
            "__pycache__",
            "%.class",
          },
        },
      })
      -- Load fzf extension for much faster fuzzy finding
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
