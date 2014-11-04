
--======= locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor

local CAMERA = CAMERA
local GAME = GAME

local Draw = love.graphics.draw

--========================================
local isDown = love.keyboard.isDown
--=====================

Keyboard = {}

tinsert(EVENT_UPDATE, Keyboard)
tinsert(EVENT_KEYDOWN, Keyboard)

local newy, newx

local ACTION = {}

ACTION.MOVE_LEFT = function(dt) 
	newx = player.x - 100*dt
	player:Move(newx)
end

ACTION.MOVE_RIGHT = function(dt) 
	newx = player.x + 100*dt
	player:Move(newx)
end

ACTION.MOVE_UP = function(dt)
	newy = player.y - 100*dt
	player:Move(null, newy)
end

ACTION.MOVE_DOWN = function(dt)
	newy = player.y + 100*dt
	player:Move(null, newy)
end

ACTION.CAMERA_LEFT = function(dt)
	CAMERA.offsetX = CAMERA.offsetX + 1000*dt
	CAMERA.X = player.x - CAMERA.offsetX
end

ACTION.CAMERA_RIGHT = function(dt)
	CAMERA.offsetX = CAMERA.offsetX - 1000*dt
	CAMERA.X = player.x - CAMERA.offsetX
end

ACTION.CAMERA_UP = function(dt)
	CAMERA.offsetY = CAMERA.offsetY + 1000*dt
	CAMERA.Y = player.y - CAMERA.offsetY
end

ACTION.CAMERA_DOWN = function(dt)
	CAMERA.offsetY = CAMERA.offsetY - 1000*dt
	CAMERA.Y = player.y - CAMERA.offsetY
end

ACTION.JUMPORFLY = function(dt)
	player:Jump()
end

local KEYDOWN_BINDING = KEYDOWN_BINDING

local KEYPRESS_BINDING = KEYPRESS_BINDING
local KEYRELEASE_BINDING = KEYRELEASE_BINDING

KEYDOWN_BINDING["a"] = "MOVE_LEFT"
KEYDOWN_BINDING["d"] = "MOVE_RIGHT"
KEYDOWN_BINDING["w"] = "MOVE_UP"
KEYDOWN_BINDING["s"] = "MOVE_DOWN"
KEYDOWN_BINDING["left"] = "CAMERA_LEFT"
KEYDOWN_BINDING["right"] = "CAMERA_RIGHT"
KEYDOWN_BINDING["up"] = "CAMERA_UP"
KEYDOWN_BINDING["down"] = "CAMERA_DOWN"

function Keyboard:Update(dt)
	for bind, func in pairs(KEYDOWN_BINDING) do
		if isDown(bind) then
			ACTION[func](dt)
		end
	end
end

KEYPRESS_BINDING[" "] = "JUMPORFLY"

function Keyboard:KeyPressed(key,uni)
	if KEYPRESS_BINDING[key] then
		ACTION[KEYPRESS_BINDING[key]]()
	end
end




