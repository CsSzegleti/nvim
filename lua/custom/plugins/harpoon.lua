vim.pack.add { { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' } }
vim.pack.add { { src = 'https://github.com/nvim-lua/plenary.nvim' } }

local harpoon = require 'harpoon'
harpoon:setup {}

local function toggle_snacks_picker(harpoon_files)
  Snacks.picker {
    title = 'Harpoon',
    -- A finder function allows the picker to regenerate the list when you delete an item
    finder = function()
      local items = {}
      for i, item in ipairs(harpoon_files.items) do
        table.insert(items, {
          idx = i,
          file = item.value,
          text = item.value,
        })
      end
      return items
    end,
    format = 'file',
    actions = {
      harpoon_delete = function(picker, item)
        if not item then return end
        table.remove(harpoon_files.items, item.idx)
        -- Refresh the picker after removing the item
        picker:find()
      end,
    },
    win = {
      input = {
        keys = {
          ['<c-d>'] = { 'harpoon_delete', mode = { 'i', 'n' } },
          ['dd'] = { 'harpoon_delete', mode = { 'n' } },
        },
      },
      list = {
        keys = {
          ['<c-d>'] = { 'harpoon_delete', mode = { 'i', 'n' } },
          ['dd'] = { 'harpoon_delete', mode = { 'n' } },
        },
      },
    },
  }
end

vim.keymap.set('n', '<leader>H', function() harpoon:list():add() end)
vim.keymap.set('n', '<leader>h', function() toggle_snacks_picker(harpoon:list()) end, { desc = 'Open harpoon window' })

for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, function() harpoon:list():select(i) end, { desc = 'Harpoon to File ' .. i })
end
