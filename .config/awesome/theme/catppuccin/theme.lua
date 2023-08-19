---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gears = require("gears")
local dpi = xresources.apply_dpi

local themes_path = os.getenv("HOME") .. "/.config/awesome/theme/catppuccin/"

local theme = {}

theme.fontfamily = "SauceCodePro"
theme.fontsize = 12
theme.font = theme.fontfamily .. " " .. theme.fontsize

-- catppuccin theme palette
theme.palette = {}
theme.palette.rosewater = "#f4dbd6"
theme.palette.flamingo = "#f0c6c6"
theme.palette.pink = "#f5bde6"
theme.palette.mauve = "#c6a0f6"
theme.palette.red = "#ed8796"
theme.palette.maroon = "#ee99a0"
theme.palette.peach = "#f5a97f"
theme.palette.yellow = "#eed49f"
theme.palette.green = "#a6da95"
theme.palette.teal = "#8bd5ca"
theme.palette.sky = "#91d7e3"
theme.palette.shappire = "#7dc4e4"
theme.palette.blue = "#8aadf4"
theme.palette.lavander = "#b7bdf8"
theme.palette.text = "#cad3f5"
theme.palette.subtext1 = "#b8c0e0"
theme.palette.subtext0 = "#a5adcb"
theme.palette.subtext2 = "#939ab7"
theme.palette.overlay2 = "#939ab7"
theme.palette.overlay1 = "8087a2"
theme.palette.overlay0 = "#6e738d"
theme.palette.surface2 = "#5b6078"
theme.palette.surface1 = "#494d64"
theme.palette.surface0 = "#363a4f"
theme.palette.base = "#24273a"
theme.palette.mantle = "#1e2030"
theme.palette.crust = "#181926"

theme.transparent = "#00000000"

theme.bg_normal     = theme.palette.base
theme.bg_focus      = theme.palette.blue
theme.bg_urgent     = theme.palette,red
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.palette.text
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(1)
theme.border_width  = dpi(1.5)
theme.border_normal = "#00000000"
theme.border_focus  = theme.palette.blue
theme.border_marked = "#91231c"

theme.bar_height = dpi(30)

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

theme.tooltip_bg = theme.palette.base
theme.tooltip_fg = theme.palette.text
theme.tooltip_border_width = dpi(1)
theme.tooltip_border_color = theme.palette.mauve

-- theme.taglist_fg_focus = theme.transparent
theme.taglist_bg_focus = theme.palette.blue
theme.taglist_bg_urgent = theme.palette.red
theme.taglist_bg_empty = theme.palette.crust
theme.taglist_bg_occupied = theme.palette.surface1

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."titlebar/maximized_focus_active.png"

theme.wallpaper = themes_path.."wallpapers/mountain.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."layouts/fairhw.png"
theme.layout_fairv = themes_path.."layouts/fairvw.png"
theme.layout_floating  = themes_path.."layouts/floatingw.png"
theme.layout_magnifier = themes_path.."layouts/magnifierw.png"
theme.layout_max = themes_path.."layouts/maxw.png"
theme.layout_fullscreen = themes_path.."layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."layouts/tileleftw.png"
theme.layout_tile = themes_path.."layouts/tilew.png"
theme.layout_tiletop = themes_path.."layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."layouts/spiralw.png"
theme.layout_dwindle = themes_path.."layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."layouts/cornernww.png"
theme.layout_cornerne = themes_path.."layouts/cornernew.png"
theme.layout_cornersw = themes_path.."layouts/cornersww.png"
theme.layout_cornerse = themes_path.."layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Setup user icons
theme.icon = {}
theme.icon.settings = themes_path.."icons/settings.svg"
theme.icon.volume_high = themes_path.."icons/volume_full.svg"
theme.icon.volume_low = themes_path.."icons/volume_low.svg"
theme.icon.volume_medium = themes_path.."icons/volume_medium.svg"
theme.icon.volume_mute = themes_path.."icons/volume_mute.svg"
theme.icon.brightness_low = themes_path.."icons/brightness_low.svg"
theme.icon.brightness_medium_low = themes_path.."icons/brightness_medium_low.svg"
theme.icon.brightness_medium_high = themes_path.."icons/brightness_medium_high.svg"
theme.icon.brightness_high = themes_path.."icons/brightness_high.svg"
theme.icon.cpu = themes_path.."icons/cpu.svg"
theme.icon.memory = themes_path.."icons/memory.svg"
theme.icon.ram = themes_path.."icons/ram.svg"
theme.icon.temp = themes_path.."icons/temp.svg"

-- Setup Bling Variables
theme.tag_preview_widget_border_radius = 0        -- Border radius of the widget (With AA)
theme.tag_preview_client_border_radius = 0        -- Border radius of each client in the widget (With AA)
theme.tag_preview_client_opacity = 1            -- Opacity of each client
theme.tag_preview_client_bg = "#000000"           -- The bg color of each client
theme.tag_preview_client_border_color = "#ffffff00" -- The border color of each client
theme.tag_preview_client_border_width = dpi(1)         -- The border width of each client
theme.tag_preview_widget_bg = "#000000"           -- The bg color of the widget
theme.tag_preview_widget_border_color = theme.palette.blue -- The border color of the widget
theme.tag_preview_widget_border_width = theme.border_width -- The border width of the widget
theme.tag_preview_widget_margin = 0


-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "notfound" -- temporary workaround

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
