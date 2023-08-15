-- Standard awesome libramy
local gears = require("gears")
local awful = require("awful")
local menu = require("main.menu")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
-- local hotkeys_popup = require("awful.hotkeys_popup")
-- Menubar library
local menubar = require("menubar")

-- Resource Configuration
local terminal = RC.vars.terminal
local mod = RC.vars.mod
local _M = {}

-- reading
-- https://awesomewm.org/wiki/Global_Keybindings

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local globalkeys = gears.table.join(

     -- general awesome keys
    awful.key(
      {mod.super},
      "s",
      hotkeys_popup.show_help,
      {description="show help", group="awesome"}
    ),
     awful.key(
        {mod.super},
        'w',
        function() RC.mainmenu:show() end,
        {description="show main menu", group="awesome"}
     ),
     awful.key(
        {mod.super, mod.ctrl},
        'r',
        awesome.restart,
        {description="reload awesome", group="awesome"}
     ),
     awful.key(
        {mod.super, mod.shift},
        'q',
        awesome.quit,
        {description="quit awesome", group="awesome"}
     ),
     awful.key(
        {mod.super},
        'x',
        function() awesome.emit_signal("powermenu::toggle") end,
        {description="show powermenu", group="awesome"}
     ),
     awful.key(
        {mod.super},
        'd',
        function() awesome.emit_signal("dashboard::toggle") end,
        {description="show dashboard", group="awesome"}
     ),

     -- Launcher related keybindings
     awful.key(
        {mod.super},
        'Return',
        function() awful.spawn(terminal) end,
        {description="open a terminal", group="launcher"}
     ),
     awful.key(
        {mod.super},
        'r',
        function() awful.screen.focused().mypromptbox:run() end,
        {description="run prompt(drun)", group="launcher"}
     ),
     awful.key(
        {mod.super},
        'p',
        function() menubar.show() end,
        {description="show the menubar", group="launcher"}
     ),
     awful.key(
        {mod.alt},
        'space',
        function() awful.spawn("rofi -show drun") end,
        {description="show rofi", group="launcher"}
     ),

     -- Tag related keybindings
     awful.key(
        {mod.ctrl, mod.super},
        'k',
        function()
          awful.tag.viewprev()
          local c = awful.client.getmaster()
          if c then
            client.focus = c
            c:raise()
          end
        end,
        {description="focus previous", group="tag"}
     ),
     awful.key(
        {mod.ctrl, mod.super},
        'j',
        function()
          awful.tag.viewnext()
          local c = awful.client.getmaster()
          if c then
            client.focus = c
            c:raise()
          end
        end,
        {description="focus next", group="tag"}
     ),
     awful.key(
        {mod.ctrl, mod.super},
        'b',
        awful.tag.history.restore,
        {description="focus previous focused tag", group="tag"}
     ),
     awful.key(
        {mod.super},
        'numrow',
        function(index)
           local screen = awful.screen.focused()
           local tag = screen.tags[index]
           if tag then
              tag:view_only()
           end
        end,
        {description="focus tag by num", group="tag"}
     ),
     -- TODO, fix those
     awful.key(
        {mod.super, mod.shift},
        'numrow',
        function(index)
           if client.focus then
              local tag = client.focus.screen.tags[index]
              if tag then
                 client.focus:move_to_tag(tag)
              end
           end
        end,
        {description="move focused client to tag", group="tag"}
     ),
     awful.key{
        modifiers   = {mod.super, mod.ctrl, mod.shift},
        keygroup    = 'numrow',
        description = 'toggle focused client on tag',
        group       = 'tag',
        on_press    = function(index)
           if client.focus then
              local tag = client.focus.screen.tags[index]
              if tag then
                 client.focus:toggle_tag(tag)
              end
           end
        end,
     },

     -- Client related keybindings
     awful.key(
        {mod.super},
        'j',
        function()
          -- if no client is focused, then focus the first one
          if client.focus then
            if #awful.screen.focused().clients == 1 then
              awful.client.focus.byidx(1)
              return
            end
          else
            --get te first client, unminimalize it and focus it
            local c = awful.client.restore()
            if c then
              client.focus = c
              return
            end
          end
          awful.client.focus.byidx(1)
        end,
        {description="focus next by index", group="client"}
     ),
     awful.key(
        {mod.super},
        'k',
        function()
          -- if no client is focused, then focus the first one
          if client.focus then
            if #awful.screen.focused().clients == 1 then
              awful.client.focus.byidx(-1)
              return
            end
          else
            --get te first client, unminimalize it and focus it
            local c = awful.client.restore()
            if c then
              client.focus = c
              return
            end
          end
          awful.client.focus.byidx(-1)
        end,
        {description="focus previous by index", group="client"}
     ),
     awful.key(
        {mod.super},
        'b',
        function()
           awful.client.focus.history.previous()
           if client.focus then
              client.focus:raise()
           end
        end,
        {description="focus previous focused", group="client"}
     ),
     awful.key(
        {mod.super, mod.ctrl},
        'n',
        function()
           local c = awful.client.restore()
           if c then
              c:active{raise = true, context = 'key.unminimize'}
           end
        end,
        {description="restore minimized", group="client"}
     ),
     awful.key(
        {mod.super, mod.shift},
        'j',
        function() awful.client.swap.byidx(1) end,
        {description="swap with next client by index", group="client"}
     ),
     awful.key(
        {mod.super, mod.shift},
        'k',
        function() awful.client.swap.byidx(-1) end,
        {description="swap with previous client by index", group="client"}
     ),
     awful.key(
        {mod.super},
        'u',
        awful.client.urgent.jumpto,
        {description="jump to urgent client", group="client"}
     ),

     -- Screen related keybindings
     awful.key(
        {mod.super, mod.alt},
        'j',
        function() awful.screen.focus_relative(1) end,
        {description="focus the next screen", group="screen"}
     ),
     awful.key(
        {mod.super, mod.alt},
        'k',
        function() awful.screen.focus_relative(-1) end,
        {description="focus the previous screen", group="screen"}
     ),

     -- layout related keybindings
     awful.key{
        modifiers   = {mod.super},
        key         = 'l',
        description = 'increase master width factor',
        group       = 'layout',
        on_press    = function() awful.tag.incmwfact(0.05) end,
     },
     awful.key{
        modifiers   = {mod.super},
        key         = 'h',
        description = 'decrease master width factor',
        group       = 'layout',
        on_press    = function() awful.tag.incmwfact(-0.05) end,
     },
     awful.key{
        modifiers   = {mod.super, mod.shift},
        key         = 'h',
        description = 'increase the number of master clients',
        group       = 'layout',
        on_press    = function() awful.tag.incnmaster(1, nil, true) end,
     },
     awful.key{
        modifiers   = {mod.super, mod.shift},
        key         = 'l',
        description = 'decrease the number of master clients',
        group       = 'layout',
        on_press    = function() awful.tag.incnmaster(-1, nil, true) end,
     },
     awful.key{
        modifiers   = {mod.super, mod.ctrl},
        key         = 'h',
        description = 'increase the number of columns',
        group       = 'layout',
        on_press    = function() awful.tag.incncol(1, nil, true) end,
     },
     awful.key{
        modifiers   = {mod.super, mod.ctrl},
        key         = 'l',
        description = 'decrease the number of columns',
        group       = 'layout',
        on_press    = function() awful.tag.incncol(-1, nil, true) end,
     },
     awful.key(
        {mod.super},
        'space',
        function() awful.layout.inc(1) end,
        {description="select next", group="layout"}
     ),
     awful.key(
        {mod.super, mod.shift},
        'space',
        function() awful.layout.inc(-1) end,
        {description="select previous", group="layout"}
     ),
     awful.key{
        modifiers   = {mod.super},
        keygroup    = 'numpad',
        description = 'select layout directly',
        group       = 'layout',
        on_press    = function(index)
           local tag = awful.screen.focused().selected_tag
           if tag then
              tag.layout = tag.layouts[index] or tag.layout
           end
        end
     }
  )
  
  return globalkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
