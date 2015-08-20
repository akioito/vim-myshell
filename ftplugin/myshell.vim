" File: myshell.vim
" Author: Akio Ito

"-----------------------------------------------------------------------------
if exists("loaded_myshell")
  finish
endif
let loaded_myshell = 1
if !(has('python'))
  echo "Error: Required vim compiled with +python"
  finish
endif   
command! -nargs=1 Py py <args>

"-----------------------------------------------------------------------------
function! s:GetParagraph()
  let save_cursor = getpos(".")
  let a_save = @a
  normal! {V}"ay/<esc>
  let xparagraph = @a
  let @a = a_save
  call setpos('.', save_cursor)
  return xparagraph
endfunction

function! s:SearchHostCmd()
  let save_cursor = getpos(".")
  execute "normal! ?^hostcmd:\<cr>"
  let xline = getline('.')
  call setpos('.', save_cursor)
  return xline
endfunction

"-----------------------------------------------------------------------------
function! s:MyShell()

Py << EOF
import vim

#------------------------------------------------
def getHostArg(hostcmd):
  hosts = hostcmd.split('hostcmd:')[1]
  if ',' in hosts:
    hosts = hosts.split(',')
  else:
    hosts = [hosts]
  hosts = [x.strip() for x in hosts]
  print hosts
  return hosts

paragraph = vim.eval('s:GetParagraph()')
hostcmd   = vim.eval('s:SearchHostCmd()')
vim.command('redraw!')
print('hostcmd=%s' % hostcmd)
x = getHostArg(hostcmd)
# Todo: local and remote hosts...
xcmd = 'QuickRun sh -src "%s"' % paragraph
# print xcmd
vim.command(xcmd) 

print(' ')
EOF
endfunction

command! MyShell call s:MyShell()

autocmd BufLeave,FocusLost * echo ' '

setlocal commentstring=#\ %s 
" setlocal cmdheight=3
setlocal splitright

