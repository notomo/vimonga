
function! vimonga#buffer#connections#model(params) abort
    let host = vimonga#config#get('default_host')
    let port = vimonga#config#get('default_port')
    return vimonga#model#connection#new(host, port)
endfunction
