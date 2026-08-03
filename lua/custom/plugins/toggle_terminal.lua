local terminal = {
  buffers = {},
  win = -1,
  active_buffer_idx = -1,
}

for _ = 1, 9 do
  table.insert(terminal.buffers, -1)
end

local function create_buffer_if_invalid(buf)
  if vim.api.nvim_buf_is_valid(buf) then
    return buf
  else
    return vim.api.nvim_create_buf(false, true)
  end
end

local function attach_buffer_to_window(win, buf)
  if not vim.api.nvim_win_is_valid(win) then
    return -1
  end
  vim.api.nvim_win_set_buf(win, buf)
  return win
end

local function enter_terminal_mode(buf)
  if vim.bo[buf].buftype ~= 'terminal' then
    vim.cmd.term()
  end
end

local function attach_bottom_terminal(opts)
  local buf = create_buffer_if_invalid(opts.buf)
  attach_buffer_to_window(opts.win, buf)
  enter_terminal_mode(buf)
  return buf, opts.win
end

local function create_bottom_terminal(opts)
  local buf = create_buffer_if_invalid(opts.buf)
  local term_config = {
    height = 15,
    split = 'below',
  }

  local term_win = vim.api.nvim_open_win(buf, true, term_config)
  enter_terminal_mode(buf)
  return buf, term_win
end

local M = {
  vim.api.nvim_create_user_command('ToggleTerminal', function(opts)
    local term_number = opts.args ~= '' and tonumber(opts.args) or 1
    local term_buffer = terminal.buffers[term_number]

    if terminal.active_buffer_idx == term_number then
      vim.api.nvim_win_hide(terminal.win)
      terminal.active_buffer_idx = -1
      return
    end

    if not vim.api.nvim_win_is_valid(terminal.win) then
      terminal.buffers[term_number], terminal.win = create_bottom_terminal { buf = term_buffer, win = terminal.win }
    else
      terminal.buffers[term_number], terminal.win = attach_bottom_terminal { buf = term_buffer, win = terminal.win }
    end
    terminal.active_buffer_idx = term_number
  end, { nargs = 1 }),

}

for i = 1, 9 do
  vim.keymap.set('n', '<leader>`' .. i, '<cmd>ToggleTerminal ' .. i .. '<CR>', { desc = 'Toggle terminal ' .. i })
end

return M
