" nvim specific configs

" sourcing vimrc
source ~/.config/vim/vimrc " regular vimrc 
source ~/.config/vim/keybinds.vim " vim keybinds


" removes pesky default bg
highlight Normal guibg=none
highlight NonText guibg=none
highlight Normal ctermbg=none
highlight NonText ctermbg=none


" plugins
call plug#begin()

" List your plugins here
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline' 	" status line 
Plug 'sainnhe/everforest' 	" everforest theme

call plug#end()


" Make airline use powerline fonts
let g:airline_powerline_fonts = 1


" Theme configuration options

" Note: everforest options must be set BEFORE colorscheme: everforest
if has ('termguicolors')
	set termguicolors
endif

let g:everforest_background = 'hard'
let g:everforest_enable_italic = 1
let g:everforest_transparent_background = 1
let g:airline_theme = 'everforest' " airline use everforest

colorscheme everforest " sets theme
