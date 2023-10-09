require'alpha'.setup(require'alpha.themes.dashboard'.config)
local dashboard = require'alpha.themes.dashboard'
dashboard.section.header.val = {
"  ██╗   ██╗███████╗ ██████╗ ██████╗ ██████╗ ███████╗",
"  ██║   ██║██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔════╝",
"  ██║   ██║███████╗██║     ██║   ██║██║  ██║█████╗  ",
"  ╚██╗ ██╔╝╚════██║██║     ██║   ██║██║  ██║██╔══╝  ",
"   ╚████╔╝ ███████║╚██████╗╚██████╔╝██████╔╝███████╗",
"    ╚═══╝  ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝",
}


dashboard.section.buttons.val = {
  dashboard.button( "e", "  New file" , ":ene <BAR> startinsert <CR>"),
  dashboard.button( "ff", "󰮗  Find file" , ":Telescope find_files <CR>"),
  dashboard.button("fo", "󱋢  Recently opened files" , ":Telescope oldfiles <CR>"),
  dashboard.button("fc", "  View command history" , ":Telescope command_history <CR>"),
  dashboard.button("fs", "󱦻  Find recent session" , ":SearchSession <CR>"),
  dashboard.button("ft", "  Change theme", ":Telescope colorscheme <CR>"),
  dashboard.button( "q", "󰅚  Quit NVIM" , ":qa<CR>"),
}
