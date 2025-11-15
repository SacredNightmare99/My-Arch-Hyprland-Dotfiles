return {
  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Fugitive
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
  },
}
