-- |  \/  \ \ / /\ \   / /_ _|  \/  |  _ \ / ___|
-- | |\/| |\ V /  \ \ / / | || |\/| | |_) | |
-- | |  | | | |    \ V /  | || |  | |  _ <| |___
-- |_|  |_| |_|     \_/  |___|_|  |_|_| \_\\____|
--
--
-- Author: @hongyuanjia
-- Last Modified: 2022-11-28 18:09

-- Basic Settings
local options = {
    backup = false,
    swapfile = false,
    writebackup = false,
    undofile = true,

    -- UI
    mouse = "a",
    cmdheight = 2,
    conceallevel = 0,
    pumheight = 10,
    showmode = false,
    showtabline = 2,
    cursorline = true,
    number = true,
    relativenumber = true,
    numberwidth = 4,
    signcolumn = "yes",
    wrap = false,
    scrolloff = 8,
    sidescrolloff = 8,
    termguicolors = true,
    laststatus = 2,
    list = true,
    listchars = "eol:↵,trail:~,tab:>-,nbsp:␣",

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
    softtabstop = 4
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- don't give ins-completion-menu messages
vim.opt.shortmess:append("c")
-- treat '-' as word separator
vim.opt.iskeyword:append("-")
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
vim.opt.formatoptions:append("t")

-- go to last loc when opening a buffer
vim.cmd([[
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
]])

-- highlight on yank
vim.cmd([[
    autocmd TextYankPost * lua vim.highlight.on_yank {}
]])

-- short name for printing
function _G.P(...)
    vim.pretty_print(...)
end

-- remap space as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.keymap.set("", "<Space>", "<Nop>")

-- use jk to go back to normal mode in insert mode
vim.keymap.set("i", "jk", "<Esc>")

-- remap j and k to move across display lines and not real lines
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "gk", "k")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "gj", "j")

-- use <C-[UDLR]> for window resizing
vim.keymap.set("n", "<C-j>", "<cmd>resize -2<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>resize +2<CR>")
vim.keymap.set("n", "<C-l>", "<cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<C-h>", "<cmd>vertical resize +2<CR>")

-- move text up and down
vim.keymap.set("n", "<A-j>", "<Esc><cmd>m .+1<CR>==gi<Esc>")
vim.keymap.set("n", "<A-k>", "<Esc><cmd>m .-2<CR>==gi<Esc>")

-- stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- move text up and down
vim.keymap.set("v", "<A-j>", "<cmd>m .+1<CR>==")
vim.keymap.set("v", "<A-k>", "<cmd>m .-2<CR>==")

-- jump to beginning or end using H and L
vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("v", "H", "^")
vim.keymap.set("v", "L", "$")

-- use Y to yank to the end of line
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("v", "Y", "'+y")

-- buffer & tab navigation
vim.keymap.set("n", "]b", "<cmd>bnext<CR>")
vim.keymap.set("n", "[b", "<cmd>bprev<CR>")
vim.keymap.set("n", "]t", "<cmd>tabnext<CR>")
vim.keymap.set("n", "[t", "<cmd>tabprev<CR>")

-- <Leader>b[uffer]
vim.keymap.set("n", "<Leader>bd", "<cmd>bdelete<CR>")
vim.keymap.set("n", "<Leader>bn", "<cmd>bnext<CR>")
vim.keymap.set("n", "<Leader>bp", "<cmd>bprev<CR>")
vim.keymap.set("n", "<Leader>bN", "<cmd>enew <BAR> startinsert <CR>")

-- <Leader>f[ile]
vim.keymap.set("n", "<Leader>fs", "<cmd>update<CR>")
vim.keymap.set("n", "<Leader>fR", "<cmd>source $MYVIMRC<CR>")
vim.keymap.set("n", "<Leader>fv", "<cmd>e $MYVIMRC<CR>")

-- <Leader>o[pen]
vim.keymap.set("n", "<Leader>oq", "<cmd>qopen<CR>")
vim.keymap.set("n", "<Leader>ol", "<cmd>lopen<CR>")

-- <Leader>t[oggle]
function _G.toggle_colorcolumn()
    if vim.wo.colorcolumn ~= "" then
        vim.wo.colorcolumn = ""
    else
        vim.wo.colorcolumn = "80"
    end
end
function _G.toggle_linenumber()
    vim.cmd[[
        execute {
            \ '00': 'set relativenumber   | set number',
            \ '01': 'set norelativenumber | set number',
            \ '10': 'set norelativenumber | set nonumber',
            \ '11': 'set norelativenumber | set number'
            \ }[&number . &relativenumber]
    ]]
end
function _G.toggle_slash()
    local line = vim.api.nvim_get_current_line()
    local first = string.match(line, "[/\\]")
    if first == nil then return end
    local oppsite = first == "\\" and "/" or "\\"
    line = string.gsub(line, first, oppsite)
    vim.api.nvim_set_current_line(line)
end
vim.keymap.set("n", "<Leader>tc", toggle_colorcolumn)
vim.keymap.set("n", "<Leader>tl", toggle_linenumber)
vim.keymap.set("n", "<Leader>t\\", toggle_slash)

-- <Leader>q[uit]
vim.keymap.set("n", "<Leader>q", "<cmd>q<CR>")
vim.keymap.set("n", "<Leader>Q", "<cmd>qa!<CR>")

-- <Leader>s[earch]
vim.keymap.set("n", "<Leader>sn", "<cmd>nohlsearch<CR>")

