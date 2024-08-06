-- Standard Awesome library
local gears = require("gears")
local awful = require("awful")
-- Custom Local Library
-- local titlebar = require("anybox.titlebar")

local _M = {}
local mod = RC.vars.mod

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local clientkeys = gears.table.join(
    awful.key(
      {mod.super},
      "f",
      function (c)
        c.fullscreen = not c.fullscreen
        c:raise()
      end,
      {description = "toggle fullscreen", group = "client"}
    ),
    awful.key(
      {mod.super}, 
      "q",      
      function (c) 
        c:kill() 
        -- focus previous client
        awful.client.focus.history.previous ()
      end,
      {description = "close", group = "client"}
    ),
    awful.key(
      {mod.super, mod.ctrl},
      "f", 
      awful.client.floating.toggle,
      {description = "toggle floating", group = "client"}
    ),
    awful.key(
      {mod.super, mod.ctrl}, 
      "Return", 
      function (c) c:swap(awful.client.getmaster()) end,
      {description = "move to master", group = "client"}
    ),
    awful.key(
      {mod.super}, 
      "t",      
      function (c) c.ontop = not c.ontop  end,
      {description = "toggle keep on top", group = "client"}
    ),
    awful.key(
      {mod.super}, 
      "n",
      function (c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
      end ,
      {description = "minimize", group = "client"}
    ),
    awful.key(
      {mod.super}, 
      "m",
      function (c)
        if c.maximized then
          c.maximized = not c.maximized
          c:raise()
          if c.floating then awful.titlebar.show(c) end
        else
          local floating = awful.client.floating.get(c)
          if floating then awful.titlebar.hide(c) end
          c.maximized = not c.maximized
          c:raise()
          if not floating then awful.titlebar.hide(c) end
        end
      end ,
      {description = "(un)maximize", group = "client"}
    ),
    awful.key(
      { mod.super,mod.ctrl}, 
      "m",
      function (c)
        c.maximized_vertical = not c.maximized_vertical
        if c.maximized_vertical then
          awful.titlebar.hide(c)
        end
        c:raise()
      end ,
      {description = "(un)maximize vertically", group = "client"}
    ),
    awful.key(
      { mod.super,mod.shift}, 
      "m",
      function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
      end ,
      {description = "(un)maximize horizontally", group = "client"}
    )
  )

  return clientkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
