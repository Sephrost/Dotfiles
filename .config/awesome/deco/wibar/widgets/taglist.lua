local awful           = require('awful')
local beautiful       = require('beautiful')
local gears           = require('gears')
local wibox           = require('wibox')
local bling           = require("lib.bling") -- https://github.com/BlingCorp/bling
local rubato          = require("lib.rubato") -- https://github.com/andOrlando/rubato
local dpi             = beautiful.xresources.apply_dpi

local base_width = dpi(8) -- the width of the indicator

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({}, 3, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end)
  )

local generate_taglist = function(s)
  local taglist = awful.widget.taglist{
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
    style = {
      -- rounded rect that looks like a circle
      shape = gears.shape.rounded_rect,
    },
    layout = {
      spacing = dpi(10),
      layout = wibox.layout.fixed.horizontal
    },
    widget_template = {
      {
        widget = wibox.container.margin,
        margin = base_width/2,
      },
      id = "background_role",
      widget = wibox.container.background,
      shape = gears.shape.circle,
      forced_width = dpi(8),
      forced_height = dpi(8),
      create_callback = function(self, tag, index, objects)

        local background_widget = self:get_children_by_id("background_role")[1]

        local update_width = function(pos)
          background_widget.forced_width = pos
        end

        self.animation = rubato.timed{
          pos = dpi(8),
          duration = 0.3,
          easing = rubato.linear,
        }

        self.animation:subscribe(function(pos)
          update_width(pos)
        end)

        if tag.selected then 
          self.animation.target = dpi(15)
        else
          self.animation.target = dpi(8)
        end

      end,
      update_callback = function(self, tag, index, objects)
        local selected = tag.selected
        if selected then
          self.animation.target = dpi(15)
        else
          self.animation.target = dpi(8)
        end
      end
    },
  }

  local wrapper = wibox.widget{
    widget = wibox.container.background,
    {
      widget = wibox.container.margin,
      top = dpi(3),
      bottom = dpi(3),
      left = dpi(5),
      right = dpi(5),
      taglist,
    }
  }

  wrapper:connect_signal("button::press", function(_, _, _, button)
    if button == 4 then
      awful.tag.viewprev()
    elseif button == 5 then
      awful.tag.viewnext()
    end
  end)



  return wrapper
end

return generate_taglist
