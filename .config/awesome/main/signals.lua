-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Custom Local Library: Common Functional Decoration
require("deco.titlebar")

-- reading
-- https://awesomewm.org/apidoc/classes/signals.html

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
  end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Set titlebar on floating windows 
local function setTitleBar(client,s)
  if s then
    if client.titlebar == nil then 
      client.emit_signal("request::titlebars", "rule", {})
    end
    awful.titlebar.show(client)
  else
    awful.titlebar.hide(client)
  end
end

-- Toggle titlebar on floating status change 
client.connect_signal("property::floating", function(c)
  setTitleBar(c, c.floating or c.first_tag and c.first_tag.layout.name == "floating")
end)

-- Hook called when a client spawns
client.connect_signal("manage", function(c)
  setTitleBar(c, c.floating or c.first_tag.layout == awful.layout.suit.floating)
end)

-- Show titlebars on tags with the floating layout
tag.connect_signal("property::layout", function(t)
  for _,c in pairs(t:clients()) do
    if t.layoout == awful.layout.suit.floating then
      setTitleBar(c, true)
    else
      setTitleBar(c, false)
    end
  end
end)
