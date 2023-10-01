local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

-- setxkbmap -layout us -variant intl

local languages = {
  'us',
  'us -variant intl',
  'it',
}
local selected = 1

local keyboard_widget = awful.widget.keyboardlayout()
-- Add buttons
keyboard_widget:connect_signal("button::press", function(_, _, _, button)
  if (button == 1) then
    selected = selected + 1
    if (selected > #languages) then
      selected = 1
    end
    awful.spawn.with_shell("setxkbmap -layout " .. languages[selected])
  elseif (button == 3) then
    selected = selected - 1
    if (selected < 1) then
      selected = #languages
    end
    awful.spawn.with_shell("setxkbmap -layout " .. languages[selected])
  end
end)
