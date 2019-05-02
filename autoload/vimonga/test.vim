
let s:is_running = v:false
function! vimonga#test#start() abort
    let s:is_running = v:true
endfunction

function! vimonga#test#is_running() abort
    return s:is_running
endfunction
