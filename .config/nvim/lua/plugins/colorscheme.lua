return {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    -- Lighten some grays. Start with dark4 (== #7c6f64 == rgb(124 111 100))
    -- and add 50 each to R, G, and B, yielding rgb(174, 161, 150) = #95887d
    local dark5 = '#95887d'
    local terminal_bg = '#0d0d0d' -- same as iTerm/alacritty profile
    local colors = require('gruvbox').palette
    require('gruvbox').setup({
      contrast = 'hard', -- background as dark as terminal
      invert_tabline = true,
      palette_overrides = {
        dark0_hard = terminal_bg,
      },
      overrides = {
        SpecialKey = { fg = dark5 },
        Whitespace = { fg = dark5 }, -- shown with "set list" (":help listchars"
        LineNr = { fg = dark5 },
        Comment = { fg = dark5 },
        Folded = { fg = dark5 },
        SignColumn = { bg = terminal_bg }, -- same as terminal background
        GruvboxRedSign = {
          fg = colors.bright_red,
          bg = terminal_bg,
          reverse = false,
        },
        GruvboxGreenSign = {
          fg = colors.bright_green,
          bg = terminal_bg,
          reverse = false,
        },
        GruvboxYellowSign = {
          fg = colors.bright_yellow,
          bg = terminal_bg,
          reverse = false,
        },
        GruvboxBlueSign = {
          fg = colors.bright_blue,
          bg = terminal_bg,
          reverse = false,
        },
        GruvboxPurpleSign = {
          fg = colors.bright_purple,
          bg = terminal_bg,
          reverse = false,
        },
        GruvboxAquaSign = {
          fg = colors.bright_aqua,
          bg = terminal_bg,
          reverse = false,
        },
        GruvboxOrangeSign = {
          fg = colors.bright_orange,
          bg = terminal_bg,
          reverse = false,
        },
      },
    })
  end,
  init = function()
    vim.o.background = 'dark' -- or "light" for dark mode
    vim.cmd.colorscheme('gruvbox')
  end,
}
