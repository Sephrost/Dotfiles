local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local calendar = require("deco.calendar")
local dpi = require("beautiful.xresources").apply_dpi

local function init(s)
  local clock = wibox.widget{
    widget = wibox.widget.textclock,
    format = '<span color="' .. beautiful.palette.blue .. '" font="' ..
    beautiful.fontfamily .. ' bold 12">%H\n%M</span>',
    valign = "center",
  }

  clock = wibox.widget{
    -- layout = wibox.layout.fixed.horizontal,
    {
      widget = wibox.container.margin,
      margins = dpi(2),
      {
        widget = wibox.container.place,
        halign = "center",
        valign = "center",
        clock,
      },
    },
    widget = wibox.container.background,
    bg = beautiful.palette.surface0,
    forced_width = math.huge,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(5))
    end,
  }

  clock:connect_signal("mouse::enter", function()
    calendar.toggle()
  end)

  clock:connect_signal("mouse::leave", function()
    calendar.toggle()
  end)
  return clock
end

return init(s)
