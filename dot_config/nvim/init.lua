-- |  \/  \ \ / /\ \   / /_ _|  \/  |  _ \ / ___|
-- | |\/| |\ V /  \ \ / / | || |\/| | |_) | |
-- | |  | | | |    \ V /  | || |  | |  _ <| |___
-- |_|  |_| |_|     \_/  |___|_|  |_|_| \_\\____|
--
--
-- Author: @hongyuanjia
-- Last Modified: 2025-09-26 11:44

-- Basic Settings
local options = {
    backup = false,
    swapfile = false,
    writebackup = false,
    undofile = true,
    hidden = true,

    -- UI
    mouse = "a",
    cmdheight = 1,
    conceallevel = 0,
    pumheight = 10,
    showmode = false,
    showtabline = 2,
    cursorline = true,
    number = true,
    relativenumber = true,
    numberwidth = 4,
    signcolumn = "yes:1",
    wrap = false,
    scrolloff = 8,
    sidescrolloff = 8,
    termguicolors = true,
    laststatus = 3,
    list = true,
    listchars = "eol:↵,trail:~,tab:>-,nbsp:␣",
    confirm = true,

    -- search
    hlsearch = true,
    ignorecase = true,
    smartcase = true,

    -- split
    splitbelow = true,
    splitright = true,

    -- edit
    fileencoding = "utf-8",
    smartindent = true,
    clipboard = "unnamedplus",
    textwidth = 80,

    -- autocomplete
    completeopt = { "menu", "menuone", "noselect" },
    timeoutlen = 500,
    updatetime = 300,

    -- tabs
    smarttab = true,
    expandtab = true,
    shiftwidth = 4,
    tabstop = 4,
    softtabstop = 4,

    -- session
    sessionoptions = {  "curdir", "winsize", "localoptions" }
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

if vim.fn.has("nvim-0.8") == 1 then
    vim.opt.spell = true
    vim.api.nvim_create_autocmd("TermOpen", {
        group = vim.api.nvim_create_augroup("SpellCheckOverwrite", {}),
        pattern = "*",
        callback = function()
            vim.opt.spell = false
        end
    })
end

-- disable line number in terminal
vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("LinenumberOverwrite", {}),
    pattern = "*",
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end
})

-- disable intro
vim.opt.shortmess:append("I")

-- treat '-' as word separator
vim.opt.iskeyword:append("-")

-- avoid other file plugins to overwrite format options
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("FormatOptionsOverwrite", {}),
    pattern = "*",
    callback = function()
        -- do not add comment header
        vim.opt.formatoptions:remove("c")
        vim.opt.formatoptions:remove("r")
        vim.opt.formatoptions:remove("o")
        -- do not insert spaces for multi bytes
        vim.opt.formatoptions:append("M")
        -- don't insert a space before or after a multi-byte when join
        vim.opt.formatoptions:append("B")
        -- multibyte line breaking
        vim.opt.formatoptions:append("m")
        -- remove a comment leader when joining
        vim.opt.formatoptions:append("j")
        -- don't auto format text
        vim.opt.formatoptions:remove("t")
    end
})

-- go to last loc when opening a buffer
vim.cmd([[
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
]])

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("HighlightYank", {}),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40
        })
    end
})

-- don't load builtin plugins
local builtins = {
    "gzip", "zip", "zipPlugin", "tar", "tarPlugin",
    "getscript", "getscriptPlugin", "vimball", "vimballPlugin",
    "2html_plugin", "matchit", "matchparen", "logiPat", "rrhelper",
    "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
    "tutor"
}
for _, plugin in ipairs(builtins) do
    vim.g["loaded_" .. plugin] = 1
end

-- update 'Last Modified' comment on save for 'init.lua' file
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("UpdateLastModified", {}),
    pattern = vim.fn.substitute(vim.fn.expand("$MYVIMRC"), "\\", "/", "g"),
    callback = function()
        -- only update if $MYVIMRC is a lua file, modifiable, and has more than 8 lines
        if vim.bo.filetype == "lua" and vim.api.nvim_get_option_value("modifiable", {}) and vim.fn.line("$") >= 8 then
            os.setlocale("en_US.UTF-8")
            local time = os.date("%Y-%m-%d %H:%M")
            local l = 1
            -- try first 8 lines
            while l <= 8 do
                vim.fn.setline(l,
                    vim.fn.substitute(vim.fn.getline(l), "^-- Last Modified: \\zs.*", time , "gc")
                )
                l = l + 1
            end
        end
    end
})

-- short name for printing
function _G.P(...)
    vim.print(...)
end

-- remap space as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- keep the cursor always at the middle when jumping lines
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- keep the cursor stay when joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- remap j and k to move across display lines and not real lines
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "gk", "k")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "gj", "j")

-- use <C-[UDLR]> for window resizing
vim.keymap.set("n", "<C-j>", "<cmd>resize -2<CR>", { desc = "Shrink window horizontally" })
vim.keymap.set("n", "<C-k>", "<cmd>resize +2<CR>", { desc = "Enlarge window horizontally" })
vim.keymap.set("n", "<C-l>", "<cmd>vertical resize -2<CR>", { desc = "Enlarge window vertically" })
vim.keymap.set("n", "<C-h>", "<cmd>vertical resize +2<CR>", { desc = "Shrink window vertically" })

-- stay in indent mode
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- select last pasted text
vim.keymap.set("n", "gp", "`[v`]" )
vim.keymap.set("n", "gP", "`[V`]" )

-- move text up and down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==",        { desc = "Move line down" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv",    { desc = "Move line down" })
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==",        { desc = "Move line up" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv",    { desc = "Move line up" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })

-- jump to beginning or end using H and L
vim.keymap.set("n", "H", "^", { desc = "To line first non-blank character" })
vim.keymap.set("n", "L", "$", { desc = "To line end" })
vim.keymap.set("v", "H", "^", { desc = "To line first non-blank character" })
vim.keymap.set("v", "L", "$", { desc = "To line end" })

-- use Y to yank to the end of line
vim.keymap.set("n", "Y", "y$",  { desc = "Yank to line end" })
vim.keymap.set("v", "Y", "'+y", { desc = "Yank to line end" })

