" === BEGIN Vundle config === "
" See https://github.com/VundleVim/Vundle.vim/blob/master/doc/vundle.txt

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Install bundles from dedicated files
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Install machine-specific bundles from dedicated files
if filereadable(expand("~/.vimrc.bundles.local"))
  source ~/.vimrc.bundles.local
endif

call vundle#end()
filetype plugin indent on
" === END Vundle config === "

syntax enable               " enable syntax highlighting
set autoindent
set autoread                " reload files when changed on disk
set backspace=2             " equivalent to backspace=indent,eol,start
set backupcopy=yes          " see :help crontab
set clipboard=unnamed       " yank and paste with the system clipboard
set complete-=i             " don't complete from include files (it's slow)
set directory-=.            " don't store swapfiles in the current directory
set display+=lastline       " show partial last lines instead of "@"
set encoding=utf-8
set expandtab               " expand tabs to spaces
set formatoptions+=j        " delete comment character when joining commented lines
set hidden                  " allow hidden buffers
set ignorecase              " case-insensitive search
set incsearch               " search as you type
set laststatus=2            " always show statusline
set list                    " show tabs and trailing whitespace
set listchars=tab:▸\ ,trail:▫
set number                  " show line numbers
set nrformats-=octal        " ignore octal numbers for auto inc/dec commands
set ruler                   " show where you are
set scrolloff=3             " always show a few lines of context above/below cursor
set sidescrolloff=5         " always show a few columns to the left/right of cursor
set shell=/bin/bash         " use bash
set showcmd
set smartcase               " case-sensitive search if any caps
set smarttab                " use shiftwidth instead of tabstop at the beginning of lines
set shiftwidth=4            " normal mode indentation commands use 4 spaces
set softtabstop=4           " insert mode tab and backspace use 4 spaces
set sessionoptions-=options " don't persist global options across session restore
set tabstop=4               " actual tabs occupy 4 characters
set ttimeout                " short timeout for partial commands
set ttimeoutlen=100
set wildignore+=tmp/**,vendor/**
set wildmenu                " show a navigable menu for tab completion
set wildmode=longest:full,full
set whichwrap+=<,>,h,l,[,]  " wrap arrow keys between lines


" === Command mappings === "

let mapleader = ','

" In case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %

" Tab navigation
nnoremap <leader>= :tabn<CR>
nnoremap <leader>- :tabp<CR>

" Clear trailing whitespace
nnoremap <leader><space> :%s/\s\+$//<CR>

" Clear highlights
nnoremap <leader>c :nohl<CR>

" Reload vimrc
nnoremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

nmap <leader>l :EasyAlign
nnoremap <leader>a :Ack<space>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
nnoremap <leader>] :TagbarToggle<CR>
nnoremap <leader>B :Gblame<CR>

" FYI: <leader>ig toggles indent guides


" === NERDTree config === "

" Open NERDTree pane automatically when vim starts with no input specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close vim if the tree pane is the only thing still open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

let g:NERDSpaceDelims=1


" === vim-go === "

" Use vim-go calls only when editing Go files
au FileType go nnoremap <leader>I :GoImports<CR>
au FileType go nnoremap <leader>R :GoRename<CR>
au FileType go nnoremap <leader>S <Plug>(go-implements)
au FileType go let b:dispatch = 'go test'

" Run go-fmt on save
let g:go_fmt_autosave = 1

" tagbar support for Go highlighting
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }


" === gitgutter settings === "

nnoremap <leader>G :GitGutterToggle<CR>
let g:gitgutter_enabled = 0
let g:gitgutter_highlight_lines = 1


" === ctrlp fuzzy search === "

let g:ctrlp_match_window = 'order:ttb,max:20'

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " Use ag in gitgutter
  let g:gitgutter_grep_command = 'ag --nogroup --nocolor'

  " Use ag with ack.vim
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif


" === Filetypes === "

" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown


" === Terminal settings === "

" Allow color schemes to do bright colors without forcing bold
if &t_Co == 8 && $TERM !~# '^linux\|^ETerm'
  set t_Co=16
endif

" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX')  " Support resizing in tmux
  set ttymouse=xterm2
endif

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Fix Cursor in tmux
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Solarized dark
if !empty(glob("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
  set background=dark
  colorscheme solarized
  " airline, the fancy statusbar
  let g:airline_theme='solarized'
endif


" === Random sensibility === "

" don't copy the contents of an overwritten selection.
vnoremap p "_dP

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif
if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif


" === Locally-specific settings === "

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
