-- https://github.com/mrjosh/helm-ls/issues/44
return {
  settings = {
    ['helm-ls'] = {
      yamlls = {
        path = 'yaml-language-server',
      },
    },
  },
}
