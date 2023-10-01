local opts = {
  settings = {
    json = {
      -- https://github.com/b0o/SchemaStore.nvim/#usage
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}

return opts
