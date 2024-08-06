local awful = require("awful")
local wibox = require("wibox")

-- setxkbmap -layout us -variant intl

local languages = {
  'us',
  'us -variant intl',
  'it',
}
local selected = 1

local widget = awful.widget.keyboardlayout()
-- Add buttons
widget:connect_signal("button::press", function(_, _, _, button)
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

return widget
