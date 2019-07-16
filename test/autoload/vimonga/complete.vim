
let s:suite = themis#suite('complete')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call VimongaTestBeforeEach()
endfunction

function! s:suite.after_each()
    call VimongaTestAfterEach()
endfunction

function! s:suite.get()
    let result = vimonga#complete#get('', 'Vimonga ', 8)
    call s:assert.equals(v:shell_error, 0)
    call s:assert.false(empty(result))
endfunction

function! s:suite.get_from_other_host()
    call vimonga#config#set('default_host', 'localhost:27022')
    let result = vimonga#complete#get('-db=', 'Vimonga collection.list -db=', 28)
    call s:assert.equals(v:shell_error, 0)
    call s:assert.equals(result, "-db=admin\n-db=local\n")
endfunction
