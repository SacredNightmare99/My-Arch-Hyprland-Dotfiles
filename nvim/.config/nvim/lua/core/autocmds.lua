-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 120 })
  end,
})

-- Diagnostics configuration: no virtual_text, floating with border
vim.diagnostic.config({
  virtual_text = false,
  float = {
    border = "rounded",
    source = "if_many",
  },
  update_in_insert = false,
})

-- Show diagnostics on hover (CursorHold)
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})
