local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi
local wibox = require("wibox")
local naughty = require("naughty")

local powerofficon = ""
local rebooticon = ""
local suspendicon = "󰒲"
local exiticon = "󰗼"
local lockicon = ""

local function poweroff ()
    naughty.notify({title = "Poweroff", text = "Shutting down...", timeout = 5})
    awful.spawn.with_shell("systemctl poweroff")
    awesome.emit_signal("powermenu::toggle")
end

local function reboot ()
    naughty.notify({title = "Reboot", text = "Rebooting...", timeout = 5})
    awful.spawn.with_shell("systemctl reboot")
    awesome.emit_signal("powermenu::toggle")
end

local function suspend ()
    naughty.notify({title = "Suspend", text = "Suspending...", timeout = 5})
    awful.spawn.with_shell("systemctl suspend")
    awesome.emit_signal("powermenu::toggle")
end

local function exit ()
  naughty.notify({title = "Exit", text = "Exiting awesome...", timeout = 5})
  awesome.quit()
end

local function lock ()
  naughty.notify({title = "Lock", text = "Locking...", timeout = 5})
  awful.spawn.with_shell("betterlockscreen -l")
  awesome.emit_signal("toggle::lock")
end

local function makeButton(icon, text, action)
  local button = wibox.widget{
    {
      {
        {
          -- text is black
          markup = "<span foreground='#" .. beautiful.palette.red .."'>" .. icon .. "</span>",
          text = icon,
          font = "SauceCodePro 24",
          align = "center",
          valign = "center",
          widget = wibox.widget.textbox
        },
        margins = dpi(10),
        widget = wibox.container.margin
      },
      forced_width = dpi(80),
      forced_height = dpi(80),
      bg = beautiful.palette.surface1 .. "90",
      shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 5)
      end,
      widget = wibox.container.background,
    },
    -- Text to describe the button
    {
      text = text,
      align = "center",
      font = beautiful.font,
      widget = wibox.widget.textbox
    },
    spacing = dpi(10),
    layout = wibox.layout.fixed.vertical,
  }
  -- attach button signals button::press 
  button:connect_signal("button::press", function() action() end)
  return button
end

-- Buttons definition
local poweroffButton = makeButton(powerofficon, "Poweroff", poweroff)
local rebootButton = makeButton(rebooticon, "Reboot", reboot)
local suspendButton = makeButton(suspendicon, "Suspend", suspend)
local exitButton = makeButton(exiticon, "Exit", exit)
local lockButton = makeButton(lockicon, "Lock", lock)

local widget = {
  {
    poweroffButton,
    rebootButton,
    suspendButton,
    exitButton,
    lockButton,
    spacing = dpi(30),
    layout = wibox.layout.fixed.horizontal,
  },
  widget = wibox.container.place,
  halign = "center",
  valign = "center",
}

local grabber = awful.keygrabber ({
  auto_start          = true,
  stop_event          = "release",
  keypressed_callback = function(_, _, key, _)
    if key == "Escape" or key == "q" then
      awesome.emit_signal("powermenu::hide")
    elseif key == "p" then
      poweroff()
    elseif key == "r" then
      reboot()
    elseif key == "s" then
      suspend()
    elseif key == "e" then
      exit()
    elseif key == "l" then
      lock()
    end

  end
})

local function setImage()
  os.execute("mkdir -p ~/.cache/awesome/blur")
  local cmd = "convert -modulate 50 -filter Gaussian -blur 0x8 " .. 
    beautiful.wallpaper .. "~/.cache/awesome/blur/lockscreen.png"
  awful.spawn.with_shell(cmd)
end

setImage()

awful.screen.connect_for_each_screen(function(s)

  -- Setup background image 
  local back = wibox.widget {
    id = "bg",
    widget = wibox.widget.imagebox,
    resize = true,
    forced_height = s.geometry.height,
    forced_width = s.geometry.width,
    image = "~/.cache/awesome/blur/lockscreen.png",
  }

  local exit = wibox({ 
    screen = s,
    visible = false,
    ontop = true,
    height = s.geometry.height, 
    width = s.geometry.width,
    bg = "#00000055", -- transparent
  })

  -- setup exit menu stacking 
  exit:setup {
    back,
    widget,
    layout = wibox.layout.stack,
  }

  awful.placement.centered(exit)

  -- signals 
  awesome.connect_signal("powermenu::toggle", function()
    if exit.visible then
      exit.visible = false
      grabber:stop()
    else
      exit.visible = true
      grabber:start()
    end
  end)

  awesome.connect_signal("powermenu::hide", function()
    exit.visible = false
    grabber:stop()
  end)

end)

