local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")



layout_box = awful.widget.layoutbox(s)
layout_box:buttons(
  gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc(1) end), 
    awful.button({ }, 3, function () awful.layout.inc(-1) end), 
    awful.button({ }, 4, function () awful.layout.inc(1) end), 
    awful.button({ }, 5, function () awful.layout.inc(-1) end) 
    ))
return layout_box
