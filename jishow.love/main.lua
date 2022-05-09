local config = require("default_config")
local state = require("state")

function love.load(args)
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
