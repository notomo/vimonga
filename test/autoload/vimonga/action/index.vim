
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
    call s:assert.equals('new_index_1', decoded[1]['name'])
endfunction
