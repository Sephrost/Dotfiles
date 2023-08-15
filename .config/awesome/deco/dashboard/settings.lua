local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi

local function makeButton(icon,color)
    local textbox = wibox.widget {
      widget = wibox.widget.textbox,
      text = icon,
      font = "SauceCodePro 17",
      align = "center",
    }
    
    local button = wibox.widget {
      {
        textbox,
        top = dpi(17),
        bottom = dpi(17),
        left = dpi(10),
        right = dpi(10),
        widget = wibox.container.margin
      },
      bg = beautiful.palette.mantle,
      shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 5)
      end,
      widget = wibox.container.background
    }

    button.selected = false -- change this 
    
    local function toggle_color()
      if button.selected then
        -- color text 
        textbox.markup = "<span foreground='" .. beautiful.palette.text .. "'>" .. icon .. "</span>"
        button.selected = false
      else
        -- color text
        textbox.markup = "<span foreground='" .. color .. "'>" .. icon .. "</span>"
        button.selected = true
      end
    end

    button:connect_signal("button::press", function(_,_,_,button)
      if button == 1 or button == 3 then
        toggle_color()
      end
    end)

    return button
end

local wifi_button = makeButton("",beautiful.palette.blue)
local bluetooth_button = makeButton("",beautiful.palette.mauve)
local battery_button = makeButton("󱟦",beautiful.palette.green)
local volume_button = makeButton("")
local airplane_button = makeButton("󰀝",beautiful.palette.flamingo)

return {
  wifi = wifi_button,
  bluetooth = bluetooth_button,
  battery = battery_button,
  volume = volume_button,
  dnd = airplane_button
}
