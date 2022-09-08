-- load the plugins
require('plugins')

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

-- When an LSP client attaches to a buffer, it does some processing before becoming ready.
-- This function returns the status of the LSP client as a string.
function lsp_loading()
	-- When there is no LSP client attached, there is nothing to return.
	if vim.lsp.buf_get_clients() == 0 then
		return ""
	end

	local lsp = vim.lsp.util.get_progress_messages()[1]
	if lsp then
		local name = lsp.name or ""
		local msg = lsp.message or ""
		local percentage = lsp.percentage or 0
		local title = lsp.title or ""
		return string.format("%%<%s: %s %s (%s%%%%)", name, title, msg, percentage)
	end
	return ""
end

-- load the status line at the bottom
require('lualine').setup {
  options = {
	  theme = 'auto', -- inherit the theme
	  component_separators = { left = '|', right = '|'},
	  section_separators = { left = '', right = ''},
	  -- refresh the contents of the line each 0.5 second
	  refresh = { 
		  statusline = 500, 
		  tabline = 500, 
		  winbar = 500
	  }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', 'lsp_loading()'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
}

-- show line numbers
vim.opt.number = true

-- reserve a column on the left for displaying signs
-- if this column doesn't exist, it will cause jitter when the LSP client wants to mark a line as erroneous
vim.opt.signcolumn = 'yes'

-- show numbers relative to the current position of the cursor
vim.opt.relativenumber = true

-- setup nvim-cmp
-- menu: use a popup menu to show the possible completions.
-- menuone: popup even when there's only one match
-- noselect: Do not select, force user to select one from the menu
vim.opt.completeopt='menu,menuone,noselect'

local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- setup lsp clients
local on_attach = function(client, bufnr)
  -- setup key-bindings for the lsp
  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

require'lspconfig'.rust_analyzer.setup{
	capabilities=capabilities,
	on_attach=on_attach,
	settings = {
		["rust-analyzer"] = {
			assist = {
				importGranularity = "module",
			},
			cargo = {
				allFeatures = true
			},
			checkOnSave = {
				command = "clippy"
			}
		}
	}
}
require'lspconfig'.clangd.setup {
	capabilities=capabilities,
	on_attach=on_attach
}
require'lspconfig'.bashls.setup{
	capabilities=capabilities,
	on_attach=on_attach
}
