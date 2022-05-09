local dict = require("dict")

local State = {}
State.__index = State

function State:load(config)
   math.randomseed(os.time())

   love.window.setTitle("字show")
   love.window.setMode(
	  self.width,
	  self.height,
	  {
		 resizable = false,
		 centered = true,
	  }
   )
   self.config = config

   self.autoscroll_cooldown = config.autoscroll_delay

   self.kanji_font = love.graphics.newFont(config.font, 120)
   self.label_font = love.graphics.newFont(config.bold_font, 15)
   self.info_font = love.graphics.newFont(config.font, 15)

   self.current_kanji_slide = 0
   self.kanji_slides = {}
   self.kanji_dict = dict
   self:new_kanji()
end

function State:new_kanji()
   if #self.kanji_slides == #self.kanji_dict then
	  return
   end

   local slide = self.kanji_dict[math.random(#self.kanji_dict)]

   while true do
	  local continue = false
	  for i, s in ipairs(self.kanji_slides) do
		 if slide.kanji == s.kanji then
			slide = self.kanji_dict[math.random(#self.kanji_dict)]
			continue = true
			break
		 end
	  end
	  if not continue then
		 break
	  end
   end

   slide.kun = {unpack(slide.kun, 1, self.config.max_length)}
   slide.on = {unpack(slide.on, 1, self.config.max_length)}
   slide.meanings = {unpack(slide.meanings, 1, self.config.max_length)}
   slide.theme = self.config.themes[math.random(#self.config.themes)]

   table.insert(self.kanji_slides, slide)
   self.current_kanji_slide = #self.kanji_slides
end

function State:scroll(dir)
   self.current_kanji_slide = self.current_kanji_slide + dir
   if self.current_kanji_slide < 1 then
	  self.current_kanji_slide = 1
   elseif self.current_kanji_slide > #self.kanji_slides then
	  self.current_kanji_slide = #self.kanji_slides
   end
end

function State:key(key)
   if key == "q" then
	  love.event.quit()
   elseif key == "p" then
	  self.paused = not self.paused
   elseif key == "n" then
	  self.paused = true
	  self:new_kanji()
   elseif key == "right" then
	  self.paused = true
	  self:scroll(1)
   elseif key == "left" then
	  self.paused = true
	  self:scroll(-1)
   end
end

function State:update(dt)
   if self.paused then
	  self.autoscroll_cooldown = self.config.autoscroll_delay
	  return
   end
   self.autoscroll_cooldown = self.autoscroll_cooldown - dt
   if self.autoscroll_cooldown < 0 then
	  self.autoscroll_cooldown = self.config.autoscroll_delay
	  self:new_kanji()
   end
end

local function print_center(text, font, x, y)
   local width = font:getWidth(text)
   local height = font:getHeight()
   local text_x = math.floor(x) - math.floor(width / 2)
   local text_y = math.floor(y) - math.floor(height / 2)
   love.graphics.print(text, font, text_x, text_y)
   return text_x, text_y, width, height
end

-- Thanks to: https://love2d.org/forums/viewtopic.php?t=79419
local function print_wrap(text, font, x, y, wrap)
   local _, lines = font:getWrap(text, wrap)
   local height = #lines * font:getLineHeight() * (font:getAscent() + font:getDescent())
   love.graphics.printf(text, font, x, y, wrap)
   return height
end

function State:render()
   local slide = self.kanji_slides[self.current_kanji_slide]
   love.graphics.clear(
	  slide.theme.bg.r,
	  slide.theme.bg.g,
	  slide.theme.bg.b,
	  slide.theme.bg.a
   )
   love.graphics.setColor(
	  slide.theme.fg.r,
	  slide.theme.fg.g,
	  slide.theme.fg.b,
	  slide.theme.fg.a
   )

   if not self.paused then
	  local width = math.floor(self.autoscroll_cooldown / self.config.autoscroll_delay * self.width)
	  love.graphics.rectangle(
		 "fill",
		 self.width - width,
		 self.height - self.config.timebar_height,
		 width,
		 self.config.timebar_height
	  )
   end

   love.graphics.print(string.format("%d/%d", self.current_kanji_slide, #self.kanji_slides), self.label_font, 10, 5)

   local padding_x = math.floor(self.width / 4)
   local padding_y = 10
   local text_x, text_y, width, height = print_center(slide.kanji, self.kanji_font, padding_x, self.height / 2 - 20)
   local info_start = text_x + width + 50
   local wrap = self.width - info_start - padding_x
   local height
   if #slide.kun ~= 0 then
	  height = print_wrap("Kun:", self.label_font, info_start, text_y, wrap)
	  text_y = text_y + height + padding_y
	  height = print_wrap(table.concat(slide.kun, ", "), self.info_font, info_start, text_y, wrap)
	  text_y = text_y + height + padding_y
   end
   if #slide.on ~= 0 then
	  height = print_wrap("On:", self.label_font, info_start, text_y, wrap)
	  text_y = text_y + height + padding_y
	  height = print_wrap(table.concat(slide.on, ", "), self.info_font, info_start, text_y, wrap)
	  text_y = text_y + height + padding_y
   end
   height = print_wrap("Def:", self.label_font, info_start, text_y, wrap)
   text_y = text_y + height + padding_y
   height = print_wrap(table.concat(slide.meanings, ", "), self.info_font, info_start, text_y, wrap)
end

local state = {
   width = 500,
   height = 300,
   paused = true,
}

setmetatable(state, State)

return state
