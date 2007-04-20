if exists("b:did_ftplugin")                                                                                                                                                                                    
    finish                                                                                                                                                                                                       
endif                                                                                                                                                                                                          
let b:scriptnames = ScriptList()
" Don't load another plugin for this buffer                                                                                                                                                                    
let b:did_ftplugin = 1                                                                                                                                                                                         

let cpo_save = &cpo                                                                                                                                                                                            
set cpo-=C      

if !b:0
    map <buffer> <2-LeftMouse> :GoToFunctionCmd<CR>
    map <buffer> <CR> :GoToFunctionCmd<CR>
endif

let &cpo = cpo_save
