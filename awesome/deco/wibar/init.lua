local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local rubato = require("lib.rubato")

local position = "left"
local padding = dpi(4)

local function init(s)

  local components = {
    layout = require("deco.wibar.widgets.layout"),
    taglist = require("deco.wibar.widgets.taglist")(s),
    settings = require("deco.wibar.widgets.settings"),
    clock = require("deco.wibar.widgets.clock"),
    battery = require("deco.wibar.widgets.battery"),
    keyboard = require("deco.wibar.widgets.keyboard"),
    systray = require("deco.wibar.widgets.systray"),
  }

  local bar = awful.wibar({
    position = position,
    width = dpi(40),
    screen = s,
  })

  bar:setup{
    layout = wibox.container.margin,
    margins = padding,
    {
      {
        layout = wibox.layout.align.vertical,
        -- left widgets 
        {
          layout = wibox.layout.fixed.vertical,
          {
            components.clock,
            widget = wibox.container.margin,
            top = dpi(4),
          }
        },
        -- middle widgets 
        nil,
        -- -- right widgets
        {
          layout = wibox.layout.fixed.vertical,
          spacing = dpi(4),
          {
            {
              widget = wibox.container.margin,
              top = dpi(4),
              bottom = dpi(4),
              {
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(2),
                {
                  components.systray,
                  widget = wibox.container.place,
                  halign = "center",
                },
                {
                  components.keyboard,
                  widget = wibox.container.place,
                  halign = "center",
                },
                {
                  widget = wibox.container.margin,
                  left = dpi(4),
                  right = dpi(4),
                  components.battery,
                },
              },
            },
            widget = wibox.container.background,
            bg = beautiful.palette.surface0,
            forced_width = math.huge,
            shape = function(cr, width, height)
              gears.shape.rounded_rect(cr, width, height, dpi(5))
            end,
          },
          -- components.settings,
          {
            components.layout,
            widget = wibox.container.background,
            bg = beautiful.palette.surface0,
            forced_width = math.huge,
            shape = function(cr, width, height)
              gears.shape.rounded_rect(cr, width, height, dpi(5))
            end,
          },
          {
            widget = wibox.container.margin,
            bottom = dpi(4),
          },
        },

      },

      {

        layout = wibox.container.place,
        halign = "center",
        valign = "center",
        components.taglist,
      },
      layout = wibox.layout.stack,
    }
  }
  return bar
end

-- return init(s)
awful.screen.connect_for_each_screen(function(s)
  local bar = init(s)
  s.bar = bar
  beautiful.wibar_width = dpi(40)
end)
