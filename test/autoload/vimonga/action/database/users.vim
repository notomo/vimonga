
let s:suite = themis#suite('users')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call VimongaTestBeforeEach()
endfunction

function! s:suite.after_each()
    call VimongaTestAfterEach()
endfunction

function! s:suite.list_but_empty()
    let id = vimonga#command#execute('user.list -db=example')
    call VimongaWait(id, 100, s:assert)

    let lines = getbufline('%', 0, '$')
    call s:assert.equals(lines, ['[]'])
endfunction
