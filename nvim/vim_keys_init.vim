"*****************************************************************************
"" KEY MAPPINGS
"*****************************************************************************

""" Map leader to ,
let mapleader=','

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

"" Fix backspace key so that it works as expected.
set backspace=indent,eol,start

" Mappings {{{

" stay in the Visual mode when using shift commands
xnoremap < <gv
xnoremap > >gv

" 2 mappings for quick prototyping: duplicate this line and comment it out
nmap <silent> <leader>] m'yygccp`'j
nmap <silent> <leader>[ m'yygccP`'k

command! -nargs=+ -complete=command PutOutput execute 'put =execute(' . escape(string(<q-args>), '|"') . ')'

" Clipboard {{{

" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

" ,c is easier to type than "+ because it doesn't require pressing Shift
noremap <leader>c "+
" these 3 mappings are equivalent to Ctrl+C, Ctrl+V, and Ctrl+X in GUI
" editors (hence the names)
" noremap <leader>cc "+y
" noremap <leader>cv "+gP
" noremap <leader>cV "+gp
" noremap <leader>cx "+d
" }}}

" make the default Vim mappings more consistent
" https://www.reddit.com/r/vim/comments/dgbr9l/mappings_i_would_change_for_more_consistent_vim/
nnoremap U <C-r>
nnoremap Y y$

" }}}

"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" grep.vim
nnoremap <silent> <leader>f :Rgrep<CR>

noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>

"" Buffer nav
noremap <leader>z :bp<CR>
noremap <leader>x :bn<CR>

"" Close buffer
noremap <leader>c :bd<CR>

"" Clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr>

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"" Open current line on GitHub
nnoremap <Leader>o :.Gbrowse<CR>

" Key mappings for moving text up or down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

command -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction
nmap <silent> ' :QFix<CR>