-- <Leader>w[indow]
vim.keymap.set("n", "<Leader>ww", "<C-w>w")
vim.keymap.set("n", "<Leader>wc", "<C-w>c")
vim.keymap.set("n", "<Leader>w-", "<C-w>s")
vim.keymap.set("n", "<Leader>w|", "<C-w>v")
vim.keymap.set("n", "<Leader>wh", "<C-w>h")
vim.keymap.set("n", "<Leader>wj", "<C-w>j")
vim.keymap.set("n", "<Leader>wl", "<C-w>l")
vim.keymap.set("n", "<Leader>wk", "<C-w>k")
vim.keymap.set("n", "<Leader>wH", "<C-w>5<")
vim.keymap.set("n", "<Leader>wL", "<C-w>5>")
vim.keymap.set("n", "<Leader>wJ", "<cmd>resize +5<CR>")
vim.keymap.set("n", "<Leader>wK", "<cmd>resize -5<CR>")
vim.keymap.set("n", "<Leader>w=", "<C-w>=")
vim.keymap.set("n", "<Leader>wv", "<C-w>v")
vim.keymap.set("n", "<Leader>ws", "<C-w>s")
vim.keymap.set("n", "<Leader>wo", "<cmd>only<CR>")
vim.keymap.set("n", "<Leader>wp", "<C-w><C-p>")

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
vim.keymap.set("t", "jk",    [[<C-\><C-n>]])
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]])
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]])
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]])
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]])

-- File type specific settings
vim.api.nvim_create_autocmd(
    { "BufEnter", "BufWinEnter" },
    {
        pattern = { "*.ahk", "*.ahk2" },
        callback = function()
            vim.bo.commentstring = ";%s"
            vim.bo.comments = "s1:/*,mb:*,ex:*/,:;"
        end
    }
)

-- Plugins
-- automatically install packer
local packer_install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
    if vim.fn.executable("git") == 0 then
        print "Git was not installed. Please install Git first. All plugins will be not installed."
        return
    end

    PACKER_BOOTSTRAP = vim.fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        packer_install_path,
    }
    print "Installing 'packer.nvim'... Please close and reopen Neovim after installing."
    vim.cmd("packadd packer.nvim")
end

-- stop loading plugin configs if packer is not installed
local packer_status_ok, packer = pcall(require, "packer")
if not packer_status_ok then
    return
end

-- use a popup window for packer
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float {
                border = "rounded"
            }
        end,
    }
}

-- issue a message when packer compilation finishses
vim.api.nvim_create_autocmd(
    { "User" },
    {
        pattern = "PackerCompileDone",
        callback = function()
            vim.notify("Packer Configuration recompiled.", 3)
        end
    }
)

