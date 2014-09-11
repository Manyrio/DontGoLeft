--[[

rendering:
scenes handles background and weather



SCALE:
powers of 10
scale meter
scale cm
scale mm

player: 2m, 20cm, 20mm

]]


--======= general locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor
--==================================


SCREEN_WIDTH = love.graphics.getWidth()
SCREEN_HEIGHT = love.graphics.getHeight()

SELECTED_SCENE = "test"

SELECTED_WORLD = false


EVENT_UPDATE = {}
EVENT_DRAW = {}
EVENT_KEYDOWN = {}
EVENT_KEYUP = {}

CAMERA = {}
CAMERA.X = 0
CAMERA.Y = 0

CAMERA.offsetX = SCREEN_WIDTH/2
CAMERA.offsetY = SCREEN_HEIGHT/2

GAME = {}
GAME.SPEED = 1
GAME.TIME = 0
GAME.GRAVITY = 9.8

mouse = {}
mouse.x = 0
mouse.y = 0



TUB_SIZE = 16

BUCKET_XCOUNT = floor(SCREEN_WIDTH/TUB_SIZE + 0.5)
BUCKET_YCOUNT = floor(SCREEN_HEIGHT/TUB_SIZE + 0.5)

BUCKET_WIDTH = BUCKET_XCOUNT*TUB_SIZE
BUCKET_HEIGHT = BUCKET_YCOUNT*TUB_SIZE

math.randomseed(40)

--=============================================
World = {}

KEYDOWN_BINDING = {}

KEYPRESS_BINDING = {}
KEYRELEASE_BINDING = {}

--=============================================

GUI = {}


require "worlddata"
require "scene"
require "terrain_draw"


function love.load()

end

function love.keypressed(key,uni)
	for i = 1, #EVENT_KEYDOWN do
		EVENT_KEYDOWN[i]:KeyPressed(key,uni)
	end
end


function love.update(dt)
	GAME.TIME = GAME.TIME + dt
	mouse.x, mouse.y = love.mouse.getPosition()
	for i = 1, #EVENT_UPDATE do
		EVENT_UPDATE[i]:Update(dt)
	end
end

function love.draw()
	for i = 1, #EVENT_DRAW do
		EVENT_DRAW[i]:Draw()
	end
	-- keep an eye on the framerate
	love.graphics.print(love.timer.getFPS()..", "..CAMERA.X..", "..CAMERA.Y, 400, 400)
end