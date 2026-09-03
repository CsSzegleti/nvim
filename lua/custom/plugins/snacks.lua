vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
  scratch = { enabled = true },
  image = { enabled = true },
}

local pickers = require 'telescope.pickers'
local conf = require('telescope.config').values
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local function scratch_open_telescope(opts)
  opts = opts or {}
  local scratch_files = Snacks.scratch.list()
  for _, item in ipairs(scratch_files) do
    local stat = vim.uv.fs_stat(item.file)
    -- Fallback to 0 if the file doesn't exist yet on disk
    item.mtime = stat and stat.mtime.sec or 0
  end

  table.sort(scratch_files, function(a, b) return a.mtime > b.mtime end)

  pickers
    .new(opts, {
      prompt_title = 'Scratch Files',
      finder = finders.new_table {
        results = scratch_files,
        entry_maker = function(entry)
          return {
            value = entry,
            display = Snacks.picker.util.text(entry, { 'name', 'branch', 'ft' }),
            ordinal = entry.name .. ' ' .. entry.ft .. ' ' .. entry.file,
            path = entry.file,
          }
        end,
      },
      previewer = conf.file_previewer(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            local item = selection.value
            Snacks.scratch.open {
              file = item.file,
              name = item.name,
              ft = item.ft,
              icon = item.icon,
            }
          end
        end)
        return true
      end,
    })
    :find()
end

vim.keymap.set('n', '<leader>.', function() Snacks.scratch() end, { desc = 'Toggle Scratch Buffer' })

vim.keymap.set('n', '<leader>S', function() scratch_open_telescope() end, { desc = 'Select Scratch Buffer' })
