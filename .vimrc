call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/ZoomWin'
Plug 'BurntSushi/ripgrep'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'christoomey/vim-tmux-navigator'
Plug 'majutsushi/tagbar'
Plug 'diabloneo/cscope_maps.vim'
Plug 'airblade/vim-gitgutter'
Plug 'ervandew/supertab'
" Themes
Plug 'NLKNguyen/c-syntax.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
call plug#end()

let mapleader='\'
set hlsearch
set nu

nnoremap <Leader>zsh :e ~/.zshrc<CR>
nnoremap <Leader>vim :e ~/.vimrc<CR>
"------------------------------------------------------------------------------
" FZF.
"------------------------------------------------------------------------------
"
nnoremap <silent> <Leader>t :Tags<CR>
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>w :Windows<CR>
nnoremap <silent> <leader>l :BLines<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <Leader>C :Colors<CR>
"nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
"nnoremap <silent> <leader>. :AgIn<space>
nnoremap <silent> <leader>/ :execute 'Rg ' . input('Rg/')<CR>
nnoremap <silent> <leader>. :RgIn<space>

" Hide statusline of terminal buffer
"autocmd! FileType fzf
"autocmd  FileType fzf set laststatus=0 noshowmode noruler
  "\| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

command! -bang Colors
  \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'}, <bang>0)

"" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-q': 'wall | bdelete',
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }


" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)


" Advanced customization using autoload functions
" inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

set complete=.,w,b,u

"----------------------------------------------------------------------------

" Rg RipGrep
"----------------------------------------------------------------------------
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options

command! -nargs=+ -complete=dir RgIn call s:rg_in(<f-args>)

command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

"   :Rg  - Start fzf with hidden preview window that can be enabled with '?' key
"   :Rg! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg -i --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

nnoremap <silent> S :call SearchWordWithRg()<CR>
function! SearchWordWithRg()
  execute 'Rg' expand('<cword>')
endfunction

"------------------------------------------------------------------------------

" Command mistypes.
nnoremap :W :w
nnoremap :E :e
nnoremap :Q :q
nnoremap :Set :set
nnoremap :Vsp :vsp
cmap w!! w !sudo tee >/dev/null %

"------------------------------------------------------------------------------
" Theme
"------------------------------------------------------------------------------

set t_Co=256   " This is may or may not needed.

"set background=light
set background=dark
colorscheme PaperColor
"colorscheme gruvbox

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme='distinguished'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tmuxline#enabled = 1
let airline#extensions#tmuxline#snapshot_file = "~/.tmux-status.conf"

" ------------------------------------------------------------------------------
"  persistant undo
" ------------------------------------------------------------------------------
" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

"DMS needs 4 space indentation. Take it.
autocmd BufNewFile,BufRead ~/git_migration/acadia_kernel/*/pavilion/target/* setlocal expandtab

"Tagbar
nmap <leader>rt :TagbarToggle<CR>

"cscope
set cscopequickfix=s-,c-,d-,i-,t-,e-
