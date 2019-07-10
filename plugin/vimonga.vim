if exists('g:loaded_vimonga')
    finish
endif
let g:loaded_vimonga = 1

command! -nargs=+ -range -complete=custom,vimonga#complete#get Vimonga <line1>,<line2>call vimonga#command#execute(<q-args>)
