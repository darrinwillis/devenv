" Must be first; disabled backwards compatibility with vi
set nocompatible

filetype off

" Helper to build YCM
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py
  endif
endfunction

" vim-plug
" vim +PlugInstall or vim +PlugUpdate
call plug#begin('~/.vim/plugged')

" Making vim look good
Plug 'altercation/vim-colors-solarized'
"Plug 'tomasr/molokai'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Adding programmer text editing
Plug 'scrooloose/syntastic'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags'
Plug 'majutsushi/tagbar'

" PEP8 python indentation
Plug 'Vimjas/vim-python-pep8-indent'

" Typescript
Plug 'https://github.com/leafgarland/typescript-vim.git'

" linting
Plug 'w0rp/ale'

" fuzzy finding
Plug 'junegunn/fzf'

" Auto completion
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }

" Git plugins
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Other text editing
Plug 'Raimondi/delimitMate'

" C scope
Plug 'steffanc/cscopemaps.vim'
Plug 'cespare/vim-toml'

" Vim rtags for finding C++ symbols
"6/11/19 disabled because 'vim is missing python support'
"Plug 'lyuts/vim-rtags'

" NERDTree
" file browsing
Plug 'scrooloose/nerdtree'

" editorconfig
" Automatically change coding style based off of editorconfig files
Plug 'editorconfig/editorconfig-vim'

" cpp-modern
" modern and more heavy handed c++ syntax highlighting
Plug 'bfrg/vim-cpp-modern'

" rust formatting
Plug 'rust-lang/rust.vim'

" Copilot
Plug 'github/copilot.vim'

call plug#end()

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

" Set preferences
syntax on
set mouse=a
set scrolloff=5 " When searching, display 5 lines of context

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

" hide '-- INSERT --'
set noshowmode

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

let g:airline_section_x = ''
let g:airline_section_y = ''

" ----- 'w0rp/ale' settings -----
let g:ale_sign_error = '✘'
let g:ale_sign_warning = "▲"
let g:ale_sign_column_always = 1
let g:ale_linters = {
\   'cpp': [],
\   'python': ['flake8'],
\}

let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   'cpp': ['clang-format'],
\   'python': ['black'],
\   'rust': ['rustfmt']
\}

" Rust should use cargo to check clippy with this, if clippy is installed
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')


" ----- scrooloose/syntastic settings -----
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
augroup mySyntastic
  au!
  au FileType tex let b:syntastic_mode = "passive"
augroup END

let g:syntastic_cpp_config_file = '.syntastic_cpp_config'
let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_cpp_compiler_options = "-std=gnu++11"

" FZF settings
nmap <c-p> :FZF<CR>

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
let g:tagbar_autofocus = 1
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

" ----- YouCompleteMe -----
let g:ycm_confirm_extra_conf = 0
let g:ycm_register_as_syntastic_checker = 1
"let g:ycm_key_list_select_completion = ['<TAB>']
let g:ycm_autoclose_preview_window_after_completion = 1
"set tags=/home/dwillis/tags
let g:ycm_show_diagnostics_ui = 1
let g:ycm_min_num_identifier_candidate_chars = 99
" Set rust root so YCM uses the latest run compiler
let g:ycm_rust_toolchain_root = '/home/dwillis/.rustup/toolchains/stable-x86_64-unknown-linux-gnu'

" ----- vim-rtags settings -----
let g:rtagsRcCmd = "/home/dwillis/dev/3rd/rtags/build/bin/rc"
"let g:rtagsUseLocationList = 0

" ----- Autoformat settings -----
let g:formatterpath = ['/usr/bin']
"au BufWrite *.cpp :Autoformat
"au BufWrite *.h :Autoformat

" ----- clang-format settings -----
" autocmd FileType c ClangFormatAutoEnable
" autocmd FileType cpp ClangFormatAutoEnable


" ----- End Plugin Settings -----

" Apply clipboard for WSL passthrough
let g:clipboard = {
  \   'name': 'WslClipboard',
  \   'copy': {
  \      '+': 'clip.exe',
  \      '*': 'clip.exe',
  \    },
  \   'paste': {
  \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  \   },
  \   'cache_enabled': 0,
  \ }


" set clipboard=unnamedplus

" Map \q to close the current buffer
nmap <silent> <leader>q :bp\|bd #<CR>

" @r to replace all trailing whitespace
let @r=':%s/\s\+$//'

" Replace camelCase with snake_case
" %s#\v(<\u\l+|\l+)(\u)#\l\1_\l\2#gc

" Make .sh always be highlighted as bash
let g:is_bash=1

" Hightlight column 80
set cc=80

" Allow bash aliases inside vim shell
"set shell=/bin/bash\ -i

" \f to reset syntax highlighting
nmap <silent> <leader>f :syntax sync fromstart<CR>

" \l to close location list
nmap <silent> <leader>l :lclose<CR>:cclose<CR>

" \c to show ycm diags
nmap <silent> <leader>c :YcmDiags<CR>

" \t to show type
nmap <silent> <leader>t :YcmCompleter GetType<CR>

" \e to show definition
nmap <silent> <leader>e :YcmCompleter GoToDefinition<CR>

" \a to show declaration
nmap <silent> <leader>a :YcmCompleter GoToDeclaration<CR>

" \g to just go, imprecisely. this may be inaccurate
nmap <silent> <leader>g :YcmCompleter GoToImprecise<CR>

" \d to open current directory in file browser
nmap <silent> <leader>d :NERDTreeFind<CR>

" \p to close file browser
nmap <silent> <leader>p :NERDTreeToggle<CR>

" \s to replace (%s) current word
nnoremap <leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

" \y to run profiling
nmap <silent> <leader>y :profile start profile.log<CR>:profile func *<CR>:profile file *<CR>

" \Y to stop profiling
nmap <silent> <leader>Y :profile pause<CR>

" Run shell script 'src/wsl-launch.sh' in the background
nnoremap <silent> <leader>r :!wsl-launch.sh<CR>
inoremap jk <ESC>
