local config = {}

local function color(hex)
   return {
	  r = (math.floor(hex / 2 ^ 16) % 2 ^ 8) / 255,
	  g = (math.floor(hex / 2 ^ 8) % 2 ^ 8) / 255,
	  b = (math.floor(hex) % 2 ^ 8) / 255,
	  a = 1
   }
end

config.themes = {
   {
	  bg = color(0x000000),
	  fg = color(0xffffff)
   },
   {
	  bg = color(0x61afef),
	  fg = color(0xffffff)
   },
   {
	  bg = color(0x546f8d),
	  fg = color(0xffffff)
   },
   {
	  bg = color(0xde437c),
	  fg = color(0xffffff)
   },
   {
	  bg = color(0x2a3a92),
	  fg = color(0xffffff)
   },
   {
	  bg = color(0xdada00),
	  fg = color(0xffffff)
   },
}

config.autoscroll_delay = 5
config.timebar_height = 10

config.font = "fonts/NotoRegularJP.otf"
config.bold_font = "fonts/NotoMediumJP.otf"

config.max_length = 3


return config