packer.startup(function(use)
    -- packer and basics
    use {
        "wbthomason/packer.nvim",
        config = function()
            -- <Leader>P[acker]
            vim.keymap.set("n", "<Leader>Pc", "<cmd>PackerCompile<CR>")
            vim.keymap.set("n", "<Leader>Pi", "<cmd>PackerInstall<CR>")
            vim.keymap.set("n", "<Leader>Ps", "<cmd>PackerSync<CR>")
            vim.keymap.set("n", "<Leader>Pl", "<cmd>PackerStatus<CR>")
            vim.keymap.set("n", "<Leader>Pu", "<cmd>PackerUpdate<CR>")
        end
    }
    use { "nvim-lua/popup.nvim", module = "popup" }
    use { "nvim-lua/plenary.nvim", module = "plenary" }

    -- chezmoi for dot file management
    use "alker0/chezmoi.vim"

    -- start tim profile
    use {
        "tweekmonster/startuptime.vim",
        cmd = "StartupTime"
    }

    -- plugin lazy loading
    use {
        "lewis6991/impatient.nvim",
        config = function()
            require("impatient").enable_profile()
        end
    }

    -- UI
    use {
        "kyazdani42/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup({ default = true })
        end
    }
    use {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                styles = {
                    comments = { italic = false }
                }
            })
            vim.cmd [[colorscheme tokyonight]]
        end
    }
    use {
        "nvim-lualine/lualine.nvim",
        event = "VimEnter",
        config = function()
            local status_ok, _ = pcall(require, "tokyonight")
            local theme = "auto"
            if status_ok then
                theme = "tokyonight"
            end

            require("lualine").setup({
                options = {
                    theme = theme,
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
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
                            colored = false,
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
                        },
                        "encoding",
                        {
                            "filetype",
                            icons_enabled = false
                        }

                    }
                }
            })
        end,
    }
    use {
        "akinsho/bufferline.nvim",
        event = "BufReadPre",
        config = function()
            require("bufferline").setup {
                options = {
                    numbers = "none",
                    close_command = "bdelete! %d",
                    left_mouse_command = "buffer %d",
                    middle_mouse_command = "bdelete %d",
                    right_mouse_command = nil,
                    max_name_length = 30,
                    max_prefix_length = 15,
                    seperator_style = "thick",
                    enforce_regular_tabs = true,
                }
            }
        end
    }
    use {
        "RRethy/vim-illuminate",
        event = "CursorHold",
        module = "illuminate",
        config = function()
            vim.g.Illuminate_delay = 200
        end
    }
    use {
        "moll/vim-bbye",
        cmd = "Bdelete",
        keys = { { "n", "<Leader>bd"} },
        config = function()
            if packer_plugins["bufferline.nvim"] then
                require("bufferline").setup({
                    options = {
                        close_command = "Bdelete! %d",
                        middle_mouse_command = "Bdelete %d"
                    }
                })
            end

            vim.keymap.set("n", "<Leader>bd", "<cmd>Bdelete<CR>")
        end
    }
    use {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        config = function()
            vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
            vim.g.indent_blankline_filetype_exclude = {
                "help",
                "alpha",
                "checkhealth",
                "dashboard",
                "packer",
                "NvimTree"
            }

            -- don't displays a trailing indentation guide on blank lines
            vim.g.indent_blankline_show_trailing_blankline_indent = false
            -- use treesitter to calculate indentation when possible
            vim.g.indent_blankline_use_treesitter = true

            require("indent_blankline").setup({
                show_current_context = true
            })
        end
    }
    use {
        "goolord/alpha-nvim",
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.buttons.val = {
                dashboard.button("SPC b N", "  New file"),
                dashboard.button("SPC s f", "  Find file"),
                dashboard.button("SPC s p", "  Find project"),
                dashboard.button("SPC f r", "  Recently used files"),
                dashboard.button("SPC s g", "  Find text"),
                dashboard.button("SPC S l", "  Load Session"),
                dashboard.button("SPC f v", "  Configuration"),
                dashboard.button("SPC Q",   "  Quit Neovim")
            }

            alpha.setup(dashboard.config)

            -- <Leader>b[uffer]
            vim.keymap.set("n", "<Leader>ba", "<cmd>Alpha<CR>")
        end
    }
    use {
        "norcalli/nvim-colorizer.lua",
        event = "BufReadPre",
        config = function()
            require("colorizer").setup()
        end
    }
    use {
        "akinsho/toggleterm.nvim",
        event = "BufWinEnter",
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
            vim.keymap.set("n", "<Leader>tf", function() toggle_terminal(shell, "float") end)
            vim.keymap.set("n", "<Leader>th", function() toggle_terminal(shell, "horizontal") end)
            vim.keymap.set("n", "<Leader>tv", function() toggle_terminal(shell, "vertical") end)

            if vim.fn.executable("lazygit") == 1 then
                vim.keymap.set("n", "<Leader>g=", function() toggle_terminal("lazygit", "float") end)
            end
        end
    }
    use {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        keys = { { "n", "<Leader>lo"} },
        config = function()
            require("symbols-outline").setup({})

            -- <Leader>l[ist]
            vim.keymap.set("n", "<Leader>lo", "<cmd>SymbolsOutline<CR>")
        end
    }
    use {
        "t9md/vim-choosewin",
        cmd = { "ChooseWin", "ChooseWinSwap", "ChooseWinSwapStay" },
        keys = { { "n", "-" } },
        config = function()
            -- use - to choose window
            vim.keymap.set("n", "-", "<Plug>(choosewin)")
        end
    }
    use {
        "sindrets/winshift.nvim",
        cmd = { "WinShift" },
        keys = { { "n", "<Leader>wS" } },
        config = function()
            require("winshift").setup({ focused_hl_groups = "Search" })

            -- use <Leader>wS to change window position
            vim.keymap.set("n", "<Leader>wS", "<cmd>WinShift<cr>")
        end
    }
    use {
        "dstein64/nvim-scrollview",
        event = "BufRead"
    }

    -- session management
    use {
        "olimorris/persisted.nvim",
        cmd = { "SessionLoad", "SessionLoadLast", "SessionSave" },
        keys = {
            { "n", "<Leader>Sl"},
            { "n", "<Leader>SL"},
            { "n", "<Leader>Ss"}
        },
        config = function()
            require("persisted").setup({})
            require("telescope").load_extension("persisted")

            -- <Leader>S[ession]
            vim.keymap.set("n", "<Leader>Sl", "<cmd>SessionLoad<CR>")
            vim.keymap.set("n", "<Leader>SL", "<cmd>SessionLoadLast<CR>")
            vim.keymap.set("n", "<Leader>Ss", "<cmd>SessionSave<CR>")
        end,
    }

    -- project
    use {
        "ahmedkhalf/project.nvim",
        event = "VimEnter",
        after = "telescope.nvim",
        config = function()
            require("project_nvim").setup({
                detection_methods = {"pattern", "lsp"},
                patterns = {".git", ".svn", ".Rproj", ".here", "package.json"}
            })

            require('telescope').load_extension("projects")
            vim.keymap.set("n", "<Leader>sp", require("telescope").extensions.projects.projects)
        end
    }

    -- autocompletion
    use {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        requires = {
            -- completion sources
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            { "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp" },

            -- snippets
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets"
        },
        config = function()
            local cmp = require("cmp")
            local compare = require('cmp.config.compare')
            local luasnip = require("luasnip")

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
                    { name = "nvim_lua" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" }
                }),
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local kind_icons = {
                            Text = "",
                            Method = "m",
                            Function = "",
                            Constructor = "",
                            Field = "",
                            Variable = "",
                            Class = "",
                            Interface = "",
                            Module = "",
                            Property = "",
                            Unit = "",
                            Value = "",
                            Enum = "",
                            Keyword = "",
                            Snippet = "",
                            Color = "",
                            File = "",
                            Reference = "",
                            Folder = "",
                            EnumMember = "",
                            Constant = "",
                            Struct = "",
                            Event = "",
                            Operator = "",
                            TypeParameter = "",
                        }
                        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end
                },
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        compare.kind,
                        compare.offset,
                        compare.exact,
                        compare.score,
                        compare.recently_used,
                        compare.locality,
                        compare.sort_text,
                        compare.length,
                        compare.order
                    }
                },
                experimental = {
                    ghost_text = true,
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
    }

    -- lsp
    use "neovim/nvim-lspconfig"
    use {
        "williamboman/mason.nvim",
        after = "nvim-lspconfig",
        config = function()
            require("mason").setup()
        end
    }
    use {
        "williamboman/mason-lspconfig.nvim",
        after = "mason.nvim",
        requires = {
            "folke/neodev.nvim",
            "simrat39/rust-tools.nvim",
            "jose-elias-alvarez/null-ls.nvim"
        },
        config = function()
            require("neodev").setup({})

            require("mason-lspconfig").setup({
                ensure_installed = { "sumneko_lua" }
            })

            require("null-ls").setup({
                sources = {
                    require("null-ls").builtins.completion.spell
                }
            })

            -- udpate diagnostic config
            local signs = {
                { name = "DiagnosticSignError", text = "" },
                { name = "DiagnosticSignWarn",  text = "" },
                { name = "DiagnosticSignHint",  text = "" },
                { name = "DiagnosticSignInfo",  text = "" },
            }
            for _, sign in ipairs(signs) do
                vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
            end
            local config = {
                virtual_text = false,
                signs = { active = signs },
                update_in_insert = true,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                }
            }
            vim.diagnostic.config(config)

            -- don't wrap long lines for hover
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
                vim.lsp.handlers.hover, { border = "rounded", wrap = false }
            )

            -- use round border for signature help
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
                vim.lsp.handlers.signature_help, { border = "rounded" }
            )

            -- use virtual text for diagnostics
            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    underline = true,
                    update_in_insert = false,
                    virtual_text = { spacing = 4, prefix = "●" },
                    severity_sort = true
                }
            )

            local on_attach = function(client, bufnr)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
                vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, { buffer = bufnr })
                vim.keymap.set("n", "gR", vim.lsp.buf.rename, { buffer = bufnr })
                vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
                vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { buffer = bufnr })
                vim.keymap.set("n", "gl", function() vim.diagnostic.open_float(nil, { scope = "line" }) end, { buffer = bufnr })
                vim.keymap.set("n", "K",  vim.lsp.buf.hover, { buffer = bufnr })
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev({ border = 'rounded' }) end, { buffer = bufnr })
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next({ border = 'rounded' }) end, { buffer = bufnr })

                -- <Leader>l[sp]
                vim.keymap.set("n", "<Leader>li", "<cmd>LspInfo<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<Leader>lI", "<cmd>LspInstallInfo<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<Leader>lj", function() vim.diagnostic.goto_next({ border = 'rounded' }) end, { buffer = bufnr })
                vim.keymap.set("n", "<Leader>lk", function() vim.diagnostic.goto_prev({ border = 'rounded' }) end, { buffer = bufnr })
                vim.keymap.set("n", "<Leader>ll", vim.lsp.codelens.run, { buffer = bufnr })
                vim.keymap.set("n", "<Leader>la", vim.lsp.buf.code_action, { buffer = bufnr })
                vim.keymap.set("n", "<Leader>lF", vim.lsp.buf.format, { buffer = bufnr })
                vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, { buffer = bufnr })

                vim.cmd[[ command! Format execute 'lua vim.lsp.buf.format()' ]]
            end

            -- add lsp auto-completion source
            if packer_plugins["cmp-nvim-lsp"] then
                require("lspconfig.util").default_config = vim.tbl_extend(
                    "force",
                    require("lspconfig.util").default_config,
                    {
                        capabilities = require("cmp_nvim_lsp").default_capabilities()
                    }
                )
            end

            local lspconfig = require("lspconfig")

            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({ on_attach = on_attach })
                end,

                -- lua
                ["sumneko_lua"] = function()
                    lspconfig.sumneko_lua.setup({
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                runtime = {
                                    version = "LuaJIT"
                                },
                                diagnostics = {
                                    globals = { "vim", "packer_plugins" }
                                },
                                workspace = {
                                    library = {
                                        vim.fn.expand("$VIMRUNTIME")
                                    },
                                    maxPreload = 5000,
                                    preloadFileSize = 10000
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
    }
    use {
        "ray-x/lsp_signature.nvim",
        after = "nvim-lspconfig",
        config = function()
            require("lsp_signature").setup({
                hint_enable = false,
                toggle_key = "<M-`>"
            })
        end
    }
    use {
        "folke/trouble.nvim",
        event = "BufRead",
        cmd = { "TroubleToggle", "Trouble" },
        keys = {
            { "n", "<Leader>tt" },
            { "n", "<Leader>ld" },
            { "n", "<Leader>lw" },
            { "n", "<Leader>oq" },
            { "n", "<Leader>ol" },
            { "n", "gr" },
        },
        config = function()
            require("trouble").setup({ use_diagnostic_signs = true })

            -- <Leader>t[oggle]
            vim.keymap.set("n", "<Leader>tt", "<cmd>TroubleToggle<CR>")

            -- use trouble to replace gr
            vim.keymap.set("n", "gr", "<cmd>TroubleToggle lsp_references<CR>")

            -- <Leader>l[ist]
            vim.keymap.set("n", "<Leader>ld", "<cmd>TroubleToggle document_diagnostics<CR>")
            vim.keymap.set("n", "<Leader>lw", "<cmd>TroubleToggle workspace_diagnostics<CR>")

            -- <Leader>o[pen]
            vim.keymap.set("n", "<Leader>oq", "<cmd>TroubleToggle quickfix<CR>")
            vim.keymap.set("n", "<Leader>ol", "<cmd>TroubleToggle loclist<CR>")
        end
    }

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim"
        },
        cmd = "Telescope",
        module = "telescope",
        keys = {
            { "n", "<Leader>bb" },
            { "n", "<Leader>ff" },
            { "n", "<Leader>fr" },
            { "n", "<Leader>gS" },
            { "n", "<Leader>gB" },
            { "n", "<Leader>gC" },
            { "n", "<Leader>ld" },
            { "n", "<Leader>lw" },
            { "n", "<Leader>sl" },
            { "n", "<Leader>sf" },
            { "n", "<Leader>sb" },
            { "n", "<Leader>sB" },
            { "n", "<Leader>sC" },
            { "n", "<Leader>sh" },
            { "n", "<Leader>sM" },
            { "n", "<Leader>sr" },
            { "n", "<Leader>sR" },
            { "n", "<Leader>sk" },
            { "n", "<Leader>sc" },
            { "n", "<Leader>sg" },
            { "n", "<Leader>s*" },
            { "n", "<Leader>s/" },
            { "n", "<Leader>sm" },
            { "n", "<Leader>ss" },
            { "n", "<Leader>sS" },
            { "n", "<Leader>sP" }
        },
        config = function()
            -- use <Ctrl-l> to send selected to quickfix list
            local mappings = {
                i = {
                    ["<C-l>"] = "send_selected_to_qflist",
                    ["<C-d>"] = "delete_buffer"
                },
                n = {
                    ["<C-l>"] = "send_selected_to_qflist",
                    ["<C-d>"] = "delete_buffer"
                }
            }

            -- use <Ctrl-o> to open all items with trouble
            if packer_plugins["trouble.nvim"] and packer_plugins["trouble.nvim"].loaded then
                local trouble = require("trouble.providers.telescope")

                vim.tbl_extend("force", mappings,
                    {
                        i = {
                            ["<C-o>"] = trouble.open_with_trouble
                        },
                        n = {
                            ["<C-o>"] = trouble.open_with_trouble
                        }
                    }
                )
            end

            require("telescope").setup({ defaults = { mappings = mappings } })

            -- <Leader>b[uffer]
            vim.keymap.set("n", "<Leader>bb", require("telescope.builtin").buffers)

            -- <Leader>f[ile]
            vim.keymap.set("n", "<Leader>ff", require("telescope.builtin").find_files)
            vim.keymap.set("n", "<Leader>fr", require("telescope.builtin").oldfiles)

            -- <Leader>g[it]
            vim.keymap.set("n", "<Leader>gS", require("telescope.builtin").git_status)
            vim.keymap.set("n", "<Leader>gB", require("telescope.builtin").git_branches)
            vim.keymap.set("n", "<Leader>gC", require("telescope.builtin").git_commits)

            -- <Leader>l[ist]
            vim.keymap.set("n", "<Leader>ld", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end)
            vim.keymap.set("n", "<Leader>lw", require("telescope.builtin").diagnostics)

            -- <Leader>s[earch]
            vim.keymap.set("n", "<Leader>sl", require("telescope.builtin").current_buffer_fuzzy_find)
            vim.keymap.set("n", "<Leader>sf", function() require("telescope.builtin").find_files(require("telescope.themes").get_dropdown{ previewer = false }) end)
            vim.keymap.set("n", "<Leader>sb", function() require("telescope.builtin").buffers(require("telescope.themes").get_dropdown{ previewer = false }) end)
            vim.keymap.set("n", "<Leader>sB", require("telescope.builtin").git_branches)
            vim.keymap.set("n", "<Leader>sC", function() require("telescope.builtin").colorscheme({ enable_preview = true }) end)
            vim.keymap.set("n", "<Leader>sh", require("telescope.builtin").help_tags)
            vim.keymap.set("n", "<Leader>sM", require("telescope.builtin").man_pages)
            vim.keymap.set("n", "<Leader>sr", require("telescope.builtin").oldfiles)
            vim.keymap.set("n", "<Leader>sR", require("telescope.builtin").registers)
            vim.keymap.set("n", "<Leader>sk", require("telescope.builtin").keymaps)
            vim.keymap.set("n", "<Leader>sc", require("telescope.builtin").commands)
            vim.keymap.set("n", "<Leader>sg", require("telescope.builtin").live_grep)
            vim.keymap.set("n", "<Leader>s*", require("telescope.builtin").grep_string)
            vim.keymap.set("n", "<Leader>s/", require("telescope.builtin").search_history)
            vim.keymap.set("n", "<Leader>sm", require("telescope.builtin").marks)
            vim.keymap.set("n", "<Leader>ss", require("telescope.builtin").lsp_document_symbols)
            vim.keymap.set("n", "<Leader>sS", require("telescope.builtin").lsp_workspace_symbols)
            vim.keymap.set("n", "<Leader>sP", require("telescope.builtin").resume)
        end
    }
    use {
        "stevearc/dressing.nvim",
        event = "BufReadPre"
    }
    use {
        "nvim-telescope/telescope-fzf-native.nvim",
        after = "telescope.nvim",
        run = "make",
        config = function()
            require("telescope").load_extension("fzf")
        end
    }

    -- editing
    use {
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
    }
    use {
        "terrortylor/nvim-comment",
        keys = {
            { "n", "gcc" },
            { "n", "gc" },
            { "v", "gc" }
        },
        config = function()
            require('nvim_comment').setup({})
        end
    }
    use {
        "antoinemadec/FixCursorHold.nvim",
        config = function()
            vim.g.curshold_updatime = 1000
        end
    }
    use {
        "ggandor/leap.nvim",
        module = { "leap" },
        keys = {
            { "n", "s" },
            { "n", "S" },
            { "n", "f" },
            { "n", "F" },
        },
        config = function()
            require("leap").set_default_keymaps()
        end
    }
    use {
        "kylechui/nvim-surround",
        event = "BufRead",
        config = function()
            require("nvim-surround").setup()
        end
    }
    use {
        "ntpeters/vim-better-whitespace",
        cmd = {
            "EnableWhitespace",
            "DisableWhitespace",
            "StripWhitespace",
            "ToggleWhitespace",
            "ToggleStripWhitespaceOnSave"
        },
        keys = {
            { "n", "<Leader>tS"},
            { "n", "<Leader>tX"}
        },
        config = function()
            -- <Leader>t[oggle]
            vim.keymap.set("n", "<Leader>tS", "<cmd>ToggleWhitespace<CR>")
            vim.keymap.set("n", "<Leader>tx", "<cmd>StripWhitespace<CR>")
            vim.keymap.set("n", "<Leader>tX", "<cmd>ToggleStripWhitespaceOnSave<CR>")
        end
    }
    use {
        "mg979/vim-visual-multi",
        keys = {
            {"n", "<C-n>"},
            {"n", "<C-Up>"},
            {"n", "<C-Down>"},
            {"n", "g/"},
            {"x", "<C-n>"},
            {"x", "<C-Up>"},
            {"x", "<C-Down>"},
            {"x", "g/"}
        }
    }
    use {
        "chentoast/marks.nvim",
        config = function()
            require("marks").setup()
        end
    }
    use {
        "wsdjeg/vim-fetch",
        keys = { { "n", "gF" } }
    }
    use {
        "ThePrimeagen/harpoon",
        requires = "nvim-lua/plenary.nvim",
        keys = {
            { "n", "<Leader>mf" },
            { "n", "<Leader>mm" },
            { "n", "<Leader>mn" },
            { "n", "<Leader>mp" },
            { "n", "<Leader>mt" }
        },
        config = function()
            require("harpoon").setup({})

            -- <Leader>m[ark]
            vim.keymap.set("n", "<Leader>mf", require("harpoon.mark").add_file)
            vim.keymap.set("n", "<Leader>mm", require("harpoon.ui").toggle_quick_menu)
            vim.keymap.set("n", "<Leader>mn", require("harpoon.ui").nav_next)
            vim.keymap.set("n", "<Leader>mp", require("harpoon.ui").nav_prev)
            vim.keymap.set("n", "<Leader>mt", require("harpoon.cmd-ui").toggle_quick_menu)
        end
    }
    use {
        "windwp/nvim-spectre",
        requires = "nvim-lua/plenary.nvim",
        keys = { { "n", "<Leader>s-"} },
        config = function()
            require("spectre").setup({})
            vim.keymap.set("n", "<Leader>s-", require("spectre").open)
        end
    }

    -- file management
    use {
        "kyazdani42/nvim-tree.lua",
        cmd = { "NvimTree", "NvimTreeToggle", "NvimTreeFindFileToggle" },
        keys = {
            { "n", "<Leader>fe" },
            { "n", "<Leader>fl" },
            { "n", "<Leader>te" }
        },
        config = function()
            require("nvim-tree").setup({
                hijack_netrw = true,
                hijack_cursor = true,
                update_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_cwd = true
                },
                diagnostics = {
                    enable = true
                },
                actions = {
                    open_file = {
                        quit_on_open = true
                    }
                },
                view = {
                    mappings = {
                        list = {
                            { key = "h", action = "close_node" },
                            { key = "l", action = "edit"}
                        }
                    }
                }
            })

            -- <Leader>f[iles]
            vim.keymap.set("n", "<Leader>fe", "<cmd>NvimTreeToggle<CR>")
            vim.keymap.set("n", "<Leader>fl", "<cmd>NvimTreeFindFileToggle<CR>")

            -- <Leader>t[oggle]
            vim.keymap.set("n", "<Leader>te", "<cmd>NvimTreeToggle<CR>")
        end
    }

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash", "c", "cmake", "comment", "cpp", "css",
                    "fish", "html", "javascript", "jsonc", "latex",
                    "lua", "markdown", "python", "query", "r", "rust",
                    "toml", "tsx", "typescript", "vue", "yaml"
                },
                highlight = { enable = true },
                autopairs = { enable = true },
                indent = { enable = true },
                incremental_selection = { enable = true },
            })

            -- treesitter based folding
            vim.wo.foldexpr = "expr"
            vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
        end
    }
    use {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "BufRead",
        requires = "nvim-treesitter/nvim-treesitter",
        config = function()
            require('nvim-treesitter.configs').setup({
                textobjects = {
                    select = {
                        enable = true,
                        -- automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,
                        keymaps = {
                            -- capture groups defined in textobjects.scm
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
                        },
                    },
                },
            })
        end
    }
    use {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufRead",
        config = function()
            require("treesitter-context").setup()
        end
    }
    use {
        'nvim-treesitter/playground',
        cmd = {
            "TSPlaygroundToggle"
        }
    }

    -- Git
    use {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        require = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup()

            -- ][c to navigate hunks
            vim.keymap.set("n", "]c", "&diff ? ']c' : '<cmd>lua require(\"gitsigns\").next_hunk({preview=true})<CR>'", { expr = true })
            vim.keymap.set("n", "[c", "&diff ? '[c' : '<cmd>lua require(\"gitsigns\").prev_hunk({preview=true})<CR>'", { expr = true })

            -- <Leader>g[it]
            vim.keymap.set("n", "<Leader>gj", function() require("gitsigns").next_hunk({ preview = true }) end)
            vim.keymap.set("n", "<Leader>gk", function() require("gitsigns").prev_hunk({ preview = true }) end)
            vim.keymap.set("n", "<Leader>gs", require("gitsigns").stage_hunk)
            vim.keymap.set("v", "<Leader>gs", function() require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end)
            vim.keymap.set("n", "<Leader>gr", require("gitsigns").reset_hunk)
            vim.keymap.set("v", "<Leader>gr", function() require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end)
            vim.keymap.set("n", "<Leader>gl", require("gitsigns").setloclist)
            vim.keymap.set("n", "<Leader>gp", require("gitsigns").preview_hunk)
            vim.keymap.set("n", "<Leader>gu", require("gitsigns").undo_stage_hunk)
            vim.keymap.set("n", "<Leader>gR", require("gitsigns").reset_buffer)
            vim.keymap.set("n", "<Leader>gb", function() require("gitsigns").blame_line({ full = true }) end)

            -- ih for text object
            vim.keymap.set("o", "ih", require("gitsigns").select_hunk)
            vim.keymap.set("x", "ih", require("gitsigns").select_hunk)
        end
    }
    use {
        "tpope/vim-fugitive",
        requires = "tpope/vim-rhubarb",
        cmd = { "Git", "Gdiffsplit", "Gwrite" },
        keys = {
            { "n", "<Leader>gg" },
            { "n", "<Leader>gc" },
            { "n", "<Leader>gd" },
            { "n", "<Leader>gw" },
            { "n", "<Leader>gP" }
        },
        config = function()
            vim.keymap.set("n", "<Leader>gg", "<cmd>Git<CR>")
            vim.keymap.set("n", "<Leader>gc", "<cmd>Git commit<CR>")
            vim.keymap.set("n", "<Leader>gd", "<cmd>Gdiffsplit<CR>")
            vim.keymap.set("n", "<Leader>gw", "<cmd>Gwrite<CR>")
            vim.keymap.set("n", "<Leader>gP", "<cmd>Git push<CR>")
        end
    }

    -- WhichKey
    use {
        "folke/which-key.nvim",
        event = "VimEnter",
        config = function()
            local whichkey = require("which-key")

            whichkey.setup({
                plugins = { spelling = { enable = true } },
                window = { border = "rounded" }
            })

            whichkey.register({
                b = {
                    name = "Buffer",
                    a = "Alpha",
                    b = "Search",
                    d = "Delete",
                    n = "Next",
                    p = "Previous",
                    N = "New",
                },
                f = {
                    name = "File",
                    f = "Search",
                    e = "NvimTree",
                    l = "Locate in NvimTree",
                    r = "Recent",
                    s = "Save",
                    R = "Source $MYVIMRC",
                    v = "Edit $MYVIMRC"
                },
                g = {
                    name = "Git",
                    c = "Commit",
                    g = "Status",
                    j = "Next Hunk",
                    k = "Prev Hunk",
                    s = "Stage Hunk",
                    r = "Reset Hunk",
                    p = "preview Hunk",
                    u = "Undo Hunk",
                    w = "Stage Buffer",
                    R = "Reset Buffer",
                    b = "Blame line",
                    d = "Diff",
                    S = "Status",
                    B = "Branches",
                    C = "Commits",
                    P = "Push",
                    l = "Changes to loclist"
                },
                l = {
                    name = "List",
                    a = "Code Action",
                    i = "Lsp Info",
                    I = "Lsp Install",
                    j = "Prev Diagnostic",
                    k = "Next Diagnostic",
                    l = "Codelens",
                    d = "Buffer Diagnostics",
                    w = "Workspace Diagnostics",
                    o = "Symbol Outline",
                    F = "Format Buffer",
                    r = "Rename in Buffer",
                },
                o = {
                    name = "Open",
                    q = "Quickfix",
                    l = "Location List"
                },
                s = {
                    name = "Search",
                    l = "Lines",
                    f = "Files",
                    b = "Buffers",
                    B = "Git Branches",
                    C = "Colorschemes",
                    h = "Help Tags",
                    M = "Manuals",
                    r = "Rencent Files",
                    R = "Registers",
                    k = "Key Maps",
                    c = "Commands",
                    g = "Live Grep",
                    p = "Projects",
                    n = "No Search Highlight",
                    m = "Marks",
                    P = "Resume",
                    s = "Symbols",
                    S = "Workspace Symbols",
                    ["/"] = "Search History",
                    ["*"] = "Grep String"
                },
                t = {
                    name = "Toggle",
                    e = "NvimTree",
                    c = "Colorcolumn",
                    s = "WhiteSpace",
                    t = "Trouble",
                    f = "Float Terminal",
                    h = "Horizontal Terminal",
                    v = "Vertical Terminal",
                    l = "Linenumber",
                    ["\\"] = "Path Slash",
                },
                w = {
                    name = "Windows",
                    w = "Next",
                    c = "Close",
                    ["-"] = "Split Horizontal",
                    ["|"] = "Split Vertical",
                    s = "Split Horizontal",
                    v = "Split Vertical",
                    h = "Left",
                    j = "Below",
                    l = "Right",
                    k = "Below",
                    o = "Only",
                    H = "Resize Left",
                    L = "Resize Right",
                    J = "Resize Above",
                    K = "Resize Below",
                    S = "Shift Window",
                    ["="] = "Resize Equally",
                },
                q = {
                    name = "Quit"
                }

            }, { prefix = "<leader>" })
        end
    }

    -- Lua
    use {
        "milisims/nvim-luaref",
        ft = { "lua" }
    }

    -- R
    use {
        "jalvesaq/R-Vim-runtime",
        ft = { "r", "rmd", "rnoweb", "rout" }
    }
    use {
        "jalvesaq/Nvim-R",
        ft = { "r", "rmd", "rnoweb", "rout" },
        config = function()
            -- do not update $HOME on Windows since I set it manually
            if vim.fn.has('win32') == 1 then
                vim.g.R_set_home_env = 0
            end

            -- disable debugging support
            vim.g.R_debug = 0
            -- do not align function arguments
            vim.g.r_indent_align_args = 0
            -- use two backticks to trigger the Rmarkdown chunk completion
            vim.g.R_rmdchunk = "``"
            -- use <Alt>- to insert assignment
            vim.g.R_assign_map = "<M-->"
            -- show hidden objects in object browser
            vim.g.R_objbr_allnames = 1
            -- show comments when sourced
            vim.g.R_commented_lines = 1
            -- use the same working directory as Vim
            vim.g.R_nvim_wd = 1
            -- highlight chunk header as R code
            vim.g.rmd_syn_hl_chunk = 1
            -- only highlight functions when followed by a parenthesis
            vim.g.r_syntax_fun_pattern = 1
            -- set encoding to UTF-8 when sourcing code
            vim.g.R_source_args = 'echo = TRUE, spaced = TRUE, encoding = "UTF-8"'
            -- number of columns to be offset when calculating R terminal width
            vim.g.R_setwidth = -7
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

            -- nvim-lspconfig set formatexpr to use lsp formatting, which breaks
            -- gq for comments
            vim.opt_local.formatexpr = nil

            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWinEnter" },
                {
                    pattern = { "*.r", "*.R", "*.rmd", "*.Rmd", "*.qmd" },
                    callback = function()
                        -- set roxygen comment string
                        vim.opt_local.comments:append("b:#'")

                        -- insert current comment leader
                        vim.opt_local.formatoptions:append("r")
                    end
                }
            )

            -- keymaps for inserting pipes and debugging
            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWinEnter" },
                {
                    pattern = { "*.r", "*.R", "*.rmd", "*.Rmd", "*.qmd" },
                    callback = function()
                        vim.wo.colorcolumn = "80"

                        -- assign, pipe and data.table assign
                        vim.keymap.set("i", "<M-->", "<C-v><Space><-<C-v><Space>", { buffer = 0 })
                        vim.keymap.set("i", "<M-=>", "<C-v><Space>%>%<C-v><Space>", { buffer = 0 })
                        vim.keymap.set("i", "<M-\\>", "<C-v><Space>|><C-v><Space>", { buffer = 0 })
                        vim.keymap.set("i", "<M-;>", "<C-v><Space>:=<C-v><Space>", { buffer = 0 })

                        -- {targets}
                        vim.keymap.set("n", "<LocalLeader>tm", "<cmd>RSend targets::tar_make()<CR>", { buffer = 0 })
                        vim.keymap.set("n", "<LocalLeader>tM", "<cmd>RSend targets::tar_make(callr_function = NULL)<CR>", { buffer = 0 })
                        vim.keymap.set("n", "<LocalLeader>tf", "<cmd>RSend targets::tar_make_future(workers = parallelly::availableCores() - 1L)<CR>", { buffer = 0 })

                        -- debug
                        vim.keymap.set("n", "<LocalLeader>tb", "<cmd>RSend traceback()<CR>", { buffer = 0 })
                        vim.keymap.set("n", "<LocalLeader>sq", "<cmd>RSend Q<CR>", { buffer = 0 })
                        vim.keymap.set("n", "<LocalLeader>sc", "<cmd>RSend c<CR>", { buffer = 0 })
                        vim.keymap.set("n", "<LocalLeader>sn", "<cmd>RSend n<CR>", { buffer = 0 })
                    end
                }
            )

            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWinEnter" },
                {
                    pattern = { "*.rmd", "*.Rmd" },
                    callback = function()
                        -- wrap long lines
                        vim.wo.wrap = true

                        function RToggleRmdEnv()
                            -- get current value
                            local env = vim.g.R_rmd_environment

                            if env == ".GlobalEnv" then
                                env = "new.env()"
                            else
                                env = ".GlobalEnv"
                            end
                            vim.g.R_rmd_environment = env

                            print("Rmd will be rendered in an empty environment.")
                        end

                        vim.keymap.set("n", "<LocalLeader>re", RToggleRmdEnv, { buffer = 0 })
                    end
                }
            )
        end
    }
    use {
        "mllg/vim-devtools-plugin",
        requires = "jalvesaq/Nvim-R",
        ft = { "r", "rmd", "rnoweb", "rout" },
        config = function()
            -- redefine test current file
            vim.cmd[[ command! -nargs=0 RTestFile :call devtools#test_file() ]]

            -- keymap for package development
            vim.api.nvim_create_autocmd(
                { "BufEnter", "BufWinEnter" },
                {
                    pattern = { "*.r", "*.R" },
                    callback = function()
                        vim.keymap.set("n", "<LocalLeader>da", "<cmd>RLoadPackage<CR>", { buffer = 0 })
                        vim.keymap.set("n", "<LocalLeader>dd", "<cmd>RDocumentPackage<CR>", { buffer = 0 })
                        vim.keymap.set("n", "<LocalLeader>dt", "<cmd>RTestPackage<CR>", { buffer = 0 })
                        vim.keymap.set("n", "<LocalLeader>df", "<cmd>RTestFile<CR>", { buffer = 0 })
                        vim.keymap.set("n", "<LocalLeader>dc", "<cmd>RCheckPackage<CR>", { buffer = 0 })
                        vim.keymap.set("n", "<LocalLeader>dr", "<cmd>RSend devtools::build_readme()<CR>", { buffer = 0 })
                        vim.keymap.set("n", "<LocalLeader>dI", "<cmd>RInstallPackage<CR>", { buffer = 0 })
                    end
                }
            )
        end
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
