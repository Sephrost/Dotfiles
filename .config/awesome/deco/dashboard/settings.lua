local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi

local wifi_icon = ""
local bluetooth_icon = ""
local dnd_icon = ""
local dnd_color = beautiful.palette.flamingo
local battery_save_icon = "󱟦"

local function getWifiButton()
    local textbox = wibox.widget {
      widget = wibox.widget.textbox,
      text = wifi_icon,
      font = "SauceCodePro 17",
      align = "center",
    }

    local widget = wibox.widget {
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

    local markup_selected = "<span foreground='" .. beautiful.palette.mantle .. "'>" .. wifi_icon .. "</span>"
    local markup_unselected = "<span foreground='" .. beautiful.palette.text .. "'>" .. wifi_icon .. "</span>"

    local setup_markup = function (selected)
      textbox.markup = selected and markup_selected or markup_unselected
      if selected then
        widget.bg = beautiful.bg_focus
      else
        widget.bg = beautiful.palette.mantle
      end
    end

    widget.selected = false


    local tooltip_flavor_text = ""
    widget.tooltip = awful.tooltip {
      objects = {widget},
      timer_function = function ()
        return tooltip_flavor_text
      end
    }

    widget.update = function ()

      awful.spawn.easy_async_with_shell(
        "nmcli radio wifi",
        function(stdout)
          --strip new line 
          stdout = stdout:gsub("^%s*(.-)%s*$", "%1")
          if stdout == "enabled" then
            widget.selected = true
          else
            widget.selected = false
          end
          setup_markup(widget.selected)
        end
      )

      awful.spawn.easy_async_with_shell(
        "nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2",
        function(stdout)
          --strip new line 
          stdout = stdout:gsub("^%s*(.-)%s*$", "%1")
          if stdout == "" then
            tooltip_flavor_text = "No wifi connection"
          else
            tooltip_flavor_text = "Connected to " .. stdout
          end
        end
      )
    end

    local function toggle()
      widget.selected = not widget.selected
      if widget.selected then
        awful.spawn.easy_async_with_shell(
          "nmcli radio wifi on"
        )
      else
        awful.spawn.easy_async_with_shell(
          "nmcli radio wifi off"
        )
        widget.tooltip.visible = false
      end
      setup_markup(widget.selected)
    end

    widget:connect_signal("button::press", function(_,_,_,button)
      if button == 1 then
        toggle()
      elseif button == 3 then
        awful.spawn("kitty --class nmtui -e nmtui")
      end
    end)

    return widget
end

local function getBluetoothButton()
    local textbox = wibox.widget {
      widget = wibox.widget.textbox,
      text = bluetooth_icon,
      font = "SauceCodePro 17",
      align = "center",
    }

    local widget = wibox.widget {
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

    local markup_selected = "<span foreground='" .. beautiful.palette.mantle .. "'>" .. bluetooth_icon .. "</span>"
    local markup_unselected = "<span foreground='" .. beautiful.palette.text .. "'>" .. bluetooth_icon .. "</span>"

    local setup_markup = function (selected)
      textbox.markup = selected and markup_selected or markup_unselected
      if selected then
        widget.bg = beautiful.bg_focus
      else
        widget.bg = beautiful.palette.mantle
      end
    end

    widget.selected = false

    local tooltip_flavor_text = ""
      widget.tooltip = awful.tooltip {
        objects = {widget},
        timer_function = function ()
          return tooltip_flavor_text
        end
      }

    widget.update = function ()

      awful.spawn.easy_async_with_shell(
        "echo 'show' | bluetoothctl | grep Powered",
        function(stdout)
          --strip new line 
          stdout = stdout:gsub("^%s*(.-)%s*$", "%1")
          if stdout == "Powered: yes" then
            widget.selected = true
          else
            widget.selected = false
          end
          setup_markup(widget.selected)
        end
      )

      awful.spawn.easy_async_with_shell(
        "echo 'info' | bluetoothctl | grep Name",
        function(stdout)
          --strip new line 
          stdout = stdout:gsub("^%s*(.-)%s*$", "%1")
          if stdout == "" then
            tooltip_flavor_text = "No bluetooth connection"
          else
            tooltip_flavor_text = "Connected to " .. stdout:sub(7)
          end
        end
      )
    end

    local function toggle()
      widget.selected = not widget.selected
      if widget.selected then
        awful.spawn.easy_async_with_shell(
          "bluetoothctl power on"
        )
      else
        awful.spawn.easy_async_with_shell(
          "bluetoothctl power off"
        )
        widget.tooltip.visible = false
      end
      setup_markup(widget.selected)
    end

    widget:connect_signal("button::press", function(_,_,_,button)
      if button == 1 then
        toggle()
      else if button == 3 then
        awful.spawn("kitty --class bluetuith -e bluetuith")
      end
    end
    end)

  return widget
end

local function getBatterySaveButton()
    local textbox = wibox.widget {
      widget = wibox.widget.textbox,
      text = battery_save_icon,
      font = "SauceCodePro 17",
      align = "center",
    }

    local widget = wibox.widget {
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

    local markup_selected = "<span foreground='" .. beautiful.palette.mantle .. "'>" .. battery_save_icon .. "</span>"
    local markup_unselected = "<span foreground='" .. beautiful.palette.text .. "'>" .. battery_save_icon .. "</span>"

    local setup_markup = function (selected)
      textbox.markup = selected and markup_selected or markup_unselected
      if selected then
        widget.bg = beautiful.bg_focus
      else
        widget.bg = beautiful.palette.mantle
      end
    end

    widget.selected = false

    widget.update = function ()
      awful.spawn.easy_async_with_shell(
        "tlp-stat -s | grep State",
        function(stdout)
          --strip new line 
          stdout = stdout:gsub("^%s*(.-)%s*$", "%1")
          if stdout == "State          = enabled" then
            widget.selected = true
          else
            widget.selected = false
          end
          setup_markup(widget.selected)
        end
      )
    end

    local function toggle()
      widget.selected = not widget.selected
      setup_markup(widget.selected)
    end

    widget:connect_signal("button::press", function(_,_,_,button)
      if button == 1 then
        -- toggle()
      end
    end)

  return widget
end

local function getDNDButton()
  local textbox = wibox.widget {
    widget = wibox.widget.textbox,
    text = dnd_icon,
    font = "SauceCodePro 17",
    align = "center",
  }

  local widget = wibox.widget {
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

  local markup_selected = "<span foreground='" .. beautiful.palette.mantle .. "'>" .. dnd_icon .. "</span>"
  local markup_unselected = "<span foreground='" .. beautiful.palette.text .. "'>" .. dnd_icon .. "</span>"

  local setup_markup = function (selected)
    textbox.markup = selected and markup_selected or markup_unselected
    if selected then
      widget.bg = beautiful.bg_focus
    else
      widget.bg = beautiful.palette.mantle
    end
  end

  widget.selected = false

  widget.update = function ()
    local naughty = require("naughty")
    if naughty.is_suspended() then
      widget.selected = true
    else
      widget.selected = false
    end
  end

  local function toggle()
    local naughty = require("naughty")
    widget.selected = not widget.selected
    if widget.selected then
      naughty.suspend()
    else
      naughty.resume()
    end
    setup_markup(widget.selected)
  end

  widget:connect_signal("button::press", function(_,_,_,button)
    if button == 1 then
      toggle()
    end
  end)

  return widget
end


local wifi_button = getWifiButton()
local bluetooth_button = getBluetoothButton()
local battery_button = getBatterySaveButton()
local airplane_button = getDNDButton()

return {
  wifi = wifi_button,
  bluetooth = bluetooth_button,
  battery = battery_button,
  dnd = airplane_button
}
