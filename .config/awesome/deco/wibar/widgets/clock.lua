local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local calendar = require("deco.calendar")

local function init(s)
  local clock = wibox.widget.textclock("%H:%M")

  clock:connect_signal("mouse::enter", function()
    if not year_calendar.visible then
      calendar.toggle()
    end
  end)
  
  clock:connect_signal("mouse::leave", function()
    if not year_calendar.visible then
      calendar.toggle()
    end
  end)
  return clock
end

return init(s)
