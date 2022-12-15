packadd vim-jetpack

call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1} "bootstrap
Jetpack 'nvim-lua/plenary.nvim'
Jetpack 'nvim-telescope/telescope.nvim'
Jetpack 'vim-jp/vimdoc-ja'
Jetpack 'thinca/vim-qfreplace'
Jetpack 'lambdalisue/fern.vim'
Jetpack 'folke/tokyonight.nvim'
Jetpack 'EdenEast/nightfox.nvim'
Jetpack 'cohama/lexima.vim'
Jetpack 'machakann/vim-sandwich'
Jetpack 'hrsh7th/nvim-cmp'
Jetpack 'hrsh7th/cmp-buffer'
Jetpack 'hrsh7th/cmp-path'
Jetpack 'hrsh7th/cmp-cmdline'
Jetpack 'hrsh7th/cmp-vsnip'
Jetpack 'hrsh7th/vim-vsnip'
Jetpack 'neovim/nvim-lspconfig'
Jetpack 'williamboman/mason.nvim'
Jetpack 'williamboman/mason-lspconfig.nvim'
call jetpack#end()

for plugin in jetpack#names()
  if !jetpack#tap(plugin)
    call jetpack#sync()
    break
  endif
endfor

syntax on
set tabstop=2
set shiftwidth=2
set expandtab
set number

set helplang=ja,en

colorscheme nordfox
noremap <Space>ff <Cmd>Telescope find_files<CR> 
noremap <Space>fh <Cmd>Telescope help_tags<CR>
noremap <Space>fw <Cmd>Telescope live_grep<CR>
noremap <Space>e <Cmd>Fern . -reveal=%<CR>

let g:fern#hide_cursor = v:true
let g:fern#default_hidden = v:true


set completeopt=menu,menuone,noselect

lua <<EOF
  local cmp = require'cmp'

  -- Global setup.
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'snippy' }, -- For snippy users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
    }, {
      { name = 'buffer' },
    })
  })

  -- `/` cmdline setup.
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- `:` cmdline setup.
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
EOF
