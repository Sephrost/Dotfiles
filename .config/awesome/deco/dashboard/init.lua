local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local rubato = require("lib.rubato")
local sliders = require("deco.dashboard.slider")
local settings = require("deco.dashboard.settings")
local system = require("deco.dashboard.system")
local music = require("deco.dashboard.music")
local user = require("deco.dashboard.user")


-- Color variables 
local field_bg_color = beautiful.palette.base
local dashboard_bg_color = beautiful.palette.crust

-- Spacing variables 
local widget_padding = dpi(10)
local dashboard_padding = dpi(12)

 local dashboard = awful.popup{
  visible = false,
  ontop = true,
  opacity = 1,
  bg = dashboard_bg_color,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
  placement = function(d) return awful.placement.right( d,
      {
        margins = {
          right = beautiful.useless_gap * 5,
        }
      }
    )
  end ,
  widget = {
      widget = wibox.container.margin,
      margins = dashboard_padding,
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
              spacing = dpi(12),
              layout = wibox.layout.fixed.vertical
            },
            widget = wibox.container.margin,
            margins = widget_padding,
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
              spacing = dpi(12),
              layout = wibox.layout.flex.horizontal
            },
            widget = wibox.container.margin,
            margins = widget_padding,
          }
        },
        {
          widget = wibox.container.background,
          shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
          end,
          bg = field_bg_color,
          {
            music,
            widget = wibox.container.margin,
            margins = widget_padding,
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
            margins = widget_padding,
          }
        },
        {
          widget = wibox.container.background,
          shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
          end,
          bg = field_bg_color,
          {
            user,
            widget = wibox.container.margin,
            margins = widget_padding,
          }
        },
        spacing = dpi(10),
        layout = wibox.layout.fixed.vertical
      }
  },
}

-- Unused grabber
local dashboard_grabber = awful.keygrabber{
  auto_start = true,
  stop_event = "release",
  stop_key = "Escape",
}

dashboard_grabber.keypressed_callback = function(_, _, key, _)
  if key == "Escape" or key == "q" then
    dashboard.toggle()
    dashboard_grabber:stop()
  end
end

-- The widgets coordinates is made known once it is made visible, but because it is not 
-- i just do the math myself
local dashboard_pos = awful.screen.focused().geometry.width - dashboard.width - beautiful.useless_gap * 5
local offsite_dashboard_pos = awful.screen.focused().geometry.width + dashboard.width + beautiful.useless_gap * 5

local slide = rubato.timed{
  rate = 60,
  duration = 0.2,
  easing = rubato.quadratic,
}

slide:subscribe(function(pos)
  dashboard.x = pos
end)

local timer = gears.timer{
  timeout = 3,
  autostart = false,
  callback = function()
    sliders.volume.update()
    sliders.brightness.update()

    settings.wifi.update()
    settings.bluetooth.update()
    settings.dnd.update()
    settings.battery.update()

    system.cpu.update()
    system.ram.update()
    system.temp.update()

    user.update()
  end
}

dashboard.toggle = function()
  if not dashboard.visible then

    -- update the values 
    timer:emit_signal("timeout")
    timer:start()


    -- move it offscreen ad make it visible
    dashboard.x = offsite_dashboard_pos
    dashboard.visible = true
    -- set animation params
    slide.pos = offsite_dashboard_pos
    slide.target = dashboard_pos
    -- start grabber
    -- dashboard_grabber:start() 
  else
    -- stop the timer
    timer:stop()
    -- stop grabber
    -- dashboard_grabber:stop()
    -- set animation params
    slide.pos = dashboard.x
    slide.target = offsite_dashboard_pos
    -- wait for animation to finish, otherwise it will be hidden before the animation is done
    gears.timer.start_new(0.4, function()
      dashboard.visible = false
    end)
  end
end

awesome.connect_signal("dashboard::toggle", function()
  dashboard.toggle()
end)

return dashboard

