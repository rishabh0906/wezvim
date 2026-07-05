return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "leoluz/nvim-dap-go",
      "mxsdev/nvim-dap-vscode-js",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle debug UI" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug REPL" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local mason_registry = require("mason-registry")

      require("mason").setup()
      require("mason-nvim-dap").setup({
        ensure_installed = {
          "codelldb",
          "delve",
          "js-debug-adapter",
        },
        automatic_installation = true,
      })

      dapui.setup()
      require("dap-go").setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      local codelldb = mason_registry.get_package("codelldb")
      local codelldb_root = codelldb:get_install_path()
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_root .. "/extension/adapter/codelldb",
          args = { "--port", "${port}" },
        },
      }
      dap.configurations.rust = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      local js_debug = mason_registry.get_package("js-debug-adapter")
      require("dap-vscode-js").setup({
        debugger_path = js_debug:get_install_path(),
        adapters = {
          "pwa-node",
          "pwa-chrome",
          "pwa-msedge",
          "node-terminal",
          "pwa-extensionHost",
        },
      })

      for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch current file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "node-terminal",
            request = "launch",
            name = "Run npm test",
            command = "npm test",
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
