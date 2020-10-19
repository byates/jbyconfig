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

" Mappings

" stay in the Visual mode when using shift commands
xnoremap < <gv
xnoremap > >gv

" 2 mappings for quick prototyping: duplicate this line and comment it out
nmap <silent> <leader>] m'yygccp`'j
nmap <silent> <leader>[ m'yygccP`'k

command! -nargs=+ -complete=command PutOutput execute 'put =execute(' . escape(string(<q-args>), '|"') . ')'

" Clipboard

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

" make the default Vim mappings more consistent
" https://www.reddit.com/r/vim/comments/dgbr9l/mappings_i_would_change_for_more_consistent_vim/
nnoremap U <C-r>
nnoremap Y y$

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
"" Make <end" go AFTER the last char
nnoremap <END> $l
vnoremap <END> $l

"" Fix delete so it doesn't overwrite the paster buffer
nnoremap d "_d
vnoremap d "_d
nnoremap x "_x
nnoremap <Del> "_x
xnoremap <leader>p "_dP
noremap YY "+y<CR>
noremap XX "+x<CR>
"" Copy current word
nnoremap <leader>e yiwe
"" Replace current word
nnoremap <leader>w viw"_dPe
"" Keymap to toggle "paste" mode on/off. This helps fix indent when pasting.
nnoremap <leader>P :set invpaste paste?<CR>
set pastetoggle=<leader>P

"" Make shift+<arrows/home/end> work like other editors.
set keymodel=startsel,stopsel

"Remove all trailing whitespace by pressing ,<backspace>
nnoremap <leader><BS> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Toggle signcolumn. Works only on vim>=8.0 or NeoVim
function! ToggleSignColumn()
    if !exists("b:signcolumn_on") || b:signcolumn_on
        set signcolumn=no
        set nonumber
        set nornu
        let b:signcolumn_on=0
    else
        set signcolumn=yes
        set number
        set rnu
        let b:signcolumn_on=1
    endif
endfunction

"" Add toggle for line numbers and sign column
noremap <leader><leader>n :call ToggleSignColumn()<CR>

nnoremap <silent> <F2> :TagbarToggle<CR>
nnoremap <silent> <F5> :FzfPreviewProjectGrep<CR>
nnoremap <leader>b :FzfPreviewBuffers<CR>

