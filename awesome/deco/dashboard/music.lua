local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")
local bling = require("lib.bling")

local controls_size = dpi(25)
local art_size = dpi (80)
local playerctl = bling.signal.playerctl.lib()

local previous_icon = wibox.widget {
  image = gears.color.recolor_image(
    beautiful.icon.previous,
    beautiful.palette.text
  ),
  resize = false,
  forced_height = controls_size,
  forced_width = controls_size,
  widget = wibox.widget.imagebox,
}

previous_icon:connect_signal("button::press", function(_,_,_,button)
  if (button == 1) then
    playerctl:previous()
  end
end)

local next_icon = wibox.widget {
  image = gears.color.recolor_image(beautiful.icon.next, beautiful.palette.text),
  resize = false,
  forced_height = controls_size,
  forced_width = controls_size,
  widget = wibox.widget.imagebox,
}

next_icon:connect_signal("button::press", function(_,_,_,button)
  if (button == 1) then
    playerctl:next()
  end
end)

local playing = gears.color.recolor_image(beautiful.icon.play, beautiful.palette.blue)
local paused = gears.color.recolor_image(beautiful.icon.pause, beautiful.palette.blue)

local playing_icon = wibox.widget {
  image = paused,
  resize = false,
  widget = wibox.widget.imagebox,
}

playing_icon:connect_signal("button::press", function(_,_,_,button)
  if (button == 1) then
    playerctl:play_pause()
  end
end)

local art = wibox.widget {
  image = beautiful.icon.music_default,
  resize = true,
  widget = wibox.widget.imagebox,
}

local art_widget = wibox.widget {
  art,
  forced_height = art_size,
  forced_width = art_size,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, dpi(10))
  end,
  shape_clip = true,
  widget = wibox.container.background,
}


local title_label = wibox.widget {
  markup = "<b>Unknown</b>",
  font = beautiful.font,
  align = "center",
  widget = wibox.widget.textbox,
  _set_markup = function(self, text)
    self:set_markup("<b>" .. text .. "</b>")
  end
}

local artist_label = wibox.widget {
  markup = "<span foreground='" .. beautiful.palette.subtext0 .. "'>Unknown</span>",
  font = beautiful.fontfamily .. " 8",
  align = "center",
  widget = wibox.widget.textbox,
  _set_markup = function(self, text)
    self:set_markup("<span foreground='" .. beautiful.palette.subtext0 .. "'>" .. text .. "</span>")
  end
}

local music_info = wibox.widget{
  title_label,
  artist_label,
  layout = wibox.layout.align.vertical,
  spacing = dpi(1),
}

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
  title_label:set_text(title == "" and "Unknown" or title)
  artist_label:set_text(artist == "" and "Unknown" or artist)
  art.image = album_path
end)

playerctl:connect_signal("playback_status", function(_,status)
  playing_icon.image = status == "Playing" and playing or paused
end)

local music_widget = wibox.widget{
  art_widget,
  {
    music_info,
    {
      widget = wibox.container.place,
      valign = "center",
      {
        previous_icon,
        playing_icon,
        next_icon,
        layout = wibox.layout.flex.horizontal,
      },
    },
    layout = wibox.layout.align.vertical,
    spacing = dpi(3),
  },
  spacing = dpi(10),
  fill_space = true,
  layout = wibox.layout.fixed.horizontal,
}

return music_widget
