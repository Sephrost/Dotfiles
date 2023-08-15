local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local battery_charged_color = beautiful.palette.green
local battery_low_color = beautiful.palette.maroon

local battery_number = 1
local battery_status = {}
local total_battery_percentage = 0

local function update_battery_status(fun)


  awful.spawn.easy_async_with_shell(
    "ls /sys/class/power_supply/ | grep '^BAT' | wc -l",
    function(stdout)
      battery_number = tonumber(stdout)
      -- for each battery get status and percentage and update the map
      for i = 1, battery_number do
        battery_status[i] = {}
        awful.spawn.easy_async_with_shell(
          "cat /sys/class/power_supply/BAT" .. tostring(i - 1) .. "/status",
          function(stdout)
            battery_status[i].status = string.gsub(stdout, "\n", "")
            awful.spawn.easy_async_with_shell(
            "cat /sys/class/power_supply/BAT" .. tostring(i - 1) .. "/capacity",
            function(stdout)
              --stip new line 
              battery_status[i].percentage = string.gsub(stdout, "\n", "")
              total_battery_percentage = total_battery_percentage + tonumber(stdout)
              if fun ~= nil then
                fun()
              end
            end
            )
          end
        )
      end
    end
  )
end

local function create_battery_widget()
  local battery_progressbar = wibox.widget {
    max_value = 100,
    value = 100,
    forced_height = dpi(1),
    forced_width = 50,
    border_width = 1,
    border_color = beautiful.palette.text,
    color = beautiful.palette.green,
    background_color = beautiful.palette.mantle,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 5)
    end,
    widget = wibox.widget.progressbar
  }

  local battery_tooltip = awful.tooltip{
    objects = {battery_progressbar},
    timeout = 10,
    timer_function = function()
      local str = ""
      for i = 1, battery_number do 
        str = str .. "Battery " .. tostring(i) .. ": " .. battery_status[i].percentage .. "% " 
          .. battery_status[i].status .. "\n" .. (i==battery_number and "" or "\n")
      end

      return str
    end,
  }

  local function update_progressbar()
    local val = total_battery_percentage / battery_number
    battery_progressbar.value = val

    local is_charging = false
    for i = 1, battery_number do
      if battery_status[i].status == "Charging\n" then
        is_charging = true
      end
    end

    if val < 20 then
      battery_progressbar.color = battery_low_color
    elseif is_charging then
      battery_progressbar.color = beautiful.palette.mauve
    else
      battery_progressbar.color = battery_charged_color
    end

  end

  -- Init timer 
  gears.timer {
    timeout = 60,
    autostart = true,
    callback = function()
      update_battery_status(update_progressbar)
    end
  }

  return battery_progressbar
end

-- Update battery widget
update_battery_status()

return create_battery_widget()
