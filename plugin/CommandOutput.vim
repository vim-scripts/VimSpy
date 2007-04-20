"   Copyright (c) 2007, Michael Shvarts <shvarts@akmosoft.com>
function! CommandOutput(cmd,...)
    redir => output
    silent exec a:cmd.' '.join(a:000,' ')
    redir END
    return output

endf
function! s:CommandOutputToBuffer(cmd,...)
    let output = call('CommandOutput',[a:cmd] + a:000)
    if a:cmd =~ '^sy\%[ntax]\>'
        let cmd = 'syntax'
        let hi = CommandOutput('hi')
    elseif a:cmd =~ '^hi\%[ghlight]\>'
        let cmd = 'highlight'
        let hi = output
    elseif a:cmd =~ '^au\%[togroup]'
        let cmd = 'autocmd'
    else
        let cmd = a:cmd
        
    endif
    exec 'new '.cmd.(a:0? '\ '.a:1 : '')
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal noswapfile
    setlocal modifiable
    let clip = @"
    let @" = output
    normal Pgg
    if getline(1) =~ '^\s*$'
        normal dd
    endif
    let @"=clip
    if exists('hi')
        let b:hi = hi
    endif
    let b:cmd = cmd
    let b:args = copy(a:000)
    let b:[0] = a:0
    let cmd = substitute(cmd, '^[aivnoscx]\(nore\)\?me\%[nu\]', 'menu', '')
    let cmd = substitute(cmd, '^[aivnoscxl]map', 'map', '')
    let cmd = substitute(cmd, '^\(\(no\|nno\?\|vno\?\|xno\?\|ono\|no\|ino\|lno\?\|cno\)\%[remap\]\|snor\%[emap\]\)', 'map', '')
    echomsg 'cmd: '.cmd
    let &ft=cmd.'_cmd'
    setlocal nomodifiable
endf
function! ParseHi(hi)
    return filter(map(split(a:hi,'\n'), 'matchlist(v:val, ''\(^\w\+\)\s\+xxx\s\+\(cleared\)\?\(links to \)\?\(.*\)'')'), 'len(v:val) && v:val[2] == ""') 
endf
function! ApplyHi(hi)
    let hi = ParseHi(a:hi)
    execute join(map(copy(hi), '"hi ".(v:val[3] !=""?"link ":"").v:val[1]." ".v:val[4]'),"\n")
    execute join(map(copy(hi), "'syn match '.v:val[1].' contained ''\\<xxx\\>'' |  syn region '.v:val[1].'_region start=''^'.v:val[1].'\\s\\+'' end=''\\<xxx\\>'' contains='.v:val[1].' keepend'"),"\n")
endf
function! ScriptList()
    return eval('{'.join(map(map(split(CommandOutput('scriptnames'), '\n'), 'matchlist(v:val, ''^\s*\(\d\+\):\s*\(.*\)'')[1:2]'), 'v:val[0].'':''.string(v:val[1])'), ',').'}')
endf
let s:funcPrefixRe = '\%(<SNR>\(\d\+\)_\|\([abglstvw]:\)\?\<\)'
function! Line2File(line)
    return substitute(substitute(get(b:scriptnames,matchstr(a:line,'\(<SNR>\)\@<=\d\+'),'unknown'),escape($VIMRUNTIME,'\'),'$VIMRUNTIME',''),escape($VIM,'\'),'$VIM','')
endf
function! GetFuncAtPos(line, col)
    return matchstr(getline(a:line), '\%(.*\%'.a:col.'c\)\@=\('.s:funcPrefixRe.'\w\+\%(\s*(\)\?\)\(\%'.a:col.'c.*\)\@<=')
endf
function! OpenFunc(...)
    for name in a:000
        let name = substitute(name, '^\('.s:funcPrefixRe.'\w\+\>\).*', '\1', '')
        if name =~ '^s:'
            let name = matchstr(CommandOutput('function'), s:funcPrefixRe.substitute(name, '^s:', '', '')) 
            if name == ''
                return
            endif
        endif
        silent call s:CommandOutputToBuffer('function', name)
    endfor
    if !a:0
        silent CommandOutput function
    endif
endf
function! GotoFunction(line, col)
    let name = GetFuncAtPos(a:line, a:col)
    if name == ''
        return
    endif
    if name =~ '($'
        if name =~ '^\(\u\|\w:\|<\)'
            call OpenFunc(name)
        else
            exec 'help '.name
        endif
        return
    endif
    let id = synID(a:line, a:col, 0)
   if synIDtrans(id) == hlID('Statement') || id == hlID('vimAutoEvent')
       exec 'help '.name
   endif
endf
command! GoToFunction  call GotoFunction(line('.'), col('.'))

command! -nargs=* -complete=command     CommandOutput silent call s:CommandOutputToBuffer(<f-args>)
command! -nargs=* -complete=highlight   Syntax      CommandOutput syntax <args>
command! -nargs=* -complete=highlight   Highlight   CommandOutput hi <args>
command! -nargs=* -complete=function    Function    call OpenFunc(<f-args>)
command! -nargs=* -complete=command     Command     CommandOutput command <args>
command! -nargs=* -complete=augroup     Autocmd     CommandOutput autocmd <args>
command!                                Changes     CommandOutput changes <args>
command!                                Messages    CommandOutput messages <args>

for char in extend(split('aivnoscxl', '.\@='), [''])
    exec 'command! -nargs=* -complete=menu         '.toupper(char).'Menu        CommandOutput '.char.'menu <args>'
    exec 'command! -nargs=* -complete=mapping          '.toupper(char).'Map        CommandOutput '.char.'map <args>'
    exec 'command! -nargs=* -complete=menu     '.toupper(char).'NoreMenu        CommandOutput '.char.'noremenu <args>'
    exec 'command! -nargs=* -complete=mapping      '.toupper(char).'NoreMap        CommandOutput '.char.'noremap <args>'
endfor
delcommand LMenu
delcommand LNoreMenu

