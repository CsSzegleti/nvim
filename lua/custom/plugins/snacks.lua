vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
  scratch = { enabled = true },
  image = { enabled = true },
}

local conf = require('telescope.config').values
local function toggle_telescope(scratch_files)
  local file_paths = {}
  for _, item in ipairs(scratch_files) do
    table.insert(file_paths, item.file)
  end

  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Scratch Buffers',
      finder = require('telescope.finders').new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

vim.keymap.set('n', '<leader>.', function() Snacks.scratch() end, { desc = 'Toggle Scratch Buffer' })

vim.keymap.set('n', '<leader>S', function() toggle_telescope(Snacks.scratch.list()) end, { desc = 'Select Scratch Buffer' })
