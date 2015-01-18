set nocompatible              " be iMproved, required
filetype off                  " required

"=====================================================
" Vundle settings
"=====================================================
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'              " let Vundle manage Vundle, required

"---------=== Code/project navigation ===-------------
Plugin 'scrooloose/nerdtree'            " Project and file navigation
Plugin 'majutsushi/tagbar'              " Class/module browser

"------------------=== Other ===----------------------
Plugin 'tpope/vim-fugitive'
Plugin 'bling/vim-airline'              " Lean & mean status/tabline for vim
Plugin 'fisadev/FixedTaskList.vim'      " Pending tasks list
Plugin 'rosenfeld/conque-term'          " Consoles as buffers
Plugin 'tpope/vim-surround'             " Parentheses, brackets, quotes, XML tags, and more
Plugin 'vim-scripts/Conque-Shell'

"--------------=== Snippets support ===---------------
Plugin 'garbas/vim-snipmate'            " Snippets manager
Plugin 'MarcWeber/vim-addon-mw-utils'   " dependencies #1
Plugin 'tomtom/tlib_vim'                " dependencies #2
Plugin 'honza/vim-snippets'             " snippets repo

Plugin 't9md/vim-choosewin'

"---------------=== Languages support ===-------------
Plugin 'Valloric/YouCompleteMe'
" --- Python ---
Plugin 'klen/python-mode'               " Python mode (docs, refactor, lints, highlighting, run and ipdb and more)
Plugin 'orestis/pysmell'
Plugin 'mitsuhiko/vim-jinja'            " Jinja support for vim
Plugin 'mitsuhiko/vim-python-combined'  " Combined Python 2/3 for Vim
" --- Perl ---
Plugin 'vim-perl/vim-perl'
" --- Erlang ---
Plugin 'jimenezrick/vimerl'
" --- GoLang ---
Plugin 'dgryski/vim-godef'
Plugin 'Blackrush/vim-gocode'

call vundle#end()                       " required

"=====================================================
" Global settings
"=====================================================

filetype on
filetype plugin on
filetype plugin indent on

:let mapleader=","

set tags=~/.vim/stdtags,tags,.tags,../tags
set ai sw=4
" enable mouse wherever
set mouse=a
" It's VIM, not VI
set nocompatible
" A tab produces a 2-space indentation
set shiftwidth=2
set expandtab
" Additional vim features to optionally uncomment.
set showcmd
set showmatch
set showmode
set incsearch
set ruler
" Add and delete spaces in increments of `shiftwidth' for tabs
set smarttab
" Highlight syntax in programming languages
syntax on

" In Makefiles, don't expand tabs to spaces, since we need the actual tabs
autocmd FileType make set noexpandtab

" Delete trailing whitespace and tabs at the end of each line
command! DeleteTrailingWs :%s/\s\+$//

" Convert all tab characters to two spaces
command! Untab :%s/\t/  /g

""" Functions
function! ConditionalPairMap(open, close)
  let line = getline('.')
  let col = col('.')
  if col < col('$') || stridx(line, a:close, col + 1) != -1
    return a:open
  else
    return a:open . a:close . repeat("\<left>", len(a:close))
  endif
endf
""" End Functions

if filereadable($HOME.'/.vimrc_local')
    source $HOME/.vimrc_local
endif

" Folds
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
set foldmethod=indent
set foldlevel=99

" Let's remember some things, like where the .vim folder is.
if has("win32") || has("win64")
    let windows=1
    let vimfiles=$HOME . "/vimfiles"
    let sep=";"
else
    let windows=0
    let vimfiles=$HOME . "/.vim"
    let sep=":"
endif

"=====================================================
" Misc
"=====================================================
" checks
if !has('gui_running')
    " Compatibility for Terminal
    let g:solarized_termtrans=1

    if (&t_Co >= 256 || $TERM == 'xterm-256color')
        " Do nothing, it handles itself.
    else
        " Make Solarized use 16 colors for Terminal support
        let g:solarized_termcolors=16
    endif
