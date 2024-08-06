local awful = require("awful")
local gears = require("gears") 
local wibox = require("wibox") 
local beautiful = require("beautiful") 
local dpi = beautiful.xresources.apply_dpi 
local rubato = require("lib.rubato") 

-- Color variables 
local field_bg_color = beautiful.palette.base

local calendar_widget = wibox.widget{
  date = os.date("*t"),
  font = beautiful.font,
  --wrap current date into a rounded rect of bg beautiful.palette.blue
    widget = wibox.widget.calendar.month
}

local calendar = awful.popup{
  visible = false,
  ontop = true,
  opacity = 1,
  bg = beautiful.palette.mantle,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
  placement = function(d) return awful.placement.left( d,
      {
        margins = {
          left = beautiful.useless_gap * 50,
        }
      }
    ) + awful.placement.top
  end ,
  widget = {
    widget = wibox.container.margin,
    margins = dpi(5),
    calendar_widget
  },
}

-- The widgets coordinates is made known once it is made visible, but because it is not 
-- i just do the math myself
local calendar_pos = beautiful.useless_gap * 8
local offsite_calendar_pos = - calendar.height

local slide = rubato.timed{
  rate = 60,
  duration = 0.2,
  easing = rubato.quadratic,
}

slide:subscribe(function(pos)
  calendar.y = pos
end)

calendar.toggle = function()
  if not calendar.visible then
    -- move it offscreen ad make it visible
    calendar.y = offsite_calendar_pos
    calendar.visible = true
    -- set animation params
    slide.pos = offsite_calendar_pos
    slide.target = calendar_pos
  else
    -- set animation params
    slide.pos = calendar.y
    slide.target = offsite_calendar_pos
    -- wait for animation to finish, otherwise it will be hidden before the animation is done
    gears.timer.start_new(0.4, function()
      calendar.visible = false
    end)
  end
end

awesome.connect_signal("calendar:toggle", function()
  calendar.toggle()
end)

return calendar

