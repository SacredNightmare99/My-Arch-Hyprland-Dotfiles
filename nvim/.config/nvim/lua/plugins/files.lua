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
        close_if_last_window = false,
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
          },
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
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
