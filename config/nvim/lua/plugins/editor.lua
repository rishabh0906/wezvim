return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup()
      vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = true,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = true,
  },
}
