-- Basic Neovim Configuration for DevOps Workspace
-- A productive, minimal setup without plugin managers

-- ============================================================================
-- General Settings
-- ============================================================================

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- UI
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.colorcolumn = "80"

-- Split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- File handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Update time (for better UX)
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Mouse support
vim.opt.mouse = "a"

-- Better completion
vim.opt.completeopt = "menu,menuone,noselect"

-- Show hidden characters
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- ============================================================================
-- Key Mappings
-- ============================================================================

local keymap = vim.keymap.set

-- Better escape
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap("i", "kj", "<ESC>", { desc = "Exit insert mode" })

-- Clear search highlight
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
keymap("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Better indenting
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Move lines
keymap("n", "<A-j>", "<cmd>move .+1<CR>==", { desc = "Move line down" })
keymap("n", "<A-k>", "<cmd>move .-2<CR>==", { desc = "Move line up" })
keymap("v", "<A-j>", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-k>", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better paste
keymap("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Save and quit
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all without saving" })

-- Split windows
keymap("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
keymap("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontally" })
keymap("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close split" })

-- File explorer (netrw)
keymap("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Open file explorer" })

-- Quick fix list
keymap("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open quickfix" })
keymap("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix" })
keymap("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix" })
keymap("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix" })

-- Terminal
keymap("n", "<leader>tt", "<cmd>terminal<CR>", { desc = "Open terminal" })
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ============================================================================
-- File Type Specific Settings
-- ============================================================================

-- Create autocommand group
local augroup = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })

-- YAML files (common in DevOps)
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "yaml", "yml" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- JSON files
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "json",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- Terraform files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup,
    pattern = { "*.tf", "*.tfvars" },
    callback = function()
        vim.bo.filetype = "terraform"
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

-- Dockerfile
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup,
    pattern = { "Dockerfile*", "*.dockerfile" },
    callback = function()
        vim.bo.filetype = "dockerfile"
    end,
})

-- Bash/Shell scripts
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "sh", "bash" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
    end,
})

-- ============================================================================
-- Netrw (Built-in File Explorer) Configuration
-- ============================================================================

vim.g.netrw_banner = 0          -- Hide banner
vim.g.netrw_liststyle = 3       -- Tree view
vim.g.netrw_browse_split = 0    -- Open in same window
vim.g.netrw_altv = 1            -- Open splits to the right
vim.g.netrw_winsize = 25        -- 25% width for explorer

-- ============================================================================
-- Basic Color Scheme
-- ============================================================================

-- Use default dark theme with some tweaks
vim.cmd("colorscheme habamax")

-- Custom highlights
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5c6370" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#abb2bf", bold = true })
vim.api.nvim_set_hl(0, "Comment", { fg = "#5c6370", italic = true })

-- ============================================================================
-- Status Line
-- ============================================================================

local function statusline()
    local mode_map = {
        n = "NORMAL",
        i = "INSERT",
        v = "VISUAL",
        V = "V-LINE",
        c = "COMMAND",
        r = "REPLACE",
        t = "TERMINAL",
    }

    local mode = mode_map[vim.fn.mode()] or "UNKNOWN"
    local file = vim.fn.expand("%:t")
    local filetype = vim.bo.filetype
    local line = vim.fn.line(".")
    local col = vim.fn.col(".")
    local total = vim.fn.line("$")
    local percent = math.floor((line / total) * 100)

    return string.format(
        " %s | %s | %s | Ln %d, Col %d | %d%% ",
        mode,
        file ~= "" and file or "[No Name]",
        filetype ~= "" and filetype or "txt",
        line,
        col,
        percent
    )
end

vim.opt.statusline = "%!v:lua.statusline()"

-- Make statusline function global
_G.statusline = statusline

-- ============================================================================
-- Auto Commands
-- ============================================================================

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("TrimWhitespace", { clear = true }),
    pattern = "*",
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("LastPosition", { clear = true }),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- ============================================================================
-- DevOps Specific Shortcuts
-- ============================================================================

-- Quick formatting for common DevOps files
keymap("n", "<leader>fj", ":%!jq .<CR>", { desc = "Format JSON with jq" })
keymap("n", "<leader>fy", ":%!yq .<CR>", { desc = "Format YAML with yq" })

-- Kubernetes shortcuts
keymap("n", "<leader>k", "", { desc = "+kubernetes" })
keymap("n", "<leader>ka", "ggVG", { desc = "Select all (for kubectl apply)" })

print("DevOps Neovim config loaded successfully!")
