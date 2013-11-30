
call pathogen#infect()

""""""""""""""'
" Misc stuff
set exrc                        "Make sure we run the vimrc
set secure                      "don't allow commandline executin in vimrc
set nocompatible                "all vim features!
set showcmd                     "show commands in statusline
set nonumber                    "no line numbers at first
"set fileformats=unix           " I want to see those ^M if I'm editing a dos file
set confirm                     "Tell me if something fucks up
set visualbell t_vb=            "Don't ring any bells
set mouse=a                     "Use the mouse in all modes
set title                       "Let VIM manage the term title
set titlestring=%t\ %y\ %r\ %m  "Set a useful term title            
set titleold=Terminal           "Get rid of that stupid flying message
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc       "Don't tab complete this much
set viminfo='20,\"50            "How much history/marks to store in viminfo
set number                      "Show line numbers
set showmode                    "Show editing mode in status bar
set fmr={,}                     "Fold marker
set fdm=marker                  "Fold method
set nofen                       "But disable folding by default
set path=.
"lots of speed up, but no guarentees the file is actually on disk at exit
set nofsync
set ttyfast
set noruler
set laststatus=2
set whichwrap=b,s,h,l,<,>,[,]
set history=1000
set wildmode=longest,list,full
set wildmenu
set scrolljump=1
set scrolloff=3

"need to patch my font for this to work
"let g:Powerline_symbols = 'fancy'


" when pasting don't replace yank buffer with what you have highlighted
vmap p "_dP
vmap P "_dP

" on space dehighlight
noremap <silent> <Space> :silent noh<Bar>echo<CR>


" buffer switching
nmap <silent> <F9> :bn <CR>
nmap <silent> <F10> :bp <CR>
nmap <silent> <F11> :ls <CR>
nmap <silent> <F12> :ball <CR>
nmap <silent> <F8> :cd ~/dev/drit/ <CR> :cscope add cscope.out <CR>
nmap <silent> <F4> :cd %:p:h <CR> :cscope add cscope.out <CR>
nmap <silent> <F5> :cscope reset <CR>
nmap <silent> <F6> :!cscope -bR <CR> :cscope reset <CR>

""""""""""""""""""
" Text Formatting
""""""""""""""""""

set autoindent          "Auto indenting
set cindent             "auto un-indent close brackets
set cinoptions=>4       "one tab only
set tabstop=4           "Tab width
set softtabstop=4       "Soft tabstop
set shiftwidth=4        "how much to shift text when formatting
set backspace=2         "backspace over every thing
set textwidth=78        "Text width
set showmatch           "Blink to show the {} and () matches
set matchtime=3         "make it a quick blink though
set formatoptions=crq2  "Do some neat comment stuff for us
set expandtab           "Expand tabs to spaces
autocmd FileType make setlocal noexpandtab
syntax on               "Do Syntax hilighting 

""""""""""""
"Searching stuff
set hlsearch        "highlight search matches
set ignorecase      "for pattern matching
set smartcase       "if I use uppercase, match case sensitive
set incsearch       "show us matches immeadiatly


"""""""""""""""
"Mappings
"

"Run the explorer
"I used a function to get around some weird case-sensitive thing
nmap <silent> <F2> :call RunExplorer() <CR>

function! RunExplorer()
	Explore
endfunction


"Toggle line nums
nmap <silent> <F3> :set nu! <CR>

map :W :w
map :Q :q
map :E :e

" use the appropriate number of colors
if &t_Co < 16
	set t_Co=8
else
	set t_Co=16
endif


""""""""""""""
"Autoload profiles
"ah, now the real black mojo begins

"enable filetype detection
filetype plugin indent on

"for all text files, set a good textwidth
autocmd FileType text setlocal textwidth=78

"autocmd BufNewFile,BufRead *.c,*.h exec 'match Todo /\%>' . &textwidth . 'v.\+/'

"HTML profile
augroup html
	au BufRead *.shtml,*.html,*.htm set tw=78 formatoptions=tcqro2 autoindent
augroup END

"C programs
augroup cprog
	au BufRead *.cpp,*.c,*.h set formatoptions=croq sm sw=4 sts=4 cindent comments=sr:/*,mb:*,el:*/,:// | if file_readable("tags.vim") | so tags.vim | endif
augroup END

"Perl profile
augroup perl
	au BufReadPre *.pl,*.pm set formatoptions=croq sm sw=4 sts=4 cindent cinkeys='0{,0},!^F,o,O,e' " tags=./tags,tags,~/devel/tags,~/devel/CVS/bin/contrib/tags
augroup END

"Python profile
augroup python
	au BufReadPre *.py set formatoptions=croq sm sw=4 sts=4 cindent cinkeys='0{,0},!^F,o,O,e'
augroup END

autocmd BufReadPre SConstruct set filetype=python
autocmd BufReadPre SConscript set filetype=python

"Shell profile
augroup shell
	au BufRead profile,bashrc,.profile,.bashrc,.bash_*,.kshrc,*.sh,*.ksh,*.bash,*.env,.login,.cshrc,*.csh,*.tcsh,.z*,zsh*,zlog* set formatoptions=croq sm sw=4 sts=4 cindent cinkeys='0{,0},!^F,o,O,e'
augroup END

command! Wires s/^\(\s*\)\.\?\([^,]\+\)\(,\?\)\s*$/\1.\2(\2)\3/g
vmap p "_dP
vmap P "_dP
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" Ctrl-L to php syntax check
autocmd FileType php noremap <C-L> :!php -l %<CR>

" Ctrl-t makes a new tab
"vmap <C-n> :tabnew<Enter>
"imap <C-n> :tabnew<Enter>
"map <C-n> :tabnew<Enter>

" syntastic customizations
let g:syntastic_php_checkers=['php']
let g:syntastic_java_checkers=[]

autocmd VimEnter * set vb t_vb=
autocmd BufNewFile,BufRead *.json set ft=javascript

" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction
