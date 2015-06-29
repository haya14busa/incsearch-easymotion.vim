"=============================================================================
" FILE: autoload/incsearch/over/modules/EasyMotion.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:module = { 'name' : 'EasyMotion' }

function! s:module._easymotion(cmdline) abort
  let [raw_pattern, _] = a:cmdline._parse_pattern()
  if raw_pattern is# ''
    let pattern = @/
  else
    let pattern = a:cmdline._convert(raw_pattern)
    call histadd('/', a:cmdline.getline())
    let @/ = pattern
  endif
  let config = {
  \   'pattern': pattern,
  \   'visualmode': s:is_visual(a:cmdline._mode),
  \   'direction': 2,
  \   'accept_cursor_pos': 1
  \ }
  call incsearch#highlight#off()
  call EasyMotion#go(config)
  call incsearch#autocmd#auto_nohlsearch(1)
  call feedkeys("\<Plug>(_incsearch-hlsearch)", 'm')
endfunction

function! s:module.on_char_pre(cmdline)
  if a:cmdline.is_input('<Over>(easymotion)')
    call a:cmdline.setchar('')
    call self._easymotion(a:cmdline)
    call a:cmdline._exit_incsearch()
  endif
endfunction

function! incsearch#over#modules#EasyMotion#make() abort
  return deepcopy(s:module)
endfunction

function! s:is_visual(mode) abort
  return a:mode =~# "[vV\<C-v>]"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
