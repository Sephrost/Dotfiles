local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local rubato = require("lib.rubato")
local overflow = require("lib.overflow")

local wallpaper_dir = os.getenv("HOME") .. "/.config/awesome/theme/catppuccin/wallpapers/"
local current_image = beautiful.wallpaper

local widget_width = dpi(500)
local widget_height = dpi(464)
local listview_height = dpi(140)

local function set_wallpaper(s,w)
  if beautiful.wallpaper then
    local wallpaper = w or beautiful.wallpaper
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
    if not w then return end

    -- local f = io.open(os.getenv("HOME") .. "/.config/awesome/theme/catppuccin/theme.lua", "r+")
    -- if f == nil then return end
    -- local content = f:read("a")
    -- local t = content:gsub("theme.wallpaper = .*\n", "theme.wallpaper = \"" .. wallpaper .. "\"\n\n")
    -- f:seek("set")
    -- f:write(t)
    -- f:close()
  end
end

local listview = wibox.widget {
  {
    layout = wibox.layout.fixed.vertical,
    id = "switcher"
  },
  forced_height = listview_height,
  layout = overflow.vertical
}

local set_wall_text = wibox.widget{
  markup = "Set As Wall",
  font   = beautiful.font .. " 12",
  widget = wibox.widget.textbox
}

set_wall_text:connect_signal("button::press", function(_, _, _, button)
  if button == 1 or button == 3 then
    for s in screen do
      set_wallpaper(s, current_image)
    end
    require("naughty").notify({
      title = "Awesome",
      text = "Wallpaper set to " .. current_image:match("([^/]+)$"),
    })
  end
end)

local imageWidget = wibox.widget {
  image = current_image,
  resize = true,
  forced_height = widget_height - listview_height,
  forced_width = widget_width,
  widget = wibox.widget.imagebox,
}

awful.screen.connect_for_each_screen(function(s)

  local close_button = wibox.widget{
    wibox.widget.base.make_widget(),
    forced_width = dpi(15),
    shape = gears.shape.circle,
    bg = beautiful.palette.red,
    widget = wibox.container.background
  }
  close_button:connect_signal("button::press", function()
    awesome.emit_signal("wallswitcher::toggle")
  end)

  local wallswitcher = wibox {
    width = widget_width,
    height = widget_height,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 10)
    end,
    bg = beautiful.palette.crust,
    ontop = true,
    visible = false,
  }

  wallswitcher:setup {
    {
      widget = wibox.container.margin,
      margins = dpi(20),
      listview,
    },
    {
      imageWidget,
      {
        wibox.widget.base.make_widget(),
        bg = beautiful.palette.base .. "55",
        widget = wibox.container.background,
      },
      {
        {
          set_wall_text,
          widget = wibox.container.margin,
          margins = 12,
        },
        widget = wibox.container.place,
        halign = 'right',
        valign = 'bottom',
      },
      layout = wibox.layout.stack
    },
    layout = wibox.layout.fixed.vertical
  }

  wallswitcher.x = s.geometry.width/2 - wallswitcher.width/2

  local widget_pos = beautiful.bar_height + beautiful.useless_gap * 8
  local offsite_widget_pos = - wallswitcher.height

  local slide = rubato.timed{
    rate = 60,
    duration = 0.2,
    easing = rubato.quadratic,
  }

  slide:subscribe(function(pos)
    wallswitcher.y = pos
  end)


  wallswitcher.update = function ()
    listview:reset()
    -- find . -maxdepth 1 , get the last 3 words
    awful.spawn.easy_async_with_shell(
      "find " .. wallpaper_dir .. " -maxdepth 1 -type f | awk -F/ '{print $NF}' | sort -R",
      function(stdout)
        for line in stdout:gmatch("[^\r\n]+") do
          local widget = wibox.widget {
            {
              widget = wibox.widget.textbox,
              font = beautiful.font .. " 12",
              markup = "<span foreground='" .. beautiful.palette.text .. "'>" .. line .. "</span>",
              image = line,
            },
            widget = wibox.container.margin,
            bottom = dpi(5),
          }
          widget:connect_signal("button::press", function(_, _, _, button)
            if button == 1 or button == 3 then
              current_image = wallpaper_dir .. line
              imageWidget.image = current_image
            end
          end)
          listview:add(widget)
        end
      end)
    end

  wallswitcher.toggle = function()
    if not wallswitcher.visible then
      wallswitcher.update()
      -- move it offscreen ad make it visible
      wallswitcher.y = offsite_widget_pos
      wallswitcher.visible = true
      -- set animation params
      slide.pos = offsite_widget_pos
      slide.target = widget_pos
    else
      -- set animation params
      slide.pos = wallswitcher.y
      slide.target = offsite_widget_pos
      -- wait for animation to finish, otherwise it will be hidden before the animation is done
      gears.timer.start_new(0.4, function()
        wallswitcher.visible = false
      end)
    end
  end

  awesome.connect_signal("wallswitcher::toggle", function()
    wallswitcher.toggle()
  end)
end)

-- setup wallpaper for each screen
awful.screen.connect_for_each_screen(set_wallpaper)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
