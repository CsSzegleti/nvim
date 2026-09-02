vim.pack.add {
  'https://github.com/AlexandrosAlexiou/intellij-server.nvim',
}

require('intellij-server').setup {
  autostart = true,
}