-- buffer & tab navigation
vim.keymap.set("n", "]b", "<cmd>bnext<CR>",   { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bprev<CR>",   { desc = "Previous buffer" })
vim.keymap.set("n", "]t", "<cmd>tabnext<CR>", { desc = "Next tab"  })
vim.keymap.set("n", "[t", "<cmd>tabprev<CR>", { desc = "Previous tab"  })

-- quickfix list & location list navigation
vim.keymap.set("n", "]q", "<cmd>cnext<CR>",   { desc = "Next item in quickfix list" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>",   { desc = "Previous item in quickfix list" })
vim.keymap.set("n", "]Q", "<cmd>clast<CR>",   { desc = "Last item in quickfix list"  })
vim.keymap.set("n", "[Q", "<cmd>cfirst<CR>",  { desc = "First item in quickfix list"  })
vim.keymap.set("n", "]l", "<cmd>lnext<CR>",   { desc = "Next item in location list" })
vim.keymap.set("n", "[l", "<cmd>lprev<CR>",   { desc = "Previous item in location list" })
vim.keymap.set("n", "]L", "<cmd>llast<CR>",   { desc = "Last item in location list"  })
vim.keymap.set("n", "[L", "<cmd>lfirst<CR>",  { desc = "First item in location list"  })

-- <Leader>b[uffer]
vim.keymap.set("n", "<Leader>bd", "<cmd>bdelete<CR>",                 { desc = "Delete buffer"})
vim.keymap.set("n", "<Leader>bn", "<cmd>bnext<CR>",                   { desc = "Next buffer"})
vim.keymap.set("n", "<Leader>bp", "<cmd>bprev<CR>",                   { desc = "Previous buffer"})
vim.keymap.set("n", "<Leader>bN", "<cmd>enew <BAR> startinsert <CR>", { desc = "New buffer"})

-- <Leader>f[ile]
vim.keymap.set("n", "<Leader>fs", "<cmd>update<CR>",          { desc = "Save file" })
vim.keymap.set("n", "<Leader>fR", "<cmd>source $MYVIMRC<CR>", { desc = "Source $MYVIMRC" })
vim.keymap.set("n", "<Leader>fv", "<cmd>e $MYVIMRC<CR>",      { desc = "Edit $MYVIMRC" })

-- <Leader>o[pen]
vim.keymap.set("n", "<Leader>oq", "<cmd>copen<CR>", { desc = "Open quickfix list"})
vim.keymap.set("n", "<Leader>ol", "<cmd>lopen<CR>", { desc = "Open location list"})

-- <Leader>t[ab]
vim.keymap.set("n", "<Leader>tN",  "<cmd>$tabnew<CR>",  { desc = "New tab" })
vim.keymap.set("n", "<Leader>tc",  "<cmd>tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<Leader>to",  "<cmd>tabonly<CR>",  { desc = "Close other tabs" })
vim.keymap.set("n", "<Leader>tn",  "<cmd>tabn<CR>",     { desc = "Next tab" })
vim.keymap.set("n", "<Leader>tp",  "<cmd>tabp<CR>",     { desc = "Previous tab" })
vim.keymap.set("n", "<Leader>tmp", "<cmd>-tabmove<CR>", { desc = "Move tab left" })
vim.keymap.set("n", "<Leader>tmn", "<cmd>+tabmove<CR>", { desc = "Move tab right" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true })

-- save in insert mode
vim.keymap.set("i", "<C-s>", "<cmd>update<CR><esc>", { desc = "Save file" })

-- move cursor using <C-h> and <C-l>
vim.keymap.set("i", "<C-h>", "<left>", { desc = "Move cursor left" })
vim.keymap.set("i", "<C-l>", "<right>", { desc = "Move cursor right" })

-- <Leader>t[oggle]
vim.keymap.set("n", "<Leader>tC", function()
    if vim.wo.colorcolumn ~= "" then
        vim.wo.colorcolumn = ""
    else
        vim.wo.colorcolumn = "80"
    end
end, { desc = "Toggle color column" })

vim.keymap.set("n", "<Leader>tL", function()
    -- if not number nor relativenumber, enable both
    if (not vim.wo.number) and (not vim.wo.relativenumber) then
        vim.wo.number = true
        vim.wo.relativenumber = true
    -- if not number but relativenumber, enable number
    elseif (not vim.wo.number) and vim.wo.relativenumber then
        vim.wo.number = true
        vim.wo.relativenumber = false
    -- if number but not relativenumber, disable all
    elseif vim.wo.number and (not vim.wo.relativenumber) then
        vim.wo.number = false
        vim.wo.relativenumber = false
    -- if both number and relativenumber, enable number
    elseif vim.wo.number and vim.wo.relativenumber then
        vim.wo.number = true
        vim.wo.relativenumber = false
    end
end,  { desc = "Toggle line number" })

vim.keymap.set("n", "<Leader>t\\", function()
    local line = vim.api.nvim_get_current_line()
    local first = string.match(line, "[/\\]")
    if first == nil then return end
    local oppsite = first == "\\" and "/" or "\\"
    line = string.gsub(line, first, oppsite)
    vim.api.nvim_set_current_line(line)
end, { desc = "Toggle path separator" })

-- <Leader>q[uit]
vim.keymap.set("n", "<Leader>q", "<cmd>q<CR>",   { desc = "Quit" })
vim.keymap.set("n", "<Leader>Q", "<cmd>qa!<CR>", { desc = "Quit without save" })

-- <Leader>s[earch]
vim.keymap.set("n", "<Leader>sn", "<cmd>nohlsearch<CR>", { desc = "Disable highlight search" })

-- <Leader>w[indow]
vim.keymap.set("n", "<Leader>ww", "<C-w>w",             { desc = "Cycyle window" })
vim.keymap.set("n", "<Leader>wc", "<C-w>c",             { desc = "Close window" })
vim.keymap.set("n", "<Leader>w-", "<C-w>s",             { desc = "Split window horizontally" })
vim.keymap.set("n", "<Leader>w|", "<C-w>v",             { desc = "Split window vertically" })
vim.keymap.set("n", "<Leader>wh", "<C-w>h",             { desc = "Window left" })
vim.keymap.set("n", "<Leader>wj", "<C-w>j",             { desc = "Window below" })
vim.keymap.set("n", "<Leader>wl", "<C-w>l",             { desc = "Window right" })
vim.keymap.set("n", "<Leader>wk", "<C-w>k",             { desc = "Window above" })
vim.keymap.set("n", "<Leader>wH", "<C-w>5<",            { desc = "Shrink window vertically" })
vim.keymap.set("n", "<Leader>wL", "<C-w>5>",            { desc = "Enlarge window vertically" })
vim.keymap.set("n", "<Leader>wJ", "<cmd>resize +5<CR>", { desc = "Enlarge window horizontally" })
vim.keymap.set("n", "<Leader>wK", "<cmd>resize -5<CR>", { desc = "Shrink window horizontally" })
vim.keymap.set("n", "<Leader>w=", "<C-w>=",             { desc = "Equal-size windows" })
vim.keymap.set("n", "<Leader>wv", "<C-w>v",             { desc = "Split window vertically" })
vim.keymap.set("n", "<Leader>ws", "<C-w>s",             { desc = "Split window horizontally" })
vim.keymap.set("n", "<Leader>wo", "<cmd>only<CR>",      { desc = "Close other windows" })
vim.keymap.set("n", "<Leader>wp", "<C-w><C-p>",         { desc = "Previous window" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]],       { desc = "Normal mode" })
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], { desc = "Window left" })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], { desc = "Window below" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], { desc = "Window above" })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], { desc = "Window right" })

-- File type specific settings
vim.api.nvim_create_autocmd(
    { "BufEnter", "BufWinEnter" },
    {
        group = vim.api.nvim_create_augroup("AutoHotkeyComment", {}),
        pattern = { "*.ahk", "*.ahk2" },
        callback = function()
            vim.bo.commentstring = ";%s"
            vim.bo.comments = "s1:/*,mb:*,ex:*/,:;"
        end
    }
)

-- Plugins
-- automatically bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    if vim.fn.executable("git") == 0 then
        print "Git was not installed. Please install Git first. All plugins will be not installed."
        return
    end
    vim.fn.system({
        "git", "clone", "--filter=blob:none", "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath
    })
end
vim.opt.runtimepath:prepend(lazypath)

-- stop loading plugin configs if lazy is not installed
local lazy_status_ok, lazy = pcall(require, "lazy")
if not lazy_status_ok then
    return
end

