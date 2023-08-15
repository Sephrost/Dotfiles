local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Theme variables 
local bar_height = dpi(9)
local bar_width = dpi(400) -- this is the main way to control the width of the dashboard
local handle_width = dpi(13)
local icon_size = dpi(28)
local handle_color = beautiful.palette.blue
local bar_color = beautiful.palette.crust

-- Volume Widget
-- local volume_icon = wibox.widget{
--   widget = wibox.widget.textbox,
--   font = "SauceCodePro 10",
--   markup = "",
--   -- markup = "Vol",
-- }

-- theme.icon.volume = themes_path.."icons/volume_full.svg"
-- theme.icon.brightness = themes_path.."icons/brightness.svg"
local volume_icon = {
  widget = wibox.widget.imagebox,
  image = gears.color.recolor_image(beautiful.icon.volume, beautiful.palette.text),
  resize = true,
  forced_height = icon_size,
  forced_width = icon_size,
}

-- volume_icon = gears.color.recolor_image(volume_icon, beautiful.palette.lavander)

local volume_slider = wibox.widget{
  widget = wibox.widget.slider,
  minimum = 0,
  maximum = 100,
  forced_height = dpi(50),
  forced_width = bar_width,
  bar_shape = gears.shape.rounded_rect,
  bar_height = bar_height,
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
  {volume_icon, top = dpi(12) ,widget = wibox.container.margin},
  volume_slider,
  spacing = dpi(10),
  layout = wibox.layout.fixed.horizontal,
}

volume_widget.update_volume = update_volume

-- Brightness Widget
local bright_icon = wibox.widget{
  widget = wibox.widget.imagebox,
  image = gears.color.recolor_image(beautiful.icon.brightness, beautiful.palette.text),
  resize = true,
  forced_height = icon_size,
  forced_width = icon_size,
}

local bright_slider = wibox.widget{
  widget = wibox.widget.slider,
  minimum = 0,
  maximum = 100,
  forced_height = dpi(30),
  forced_width = bar_width,
  bar_shape = gears.shape.rounded_rect,
  bar_height = bar_height,
  bar_color = bar_color,
  handle_width = handle_width,
  handle_color = handle_color,
  handle_shape = gears.shape.circle,
}

bright_slider:connect_signal("property::value", function()
  local bright = bright_slider.value
  awful.spawn.easy_async_with_shell("brightnessctl s " .. bright .. "%", function(stdout, stderr, reason, exit_code)
    if exit_code ~= 0 then
      local naughty = require("naughty")
      naughty.notify{
        preset = naughty.config.presets.critical,
        title = "Error while setting brightness",
        text = stderr,
      }
    end
  end)
end)

local bright_widget = wibox.widget{
  bright_icon,
  bright_slider,
  spacing = dpi(10),
  layout = wibox.layout.fixed.horizontal,
}

bright_widget:connect_signal("button::press", function(_, _, _, button)
  -- when sliding with mouse 
  if button == 4 then
    bright_slider.value = bright_slider.value + 5
  elseif button == 5 then
    bright_slider.value = bright_slider.value - 5
  end
end)

bright_widget.update = function()
  awful.spawn.easy_async_with_shell("brightnessctl", function(stdout, stderr, reason, exit_code)
    local brightness = stdout:match("(%d+)%%")
    bright_slider.value = tonumber(brightness)
  end)
end

return {
  volume = volume_widget,
  brightness = bright_widget,
}
