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
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'preservim/nerdtree' " FileBrowser in-vim
Plug 'neoclide/coc.nvim', {'branch':'release'}
Plug 'mattn/emmet-vim' " Generate Html/Css from command
Plug 'tpope/vim-commentary' " Easy way to comment. gcc for commenting one line, gc for selection
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-unimpaired' " Comment out lines of code
Plug 'github/copilot.vim'    
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
Plug 'ryanoasis/vim-devicons'
Plug 'bryanmylee/vim-colorscheme-icons' " Colored icons for previous plugin
Plug 'nvim-lua/plenary.nvim' " Dependency for telescope
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.3' } " Fuzzy finder
Plug 'goolord/alpha-nvim' " Dashboard
Plug 'nvim-tree/nvim-web-devicons' " Dependency for alpha
Plug 'rmagatti/auto-session' " Save session automatically
Plug 'rmagatti/session-lens' " Telescope extension for session
Plug 'nvim-lualine/lualine.nvim' " Statusline
call plug#end()

colorscheme catppuccin-macchiato
set clipboard=unnamedplus

" Tab mappings
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>

" NerdTree remapping
let mapleader = " " " Set mapleader to space
nnoremap <silent><leader>n :NERDTreeFocus<cr>
" nnoremap <C-n> :NERDTree<cr>
nnoremap <silent><leader>t :NERDTreeToggle<cr>
nnoremap <silent><C-f> :NERDTreeFind<cr>

" Start NERDTree when Vim is started without file arguments.
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
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
" unmap gs
" unmap gt
nnoremap <silent> gdv :call CocAction('jumpDefinition', 'vsplit')<CR>
nnoremap <silent> gdt :call CocAction('jumpDefinition', 'tabe')<CR>
nnoremap <silent> gi :call CocAction('jumpImplementation')<CR>
nnoremap <silent> git :call CocAction('jumpImplementation', 'tabe')<CR>
nnoremap <silent> giv :call CocAction('jumpImplementation' 'vsplit')<CR>
nnoremap <silent> gr :call CocAction('jumpReferences')<CR>
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif CocAction('hasProvider', 'hover')
    if coc#float#has_float()
      call coc#float#jump()
      nnoremap <buffer> q <Cmd>close<CR>
    else
      call CocActionAsync('doHover')
    endif
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Ctrl+B in visual mode to wrap selection with \textbf{}
xnoremap <C-b> c\textbf{<C-r>"}
xnoremap <C-i> c\textit{<C-r>"}

" Vimtex Settings
let g:vimtex_view_method = 'zathura'

" Setting pdf viewer for Latex live preview
let g:livepreview_previewer = 'zathura'
let g:livepreview_cursorhold_recompile = 0 " Set autorecompile on write buffer to false

" Telescope remapping
nnoremap ff <cmd>Telescope find_files<cr>
nnoremap fg <cmd>Telescope live_grep<cr>
nnoremap fs <cmd>SearchSession<cr>

" Dashboard config 
" include ./lua/alpha via lua
lua require'alpha-config'

" Session setup
lua require'auto-session-config'

lua require'lualine-config'
