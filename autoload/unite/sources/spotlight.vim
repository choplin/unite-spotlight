let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
      \ 'name': 'spotlight',
      \ 'max_candidates': 30,
      \ 'is_volatile': 1,
      \ 'required_pattern_length': 3,
      \ }

function! s:unite_source.gather_candidates(args, context)
  return map(
        \ split(
        \   unite#util#system(printf(
        \     'mdfind %s | head -n %d',
        \     a:context.input,
        \     s:unite_source.max_candidates)),
        \   "\n"),
        \ '{
        \ "word": v:val,
        \ "source": "spotlight",
        \ "kind": "file",
        \ "action__path": v:val,
        \ "action__directory": fnamemodify(v:val, ":p:h"),
        \ }')
endfunction

function! unite#sources#spotlight#define()
  return executable('mdfind') ? s:unite_source : []
endfunction

" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
