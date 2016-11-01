" load guard {{{1

if exists('g:autoloaded_man_helpers')
  finish
endif
let g:autoloaded_man_helpers = 1

" }}}
" man#helpers#section_arg and man#helpers#find_arg {{{1

let s:section_arg = ''
let s:find_arg = '-w'
try
  if !has('win32') && $OSTYPE !~ 'cygwin\|linux' && system('uname -s') =~ 'SunOS' && system('uname -r') =~ '^5'
    let s:section_arg = '-s'
    let s:find_arg = '-l'
  endif
catch /E145:/
  " Ignore the error in restricted mode
endtry

function! man#helpers#section_arg()
  return s:section_arg
endfunction

function! man#helpers#find_arg()
  return s:find_arg
endfunction

" }}}
" man#helpers#error {{{1

function! man#helpers#error(str)
  echohl ErrorMsg
  echomsg a:str
  echohl None
endfunction

" }}}
" man#helpers#get_cmd_arg {{{1

function! man#helpers#get_cmd_arg(sect, page)
  if a:sect == ''
    return a:page
  else
    return man#helpers#section_arg().' '.a:sect.' '.a:page
  endif
endfunction

" }}}
" vim:set ft=vim et sw=2:
