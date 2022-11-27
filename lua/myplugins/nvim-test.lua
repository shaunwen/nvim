require('nvim-test').setup {
  run = true,                 -- run tests (using for debug)
  commands_create = true,     -- create commands (TestFile, TestLast, ...)
  filename_modifier = ":.",   -- modify filenames before tests run(:h filename-modifiers)
  silent = false,             -- less notifications
  term = "terminal",          -- a terminal to run ("terminal"|"toggleterm")
  termOpts = {
    direction = "vertical",   -- terminal's direction ("horizontal"|"vertical"|"float")
    width = 96,               -- terminal's width (for vertical|float)
    height = 24,              -- terminal's height (for horizontal|float)
    go_back = false,          -- return focus to original window after executing
    stopinsert = "auto",      -- exit from insert mode (true|false|"auto")
    keep_one = true,          -- keep only one terminal for testing
  },
  runners = {               -- setup tests runners
    go = "nvim-test.runners.go-test",
    javascript = "nvim-test.runners.jest",
    lua = "nvim-test.runners.busted",
    python = "nvim-test.runners.pytest",
    rust = "nvim-test.runners.cargo-test",
    typescript = "nvim-test.runners.jest",
  }
}

require('nvim-test.runners.jest'):setup {
  command = "./node_modules/.bin/jest",                                       -- a command to run the test runner
  args = { "--collectCoverage=false" },                                       -- default arguments
  env = { CUSTOM_VAR = 'value' },                                             -- custom environment variables

  file_pattern = "\\v(__tests__/.*|(spec|test))\\.(js|jsx|coffee|ts|tsx)$",   -- determine whether a file is a testfile
  find_files = { "{name}.test.{ext}", "{name}.spec.{ext}" },                  -- find testfile for a file

  filename_modifier = nil,                                                    -- modify filename before tests run (:h filename-modifiers)
  working_directory = nil,                                                    -- set working directory (cwd by default)
}

require('nvim-test.runners.mocha'):setup {
  command = { "./node_modules/.bin/mocha", "mocha" },
  file_pattern = "\\v(tests?/.*|test)\\.(js|jsx|coffee)$",
  find_files = { "{name}.test.{ext}" },
}

require('nvim-test.runners.ts-mocha'):setup {
  command = { "./node_modules/.bin/ts-mocha", "ts-mocha" },
  file_pattern = "\\v(tests?/.*|test)\\.(ts|tsx)$",
  find_files = { "{name}.test.{ext}" },
}
