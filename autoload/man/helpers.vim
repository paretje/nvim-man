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
" man#helpers#extract_permitted_section_value {{{1

function! man#helpers#extract_permitted_section_value(section_arg)
  if a:section_arg =~# '^*$'
    " matches all dirs with a glob 'man*'
    return a:section_arg
  elseif a:section_arg =~# '^\d[xp]\?$'
    " matches dirs: man1, man1x, man1p
    return a:section_arg
  elseif a:section_arg =~# '^[nlpo]$'
    " matches dirs: mann, manl, manp, mano
    return a:section_arg
  elseif a:section_arg =~# '^\d\a\+$'
    " take only first digit, sections 3pm, 3ssl, 3tiff, 3tcl are searched in man3
    return matchstr(a:section_arg, '^\d')
  else
    return ''
  endif
endfunction

" }}}
" man#helpers#get_path_glob {{{1

" creates a string containing shell globs suitable to finding matching manpages
function! man#helpers#get_path_glob(manpath, section, file, separator)
  let section_part = empty(a:section) ? '*' : a:section
  let file_part = empty(a:file) ? '' : a:file
  let man_globs = substitute(a:manpath.':', ':', '/*man'.section_part.'/'.file_part.a:separator, 'g')
  let cat_globs = substitute(a:manpath.':', ':', '/*cat'.section_part.'/'.file_part.a:separator, 'g')
  " remove one unecessary path separator from the end
  let cat_globs = substitute(cat_globs, a:separator.'$', '', '')
  return man_globs.cat_globs
endfunction

" }}}1
" man#helpers#expand_path_glob {{{1

" path glob expansion to get filenames
function! man#helpers#expand_path_glob(path_glob, manpage_prefix)
  if empty(a:manpage_prefix)
    let manpage_part = '*'
  elseif a:manpage_prefix =~# '*$'
    " asterisk is already present
    let manpage_part = a:manpage_prefix
  else
    let manpage_part = a:manpage_prefix.'*'
  endif
  return split(globpath(a:path_glob, manpage_part, 1), '\n')
endfunction

" }}}
" man#helpers#strip_dirname_and_extension {{{1

" first strips the directory name from the match, then the extension
function! man#helpers#strip_dirname_and_extension(manpage_path)
  return man#helpers#strip_extension(fnamemodify(a:manpage_path, ':t'))
endfunction

" }}}
" man#helpers#strip_extension {{{1

" Public function so it can be used for testing.
" Check 'manpage_extension_stripping_test.vim' for example input and output
" this regex produces.
function! man#helpers#strip_extension(filename)
  return substitute(a:filename, '\.\(\d\a*\|n\|ntcl\)\(\.\a*\|\.bz2\)\?$', '', '')
endfunction

" }}}
" man#helpers#manpath {{{1

" fetches a colon separated list of paths where manpages are stored
function! man#helpers#manpath()
  " We don't expect manpath to change, so after first invocation it's
  " saved/cached in a script variable to speed things up on later invocations.
  if !exists('s:manpath')
    " perform a series of commands until manpath is found
    let s:manpath = $MANPATH
    if s:manpath ==# ''
      let s:manpath = system('manpath 2>/dev/null')
      if s:manpath ==# ''
        let s:manpath = system('man '.man#helpers#find_arg.' 2>/dev/null')
      endif
    endif
    " strip trailing newline for output from the shell
    let s:manpath = substitute(s:manpath, '\n$', '', '')
  endif
  return s:manpath
endfunction

" }}}
" vim:set ft=vim et sw=2:
