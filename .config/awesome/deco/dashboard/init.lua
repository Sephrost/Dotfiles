local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local animation = require("lib.rubato")

local sliders = require("deco.dashboard.slider")
local settings = require("deco.dashboard.settings")
local system = require("deco.dashboard.system")


-- Color variables 
local field_bg_color = beautiful.palette.base

 local dashboard = awful.popup{
  visible = false,
  ontop = true,
  opacity = 1,
  bg = beautiful.palette.mantle,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
  placement = function(d)
    return awful.placement.right(
      d,
      {
        margins = {
          right = beautiful.useless_gap * 5,
        }
      }
    )
  end ,
  widget = {
      widget = wibox.container.margin,
      margins = dpi(5),
      {
        -- Sliders
        {
          widget = wibox.container.background,
          shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
          end,
          bg = field_bg_color,
          {
            wibox.widget{
              sliders.volume,
              sliders.brightness,
              spacing = dpi(2),
              layout = wibox.layout.fixed.vertical
            },
            -- ad margins to the left and to the right 
            widget = wibox.container.margin,
            left = dpi(10),
            right = dpi(10),
          }
        },
        -- Settings 
        {
          widget = wibox.container.background,
          shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
          end,
          bg = field_bg_color,
          {
            wibox.widget{
              settings.wifi,
              settings.bluetooth,
              settings.dnd,
              settings.battery,
              spacing = dpi(2),
              layout = wibox.layout.flex.horizontal
            },
            -- ad margins to the left and to the right 
            widget = wibox.container.margin,
            margins = dpi(2),
          }
        },
        {
          widget = wibox.container.background,
          shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
          end,
          bg = field_bg_color,
          {
            {
              system.cpu,
              system.ram,
              system.temp,
              spacing = dpi(2),
              layout = wibox.layout.flex.horizontal,
            },
            widget = wibox.container.margin,
            margins = dpi(2),
          }
        },
        spacing = dpi(5),
        layout = wibox.layout.fixed.vertical
      }
  },
  -- widget = {
  --   widget = wibox.widget.textbox,
  --   text = "Hello World"
  -- }
}

local dashboard_grabber = awful.keygrabber{
  auto_start = true,
  stop_event = "release",
  stop_key = "Escape",
}

dashboard_grabber.keypressed_callback = function(_, _, key, _)
  if key == "Escape" then
    dashboard.toggle()
    dashboard_grabber:stop()
  end
end

dashboard.toggle = function()
  dashboard.visible = not dashboard.visible
  if dashboard.visible then
    -- add ESC listener to close it
    dashboard_grabber:start() 
  else
    dashboard_grabber:stop()
  end
end

return dashboard

