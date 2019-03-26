
let s:PARAM_TYPE_PASS = 'PASS'
let s:PARAM_TYPE_THROUGH_OK = 'THROUGH_OK'
let s:PARAM_TYPE_EXTEND_OK = 'EXTEND_OK'

function! vimonga#job#new() abort
    let dict = {'jobs': []}

    function! dict.map_ok(func) abort
        call add(self.jobs, s:map_ok(a:func, s:PARAM_TYPE_PASS))
        return self
    endfunction

    function! dict.map_extend_ok(func) abort
        call add(self.jobs, s:map_ok(a:func, s:PARAM_TYPE_EXTEND_OK))
        return self
    endfunction

    function! dict.map_through_ok(func) abort
        call add(self.jobs, s:map_ok(a:func, s:PARAM_TYPE_THROUGH_OK))
        return self
    endfunction

    function! dict.map_err(func) abort
        call add(self.jobs, s:map_err(a:func))
        return self
    endfunction

    function! dict.execute() abort
        let result = vimonga#job#ok([])
        call vimonga#job#execute(self.jobs, result)
    endfunction

    return dict
endfunction

function! s:map_ok(func, param_type) abort
    let dict = { 'func': a:func, 'param_type': a:param_type }

    function! dict.execute(result) abort
        if a:result.is_ok
            return call(self.func, a:result.ok)
        endif

        return a:result
    endfunction

    return dict
endfunction

function! s:map_err(func) abort
    let dict = { 'func': a:func, 'param_type': s:PARAM_TYPE_PASS }

    function! dict.execute(result) abort
        if a:result.is_err
            return call(self.func, a:result.err)
        endif

        return a:result
    endfunction

    return dict
endfunction

function! s:default_result() abort
    return {
        \ 'is_ok': v:false,
        \ 'is_pending': v:false,
        \ 'is_err': v:false,
        \ 'ok': [[]],
        \ 'cmd': '',
        \ 'options': {},
        \ 'err': [[]],
    \ }
endfunction

function! vimonga#job#ok(ok) abort
    let result = s:default_result()
    let result.is_ok = v:true
    let result.ok = [a:ok]
    return result
endfunction

function! vimonga#job#err(err) abort
    let result = s:default_result()
    let result.is_err = v:true
    let result.err = [a:err]
    return result
endfunction

function! vimonga#job#pending(cmd, options) abort
    let result = s:default_result()
    let result.is_pending = v:true
    let result.cmd = a:cmd
    let result.options = a:options
    return result
endfunction

function! vimonga#job#execute(jobs, result) abort
    let result = a:result
    for index in range(len(a:jobs))
        let job = a:jobs[index]
        let old_ok = result.ok
        let result = job.execute(result)
        if job.param_type ==? s:PARAM_TYPE_EXTEND_OK && result.is_ok
            let result.ok = extend(old_ok, result.ok)
        elseif job.param_type ==? s:PARAM_TYPE_THROUGH_OK && result.is_ok
            let result.ok = old_ok
        endif

        if !result.is_pending
            continue
        endif

        let rest_jobs = a:jobs[index+1:]
        let options = {
            \ 'on_stdout': function('s:handle_stdout'),
            \ 'on_stderr': function('s:handle_stderr'),
            \ 'on_exit': function('s:handle_exit'),
            \ 'jobs': rest_jobs,
            \ 'ok': [],
            \ 'handle_ok': { _, v -> v },
            \ 'is_extend': job.param_type ==? s:PARAM_TYPE_EXTEND_OK,
            \ 'is_ok_through': job.param_type ==? s:PARAM_TYPE_THROUGH_OK,
            \ 'old_ok': old_ok,
            \ 'err': [],
            \ 'is_err': v:false,
        \ }
        if has_key(result.options, 'handle_ok')
            let options.handle_ok = result.options.handle_ok
        endif
        call jobstart(result.cmd, options)
        break
    endfor
endfunction

function! s:handle_stdout(job_id, data, event) abort dict
    let valid_data = filter(a:data, { _, v -> !empty(v) })
    call extend(self.ok, valid_data)
endfunction

function! s:handle_stderr(job_id, data, event) abort dict
    let valid_data = filter(a:data, { _, v -> !empty(v) })
    if len(valid_data) == 0
        return
    endif
    call extend(self.err, valid_data)
    let self.is_err = v:true
endfunction

function! s:handle_exit(job_id, data, event) abort dict
    if self.is_err
        let result = vimonga#job#err(self.err)
    else
        let ok = self.handle_ok(join(self.ok, ''))
        let result = vimonga#job#ok(ok)
        if self.is_extend
            let result.ok = extend(self.old_ok, result.ok)
        elseif self.is_ok_through
            let result.ok = self.old_ok
        endif
    endif

    call vimonga#job#execute(self.jobs, result)
endfunction
