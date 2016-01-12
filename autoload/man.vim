if exists('g:autoloaded_man')
  finish
endif
let g:autoloaded_man = 1

function! man#get_page(split_type, ...)
  if a:0 == 0
    call man#helpers#error("Argument required.")
    return
  elseif a:0 == 1
    let sect = ''
    let page = a:1
  elseif a:0 == 2
    let sect = a:1
    let page = a:2
  else
    call man#helpers#error("Too many arguments.")
    return
  endif

  if sect !=# '' && !s:manpage_exists(sect, page)
    let sect = ''
  endif
  if !s:manpage_exists(sect, page)
    call man#helpers#error("No manual entry for '".page."'.")
    return
  endif

  call s:get_new_or_existing_man_window(a:split_type)
  call s:load_manpage(sect, page)
endfunction

function! s:manpage_exists(sect, page)
  if a:page ==# ''
    return 0
  endif
  let find_arg = man#helpers#find_arg()
  let where = system(g:vim_man_cmd.' '.find_arg.' '.man#helpers#get_cmd_arg(a:sect, a:page))
  if where !~# '^\s*/'
    " result does not look like a file path
    return 0
  else
    " found a manpage
    return 1
  endif
endfunction

function! s:load_manpage(...)
  call termopen('man ' . join(a:000, ' '))
  setlocal syntax=man

  startinsert
  au BufEnter <buffer> startinsert
  doau User ManOpen
endfunction

function! s:get_new_or_existing_man_window(split_type)
  if a:split_type == 'current' || &syntax == 'man'
    enew
  elseif a:split_type == 'vertical'
    vnew
  elseif a:split_type == 'tab'
    tabnew
  else
    new
  endif
endfunction

" vim:set ft=vim et sw=2:
