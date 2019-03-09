
function! vimonga#repo#database#list() abort
    return vimonga#request#json(['database', 'list'])
endfunction
