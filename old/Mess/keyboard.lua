
--========= locals ===========

local tinsert = table.insert
local random = math.random
local isDown = love.keyboard.isDown
--=====================



Keyboard = {}

tinsert(EVENT_UPDATE, Keyboard)

function Keyboard:Update(dt)
	if isDown("w") then
		CAMERA_Y = CAMERA_Y - 1000*dt
	end

	if isDown("s") then
		CAMERA_Y = CAMERA_Y + 1000*dt
	end

	if isDown("a") then
		CAMERA_X = CAMERA_X + 1000*dt
	end

	if isDown("d") then
		CAMERA_X = CAMERA_X - 1000*dt
	end
end

