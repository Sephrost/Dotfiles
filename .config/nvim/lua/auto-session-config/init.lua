require("auto-session").setup {
  log_level = "error",
  auto_session_create_enabled = true,
  auto_session_suppress_dirs = {
    "~/",
    "~/.config",
    "~/Downloads",
    "~/Desktop",
    "~/Documents",
  },
  cwd_change_handling = {
    post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
      require("lualine").refresh() -- refresh lualine so the new session name is displayed in the status bar
    end,
  },
}
