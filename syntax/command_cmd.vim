"   Copyright (c) 2007, Michael Shvarts <shvarts@akmosoft.com>
" For version 5.x, clear all syntax items.
" For version 6.x, quit when a syntax file was already loaded.
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
"set ft=vim
"syn region commandTitle start='^\s*Name\s\+Args\s\+Range\>' end='\<Complete\s\+Definition$' keepend 
syn region commandSpecialChar start='<' end='>' keepend contains=commandSubst
syn match commandSubst '<\([fq]-\)\?\(line[12]\|bang\|count\|reg\|args\|lt\)>' contained
syn match commandName contained '\a\w*'
"syn match commandTitle 'Name\s\+Args\s\+Range\s\+Complete\s\+Definition'
syn match commandListTitle '\%1l.*'
syn region commandListBody start='^\%2l' end='\%$' contains=commandBangReg
syn match commandBangReg '^\s*!\?\s*' nextgroup=commandName contained
syn match commandName '\w\+' nextgroup=commandArgs contained
syn match commandArgs '\s\+[01%?*+]' nextgroup=commandRange contained
syn match commandRange '\(\s\+\([%.]\|\d\+c\)\)\?' nextgroup=commandComplete contained
syn match commandComplete '\(\s\+\(augroup\|buffer\|command\|dir\|environment\|event\|expression\|file\|shellcmd\|function\|help\|highlight\|mapping\|menu\|option\|tag\|tag_listfiles\|var\|custom\|customlist\)\>\)\?\s\+' nextgroup=commandDefinition contained
syn match commandDefinition '.*' contains=@vimSyntax contained
syn include @vimSyntax $VIMRUNTIME/syntax/vim.vim
syn match vimScriptFunc '<SNR>\d\+_\w\+' containedin=commandDefinition 
syn match vimSNR   '<SNR>' containedin=vimScriptFunc nextgroup=vimScriptNr
syn match vimScriptNr '\d\+_' contained nextgroup=vimUserFunc1
syn match vimUserFunc1 '\a\w*' contained


"syn region commandDesc start='^[ !]*' end='[01%?*+]\(\s\+%\)\?\(\s\+\(file\|dir\|buffer\|menu\|highlight\|function\|custom\|command\)\>\)\?' oneline keepend contains=commandName,commandSpecialChar nextgroup=commandNoDef
"syn region commandVimString start='"' skip='\\"' end='"' keepend
"syn region commandVimString start="'" end="'" keepend
" Define the default highlighting.
" For version 5.x and earlier, only when not done already.
" For version 5.8 and later, only when an item doesn't have highlighting yet.
if version >= 508 || !exists("did_command_cmd_syn_inits")
  if version < 508
    let did_command_cmd_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink commandName        PreProc 
  HiLink commandArgs        vimUserAttrb
  HiLink commandComplete    vimUserAttrb
  HiLink commandRange       vimUserAttrb
  HiLink commandListTitle   Title
  HiLink commandSpecialChar SpecialKey
  HiLink vimSNR             PreProc
  HiLink vimScriptNr        Special
  hi link vimUserFunc       Identifier
  HiLink vimUserFunc1       Identifier
  delcommand HiLink
endif
let b:current_syntax = "command"
