local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi

local function makeButton(icon)
    local button = wibox.widget {
      {
        {
          widget = wibox.widget.textbox,
          text = icon,
          font = "SauceCodePro 10",
          align = "center",
        },
        margins = dpi(10),
        widget = wibox.container.margin
      },
      bg = beautiful.palette.base,
      shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 5)
      end,
      widget = wibox.container.background
    }

    return button
end

local wifi_button = makeButton("")
local bluetooth_button = makeButton("")
local battery_button = makeButton("󱟦")
local volume_button = makeButton("")
local airplane_button = makeButton("󰀝")

return {
  wifi = wifi_button,
  bluetooth = bluetooth_button,
  battery = battery_button,
  volume = volume_button,
  dnd = airplane_button
}
