--[[==============================
needed:
Sceenes:
	- varied gradient - night/day/eveiiilll
	-varied sun/moon/
	-varied clouds 
	-varied weather - rain/leaves/meteors



--========================================]]

SCREEN_WIDTH = love.graphics.getWidth()
SCREEN_HEIGHT = love.graphics.getHeight()

SELECTED_SCENE = "test"

EVENT_UPDATE = {}
EVENT_DRAW = {}
EVENT_KEYDOWN = {}
EVENT_KEYUP = {}

math.randomseed(101)

--=============================================

require 'keyboard'
require 'scenes'
--require 'weather'
require 'world'

CAMERA_X = SCREEN_WIDTH + SCREEN_WIDTH/2
CAMERA_Y = 0


function love.load()

end

function love.keypressed()
	--Scene:ChangeScene("day")
end


function love.update(dt)
	for i = 1, #EVENT_UPDATE do
		EVENT_UPDATE[i]:Update(dt)
	end
	
end

function love.draw()
	for i = 1, #EVENT_DRAW do
		EVENT_DRAW[i]:Draw()
	end
	
	love.graphics.print(love.timer.getFPS()..", "..CAMERA_Y, 400, 400)
end