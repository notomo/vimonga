doautocmd User VimongaSourceLoad

let s:actions = {
    \ 'connection.list': { params -> vimonga#action#connections#list(params) },
    \ 'database.list': { params -> vimonga#action#databases#list(params) },
    \ 'database.drop': { params -> vimonga#action#databases#drop(params) },
    \ 'user.list': { params -> vimonga#action#users#list(params) },
    \ 'user.create': { params -> vimonga#action#user#create(params) },
    \ 'user.new': { params -> vimonga#action#user#new(params) },
    \ 'user.drop': { params -> vimonga#action#user#drop(params) },
    \ 'collection.list': { params -> vimonga#action#collections#list(params) },
    \ 'collection.create': { params -> vimonga#action#collections#create(params) },
    \ 'collection.drop': { params -> vimonga#action#collections#drop(params) },
    \ 'index.list': { params -> vimonga#action#indexes#list(params) },
    \ 'index.create': { params -> vimonga#action#index#create(params) },
    \ 'index.new': { params -> vimonga#action#index#new(params) },
    \ 'index.drop': { params -> vimonga#action#index#drop(params) },
    \ 'document.find': { params -> vimonga#action#documents#find(params, {}) },
    \ 'document.next': { params -> vimonga#action#documents#scroll_next(params, v:false) },
    \ 'document.next_wrap': { params -> vimonga#action#documents#scroll_next(params, v:true) },
    \ 'document.prev': { params -> vimonga#action#documents#scroll_prev(params, v:false) },
    \ 'document.prev_wrap': { params -> vimonga#action#documents#scroll_prev(params, v:true) },
    \ 'document.page.next': { params -> vimonga#action#documents#next(params) },
    \ 'document.page.first': { params -> vimonga#action#documents#first(params) },
    \ 'document.page.prev': { params -> vimonga#action#documents#prev(params) },
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
function! vimonga#command#execute(arg_string) range abort
    let [args, params] = vimonga#command#parse(a:arg_string, a:firstline, a:lastline)

    if empty(args)
        return vimonga#message#error(['no arguments'])
    endif

    let action_name = args[0]
    if has_key(s:actions, action_name)
        return s:actions[action_name](params)
    endif

    call vimonga#message#error(['invalid argument: ' . a:arg_string])
endfunction

let s:params = {
    \ 'db': [],
    \ 'user': '',
    \ 'coll': [],
    \ 'index': '',
    \ 'id': '',
    \ 'host': '',
    \ 'open': '',
    \ 'width': v:null,
    \ 'force': v:false,
\ }
function! vimonga#command#parse(arg_string, first_line, last_line) abort
    let args = []
    let raw_params = deepcopy(s:params)
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
            if type(raw_params[key]) == v:t_list
                call add(raw_params[key], value)
            else
                let raw_params[key] = value
            endif
            continue
        endif

        call vimonga#message#warn(['invalid param: ' . factor])
    endfor

    let params = s:new_params(raw_params, a:first_line, a:last_line)
    return [args, params]
endfunction

function! s:new_params(params, first_line, last_line) abort
    let raw_open_cmd = a:params['open']
    let width = a:params['width']
    let params = {
        \ 'database_names': a:params['db'],
        \ 'user_name': a:params['user'],
        \ 'collection_names': a:params['coll'],
        \ 'index_name': a:params['index'],
        \ 'document_id': a:params['id'],
        \ 'host': a:params['host'],
        \ 'open_cmd': vimonga#model#open_command#new(raw_open_cmd, width),
        \ 'force': a:params['force'],
        \ 'first_line': a:first_line,
        \ 'last_line': a:last_line,
    \ }

    let params['has_db'] = !empty(params['database_names'])
    let params['has_user'] = !empty(params['user_name'])
    let params['has_coll'] = !empty(params['collection_names'])
    let params['has_index'] = !empty(params['index_name'])
    let params['has_id'] = !empty(params['document_id'])
    let params['has_host'] = !empty(params['host'])

    return params
endfunction
