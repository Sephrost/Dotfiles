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
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' } " Fuzzy finder
Plug 'goolord/alpha-nvim' " Dashboard
Plug 'nvim-tree/nvim-web-devicons' " Dependency for alpha
Plug 'rmagatti/auto-session' " Save session automatically
Plug 'rmagatti/session-lens' " Telescope extension for session
Plug 'nvim-lualine/lualine.nvim' " Statusline
Plug 'neovim/nvim-lspconfig' " LSP
Plug 'Saghen/blink.cmp' " Autocompletion
Plug 'mfussenegger/nvim-lint' " Linting
Plug 'nvim-java/nvim-java' " Java LSP
Plug 'nvim-java/lua-async-await'
Plug 'nvim-java/nvim-java-refactor'
Plug 'nvim-java/nvim-java-core'
Plug 'nvim-java/nvim-java-test'
Plug 'nvim-java/nvim-java-dap'
Plug 'MunifTanjim/nui.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'JavaHello/spring-boot.nvim', { 'commit': '218c0c26c14d99feca778e4d13f5ec3e8b1b60f0'}
Plug 'mason-org/mason.nvim'
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

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Load Emmet only for html/css
let g:user_emmet_install_global = 0
autocmd FileType html,css,php EmmetInstall

" In case vim-commentary doesn't work for a typefile
" autocmd FileType apache setlocal commentstring=#\ %s

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

lua registries = { "github:nvim-java/mason-registry", "github:mason-org/mason-registry" }
lua require("mason").setup({ registries = registries })
lua require('java').setup({verification = { invalid_mason_registry = false }})
lua require('lspconfig').jdtls.setup({})

" Plugins setup
lua require'alpha-config'
lua require'auto-session-config'
lua require'lualine-config'
lua require'lsp-config'
lua require'blink-config'
lua require'linter-config'
