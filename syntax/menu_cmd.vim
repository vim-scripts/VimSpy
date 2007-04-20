"   Copyright (c) 2007, Michael Shvarts <shvarts@akmosoft.com>
" For version 5.x, clear all syntax items.
" For version 6.x, quit when a syntax file was already loaded.
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
syn match Menus '--- Menus ---'
syn match menuHeader /^\s*\d\+.*/ contains=menuName,menuNum
syn match menuName contained '\S.*'
syn match menuNum contained /^\s*\d\+\s\+/ nextgroup=menuName
syn match menuCmdLine /^\s*\a\*\?\a\?.*/ 
syn region menuTypeAndNormal start='^\s*\a' end=':\|$' keepend containedin=menuCmdLine contains=menuType nextgroup=menuCmd contained 
syn match menuType '^\s*\a\*\?\a\?' nextgroup=menuNormal contained
syn match menuNormal '.*' contained
syn match menuSpecialChar '<[^<>]\{2,\}>' containedin=menuNormal contained
syn match menuCmd '.*' contains=@vimSyntax contained
syn include @vimSyntax $VIMRUNTIME/syntax/vim.vim
syn match vimScriptFunc '<SNR>\d\+_\w\+' containedin=menuCmd
syn match vimSNR   '<SNR>' containedin=vimScriptFunc nextgroup=vimScriptNr
syn match vimScriptNr '\d\+_' contained nextgroup=vimUserFunc1
syn match vimUserFunc1 '\a\w*' contained


" Define the default highlighting.
" For version 5.x and earlier, only when not done already.
" For version 5.8 and later, only when an item doesn't have highlighting yet.
if version >= 508 || !exists("did_menu_cmd_syn_inits")
  if version < 508
    let did_menu_cmd_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink menuName       PreProc
  HiLink Menus          Title
  HiLink menuSpecialChar Special
  HiLink menuType        Special
  HiLink menuNum         Question
  HiLink menuNormal      LineNr   
  HiLink vimSNR             PreProc
  HiLink vimScriptNr        Special
  hi link vimUserFunc       Identifier
  HiLink vimUserFunc1       Identifier
delcommand HiLink
endif
let b:current_syntax = "menu"
