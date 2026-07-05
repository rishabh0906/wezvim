return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    cmd = { "TSInstall", "TSInstallSync", "TSUpdate" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "css",
          "go",
          "gomod",
          "gosum",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "rust",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
