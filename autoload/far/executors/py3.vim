" File: autoload/far/executors/py.vim
" Description: Synchronous python executor
" Author: Oleg Khalidov <brooth@gmail.com>
" License: MIT

function! far#executors#py3#execute(exec_ctx, callback) abort "{{{
    let ctx = a:exec_ctx
    if empty(get(ctx.source, 'py', ''))
        let ctx['error'] = 'source dosn`t support python execution'
        call call(a:callback, [ctx])
        return
    endif

    let source = ctx.source.py
    let idx = strridx(source, '.')
    let evalstr = source."(".json_encode(a:exec_ctx.far_ctx).")"
    let result = far#rpc#invoke(['json', source[:idx-1]], evalstr)
    let error = get(result, 'error', '')
    if !empty(error)
        let ctx['error'] = 'source error:'.error
    else
        let ctx.far_ctx['items'] = result['items']
    endif
    call call(a:callback, [ctx])
endfunction "}}}

" vim: set et fdm=marker sts=4 sw=4: