local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")


local function make_rounded_progressbar(icon, color)
  local progressbar = wibox.widget {
    {
      {
        {
          {
            widget = wibox.widget.imagebox,
            image = gears.color.recolor_image( 
              icon,
              beautiful.palette.text
            ),
            -- forced_width = dpi(5),
            -- forced_height = dpi(5),
          },
          max_value = 100,
          min_value = 0,
          value = 75,
          -- start from top and follow clockwise
          start_angle = 4.71238898,
          forced_height = dpi(30),
          forced_width = dpi(30),
          paddings = dpi(5),
          rounded_edge = true,
          colors = {color},
          widget = wibox.container.arcchart,
        },
        widget = wibox.container.mirror,
        reflection = {
          vertical = false,
          horizontal = true,
        },
      },
      margins = dpi(5),
      widget = wibox.container.margin
    },
    -- bg = beautiful.bg_normal,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 5)
    end,
    widget = wibox.container.background
  }

  return progressbar
end

return {
  cpu = make_rounded_progressbar(beautiful.icon.cpu, beautiful.palette.peach),
  ram = make_rounded_progressbar(beautiful.icon.ram, beautiful.palette.yellow),
  temp = make_rounded_progressbar(beautiful.icon.temp, beautiful.palette.red),
}
