if exists('g:loaded_toggle_quotes') | finish | endif " prevent loading file twice

let s:save_cpo = &cpo " save user coptions
set cpo&vim " reset them to defaults

command! ToggleQuotes lua require('toggle-quotes').toggle_quotes()

let &cpo = s:save_cpo " and restore after
unlet s:save_cpo

let g:loaded_toggle_quotes = 1
