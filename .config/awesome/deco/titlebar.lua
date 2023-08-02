-- module("anybox.titlebar", package.seeall)
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local cairo = require("lgi").cairo
local dpi = require("beautiful.xresources").apply_dpi

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function createButton(c, col,fn)
  local button = wibox.widget{
    wibox.widget.base.make_widget(),
    forced_width = dpi(8),
    shape = gears.shape.circle,
    bg = col,
    widget = wibox.container.background
  }
  -- connect signal on mouse click 
  button:connect_signal("button::press", function()
    if fn then fn() end
  end)
  return button
end



-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  local close = createButton(c, beautiful.palette.red, function() c:kill() end)
  local minimize = createButton(c, beautiful.palette.yellow, function() c.minimized = true end)

  local buttons = gears.table.join(
    awful.button({ }, 1, function()
      client.focus = c
      c:raise()
      awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c, {
      size = 25,
      position = "top",
      bg_normal = beautiful.palette.mantle,
      bg_focus = beautiful.palette.mantle,
      fg_normal = beautiful.palette.text,
      fg_focus = beautiful.palette.text,
    }) :setup {
    {
      {
        
        close,
        minimize,
        spacing = dpi(5),

        layout = wibox.layout.fixed.horizontal
      },
      {
        -- Middle
        buttons = buttons,
        layout = wibox.layout.flex.horizontal
      },
      {
        -- Left
        {
          -- Title
          {
            align  = 'center',
            widget = awful.titlebar.widget.titlewidget(c)
          },
          widget = wibox.container.constraint,
          width = 350
        },
        buttons = buttons,
        layout = wibox.layout.fixed.horizontal
      },
      layout = wibox.layout.align.horizontal
    },
    right = 10,
    left = 10,
    top = 0,
    bottom = 5,
    widget = wibox.container.margin
  } 
end)
