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

set clipboard=unnamed       " yank and paste with the system clipboard
set directory-=.            " don't store swapfiles in the current directory
set expandtab               " expand tabs to spaces
set formatoptions+=j        " delete comment character when joining commented lines
set hidden                  " allow hidden buffers
set ignorecase              " case-insensitive search
set list                    " show tabs and trailing whitespace
set listchars=tab:▸\ ,trail:▫
set number                  " show line numbers
set showcmd
set smartcase               " case-sensitive search if any caps
set shiftwidth=4            " normal mode indentation commands use 4 spaces
set softtabstop=4           " insert mode tab and backspace use 4 spaces
set sessionoptions-=options " don't persist global options across session restore
set tabstop=4               " actual tabs occupy 4 characters
set wildignore+=tmp/**,vendor/**
set wildmode=longest:full,full
set whichwrap+=<,>,h,l,[,]  " wrap arrow keys between lines


" === Command mappings === "

nnoremap <space> <nop>
let mapleader = ' '

" In case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %

" Get back to the code
nnoremap <leader><space> :ccl<CR>:lcl<CR>

" Tab navigation
nnoremap <leader>] :tabn<CR>
nnoremap <leader>[ :tabp<CR>

" Clear trailing whitespace
nnoremap <leader>= :%s/\s\+$//<CR>

" Reload vimrc
nnoremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" Plugin commands
nnoremap <leader>\ :TagbarToggle<CR>
nnoremap <leader>b :Git blame<CR>
nnoremap <leader>g :GitGutterToggle<CR>
nnoremap <leader>a :Ack<space>

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

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
augroup golang
    au!
    au FileType go nnoremap <leader>I :GoImports<CR>
    au FileType go nnoremap <leader>R :GoRename<CR>
    au FileType go nnoremap <leader>S <Plug>(go-implements)

    au FileType go let b:dispatch = 'go test'

    au FileType go let g:syntastic_go_checkers = ['golint', 'govet']
    au FileType go let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

    au FileType go let g:go_fmt_autosave = 1

    " tagbar support for Go highlighting
    au FileType go let g:tagbar_type_go = {
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
augroup end

" === gitgutter settings === "

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

" === synastic === "

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" === Filetypes === "

" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown

" === Terminal settings === "

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

" === Locally-specific settings === "

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
