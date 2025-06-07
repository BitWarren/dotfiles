" My nvim keybinds

" Use ESC to exit term mode
tnoremap <Esc> <C-\><C-N>
nnoremap <A-h> :nohlsearch<CR>
nnoremap <A-s> :call SpellingSetUnset()<CR>


" Functions for remaps defined here

" Spell toggle func
function! SpellingSetUnset()
	if &spell == 1
		:set nospell
		echom 'Spell checking OFF'
	else 
		:set spell spelllang=en_us
		echom 'Spell checking ON'
	endif
endfunction
