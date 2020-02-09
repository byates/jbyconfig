" allow moving cursor just after the last chraracter of the line
set virtualedit=onemore

set foldmethod=marker

set commentstring=//%s

"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set fileformats=unix,dos,mac

set autoread

" remove trailing whitespaces
command! FixWhitespace :%s/\s\+$//e

"
" Indentination {{{

  function SetIndent(expandtab, shiftwidth)
    let &l:expandtab = a:expandtab
    let &l:shiftwidth = str2nr(a:shiftwidth)
    let &l:tabstop = &shiftwidth
    let &l:softtabstop = &shiftwidth
  endfunction
  command -nargs=1 Indent call SetIndent(1, <q-args>)
  command -nargs=1 IndentTabs call SetIndent(0, <q-args>)

  " use 4 spaces for indentination
  set expandtab shiftwidth=4 tabstop=4 softtabstop=4
  " round indents to multiple of shiftwidth when using shift (< and >) commands
  set shiftround

  let g:indentLine_char = "\u2502"
  let g:indentLine_first_char = g:indentLine_char
  let g:indentLine_showFirstIndentLevel = 1
  let g:indentLine_fileTypeExclude = ['text', 'help', 'tutor', 'man']

" }}}


" Invisible characters {{{
  set list
  let &listchars = "tab:\u2192 ,extends:>,precedes:<,eol:\u00ac,trail:\u00b7"
  let &showbreak = '>'
" }}}


" Cursor and Scrolling {{{

"" Enable virtual edit (allow cursor beyond eol)
:set virtualedit=all

" remember cursor position
augroup vimrc-editing-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exec "normal! g`\"" | endif
augroup END

" }}}


" Wrapping {{{
set nowrap
set colorcolumn=120
" }}}

" Search {{{

"" Searching
set hlsearch
set incsearch

hi Search ctermbg=LightBlue

" ignore case if the pattern doesn't contain uppercase characters (use '\C'
" anywhere in pattern to override these two settings)
set ignorecase smartcase

nnoremap \ <Cmd>nohlsearch<CR>

let g:indexed_search_center = 1

" search inside a visual selection
xnoremap / <Esc>/\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
xnoremap ? <Esc>?\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l

" * and # in the Visual mode will search the selected text
function! s:VisualStarSearch(search_cmd)
    let l:tmp = @"
    normal! gvy
    let @/ = '\V' . substitute(escape(@", a:search_cmd . '\'), '\n', '\\n', 'g')
    let @" = l:tmp
endfunction
" HACK: my mappings are added on VimEnter to override mappings from the
" vim-indexed-search plugin
augroup vimrc-editing-visual-star-search
    autocmd!
    autocmd VimEnter *
        \ xmap * :<C-u>call <SID>VisualStarSearch('/')<CR>n
        \|xmap # :<C-u>call <SID>VisualStarSearch('?')<CR>N
augroup END

function! BuffersList()
    let all = range(0, bufnr('$'))
    let res = []
    for b in all
    if buflisted(b)
        call add(res, bufname(b))
    endif
    endfor
    return res
endfunction

function! GrepBuffers (expression)
    exec 'vimgrep/'.a:expression.'/ '.join(BuffersList())
endfunction

command! -nargs=+ GrepBufs call GrepBuffers(<q-args>)
nnoremap <leader>F :call GrepBuffers("<C-R><C-W>")<CR>

" grep.vim
let Grep_Default_Options = '-IR'
let Grep_Skip_Files = '*.log *.db'
let Grep_Skip_Dirs = '.git node_modules'

" }}}


" Replace {{{

  " show the effects of the :substitute command incrementally, as you type
  " (works similar to 'incsearch')
  set inccommand=nosplit

  " quick insertion of the substitution command
  nnoremap gs :%s///g<Left><Left><Left>
  xnoremap gs :s///g<Left><Left><Left>
  nnoremap gss :%s///g<Left><Left>
  xnoremap gss :s///g<Left><Left>

" }}}


" Formatting {{{

  " don't insert a comment after hitting 'o' or 'O' in the Normal mode
  augroup vimrc-editing-formatting
    autocmd!
    autocmd FileType * set formatoptions-=o
  augroup END

" }}}



