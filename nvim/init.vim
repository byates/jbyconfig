" vim-bootstrap

" Folder in which script resides
let g:nvim_dotfiles_dir = expand('<sfile>:p:h')
" Flag indicating if terminal or gui
let g:vim_ide = get(g:, 'vim_ide', 0)
" polyglot_disabled must be declared prior to polyglot init
" Default python highlight is better than polyglot provides
let g:polyglot_disabled = ['python']

"" Include plugins
if filereadable(expand("~/.config/nvim/vim_plugins_init.vim"))
  source ~/.config/nvim/vim_plugins_init.vim
  endif

"" Include keymapping
if filereadable(expand("~/.config/nvim/vim_keys_init.vim"))
  source ~/.config/nvim/vim_keys_init.vim
  endif

"" Include editing settings
if filereadable(expand("~/.config/nvim/vim_editing_init.vim"))
  source ~/.config/nvim/vim_editing_init.vim
  endif

"" Include C++/C settings
if filereadable(expand("~/.config/nvim/vim_cpp_init.vim"))
  ""source ~/.config/nvim/vim_cpp_init.vim
  endif

 " Include GO settings
if filereadable(expand("~/.config/nvim/vim_go_init.vim"))
  source ~/.config/nvim/vim_go_init.vim
  endif

 " Include Python settings
if filereadable(expand("~/.config/nvim/vim_python_init.vim"))
  source ~/.config/nvim/vim_python_init.vim
  endif

  "" Include UI settings
if filereadable(expand("~/.config/nvim/vim_ui_init.vim"))
  source ~/.config/nvim/vim_ui_init.vim
  endif

  "" Include ansible settings
if filereadable(expand("~/.config/nvim/vim_ansible.vim"))
  source ~/.config/nvim/vim_ansible.vim
  endif

"*****************************************************************************
"" Basic Setup
"*****************************************************************************"
if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

""****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call vim_ui_init#setupWrapping()
augroup END

"" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

"" buildroot
augroup vimrc-builtroot
  autocmd!
  autocmd BufRead,BufNewFile Config.in call SetIndent(0, 4)
augroup END

augroup completion_preview_close
  autocmd!
  if v:version > 703 || v:version == 703 && has('patch598')
    autocmd CompleteDone * if !&previewwindow && &completeopt =~ 'preview' | silent! pclose | endif
  endif
augroup END

"" Add commands for statup screen (such as nerdtree) if desired.
augroup Startup
  autocmd!
  autocmd VimEnter *
                \   if !argc()
                \ |   Startify
                \ |   wincmd w
                \ | endif
augroup END

