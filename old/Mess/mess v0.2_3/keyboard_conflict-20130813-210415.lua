
--========= locals ===========

local tinsert = table.insert
local random = math.random
local isDown = love.keyboard.isDown
--=====================



Keyboard = {}

tinsert(EVENT_UPDATE, Keyboard)
tinsert(EVENT_KEYDOWN, Keyboard)

local newy, newx

function Keyboard:Update(dt)
	if isDown("w") then
		newy = player.y - 100*dt
		if player:Collides(player.x, newy) then
			
		else
			player.y = newy
			CAMERA_Y = player.y - CAMERA_OFFSETY
		end
	end

	if isDown("s") then
		player.y = player.y + 100*dt
		CAMERA_Y = player.y - CAMERA_OFFSETY
	end

	if isDown("a") then
		--player.x = player.x - 100*dt
		--CAMERA_X = player.x - CAMERA_OFFSETX
		
		newx = player.x - 100*dt
		if player:Collides(newx, player.y+player.height) or player:Collides(newx+player.width, player.y+player.height) or player:Collides(newx, player.y) or player:Collides(newx+player.width, player.y) then
			
		else
			player.x = newx
			CAMERA_X = player.x - CAMERA_OFFSETX
		end
	end

	if isDown("d") then
		newx = player.x + 100*dt
		if player:Collides(newx, player.y+player.height) or player:Collides(newx+player.width, player.y+player.height) or player:Collides(newx, player.y) or player:Collides(newx+player.width, player.y) then
			
		else
			player.x = newx
			CAMERA_X = player.x - CAMERA_OFFSETX
		end
	end
	
	if isDown("up") then
		CAMERA_OFFSETY = CAMERA_OFFSETY + 1000*dt
		CAMERA_Y = player.y - CAMERA_OFFSETY
	end

	if isDown("down") then
		CAMERA_OFFSETY = CAMERA_OFFSETY - 1000*dt
		CAMERA_Y = player.y - CAMERA_OFFSETY
	end

	if isDown("left") then
		CAMERA_OFFSETX = CAMERA_OFFSETX + 1000*dt
		CAMERA_X = player.x - CAMERA_OFFSETX
	end

	if isDown("right") then
		CAMERA_OFFSETX = CAMERA_OFFSETX - 1000*dt
		CAMERA_X = player.x - CAMERA_OFFSETX
	end
end

function Keyboard:KeyPressed(key,uni)
if key == " " then

	player.vy = -200
elseif key == "1" then
	print(player.x, player.y, player.x + player.width, player.y+player.height)
end
end




