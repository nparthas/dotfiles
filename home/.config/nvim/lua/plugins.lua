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
    use 'williamboman/nvim-lsp-installer'
    use {
        'jose-elias-alvarez/null-ls.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
    }
    use 'EdenEast/nightfox.nvim'
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
        'amirali/yapf.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
    }

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

end
)

vim.g.vscode_style = 'dark'
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
        lualine_x = { { 'buffers', symbols = { alternate_file = '' } }, },
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

-- requires pylint on path
local nls = require('null-ls')
nls.setup({
    debounce = 150,
    sources = {
        nls.builtins.diagnostics.pylint,
    },
})

vim.keymap.set('n', 'gi', vim.lsp.buf.incoming_calls)
vim.keymap.set('n', 'go', vim.lsp.buf.outgoing_calls)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gc', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gh', vim.lsp.buf.hover)
vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)

vim.keymap.set('n', 'ff', vim.lsp.buf.format)
vim.keymap.set('v', 'ff', vim.lsp.buf.format)

require('nvim-lsp-installer').setup({
    ensure_installed = {
        'rust_analyzer',
        'pyright',
        'clangd',
        'sumneko_lua',
        'ocamllsp',
    },
    ui = {
        icons = {
            server_installed = '✓',
            server_pending = '➜',
            server_uninstalled = '✗'
        }
    }
})

for _, server in ipairs(require('nvim-lsp-installer').get_installed_servers()) do
    if server == 'rust_analyzer' then
        require('rust-tools').setup({
            tools = {
                inlay_hints = {
                    show_parameter_hints = false,
                    parameter_hints_prefix = '',
                    other_hints_prefix = 'type::',
                    highlight = 'TSStructure',
                },
            },
            server = {
                settings = {
                    ['rust-analyzer'] = {
                        checkOnSave = { command = 'clippy' },
                        diagnostics = { disabled = { 'inactive-code' } }
                    }
                }
            },
        })
    else
        require('lspconfig')[server.name].setup({})
    end
end

require('diffview').setup({
    use_icons = false,
})

require('fidget').setup({})

-- requires yapf on path
require('yapf').setup({
    style = os.getenv('HOME') .. '/.yapfrc',
})

vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files)
vim.keymap.set('n', '<C-f>', require('telescope.builtin').live_grep)
vim.keymap.set('n', 'tm', require('telescope.builtin').marks)
vim.keymap.set('n', '<leader><Tab>', require('telescope.builtin').buffers)
vim.keymap.set('n', 'tp', require('telescope.builtin').buffers)

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
                height = 12
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
                ['textDocument/documentSymbol'] = true,
                ['workspace/symbol'] = true,
                ['textDocument/codeAction'] = true,
            },
        },
    }
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('lsp_handlers')

require('nvim-treesitter.configs').setup({
    -- A list of parser names, or 'all'
    ensure_installed = { 'c', 'lua', 'rust', 'cpp', 'python' },

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
})

local cmp = require 'cmp'
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
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
for _, server in ipairs(require('nvim-lsp-installer').get_installed_servers()) do
    require('lspconfig')[server.name].setup({
        capabilites = capabilities
    })
end
