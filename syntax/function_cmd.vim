"   Copyright (c) 2007, Michael Shvarts <shvarts@akmosoft.com>
" For version 5.x, clear all syntax items.
" For version 6.x, quit when a syntax file was already loaded.
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif
if b:0
    try
        %s/^\d\+//
        %s/^\s*function\s\+<SNR>\d\+_/function s:/
    catch /^Vim\%((\a\+)\)\=:E/
    endtry
    silent set ft=vim
    silent normal G=gg 
    finish
else
    syn match func '^fu\%[nction]\>'
    syn match funcSpecialChar '<[^<>]\{2,\}>'
    syn region funcDef start='[[:alnum:]_#]\+(' end=')' keepend contains=funcPrefix,funcName,funcArgs 
    syn region funcArgs start="(" end=")"he=e-1 contained contains=funcArg,funcOper
    syn match funcOper '[(),]'
    syn match funcArg '\w\+' contained
    syn match funcArg '\.\.\.' contained
    syn match funcPrefix '\<\d\+_' contained nextgroup=funcName
    syn match funcName '\a[[:alnum:]_#]*\>' contained 
endif
" Define the default highlighting.
" For version 5.x and earlier, only when not done already.
" For version 5.8 and later, only when an item doesn't have highlighting yet.
if version >= 508 || !exists("did_function_cmd_syn_inits")
    if version < 508
        let did_function_cmd_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif
    HiLink func Keyword
    HiLink funcArg Type
    HiLink funcOper Keyword
    HiLink funcPrefix Special
    HiLink funcName Identifier
    HiLink funcSpecialChar Macro 
    delcommand HiLink
endif
let b:current_syntax = "menu"