lazy.setup({
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",

    -- colorscheme
    {
        "folke/tokyonight.nvim",
        event = "VimEnter",
        config = function()
            require("tokyonight").setup({
                -- the default win separator is too dark
                -- https://github.com/folke/tokyonight.nvim/issues/34
                on_colors = function(colors)
                    colors.border = "#565f89"
                end
            })
            vim.cmd.colorscheme("tokyonight")
        end
    },

    -- chezmoi for dot file management
    { "alker0/chezmoi.vim",
        lazy = false,
        init = function()
            vim.g['chezmoi#use_tmp_buffer'] = true
        end
    },

    -- start time profile
    { "tweekmonster/startuptime.vim", cmd = "StartupTime" },

    {
        "nmac427/guess-indent.nvim",
        event = "BufReadPre",
        config = true,
    },

    -- UI
    {
        "anuvyklack/windows.nvim",
        dependencies = {
            "anuvyklack/middleclass",
            -- this cause a lot of issues
            -- https://github.com/anuvyklack/windows.nvim/issues/23
            -- "anuvyklack/animation.nvim"
        },
        event = "WinEnter",
        init = function()
            -- <Leader>w[indows]
            vim.keymap.set("n", "<Leader>wm", "<cmd>WindowsMaximize<CR>",             { desc = "Maximize window" })
            vim.keymap.set("n", "<Leader>wV", "<cmd>WindowsMaximizeVertically<CR>",   { desc = "Maximize window vertically" })
            vim.keymap.set("n", "<Leader>wH", "<cmd>WindowsMaximizeHorizontally<CR>", { desc = "Maximize window horizontally" })
            vim.keymap.set("n", "<Leader>w=", "<cmd>WindowsEqualize<CR>",             { desc = "Equal-size windows" })
            vim.keymap.set("n", "<Leader>wC", "<cmd>WindowsToggleAutowidth<CR>",      { desc = "Toggle window auto-width" })
        end,
        config = function()
            vim.o.winwidth = 10
            vim.o.winminwidth = 10
            vim.o.equalalways = false
            require("windows").setup({
                ignore = {
                    filetype = { "NvimTree", "DiffviewFiles", "alpha", "Outline", "rbrowser" }
                }
            })
        end
    },
    { "nvim-tree/nvim-web-devicons", opts = { default = true } },
    {
        "romgrk/barbar.nvim",
        event = "VeryLazy",
        init = function()
            vim.g.barbar_auto_setup = false

            vim.keymap.set("n", "]b", "<cmd>BufferNext<CR>",     { desc = "Next buffer" })
            vim.keymap.set("n", "[b", "<cmd>BufferPrevious<CR>", { desc = "Previous buffer" })

            -- <Leader>b[uffers]
            vim.keymap.set("n", "<Leader>bn", "<cmd>BufferNext<CR>",     { desc = "Next buffer" })
            vim.keymap.set("n", "<Leader>bp", "<cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
            vim.keymap.set("n", "<Leader>b1", "<cmd>BufferGoto 1<CR>", { desc = "Go to buffer 1" })
            vim.keymap.set("n", "<Leader>b2", "<cmd>BufferGoto 2<CR>", { desc = "Go to buffer 2" })
            vim.keymap.set("n", "<Leader>b3", "<cmd>BufferGoto 3<CR>", { desc = "Go to buffer 3" })
            vim.keymap.set("n", "<Leader>b4", "<cmd>BufferGoto 4<CR>", { desc = "Go to buffer 4" })
            vim.keymap.set("n", "<Leader>b5", "<cmd>BufferGoto 5<CR>", { desc = "Go to buffer 5" })
            vim.keymap.set("n", "<Leader>b6", "<cmd>BufferGoto 6<CR>", { desc = "Go to buffer 6" })
            vim.keymap.set("n", "<Leader>b7", "<cmd>BufferGoto 7<CR>", { desc = "Go to buffer 7" })
            vim.keymap.set("n", "<Leader>b8", "<cmd>BufferGoto 8<CR>", { desc = "Go to buffer 8" })
            vim.keymap.set("n", "<Leader>b9", "<cmd>BufferGoto 9<CR>", { desc = "Go to buffer 9" })
            vim.keymap.set("n", "<Leader>b0", "<cmd>BufferLast<CR>",   { desc = "Go to buffer last" })

            vim.keymap.set("n", "<Leader>bP", "<cmd>BufferPin<CR>",    { desc = "Pin current buffer" })
            vim.keymap.set("n", "<Leader>bd", "<cmd>BufferClose<CR>",  { desc = "Close buffer" })
            vim.keymap.set("n", "<Leader>bX", "<cmd>BufferClose!<CR>", { desc = "Close buffer without saving" })

            vim.keymap.set("n", "<Leader>b-", "<cmd>BufferPick<CR>",        { desc = "Pick buffer" })
            vim.keymap.set("n", "<Leader>b=", "<cmd>BufferPickDelete<CR>",  { desc = "Pick buffer to delete" })
            -- Sort automatically by...
            vim.keymap.set('n', '<Leader>bB', '<cmd>BufferOrderByBufferNumber<CR>', { desc = "Order buffer by bufnr" })
            vim.keymap.set('n', '<Leader>bD', '<cmd>BufferOrderByDirectory<CR>', { desc = "Order buffer by dir" })
            vim.keymap.set('n', '<Leader>bL', '<cmd>BufferOrderByLanguage<CR>', { desc = "Order buffer by lang" })
            vim.keymap.set('n', '<Leader>bW', '<cmd>BufferOrderByWindowNumber<CR>', { desc = "Order buffer by winnr" })
        end,
        config = true
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true,
                    disabled_filetypes = {
                        statusline = { "alpha", "NvimTree", "Outline" },
                        winbar = {  "alpha", "NvimTree", "toggleterm" }
                    },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        {
                            "branch",
                            icons_enabled = true,
                            icon = "",
                        },
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            sections = { "error", "warn" },
                            symbols = { error = " ", warn = " " },
                            colored = true,
                        }
                    },
                    lualine_c = {},
                    lualine_x = {
                        {
                            "diff",
                            colored = false,
                            symbols = { added = " ", modified = " ", removed = " " },
                            cond = function()
                                return vim.fn.winwidth(0) > 80
                            end
                        }
                    },
                    lualine_y = { "encoding", "filetype", "fileformat" },
                    lualine_z = { "location", "progress" }
                }
            })
        end
    },
    { "tiagovla/scope.nvim", event = "VeryLazy", config = true },
    {
        "RRethy/vim-illuminate",
        event = "BufReadPost",
        keys = {
            { "]n", function() require("illuminate").goto_next_reference(false) end, desc = "Next word under-cursor" },
            { "[n", function() require("illuminate").goto_prev_reference(false) end, desc = "Previous word under-cursor" }
        },
        config = function()
            require("illuminate").configure({ delay = 200, large_file_cutoff = 8000 })
        end
    },
    {
        "moll/vim-bbye",
        cmd = "Bdelete",
        keys = {
            { "<Leader>bd", "<cmd>Bdelete<CR>", desc = "Delete buffer" }
        }
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufReadPre",
        opts = {
            exclude = {
                filetypes = {
                    "lspinfo", "checkhealth", "help", "man", "TelescopeResults",
                    "TelescopePrompt", "alpha", "dashboard", "NvimTree", "Trouble"
                }
            },
            scope = { enabled = false }
        }
    },
    {
        "NvChad/nvim-colorizer.lua",
        cmd = {
            "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerToggle"
        },
        opts = {
            filetypes = { "*", "!lazy" },
            user_default_options = {
                RGB = true,
                RRGGBB = true,
                RRGGBBAA = true,
                AARRGGBB = true,
                mode = "background"
            }
        }
    },
    {
        "akinsho/toggleterm.nvim",
        keys = { "<Leader>tf", "<Leader>th", "<Leader>tv", "<Leader>g=" },
        config = function()
            require("toggleterm").setup({
                size = function(term)
                    if term.direction == "vertical" then
                        return vim.o.columns * 0.3
                    else
                        return 20
                    end
                end,
                float_opts = {
                    border = "curved",
                    winblend = 0,
                    highlights = {
                        border = "Normal",
                        background = "Normal"
                    }
                }
            })

            local shell = vim.o.shell
            if string.lower(jit.os) == "windows" then
                if vim.fn.executable("pwsh") == 1 then
                    shell = "pwsh -NoLogo"
                else
                    shell = "powershell -NoLogo"
                end
            end
            _G.toggle_terminal = function(cmd, direction)
                local terminal = require("toggleterm.terminal").Terminal:new({ cmd = cmd, direction = "horizontal" })
                terminal.direction = direction
                terminal:toggle()
            end

            -- <Leader>t[erminal]
            vim.keymap.set("n", "<Leader>tf", function() toggle_terminal(shell, "float") end,      { desc = "Toggle float terminal" })
            vim.keymap.set("n", "<Leader>th", function() toggle_terminal(shell, "horizontal") end, { desc = "Toggle horizontal terminal" })
            vim.keymap.set("n", "<Leader>tv", function() toggle_terminal(shell, "vertical") end,   { desc = "Toggle vertical terminal" })

            if vim.fn.executable("lazygit") == 1 then
                vim.keymap.set("n", "<Leader>g=", function() toggle_terminal("lazygit", "float") end, { desc = "Toggle Lazygit" })
            end
        end
    },
    {
        "petertriho/nvim-scrollbar",
        config = function()
            local colors = require("tokyonight.colors").setup()

            require("scrollbar").setup({
                handle = {
                    color = colors.fg_gutter,
                    blend = 0
                },
                marks = {
                    GitAdd = { text = "│" },
                    GitChange = { text = "│" },
                },
                handlers = { cursor = false }
            })
        end
    },
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            dashboard.section.footer = {
                type = "text",
                val = {
                    os.date("%Y-%m-%d %H:%M"),
                    "Plugin: " .. require("lazy").stats().count
                },
                opts = { position = "center", hl = "Comment" }
            }

            dashboard.section.buttons.val = {
                dashboard.button("SPC b N", "  New file"),
                dashboard.button("SPC s f", "  Find file"),
                dashboard.button("SPC p s", "  Find project"),
                dashboard.button("SPC f r", "  Recently used files"),
                dashboard.button("SPC s g", "󰈬  Find text"),
                dashboard.button("SPC S l", "  Load Session"),
                dashboard.button("SPC f v", "  Configuration"),
                dashboard.button("SPC Q",   "󰅖  Quit Neovim")
            }

            dashboard.config.layout = {
                { type = "padding", val = 2 },
                dashboard.section.header,
                { type = "padding", val = 2 },
                dashboard.section.buttons,
                { type = "padding", val = 2 },
                dashboard.section.footer
            }

            dashboard.config.opts = {
                margin = 5,
                setup = function()
                    vim.api.nvim_create_autocmd("User", {
                        pattern = "AlphaReady",
                        desc = "Disable status and tabline for alhpa",
                        callback = function()
                            vim.opt.showtabline = 0
                        end
                    })

                    vim.api.nvim_create_autocmd("BufUnload", {
                        buffer = 0,
                        desc = "Enable status and tabline after alhpa",
                        callback = function()
                            vim.opt.showtabline = 2
                        end
                    })
                end
            }

            alpha.setup(dashboard.config)

            -- <Leader>b[uffer]
            vim.keymap.set("n", "<Leader>ba", "<cmd>Alpha<CR>", { desc = "Alpha" })
        end
    },
    {
        "b0o/incline.nvim",
        event = "BufReadPre",
        config = function()
            require("incline").setup({
                window = {
                    margin = {
                        vertical = 0,
                        horizontal = 1,
                    },
                },
                render = function(props)
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
                    local icon, color = require("nvim-web-devicons").get_icon_color(filename)
                    return {
                        { icon, guifg = color },
                        { " " },
                        { filename },
                    }
                end,
            })
        end
    },
    {
        "4513ECHO/vim-snipewin",
        keys = {
            { "-", "<Plug>(snipewin)", "n", remap = true, desc = "Choose windows" }
        }
    },
    {
        "sindrets/winshift.nvim",
        cmd = "WinShift",
        keys = {
            -- use <Leader>wS to change window position
            { "<Leader>wS", "<cmd>WinShift<CR>", desc = "Resize window" }
        },
        opts = { focused_hl_groups = "Search" }
    },

    -- session management
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        keys = {
            -- load the session for the current directory
            { "<leader>Ss", mode = "n", function() require("persistence").load() end },

            -- select a session to load
            { "<leader>SS", mode = "n", function() require("persistence").select() end },

            -- load the last session
            { "<leader>Sl", mode = "n", function() require("persistence").load({ last = true }) end },

            -- stop Persistence => session won't be saved on exit
            { "<leader>Sd", mode = "n", function() require("persistence").stop() end }
        },
        opts = {
            dir = vim.fn.stdpath("state") .. "/sessions/",
            need = 1,
            branch = true
        }
    },

    -- autocompletion
    {
        "zbirenbaum/copilot.lua",
        init = function()
            vim.keymap.set("n", "<Leader>Ct", function()
                require("copilot.suggestion").toggle_auto_trigger()
            end)
        end,
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = { enabled = false },
                suggestion = {
                    enabled = true,
                    keymap = { accept = "<M-'>" }
                }
            })
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "giuxtaposition/blink-cmp-copilot",
    },
    {
        'saghen/blink.cmp',
        event = "InsertEnter",
        dependencies = {
            'rafamadriz/friendly-snippets',
            'giuxtaposition/blink-cmp-copilot',
        },
        version = '*',
        opts = {
            keymap = { preset = "super-tab" },
            sources = {
                default = { "lazydev", "lsp", "path", "snippets", "buffer", "copilot", "lazydev" },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
                        transform_items = function(_, items)
                            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                            local kind_idx = #CompletionItemKind + 1
                            CompletionItemKind[kind_idx] = "Copilot"
                            for _, item in ipairs(items) do
                                item.kind = kind_idx
                            end
                            return items
                        end,
                    },
                    lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
                },
            },
            signature = { enabled = true },
            completion = {
                menu = {
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind", gap = 1 }
                        },
                    },
                },
                documentation = {
                    auto_show = true
                }
            },
            appearance = {
                use_nvim_cmp_as_default = false,
                nerd_font_variant = 'mono',
                kind_icons = {
                    Copilot = "",
                    Text = '󰉿',
                    Method = '󰊕',
                    Function = '󰊕',
                    Constructor = '󰒓',

                    Field = '󰜢',
                    Variable = '󰆦',
                    Property = '󰖷',

                    Class = '󱡠',
                    Interface = '󱡠',
                    Struct = '󱡠',
                    Module = '󰅩',

                    Unit = '󰪚',
                    Value = '󰦨',
                    Enum = '󰦨',
                    EnumMember = '󰦨',

                    Keyword = '󰻾',
                    Constant = '󰏿',

                    Snippet = '󱄽',
                    Color = '󰏘',
                    File = '󰈔',
                    Reference = '󰬲',
                    Folder = '󰉋',
                    Event = '󱐋',
                    Operator = '󰪚',
                    TypeParameter = '󰬛',
                },
            },
        },
        -- allows extending the providers array elsewhere in your config
        -- without having to redefine it
        opts_extend = { "sources.default" }
    },

    -- lsp
    {
        "dnlhc/glance.nvim",
        cmd = { "Glance" },
        config = function()
            require("glance").setup()
        end
    },
    { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },
    { "williamboman/mason-lspconfig.nvim", config = true },
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
             "saghen/blink.cmp" ,
        },
        config = function()
            local lspconfig = require("lspconfig")

            -- custom namespace
            local ns_diag = vim.api.nvim_create_namespace("severe-diagnostics")

            -- reference to the original handler
            local orig_signs_handler = vim.diagnostic.handlers.signs

            -- only show the single most relevant sign for diagnostics
            vim.diagnostic.handlers.signs = {
                show = function(_, bufnr, _, opts)
                    -- get all diagnostics from the whole buffer rather
                    -- than just the diagnostics passed to the handler
                    local diagnostics = vim.diagnostic.get(bufnr)

                    -- find the "worst" diagnostic per line
                    local max_severity_per_line = {}
                    for _, d in pairs(diagnostics) do
                        local m = max_severity_per_line[d.lnum]
                        if not m or d.severity < m.severity then
                            max_severity_per_line[d.lnum] = d
                        end
                    end

                    local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
                    orig_signs_handler.show(ns_diag, bufnr, filtered_diagnostics, opts)
                end,
                hide = function(_, bufnr)
                    orig_signs_handler.hide(ns_diag, bufnr)
                end
            }

            -- use virtual text
            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
                virtual_text = { spacing = 4, prefix = "●" },
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.HINT] = "",
                        [vim.diagnostic.severity.INFO] = ""
                    }
                }
            })

            vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
                local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
                pcall(vim.diagnostic.reset, ns)
                return true
            end

            local diagnostics_active = true
            local diagnostics_virtual = true
            local on_attach = function(client, bufnr)
                vim.keymap.set("n", "gpi", "<cmd>Glance implementations<CR>", { buffer = bufnr, desc = "Glance: Preview implementations" })
                vim.keymap.set("n", "gpr", "<cmd>Glance references<CR>", { buffer = bufnr, desc = "Glance: Preview references" })
                vim.keymap.set("n", "gpd", "<cmd>Glance definitions<CR>", { buffer = bufnr, desc = "Glance: Preview definitions" })
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Lsp: Go to declaration" })
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Lsp: Go to definition" })
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Lsp: Go to implementation" })
                vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Lsp: Signature help" })
                vim.keymap.set("n", "gR", vim.lsp.buf.rename, { buffer = bufnr, desc = "Lsp: Rename under cursor" })
                vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Lsp: List references" })
                vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Lsp: Code actions" })
                vim.keymap.set("n", "gl", function() vim.diagnostic.open_float(nil, { scope = "line" }) end, { buffer = bufnr, desc = "Lsp: Current diagnostic" })
                vim.keymap.set("n", "K",  vim.lsp.buf.hover, { buffer = bufnr, desc = "Lsp: Hover" })
                vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { buffer = bufnr, desc = "Lsp: Previous diagnostic" })
                vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { buffer = bufnr, desc = "Lsp: Next diagnostic" })

                -- rustaceanvim specific
                if client.name == "rust-analyzer" then
                    vim.keymap.set("n", "<LocalLeader>rr", function() vim.cmd.RustLsp("run") end, { buffer = bufnr, desc = "Rust: Run" })
                    vim.keymap.set("n", "<LocalLeader>xm", function() vim.cmd.RustLsp("expandMacro") end, { buffer = bufnr, desc = "Rust: Expand macros" })
                    vim.keymap.set("n", "ga", function() vim.cmd.RustLsp('codeAction') end, { buffer = bufnr, desc = "Rust: Code actions" })
                    vim.keymap.set("n", "<LocalLeader>oc", function() vim.cmd.RustLsp('openCargo') end, { buffer = bufnr, desc = "Rust: Open Cargo.toml" })
                    vim.keymap.set("n", "<LocalLeader>rh", function() vim.cmd.RustLsp('openDocs') end, { buffer = bufnr, desc = "Rust: Open docs under the cursor" })
                    vim.keymap.set({"n", "v"}, "<LocalLeader>j", function() vim.cmd.RustLsp('joinLines') end, { buffer = bufnr, desc = "Rust: Join lines" })
                end

                -- <Leader>l[sp]
                vim.keymap.set("n", "<Leader>lh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { buffer = bufnr, desc = "Lsp: Toggle inlay hints" })
                vim.keymap.set("n", "<Leader>li", "<cmd>LspInfo<CR>", { buffer = bufnr, desc = "Lsp: Info" })
                vim.keymap.set("n", "<Leader>lI", "<cmd>LspInstallInfo<CR>", { buffer = bufnr, desc = "Lsp: Install info" })
                vim.keymap.set("n", "<Leader>lj", function() vim.diagnostic.jump({ count = -1, float = true }) end, { buffer = bufnr, desc = "Lsp: Previous diagnostic" })
                vim.keymap.set("n", "<Leader>lk", function() vim.diagnostic.jump({ count = 1, float = true }) end, { buffer = bufnr, desc = "Lsp: Next diagnostic" })
                vim.keymap.set("n", "<Leader>ll", vim.lsp.codelens.run, { buffer = bufnr, desc = "Lsp: Code lens" })
                vim.keymap.set("n", "<Leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Lsp: Code action" })
                vim.keymap.set("n", "<Leader>lF", function() vim.lsp.buf.format{ timeout_ms = 10000 } end, { buffer = bufnr, desc = "Lsp: Format buffer" })
                vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "Lsp: Rename under cursor" })
                vim.keymap.set("n", "<Leader>lv",
                    function()
                        diagnostics_virtual = not diagnostics_virtual
                        vim.diagnostic.config({ virtual_text = diagnostics_virtual })
                    end,
                    { buffer = bufnr, desc = "Lsp: Show/Hide diagnostics virtual text" }
                )
                vim.keymap.set("n", "<Leader>lt",
                    function()
                        diagnostics_active = not diagnostics_active
                        if diagnostics_active then
                            vim.diagnostic.show()
                        else
                            vim.diagnostic.hide()
                        end
                    end,
                    { buffer = bufnr, desc = "Lsp: show/hide diagnostics" }
                )
            end

            lspconfig.lua_ls.setup({
                on_attach = on_attach,
                capabilities = vim.lsp.protocol.make_client_capabilities(),
                flags = {
                    debounce_text_changes = 150
                },
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                            special = {
                                reload = "require"
                            }
                        },
                        completion = { callSnippet = "Replace" },
                        diagnostics = {
                            globals = { "vim" }
                        },
                        workspace = {
                            library = {
                                vim.fn.expand("$VIMRUNTIME")
                            },
                            maxPreload = 5000,
                            preloadFileSize = 10000,
                            -- Diable the message "Do you need to configure your environment as luassert"
                            checkThirdParty = false
                        },
                        telemetry = {
                            enable = false
                        }
                    }
                }
            })

            vim.g.rustaceanvim = {
                server = {
                    on_attach = on_attach
                }
            }

            vim.lsp.config("*", {
                on_attach = on_attach,
                capabilities = vim.lsp.protocol.make_client_capabilities()
            })

            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls" }
            })
        end
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        lazy = false, -- This plugin is already lazy
    },
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        keys = {
            -- <Leader>t[rouble]
            { "<Leader>tl", "<cmd>Trouble loclist toggle<CR>", desc = "Toggle: Open in Location List" },
            { "<Leader>tq", "<cmd>Trouble quickfix toggle<CR>", desc = "Toggle: Open in Quickfix List" },
            { "<Leader>td", "<cmd>Trouble diagnostics trouble filter.buf=0<CR>", desc = "Trouble: Buffer diagnostics" },
            { "<Leader>tD", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble: Workspace diagnostics" },
            { "<Leader>tO", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Trouble: Symbols" },

            -- use trouble to replace gr
            { "gr", "<cmd>Trouble lsp_references<CR>", desc = "Trouble: List references" },
        },
        opts = { use_diagnostic_signs = true }
    },

    -- dap
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            -- virtual text for the debugger
            { "theHamsta/nvim-dap-virtual-text", opts = {} },
            "jay-babu/mason-nvim-dap.nvim"
        },

        keys = {
            { "<Leader>d", "", desc = "+debug", mode = {"n", "v"} },
            { "<Leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
            { "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
            { "<Leader>dc", function() require("dap").continue() end, desc = "Continue" },
            { "<Leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
            { "<Leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
            { "<Leader>di", function() require("dap").step_into() end, desc = "Step Into" },
            { "<Leader>dj", function() require("dap").down() end, desc = "Down" },
            { "<Leader>dk", function() require("dap").up() end, desc = "Up" },
            { "<Leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
            { "<Leader>do", function() require("dap").step_out() end, desc = "Step Out" },
            { "<Leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
            { "<Leader>dp", function() require("dap").pause() end, desc = "Pause" },
            { "<Leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
            { "<Leader>ds", function() require("dap").session() end, desc = "Session" },
            { "<Leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
            { "<Leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
        },

        config = function()
            require ("mason-nvim-dap").setup({
                automatic_installation = true,
                ensure_installed = {"stylua", "jq"},
                handlers = {}, -- sets up dap in the predefined manner
            })

            vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
        end
    },
    -- fancy UI for the debugger
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        keys = {
            { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
            { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
        },
        opts = {},
        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup(opts)
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({})
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close({})
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close({})
            end
        end,
    },
    -- mason.nvim integration
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
            automatic_installation = true,
            handlers = {},
            ensure_installed = {},
        },
        config = function() end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "tsakirist/telescope-lazy.nvim"
        },
        cmd = "Telescope",
        init = function()
            -- <Leader>sL[azy]
            vim.keymap.set("n", "<Leader>sL", function() require("telescope").extensions.lazy.lazy() end, { desc = "Search plugins"} )

            -- <Leader>b[uffer]
            vim.keymap.set("n", "<Leader>bb", function() require("telescope.builtin").buffers() end, { desc = "Search buffer"})

            -- <Leader>f[ile]
            vim.keymap.set("n", "<Leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Search file" })
            vim.keymap.set("n", "<Leader>fr", function() require("telescope.builtin").oldfiles() end, { desc = "Search recent files" })

            -- <Leader>g[it]
            vim.keymap.set("n", "<Leader>gS", function() require("telescope.builtin").git_status() end, { desc = "Search Git status" })
            vim.keymap.set("n", "<Leader>gB", function() require("telescope.builtin").git_branches() end, { desc = "Search Git branches" })
            vim.keymap.set("n", "<Leader>gC", function() require("telescope.builtin").git_commits() end, { desc = "Search Git commits" })

            -- <Leader>l[ist]
            vim.keymap.set("n", "<Leader>ld", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end, { desc = "List buffer diagnostics" })
            vim.keymap.set("n", "<Leader>lw", function() require("telescope.builtin").diagnostics() end, { desc = "List all diagnostics" })

            -- <Leader>s[earch]
            vim.keymap.set("n", "<Leader>sl", function() require("telescope.builtin").current_buffer_fuzzy_find() end, { desc = "Search buffer words" })
            vim.keymap.set("n", "<Leader>sf", function() require("telescope.builtin").find_files(require("telescope.themes").get_dropdown{ previewer = false }) end, { desc = "Search files (no preview)" })
            vim.keymap.set("n", "<Leader>sb", function() require("telescope.builtin").buffers(require("telescope.themes").get_dropdown{ previewer = false }) end, { desc = "Search themes" })
            vim.keymap.set("n", "<Leader>sB", function() require("telescope.builtin").git_branches() end, { desc = "Search Git branches" })
            vim.keymap.set("n", "<Leader>sC", function() require("telescope.builtin").colorscheme({ enable_preview = true }) end, { desc = "Search Git commits" })
            vim.keymap.set("n", "<Leader>sh", function() require("telescope.builtin").help_tags() end, { desc = "Search helps" })
            vim.keymap.set("n", "<Leader>sM", function() require("telescope.builtin").man_pages() end, { desc = "Search manuals" })
            vim.keymap.set("n", "<Leader>sr", function() require("telescope.builtin").oldfiles() end, { desc = "Search recent files" })
            vim.keymap.set("n", "<Leader>sR", function() require("telescope.builtin").registers() end, { desc = "Search registers" })
            vim.keymap.set("n", "<Leader>sk", function() require("telescope.builtin").keymaps() end, { desc = "Search keymaps" })
            vim.keymap.set("n", "<Leader>sc", function() require("telescope.builtin").commands() end, { desc = "Search commands" })
            vim.keymap.set("n", "<Leader>s/", function() require("telescope.builtin").search_history() end, { desc = "Search search history" })
            vim.keymap.set("n", "<Leader>sm", function() require("telescope.builtin").marks() end, { desc = "Search marks" })
            vim.keymap.set("n", "<Leader>ss", function() require("telescope.builtin").lsp_document_symbols() end, { desc = "Search buffer Lsp symbols" })
            vim.keymap.set("n", "<Leader>sS", function() require("telescope.builtin").lsp_workspace_symbols() end, { desc = "Search workspace Lsp symbols" })
            vim.keymap.set("n", "<Leader>sP", function() require("telescope.builtin").resume() end, { desc = "Resume last serach" })

            -- change comma input text into a lua table
            local input_to_table = function(txt)
                -- trim spaces
                local inputs = vim.fn.input(txt):gsub("^%s*(.-)%s*$", "%1")

                -- return nil if empty string
                if inputs == "" then return nil end

                -- accept comma-separated inputs
                local tbl = {}
                for m in string.gmatch(inputs, "[^,]+") do
                    local tmp = m
                    tmp = tmp:gsub("^%s*(.-)%s*$", "%1")
                    table.insert(tbl, tmp)
                end
                return tbl
            end

            vim.keymap.set("n", "<Leader>s*", function()
                require("telescope.builtin").grep_string({
                    search_dirs = input_to_table("Search Dirs > ")
                })
            end, { desc = "Grep current word" })
            vim.keymap.set("n", "<Leader>sg", function()
                require("telescope.builtin").live_grep({
                    search_dirs = input_to_table("Search Dirs > "),
                    glob_pattern = input_to_table("Globs > ")
                })
            end, { desc = "Grep search" })
        end,
        config = function()
            -- use <Ctrl-l> to send selected to quickfix list
            local mappings = {
                i = {
                    ["<C-l>"] = "send_selected_to_qflist",
                    ["<C-d>"] = "delete_buffer",
                    ["<C-a>"] = "select_all",
                    ["<C-Down>"] = "cycle_history_next",
                    ["<C-Up>"] = "cycle_history_prev",
                },
                n = {
                    ["<C-l>"] = "send_selected_to_qflist",
                    ["<C-d>"] = "delete_buffer",
                    ["<C-a>"] = "select_all"
                }
            }

            -- use <Ctrl-o> to open all items with trouble
            local trouble = require("trouble.sources.telescope")

            vim.tbl_extend("force", mappings,
                {
                    i = { ["<C-o>"] = trouble.open },
                    n = { ["<C-o>"] = trouble.open }
                }
            )

            require("telescope").setup({
                defaults = {
                    mappings = mappings,
                    layout_strategy = "horizontal",
                    layout_config = {
                        prompt_position = "top"
                    },
                    sorting_strategy = "ascending"
                }
            })

            require("telescope").load_extension("fzf")
            require("telescope").load_extension("lazy")
        end
    },
    { "stevearc/dressing.nvim", event = "VeryLazy" },

    -- editing
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local autopairs = require("nvim-autopairs")
            autopairs.setup({
                check_ts = true,
                disable_filetype = { "TelescopePrompt" }
            })
        end
    },
    { "terrortylor/nvim-comment",
        cmd = "CommentToggle",
        init = function()
            -- a hack to get it lazy loaded
            local vim_func = [[
            function! CommentOperatorFake(type) abort
                let reg_save = @@
                execute "lua require('nvim_comment').operator('" . a:type. "')"
                let @@ = reg_save
            endfunction ]]
            vim.api.nvim_call_function("execute", { vim_func })

            vim.keymap.set("n", "gcc", "<cmd>set operatorfunc=CommentOperatorFake<CR>g@l", { desc = "Comment/uncomment line" })
            vim.keymap.set("n", "gc", "<cmd>set operatorfunc=CommentOperatorFake<CR>g@", { desc = "Comment/uncomment line" })
            vim.keymap.set("x", "gc", ":<C-u>call CommentOperatorFake(visualmode())<CR>", { desc = "Comment/uncomment line" })
        end,
        config = function()
            require('nvim_comment').setup()
        end
    },
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        init = function()
            vim.keymap.set("n", "]T", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
            vim.keymap.set("n", "[T", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
        end,
        config = true
    },
    {
        "ggandor/leap.nvim",
        event = "VeryLazy",
        config = function()
            require("leap").set_default_keymaps()
        end
    },
    {
        "ggandor/flit.nvim",
        event = "VeryLazy",
        config = function()
            require("flit").setup()
        end
    },
    {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        config = function()
            require("inc_rename").setup()
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = { move_cursor = true }
    },
    {
        "ntpeters/vim-better-whitespace",
        cmd = {
            "EnableWhitespace",
            "DisableWhitespace",
            "StripWhitespace",
            "ToggleWhitespace",
            "ToggleStripWhitespaceOnSave"
        },
        keys = {
            -- <Leader>t[oggle]
            { "<Leader>tS", "<cmd>ToggleWhitespace<CR>", desc = "Whitespace toggle" },
            { "<Leader>tx", "<cmd>StripWhitespace<CR>", desc = "Whitespace strip" },
            { "<Leader>tX", "<cmd>ToggleStripWhitespaceOnSave<CR>", desc = "whitespace strip on save" }
        }
    },
    {
        "mg979/vim-visual-multi",
        keys = {
            { "<C-n>", mode = { "n", "v" } },
            { "<C-Up>", mode = { "n", "v" } },
            { "<C-Down>", mode = { "n", "v" } },
            { "g/", mode = { "n", "v"} },
        },
        config = function()
            local has_hlslens, hlslens = pcall(require, "hlslens")
            if has_hlslens then
                local overrideLens = function(render, posList, nearest, idx, relIdx)
                    local _ = relIdx
                    local lnum, col = unpack(posList[idx])

                    local text, chunks
                    if nearest then
                        text = ("[%d/%d]"):format(idx, #posList)
                        chunks = {{" ", "Ignore"}, {text, "VM_Extend"}}
                    else
                        text = ("[%d]"):format(idx)
                        chunks = {{" ", "Ignore"}, {text, "HlSearchLens"}}
                    end
                    render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
                end
                local lensBak
                local config = require("hlslens.config")
                vim.api.nvim_create_autocmd("User", {
                    pattern = { "visual_multi_start", "visual_multi_exit" },
                    group = vim.api.nvim_create_augroup("VMlens", {}),
                    callback = function(ev)
                        if ev.match == "visual_multi_start" then
                            lensBak = config.override_lens
                            config.override_lens = overrideLens
                        else
                            config.override_lens = lensBak
                        end
                        hlslens.start()
                    end
                })
            end
        end
    },
    {
        "dhruvasagar/vim-table-mode",
        cmd = { "TableModeToggle", "TableModeRealign", "Tableize" },
        keys = {
            -- <Leader>t[oggle]
            { "<Leader>tmm", "<cmd>TableModeToggle<CR>",  desc = "Table-mode toggle" },
            { "<Leader>tmr", "<cmd>TableModeRealign<CR>", desc = "Table-mode realign" },
            { "<Leader>tmt", "<cmd>Tableize<CR>",         desc = "Table-mode format" },
        },
        config = function()
            vim.g.table_mode_corner = "|"
            vim.g.table_mode_map_prefix = "<Leader>tm"
        end
    },
    {
        "chentoast/marks.nvim",
        keys = { "m", "dm" },
        config = true
    },
    {
        "wsdjeg/vim-fetch",
        keys = { "gF" }
    },
    {
        "windwp/nvim-spectre",
        dependencies = "nvim-lua/plenary.nvim",
        keys = {
            { "<Leader>s-", function() require("spectre").open() end, desc = "Open Spectre search" }
        },
        config = true
    },
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle" ,
        keys = {
            { "<Leader>tu", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" }
        }
    },
    {
        "lambdalisue/suda.vim",
        -- do not load for Windows
        cond = jit.os ~= "Windows",
        cmd = { "SudaRead", "SudaWrite" }
    },
    {
        "kevinhwang91/nvim-hlslens",
        keys = {
            { "n", "<cmd>execute('normal! ' . v:count1 . 'n')<CR><cmd>lua require('hlslens').start()<CR>", "n" },
            { "N", "<cmd>execute('normal! ' . v:count1 . 'N')<CR><cmd>lua require('hlslens').start()<CR>", "n" },
            { "*", "*<Cmd>lua require('hlslens').start()<CR>", "n" },
            { "#", "#<Cmd>lua require('hlslens').start()<CR>", "n"},
            { "g*", "g*<Cmd>lua require('hlslens').start()<CR>", "n" },
            { "g#", "g#<Cmd>lua require('hlslens').start()<CR>", "n" }
        },
        config = function()
            local scrollbar_status_ok, _ = pcall(require, "scrollbar.handers.search")
            if not scrollbar_status_ok then
                require("hlslens").setup()
            else
                require("scrollbar.handlers.search").setup()
            end
        end
    },

    -- file management
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTree", "NvimTreeToggle", "NvimTreeFindFileToggle" },
        keys = {
            -- <Leader>f[iles]
            { "<Leader>fe", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
            { "<Leader>fl", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Locate buffer in NvimTree" },

            -- <Leader>t[oggle]
            { "<Leader>te", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" }
        },
        opts = {
            hijack_netrw = true,
            hijack_cursor = true,

            sync_root_with_cwd = true,
            respect_buf_cwd = true,
            update_cwd = true,
            update_focused_file = {
                enable = true,
                update_cwd = true
            },

            diagnostics = { enable = false },
            actions = {
                open_file = {
                    quit_on_open = true
                }
            },
            on_attach = function(bufnr)
                local api = require('nvim-tree.api')
                local function opts(desc)
                    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end
                api.config.mappings.default_on_attach(bufnr)
                vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
                vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
            end
        }
    },
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = { "Oil" },
        keys = {
            -- <Leader>f[iles]
            { "<Leader>ft", "<cmd>Oil<CR>", desc = "Open parent directory" },
            { "<Leader>fT", "<cmd>Oil --float<CR>", desc = "Open parent directory in float window" }
        },
        opts = {
            view_options = {
                -- Show files and directories that start with "."
                show_hidden = true
            }
        },
    },
    {
        "mikavilpas/yazi.nvim",
        event = "VeryLazy",
        -- <Leader>f[iles]
        keys = {
            { "<Leader>fy", "<cmd>Yazi<CR>", desc = "Open current file using yazi" },
            { "<Leader>fd", "<cmd>Yazi cwd<CR>", desc = "Open CWD using yazi" },
            { "<Leader>ft", "<cmd>Yazi toggle<CR>", desc = "Resume the last yazi session" },
        },
        opts = {
            open_for_directories = true,
            keymaps = {
                show_help = "g?"
            }
        }
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        event = "BufReadPost",
        dependencies = {
            {"PMassicotte/nvim-treesitter-textobjects", commit = "0af9ad6"},
        },
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash", "jsonc", "rust", "c", "cmake", "cpp", "css",
                    "html", "javascript", "latex", "lua", "markdown", "markdown_inline", "python",
                    -- have to make sure parsers for 'c', 'vim', 'lua' and
                    -- 'help' have been installed
                    -- See: https://github.com/nvim-treesitter/nvim-treesitter/issues/3970
                    "r", "rnoweb", "toml", "tsx", "typescript", "vue", "yaml", "vim", "vimdoc"
                },
                sync_install = false,
                auto_install = false,
                additional_vim_regex_highlighting = false,
                highlight = { enable = true, disable = { "r" } },
                autopairs = { enable = true },
                indent = { enable = true },
                incremental_selection = { enable = true },
                textobjects = {
                    select = {
                        enable = true,
                        -- automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,
                        keymaps = {
                            -- capture groups defined in textobjects.scm
                            ["ik"] = "@call.inner",
                            ["ak"] = "@call.outer",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["ai"] = "@conditional.outer",
                            ["ii"] = "@conditional.inner",
                            ["al"] = "@loop.outer",
                            ["il"] = "@loop.inner",
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner"
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<Leader>an"] = "@parameter.inner"
                        },
                        swap_previous = {
                            ["<Leader>ap"] = "@parameter.inner"
                        }
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]]"] = "@class.outer",
                            ["]i"] = "@conditional.outer",
                            ["]l"] = "@loop.outer",
                            ["]k"] = "@call.inner"
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]["] = "@class.outer",
                            ["]I"] = "@conditional.outer",
                            ["]L"] = "@loop.outer",
                            ["]K"] = "@call.outer"
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[["] = "@class.outer",
                            ["[i"] = "@conditional.outer",
                            ["[l"] = "@loop.outer",
                            ["[k"] = "@call.outer"
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[]"] = "@class.outer",
                            ["[I"] = "@conditional.outer",
                            ["[L"] = "@loop.outer",
                            ["[K"] = "@call.outer"
                        }
                    }
                }
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufReadPre",
        config = function()
            require("treesitter-context").setup()
        end,
    },

    -- Git
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        dependencies = "nvim-lua/plenary.nvim",
        init = function()
            -- ][c to navigate hunks
            vim.keymap.set("n", "]c",
                function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() require("gitsigns").nav_hunk('next', { preview = true }) end)
                    return '<Ignore>'
                end,
                { expr = true, desc = "Next diff" }
            )
            vim.keymap.set("n", "[c",
                function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() require("gitsigns").nav_hunk('prev', { preview = true }) end)
                    return '<Ignore>'
                end,
                { expr = true, desc = "Previous diff" }
            )

            -- <Leader>g[it]
            vim.keymap.set("n", "<Leader>gj", function() require("gitsigns").nav_hunk('next', { preview = true }) end, { desc = "Next hunk" })
            vim.keymap.set("n", "<Leader>gk", function() require("gitsigns").nav_hunk('prev', { preview = true }) end, { desc = "Previous hunk" })
            vim.keymap.set("n", "<Leader>gs", function() require("gitsigns").stage_hunk() end, { desc = "Stage hunk" })
            vim.keymap.set("v", "<Leader>gs", function() require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end, { desc = "Stage selected" })
            vim.keymap.set("n", "<Leader>gr", function() require("gitsigns").reset_hunk() end, { desc = "Reset hunk" })
            vim.keymap.set("v", "<Leader>gr", function() require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end, { desc = "Reset selected" })
            vim.keymap.set("n", "<Leader>gl", function() require("gitsigns").setloclist() end, { desc = "List all changes in location list" })
            vim.keymap.set("n", "<Leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Preview hunk" })
            vim.keymap.set("n", "<Leader>gR", function() require("gitsigns").reset_buffer() end, { desc = "Reset buffer" })
            vim.keymap.set("n", "<Leader>gb", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame line" })

            -- ih for text object
            vim.keymap.set("o", "ih", function() require("gitsigns").select_hunk() end, { desc = "Select hunk" })
            vim.keymap.set("x", "ih", function() require("gitsigns").select_hunk() end, { desc = "Select hunk" })
        end,
        config = function()
            require("gitsigns").setup()
            local scrollbar_status_ok, _ = pcall(require, "scrollbar")
            if scrollbar_status_ok then
                require("scrollbar.handlers.gitsigns").setup()
            end
        end
    },
    { "pwntester/octo.nvim", config = true, cmd = { "Octo" } },
    { 
        "tpope/vim-fugitive",
        cmd = { "Git", "Gdiffsplit"},
        keys = {
            { "<Leader>gd", "<cmd>Gdiffsplit<CR>" }
        }
    },

    -- WhichKey
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local whichkey = require("which-key")

            whichkey.setup({
                plugins = { spelling = { enable = true } },
                win = { border = "rounded" }
            })

            whichkey.add({
                { "<Leader>b", { name = "Buffer" }},
                { "<Leader>f", { name = "File" }},
                { "<Leader>g", { name = "Git" }},
                { "<Leader>l", { name = "List" }},
                { "<Leader>o", { name = "Open" }},
                { "<Leader>s", { name = "Search" }},
                { "<Leader>t", { name = "Toggle/Tab" }},
                { "<Leader>w", { name = "Windows" }},
                { "<Leader>q", { name = "Quit" }}

            })
        end
    },

    {
        "keaising/im-select.nvim",
        enabled = vim.fn.has("win32") == 1,
        event = "InsertEnter",
        config = true
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        cmd = {
            "ObsidianOpen", "ObsidianNew", "ObsidianQuickSwitch", "ObsidianSearch",
            "ObsidianWorkspace"
        },
        event = {
          "BufReadPre " .. vim.fn.expand "~" .. "/notes/**.md",
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            workspaces = {
                { name = "personal", path = "~/notes", }
            }
        }
    },

    -- R
    {
        "R-nvim/R.nvim",
        -- lazy = false,
        dependencies = { "mllg/vim-devtools-plugin" },
        ft = { "r", "rout", "rmd", "rhelp", "rnoweb", "quarto" },
        config = function()
            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWinEnter" },
                {
                    group = vim.api.nvim_create_augroup("RCommonSetup", {}),
                    pattern = { "*.r", "*.R" },
                    callback = function()
                        -- set roxygen comment string
                        vim.opt_local.comments:append("b:#'")
                        -- insert current comment leader
                        vim.opt_local.formatoptions:append("r")
                        -- nvim-lspconfig set formatexpr to use lsp formatting,
                        -- which breaks gq for comments
                        vim.opt_local.formatexpr = nil
                    end
                }
            )

            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWinEnter" },
                {
                    group = vim.api.nvim_create_augroup("RQuartoSetup", {}),
                    pattern = { "_quarto.yml" },
                    callback = function()
                        -- wrap long lines
                        vim.wo.wrap = true
                        vim.keymap.set("n", "<LocalLeader>rf",
                            "<cmd>lua require('r.run').start_R('R')<CR>",
                            { buffer = 0, desc = "Send to R: quarto::quarto_render()" }
                        )
                        vim.keymap.set("n", "<LocalLeader>rq",
                            "<cmd>lua require('r.run').quit_R('nosave')<CR>",
                            { buffer = 0, desc = "Send to R: quarto::quarto_render()" }
                        )
                        vim.keymap.set("n", "<LocalLeader>qr",
                            "<cmd>lua require('r.quarto').command('render')<CR>",
                            { buffer = 0, desc = "Send to R: quarto::quarto_render()" }
                        )
                        vim.keymap.set("n", "<LocalLeader>qp",
                            "<cmd>lua require('r.quarto').command('preview')<CR>",
                            { buffer = 0, desc = "Send to R: quarto::quarto_preview()" }
                        )
                        vim.keymap.set("n", "<LocalLeader>qs",
                            "<cmd>lua require('r.quarto').command('stop')<CR>",
                            { buffer = 0, desc = "Send to R: quarto::quarto_preivew_stop()" }
                        )
                    end
                }
            )

            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWinEnter" },
                {
                    group = vim.api.nvim_create_augroup("RMarkdownSetup", {}),
                    pattern = { "*.rmd", "*.Rmd" },
                    callback = function()
                        -- wrap long lines
                        vim.wo.wrap = true
                    end
                }
            )

            -- make vim-devtools-plugin compatible with R.nvim
            vim.g.SendCmdToR = require("r.send").cmd
            vim.fn.RWarningMsg = require("r").warn

            local opts = {}

            -- remove the 'nobuflisted' from the default buffer_opts to list the R buffer
            opts.buffer_opts = "winfixwidth winfixheight"

            -- manually set the R path since scoop did not write registry entries about R
            local use_scoop_r = false
            if string.lower(jit.os) == "windows" and use_scoop_r then
                -- do not update $HOME on Windows since I set it manually
                opts.set_home_env = false

                local path = require("plenary.path")
                local scoop_r = path:new(vim.loop.os_homedir(), "scoop", "apps", "r")
                if scoop_r:exists() then
                    opts.R_path = scoop_r:joinpath("current", "bin").filename:gsub("\\", "/")
                end
            end

            -- disable R startup messages
            opts.R_args = { "--no-save", "--quiet" }

            -- echo when sourcing code
            opts.source_args = "print.eval=TRUE, echo=TRUE, spaced=TRUE"

            -- clear lines before sending code
            opts.clear_line = true

            -- disable debug support
            opts.debug = false

            -- {targets} related keymaps
            local r_set_keymap_targets = function(buffer)
                local buf = buffer == nil and 0 or buffer
                vim.keymap.set("n", "<LocalLeader>tm", "<cmd>lua require('r.send').cmd('targets::tar_make()')<CR>", { buffer = buf, desc = "Make targets"} )
                vim.keymap.set("n", "<LocalLeader>tM", "<cmd>lua require('r.send').cmd('targets::tar_make(callr_function = NULL)')<CR>", { buffer = buf, desc = "Make targets in current session" })
                vim.keymap.set("n", "<LocalLeader>tf", "<cmd>lua require('r.send').cmd('targets::tar_make(use_crew = TRUE)')<CR>", { buffer = buf, desc = "Make targets in parallel" })
                vim.keymap.set("n", "<LocalLeader>tp", "<cmd>lua require('r.run').action('targets::tar_read')<CR>", { buffer = buf, desc = "Print target under cursor" })
                vim.keymap.set("n", "<LocalLeader>tt",
                    function()
                        local word = vim.fn.expand("<cword>")
                        local cmd = "targets::tar_unblock_process(store = '_targets')"
                        cmd = cmd .. "; targets::tar_make('" .. word .."', callr_function = NULL, use_crew = FALSE, as_job = FALSE)"
                        require("r.send").cmd(cmd)
                    end,
                    { buffer = buf, desc = "Make target under cursor" }
                )
                vim.keymap.set("n", "<LocalLeader>tr",
                    function()
                        local word = vim.fn.expand("<cword>")
                        local cmd = word .. " <- targets::tar_read(" .. word ..")"
                        require("r.send").cmd(cmd)
                    end,
                    { buffer = buf, desc = "Print target under cursor" }
                )
                vim.keymap.set("n", "<LocalLeader>tl", "<cmd>lua require('r.send').cmd('targets::tar_source()')<CR>",
                    { buffer = buf, desc = "Reload scripts under 'R'" }
                )
            end

            -- debug related keymaps
            local r_set_keymap_debug = function(buffer)
                local buf = buffer == nil and 0 or buffer
                vim.keymap.set("n", "<LocalLeader>tb", "<cmd>lua require('r.send').cmd('traceback()')<CR>", { buffer = buf, desc = "Send 'trackback()'" })
                vim.keymap.set("n", "<LocalLeader>sq", "<cmd>lua require('r.send').cmd('Q')<CR>", { buffer = buf, desc = "Send 'Q' in debug mode" })
                vim.keymap.set("n", "<LocalLeader>sc", "<cmd>lua require('r.send').cmd('c')<CR>", { buffer = buf, desc = "Send 'c' in debug mode" })
                vim.keymap.set("n", "<LocalLeader>sn", "<cmd>lua require('r.send').cmd('n')<CR>", { buffer = buf, desc = "Send 'n' in debug mode" })
                vim.keymap.set("n", "<LocalLeader>vp", "<cmd>lua require('r.send').cmd('print(.Last.value, n = Inf)')<CR>", { buffer = buf, desc = "Print .Last.value with maximum rows" })

                -- check if TotalCMD is installed
                local totalcmd = require("plenary.path").new(vim.env.LOCALAPPDATA, "TotalCMD64", "TotalCMD64.exe")
                local has_totalcmd = string.lower(jit.os) == "windows" and totalcmd:exists()

                -- open directory using TotalCMD
                local totalcmd_open = function(dir)
                    if not has_totalcmd then return end
                    local rcmd = "system2"
                    rcmd = rcmd .. "('" .. totalcmd.filename:gsub("\\", "/") .. "', "
                    rcmd = rcmd .. "c('/O', '/P=L', sprintf('/L=\"%s\"', " .. dir .. ")))"
                    require("r.send").cmd(rcmd)
                end

                vim.keymap.set("n", "<LocalLeader>sd",
                    function()
                        if not has_totalcmd then
                            require("r.send").cmd("shell.exec(getwd())")
                        else
                            totalcmd_open("getwd()")
                        end
                    end,
                    { buffer = 0, desc = "Open current work directory"}
                )

                vim.keymap.set("n", "<LocalLeader>st",
                    function()
                        if not has_totalcmd then
                            require("r.send").cmd("shell.exec(tempdir())")
                        else
                            totalcmd_open("tempdir()")
                        end
                    end,
                    { buffer = 0, desc = "Open R temp directory"}
                )
            end

            -- {devtools} related keymaps
            local r_dev_find_desc = function(path)
                local desc
                if not path then
                    desc = vim.fn.findfile("DESCRIPTION", ".;")
                else
                    desc = vim.fn.findfile("DESCRIPTION", vim.fn.expand(path) .. ";")
                end

                if not desc or desc == "" then
                    require("r").warn("DESCRIPTION file not found.")
                    return ""
                end

                local p = vim.fn.fnamemodify(desc, ":p:h")
                vim.notify("Using package DESCRIPTION in \"" .. p .. "\".")
                return p:gsub("\\", "/")
            end
            local r_dev_cmd = function(cmd)
                local desc = r_dev_find_desc()
                if desc ~= "" then
                    require("r.send").cmd("devtools::" .. cmd .. "('" .. desc .. "') # [history skip]")
                end
            end

            local r_set_keymap_devtools = function(buffer)
                local buf = buffer == nil and 0 or buffer
                vim.keymap.set("n", "<LocalLeader>da", function() r_dev_cmd("load_all") end,     { buffer = buf, desc = "Load package" })
                vim.keymap.set("n", "<LocalLeader>dd", function() r_dev_cmd("document") end,     { buffer = buf, desc = "Document package" })
                vim.keymap.set("n", "<LocalLeader>dt", function() r_dev_cmd("test") end,         { buffer = buf, desc = "Test package" })
                vim.keymap.set("n", "<LocalLeader>dc", function() r_dev_cmd("check") end,        { buffer = buf, desc = "Check package" })
                vim.keymap.set("n", "<LocalLeader>dr", function() r_dev_cmd("build_readme") end, { buffer = buf, desc = "Build package README" })
                vim.keymap.set("n", "<LocalLeader>dI", function() r_dev_cmd("install") end,      { buffer = buf, desc = "Install package" })

                -- redefine test current file
                vim.keymap.set("n", "<LocalLeader>df",
                    function()
                        local curfile = vim.fn.expand("%:p"):gsub("\\", "/")
                        require("r.send").cmd('devtools::test_active_file("' .. curfile .. '")')
                    end,
                    { buffer = buffer, desc = "Test current file" }
                )
            end

            opts.hook = {
                after_config = function()
                    vim.keymap.set("i", "<M-->", "<C-v><Space><-<C-v><Space>", { buffer = 0, desc = "Insert assign" })
                    vim.keymap.set("i", "<M-=>", "<C-v><Space>%>%<C-v><Space>", { buffer = 0, desc = "Insert {magrittr} pipe" })
                    vim.keymap.set("i", "<M-\\>", "<C-v><Space>|><C-v><Space>", { buffer = 0, desc = "Insert base pipe" })
                    vim.keymap.set("i", "<M-;>", "<C-v><Space>:=<C-v><Space>", { buffer = 0, desc = "Insert {data.table} assign" })

                    -- {targets}
                    r_set_keymap_targets(0)
                    -- {devtools}
                    r_set_keymap_devtools(0)
                    -- debug
                    r_set_keymap_debug(0)
                end,
                after_R_start = function()
                    -- get the R terminal buffer number
                    local r_bufnr = require("r.term").get_buf_nr()

                    -- set keymap to quit R
                    vim.keymap.set("n", "<LocalLeader>rq", "<cmd>lua require('r.run').quit_R('nosave')<CR>", { buffer = r_bufnr, desc = "Quit R" })

                    -- {targets}
                    r_set_keymap_targets(r_bufnr)
                    -- {devtools}
                    r_set_keymap_devtools(r_bufnr)
                    -- debug
                    r_set_keymap_debug(r_bufnr)

                    vim.api.nvim_create_autocmd(
                        { "BufEnter", "BufWinEnter" },
                        {
                            group = vim.api.nvim_create_augroup("RKeymapSetup", {}),
                            pattern = { "*.r", "*.R" },
                            callback = function(args)
                                -- {targets}
                                r_set_keymap_targets(args.buf)
                                -- {devtools}
                                r_set_keymap_devtools(args.buf)
                                -- debug
                                r_set_keymap_debug(args.buf)
                            end
                        }
                    )
                end
            }

            require("r").setup(opts)
        end
    },
    {
        "Vigemus/iron.nvim",
        cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
        keys = {
            -- <Leader>r[epl]
            { "<Leader>rs", "<cmd>IronRepl<CR>",    desc = "Toggle REPL" },
            { "<Leader>rr", "<cmd>IronRestart<CR>", desc = "Restart REPL" },
            { "<Leader>rf", "<cmd>IronFocus<CR>",   desc = "Focus REPL"},
            { "<Leader>rh", "<cmd>IronHide<CR>",    desc = "Hide REPL"},

            -- local keymaps
            { "<LocalLeader>ss",   mode = { "n", "x" }, desc = "Send to REPL"},
            { "<LocalLeader>sf",   desc = "Send file to REPL"},
            { "<LocalLeader>sl",   desc = "Send line to REPL"},
            { "<LocalLeader>sc",   desc = "Send until cursor to REPL"},
            { "<LocalLeader>mb",   desc = "Send text with in mark to REPL"},
            { "<LocalLeader>mm",   mode = { "n", "x" }, desc = "Mark the test object"},
            { "<LocalLeader>md",   desc = "Remove the set mark"},
            { "<LocalLeader><CR>", desc = "Send ENTER to REPL"},
            { "<LocalLeader>cc",   desc = "Send <Ctrl-C> to REPL"},
            { "<LocalLeader>sq",   desc = "Exit REPL"},
            { "<LocalLeader>cl",   desc = "Clear REPL"},
        },

        -- since irons's setup call is `require("iron.core").setup`, instead of
        -- `require("iron").setup` like other plugins would do, we need to tell
        -- lazy.nvim which module to via the `main` key
        main = "iron.core",

        opts = {
            keymaps = {
                send_motion = "<LocalLeader>ss",
                visual_send = "<LocalLeader>ss",
                send_file = "<LocalLeader>sf",
                send_line = "<LocalLeader>sl",
                send_until_cursor = "<LocalLeader>sc",
                mark_motion = "<LocalLeader>mb",
                mark_visual = "<LocalLeader>mm",
                remove_mark = "<LocalLeader>md",
                cr = "<LocalLeader><CR>",
                interrupt = "<LocalLeader>cc",
                exit = "<LocalLeader>sq",
                clear = "<LocalLeader>cl",
            },
            config = {
                repl_open_cmd = "horizontal bot 10 split",
                repl_definition = {
                    R = {
                        command = "R"
                    }
                },
            },
        },
    },
},
{
    -- lazy load all plugins by default
    defaults = {
        lazy = true
    },

    install = {
        colorscheme = { "tokyonight" }
    },

    performance = {
        rtp = {
            disabled_plugins = {
                "gzip", "matchit", "matchparen", "netrwPlugin", "tohtml",
                "tutor", "tarPlugin", "zipPlugin"
            }
        }
    }
}
)
