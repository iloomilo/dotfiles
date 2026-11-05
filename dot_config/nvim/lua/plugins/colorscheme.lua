return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
    },
  },
  { "slugbyte/lackluster.nvim", enabled = false },
  { "folke/tokyonight.nvim", enabled = false },
  { "nvim-mini/mini.base16", enabled = false },
  { "Senal-D-A-Gunaratna/matugen.nvim", enabled = false },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "catppuccin"
    end,
  },
}
