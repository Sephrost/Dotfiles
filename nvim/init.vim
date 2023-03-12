" Pluginstall to intall new plugins
" PlugUpdate to update vim-plug
" PlugClean to remove deleted plugins
set relativenumber
set nu
set noerrorbells
set nowrap
set scrolloff=8
set tabstop=2 softtabstop=2 expandtab shiftwidth=2 smarttab
set colorcolumn=100

call plug#begin('~/.vim/plugged')
Plug 'gruvbox-community/gruvbox' " Theme schema
Plug 'preservim/nerdtree' " FileBrowser in-vim
Plug 'neoclide/coc.nvim', {'branch':'release'}
Plug 'mattn/emmet-vim' " Generate Html/Css from command
Plug 'tpope/vim-commentary' " Easy way to comment. gcc for commenting one line, gc for selection
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-unimpaired' " Comment out lines of code
Plug 'github/copilot.vim'    
Plug 'thosakwe/vim-flutter' " Run flutter commands in vim
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
" Plug 'vim-airline/vim-airline'
call plug#end()

colorscheme gruvbox
set clipboard+=unnamedplus

" NerdTree remapping
let mapleader = " " " Set mapleader to space
nnoremap <leader>n :NERDTreeFocus<cr>
nnoremap <C-n> :NERDTree<cr>
nnoremap <leader>t :NERDTreeToggle<cr>
nnoremap <C-f> :NERDTreeFind<cr>

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Load Emmet only for html/css
let g:user_emmet_install_global = 0
autocmd FileType html,css,php EmmetInstall

" In case vim-commentary doesn't work for a typefile
" autocmd FileType apache setlocal commentstring=#\ %s

" Disable VimCoc warning
let g:coc_disable_startup_warning = 1
" Use tab for selecting in Vim-Coc
inoremap <expr> <S-Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <C-S-Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" Setting pdf viewer for Latex live preview
let g:livepreview_previewer = 'atril'
let g:livepreview_cursorhold_recompile = 0 " Set autorecompile on write buffer to false
