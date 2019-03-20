if exists('g:loaded_vimonga')
    finish
endif
let g:loaded_vimonga = 1

command! -nargs=+ -complete=custom,vimonga#complete#get Vimonga call vimonga#command#execute(<q-args>)
