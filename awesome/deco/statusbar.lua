-- Standard awesome library
local gears = require("gears")
local awful     = require("awful")

-- Wibox handling library
local wibox = require("wibox")

-- Custom Local Library: Common Functional Decoration
local deco = {
  wallpaper = require("deco.wallpaper"),
  taglist   = require("deco.taglist"),
  tasklist  = require("deco.tasklist")
  wibar     = require("deco.wibar")
}

local taglist_buttons  = deco.taglist()
local tasklist_buttons = deco.tasklist()

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Wibar
-- Create a textclock widget
-- mytextclock = wibox.widget.textclock()

-- awful.screen.connect_for_each_screen(function(s)
--   -- Wallpaper
--   set_wallpaper(s)

--   -- Create a promptbox for each screen
--   s.mypromptbox = awful.widget.prompt()

--   -- config path .. "wibar"
--   -- require("/home/user/.config/awesome/deco/bar")
--   -- require"bar"
--   require'deco.wibar'

-- end)
-- }}}
