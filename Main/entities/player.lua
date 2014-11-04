--======= locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor

local CAMERA = CAMERA
local GAME = GAME

local Draw = love.graphics.draw

--========================================


player = { x = 3000, y = 0, sx = 1, sy = 1, ox = 1, oy = 0,
		   width = 18, height = 38, active = true, vx = 0, vy = 0,
			reach = 40, jumps = 0, bagsize = 10, items = {} }

player.image = love.graphics.newImage("img/player.png")

tinsert(EVENT_UPDATE, player)
tinsert(EVENT_DRAW,player)

local mouse_timer = 0
local mouse_interval = 0.3

function player:BoundsCollide(newX, newY)
	for i = newX, newX + self.width, self.width/2 do
		for j = newY, newY + self.height, self.height/2 do
			if World:Collides(i,j) then
				return true
			end
		end
	end
end

function player:Move(newX, newY)
	newX = newX or self.x
	newY = newY or self.y

	if not self:BoundsCollide(newX,newY) then
		self:SetPosition(newX,newY)
	end
end

function player:SetPosition(newX, newY)
	self.x = newX
	CAMERA.X = player.x - CAMERA.offsetX
	self.y = newY
	CAMERA.Y = player.y - CAMERA.offsetY
end


function player:Jump()
	if player.jumps < 2 then
		self.vy = -200
		self.jumps = self.jumps + 1
	end
end

local function ConvertMouse(mx, my)
	return CAMERA.X+mx, CAMERA.Y+my
end

local function InRange(mx,my)
	if mx > player.x - player.reach and mx < player.x+player.width*player.sx+player.reach then
		if my > player.y - player.reach and my < player.y+player.height*player.sy+player.reach then
			return true
		else
			return false
		end
	else
		return false
	end
end

function player:ProcessGravity(dt)
	local newY = self.y  + self.vy*dt
	if self:BoundsCollide(self.x, newY) then
		self.vy = 0
		self.jumps = 0
	else
		self.vy = self.vy + GRAVITY*dt
		self.y = newY
	end
end

function player:Update(dt)
	-- ======== MOUSE STUFF =========
	
	mouse_timer = mouse_timer + dt
	if mouse_timer > mouse_interval then
		mouse_timer = mouse_timer - mouse_interval
		if love.mouse.isDown("l") then
			local mx, my = ConvertMouse(mouse.x, mouse.y)
			if InRange(mx,my) then
				World:DestroyTub(mx,my)
			end
		end
	end
	
	self:ProcessGravity(dt)
	
	CAMERA.Y = self.y	-CAMERA.offsetY
	--===============================
	
end


function player:Draw()
	if player.active then
		Draw(player.image, player.x-CAMERA.X, player.y-CAMERA.Y,player.rot, player.sx, player.sy, player.ox, player.oy)
	end
end

CAMERA.X = player.x	-CAMERA.offsetX
CAMERA.Y = player.y	-CAMERA.offsetY






