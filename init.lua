local config = {

  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "nightly", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "main", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    -- remotes = { -- easily add new remotes to track
    --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
    --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
    --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    -- },
  },

  -- Set colorscheme
  colorscheme = "gruvbox",

  -- set vim options here (vim.<first_key>.<second_key> =  value)
  options = {
    opt = {
      relativenumber = true, -- sets vim.opt.relativenumber
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
    },
  },

  -- Default theme configuration
  -- default_theme = {
  --   diagnostics_style = { italic = true },
  --   -- Modify the color table
  --   colors = {
  --     fg = "#abb2bf",
  --   },
  --   -- Modify the highlight groups
  --   highlights = function(highlights)
  --     local C = require "default_theme.colors"
  --
  --     highlights.Normal = { fg = C.fg, bg = C.bg }
  --     return highlights
  --   end,
  --   plugins = { -- enable or disable extra plugin highlighting
  --     aerial = true,
  --     beacon = false,
  --     bufferline = true,
  --     dashboard = true,
  --     highlighturl = true,
  --     hop = false,
  --     indent_blankline = true,
  --     lightspeed = false,
  --     ["neo-tree"] = true,
  --     notify = true,
  --     ["nvim-tree"] = false,
  --     ["nvim-web-devicons"] = true,
  --     rainbow = true,
  --     symbols_outline = false,
  --     telescope = true,
  --     vimwiki = false,
  --     ["which-key"] = true,
  --   },
  -- },

  -- Disable AstroNvim ui features
  ui = {
    nui_input = true,
    telescope_select = true,
  },

  -- Configure plugins
  plugins = {
    -- Add plugins, the packer syntax without the "use"
    init = {
      -- You can disable default plugins as follows:
      -- ["goolord/alpha-nvim"] = { disable = true },

      {
        "mfussenegger/nvim-dap",
        config = function ()
          require("dap").adapters.php = {
            type = 'executable',
            command = 'node',
            args = { '/home/tschwemley/.config/debuggers/vscode-php-debug/out/phpDebug.js' }
          }

          require("dap").configurations.php = {
            {
              type = 'php',
              request = 'launch',
              name = 'Listen for Xdebug',
              port = 9095
            }
          }
        end
      },
      {
        "rcarriga/nvim-dap-ui",
        requires = {"mfussenegger/nvim-dap"},
        config = function()
          local dap, dapui = require("dap"), require("dapui")
          dapui.setup()
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end
      },
      {
        'nvim-dap-virtual-text',
        requires = {"mfussenegger/nvim-dap"},
        config = function()
          require("nvim-dap-virtual-text").setup {
            enabled = true,                        -- enable this plugin (the default)
            enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
            highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
            highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
            show_stop_reason = true,               -- show stop reason when stopped for exceptions
            commented = false,                     -- prefix virtual text with comment string
            only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
            all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
            filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
            -- experimental features:
            virt_text_pos = 'eol',                 -- position of virtual text, see `:h nvim_buf_set_extmark()`
            all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
            virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
            virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
          }
        end
      },
      {
        'pwntester/octo.nvim',
        requires = {
          'plenary.nvim',
          'telescope.nvim',
          'nvim-web-devicons',
        },
        config = function ()
          local config = {
            default_remote = {"origin"}; -- order to try remotes
            github_hostname = "github-ca.corp.zynga.com"; -- GitHub Enterprise host
          }
          require"octo".setup(config);
        end
      },
      { "ellisonleao/gruvbox.nvim" }
  },
  -- All other entries override the setup() call for default plugins
  ["indent-o-matic"] = {
    max_lines = 8198,
    standard_widths = { 2, 4, 8 },

    filetype_php = {
      standard_widths = { 4 },
    },
    filetype_ = {
      standard_widths = { 2, 4, 8 },
    }
  },
  ["null-ls"] = function(config)
    local null_ls = require "null-ls"
    -- Check supported formatters and linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- Set a formatter
      null_ls.builtins.formatting.rufo,
      -- Set a linter
      null_ls.builtins.diagnostics.rubocop,
    }
    -- set up null-ls's on_attach function
    config.on_attach = function(client)
      -- NOTE: You can remove this on attach function to disable format on save
      if client.resolved_capabilities.document_formatting then
        vim.api.nvim_create_autocmd("BufWritePre", {
          desc = "Auto format before save",
          pattern = "<buffer>",
            callback = vim.lsp.buf.formatting_sync,
          })
        end
      end
      return config -- return final config table
    end,
    treesitter = {
      ensure_installed = { "go", "javascript", "lua", "php", "typescript" },
    },
    ["nvim-lsp-installer"] = {
      ensure_installed = { "intelephense", "sumneko_lua" },
    },
    packer = {
      compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
    },
  },

  -- LuaSnip Options
  luasnip = {
    -- Add paths for including more VS Code style snippets in luasnip
    vscode_snippet_paths = {},
    -- Extend filetypes
    filetype_extend = {
      javascript = { "javascriptreact" },
    },
  },

  -- Modify which-key registration
  ["which-key"] = {
    -- Add bindings
    register_mappings = {
      -- first key is the mode, n == normal mode
      n = {
        -- second key is the prefix, <leader> prefixes
        ["<leader>"] = {
          -- which-key registration table for normal mode, leader prefix
          -- ["N"] = { "<cmd>tabnew<cr>", "New Buffer" },
        },
      },
    },
  },

  -- CMP Source Priorities
  -- modify here the priorities of default cmp sources
  -- higher value == higher priority
  -- The value can also be set to a boolean for disabling default sources:
  -- false == disabled
  -- true == 1000
  cmp = {
    source_priority = {
      nvim_lsp = 1000,
      luasnip = 750,
      buffer = 500,
      path = 250,
    },
  },

  -- Extend LSP configuration
  lsp = {
    -- enable servers that you already have installed without lsp-installer
    servers = {
      -- "pyright"
    },
    -- add to the server on_attach function
    -- on_attach = function(client, bufnr)
    -- end,

    -- override the lsp installer server-registration function
    -- server_registration = function(server, opts)
    --   require("lspconfig")[server].setup(opts)
    -- end,

    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = {
      -- example for addings schemas to yamlls
      -- yamlls = {
      --   settings = {
      --     yaml = {
      --       schemas = {
      --         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
      --         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      --         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      --       },
      --     },
      --   },
      -- },
    },
  },

  -- Diagnostics configuration (for vim.diagnostics.config({}))
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  -- This function is run last
  -- good place to configure mappings and vim options
  polish = function()
    -- Set key bindings
    vim.keymap.set("n", "<C-s>", ":w!<CR>")
    vim.keymap.set("n", "<F5>", ":DapContinue<CR>")
    vim.keymap.set("n", "<F10>", ":DapStepInto<CR>")
    vim.keymap.set("n", "<F11>", ":DapStepOver<CR>")
    vim.keymap.set("n", "<F12>", ":DapStepOut<CR>")
    vim.keymap.set("n", "<leader>b", ":DapToggleBreakpoint<CR>")
    vim.keymap.set("n", "<F6>", ":lua require('dapui').close()<CR>")

    -- Set autocommands
    vim.api.nvim_create_augroup("packer_conf", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "plugins.lua",
      command = "source <afile> | PackerSync",
    })

    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}

return config
