local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local wibox = require("wibox")
local gears = require("gears")
local rubato = require("lib.rubato")

local icons = {
  low = gears.color.recolor_image(beautiful.icon.brightness_low, beautiful.palette.text),
  medium_low = gears.color.recolor_image(beautiful.icon.brightness_medium_low, beautiful.palette.text),
  medium_high = gears.color.recolor_image(beautiful.icon.brightness_medium_high, beautiful.palette.text),
  high = gears.color.recolor_image(beautiful.icon.brightness_high, beautiful.palette.text),
}

icon_size = dpi(30)

local function notify(s)
  local icon = wibox.widget {
    widget = wibox.widget.imagebox,
    forced_height = icon_size,
    forced_width = icon_size,
  }

  local progressbar = wibox.widget {
    widget = wibox.widget.progressbar,
    max_value = 100,
    value = 0,
    forced_height = dpi(10),
    forced_width = dpi(200),
    shape = function(cr, w, h)
      gears.shape.rounded_rect(cr, w, h, dpi(5))
    end,
    color = beautiful.palette.yellow,
    background_color = beautiful.palette.surface1,
  }

  local animation = rubato.timed {
    target = progressbar,
    easing = rubato.linear,
    duration = 0.25,
  }

  animation:subscribe(function(value)
    progressbar.value = value
  end)

  local widget = awful.popup{
    visible = false,
    ontop = true,
    placement = function(c)
      awful.placement.centered(c, {
        offset = {
          y = 0 - s.geometry.height/2.5
        }
      })
    end,
    shape = function(cr, w, h)
      gears.shape.rounded_rect(cr, w, h, dpi(10))
    end,
    bg = beautiful.palette.mantle,
    border_color = beautiful.palette.surface1,
    border_width = dpi(1),
    widget = {
      widget = wibox.container.margin,
      margins = dpi(10),
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(10),
        {
          widget = wibox.container.place,
          halign = "center",
          icon,
        },
        {
          widget = wibox.container.margin,
          margins = {
            top = dpi(5),
            bottom = dpi(5),
          },
          progressbar,
        },
      }
    },
  }

  local hide = gears.timer {
    timeout = 2,
    callback = function()
      widget.visible = false
    end,
  }

  awesome.connect_signal("brightness::notify", function()
    awful.spawn.easy_async_with_shell("brightnessctl",
      function(stdout, stderr, reason, exit_code)
        local brightness = stdout:match("(%d+)%%")
        brightness = tonumber(brightness)
        if brightness <= 25 then
          icon.image = icons.low
        elseif brightness <= 50 then
          icon.image = icons.medium_low
        elseif brightness <= 75 then
          icon.image = icons.medium_high
        else
          icon.image = icons.high
        end
        animation.value = progressbar.value
        animation.target = brightness

        if widget.visible then
          hide:again()
        else
          widget.visible = true
          hide:start()
        end

      end)
    end)

    return widget
end

awful.screen.connect_for_each_screen(function(s)
  notify(s)
end)
