local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn

-- ensure that packer is installed
local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    execute 'packadd packer.nvim'
end

vim.cmd('packadd packer.nvim')

local packer = require 'packer'
local util = require 'packer.util'
packer.init({
    package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

--- startup and add configure plugins
packer.startup(function()
    local use = use

    use 'wbthomason/packer.nvim'
    use 'neovim/nvim-lspconfig'
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use {
        'jose-elias-alvarez/null-ls.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
    }
    use 'EdenEast/nightfox.nvim'
    -- https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/JetBrainsMono.zip
    use 'nvim-tree/nvim-web-devicons'
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'chentoast/marks.nvim'
    use 'tversteeg/registers.nvim'
    use 'ntpeters/vim-better-whitespace'
    use 'wsdjeg/vim-fetch'
    use 'tpope/vim-fugitive'
    use 'lewis6991/gitsigns.nvim'
    use 'rust-lang/rust.vim'
    use 'simrat39/rust-tools.nvim'

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        }
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use 'nvim-treesitter/nvim-treesitter-textobjects'

    use 'gbrlsnchs/telescope-lsp-handlers.nvim'

    use 'j-hui/fidget.nvim'

    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'

    use "lukas-reineke/indent-blankline.nvim"

    use { 'sindrets/diffview.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
        }
    }

    use 'LnL7/vim-nix'

    use 'peterhoeg/vim-qml'
    use 'ggandor/leap.nvim'

    use 'p00f/nvim-ts-rainbow'

    use "akinsho/toggleterm.nvim"
end
)

vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")

vim.cmd("autocmd TermOpen * :DisableWhitespace")

vim.cmd [[colorscheme nightfox]]
require('lualine').setup {
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
            'branch',
            'diff',
            { 'diagnostics', sources = { 'nvim_lsp' }, symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' }, }
        },
        lualine_c = { { 'filename', path = 3 } },
        lualine_x = {},
        lualine_y = {
            'filetype',
            -- { 'fileformat', symbols = { unix = '[unix]', dos = '[dos]', mac = '[mac]' } },
            'encoding',
        },
        lualine_z = { 'location', 'progress' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
}

require('gitsigns').setup()
require('marks').setup({
    default_mappings = true,
    signs = true,
    mappings = {}
})

require('leap').add_default_mappings()

require("toggleterm").setup({ shading_factor = 5 })

local tbi = require('telescope.builtin')
local ttm = require("toggleterm.terminal").Terminal
local tpy = ttm:new({ cmd = "python3", hidden = true, direction = 'float' })
local tbc = ttm:new({ cmd = "bytes-cli", hidden = true, direction = 'float' })
local tdy = ttm:new({ cmd = "", hidden = true, direction = 'float' }) -- dummy command, closes floating window
local ttt = ttm:new({ hidden = true, direction = 'float' })

local function termwrap(t)
    return function() t:toggle() end
end

vim.keymap.set('n', '<C-p>', tbi.find_files)
vim.keymap.set('n', '<C-f>', tbi.live_grep)
vim.keymap.set('n', 'tp', tbi.buffers)

vim.keymap.set('n', 'gi', vim.lsp.buf.incoming_calls)
vim.keymap.set('n', 'go', vim.lsp.buf.outgoing_calls)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gc', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gh', vim.lsp.buf.hover)
vim.keymap.set('n', 'gs', vim.lsp.buf.document_symbol)
vim.keymap.set('n', 'gw', tbi.lsp_dynamic_workspace_symbols)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', 'gt', tbi.lsp_type_definitions)

vim.keymap.set('n', 'gm', tbi.marks)
vim.keymap.set('n', 'gp', tbi.registers)
vim.keymap.set('n', 'ga', tbi.git_status)
vim.keymap.set('n', 'ge', tbi.resume)

vim.keymap.set('n', 'ff', vim.lsp.buf.format)
vim.keymap.set('v', 'ff', vim.lsp.buf.format)

vim.keymap.set('n', 'te', termwrap(tpy))
vim.keymap.set('n', 'ts', termwrap(tbc))
vim.keymap.set('n', 'tw', termwrap(tdy))
vim.keymap.set('n', 'tt', termwrap(ttt))

-- requires pylint on path
local nls = require('null-ls')
nls.setup({
    debounce = 150,
    sources = {
        nls.builtins.diagnostics.pylint,
        nls.builtins.formatting.yapf.with({ extra_args = { '--style', os.getenv('HOME') .. '/.yapfrc' } }),
    },
})

require('mason').setup({
    ensure_installed = {
        'yapf'
    },
    ui = {
        icons = {
            server_installed = '✓',
            server_pending = '➜',
            server_uninstalled = '✗'
        }
    }
})

require('mason-lspconfig').setup {
    ensure_installed = {
        'pyright',
        'clangd',
        'lua_ls',
        'ocamllsp',
    },
}

require('nvim-web-devicons').setup({ default = true })
require('diffview').setup({})

require('fidget').setup({})

-- requires `brew intsall fzf`
-- requires `brew install ripgrep`
-- requires `brew install fd`
local actions = require 'telescope.actions'
require('telescope').setup({
    defaults = {
        file_ignore_patterns = { '/.git/', '^.git/', '^.clangd/', '/.clangd/', '^.cache/', '/.cache/' },
        mappings = {
            i = {
                ['<C-f>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
            n = {
                ['<C-f>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
        },
    },
    pickers = {
        find_files = {
            hidden = true,
            follow = true,
        },
        buffers = {
            previewer = false,
            theme = "ivy",
            layout_config = {
                height = 13
            },
        }
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
        },
        lsp_handlers = {
            disable = {
                ['textDocument/declaration'] = true,
                ['textDocument/definition'] = true,
                ['textDocument/implementation'] = true,
                ['textDocument/typeDefinition'] = true,
                ['textDocument/codeAction'] = true,
            },
        },
    }
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('lsp_handlers')

require('nvim-treesitter.configs').setup({
    -- A list of parser names, or 'all'
    ensure_installed = { 'c', 'lua', 'rust', 'cpp', 'python', 'vim', 'vimdoc' },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    highlight = {
        enable = true,
        -- NOTE: these are the names of the parsers and not the filetype.
        disable = { 'rust' },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
        disable = { 'python' },
    },
    rainbow = {
        enable = true,
    }
})

local cmp = require('cmp')
vim.opt.pumheight = 1
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
        end,
    },
    window = {
        documentation = {
            max_height = 0,
        }
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    }, {
        { name = 'buffer' },
    }),
    experimental = {
        ghost_text = true
    },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
for _, server in ipairs(require('mason-lspconfig').get_installed_servers()) do
    require('lspconfig')[server].setup({
        capabilites = capabilities,
    })
end

--rustup component add rust-analyzer
--requred to be run manually to have inlay hints
require('rust-tools').setup({
    tools = {
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = '',
            other_hints_prefix = 'type::',
        },
    },
    server = {
        cmd = { 'rustup', 'run', 'stable', 'rust-analyzer' },
        settings = {
            ['rust-analyzer'] = {
                checkOnSave = { command = 'clippy' },
                diagnostics = { disabled = { 'inactive-code' } }
            }
        }
    },
})
