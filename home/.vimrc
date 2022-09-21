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
set ttyfast
set signcolumn=yes
set mouse=a
set hidden
set wildcharm=<C-z>
set cursorline
if system('uname -s') == "Darwin\n"
  set clipboard=unnamed "OSX
else
  set clipboard=unnamedplus "Linux
endif

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
nnoremap <leader>g :!git diff %<CR>

tnoremap <esc> <C-\><C-N>

let g:rustfmt_autosave = 1

nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev({float=false})<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next({float=false})<CR>

nnoremap <leader><Tab> :buffer<Space><C-z>

nnoremap <leader>o :only<CR>

nnoremap <MiddleMouse> <Nop>
nnoremap <2-MiddleMouse> <Nop>
nnoremap <3-MiddleMouse> <Nop>
nnoremap <4-MiddleMouse> <Nop>

inoremap <MiddleMouse> <Nop>
inoremap <2-MiddleMouse> <Nop>
inoremap <3-MiddleMouse> <Nop>
inoremap <4-MiddleMouse> <Nop>

au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction


" With this function you can reuse the same terminal in neovim.
" You can toggle the terminal and also send a command to the same terminal.
let s:monkey_terminal_window = -1
let s:monkey_terminal_buffer = -1
let s:monkey_terminal_job_id = -1
let s:monkey_terminal_window_size = -1

function! MonkeyTerminalOpen()
  " Check if buffer exists, if not create a window and a buffer
  if !bufexists(s:monkey_terminal_buffer)
    " Creates a window call monkey_terminal
    new monkey_terminal
    " Moves the window to the bottom
    wincmd J
    resize 15
    let s:monkey_terminal_job_id = termopen($SHELL, { 'detach': 1 })

     " Change the name of the buffer to "Terminal 1"
     silent file Terminal\ 1
     " Gets the id of the terminal window
     let s:monkey_terminal_window = win_getid()
     let s:monkey_terminal_buffer = bufnr('%')

    " The buffer of the terminal won't appear in the list of the buffers
    " when calling :buffers command
    set nobuflisted
  else
    if !win_gotoid(s:monkey_terminal_window)
    sp
    " Moves to the window below the current one
    wincmd J
    execute "resize " . s:monkey_terminal_window_size
    buffer Terminal\ 1
     " Gets the id of the terminal window
     let s:monkey_terminal_window = win_getid()
    endif
  endif
  startinsert
endfunction

function! MonkeyTerminalToggle()
  if win_gotoid(s:monkey_terminal_window)
    call MonkeyTerminalClose()
  else
    call MonkeyTerminalOpen()
  endif
endfunction

function! MonkeyTerminalClose()
  if win_gotoid(s:monkey_terminal_window)
    let s:monkey_terminal_window_size = winheight(s:monkey_terminal_window)
    " close the current window
    hide
  endif
endfunction

function! MonkeyTerminalExec(cmd)
  if !win_gotoid(s:monkey_terminal_window)
    call MonkeyTerminalOpen()
  endif

  " clear current input
  call jobsend(s:monkey_terminal_job_id, "clear\n")

  " run cmd
  call jobsend(s:monkey_terminal_job_id, a:cmd . "\n")
  normal! G
  wincmd p
endfunction

" With this maps you can now toggle the terminal
nnoremap <F7> :call MonkeyTerminalToggle()<cr>
tnoremap <F7> <C-\><C-n>:call MonkeyTerminalToggle()<cr>
nnoremap <C-n> :call MonkeyTerminalToggle()<cr>
tnoremap <C-n> <C-\><C-n>:call MonkeyTerminalToggle()<cr>

