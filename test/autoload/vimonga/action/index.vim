
let s:suite = themis#suite('index')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call VimongaTestBeforeEach()
endfunction

function! s:suite.after_each()
    call VimongaTestAfterEach()
endfunction

function! s:suite.create()
    let id = vimonga#command#execute('index.new -db=other -coll=other')
    call VimongaWait(id, s:assert)

    silent %delete _
    call setline(1, '{ "new_index": 1 }')
    let id = vimonga#command#execute('index.create')
    call VimongaWait(id, s:assert)

    let decoded = json_decode(join(getbufline('%', 0, '$'), ''))
    call s:assert.equals(decoded[2]['name'], 'new_index_1')
endfunction

function! s:suite.drop()
    let id = vimonga#command#execute('index.list -db=other -coll=other')
    call VimongaWait(id, s:assert)

    let lines = join(getbufline('%', 0, '$'), '')
    let dropped_index = stridx(lines, 'dropped_index_1')
    call s:assert.not_equals(dropped_index, -1)

    let id = vimonga#command#execute('index.drop -db=other -coll=other -index=dropped_index_1 -force')
    call VimongaWait(id, s:assert)

    let lines = join(getbufline('%', 0, '$'), '')
    let dropped_index = stridx(lines, 'dropped_index_1')
    call s:assert.equals(dropped_index, -1)
endfunction
