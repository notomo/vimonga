
let s:actions = {
    \ 'database.list': { params -> vimonga#action#databases#list(params) },
    \ 'database.drop': { params -> vimonga#action#databases#drop(params) },
    \ 'user.list': { params -> vimonga#action#database#users#list(params) },
    \ 'user.create': { params -> vimonga#action#database#user#create(params) },
    \ 'user.new': { params -> vimonga#action#database#user#new(params) },
    \ 'user.drop': { params -> vimonga#action#database#user#drop(params) },
    \ 'collection.list': { params -> vimonga#action#collections#list(params) },
    \ 'collection.create': { params -> vimonga#action#collections#create(params) },
    \ 'collection.drop': { params -> vimonga#action#collections#drop(params) },
    \ 'index.list': { params -> vimonga#action#collection#indexes#list(params) },
    \ 'index.create': { params -> vimonga#action#collection#index#create(params) },
    \ 'index.new': { params -> vimonga#action#collection#index#new(params) },
    \ 'index.drop': { params -> vimonga#action#collection#index#drop(params) },
    \ 'document.find': { params -> vimonga#action#documents#find(params, {}) },
    \ 'document.page.next': { params -> vimonga#action#documents#move_page(params, 1) },
    \ 'document.page.first': { params -> vimonga#action#documents#first(params) },
    \ 'document.page.prev': { params -> vimonga#action#documents#move_page(params, -1) },
    \ 'document.page.last': { params -> vimonga#action#documents#last(params) },
    \ 'document.sort.ascending': { params -> vimonga#action#documents#sort#do(params, 1) },
    \ 'document.sort.descending': { params -> vimonga#action#documents#sort#do(params, -1) },
    \ 'document.sort.toggle': { params -> vimonga#action#documents#sort#toggle(params) },
    \ 'document.sort.reset': { params -> vimonga#action#documents#sort#do(params, 0) },
    \ 'document.sort.reset_all': { params -> vimonga#action#documents#sort#reset_all(params) },
    \ 'document.projection.hide': { params -> vimonga#action#documents#projection#hide(params) },
    \ 'document.projection.reset_all': { params -> vimonga#action#documents#projection#reset_all(params) },
    \ 'document.query.add': { params -> vimonga#action#documents#query#add(params) },
    \ 'document.query.find_by_oid': { params -> vimonga#action#documents#query#find_by_oid(params) },
    \ 'document.query.reset_all': { params -> vimonga#action#documents#query#reset_all(params) },
    \ 'document.one': { params -> vimonga#action#document#open(params) },
    \ 'document.one.insert': { params -> vimonga#action#document#insert(params) },
    \ 'document.one.delete': { params -> vimonga#action#document#delete(params) },
    \ 'document.one.update': { params -> vimonga#action#document#update(params) },
    \ 'document.new': { params -> vimonga#action#document#new(params) },
\ }
function! vimonga#command#execute(arg_string) abort
    let [args, params] = vimonga#command#parse(a:arg_string)

    if empty(args)
        echohl ErrorMsg | echo 'no arguments' | echohl None | return
    endif

    let action_name = args[0]
    if has_key(s:actions, action_name)
        return s:actions[action_name](params)
    endif

    echohl ErrorMsg | echo 'invalid argument: ' . a:arg_string | echohl None
endfunction

let s:params = {
    \ 'db': 'database name',
    \ 'user': 'user name',
    \ 'coll': 'collection name',
    \ 'index': 'index name',
    \ 'id': 'document id',
    \ 'host': 'host',
    \ 'port': 'port',
    \ 'open': 'command to open buffer',
    \ 'force': 'ignore confirmation',
\ }
function! vimonga#command#parse(arg_string) abort
    let args = []
    let raw_params = {}
    for factor in split(a:arg_string, '\v\s+')
        if factor[0] !=# '-'
            call add(args, factor)
            continue
        endif

        let key_value = split(factor[1:], '=', v:true)
        if len(key_value) == 1 && has_key(s:params, key_value[0])
            let [key] = key_value
            let raw_params[key] = v:true
            continue
        elseif len(key_value) == 2 && has_key(s:params, key_value[0])
            let [key, value] = key_value
            let raw_params[key] = value
            continue
        endif

        echohl WarningMsg | echo 'invalid param: ' . factor | echohl None
    endfor

    let params = s:new_params(raw_params)
    return [args, params]
endfunction

function! s:new_params(params) abort
    let params = {
        \ 'database_name': has_key(a:params, 'db') ? a:params['db'] : '',
        \ 'user_name': has_key(a:params, 'user') ? a:params['user'] : '',
        \ 'collection_name': has_key(a:params, 'coll') ? a:params['coll'] : '',
        \ 'index_name': has_key(a:params, 'index') ? a:params['index'] : '',
        \ 'document_id': has_key(a:params, 'id') ? a:params['id'] : '',
        \ 'host': has_key(a:params, 'host') ? a:params['host'] : '',
        \ 'port': has_key(a:params, 'port') ? a:params['port'] : '',
        \ 'open_cmd': has_key(a:params, 'open') ? a:params['open'] : 'edit',
        \ 'force': has_key(a:params, 'force') ? a:params['force'] : v:false,
    \ }

    let params['has_db'] = !empty(params['database_name'])
    let params['has_user'] = !empty(params['user_name'])
    let params['has_coll'] = !empty(params['collection_name'])
    let params['has_index'] = !empty(params['index_name'])
    let params['has_id'] = !empty(params['document_id'])
    let params['has_host'] = !empty(params['host'])
    let params['has_port'] = !empty(params['port'])

    return params
endfunction
