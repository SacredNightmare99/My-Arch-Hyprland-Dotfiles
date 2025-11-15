local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Select all
map("n", "<C-a>", "ggVG", opts)

-- Save & quit shortcuts
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Clear search highlight
map("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Telescope (plugin will be lazy-loaded on use)
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { silent = true, desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { silent = true, desc = "Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { silent = true, desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { silent = true, desc = "Help" })

-- Neo-tree toggle
map("n", "<C-n>", "<cmd>Neotree toggle<CR>", { silent = true, desc = "Toggle Neo-tree" })

-- Trouble (diagnostics panel)
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { silent = true, desc = "Diagnostics (Trouble)" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { silent = true, desc = "Quickfix (Trouble)" })
