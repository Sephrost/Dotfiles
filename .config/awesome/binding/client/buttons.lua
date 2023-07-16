-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local _M = {}
local mod = RC.vars.mod

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local clientbuttons = gears.table.join(
      awful.button{
         modifiers = {},
         button    = 1,
         on_press  = function(c) c:activate{context = 'mouse_click'} end
      },
      awful.button{
         modifiers = {mod.super},
         button    = 1,
         on_press  = function(c) c:activate{context = 'mouse_click', action = 'mouse_move'} end
      },
      awful.button{
         modifiers = {mod.super},
         button    = 3,
         on_press  = function(c) c:activate{context = 'mouse_click', action = 'mouse_resize'} end
      }
  )

  return clientbuttons
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
