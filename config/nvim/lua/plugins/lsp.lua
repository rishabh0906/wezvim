return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = true,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "lua_ls",
          "rust_analyzer",
          "ts_ls",
        },
        automatic_installation = true,
      })

      local on_attach = function(_, bufnr)
        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc })
        end

        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gr", vim.lsp.buf.references, "References")
        map("K", vim.lsp.buf.hover, "Hover")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, "Format")
      end

      local servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              staticcheck = true,
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = true,
              check = { command = "clippy" },
            },
          },
        },
        ts_ls = {},
      }

      local enabled_servers = {}

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        table.insert(enabled_servers, server)

        if vim.lsp.config then
          vim.lsp.config(server, config)
        else
          require("lspconfig")[server].setup(config)
        end
      end

      if vim.lsp.enable then
        vim.lsp.enable(enabled_servers)
      end
    end,
  },
}
