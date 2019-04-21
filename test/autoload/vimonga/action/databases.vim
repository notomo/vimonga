
let s:suite = themis#suite('databases')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call VimongaTestBeforeEach()
endfunction

function! s:suite.after_each()
    call VimongaTestAfterEach()
endfunction

function! s:suite.drop()
    let id = vimonga#command#execute('database.list')
    call VimongaWait(id, s:assert)

    let lines = getbufline('%', 0, '$')
    call s:assert.equals(lines, ['admin', 'dropped', 'example', 'local'])

    let id = vimonga#command#execute('database.drop -db=dropped -force')
    call VimongaWait(id, s:assert)

    let lines = getbufline('%', 0, '$')
    call s:assert.equals(lines, ['admin', 'example', 'local'])
endfunction

function! s:suite.list()
    let id = vimonga#command#execute('database.list')
    call VimongaWait(id, s:assert)

    let lines = getbufline('%', 0, '$')
    call s:assert.equals(lines, ['admin', 'example', 'local'])
endfunction
