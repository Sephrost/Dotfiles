local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

-- Load components

local function init(s)

  local components = {
    layout = require("deco.wibar.widgets.layout"),
    taglist = require("deco.wibar.widgets.taglist")(s),
    settings = require("deco.wibar.widgets.settings"),
    clock = require("deco.wibar.widgets.clock"),
    battery = require("deco.wibar.widgets.battery"),
  }

  return awful.wibar({
    position = "top",
    height = beautiful.bar_height,
    width = s.geometry.width - (beautiful.useless_gap * 2 + 6),
    screen = s,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 10)
    end,
  }):setup{
    layout = wibox.container.margin,
    top = dpi(2),
    bottom = dpi(2),
    {
      layout = wibox.layout.align.horizontal,
      -- left widgets 
      {
        layout = wibox.layout.fixed.horizontal,
        {
          components.clock,
          widget = wibox.container.margin,
          left = 10,
        }
      },
      -- middle widgets 
      {
        layout = wibox.container.place,
        halign = "center",
        valign = "center",
        components.taglist,
      },
      -- -- right widgets
      {
        layout = wibox.layout.fixed.horizontal,
        {
          {
            layout = wibox.layout.fixed.horizontal,
            awful.widget.keyboardlayout(),
            {
              layout = wibox.layout.fixed.horizontal,
              {
                components.battery,
                widget = wibox.container.margin,
                top = 3,
                bottom = 2,
                right = 3,
              },

            },
            components.settings,
            components.layout,
          },
          widget = wibox.container.margin,
          right = 10,
        }


      },
    }
  }
end

-- return init(s)
awful.screen.connect_for_each_screen(function(s)
  s.wibar = init(s)
end)

-- For each new screen, set the wibar
screen.connect_signal("request::desktop_decoration", function(s)
  s.wibox = init(s)
end)



