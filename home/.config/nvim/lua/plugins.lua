local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn

-- ensure that packer is installed
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end

vim.cmd('packadd packer.nvim')

local packer = require'packer'
local util = require'packer.util'
packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

--- startup and add configure plugins
packer.startup(function()
  local use = use

  -- checkout null-ls for other langs
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'EdenEast/nightfox.nvim'
  use 'chentau/marks.nvim'
  use 'Mofiqul/vscode.nvim'
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    tag = 'release'
  }
  use 'rust-lang/rust.vim'
  use 'simrat39/rust-tools.nvim'
  use {
    'amirali/yapf.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
       {'nvim-lua/plenary.nvim'},
       {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  end
)

vim.g.vscode_style = "dark"
vim.cmd[[colorscheme vscode]]

require('marks').setup {
    default_mappings = true,
    signs = true,
    mappings = {}
}

require('lspconfig').rust_analyzer.setup({})
require('rust-tools').setup({
    tools = {
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "type::",
            highlight = "TSStructure",
        },
    },
    server = {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = { command = "clippy" },
                diagnostics = { disabled = { "inactive-code" } }
            }
        }
    },
})

require('gitsigns').setup()

-- requires `npm install --global pyright`
require('lspconfig').pyright.setup({})

-- requires yapf on path
require('yapf').setup({
    style = os.getenv("HOME") .. '/.yapfrc',
})

-- requires newer clang or maunal clangd install
require('lspconfig').clangd.setup({})

-- requires `brew intsall brew install ripgrep`
-- requires `brew install fd`
require('telescope').setup({
  defaults = {
    file_ignore_patterns = { "/.git/" },
  },
  pickers = {
    find_files = {
      hidden = true,
      follow = true,
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
})

require('telescope').load_extension('fzf')

require('nvim-treesitter.configs').setup({
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    enable = true,
    -- NOTE: these are the names of the parsers and not the filetype.
    disable = { "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})
