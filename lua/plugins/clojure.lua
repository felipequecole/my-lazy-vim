return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "clojure" } },
  },
  {
    "julienvincent/nvim-paredit",
    config = function()
      require("nvim-paredit").setup()
    end,
  },
  {
    "Olical/conjure",
    event = "LazyFile",
    config = function(_, _)
      require("conjure.main").main()
      require("conjure.mapping")["on-filetype"]()
    end,
    init = function()
      -- print color codes if baleia.nvim is available
      local colorize = require("lazyvim.util").has("baleia.nvim")

      if colorize then
        vim.g["conjure#log#strip_ansi_escape_sequences_line_limit"] = 0
      else
        vim.g["conjure#log#strip_ansi_escape_sequences_line_limit"] = 1
      end

      -- disable diagnostics in log buffer and colorize it
      vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
        pattern = "conjure-log-*",
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          vim.diagnostic.enable(false, { bufnr = buffer })

          if colorize and vim.g.conjure_baleia then
            vim.g.conjure_baleia.automatically(buffer)
          end

          -- special cases for Nubank
          vim.g["conjure#client#clojure#nrepl#test#current_form_names"] =
            { "deftest", "defflow", "defflow-i18n", "defspec", "facts" }

          vim.keymap.set(
            { "n", "v" },
            "[c",
            "<CMD>call search('^; -\\+$', 'bw')<CR>",
            { silent = true, buffer = true, desc = "Jumps to the begining of previous evaluation output." }
          )
          vim.keymap.set(
            { "n", "v" },
            "]c",
            "<CMD>call search('^; -\\+$', 'w')<CR>",
            { silent = true, buffer = true, desc = "Jumps to the begining of next evaluation output." }
          )
        end,
      })

      -- prefer LSP for jump-to-definition and symbol-doc, and use conjure
      -- alternatives with <localleader>K and <localleader>gd
      vim.g["conjure#mapping#doc_word"] = "K"
      vim.g["conjure#mapping#def_word"] = "gd"
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
  {
    "PaterJason/nvim-treesitter-sexp",
    enabled = false,
  },
}
