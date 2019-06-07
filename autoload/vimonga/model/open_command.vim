
let s:commands = {
    \ '': 'edit',
    \ 'nosplit': 'edit',
    \ 'horizontal': 'split',
    \ 'vertical': 'vsplit',
    \ 'tab': 'tabedit',
\ }

function! vimonga#model#open_command#new(type, width) abort
    let command = get(s:commands, a:type, 'edit')
    let open_command = {
        \ 'command': command,
        \ 'width': a:width,
    \ }

    function! open_command.execute(path) abort
        execute printf('%s %s', self.command, a:path)
        if self.width != v:null
            call nvim_win_set_width(win_getid(), str2nr(self.width))
        endif
    endfunction

    return open_command
endfunction
