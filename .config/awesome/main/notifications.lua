-- Change style of notifications
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

naughty.config.padding = beautiful.useless_gap * 10
naughty.config.spacing = dpi(5)
naughty.icon_dirs = {
  os.getenv("HOME") .. ".icons/Catppuccin-Macchiato/"
}
naughty.icon_formats = { "svg", "png", "jpg", "gif" }

local preset_normal = {
  hover_timeout = 1,
  position     = "top_left",
}

naughty.config.presets.normal = preset_normal
naughty.config.presets.low = preset_normal

naughty.config.defaults.timeout = 4
naughty.config.notify_callback = function(args)
  args.destroy = function(reason)
    if reason ~= naughty.notificationClosedReason.expired then return end
    -- pass caller 
    awesome.emit_signal("notification::enlist", args)
  end
  return args
end
