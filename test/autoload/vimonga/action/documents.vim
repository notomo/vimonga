
let s:suite = themis#suite('documents')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call VimongaTestBeforeEach()
endfunction

function! s:suite.after_each()
    call VimongaTestAfterEach()
endfunction

function! s:suite.find_but_empty()
    let id = vimonga#command#execute('document.find -db=example -coll=empty')
    call VimongaWait(id, s:assert)

    let lines = getbufline('%', 0, '$')
    call s:assert.equals(lines, ['[]'])
endfunction
