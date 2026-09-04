vim.pack.add { { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' } }

local telescope_config = require 'telescope.config'
local harpoon = require 'harpoon'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'

harpoon:setup {}

local conf = telescope_config.values
local function toggle_telescope(harpoon_files)
  local finder = function()
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
      table.insert(file_paths, item.value)
    end
    return finders.new_table {
      results = file_paths,
    }
  end

  pickers
    .new({}, {
      prompt_title = 'Harpoon',
      finder = finder(),
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        local delete_entry = function()
          local state = require 'telescope.actions.state'
          local selected_entry = state.get_selected_entry()
          local current_picker = state.get_current_picker(prompt_bufnr)

          table.remove(harpoon_files.items, selected_entry.index)
          current_picker:refresh(finder())
        end
        map('i', '<C-d>', delete_entry)
        map('n', 'dd', delete_entry)
        return true
      end,
    })
    :find()
end

vim.keymap.set('n', '<leader>H', function() harpoon:list():add() end)
vim.keymap.set('n', '<leader>h', function() toggle_telescope(harpoon:list()) end, { desc = 'Open harpoon window' })

for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, function() harpoon:list():select(i) end, { desc = 'Harpoon to File' .. i })
end
