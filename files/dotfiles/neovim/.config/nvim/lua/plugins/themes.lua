return {
  -- Dark themes
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
  { "olimorris/onedarkpro.nvim", lazy = false, priority = 1000 },
  { "nyoom-engineering/oxocarbon.nvim", lazy = false, priority = 1000, build = false },
  -- {
  --   "zenbones-theme/zenbones.nvim",
  --   dependencies = "rktjmp/lush.nvim",
  --   lazy = false,
  --   priority = 1000,
  -- },
  { "craftzdog/solarized-osaka.nvim", lazy = false, priority = 1000 },
  { "shaunsingh/nord.nvim", lazy = false, priority = 1000 },
  { "EdenEast/nightfox.nvim", lazy = false, priority = 1000 },
  { "savq/melange-nvim", lazy = false, priority = 1000 },
  { "omacom-io/lumon.nvim", lazy = false, priority = 1000 },
  { "bjarneo/ethereal.nvim", lazy = false, priority = 1000 },
  { "neanias/everforest-nvim", lazy = false, priority = 1000 },
  { "ellisonleao/gruvbox.nvim", lazy = false, priority = 1000 },
  { "xero/miasma.nvim", lazy = false, priority = 1000 },
  { "ribru17/bamboo.nvim", lazy = false, priority = 1000 },
  { "tahayvr/matteblack.nvim", lazy = false, priority = 1000 },
  { "tanvirtin/monokai.nvim", lazy = false, priority = 1000 },
  { "kepano/flexoki-neovim", lazy = false, priority = 1000 },
  { "rose-pine/neovim", lazy = false, priority = 1000 },
  { "Shatur/neovim-ayu", lazy = false, priority = 1000 },
  { "mellow-theme/mellow.nvim", lazy = false, priority = 1000 },

  -- Light / beige themes
  -- { "zenbones-theme/zenbones.nvim", lazy = false, priority = 1000, opts = { background = "light" } },
  { "uhs-robert/oasis.nvim", lazy = false, priority = 1000, opts = { style = "dune", light_intensity = 3 } },
  { "NLKNguyen/papercolor-theme", lazy = false, priority = 1000 },

  -- Your active theme (with full integrations)
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        mini = true,
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        snacks = true,
        telescope = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find("catppuccin") then
            opts.highlights = require("catppuccin.special.bufferline").get_theme()
          end
        end,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
