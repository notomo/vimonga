
let s:suite = themis#suite('projection')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call VimongaTestBeforeEach()
endfunction

function! s:suite.after_each()
    call VimongaTestAfterEach()
endfunction

function! s:suite.hide()
    let id = vimonga#command#execute('document.find -db=example -coll=tests2')
    call VimongaWait(id, s:assert)

    call search('num')
    let id = vimonga#command#execute('document.projection.hide')
    call VimongaWait(id, s:assert)

    let decoded = json_decode(join(getbufline('%', 0, '$'), ''))
    call s:assert.equals(v:false, has_key(decoded[0], 'num'))
endfunction
