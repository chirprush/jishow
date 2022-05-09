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
	  fg = color(0xffffff),
   },
   {
	  bg = color(0x282828),
	  fg = color(0xffffff),
   },
   {
	  bg = color(0xdfdfdf),
	  fg = color(0x000000),
   },
   {
	  bg = color(0xffffff),
	  fg = color(0x000000),
   },
}

config.autoscroll_delay = 5
config.timebar_height = 10

config.font = "fonts/NotoRegularJP.otf"
config.bold_font = "fonts/NotoMediumJP.otf"

config.max_length = 3


return config
