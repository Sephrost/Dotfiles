local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local rubato = require("lib.rubato")
local overflow = require("lib.overflow")

-- Color variables 
local field_bg_color = beautiful.palette.base
local center_bg_color = beautiful.palette.crust

-- Spacing variables 
local widget_padding = dpi(10)
local center_padding = dpi(12)

local listview = wibox.widget{
  forced_width = dpi(400),
  forced_height = awful.screen.focused().geometry.height * 0.7,
  spacing = dpi(10),
  layout = overflow.vertical,
}

local bin_icon = wibox.widget{
  image = gears.color.recolor_image(beautiful.icon.bin , beautiful.palette.red),
  forced_height = dpi(25),
  forced_width = dpi(25),
  widget = wibox.widget.imagebox,
}

bin_icon:connect_signal("button::press", function(_,_,_,button)
  if (button == 1) then
    listview:reset()
  end
end)

require('naughty').notify({title = "Notification Center", message = tostring(5)})

local center = awful.popup{
  visible = false,
  ontop = true,
  opacity = 1,
  bg = center_bg_color,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, dpi(10))
  end,
  placement = function(d) return awful.placement.left( d,
    {
      margins = {
        left = beautiful.useless_gap * 5 + dpi(40),
      }
    }
    )
  end ,
  widget = {
    widget = wibox.container.margin,
    margins = center_padding,
    {
      {
        {
          markup = "<span foreground='" .. beautiful.palette.text .. "'><b>Notification Center</b></span>",
          widget = wibox.widget.textbox,
        },
        {
          bin_icon,
          halign = "right",
          valign = "top",
          widget = wibox.container.place,
        },
        layout = wibox.layout.align.horizontal,
      },
      listview,
      spacing = center_padding,
      layout = wibox.layout.fixed.vertical,
    },
  },
}

local center_pos = beautiful.useless_gap * 5
local offsite_center_pos = - center.width - beautiful.useless_gap * 5

local slide = rubato.timed{
  rate = 60,
  duration = 0.2,
  easing = rubato.quadratic,
}

slide:subscribe(function(pos)
  center.x = pos
end)

center.toggle = function()
  if not center.visible then
    -- move it offscreen ad make it visible
    center.x = offsite_center_pos
    center.visible = true
    -- set animation params
    slide.pos = offsite_center_pos
    slide.target = center_pos
  else
    -- set animation params
    slide.pos = center.x
    slide.target = offsite_center_pos
    -- wait for animation to finish, otherwise it will be hidden before the animation is done
    gears.timer.start_new(0.4, function()
      center.visible = false
    end)
  end
end

awesome.connect_signal("notify_center::toggle", function()
  center.toggle()
end)

awesome.connect_signal("notification::enlist", function(n)
  local title = n.title or "No title"
  local text = n.text or "No text"
  local time = os.date("%H:%M", os.time())

  local widget = wibox.widget{
    {
      {
        {
          {
            markup = "<b>" .. title .. "</b>",
            widget = wibox.widget.textbox,
          },
          {
            text = text,
            widget = wibox.widget.textbox,
          },
          spacing = dpi(7),
          layout = wibox.layout.fixed.vertical
        },
        {
          {
            --setup color overlay0 and font 
            markup = "<span foreground='" .. beautiful.palette.subtext0 .. "'>" .. time .. "</span>",
            widget = wibox.widget.textbox,
          },
          halign = "right",
          valign = "top",
          widget = wibox.container.place,
        },
        layout = wibox.layout.stack,
      },
      margins = widget_padding,
      widget = wibox.container.margin,
    },
    bg = field_bg_color,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(10))
    end,
    widget = wibox.container.background,
  }
  widget:buttons(
    gears.table.join(
      awful.button({}, 1, function()
        listview:remove_widgets(widget)
      end)
    )
  )
  listview:add(widget)
end)

