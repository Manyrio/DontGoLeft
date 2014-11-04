
-- terrain generates buckets with textures


--======= general locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor


require 'globals'
require 'gamedata'

require "textures"

require 'entities/creatures'
require 'scenes'
--require 'weather'
require 'bucket'
require 'world'
require 'items'
require "entities/player"
require 'keyboard'
require 'gui'


function love.load()

end

function love.keypressed(key,uni)
	for i = 1, #EVENT_KEYDOWN do
		EVENT_KEYDOWN[i]:KeyPressed(key,uni)
	end
	--Scene:ChangeScene("day")
end


function love.update(dt)
	GAME.TIME = GAME.TIME + dt
	mouse.x, mouse.y = love.mouse.getPosition()
	for i = 1, #EVENT_UPDATE do
		EVENT_UPDATE[i]:Update(dt)
	end
	if not CRASH_WHEN_GOING_TO_THE_LEFT then
		CAMERA.X = math.max(CAMERA.X, 1600)
		player.x = math.max(player.x, 1600)
	end
end

function love.draw()
	for i = 1, #EVENT_DRAW do
		EVENT_DRAW[i]:Draw()
	end
	
	love.graphics.print(love.timer.getFPS()..", "..CAMERA.X..", "..CAMERA.Y, 400, 400)
end