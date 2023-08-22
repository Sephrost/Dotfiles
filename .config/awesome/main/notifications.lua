-- Change style of notifications
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")
local awful = require("awful")

naughty.config.padding = beautiful.useless_gap * 10
naughty.config.spacing = dpi(5)
naughty.icon_dirs = {
  os.getenv("HOME") .. ".icons/Catppuccin-Macchiato/"
}
naughty.icon_formats = { "svg", "png", "jpg", "gif" }

local preset_normal = {
  timeout      = 6,
  hover_timeout = 1,
  position     = "top_right",
}

naughty.config.presets.normal = preset_normal
