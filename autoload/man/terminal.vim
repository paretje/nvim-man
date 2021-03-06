if exists('g:autoloaded_man')
  finish
endif
let g:autoloaded_man = 1

function! man#terminal#get_page(split_type, ...)
  if a:0 == 0
    call man#helpers#error("Argument required.")
    return
  elseif a:0 == 1
    let l:ref = a:1
  elseif a:0 == 2
    let l:ref = a:2 . '(' . a:1 . ')'
  else
    call man#helpers#error("Too many arguments.")
    return
  endif

  try
    let [l:sect, l:page] = man#extract_sect_and_name_ref(l:ref)
  catch
    call man#helpers#error(v:exception)
    return
  endtry

  if !s:manpage_exists(sect, page)
    call man#helpers#error("No manual entry for '".page."'.")
    return
  endif

  call s:get_new_or_existing_man_window(a:split_type)
  call s:load_manpage(sect, page)
endfunction

function! s:load_manpage(sect, page)
  call termopen('man ' . a:sect . ' ' . a:page)

  let b:man_sect = a:sect
  setlocal syntax=man

  startinsert
  doau User ManOpen
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

function! s:get_new_or_existing_man_window(split_type)
  if a:split_type == 'current' || &syntax == 'man'
    enew
  else
    let l:winnr = winnr()
    wincmd w
    while l:winnr != winnr() && &syntax != 'man'
      wincmd w
    endwhile
    if &syntax == 'man'
      enew
    elseif a:split_type == 'vertical'
      vnew
    elseif a:split_type == 'tab'
      tabnew
    else
      new
    endif
  endif
endfunction

" vim:set ft=vim et sw=2:
