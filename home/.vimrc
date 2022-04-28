colorscheme murphy
syntax enable

set tabstop=4
set shiftwidth=4
set expandtab
set number
set relativenumber
set showcmd
set showmatch
set incsearch
set hlsearch
set title
set foldenable
set splitbelow splitright
set clipboard=unnamedplus
set ttyfast
set signcolumn=yes
set mouse=a
set hidden

augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}

let mapleader=" "

inoremap jk <esc>
nnoremap <leader>w :w<CR>

nnoremap <leader>d :w !diff % -<CR>
nnoremap <leader>g :w !git diff --no-index -- % -<CR>

tnoremap <esc> <C-\><C-N>

let g:rustfmt_autosave = 1

nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev({float=false})<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next({float=false})<CR>


nnoremap <C-p> :Telescope find_files<CR>
nnoremap <leader>p :Telescope find_files<CR>
nnoremap <leader>f :Telescope live_grep<CR>

au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

