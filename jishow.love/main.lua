local config = require("default_config")
local state = require("state")

function love.load(args)
   local config_file = love.filesystem.getInfo("~/.config/jishow/config.lua")
   if config_file ~= nil and config_file.type == "file" then
	  local custom_config = dofile("~/.config/jishow/config.lua")

	  for key, value in pairs(custom_config) do
		 config[key] = value
	  end
   end
   state:load(config)
end

function love.update(dt)
   state:update(dt)
end

function love.keypressed(key, _scancode, _isrepeat)
   state:key(key)
end

function love.draw()
   state:render()
end
