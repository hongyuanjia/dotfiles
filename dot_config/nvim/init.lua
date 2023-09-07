-- |  \/  \ \ / /\ \   / /_ _|  \/  |  _ \ / ___|
-- | |\/| |\ V /  \ \ / / | || |\/| | |_) | |
-- | |  | | | |    \ V /  | || |  | |  _ <| |___
-- |_|  |_| |_|     \_/  |___|_|  |_|_| \_\\____|
--
--
-- Author: @hongyuanjia
-- Last Modified: 2023-06-15 10:54

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
    signcolumn = "auto:1-9",
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


if vim.fn.has("nvim-0.9.0") == 1 then
    vim.opt.splitkeep = "screen"
end

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
        vim.opt.formatoptions:remove("cro")
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
vim.keymap.set("n", "<Leader>oq", "<cmd>qopen<CR>", { desc = "Open quickfix list"})
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
            require("tokyonight").setup()
            vim.cmd.colorscheme("tokyonight")
        end
    },

    -- chezmoi for dot file management
    { "alker0/chezmoi.vim", lazy = false },

    -- start tim profile
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
    { "kyazdani42/nvim-web-devicons", opts = { default = true } },
    {
        "nanozuki/tabby.nvim",
        event = "VeryLazy",
        init = function()
            vim.keymap.set("n", "<Leader>tR", function()
                vim.ui.input(
                    {
                        prompt = "Tab Name > ",
                        default = nil
                    },
                    function(input)
                        if input and input ~= "" then
                            vim.cmd.TabRename(input)
                        end
                    end
                )
            end,
            { desc = "Tab rename" })
        end,
        config = true
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = "SmiteshP/nvim-navic",
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
                    lualine_c = {
                        {
                            function()
                                local navic = require("nvim-navic")
                                local ret = navic.get_location()
                                return ret:len() > 2000 and "navic error" or ret
                            end,
                            cond = function()
                                local navic = require("nvim-navic")
                                return navic.is_available()
                            end
                        }
                    },
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
                    lualine_y = { "encoding", "filetype" },
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
            require("illuminate").configure({ delay = 200 })
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
        event = "BufReadPre",
        opts = {
            buftype_exclude = { "terminal", "nofile" },
            filetype_exclude = {
                "alpha", "help", "checkhealth", "dashboard", "NvimTree", "Trouble"
            },
            use_treesitter_scope = false
        }
    },
    { "norcalli/nvim-colorizer.lua", event = "BufReadPre", config = true },
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
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        keys = {
            -- <Leader>l[ist]
            { "<Leader>lo", "<cmd>SymbolsOutline<CR>", desc = "List symbols outline" }
        },
        config = true
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
        "natecraddock/sessions.nvim",
        cmd = { "SessionsLoad", "SessionsStop", "SessionsSave" },
        init = function()
            vim.keymap.set("n", "<Leader>Ss", function()
                -- detect if an R terminal is started by NVim-R
                if vim.g.rplugin and vim.g.rplugin.R_bufnr then
                    -- quite R sessions
                    vim.call("RQuit", "nosave")
                    -- delete the buffer
                    vim.cmd("bdelete " .. vim.g.rplugin.R_bufnr)
                end
                vim.ui.input(
                    {
                        prompt = "Session Name > ",
                        default = nil
                    },
                    function(input)
                        if input and input ~= "" then
                            require("sessions").save(input)
                        end
                    end
                )
            end,
            { desc = "Session save" }
            )
            vim.keymap.set("n", "<Leader>Sl", function() require("sessions").load() end, { desc = "Session load" })
        end,
        opts = {
            session_filepath = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions"),
            absolute = true
        }
    },
    {
        "natecraddock/workspaces.nvim",
        init = function()
            vim.keymap.set("n", "<Leader>pa", function()
                vim.ui.input(
                    {
                        prompt = "Project Name > ",
                        default = nil
                    },
                    function(input)
                        if input and input ~= "" then
                            require("workspaces").add(input, nil)
                        end
                    end
                )
            end)
            vim.keymap.set("n", "<Leader>pl", function() require("workspaces").list() end)
            vim.keymap.set("n", "<Leader>ps", function() require("telescope").extensions.workspaces.workspaces() end )
        end,
        config = function()
            require("workspaces").setup({
                hooks = {
                    open = function()
                        if not require("sessions").load(nil, { silent = true }) then
                            require("telescope.builtin").find_files()
                        end
                    end,
                }
            })
            require("telescope").load_extension("workspaces")
        end
    },

    -- autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- completion sources
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "petertriho/cmp-git",
            "uga-rosa/cmp-dictionary",

            -- snippets
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",

            -- Chinese input method
            "yehuohan/cmp-im",
            "yehuohan/cmp-im-zh"
        },
        config = function()
            local cmp = require("cmp")
            local compare = require("cmp.config.compare")
            local luasnip = require("luasnip")

            require("cmp_im").setup({
                tables = require("cmp_im_zh").tables({ "wubi", "pinyin" })
            })
            require("cmp_git").setup()

            require("cmp_dictionary").setup({
                dic = {
                    ["*"] = vim.fn.expand(vim.fn.stdpath("data") .. "/dictionary/en.dict")
                },
                async = true
            })
            require("cmp_dictionary").update()

            vim.keymap.set({"n", "v", "c", "i"}, "<M-;>", function()
                vim.notify(string.format("IM is %s", require("cmp_im").toggle() and "enabled" or "disabled"))
            end, { desc = "Toggle Chinese input method" })

            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            -- load snippets
            require("luasnip/loaders/from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                mapping = {
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs( 4), { "i", "c" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ["<C-y>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ["<C-e>"] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close()
                    }),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        elseif cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ['<Space>'] = cmp.mapping(require("cmp_im").select(), { 'i' })
                },
                sources = cmp.config.sources({
                    { name = "IM"},
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "luasnip" },
                    { name = "nvim_lua" },
                    { name = "git" },
                    { name = "dictionary", keyword_length = 2 },
                    { name = "buffer" },
                    { name = "path" }
                }),
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local kind_icons = {
                            Text = "󰊄",
                            Method = "m",
                            Function = "󰊕",
                            Constructor = "",
                            Field = "",
                            Variable = "",
                            Class = "",
                            Interface = "",
                            Module = "",
                            Property = "",
                            Unit = "",
                            Value = "",
                            Enum = "",
                            Keyword = "",
                            Snippet = "",
                            Color = "",
                            File = "",
                            Reference = "",
                            Folder = "",
                            EnumMember = "",
                            Constant = "",
                            Struct = "",
                            Event = "",
                            Operator = "",
                            TypeParameter = "",
                        }
                        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                            IM = "[IM]",
                        })[entry.source.name]
                        return vim_item
                    end
                },
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        compare.sort_text,
                        compare.kind,
                        compare.offset,
                        compare.exact,
                        compare.score,
                        compare.recently_used,
                        compare.locality,
                        compare.length,
                        compare.order
                    }
                },
                experimental = {
                    ghost_text = { hl_group = "LspCodeLens" },
                    native_menu = false
                }
            })

            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" }
                }
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "cmdline" }
                })
            })
        end
    },

    -- lsp
    {
        "dnlhc/glance.nvim",
        cmd = { "Glance" },
        config = function()
            require("glance").setup()
        end
    },
    {
        "SmiteshP/nvim-navic",
        config = function()
            vim.g.navic_silence = true
            require("nvim-navic").setup({ separator = " ", highlight = true, depth_limit = 5 })
        end,
    },
    { "williamboman/mason.nvim", build = ":MasonUpdate", config = true },
    { "williamboman/mason-lspconfig.nvim", config = true },
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
            "simrat39/rust-tools.nvim",
            "hrsh7th/cmp-nvim-lsp",
            { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
            { "folke/neodev.nvim", config = true }
        },
        config = function()
            -- load neoconf before lspconfig
            require("neoconf").setup()

            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls" }
            })
            local lspconfig = require("lspconfig")

            -- update diagnostic config
            local signs = { Error = "" , Warn = "" , Hint = "" , Info = "" }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- use virtual text
            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
                virtual_text = { spacing = 4, prefix = "●" },
                severity_sort = true,
            })

            vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
                local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
                pcall(vim.diagnostic.reset, ns)
                return true
            end

            local on_attach = function(client, bufnr)
                require("nvim-navic").attach(client, bufnr)
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
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev({ border = 'rounded' }) end, { buffer = bufnr, desc = "Lsp: Previous diagnostic" })
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next({ border = 'rounded' }) end, { buffer = bufnr, desc = "Lsp: Next diagnostic" })

                -- <Leader>l[sp]
                vim.keymap.set("n", "<Leader>li", "<cmd>LspInfo<CR>", { buffer = bufnr, desc = "Lsp: Info" })
                vim.keymap.set("n", "<Leader>lI", "<cmd>LspInstallInfo<CR>", { buffer = bufnr, desc = "Lsp: Install info" })
                vim.keymap.set("n", "<Leader>lj", function() vim.diagnostic.goto_next({ border = 'rounded' }) end, { buffer = bufnr, desc = "Lsp: Next diagnostic" })
                vim.keymap.set("n", "<Leader>lk", function() vim.diagnostic.goto_prev({ border = 'rounded' }) end, { buffer = bufnr, desc = "Lsp: Previous diagnostic" })
                vim.keymap.set("n", "<Leader>ll", vim.lsp.codelens.run, { buffer = bufnr, desc = "Lsp: Code lens" })
                vim.keymap.set("n", "<Leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Lsp: Code action" })
                vim.keymap.set("n", "<Leader>lF", function() vim.lsp.buf.format{ timeout_ms = 10000 } end, { buffer = bufnr, desc = "Lsp: Format buffer" })
                vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "Lsp: Rename under cursor" })
            end


            -- add lsp auto-completion source
            require("lspconfig.util").default_config = vim.tbl_extend(
                "force",
                require("lspconfig.util").default_config,
                {
                    capabilities = require("cmp_nvim_lsp").default_capabilities()
                }
            )
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({ on_attach = on_attach })
                end,

                -- lua
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        on_attach = on_attach,
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
                end,

                -- rust
                ["rust_analyzer"] = function()
                    require('rust-tools').setup({ server = { on_attach = on_attach } })
                end
            })
        end
    },
    { "m-demare/hlargs.nvim", event = "VeryLazy", config = true },
    {
        "folke/trouble.nvim",
        keys = {
            -- <Leader>t[oggle]
            { "<Leader>tt", "<cmd>TroubleToggle<CR>", desc = "Toggle Trouble" },

            -- use trouble to replace gr
            { "gr", "<cmd>TroubleToggle lsp_references<CR>", desc = "List references" },

            -- <Leader>l[ist]
            { "<Leader>ld", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Lsp: Buffer diagnostic" },
            { "<Leader>lw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Lsp: Workspace diagnostic" },

            -- <Leader>o[pen]
            { "<Leader>oq", "<cmd>TroubleToggle quickfix<CR>", desc = "Open quickfix list" },
            { "<Leader>ol", "<cmd>TroubleToggle loclist<CR>", desc = "Open location list"}
        },
        opts = { use_diagnostic_signs = true }
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
            local trouble = require("trouble.providers.telescope")

            vim.tbl_extend("force", mappings,
                {
                    i = { ["<C-o>"] = trouble.open_with_trouble },
                    n = { ["<C-o>"] = trouble.open_with_trouble }
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

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp_status_ok, cmp = pcall(require, "cmp")
            if cmp_status_ok then
                cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
            end
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
    { "kylechui/nvim-surround", event = "BufRead", opts = { move_cursor = false } },
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
            { "<C-n>" }, { "<C-Up>" }, { "<C-Down>" }, { "g/" },
            {"<C-n>",    nil, "x"},
            {"<C-Up>",   nil, "x"},
            {"<C-Down>", nil, "x"},
            {"g/",       nil, "x"}
        }
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
        'stevearc/oil.nvim',
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
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        event = "BufReadPost",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash", "jsonc", "rust", "c", "cmake", "cpp", "css",
                    "html", "javascript", "latex", "lua", "markdown", "python",
                    -- have to make sure parsers for 'c', 'vim', 'lua' and
                    -- 'help' have been installed
                    -- See: https://github.com/nvim-treesitter/nvim-treesitter/issues/3970
                    "r", "toml", "tsx", "typescript", "vue", "yaml", "vim"
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
                            ["]l"] = "@loop.outer"
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]["] = "@class.outer",
                            ["]I"] = "@conditional.outer",
                            ["]L"] = "@loop.outer"
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[["] = "@class.outer",
                            ["[i"] = "@conditional.outer",
                            ["[l"] = "@loop.outer"
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[]"] = "@class.outer",
                            ["[I"] = "@conditional.outer",
                            ["[L"] = "@loop.outer"
                        }
                    }
                },
                playground = { enable = true }
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
    { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

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
                    vim.schedule(function() require("gitsigns").next_hunk({ preview = true }) end)
                    return '<Ignore>'
                end,
                { expr = true, desc = "Next diff" }
            )
            vim.keymap.set("n", "[c",
                function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() require("gitsigns").prev_hunk({ preview = true }) end)
                    return '<Ignore>'
                end,
                { expr = true, desc = "Previous diff" }
            )

            -- <Leader>g[it]
            vim.keymap.set("n", "<Leader>gj", function() require("gitsigns").next_hunk({ preview = true }) end, { desc = "Next hunk" })
            vim.keymap.set("n", "<Leader>gk", function() require("gitsigns").prev_hunk({ preview = true }) end, { desc = "Previous hunk" })
            vim.keymap.set("n", "<Leader>gs", function() require("gitsigns").stage_hunk() end, { desc = "Stage hunk" })
            vim.keymap.set("v", "<Leader>gs", function() require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end, { desc = "Stage selected" })
            vim.keymap.set("n", "<Leader>gr", function() require("gitsigns").reset_hunk() end, { desc = "Reset hunk" })
            vim.keymap.set("v", "<Leader>gr", function() require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end, { desc = "Reset selected" })
            vim.keymap.set("n", "<Leader>gl", function() require("gitsigns").setloclist() end, { desc = "List all changes in location list" })
            vim.keymap.set("n", "<Leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Preview hunk" })
            vim.keymap.set("n", "<Leader>gu", function() require("gitsigns").undo_stage_hunk() end, { desc = "Undo stage hunk" })
            vim.keymap.set("n", "<Leader>gR", function() require("gitsigns").reset_buffer() end, { desc = "Reset buffer" })
            vim.keymap.set("n", "<Leader>gb", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame line" })

            -- ih for text object
            vim.keymap.set("o", "ih", function() require("gitsigns").select_hunk() end, { desc = "Select hunk" })
            vim.keymap.set("x", "ih", function() require("gitsigns").select_hunk() end, { desc = "Select hunk" })
        end,
        config = true
    },
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        config = true
    },
    { "pwntester/octo.nvim", config = true, cmd = { "Octo" } },

    -- WhichKey
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local whichkey = require("which-key")

            whichkey.setup({
                plugins = { spelling = { enable = true } },
                window = { border = "rounded" }
            })

            whichkey.register({
                b = { name = "Buffer" },
                f = { name = "File" },
                g = { name = "Git" },
                l = { name = "List" },
                o = { name = "Open" },
                s = { name = "Search" },
                t = { name = "Toggle/Tab" },
                w = { name = "Windows" },
                q = { name = "Quit" }

            }, { prefix = "<Leader>" })
        end
    },

    -- R
    { "jalvesaq/R-Vim-runtime", lazy = false },
    {
        "jalvesaq/Nvim-R",
        dependencies = { "jalvesaq/R-Vim-runtime" },
        ft = { "r", "rhelp", "rmd", "rnoweb", "rrst", "quarto" },
        config = function()
            -- do not update $HOME on Windows since I set it manually
            if vim.fn.has("win32") == 1 then
                vim.g.R_set_home_env = 0
            end

            -- disable debugging support,
            vim.g.R_debug = 1
            -- do not align function arguments
            vim.g.r_indent_align_args = 0
            -- use two backticks to trigger the Rmarkdown chunk completion
            vim.g.R_rmdchunk = "``"
            -- use <Alt>- to insert assignment
            vim.g.R_assign_map = "<M-->"
            -- show hidden objects in object browser
            vim.g.R_objbr_allnames = 1
            -- use the same working directory as Vim
            vim.g.R_nvim_wd = 1
            -- highlight chunk header as R code
            vim.g.rmd_syn_hl_chunk = 1
            -- only highlight functions when followed by a parenthesis
            vim.g.r_syntax_fun_pattern = 1
            -- set encoding to UTF-8 when sourcing code
            vim.g.R_source_args = 'echo = TRUE, spaced = TRUE, encoding = "UTF-8"'
            -- number of columns to be offset when calculating R terminal width
            vim.g.R_setwidth = 2
            -- manually set the R path since scoop did not write registry entries about R
            if string.lower(jit.os) == "windows" then
                local scoop_r = require("plenary.path").new(vim.loop.os_homedir(), "scoop", "apps", "r")
                if scoop_r:exists() then
                    vim.g.R_path = scoop_r:joinpath("current", "bin").filename:gsub("\\", "/")
                end
            end

            -- auto quit R when close Vim
            vim.cmd[[
                autocmd VimLeave * if exists("g:SendCmdToR") && string(g:SendCmdToR) != "function('SendCmdToR_fake')" | call RQuit("nosave") | endif
            ]]

            -- assign and pipe
            local r_set_keymap_pipe = function (buffer)
                local buf = buffer == nil and 0 or buffer
                vim.keymap.set("i", "<M-->", "<C-v><Space><-<C-v><Space>", { buffer = buf, desc = "Insert assign" })
                vim.keymap.set("i", "<M-=>", "<C-v><Space>%>%<C-v><Space>", { buffer = buf, desc = "Insert {magrittr} pipe" })
                vim.keymap.set("i", "<M-\\>", "<C-v><Space>|><C-v><Space>", { buffer = buf, desc = "Insert base pipe" })
                vim.keymap.set("i", "<M-;>", "<C-v><Space>:=<C-v><Space>", { buffer = buf, desc = "Insert {data.table} assign" })
            end

            -- {targets}
            local r_set_keymap_targets = function (buffer)
                local buf = buffer == nil and 0 or buffer
                vim.keymap.set("n", "<LocalLeader>tm", "<cmd>RSend targets::tar_make()<CR>", { buffer = buf, desc = "Make targets"} )
                vim.keymap.set("n", "<LocalLeader>tM", "<cmd>RSend targets::tar_make(callr_function = NULL)<CR>", { buffer = buf, desc = "Make targets in current session" })
                vim.keymap.set("n", "<LocalLeader>tf", "<cmd>RSend targets::tar_make_future(workers = parallelly::availableCores() - 1L)<CR>", { buffer = buf, desc = "Make targets in parallel" })
                vim.keymap.set("n", "<LocalLeader>tc", "<cmd>RSend targets::tar_make_clustermq(workers = parallelly::availableCores() - 1L)<CR>", { buffer = buf, desc = "Make targets in parallel (clustermq)" })
            end

            -- debug
            local r_set_keymap_debug = function (buffer)
                local buf = buffer == nil and 0 or buffer
                vim.keymap.set("n", "<LocalLeader>tb", "<cmd>RSend traceback()<CR>", { buffer = buf, desc = "Send 'trackback()'" })
                vim.keymap.set("n", "<LocalLeader>sq", "<cmd>RSend Q<CR>", { buffer = buf, desc = "Send 'Q' in debug mode" })
                vim.keymap.set("n", "<LocalLeader>sc", "<cmd>RSend c<CR>", { buffer = buf, desc = "Send 'c' in debug mode" })
                vim.keymap.set("n", "<LocalLeader>sn", "<cmd>RSend n<CR>", { buffer = buf, desc = "Send 'n' in debug mode" })
                if string.lower(jit.os) == "windows" then
                    -- check if TotalCMD is installed
                    local totalcmd = require("plenary.path").new(vim.env.LOCALAPPDATA, "TotalCMD64", "TotalCMD64.exe")
                    local has_totalcmd = function()
                        return totalcmd:exists()
                    end
                    local totalcmd_open = function(dir)
                        if not has_totalcmd() then return end
                        local rcmd = "RSend system2"
                        rcmd = rcmd .. "('" .. totalcmd.filename:gsub("\\", "/") .. "', "
                        rcmd = rcmd .. "c('/O', '/P=L', sprintf('/L=\"%s\"', " .. dir .. ")))"
                        vim.cmd(rcmd)
                    end
                    vim.keymap.set("n", "<LocalLeader>sd",
                        function()
                            if not has_totalcmd() then
                                vim.cmd([[RSend shell.exec(getwd())]])
                            else
                                totalcmd_open("getwd()")
                            end
                        end,
                        { buffer = buf, desc = "Open current work directory"}
                    )
                    vim.keymap.set("n", "<LocalLeader>st",
                        function()
                            if not has_totalcmd() then
                                vim.cmd([[RSend shell.exec(tempdir())]])
                            else
                                totalcmd_open("tempdir()")
                            end
                        end,
                        { buffer = buf, desc = "Open R temp directory"}
                    )
                end
            end

            -- add keymap for quit R if current window is an R terminal
            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWinEnter" },
                {
                    group = vim.api.nvim_create_augroup("RTermSetup", {}),
                    pattern = "*",
                    callback = function(args)
                        -- if current buffer is an R terminal
                        if vim.g.rplugin and vim.g.rplugin.R_bufnr == args.buf then
                            -- set keymap to quit R
                            vim.keymap.set("n", "<LocalLeader>rq", "<cmd>call RQuit('nosave')<CR>", { buffer = args.buf, desc = "Quit R" })

                            -- set other keymap
                            r_set_keymap_targets(args.buf)
                            r_set_keymap_debug(args.buf)
                        end
                    end
                }
            )

            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWinEnter" },
                {
                    group = vim.api.nvim_create_augroup("RCommonSetup", {}),
                    pattern = { "*.r", "*.R", "*.rmd", "*.Rmd", "*.qmd" },
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

            -- keymaps for inserting pipes and debugging
            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWinEnter" },
                {
                    group = vim.api.nvim_create_augroup("RKeymapSetup", {}),
                    pattern = { "*.r", "*.R", "*.rmd", "*.Rmd", "*.qmd" },
                    callback = function(args)
                        vim.wo.colorcolumn = "80"
                        r_set_keymap_pipe(args.buf)
                        r_set_keymap_targets(args.buf)
                        r_set_keymap_debug(args.buf)
                    end
                }
            )

            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWinEnter" },
                {
                    group = vim.api.nvim_create_augroup("RMarkdownSetup", {}),
                    pattern = { "*.rmd", "*.Rmd" },
                    callback = function(args)
                        -- wrap long lines
                        vim.wo.wrap = true

                        function RToggleRmdEnv()
                            -- get current value
                            local env = vim.g.R_rmd_environment

                            if env == ".GlobalEnv" then
                                env = "new.env()"
                                print("Rmd will be rendered in an empty environment.")
                            else
                                env = ".GlobalEnv"
                                print("Rmd will be rendered in global environment.")
                            end
                            vim.g.R_rmd_environment = env
                        end

                        vim.keymap.set("n", "<LocalLeader>re", RToggleRmdEnv, { buffer = args.buf, desc = "Toggle Rmd render environment" })
                    end
                }
            )
        end
    },
    {
        "mllg/vim-devtools-plugin",
        dependencies = "jalvesaq/Nvim-R",
        ft = { "r", "rmd", "rnoweb", "rout", "rhelp" },
        config = function()
            -- devtools
            local r_set_keymap_devtools = function(buffer)
                local buf = buffer == nil and 0 or buffer
                vim.keymap.set("n", "<LocalLeader>da", "<cmd>RLoadPackage<CR>",                   { buffer = buf, desc = "Load package" })
                vim.keymap.set("n", "<LocalLeader>dd", "<cmd>RDocumentPackage<CR>",               { buffer = buf, desc = "Document package" })
                vim.keymap.set("n", "<LocalLeader>dt", "<cmd>RTestPackage<CR>",                   { buffer = buf, desc = "Test package" })
                vim.keymap.set("n", "<LocalLeader>dc", "<cmd>RCheckPackage<CR>",                  { buffer = buf, desc = "Check package" })
                vim.keymap.set("n", "<LocalLeader>dr", "<cmd>RSend devtools::build_readme()<CR>", { buffer = buf, desc = "Build package README" })
                vim.keymap.set("n", "<LocalLeader>dI", "<cmd>RInstallPackage<CR>",                { buffer = buf, desc = "Install package" })
            end

            -- keymap for package development
            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWinEnter" },
                {
                    group = vim.api.nvim_create_augroup("RDevtoolsSetup", {}),
                    pattern = { "*.r", "*.R" },
                    callback = function(args)
                        -- {devtools}
                        r_set_keymap_devtools(args.buf)

                        -- redefine test current file
                        vim.keymap.set("n", "<LocalLeader>df",
                            function()
                                local curfile = vim.fn.substitute(vim.fn.expand('%:p'), '\\', '/', "g")
                                if vim.bo.filetype ~= "r" then
                                    vim.fn['RWarningMsg']("Current file is not an R script.")
                                    return
                                end
                                vim.fn['devtools#send_cmd']('devtools::test_active_file("' .. curfile .. '")')
                            end,
                            { buffer = args.buf, desc = "Test current file" }
                        )
                    end
                }
            )

            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWinEnter" },
                {
                    group = vim.api.nvim_create_augroup("RTermDevtoolsSetup", {}),
                    pattern = "*",
                    callback = function(args)
                        -- if current buffer is an R terminal
                        if vim.g.rplugin and vim.g.rplugin.R_bufnr == args.buf then
                            -- {devtools}
                            r_set_keymap_devtools(args.buf)
                        end
                    end
                }
            )
        end
    }
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

