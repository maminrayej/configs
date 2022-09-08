return require('packer').startup(function()
  -- package manager
  use 'wbthomason/packer.nvim'

  -- quick start configs for nvim lsp
  use 'neovim/nvim-lspconfig' 

  -- gruvbox theme <3
  use 'ellisonleao/gruvbox.nvim'

  -- status line
  use {
	  'nvim-lualine/lualine.nvim',
	  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- fuzzy finder
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  -- completion engine
  use 'hrsh7th/nvim-cmp'

  -- snippet engine
  use 'L3MON4D3/LuaSnip'

  -- completion sources
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'saadparwaiz1/cmp_luasnip'
end)
