local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local dashboard = require("deco.dashboard")

local settings = wibox.widget{
  {
    {
      image = gears.color.recolor_image(
        beautiful.icon.settings,
        beautiful.palette.text
      ),
      widget = wibox.widget.imagebox,
    },
    widget = wibox.container.margin,
    top = dpi(2),
    bottom = dpi(3),
  },
  widget = wibox.container.background,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end
}

settings:connect_signal("button::press", function()
  dashboard.toggle()
end)

return settings
