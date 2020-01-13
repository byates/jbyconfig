"*****************************************************************************
"" Vim-PLug core
"*****************************************************************************

let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!\curl -fLo " . vimplug_exists . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Required:
call plug#begin(expand('~/.config/nvim/plugged'))

"*****************************************************************************
"" Plug install packages
"*****************************************************************************

" UI {{{
  Plug 'mhinz/vim-startify'
  Plug 'moll/vim-bbye'
  Plug 'gerw/vim-HiLinkTrace'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'Yggdroot/indentLine'
  Plug 'vim-scripts/CSApprox'
  Plug 'henrik/vim-indexed-search'
  Plug 'tomasr/molokai'
  Plug 'morhetz/gruvbox'
  Plug 'romainl/vim-qf'
" }}}

" Git {{{
  Plug 'tpope/vim-rhubarb'
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
" }}}

" Files {{{
   Plug 'scrooloose/nerdtree'
   Plug 'jistr/vim-nerdtree-tabs'
   Plug 'jlanzarotta/bufexplorer'
   Plug 'vim-scripts/grep.vim'
   Plug 'tpope/vim-eunuch'
   "" Vim-Session
   Plug 'xolox/vim-misc'
"" }}}

" Programming {{{
  Plug 'editorconfig/editorconfig-vim'
  Plug 'majutsushi/tagbar'
  Plug 'Raimondi/delimitMate'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'andymass/vim-matchup'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'easymotion/vim-easymotion'
  Plug 'junegunn/vim-easy-align'
  Plug 'inkarkat/vim-ingo-library'  " required by LineJuggler
  Plug 'inkarkat/vim-LineJuggler', { 'branch': 'stable' }
  "" Snippets
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  "" Go Lang Bundle
  Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
  "" Python Bundle
  Plug 'davidhalter/jedi-vim'
""  Plug 'w0rp/ale'"
  Plug 'sheerun/vim-polyglot'
  Plug 'liuchengxu/vista.vim'
" }}} 

call plug#end()

" Required:
filetype plugin indent on