endif
if has("gui_running")
    set cursorline                  "Highlight background of current line
    autocmd VimEnter * NERDTree     "run nerdtree
    "autocmd VimEnter * TagbarOpen

    " Show tabs and newline characters with ,s
    nmap <Leader>s :set list!<CR>
    set listchars=tab:▸\ ,eol:¬
    "Invisible character colors
    highlight NonText guifg=#4a4a59
    highlight SpecialKey guifg=#4a4a59
endif
if has("gui_macvim") "Use Experimental Renderer option must be enabled for transparencY
   let s:uname = system("uname")
   if s:uname == "Darwin\n"
      set guifont=Menlo\ for\ Powerline:h14
   endif
    map <SwipeLeft> :bprev<CR>
    map <SwipeRight> :bnext<CR>
endif

" Syntax highlighting for clojurescript files
autocmd BufRead,BufNewFile *.cljs setlocal filetype=clojure
set guifont=Liberation\ Mono\ for\ Powerline\ 10 

set t_Co=256
"set laststatus=2
set term=xterm-256color
autocmd bufwritepost .vimrc source $MYVIMRC

"=====================================================
" AutoRun
"=====================================================
autocmd VimEnter * TagbarOpen
autocmd BufEnter * TagbarOpen 
autocmd VimEnter * NERDTree
autocmd BufEnter * NERDTreeMirror

set wildmode=longest:full,full
set clipboard+=unnamed  " use the clipboards of vim and win
set backspace=indent,eol,start

"autocmd BufRead,BufNewFile   *.sh,*.bash,*.shell set completeopt=menu,longest 
autocmd BufRead,BufNewFile   *.sh,*.bash,*.shell let g:acp_behaviorKeywordCommand = "\<C-n>"

"=====================================================
" Autocompletions
"=====================================================
autocmd FileType ada setlocal omnifunc=adacomplete#Complete
autocmd FileType c setlocal omnifunc=ccomplete#Complete
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType java setlocal omnifunc=javacomplete#Complete
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType sql setlocal omnifunc=sqlcomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType go setlocal completefunc=youcompleteme#Complete

" highlight if we have more then 80 chars
augroup vimrc_autocmds
    autocmd!
    autocmd FileType ruby,python,go,javascript,c,cpp,sh highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType ruby,python,go,javascript,c,cpp,sh match Excess /\%80v.*/
    autocmd FileType ruby,python,go,javascript,c,cpp,sh set nowrap
augroup END

"=====================================================
" Plugins set
"=====================================================

"=================== airlines ========================
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_symbols.whitespace = 'Ξ'

"=================== NERDTREE =======================
let NERDTreeIgnore=['\~$', '\.pyc$', '\.pyo$', '\.class$', 'pip-log\.txt$', '\.o$'] 

"=================== YouCompleteMe ==================
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_auto_trigger = 1
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'unite' : 1,
      \ 'text' : 1,
      \ 'vimwiki' : 1,
      \ 'pandoc' : 1,
      \ 'infolog' : 1,
      \ 'mail' : 1
      \}
let g:ycm_complete_in_comments = 0
let g:ycm_autoclose_preview_window_after_completion=1
"let g:go_fmt_command = "goimports"

""autocmd FileType go setlocal completeopt=preview,menuone
"let g:acp_completeoptPreview = 1
" ==================== DelimitMate ====================
"let g:delimitMate_expand_cr = 1
"let g:delimitMate_expand_space = 1

"=====================================================
"" Settings by type
"=====================================================
"====================== golang =======================
au FileType go nmap <leader>gd <Plug>(go-doc-browser)
" Go tags
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

