--python support
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python", "ninja", "rst" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff_lsp = {
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = {
            settings = {
              logLevel = "error",
            },
          },
          keys = {
            {
              "<leader>co",
              function()
                require("lspconfig.util").organize_imports()
              end,
              desc = "Organize Imports",
            },
          },
        },
        pyright = {
          -- Pyright specific configuration
        },
      },
      setup = {
        ruff_lsp = function(_, opts)
          require("lazyvim.util").on_attach(function(client, _)
            -- Disable hover in favor of Pyright
            if client.name == "ruff_lsp" then
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
      },
    },
  },

  {
    "nvim-neotest/neotest-python",
  },

  {
    "mfussenegger/nvim-dap-python",
    -- stylua: ignore
    keys = {
      { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
      { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
    },
    config = function()
      local path = require("mason-registry").get_package("debugpy"):get_install_path()
      if vim.fn.has("win32") == 1 then
        require("dap-python").setup(path .. "/venv/Scripts/python.exe")
      else
        require("dap-python").setup(path .. "/venv/bin/python")
      end
    end,
  },
}
