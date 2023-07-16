-- {{{ Global Variable Definitions
-- moved here in module as local variable
-- }}}

local home = os.getenv("HOME")

local _M = {
  -- This is used later as the default terminal and editor to run.
  -- terminal = "xterm",
  terminal = os.getenv("TERMINAL") or "kitty",
   
  -- Default modkey.
  mod = {
     alt   = "Mod1",
     -- Usually, Mod4 is the key with a logo between Control and Alt.
     super = "Mod4",
     shift = "Shift",
     ctrl  = "Control"
  },
  modkey = "Mod4",


  -- user defined wallpaper
  -- wallpaper = nil,
  wallpaper = home .. "/Images/wallpaper.jpg",
}

return _M

