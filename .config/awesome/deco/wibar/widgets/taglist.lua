local awful           = require('awful')
local beautiful       = require('beautiful')
local gears           = require('gears')
local wibox           = require('wibox')
local bling           = require("lib.bling") -- https://github.com/BlingCorp/bling
local rubato          = require("lib.rubato") -- https://github.com/andOrlando/rubato
local dpi             = beautiful.xresources.apply_dpi

local base_width = dpi(12) -- the width of the indicator

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

-- Bling enabling 
bling.widget.tag_preview.enable {
    show_client_content = true,  -- Whether or not to show the client content
    x = 10,                       -- The x-coord of the popup
    y = 10,                       -- The y-coord of the popup
    scale = 0.25,                 -- The scale of the previews compared to the screen
    honor_padding = false,        -- Honor padding when creating widget size
    honor_workarea = false,       -- Honor work area when creating widget size
    placement_fn = function(c)    -- Place the widget using awful.placement (this overrides x & y)
        awful.placement.top(c, {
            margins = {
                top = beautiful.bar_height + beautiful.useless_gap * 2.5,
            }
        })
    end,
    background_widget = wibox.widget {    -- Set a background image (like a wallpaper) for the widget 
        image = beautiful.wallpaper,
        horizontal_fit_policy = "fit",
        vertical_fit_policy   = "fit",
        widget = wibox.widget.imagebox
    }
}

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
      forced_width = base_width,
      forced_height = base_width,
      create_callback = function(self, tag, index, objects)

        local background_widget = self:get_children_by_id("background_role")[1]

        local update_width = function(pos)
          background_widget.forced_width = pos
        end

        self.animation = rubato.timed{
          pos = base_width,
          duration = 0.3,
          easing = rubato.linear,
        }

        self.animation:subscribe(function(pos)
          update_width(pos)
        end)

        if tag.selected then 
          self.animation.target = base_width + dpi(8)
        else
          self.animation.target = base_width
        end

        -- Bling stuff
        self:connect_signal("mouse::enter", function()
          if #tag:clients() > 0 then
            -- BLING: Update the widget with the new tag
            awesome.emit_signal("bling::tag_preview::update", tag)
            -- BLING: Show the widget
            awesome.emit_signal("bling::tag_preview::visibility", s, true)
          end
        end)

        self:connect_signal('mouse::leave', function()
          awesome.emit_signal("bling::tag_preview::visibility", s, false)
        end)

      end,
      update_callback = function(self, tag, index, objects)
        local selected = tag.selected
        if selected then
          self.animation.target = base_width + dpi(8)
        else
          self.animation.target = base_width
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
