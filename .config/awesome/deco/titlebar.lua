-- module("anybox.titlebar", package.seeall)

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Widget and layout library
local wibox = require("wibox")
local beautiful = require("beautiful")
local cairo = require("lgi").cairo

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function createButton(c, col,fn)
  local button = wibox.widget{
    forced_width = 15,
    forced_height = 15,
    buttons = {
      awful.button({ }, 1, fn)
    },
    shape = function (cr, width, height)
      return gears.shape.circle(cr, 15, 15)
    end,
    bg = col,
    widget = wibox.container.background
  }
  return button
end



-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  local close = createButton(c, beautiful.palette.red, function() c:kill() end)
  local maximize = createButton(c, beautiful.palette.green, function() c.maximized = not c.maximized end)
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

  local resize_buttons = gears.table.join(
    awful.button({ }, 3, function()
      awful.mouse.client.resize(c)
    end)
  )

  --titlebar with buttons on the left and title on the right
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
        {
          -- Right
          {
            close,
            maximize,
            minimize,
            spacing = 10,
            widget = wibox.container.place,
            halign = 'center',
            layout = wibox.layout.fixed.horizontal
          },
          top = 5,
          bottom = 5,
          widget = wibox.container.margin
        },
        widget = wibox.container.place,
        halign = 'center',
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
