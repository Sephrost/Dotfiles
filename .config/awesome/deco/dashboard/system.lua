local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")
local rubato = require("lib.rubato")


local function make_rounded_progressbar(icon, color,fn)
  local progressbar = wibox.widget {
    {
      {
        {
          {
            widget = wibox.widget.imagebox,
            image = gears.color.recolor_image( 
              icon,
              beautiful.palette.text
            ),
            -- forced_width = dpi(5),
            -- forced_height = dpi(5),
          },
          max_value = 100,
          min_value = 0,
          -- start from top and follow clockwise
          start_angle = 4.71238898,
          forced_height = dpi(30),
          forced_width = dpi(30),
          paddings = dpi(5),
          rounded_edge = true,
          colors = {color},
          id = "target",
          widget = wibox.container.arcchart,
        },
        widget = wibox.container.mirror,
        reflection = {
          vertical = false,
          horizontal = true,
        },
      },
      margins = dpi(5),
      widget = wibox.container.margin
    },
    -- bg = beautiful.bg_normal,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 5)
    end,
    widget = wibox.container.background
  }

  progressbar.update = function()
    local widget = progressbar:get_children_by_id("target")[1]
    fn(widget) 
  end

  return progressbar
end

-- Why i have to use this value as backup is a mistery to me,
-- if i try to use target.value it results to nil even after the first iteration 
-- and i can't understand why
local cpu_value_bak = 0

local cpu_value = function(target)
  local cmd = "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1}'"
  local animation = rubato.timed{
    pos = cpu_value_bak,
    duration = 0.3,
    easing = rubato.quadratic,
  }

  animation:subscribe(function(pos)
    target.value = pos
  end)

  awful.spawn.easy_async_with_shell(cmd, function(stdout)
    animation.pos = cpu_value_bak
    animation.target = tonumber(stdout)
    cpu_value_bak = tonumber(stdout)
  end)

end

local ram_value_bak = 0

local ram_value = function(target)
  local cmd = "free | grep Mem | awk '{print $3/$2 * 100.0}'"
  local animation = rubato.timed{
    pos = ram_value_bak,
    duration = 0.3,
    easing = rubato.quadratic,
  }

  animation:subscribe(function(pos)
    target.value = pos
  end)
  awful.spawn.easy_async_with_shell(cmd, function(stdout)
    animation.pos = ram_value_bak
    animation.target = tonumber(stdout)
    ram_value_bak = tonumber(stdout)
  end)
end

local temp_value = function(target)
  target.value = 50
end

return {
  cpu = make_rounded_progressbar(beautiful.icon.cpu, beautiful.palette.peach, cpu_value),
  ram = make_rounded_progressbar(beautiful.icon.ram, beautiful.palette.yellow, ram_value),
  temp = make_rounded_progressbar(beautiful.icon.temp, beautiful.palette.red, temp_value),
}
