local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local calendar = require("deco.calendar")

local function init(s)
  local clock = wibox.widget.textclock("%H:%M")

  clock:connect_signal("mouse::enter", function()
    calendar.toggle()
  end)
  
  clock:connect_signal("mouse::leave", function()
    calendar.toggle()
  end)
  return clock
end

return init(s)
