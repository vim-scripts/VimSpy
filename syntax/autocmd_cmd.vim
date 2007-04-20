"   Copyright (c) 2007, Michael Shvarts <shvarts@akmosoft.com>
" For version 5.x, clear all syntax items.
" For version 6.x, quit when a syntax file was already loaded.
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
"syn region autocmdSpecialChar start='<' end='>' keepend contains=autocmdSubst
"syn match autocmdSubst '<\([fq]-\)\?\(line[12]\|bang\|count\|reg\|args\|lt\)>' contained
"syn match autocmdName contained '\a\w*'
"syn match autocmdTitle 'Name\s\+Args\s\+Range\s\+Complete\s\+Definition'
syn match autocmdListTitle '\%1l.*'
syn region autocmdListBody start='^\%2l' end='\%$'
syn match autocmdGroup '^\w\+\s\+\w\+' containedin=autocmdListBody 
syn match autocmdEvent '^\w\+$' containedin=autocmdListBody 
syn match autocmdEvent '\w\+$' containedin=autocmdGroup contained
syn match autocmdGroupName '^\w\+' containedin=autocmdGroup contained
syn match autocmdMatchLine '^\s\{4\}\S\+\(\n\s\{5,\}\S\)\?.*' containedin=autocmdListBody
syn match autocmdMatch '^\s\{4\}\S\+\(\n\s\{5,\}\)\?' containedin=autocmdMatchLine nextgroup=autocmdVimScript contained
syn match autocmdVimScript '.*' contains=@vimSyntax contained 
"syn match autocmdVimScript '^\s\{5,\}.*' contains=@vimSyntax containedin=autocmdListBody contained 
syn include @vimSyntax $VIMRUNTIME/syntax/vim.vim

" Define the default highlighting.
" For version 5.x and earlier, only when not done already.
" For version 5.8 and later, only when an item doesn't have highlighting yet.
if version >= 508 || !exists("did_autocmd_cmd_syn_inits")
  if version < 508
    let did_autocmd_cmd_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink autocmdListTitle   Title 
  HiLink autocmdEvent       vimAutoEvent 
  HiLink autocmdGroupName   Identifier
  HiLink autocmdMatch       PreProc
  delcommand HiLink
endif
let b:current_syntax = "autocmd"
