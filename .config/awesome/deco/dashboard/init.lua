local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local animation = require("lib.rubato")

local sliders = require("deco.dashboard.slider")

 local dashboard = awful.popup{
  visible = false,
  ontop = true,
  opacity = 1,
  bg = beautiful.palette.mantle,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
  placement = function(d)
    return awful.placement.top_right(
      d,
      {
        margins = {
          top = dpi(20) + beautiful.useless_gap * 2,
          right = beautiful.useless_gap * 2,
        }
      }
    )
  end,
  widget = {
      widget = wibox.container.margin,
      margins = 5,
      {
        {
          widget = wibox.container.background,
          shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
          end,
          bg = beautiful.palette.base,
          {
            wibox.widget{
            sliders.volume,
            sliders.brightness,
            -- spacing = dpi(2),
            margins = dpi(10),
            layout = wibox.layout.fixed.vertical
            },
            -- ad margins to the left and to the right 
            widget = wibox.container.margin,
            left = dpi(10),
            right = dpi(10),
          }
        },
        layout = wibox.layout.fixed.vertical
      }
  },
  -- widget = {
  --   widget = wibox.widget.textbox,
  --   text = "Hello World"
  -- }
}

dashboard.toggle = function()
  dashboard.visible = not dashboard.visible
end

return dashboard

