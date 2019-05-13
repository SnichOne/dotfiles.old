set mouse=a
set backup             " keep a backup file (restore to previous version)
set ruler              " show the cursor position all the time
set showcmd            " display incomplete commands
set undofile           " keep an undo file (undo changes after closing)

" Don't use Ex mode, use Q for formatting
noremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on
syntax on

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'textwidth' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

augroup vimrcEx
  autocmd!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif

augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif

" Save your backups to a less annoying place than the current directory.
set backupdir-=.

" My nvim config
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

" Change <ESC> key to fast binding jk
inoremap jk <ESC>

" indent public, private, protected
" http://vimdoc.sourceforge.net/htmldoc/indent.html
set cino+=g0

" when you abandon a buffer, Vim will quietly put the still-modified buffer in the background.
set hidden

" Enable enhanced command-line completion
set wildmenu

" Operations such as yy, D, and P work with the system clipboard.
" No need to prefix them with "+ or "*.
set clipboard=unnamedplus


" Let's make it easy to edit this file (mnemonic for the key sequence is
" 'e'dit 'v'imrc)
nmap <silent> ,ev :e $MYVIMRC<cr>
" And to source this file as well (mnemonic for the key sequence is
" 's'ource 'v'imrc)
nmap <silent> ,sv :so $MYVIMRC<cr>


" Magic tab staff
set expandtab tabstop=4 shiftwidth=4 softtabstop=4

" Display line numbers
set number
nmap \l :setlocal number!<CR>

" Change paste mode
nmap \o :set paste!<CR>
nmap j gj
nmap k gk

" Vim command line
cnoremap <C-a>  <Home>
cnoremap <C-b>  <Left>
cnoremap <C-f>  <Right>
cnoremap <C-d>  <Delete>
cnoremap <M-b>  <S-Left>
cnoremap <M-f>  <S-Right>
cnoremap <M-d>  <S-right><Delete>
cnoremap <C-g>  <C-c>

" Search settings
set ignorecase
set smartcase
nmap \q :nohlsearch<CR>

" Buffer settings
nmap <C-e> :e#<CR>
nmap \n :bnext<CR>
nmap \p :bprev<CR>

" Russian lang
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan

" Display wrap line
set colorcolumn=80

" Reindent code
map \re mzgg=G`z<CR>

" Save file
nmap <F2> <esc>:w<cr>
vmap <F2> <esc>:w<cr>
imap <F2> <esc>:w<cr>

" Make go
nmap <F3> <esc>:w<cr>:make go<cr>
vmap <F3> <esc>:w<cr>:make go<cr>v
imap <F3> <esc>:w<cr>:make go<cr>i

call plug#begin('~/.config/nvim/plugged')

" Make sure you use single quotes

" NERD tree will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Zen coding, HTML, XML, etc
Plug 'mattn/emmet-vim'

" Solarized color theme
Plug 'altercation/vim-colors-solarized'

Plug 'itchyny/lightline.vim'
Plug 'benekastah/neomake'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'scrooloose/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'Valloric/YouCompleteMe', {
            \ 'do': 'python3 install.py --clang-completer',
            \ 'for': ['cpp', 'python', 'java']}
autocmd! User YouCompleteMe if !has('vim_starting') | call youcompleteme#Enable() | endif

Plug 'christoomey/vim-tmux-navigator'

" F#
Plug 'fsharp/vim-fsharp', {
      \ 'for': 'fsharp',
      \ 'do':  'make fsautocomplete',
      \}

Plug 'ervandew/supertab', { 'for': 'fsharp' }

Plug 'ntpeters/vim-better-whitespace'

Plug 'tpope/vim-fugitive'

" Python

Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'davidhalter/jedi-vim', {'for': 'python'}

" function! DoRemote(arg)
  " UpdateRemotePlugins
" endfunction
" Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote'), 'for': 'python' }
" Plug 'zchee/deoplete-jedi'


" Swift
Plug 'keith/swift.vim', {'for': 'swift'}

" Javascript
Plug 'pangloss/vim-javascript', {'for': 'javascript'}

" Add plugins to &runtimepath
call plug#end()

" Ocaml
" let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
" execute "set rtp+=" . g:opamshare . "/merlin/vim"
" execute "set rtp+=" . g:opamshare . "/ocp-indent/vim"

" vim-better-whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

" NERDTree
let NERDTreeIgnore = ['\.pyc$', '\~$']
nmap ,n :NERDTreeToggle<cr>
vmap ,n <esc>:NERDTreeToggle<cr>i
" imap ,n <esc>:NERDTreeToggle<cr>i


" Use deoplete.
" let g:deoplete#enable_at_startup = 1
" if !exists('g:deoplete#omni#input_patterns')
  " let g:deoplete#omni#input_patterns = {}
" endif

" Run neomake on the current file on every write
autocmd! BufWritePost * Neomake
let g:neomake_cpp_gcc_maker = {
            \ 'args': ['-std=c++11'],
            \ }
let g:neomake_cpp_enabled_makers = ['gcc']
let g:neomake_python_enabled_makers = ['pylint']

" Lightline
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'MyModified',
      \   'readonly': 'MyReadonly',
      \   'fugitive': 'MyFugitive',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'filename': 'MyFilename',
      \   'mode': 'MyMode',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '' : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? ' '._ : ''
  endif
  return ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

" NERDCommenter
let NERDSpaceDelims = 1

" YouCompleteMe
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_complete_in_comments = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_confirm_extra_conf = 0
let g:ycm_register_as_syntastic_checker = 0

let g:ycm_python_binary_path = 'python'
" let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" jedi-vim
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#completions_enabled = 0
let g:jedi#show_call_signatures = "1"

let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_command = "<leader>d"
let g:jedi#usages_command = "<leader>pu"

" FZF
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <leader>; :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>

nnoremap <silent> <C-p> :FZF<CR>

" Pane switching
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l


let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"


" Solarized color theme
set background=light
" let g:solarized_termcolors=256
silent! colorscheme solarized


" spaces
autocmd FileType html setlocal ts=2 sts=2 sw=2
autocmd FileType javascript setlocal ts=2 sts=2 sw=2
autocmd FileType cpp setlocal ts=2 sts=2 sw=2
