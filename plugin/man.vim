if exists('g:loaded_vim_utils_man') && g:loaded_vim_utils_man
  finish
endif
let g:loaded_vim_utils_man = 1
let g:loaded_man = 1 " stop the buildin man plugin from loading

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:vim_man_cmd')
  let g:vim_man_cmd='/usr/bin/man'
endif

if !exists('g:nvim_man_default_target')
  let g:nvim_man_default_target='vertical'
endif

command! -nargs=* -bar -complete=customlist,man#complete Man  call man#terminal#get_page(g:nvim_man_default_target, <f-args>)
command! -nargs=* -bar -complete=customlist,man#complete Sman call man#terminal#get_page('horizontal', <f-args>)
command! -nargs=* -bar -complete=customlist,man#complete Vman call man#terminal#get_page('vertical', <f-args>)
command! -nargs=* -bar -complete=customlist,man#complete Tman call man#terminal#get_page('tab', <f-args>)

" map a key to open a manpage for word under cursor, example: map ,k <Plug>(Man)
nnoremap <silent> <Plug>(Man)  :<C-U>call man#terminal#get_page_from_cword(g:nvim_man_default_target, v:count)<CR>
nnoremap <silent> <Plug>(Sman) :<C-U>call man#terminal#get_page_from_cword('horizontal', v:count)<CR>
nnoremap <silent> <Plug>(Vman) :<C-U>call man#terminal#get_page_from_cword('vertical', v:count)<CR>
nnoremap <silent> <Plug>(Tman) :<C-U>call man#terminal#get_page_from_cword('tab', v:count)<CR>

augroup nvim_man
  au!

  " automatically enter terminal mode
  au User ManOpen au BufEnter <buffer> startinsert

  " enable window key in manpage
  au User ManOpen tnoremap <buffer> <C-w> <C-\><C-n><C-w>

  " close window when quiting
  au User ManOpen au TermClose <buffer> close
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set ft=vim et sw=2:
