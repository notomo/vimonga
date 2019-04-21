
let s:suite = themis#suite('collections')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call VimongaTestBeforeEach()
endfunction

function! s:suite.after_each()
    call VimongaTestAfterEach()
endfunction

function! s:suite.drop()
    let id = vimonga#command#execute('collection.list -db=example')
    call VimongaWait(id, s:assert)

    let lines = getbufline('%', 0, '$')
    let dropped_index = index(lines, 'dropped')
    call s:assert.not_equals(dropped_index, -1)

    let id = vimonga#command#execute('collection.drop -db=example -coll=dropped -force')
    call VimongaWait(id, s:assert)

    let lines = getbufline('%', 0, '$')
    let dropped_index = index(lines, 'dropped')
    call s:assert.equals(dropped_index, -1)
endfunction

function! s:suite.list()
    let id = vimonga#command#execute('collection.list -db=example')
    call VimongaWait(id, s:assert)

    let lines = getbufline('%', 0, '$')
    call s:assert.equals(lines, ['empty', 'tests1', 'tests2'])
endfunction

function! s:suite.create()
    let id = vimonga#command#execute('collection.list -db=example')
    call VimongaWait(id, s:assert)

    let lines = getbufline('%', 0, '$')
    let created_index = index(lines, 'created')
    call s:assert.equals(created_index, -1)

    let id = vimonga#command#execute('collection.create -db=example -coll=created')
    call VimongaWait(id, s:assert)

    let lines = getbufline('%', 0, '$')
    let created_index = index(lines, 'created')
    call s:assert.not_equals(created_index, -1)
endfunction
