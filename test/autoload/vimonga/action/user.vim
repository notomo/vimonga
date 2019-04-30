
let s:suite = themis#suite('user')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call VimongaTestBeforeEach()
endfunction

function! s:suite.after_each()
    call VimongaTestAfterEach()
endfunction

function! s:suite.list_but_empty()
    let id = vimonga#command#execute('user.new -db=other')
    call VimongaWait(id, s:assert)

    silent %delete _
    call setline(1, '{ "user": "new_user", "pwd": "password", "roles": [ {"role": "readWrite", "db": "other"} ] }')
    let id = vimonga#command#execute('user.create')
    call VimongaWait(id, s:assert)

    let decoded = json_decode(join(getbufline('%', 0, '$'), ''))
    call s:assert.equals('new_user', decoded[0]['user'])
endfunction
