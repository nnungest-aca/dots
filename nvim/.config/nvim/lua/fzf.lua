vim.g.fzf_action = {
  ['ctrl-t'] = 'tab split',
  ['ctrl-x'] = 'split',
  ['ctrl-v'] = 'vsplit'
}

-- Enable per-command history.
-- CTRL-N and CTRL-P will be automatically bound to next-history and
-- previous-history instead of down and up. If you don't like the change,
-- explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
-- vim.g.fzf_history_dir = '~/.local/share/fzf-history'

-- vim.g.fzf_tags_command = 'ctags -R'
-- Border color
-- vim.g.fzf_layout = { up='~90%', window={ width=0.8, height=0.8, yoffset=0.5, xoffset=0.5, highlight='Todo', border='sharp' } }

-- vim.env.FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'
-- vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden"

-- Customize fzf colors to match your color scheme
vim.g.fzf_colors = {
  fg = {'fg', 'Normal'},
  bg = {'bg', 'Normal'},
  hl = {'fg', 'Comment'},
  ['fg+'] = {'fg', 'CursorLine', 'CursorColumn', 'Normal'},
  ['bg+'] = {'bg', 'CursorLine', 'CursorColumn'},
  ['hl+'] = {'fg', 'Statement'},
  info = {'fg', 'PreProc'},
  border = {'fg', 'Ignore'},
  prompt = {'fg', 'Conditional'},
  pointer = {'fg', 'Exception'},
  marker = {'fg', 'Keyword'},
  spinner = {'fg', 'Label'},
  header = {'fg', 'Comment'}
}

-- Get Files
-- vim.cmd [[ command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0) ]]

-- Get text in files with Rg
-- vim.cmd [[ command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0) ]]
--
-- vim.cmd [[ command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0) ]]
--
-- -- Git grep
-- vim.cmd [[ command! -bang -nargs=* GGrep call fzf#vim#grep('git grep --line-number ' .. vim.fn.shellescape(<q-args>), 0, fzf#vim#with_preview({'dir': vim.fn.systemlist('git rev-parse --show-toplevel')[1]}), <bang>0) ]]
--