"-------> python <--------
"au FileType python set omnifunc=pythoncomplete#Complete
autocmd BufRead,BufNewFile FileType python let pymode = 1
" Documentation
autocmd BufRead,BufNewFile FileType python let g:pymode_doc = 1
autocmd BufRead,BufNewFile FileType python let g:pymode_doc_key = 'K'
"Linting
autocmd BufRead,BufNewFile FileType python let g:pymode_lint = 1
"autocmd BufRead,BufNewFile FileType python let g:pymode_lint_checker = "pyflakes,pep8"
" Auto check on save
autocmd BufRead,BufNewFile FileType python let g:pymode_lint_write = 1
" Support virtualenv
autocmd BufRead,BufNewFile FileType python let g:pymode_virtualenv = 1
" Enable breakpoints plugin
autocmd BufRead,BufNewFile FileType python let g:pymode_breakpoint = 1
autocmd BufRead,BufNewFile FileType python let g:pymode_breakpoint_key = '<leader>b'
" syntax highlighting
autocmd BufRead,BufNewFile FileType python let g:pymode_syntax = 1
"autocmd BufRead,BufNewFile FileType python let g:pymode_syntax_all = 1
"autocmd BufRead,BufNewFile FileType python let g:pymode_syntax_indent_errors = g:pymode_syntax_all
"autocmd BufRead,BufNewFile FileType python let g:pymode_syntax_space_errors = g:pymode_syntax_all
"autocmd BufRead,BufNewFile FileType python let pymode_path = 1
"autocmd BufRead,BufNewFile FileType python let pymode_paths = []
autocmd BufRead,BufNewFile FileType python let pymode_doc = 1
autocmd BufRead,BufNewFile FileType python let pymode_doc_key = '<leader>D'
autocmd BufRead,BufNewFile FileType python let pymode_run = 1
"autocmd BufRead,BufNewFile FileType python let pymode_run_key = '<leader>r'
"autocmd BufRead,BufNewFile FileType python let pymode_lint = 1
autocmd BufRead,BufNewFile FileType python let pymode_lint_checker = 'pyflakes'
"autocmd BufRead,BufNewFile FileType python let pymode_lint_ignore = 'E501'
autocmd BufRead,BufNewFile FileType python let pymode_lint_select = ''
"autocmd BufRead,BufNewFile FileType python let pymode_lint_onfly = 0
autocmd BufRead,BufNewFile FileType python let pymode_lint_write = 1
"autocmd BufRead,BufNewFile FileType python let pymode_lint_cwindow = 1
autocmd BufRead,BufNewFile FileType python let pymode_lint_message = 1
"autocmd BufRead,BufNewFile FileType python let pymode_lint_signs = 1
autocmd BufRead,BufNewFile FileType python let pymode_lint_jump = 0
"autocmd BufRead,BufNewFile FileType python let pymode_lint_hold = 0
autocmd BufRead,BufNewFile FileType python let pymode_lint_minheight = 3
"autocmd BufRead,BufNewFile FileType python let pymode_lint_maxheight = 6
autocmd BufRead,BufNewFile FileType python let pymode_rope = 0
"autocmd BufRead,BufNewFile FileType python let pymode_folding = 0
autocmd BufRead,BufNewFile FileType python let pymode_breakpoint = 1
autocmd BufRead,BufNewFile FileType python let g:pymode_folding = 0
"" jedi
"" <leader>d - goto global definitin
"" <leader>g - goto definitin
autocmd BufRead,BufNewFile FileType python let g:jedi#popup_on_dot=0
autocmd BufRead,BufNewFile FileType python let g:jedi#completions_enabled = 1
autocmd BufRead,BufNewFile FileType python let g:jedi#auto_vim_configuration = 1

"-------> ConqueTerm <------
let g:ConqueTerm_InsertOnEnter = 0
let g:ConqueTerm_CWInsert = 1
let g:ConqueTerm_Color = 2

"=====================================================
"" HOTKEYS
"=====================================================
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>
nnoremap to  :ConqueTermSplit zsh<CR>
nnoremap go  :!go build<CR>
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>
vnoremap <leader>gb :Gblame<CR>

"=====================================================
"" Key mapping
"=====================================================
nmap  -  <Plug>(choosewin)
" NERDTree
map <F2> :NERDTreeToggle<CR>
"Enable Ctrl+P to paste
map <C-Y> :set paste<CR>
" Moving around windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h
map <leader>vimrc :tabe ~/.vim/.vimrc<cr>
nmap <F8> :TagbarToggle<CR>
:map <M-Esc>[62~ <MouseDown> 
:map! <M-Esc>[62~ <MouseDown> 
:map <M-Esc>[63~ <MouseUp> 
:map! <M-Esc>[63~ <MouseUp> 
:map <M-Esc>[64~ <S-MouseDown> 
:map! <M-Esc>[64~ <S-MouseDown> 
:map <M-Esc>[65~ <S-MouseUp> 
:map! <M-Esc>[65~ <S-MouseUp>
" Moving around windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h
