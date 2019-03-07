
function! vimonga#repo#database#list() abort
    let pid = vimonga#request#pid_option()
    return vimonga#request#json(['database', pid, 'list'])
endfunction
