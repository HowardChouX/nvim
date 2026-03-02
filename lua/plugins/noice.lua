return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
        ["vim.lsp.util.stylize_markdown"] = false,
        ["cmp.entry.get_documentation"] = false,
      },
      progress = {
        enabled = true,
        format = "lsp_progress",
        view = "mini",
      },
      message = {
        enabled = true,
        view = "mini",
        opts = {},
      },
      hover = {
        enabled = true,
        silent = true,
      },
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true,
          luasnip = true,
          throttle = 50,
        },
      },
    },
    notify = {
      enabled = true,
      view = "notify",
      on_open = function(win)
        vim.keymap.set("n", "<LeftMouse>", function()
          vim.api.nvim_win_close(win, true)
        end, { buffer = true, silent = true })
        vim.keymap.set("i", "<LeftMouse>", function()
          vim.api.nvim_win_close(win, true)
        end, { buffer = true, silent = true })
      end,
    },
    messages = {
      enabled = true,
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = "virtualtext",
    },
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
      format = {
        cmdline = { pattern = "^:", icon = "", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = false,
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
      {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "notify",
          find = "already referenced",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "lsp",
          kind = "progress",
        },
        view = "mini",
      },
      {
        filter = {
          event = "lsp",
          kind = "message",
        },
        view = "mini",
      },
      {
        filter = {
          event = "msg_show",
          min_height = 10,
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          message = {
            min_length = 20,
          },
        },
        opts = { skip = true },
      },
    },
    views = {
      cmdline_popup = {
        position = { row = 2, col = "50%" },
        size = { width = 40, height = "auto" },
      },
      mini = {
        position = { row = -2, col = "100%" },
        timeout = 150,
        size = { width = 15, height = 1 },
        border = "none",
        zindex = 60,
        win_options = {
          winblend = 30,
          winhighlight = {
            Normal = "NoiceMini",
            IncSearch = "",
            Search = "",
          },
        },
      },
    },

    throttle = 1000 / 30,
  },
}
