" DevOps Workspace Vim Configuration

" Basic settings
set nocompatible
syntax on
filetype plugin indent on

" UI Configuration
set number                  " Show line numbers
set relativenumber         " Show relative line numbers
set cursorline             " Highlight current line
set showmatch              " Highlight matching brackets
set showcmd                " Show command in bottom bar
set wildmenu               " Visual autocomplete for command menu
set laststatus=2           " Always show status line

" Indentation
set tabstop=4              " Number of spaces per tab
set softtabstop=4          " Number of spaces per tab when editing
set shiftwidth=4           " Number of spaces for autoindent
set expandtab              " Convert tabs to spaces
set autoindent             " Copy indent from current line when starting new line
set smartindent            " Smart autoindenting

" Search settings
set incsearch              " Search as characters are entered
set hlsearch               " Highlight search matches
set ignorecase             " Case insensitive search
set smartcase              " Case sensitive when uppercase present

" Performance
set lazyredraw             " Redraw only when needed
set ttyfast                " Fast terminal connection

" Backup and swap
set nobackup               " No backup files
set noswapfile             " No swap files
set nowritebackup          " No backup before overwrite

" File encoding
set encoding=utf-8
set fileencoding=utf-8

" Enable mouse support
set mouse=a

" Split behavior
set splitbelow             " Horizontal splits below
set splitright             " Vertical splits to right

" Clipboard
set clipboard=unnamedplus  " Use system clipboard

" Line wrapping
set wrap                   " Wrap long lines
set linebreak              " Wrap at word boundaries

" Folding
set foldmethod=indent      " Fold based on indent
set foldlevel=99           " Open all folds by default

" Key mappings
let mapleader = ","        " Leader key

" Quick save
nnoremap <leader>w :w<CR>

" Quick quit
nnoremap <leader>q :q<CR>

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffer navigation
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>

" Tab navigation
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>tm :tabmove<CR>

" YAML indentation
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yml setlocal ts=2 sts=2 sw=2 expandtab

" JSON formatting
autocmd FileType json syntax match Comment +\/\/.\+$+

" Terraform
autocmd FileType terraform setlocal commentstring=#%s

" Status line
set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [%04l,%04v][%p%%]\ [LEN=%L]

" Color scheme (if available)
try
    colorscheme desert
catch
    colorscheme default
endtry

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Auto remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e
