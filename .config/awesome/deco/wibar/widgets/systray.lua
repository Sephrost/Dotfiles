local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

local markup_shrinked = "<span color='" .. beautiful.palette.blue .. "' font='" ..
  beautiful.fontfamily .. " bold 12'>^</span>"
local markup_expanded = "<span color='" .. beautiful.palette.blue .. "' font='" ..
  beautiful.fontfamily .. " bold 12'>V</span>"

local systray_icon = wibox.widget{
  markup = markup_shrinked,
  widget = wibox.widget.textbox,
}

local systray = wibox.widget.systray(true)
systray.visible = false

local systray_widget = wibox.widget{
  {
    systray_icon,
    widget = wibox.container.margin,
    top = dpi(5),
    bottom = dpi(5),
  },
  {
    systray,
    widget = wibox.container.margin,
    left = dpi(5),
    right = dpi(5),
    bottom = dpi(5),
  },
  layout = wibox.layout.fixed.vertical,
}

systray_icon:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    systray.visible = not systray.visible
    if systray.visible then
      systray_icon.markup = markup_expanded
    else
      systray_icon.markup = markup_shrinked
    end
    -- emit a signal to update the layout
    systray_icon:emit_signal("widget::layout_changed")
  end
end)

return systray_widget
