local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Theme variables 
local handle_width = dpi(10)
local handle_color = beautiful.palette.blue
local bar_color = beautiful.palette.crust

-- Volume Widget
local volume_icon = wibox.widget{
  widget = wibox.widget.textbox,
  font = "SauceCodePro 10",
  markup = "",
}


-- volume_icon = gears.color.recolor_image(volume_icon, beautiful.palette.lavander)

local volume_slider = wibox.widget{
  widget = wibox.widget.slider,
  minimum = 0,
  maximum = 100,
  forced_height = dpi(30),
  forced_width = dpi(220),
  bar_shape = gears.shape.rounded_rect,
  bar_height = dpi(5),
  bar_color = bar_color,
  handle_width = handle_width,
  handle_shape = gears.shape.circle,
  handle_color = handle_color,
}

volume_slider:connect_signal("property::value", function()
  local vol = volume_slider.value
  awful.spawn.easy_async_with_shell("pactl -- set-sink-volume 0" .. vol .. "%", function(stdout, stderr, reason, exit_code)
    if exit_code ~= 0 then
      local naughty = require("naughty")
      naughty.notify{
        preset = naughty.config.presets.critical,
        title = "Error while setting volume",
        text = stderr,
      }
    end
  end)
end)

local function update_volume()
  awful.spawn.easy_async_with_shell("pactl list sinks", function(stdout, stderr, reason, exit_code)
    local volume = stdout:match("(%d+)%% /")
    volume_slider.value = tonumber(volume)
  end)
end

local volume_widget = wibox.widget{
  volume_icon,
  volume_slider,
  spacing = dpi(15),
  layout = wibox.layout.fixed.horizontal,
}

volume_widget.update_volume = update_volume

-- Brightness Widget
local bright_icon = wibox.widget{
  widget = wibox.widget.textbox,
  font = "SauceCodePro 10",
  markup = "",

}

local bright_slider = wibox.widget{
  widget = wibox.widget.slider,
  minimum = 0,
  maximum = 100,
  forced_height = dpi(30),
  forced_width = dpi(220),
  bar_shape = gears.shape.rounded_rect,
  bar_height = dpi(5),
  bar_color = bar_color,
  handle_width = handle_width,
  handle_color = handle_color,
  handle_shape = gears.shape.circle,
}

bright_slider:connect_signal("propriet::value", function()
  awful.spawn("brightnessctl set " .. bright_slider.value .. "%", false)
end)

local function update_brightness()
  awful.spawn.easy_async_with_shell("brightnessctl g", function(stdout, stderr, reason, exit_code)
    local brightness = stdout:match("(%d+)%%")
    bright_slider.value = tonumber(brightness)
  end)
end

local bright_widget = wibox.widget{
  bright_icon,
  bright_slider,
  spacing = dpi(15),
  layout = wibox.layout.fixed.horizontal,
}


return {
  volume = volume_widget,
  brightness = bright_widget,
}
