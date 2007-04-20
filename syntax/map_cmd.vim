"   Copyright (c) 2007, Michael Shvarts <shvarts@akmosoft.com>
" For version 5.x, clear all syntax items.
" For version 6.x, quit when a syntax file was already loaded.
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
syn match mapLine '^\s\+.*$' 
syn match mapTypedLine '^\w\+\s\+.*$'
syn match mapBlankStart '^\s\+' containedin=mapLine nextgroup=mapKeySequence contained
syn match mapType '^\w\+\s\+' containedin=mapTypedLine nextgroup=mapKeySequence contained
syn match mapKeySequence '\S\+' nextgroup=mapAsterisk contained
syn match mapAsterisk '\(\s\+[*&@]\+\)\?' nextgroup=mapNormal contained
syn region mapNormal start='\s*' end=':\@=\|$' keepend nextgroup=mapCmd contained
syn region mapSpecialChar start='<' end='>' keepend containedin=mapNormal
syn match mapCmd '.*' contains=@vimSyntax contained
syn include @vimSyntax $VIMRUNTIME/syntax/vim.vim
syn match vimScriptFunc '<SNR>\d\+_\w\+' containedin=mapCmd
syn match vimSNR   '<SNR>' containedin=vimScriptFunc nextgroup=vimScriptNr
syn match vimScriptNr '\d\+_' contained nextgroup=vimUserFunc1
syn match vimUserFunc1 '\a\w*' contained


" Define the default highlighting.
" For version 5.x and earlier, only when not done already.
" For version 5.8 and later, only when an item doesn't have highlighting yet.
if version >= 508 || !exists("did_map_cmd_syn_inits")
  if version < 508
    let did_map_cmd_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink mapType        Question
  HiLink mapKeySequence PreProc
  HiLink mapNormal      PreProc
  HiLink mapSpecialChar Special
  HiLink mapAsterisk    vimUserAttrb
  HiLink vimSNR             PreProc
  HiLink vimScriptNr        Special
  hi link vimUserFunc       Identifier
  HiLink vimUserFunc1       Identifier
delcommand HiLink
endif
let b:current_syntax = "map"
