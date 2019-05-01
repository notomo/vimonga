
let s:suite = themis#suite('user')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call VimongaTestBeforeEach()
endfunction

function! s:suite.after_each()
    call VimongaTestAfterEach()
endfunction

function! s:suite.create()
    let id = vimonga#command#execute('user.new -db=other')
    call VimongaWait(id, s:assert)

    silent %delete _
    call setline(1, '{ "user": "new_user", "pwd": "password", "roles": [ {"role": "readWrite", "db": "other"} ] }')
    let id = vimonga#command#execute('user.create')
    call VimongaWait(id, s:assert)

    let decoded = json_decode(join(getbufline('%', 0, '$'), ''))
    call s:assert.equals(decoded[1]['user'], 'new_user')
endfunction

function! s:suite.drop()
    let id = vimonga#command#execute('user.list -db=other -coll=other')
    call VimongaWait(id, s:assert)

    let lines = join(getbufline('%', 0, '$'), '')
    let dropped_index = stridx(lines, 'dropped_user')
    call s:assert.not_equals(dropped_index, -1)

    let id = vimonga#command#execute('user.drop -db=other -user=dropped_user -force')
    call VimongaWait(id, s:assert)

    let lines = join(getbufline('%', 0, '$'), '')
    let dropped_index = stridx(lines, 'dropped_user')
    call s:assert.equals(dropped_index, -1)
endfunction
