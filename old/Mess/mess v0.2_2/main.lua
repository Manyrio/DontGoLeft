--[[==============================
needed:
Sceenes:
	- varied gradient - night/day/eveiiilll
	-varied sun/moon/
	-varied clouds 
	-varied weather - rain/leaves/meteors

	
	
	8[21:27]	robin-gvx: lua> function index(t, ...) if select("#", ...) == 0 then return t elseif t[...] then return index(t[...], select(2, ...)) else return false end end t = {} return index(t, 3, 4, 5)
8[21:27]	lua_bot: robin-gvx: false
8[21:28]	robin-gvx: :D
7[21:28]	Kraftman: nice one :)
7[21:28]	Kraftman: thanks!
8[21:28]	robin-gvx: lua> function index(t, ...) if select("#", ...) == 0 then return t elseif t[...] then return index(t[...], select(2, ...)) else return false end end t = {[3] = {[4] = {[5] = true}}} return index(t, 3, 4, 5)
8[21:28]	lua_bot: robin-gvx: true


--========================================]]

SCREEN_WIDTH = love.graphics.getWidth()
SCREEN_HEIGHT = love.graphics.getHeight()

SELECTED_SCENE = "test"

EVENT_UPDATE = {}
EVENT_DRAW = {}
EVENT_KEYDOWN = {}
EVENT_KEYUP = {}

CAMERA_X = 0
CAMERA_Y = 0

CAMERA_OFFSETX = SCREEN_WIDTH/2
CAMERA_OFFSETY = SCREEN_HEIGHT/2

GAME_SPEED = 1
GAME_TIME = 0

mouse = {}
mouse.x = 0
mouse.y = 0

GRAVITY = 500

TUB_SIZE = 16

math.randomseed(40)

--=============================================

require "textures"


require 'scenes'
--require 'weather'
require 'world'
require "player"
require 'keyboard'



function love.load()

end

function love.keypressed(key,uni)
for i = 1, #EVENT_KEYDOWN do
	EVENT_KEYDOWN[i]:KeyPressed(key,uni)
end
	--Scene:ChangeScene("day")
end


function love.update(dt)
	GAME_TIME = GAME_TIME + dt
	mouse.x, mouse.y = love.mouse.getPosition()
	for i = 1, #EVENT_UPDATE do
		EVENT_UPDATE[i]:Update(dt)
	end
	
end

function love.draw()
	for i = 1, #EVENT_DRAW do
		EVENT_DRAW[i]:Draw()
	end
	
	love.graphics.print(love.timer.getFPS()..", "..CAMERA_X..", "..CAMERA_Y, 400, 400)
end