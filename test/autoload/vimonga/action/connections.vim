
let s:suite = themis#suite('connections')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call VimongaTestBeforeEach()
endfunction

function! s:suite.after_each()
    call VimongaTestAfterEach()
endfunction

function! s:suite.list()
    call vimonga#config#set('connection_config', './test/_test_data/connection.json')

    let id = vimonga#command#execute('connection.list')
    call VimongaWait(id, s:assert)

    let lines = getbufline('%', 0, '$')
    call s:assert.equals(lines, ['localhost:27020', 'localhost:27021'])
endfunction
