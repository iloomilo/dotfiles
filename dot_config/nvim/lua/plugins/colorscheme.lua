return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function() end,
    },
  },
  { "folke/tokyonight.nvim", enabled = false },
  {
    "nvim-mini/mini.base16",
    enabled = false, -- testing matugen.nvim; flip back on to revert
    lazy = false,
    priority = 1000,
    config = function()
      local ok, palette = pcall(require, "config.colors")
      if not ok then
        return
      end

      require("mini.base16").setup({
        palette = palette,
        use_cterm = true,
      })

      local highlights = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "FloatBorder",
        "SignColumn",
        "LineNr",
        "CursorLineNr",
        "FoldColumn",
      }
      for _, hl in ipairs(highlights) do
        vim.api.nvim_set_hl(0, hl, { bg = "NONE" })
      end
    end,
  },
  {
    "Senal-D-A-Gunaratna/matugen.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      palette_path = "~/.cache/matugen/nvim-colors.json",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "auto"
    end,
  },
}
