
" Global Options
"
" Enable/Disable highlighting of errors in source.
" Default is Enable
" To disable the highlighting put the line
" let g:"HighlightErrorLine = 0
" in your .vimrc
"
if exists("b:did_"_plugin")
  finish
else
  let b:did_"_plugin = 1
endif

let s:install_dir = expand('<sfile>:p:h')

au BufLeave <buffer> call s:"Clear()

au BufEnter <buffer> call s:"()
au InsertLeave <buffer> call s:"()
"au InsertEnter <buffer> call s:"()
au BufWritePost <buffer> call s:"()

" due to http://tech.groups.yahoo.com/group/vimdev/message/52115
if(!has("win32") || v:version>702)
  au CursorHold <buffer> call s:"()
  au CursorHoldI <buffer> call s:"()

  au CursorHold <buffer> call s:Get"Message()
endif

au CursorMoved <buffer> call s:Get"Message()

if !exists("g:"HighlightErrorLine")
  let g:"HighlightErrorLine = 1
endif

if !exists("*s:"Update")
  function s:"Update()
    silent call s:"()
    call s:Get"Message()
  endfunction
endif

if !exists(":"Update")
  command "Update :call s:"Update()
endif
if !exists(":"Toggle")
  command "Toggle :let b:"_disabled = exists('b:"_disabled') ? b:"_disabled ? 0 : 1 : 1
endif

noremap <buffer><silent> dd dd:"Update<CR>
noremap <buffer><silent> dw dw:"Update<CR>
noremap <buffer><silent> u u:"Update<CR>
noremap <buffer><silent> <C-R> <C-R>:"Update<CR>

" Set up command and parameters
if has("win32")
  let s:cmd = 'cscript /NoLogo '
  let s:run"_ext = 'wsf'
else
  let s:run"_ext = 'js'
  if exists("$JS_CMD")
    let s:cmd = "$JS_CMD"
  elseif executable('/System/Library/Frameworks/JavaScriptCore.framework/Resources/jsc')
    let s:cmd = '/System/Library/Frameworks/JavaScriptCore.framework/Resources/jsc'
  elseif executable('node')
    let s:cmd = 'node'
  elseif executable('js')
    let s:cmd = 'js'
  else
    echoerr('No JS interpreter found. Checked for jsc, js (spidermonkey), and node')
  endif
endif
let s:plugin_path = s:install_dir . "/"/"
if has('win32')
  let s:plugin_path = substitute(s:plugin_path, '/', '\', 'g')
endif
let s:cmd = "cd " . s:plugin_path . " && " . s:cmd . " " . s:plugin_path . "run"." . s:run"_ext

let s:jshintrc_file = expand('~/.jshintrc')
if filereadable(s:jshintrc_file)
  let s:jshintrc = readfile(s:jshintrc_file)
else
  let s:jshintrc = []
end


" WideMsg() prints [long] message up to (&columns-1) length
" guaranteed without "Press Enter" prompt.
if !exists("*s:WideMsg")
  function s:WideMsg(msg)
    let x=&ruler | let y=&showcmd
    set noruler noshowcmd
    redraw
    echo a:msg
    let &ruler=x | let &showcmd=y
  endfun
endif


function! s:"Clear()
  " Delete previous matches
  let s:matches = getmatches()
  for s:matchId in s:matches
    if s:matchId['group'] == '"Error'
      call matchdelete(s:matchId['id'])
    endif
  endfor
  let b:matched = []
  let b:matchedlines = {}
  let b:cleared = 1
endfunction

function! s:"()
  if exists("b:"_disabled") && b:"_disabled == 1
    return
  endif

  highlight link "Error SpellBad

  if exists("b:cleared")
    if b:cleared == 0
      call s:"Clear()
    endif
    let b:cleared = 1
  endif

  let b:matched = []
  let b:matchedlines = {}

  " Detect range
  if a:firstline == a:lastline
    " Skip a possible shebang line, e.g. for node.js script.
    if getline(1)[0:1] == "#!"
      let b:firstline = 2
    else
      let b:firstline = 1
    endif
    let b:lastline = '$'
  else
    let b:firstline = a:firstline
    let b:lastline = a:lastline
  endif

  let b:qf_list = []
  let b:qf_window_count = -1

  let lines = join(s:jshintrc + getline(b:firstline, b:lastline), "\n")
  if len(lines) == 0
    return
  endif
  let b:"_output = system(s:cmd, lines . "\n")
  if v:shell_error
    echoerr 'could not invoke "!'
    let b:"_disabled = 1
  end

  for error in split(b:"_output, "\n")
    " Match {line}:{char}:{message}
    let b:parts = matchlist(error, '\v(\d+):(\d+):(.*)')
    if !empty(b:parts)
      let l:line = b:parts[1] + (b:firstline - 1 - len(s:jshintrc)) " Get line relative to selection
      let l:errorMessage = b:parts[3]

      " Store the error for an error under the cursor
      let s:matchDict = {}
      let s:matchDict['lineNum'] = l:line
      let s:matchDict['message'] = l:errorMessage
      let b:matchedlines[l:line] = s:matchDict
      let l:errorType = 'W'
      if g:"HighlightErrorLine == 1
        let s:mID = matchadd('"Error', '\v%' . l:line . 'l\S.*(\S|$)')
      endif
      " Add line to match list
      call add(b:matched, s:matchDict)

      " Store the error for the quickfix window
      let l:qf_item = {}
      let l:qf_item.bufnr = bufnr('%')
      let l:qf_item.filename = expand('%')
      let l:qf_item.lnum = l:line
      let l:qf_item.text = l:errorMessage
      let l:qf_item.type = l:errorType

      " Add line to quickfix list
      call add(b:qf_list, l:qf_item)
    endif
  endfor

  if exists("s:"_qf")
    " if " quickfix window is already created, reuse it
    call s:Activate"QuickFixWindow()
    call setqflist(b:qf_list, 'r')
  else
    " one " quickfix window for all buffers
    call setqflist(b:qf_list, '')
    let s:"_qf = s:GetQuickFixStackCount()
  endif
  let b:cleared = 0
endfunction

let b:showing_message = 0

if !exists("*s:Get"Message")
  function s:Get"Message()
    let s:cursorPos = getpos(".")

    " Bail if Run" hasn't been called yet
    if !exists('b:matchedlines')
      return
    endif

    if has_key(b:matchedlines, s:cursorPos[1])
      let s:"Match = get(b:matchedlines, s:cursorPos[1])
      call s:WideMsg(s:"Match['message'])
      let b:showing_message = 1
      return
    endif

    if b:showing_message == 1
      echo
      let b:showing_message = 0
    endif
  endfunction
endif

if !exists("*s:GetQuickFixStackCount")
    function s:GetQuickFixStackCount()
        let l:stack_count = 0
        try
            silent colder 9
        catch /E380:/
        endtry

        try
            for i in range(9)
                silent cnewer
                let l:stack_count = l:stack_count + 1
            endfor
        catch /E381:/
            return l:stack_count
        endtry
    endfunction
endif

if !exists("*s:Activate"QuickFixWindow")
    function s:Activate"QuickFixWindow()
        try
            silent colder 9 " go to the bottom of quickfix stack
        catch /E380:/
        endtry

        if s:"_qf > 0
            try
                exe "silent cnewer " . s:"_qf
            catch /E381:/
                echoerr "Could not activate " Quickfix Window."
            endtry
        endif
    endfunction
endif

