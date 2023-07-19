local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local function init(s)
  local clock = wibox.widget.textclock("%H:%M")
  local calendar = awful.widget.calendar_popup.month({
    position = "tl",
    margin = 5,
    font = beautiful.font,
  })
  local year_calendar = awful.widget.calendar_popup.year({
    position = "tl",
    margin = 2,
    font = beautiful.font,
  })

  -- When the clock is pressed, show calendar
  -- calendar:attach(clock, "tl")
  clock:connect_signal("button::press", function(_, _, _, button)
    if button == 3 then
      year_calendar:toggle()
    end
  end)

  clock:connect_signal("mouse::enter", function()
    if not year_calendar.visible then
      calendar:toggle()
    end
  end)
  
  clock:connect_signal("mouse::leave", function()
    if not year_calendar.visible then
      calendar:toggle()
    end
  end)
  return clock
end

return init(s)
