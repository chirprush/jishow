local config = require("default_config")
local state = require("state")

function love.load(args)
   local config_file = love.filesystem.getInfo("~/.config/jishow/config.lua")
   if config_file ~= nil and config_file.type == "file" then
	  local custom_config = dofile("~/.config/jishow/config.lua")

	  local quit = false
	  for key, _ in pairs(config) do
		 if custom_config[key] == nil then
			print(string.format("error: custom config is missing key '%s'"), key)
			quit = true
		 end
	  end
	  if quit then
		 love.event.quit()
	  else
		 config = custom_config
	  end
   end
   state:load(config)
end

function love.draw()
   state:render()
end
