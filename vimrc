" Must be first; disabled backwards compatibility with vi
set nocompatible

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" To install run
" vim +PluginInstall +qall
Plugin 'gmarik/Vundle.vim'

" Making vim look good
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Adding programmer text editing
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'scrooloose/syntastic'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'kien/ctrlp.vim'

" Git plugins
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" Other text editing
Plugin 'Raimondi/delimitMate'

" Systemverilog
Plugin 'nachumk/systemverilog.vim'

" SLICC Cache Coherence language
Plugin 'kshenoy/vim-slicc'

" C scope
Plugin 'steffanc/cscopemaps.vim'

call vundle#end()

filetype plugin indent on

" General setings
set backspace=indent,eol,start
set ruler
set number
set showcmd
set incsearch
set hlsearch

" Set indentation and tabbing
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
nnoremap <silent> <leader>\ :nohlsearch<CR>

syntax on

set mouse=a

" ----- Plugin-Specific Settings --------------------------------------
set guifont=Menlo\ for\ Powerline

" ----- altercation/vim-colors-solarized settings -----
" Toggle this to "light" for light colorscheme
set background=dark

" Uncomment the next line if your terminal is not configured for solarized
"let g:solarized_termcolors=256

" This fixes the background color being wrong
se t_Co=16
" Set the colorscheme
colorscheme solarized


" ----- bling/vim-airline settings -----
" Always show statusbar
set laststatus=2

" Fancy arrow symbols, requires a patched font
" To install a patched font, run over to
"     https://github.com/abertsch/Menlo-for-Powerline
" download all the .ttf files, double-click on them and click "Install"
" Finally, uncomment the next line
let g:airline_powerline_fonts = 1

" Color
let g:airline_theme='solarized'

" Show PASTE if in paste mode
let g:airline_detect_paste=1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1

" ----- jistr/vim-nerdtree-tabs -----
" Open/close NERDTree Tabs with \t
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
" To have NERDTree always open on startup set to 1 to open on start
let g:nerdtree_tabs_open_on_console_startup = 0

" ----- scrooloose/syntastic settings -----
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
augroup mySyntastic
  au!
  au FileType tex let b:syntastic_mode = "passive"
augroup END

let g:syntastic_c_include_dirs = [ '../include', 'include' ]
let g:syntastic_c_config_file = '.syntastic_c_config'
let g:syntastic_c_remove_include_errors = 1


" ----- xolox/vim-easytags settings -----
" Where to look for tags files
set tags=./tags;,~/.vimtags
" Sensible defaults
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
let g:easytags_dynamic_files = 2
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warning = 1

" ----- majutsushi/tagbar settings -----
" Open/close tagbar with \b
nmap <silent> <leader>b :TagbarToggle<CR>
" Uncomment to open tagbar automatically whenever possible
"autocmd BufEnter * nested :call tagbar#autoopen(0)


" ----- airblade/vim-gitgutter settings -----
" Required after having changed the colorscheme
hi clear SignColumn
let g:gitgutter_max_signs = 2000
" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

" ----- Raimondi/delimitMate settings -----
let delimitMate_expand_cr = 1
augroup mydelimitMate
  au!
  au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
  au FileType tex let b:delimitMate_quotes = ""
  au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
  au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END

" ----- End Plugin Settings ----

set clipboard=unnamedplus

" Map \q to close the current buffer
nmap <silent> <leader>q :bp\|bd #<CR>

" @r to replace all trailing whitespace
let @r=':%s/\s\+$//'

" Add cscope database
cs add /home/dwillis/xcalar/cscope.out
