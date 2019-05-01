
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
    call VimongaWait(id, s:assert)

    let decoded = json_decode(join(getbufline('%', 0, '$'), ''))
    call s:assert.equals(decoded['_id']['$oid'], '5ca3f45b1edab35868df1e0e')
endfunction

function! s:suite.update()
    let id = vimonga#command#execute('document.one -db=example -coll=tests1 -id=7ca3f45b1edab35868df1e0e')
    call VimongaWait(id, s:assert)

    call setline(search('bar'), '"name": "updated"')
    let id = vimonga#command#execute('document.one.update')
    call VimongaWait(id, s:assert)

    let decoded = json_decode(join(getbufline('%', 0, '$'), ''))
    call s:assert.equals(decoded['name'], 'updated')
    call s:assert.equals(&modified, v:false)
endfunction

function! s:suite.insert()
    let id = vimonga#command#execute('document.new -db=example -coll=tests1')
    call VimongaWait(id, s:assert)

    call setline(2, '"name": "inserted"')
    let id = vimonga#command#execute('document.one.insert')
    call VimongaWait(id, s:assert)

    let decoded = json_decode(join(getbufline('%', 0, '$'), ''))
    call s:assert.equals(decoded['name'], 'inserted')
    call s:assert.equals(has_key(decoded, '_id'), v:true)
    call s:assert.equals(&modifiable, v:true)
endfunction

function! s:suite.delete()
    let id = vimonga#command#execute('document.one.delete -db=example -coll=tests1 -id=6ca3f45b1edab35868df1e0e -force')
    call VimongaWait(id, s:assert)

    call s:assert.equals(&buftype, 'nofile')
    call s:assert.equals(&modified, v:false)
    call s:assert.equals(&modifiable, v:false)
endfunction
