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
set wildcharm=<C-z>
set cursorline

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

nnoremap <leader><Tab> :buffer<Space><C-z>

nnoremap <C-p> :Telescope find_files<CR>
nnoremap <C-f> :Telescope live_grep<CR>
nnoremap <C-b> :Telescope buffers<CR>
nnoremap <leader>m :Telescope marks<CR>
nnoremap <leader>r :Telescope registers<CR>

nnoremap <leader>i :lua vim.lsp.buf.incoming_calls()<CR>
nnoremap <leader>o :lua vim.lsp.buf.outgoing_calls()<CR>

nnoremap <leader>f  :lua vim.lsp.buf.formatting()<CR>
nnoremap ƒ          :lua vim.lsp.buf.format_selection()<CR>

" comment hotkeys

au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

