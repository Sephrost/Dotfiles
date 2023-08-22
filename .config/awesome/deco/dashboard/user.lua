local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

local hostname = io.popen("hostname"):read("*l")
local username = io.popen("whoami"):read("*l")
local uptime = io.popen("uptime -p"):read("*l")

local fontsize = tostring(10)

local background_propic = wibox.widget{
  widget = wibox.container.background,
  bg = beautiful.palette.red,
  forced_width = dpi(70),
  forced_height = dpi(70),
  shape = gears.shape.circle,
}

local widget = wibox.widget{
  layout = wibox.layout.align.horizontal,
  {
    -- propic circle cropped 
    {
      widget = wibox.widget.imagebox,
      image = beautiful.propic,
      resize = false,
      forced_width = dpi(50),
      forced_height = dpi(50),
      clip_shape = gears.shape.circle,
    },
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
  {
    widget = wibox.widget.textbox,
    markup = "<span font=' " .. beautiful.fontfamily .. " " .. fontsize .. "' foreground='" .. beautiful.palette.mauve .. "'>  " .. uptime .."</span>",
  },

}

local update = function()
  awful.spawn.easy_async_with_shell("uptime -p", function(stdout)
    uptime = stdout
  end)
end

widget.update = update

return widget
