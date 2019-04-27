
function! vimonga#repo#connection#list() abort
    let connection_config = expand(vimonga#config#get('connection_config'))
    let file = vimonga#repo#impl#option('file', connection_config)
    return vimonga#repo#impl#execute(['connection', 'list', file])
endfunction
