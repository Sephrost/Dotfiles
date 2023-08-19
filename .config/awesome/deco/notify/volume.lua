local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local wibox = require("wibox")
local gears = require("gears")
local rubato = require("lib.rubato")

local icons = {
  low = gears.color.recolor_image(beautiful.icon.volume_low, beautiful.palette.text),
  medium = gears.color.recolor_image(beautiful.icon.volume_medium, beautiful.palette.text),
  high = gears.color.recolor_image(beautiful.icon.volume_high, beautiful.palette.text),
  mute = gears.color.recolor_image(beautiful.icon.volume_mute, beautiful.palette.text),

}

local function notify(s)
  local icon = wibox.widget {
    widget = wibox.widget.imagebox,
    forced_height = dpi(70),
    forced_width = dpi(70),
  }

  local progressbar = wibox.widget {
    widget = wibox.widget.progressbar,
    max_value = 100,
    value = 0,
    forced_height = dpi(10),
    forced_width = dpi(200),
    shape = gears.shape.rounded_bar,
    bar_shape = gears.shape.rounded_bar,
    color = beautiful.palette.blue,
    background_color = beautiful.palette.surface1,
  }

  local animation = rubato.timed {
    target = progressbar,
    easing = rubato.quadratic,
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
          y = 0 - s.geometry.height/3
        }
      })
    end,
    shape = function(cr, w, h)
      gears.shape.rounded_rect(cr, w, h, dpi(10))
    end,
    bg = beautiful.palette.mantle,
    widget = {
      widget = wibox.container.margin,
      margins = dpi(10),
      {
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(10),
        {
          widget = wibox.container.place,
          halign = "center",
          icon,
        },
        progressbar,
      }
    },
  }

  local hide = gears.timer {
    timeout = 1.5,
    callback = function()
      widget.visible = false
    end,
  }

  awesome.connect_signal("volume::notify", function()
    awful.spawn.easy_async_with_shell(
      "pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/.$//'",
      function(stdout, stderr, reason, exit_code)

        stdout = stdout:gsub("^%s*(.-)%s*$", "%1")
        local volume = tonumber(stdout)

        awful.spawn.easy_async_with_shell(
        "pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'",
        function(stdout, stderr, reason, exit_code)
          stdout = stdout:gsub("^%s*(.-)%s*$", "%1")
          if stdout == "yes" then
            icon.image = icons.mute
          else
            if volume > 66 then
              icon.image = icons.high
            elseif volume > 33 then
              icon.image = icons.medium
            else
              icon.image = icons.low
            end
          end
        end)
        animation.value = progressbar.value
        animation.target = volume

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
