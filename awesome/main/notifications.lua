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

naughty.config.presets.critical.position = "top_right"

naughty.config.defaults.timeout = 4
naughty.config.defaults.position = "top_left"
naughty.config.defaults.icon_size = dpi(60)
-- This function is called on notify before assigning it the params
-- so we can modify non assingable parameters 
naughty.config.notify_callback = function(args)
  -- If the notification expires we pass it to the notification center,
  -- which will create the wibox with the notification parameters
  args.destroy = function(reason)
    if reason ~= naughty.notificationClosedReason.expired then return end
    awesome.emit_signal("notification::enlist", args)
  end
  return args
end
