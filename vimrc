"Jimi Malcolm - jimi.malcolm@gmail.com

set vb t_vb=

let mapleader=","

" reselect any text pasted in visual mode
xnoremap p pgvy

nnoremap ; :
" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

set hidden
set autoindent copyindent
set helpfile=$VIMRUNTIME/doc/help.txt.gz

" emacs-like navigation
inoremap <C-A> <Esc>0i
nnoremap <C-A> 0i
inoremap <C-E> <Esc>A
nnoremap <C-E> A
inoremap <C-N> <Esc>ja
nnoremap <C-N> j
inoremap <C-P> <Esc>ka
nnoremap <C-P> k
inoremap <C-F> <Esc>la
nnoremap <C-F> l
inoremap <C-B> <Esc>i
nnoremap <C-B> h
inoremap <C-D> <Del>
inoremap <C-K> <Esc>lDA
nnoremap <C-K> D

" emacs-like command line editing
cnoremap <C-A>		<Home>
cnoremap <C-B>		<Left>
cnoremap <C-D>		<Del>
cnoremap <C-E>		<End>
cnoremap <C-F>		<Right>
cnoremap <C-G>		<Esc>
cnoremap <C-N>		<Down>
cnoremap <C-P>		<Up>
cnoremap <Esc><C-B>	<S-Left>
cnoremap <Esc><C-F>	<S-Right>


" Save
inoremap <C-C> <Esc>:w<CR>
nnoremap <C-C> :w<CR>
inoremap <C-X> <Esc>:q<CR>
nnoremap <C-X> :q<CR>


" Display settings
set statusline=[%04{strftime('\%H%M')}]\ \%<%F\ %y\ (%l/%L,%c\ 0x%B)\ %p%%\ %=%1*%m%*%r
highlight User1 term=inverse,bold cterm=inverse,bold ctermfg=red
set laststatus=2 background=dark

if has("syntax")
   syntax on
endif
set noswapfile nobackup showfulltag cmdheight=2 backspace=2 autowrite
set textwidth=78 shiftwidth=4 tabstop=4 softtabstop=4 expandtab joinspaces

" highlight whitespace
set list listchars=tab:>.,trail:.,extends:#,nbsp:.

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" searching...
set incsearch hlsearch report=0 ignorecase smartcase showcmd showmatch showmode

set ruler showmatch

" sudo after already opening file
cmap w!! w !sudo tee % >/dev/null

if has("autocmd")

augroup txt
    au!
    autocmd BufRead,BufNewFile *.txt set tabstop=2 shiftwidth=2 textwidth=78
augroup END

augroup lisp
    au!
    autocmd BufRead,BufNewFile *.cl,*.lisp,*.lsp set syntax=lisp
    autocmd BufRead,BufNewFile *.cl,*.lisp,*.lsp set autoindent
    autocmd BufRead,BufNewFile *.cl,*.lisp,*.lsp set nocindent
    autocmd BufRead,BufNewFile *.cl,*.lisp,*.lsp set lisp
augroup END

augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For .java, .c, and .h files set formatting to C-indent
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd BufRead *              set formatoptions=tcql nocindent comments&
  autocmd BufRead *.java,*.cu,*.[ch] set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
  autocmd BufRead *.java,*.cu,*.[ch] set textwidth=78
  autocmd BufRead *.java,*.cu,*.[ch] set shiftwidth=4 tabstop=4 expandtab smarttab
  autocmd BufRead *.java,*.cu,*.[ch] set cin
  autocmd BufRead *.java,*.cu,*.[ch] inoremap <Tab> <C-R>=CleverTab()<CR>
augroup END

endif " has ("autocmd")

" Priority between files for name completion (suffixes)
" We want this to have a higher priority

set wildignore=*.aux,*.ps,*.pdf,*.bak,*.dvi,*.o
set suffixesadd=.java,.c,.h,.tex,.log,.out

set visualbell noerrorbells
set notitle
set ttyfast

" Autocompletion
function! CleverTab( )
  if getline( '.' )[ col( '.' ) - 2 ] =~ '\a\|_\|-'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction

set scrolloff=8
set autoread

" Make <F8> diff the current buffer with it's file on disk.
" use tempname(), so maybe put it into a helper function
"nmap <F8> :w !diff -wBp -c2 - % >/tmp/tmp.diff<CR>:sp tmp.diff<CR>

colorscheme darkblue
