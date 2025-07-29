local status, autopairs = pcall(require, "nvim-autopairs")
if (not status) then return end

autopairs.setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})

-- Integrate with blink.cmp
local blink_status, blink = pcall(require, "blink.cmp")
if blink_status then
  -- blink.cmp handles autopairs integration differently
  -- The integration is built-in when auto_brackets is enabled in blink.cmp config
end

