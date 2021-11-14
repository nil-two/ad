let b:app = {}

function! b:app.init() abort
  let self.cwd               = getcwd()
  let self.show_hidden_files = 0
  let self.save_file         = getenv('SAVE_FILE')
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nowrap
  nnoremap <buffer><silent> +     :<C-u>call b:app.toggle_show_hidden()<CR>
  nnoremap <buffer><silent> -     :<C-u>call b:app.up_directory()<CR>
  nnoremap <buffer><silent> <CR>  :<C-u>call b:app.move_directory()<CR>
  nnoremap <buffer><silent> <C-g> :<C-u>call b:app.save_directory_and_exit()<CR>
  nnoremap <buffer><silent> q     :<C-u>call b:app.exit()<CR>
  call self.update_screen()
endfunction

function! b:app.update_screen() abort
  let files = s:readdir_with_indicator(self.cwd, self.show_hidden_files)
  let lines = [self.cwd, ''] + files
  execute '%delete'
  call setline(1, lines)
  call cursor(3, 1)
endfunction

function! b:app.toggle_show_hidden() abort
  let self.show_hidden_files = !self.show_hidden_files
  call self.update_screen()
endfunction

function! b:app.up_directory() abort
  let self.cwd = fnamemodify(self.cwd, ':h')
  call self.update_screen()
endfunction

function! b:app.move_directory() abort
  let file = substitute(getline('.'), '/$', '', '')
  let path = fnamemodify((self.cwd ==# '/' ? '/' : self.cwd . '/') . file, ':p:h')
  if isdirectory(path)
    let self.cwd = path
    call self.update_screen()
  endif
endfunction

function! b:app.save_directory_and_exit() abort
  if filewritable(self.save_file)
    call writefile([self.cwd], self.save_file)
  endif
  exit
endfunction

function! b:app.exit() abort
  exit
endfunction

function! s:compare_files_with_indicator(lhs, rhs)
  if a:lhs[-1:] ==# '/' && a:rhs[-1:] !=# '/'
    return -1
  elseif a:lhs[-1:] !=# '/' && a:rhs[-1:] ==# '/'
    return 1
  endif
  if a:lhs < a:rhs
    return -1
  elseif a:lhs > a:rhs
    return 1
  endif
  return 0
endfunction

function! s:readdir_with_indicator(path, show_hidden_files) abort
  let files = readdir(a:path, 1)
  if !a:show_hidden_files
    let files = filter(files, {_, file -> file !~# '^\.'})
  endif
  let files = map(files, {_, file -> isdirectory(a:path . '/' . file) ? file . '/' : file})
  let files = sort(files, function('s:compare_files_with_indicator'))
  return files
endfunction

call b:app.init()
