" File: grepprg.vim
" Description: grepprg source for far.vim
" Author: Oleg Khalidov <brooth@gmail.com>
" License: MIT


function! far#sources#grepprg#search(ctx) abort "{{{
    call a:ctx.logger('grepprg#search('.a:ctx.pattern.','.a:ctx.file_mask.')')

    try
        let cmd = 'silent! grep! '.escape(a:ctx.pattern, ' ').' '.a:ctx.file_mask
        call a:ctx.logger('grepprg cmd: '.cmd)
        silent! exec cmd
    catch /.*/
        call a:ctx.logger('grepprg error:'.v:exception)
    endtry

    let items = getqflist()
    if empty(items)
        return {}
    endif

    let result = {}
    for item in items
        if get(item, 'bufnr') == 0
            call a:ctx.logger('item '.item.text.' has no bufnr')
            continue
        endif

        let file_ctx = get(result, item.bufnr, {})
        if empty(file_ctx)
            let file_ctx.fname = bufname(item.bufnr)
            let file_ctx.items = []
            let result[item.bufnr] = file_ctx
        endif

        let item_ctx = {}
        let item_ctx.lnum = item.lnum
        let item_ctx.cnum = item.col
        let item_ctx.text = item.text
        call add(file_ctx.items, item_ctx)
    endfor
    return values(result)
endfunction "}}}