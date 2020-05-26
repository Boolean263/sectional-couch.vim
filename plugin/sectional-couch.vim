" sectional-couch.vim - make section/paragraph navigation configurable
" Author:       David Perry <https://github.com/Boolean263>
" Version:      0.0.1
"
" Inspired by https://learnvimscriptthehardway.stevelosh.com/chapters/51.html

if exists("g:loaded_sectional_couch") || &cp
  finish
endif
let g:loaded_sectional_couch = 1

function! s:Couch(keys, visual) " {{{1
  if a:visual
    normal! gv
  endif
  if a:keys == '[[' || a:keys == ']]' || a:keys == '[]' || a:keys == ']['
    let l:opt = &sections
    let l:has_end = 1
  elseif a:keys == '{' || a:keys == '}'
    let l:opt = &paragraphs
    let l:has_end = 0
  else
    echoerr "Shouldn't get here"
    exec 'normal! '.a:keys
    return
  endif
  if !(l:opt[0] == '/' && l:opt[-1:] == '/')
    " It's not bracketed by '/' characters. Assume normal behaviour
    exec 'normal! '.a:keys
    return
  endif
  " It's a '/'-bracketed regexp. Do our magic. (Pun intended.)

  " Strip the '/' from each end
  let l:re = l:opt[1:-2]

  " If we can have 2 regexps (section start/end), split them up.
  if l:has_end
    " This ugly mess is meant to find the '/ /' that separates the two
    " regexes without matching on \-escaped slashes.
    let l:parts = split(l:re, '\(\\\)\@<!/ \(\\\)\@<!/')

    if len(l:parts) == 1 || a:keys[0] == a:keys[1]
      " Moving to the start of a section
      " (or else we don't have a separate end-section expression)
      let l:re = l:parts[0]
    else
      " Moving to the end of a section
      let l:re = l:parts[1]
    endif
  else
    " Not a 2-part regexp.
    let l:re = l:opt
  endif

  " Finally, prepare to call search(). Use flags to set search direction,
  " avoid wrapscan, and mark our prior location.
  " search() is subject to ignorecase/smartcase, so we just have to hope
  " our user is taking that into account.
  let l:flags = "Ws"
  if a:keys[0] == '[' || a:keys == '{'
    " If we're searching backwards:
    let l:flags .= "b"
  endif
  call search(l:re, l:flags)
endfunction
" }}}1

" Global key bindings {{{1
noremap <script> <silent> ]] :call <SID>Couch(']]', 0)<cr>
noremap <script> <silent> ][ :call <SID>Couch('][', 0)<cr>
noremap <script> <silent> [[ :call <SID>Couch('[[', 0)<cr>
noremap <script> <silent> [] :call <SID>Couch('[]', 0)<cr>
noremap <script> <silent> { :call <SID>Couch('{', 0)<cr>
noremap <script> <silent> } :call <SID>Couch('}', 0)<cr>

vnoremap <script> <silent> ]] :<c-u>call <SID>Couch(']]', 1)<cr>
vnoremap <script> <silent> ][ :<c-u>call <SID>Couch('][', 1)<cr>
vnoremap <script> <silent> [[ :<c-u>call <SID>Couch('[[', 1)<cr>
vnoremap <script> <silent> [] :<c-u>call <SID>Couch('[]', 1)<cr>
vnoremap <script> <silent> { :<c-u>call <SID>Couch('{', 1)<cr>
vnoremap <script> <silent> } :<c-u>call <SID>Couch('}', 1)<cr>
" }}}1

" vim:ft=vim:sw=2:sts=2:fdm=marker:
