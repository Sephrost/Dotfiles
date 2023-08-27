local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

local hostname = io.popen("hostname"):read("*l")
local username = io.popen("whoami"):read("*l")
local uptime = io.popen("uptime -p"):read("*l")

local fontsize = tostring(11)

local uptime_widget = wibox.widget{
  widget = wibox.widget.textbox,
  markup = "<span font=' " .. beautiful.fontfamily .. " " .. fontsize .. "' foreground='" .. beautiful.palette.mauve .. "'>" .. uptime .."</span>",
}

uptime_widget.update = function()
  awful.spawn.easy_async_with_shell("uptime -p", function(stdout)
    uptime = stdout
    uptime_widget.markup = "<span font=' " .. beautiful.fontfamily .. " " .. fontsize .. "' foreground='" .. beautiful.palette.mauve .. "'>" .. uptime .."</span>"
  end)
end

local propic_widget = wibox.widget{
  widget = wibox.container.background,
  shape_clip = gears.shape.circle,
  forced_width = dpi(70),
  forced_height = dpi(70),
  bg = beautiful.palette.base,
  {
    widget = wibox.widget.imagebox,
    image = beautiful.propic,
    resize = true,
  },
}

local widget = wibox.widget{
  layout = wibox.layout.align.horizontal,
  {
    -- propic_widget,
    propic_widget,
    {
      widget = wibox.container.place,
      valign = "center",
      {
        layout = wibox.layout.fixed.vertical,
        {
          widget = wibox.widget.textbox,
          markup = "<span font=' " .. beautiful.fontfamily .. " " .. fontsize .. "' foreground='" .. beautiful.palette.blue .. "'>  " .. username .."</span>",
        },
        {
          widget = wibox.widget.textbox,
          markup = "<span font=' " .. beautiful.fontfamily .. " " .. fontsize .. "' foreground='" .. beautiful.palette.blue .. "'>  " .. hostname .."</span>",
        },
      },
    },
    layout = wibox.layout.fixed.horizontal,
    spacing = dpi(15),
  },
  nil,
  uptime_widget,
}

widget.update = uptime_widget.update

return widget
