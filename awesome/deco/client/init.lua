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

-- Size Variables
local icon_size = dpi(43)
local icon_spacing = dpi(13)
local wrapper_padding = dpi(2)

awful.screen.connect_for_each_screen(function(s)
  local widget = awful.popup{
    visible = false,
    ontop = true,
    opacity = 1,
    bg = center_bg_color,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(10))
    end,
    placement = function(d)
      return awful.placement.bottom( d, {
        margins = {
          bottom = beautiful.useless_gap * 5,
        }
      })
    end,
    widget = {
      color = field_bg_color,
      widget = wibox.widget.background,
    }
  }

   widget.x = s.geometry.width/2 - widget.width/2

   local widget_pos = s.geometry.height - widget.height - beautiful.useless_gap
   * 5 - icon_size - wrapper_padding
   local offsite_widget_pos = s.geometry.height + beautiful.useless_gap * 5

   local slide = rubato.timed{
     rate = 60,
     duration = 0.2,
     easing = rubato.quadratic,
   }

   slide:subscribe(function(pos)
     widget.y = pos
   end)

   widget.toggle = function()
     if not widget.visible then
       -- move it offscreen ad make it visible
       widget.y = offsite_widget_pos
       widget.visible = true
       -- set animation params
       slide.pos = widget.y
       slide.target = widget_pos
     else
       -- set animation params
       slide.pos = widget.y
       slide.target = offsite_widget_pos
       -- wait for animation to finish, otherwise it will be hidden before the animation is done
       gears.timer.start_new(0.4, function()
         widget.visible = false
       end)
     end
   end

   local function dump(o)
     if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
     else
       return tostring(o)
     end
   end
   -- get clients from all tags
   -- The map has the following structure:
   -- {
   --   [tag] = {
   --     [client_class] = {
   --     [1] = client,
   --     [2] = client,
   --     ...
   --     }
   --     ...
   --   }
   --  ...
   --  }
   local get_clients = function()
     local clients = {}
     -- local tags = s.tags
     local tags = awful.screen.focused().tags
     -- local f = io.open("/tmp/test", "w")
     -- if not f then return end
     -- -- f:write(dump(tags))
     -- f:write(dump(tags[1]:clients()[1].class))
     -- f:close()

     for _, tag in tags do
       if not tag then break end
       local f = io.open("/tmp/test", "w")
       if not f then return end
       f:write(dump(tag:clients()))
       f:close()

       local tag_clients = tag:clients()
       if not tag_clients or #tag_clients == 0 then break end
       if not clients[tag or ""] then clients[tag or ""] = {} end
       for _, c in ipairs(tag_clients) do
         if not c.skip_taskbar then
           -- Initialize map for client class 
           if not clients[tag or ""][c.class] then
             clients[tag or ""][c.class] = {}
           end
           -- Append client to map
           clients[tag or ""][c.class][#clients[tag or ""][c.class] + 1] = c
         end
       end
      end

     -- for _, c in ipairs(s.all_clients) do
     --   if not c.skip_taskbar then
     --     -- Initialize map for client class 
     --     if not clients[c.class] then
     --       clients[c.class] = {}
     --     end
     --     -- Append client to map
     --     clients[c.class][#clients[c.class] + 1] = c
     --   end
     -- end
     return clients
   end

   -- make icon widget list from clients and return it
   local create_icon_list = function(clients)
     local llayout = wibox.widget{
       spacing = icon_spacing,
       layout = wibox.layout.fixed.horizontal,
     }

     local wrap_widget = wibox.widget{
       {
        llayout,
        margins = wrapper_padding,
        widget = wibox.container.margin,
       },
       layout = wibox.layout.fixed.vertical,
       widget = wibox.container.background
     }

     for _, tag in pairs(clients) do
       for _, c in pairs(tag) do
         if not c then break end
         local icon_widget = wibox.widget{
           -- if not c[1] then break end
           image = c[1].icon,
           forced_height = icon_size,
           forced_width = icon_size,
           widget = wibox.widget.imagebox,
         }
         -- append to wrap 
         llayout:add(icon_widget)
       end
     end

     return wrap_widget
   end



   awesome.connect_signal("client_list::toggle", function()
     local clients = get_clients()
     -- dump clients to /tmp/test

     local icons_widget = create_icon_list(clients)
     widget.widget.widget = icons_widget
     widget.toggle()
   end)

 end)
