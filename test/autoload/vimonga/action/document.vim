
let s:suite = themis#suite('document')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call VimongaTestBeforeEach()
endfunction

function! s:suite.after_each()
    call VimongaTestAfterEach()
endfunction

function! s:suite.one()
    let id = vimonga#command#execute('document.one -db=example -coll=tests1 -id=5ca3f45b1edab35868df1e0e')
    call VimongaWait(id, 100, s:assert)

    let decoded = json_decode(join(getbufline('%', 0, '$'), ''))
    call s:assert.equals(decoded['_id']['$oid'], '5ca3f45b1edab35868df1e0e')
endfunction
