vim.pack.add {
  'https://github.com/AlexandrosAlexiou/intellij-server.nvim',
}

require('intellij-server').setup {
  jvm_args = { '-Xmx8g' },
  autostart = true,
  connection = {
    port = 9191,
  },
}
