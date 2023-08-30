local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local lgi = require("lgi")
local upower = lgi.require("UPowerGlib")

local function get_batteries()
  local batteries = {}
  for _, dev in ipairs(upower.Client():get_devices()) do
    if dev:get_object_path():match("/battery_BAT[0-9]+$") then
      table.insert(batteries, dev)
    end
  end
  return batteries
end

local function get_battery_percentage()
  local batteries = batteries or get_batteries()
  if #batteries == 0 then
    return 0
  end

  local percentage = 0
  for _, battery in ipairs(batteries) do
    percentage = percentage + battery.percentage
  end
  return percentage / #batteries
end

local battery_charged_color = beautiful.palette.green
local battery_low_color = beautiful.palette.maroon
local battery_charging_color = beautiful.palette.mauve

local states = {
  [0] = "Unknown",
  [1] = "Charging",
  [2] = "Discharging",
  [3] = "Empty",
  [4] = "Fully charged",
  [5] = "Pending charge",
  [6] = "Pending discharge",
  [7] = "Last"
}
local batteries = get_batteries()
local previous_charge = 0
local actual_charge = get_battery_percentage()
local is_charging = false
for _, battery in ipairs(batteries) do
  if battery.state == 1 then
    is_charging = true
  end
end

local function create_battery_widget()
  local battery_progressbar = wibox.widget {
    max_value = 100,
    value = actual_charge,
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
      for c, battery in ipairs(batteries) do
        str = str .. string.format("%s: %d%% %s" .. (c == #batteries and "" or "\n"), battery:get_object_path():match("/battery_(BAT[0-9]+)$"), battery.percentage, states[battery.state])
      end
      return str
    end,
  }

  for _, battery in ipairs(batteries) do
    battery.on_notify = function()
      actual_charge = get_battery_percentage()
      is_charging = false
      for _, bat in ipairs(batteries) do
        if bat.state == 1 then
          is_charging = true
        end
      end

      if actual_charge == previous_charge and not is_charging then
        return
      end

      previous_charge = actual_charge
      battery_progressbar.value = actual_charge
      if actual_charge < 20 then
        battery_progressbar.color = battery_low_color
      elseif battery.state == 1 then
        battery_progressbar.color = battery_charging_color
      else
        battery_progressbar.color = battery_charged_color
      end
    end
  end

  return battery_progressbar
end

return create_battery_widget()
