packadd vim-jetpack

call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1} "bootstrap
Jetpack 'nvim-lua/plenary.nvim'
Jetpack 'nvim-telescope/telescope.nvim'
Jetpack 'vim-jp/vimdoc-ja'
Jetpack 'thinca/vim-qfreplace'
Jetpack 'lambdalisue/fern.vim'
Jetpack 'lambdalisue/gin.vim'
Jetpack 'folke/tokyonight.nvim'
Jetpack 'EdenEast/nightfox.nvim'
Jetpack 'cohama/lexima.vim'
Jetpack 'machakann/vim-sandwich'
Jetpack 'hrsh7th/nvim-cmp'
Jetpack 'hrsh7th/cmp-nvim-lsp'
Jetpack 'hrsh7th/cmp-nvim-lsp-document-symbol'
Jetpack 'hrsh7th/cmp-nvim-lsp-signature-help'
Jetpack 'hrsh7th/cmp-nvim-lua'
Jetpack 'hrsh7th/cmp-buffer'
Jetpack 'hrsh7th/cmp-path'
Jetpack 'hrsh7th/cmp-cmdline'
Jetpack 'hrsh7th/cmp-vsnip'
Jetpack 'hrsh7th/cmp-calc'
Jetpack 'hrsh7th/cmp-emoji'
Jetpack 'hrsh7th/vim-vsnip'
Jetpack 'neovim/nvim-lspconfig'
Jetpack 'williamboman/mason.nvim'
Jetpack 'williamboman/mason-lspconfig.nvim'
Jetpack 'onsails/lspkind-nvim'
Jetpack 'petertriho/cmp-git'
Jetpack 'vim-denops/denops.vim'
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
noremap <Space>aa <Cmd>GinStatus<CR>
noremap <Space>ac <Cmd>Gin commit -v<CR>

let g:fern#hide_cursor = v:true
let g:fern#default_hidden = v:true


set completeopt=menu,menuone,noselect

lua <<EOF
  local lspkind = require'lspkind'

  local cmp = require'cmp'
  cmp.setup {
    snippet = {
      expand = function(args)
        vim.fn['vsnip#anonymous'](args.body)
      end
    },
    window = {
   
      completion = {
        -- border = 'single',
      },
      documentation = {
        -- border = 'single',
      },
    },
    formatting = {
      fields = { 'kind', 'abbr', 'menu', },
      format = require("lspkind").cmp_format({
        with_text = false,
      })
    },
    mapping = {
      ['<C-o>'] = cmp.mapping(function(fallback)
        local fallback_key = vim.api.nvim_replace_termcodes('<Tab>', true, true, true)
        local resolved_key = vim.fn['copilot#Accept'](fallback)
        if fallback_key == resolved_key then
          cmp.confirm({ select = true })
        else
          vim.api.nvim_feedkeys(resolved_key, 'n', true)
        end
      end),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i' }),
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<C-y>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
      ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp_signature_help' },
    }, {
      { name = 'path' },
    }, {
      { name = 'nvim_lsp' },
    }, {
      { name = 'calc' },
      { name = 'vsnip' },
      { name = 'emoji' },
    }, {
      { name = 'buffer' },
    })
  }
  cmp.setup.filetype('gitcommit', {
    sources = require('cmp').config.sources({
      { name = 'cmp_git' },
    }, {
      { name = 'buffer' },
    })
  })
  require('cmp_git').setup({})

  cmp.setup.cmdline('/', {
    sources = {
      { name = 'nvim_lsp_document_symbol' },
      { name = 'buffer' },
    },
  })
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline' },
    }),
  })
EOF

lua <<EOF
  require("mason").setup()
  require("mason-lspconfig").setup()
  require("mason-lspconfig").setup_handlers({
    function(server_name)
      require("lspconfig")[server_name].setup({
        on_attach=function(client, bufnr)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=bufnr})
        end
      })
    end
  })
EOF

