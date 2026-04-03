local M = {}

function M.setup()
  vim.g.db_ui_save_location = vim.fn.stdpath "config" .. require("plenary.path").path.sep .. "db_ui"

  local dadbod_group = vim.api.nvim_create_augroup('DadbodConfig', { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = dadbod_group,
    pattern = {
      "sql",
    },
    command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
  })
end

return M
