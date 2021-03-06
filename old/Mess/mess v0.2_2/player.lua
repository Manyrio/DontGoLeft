
--======= locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor

local Draw = love.graphics.draw

--========================================


player = {}

tinsert(EVENT_UPDATE, player)
tinsert(EVENT_DRAW,player)

player.image = love.graphics.newImage("player.png")


player.x = 3000
player.y = 0
player.sx = 1
player.sy = 1
player.ox = 1
player.oy = 0
player.width = 18
player.height = 38
player.active = true
player.vx = 0
player.vy = 0


local function GetBucket(x,y)
	return floor(x/BUCKET_WIDTH), floor(y/BUCKET_HEIGHT)
end

local function GetTub(bx,by,x,y)
	return floor((x-bx*BUCKET_WIDTH)/TUB_SIZE), floor((y-by*BUCKET_HEIGHT)/TUB_SIZE)
end

function player:Collides(newx, newy)
	local bx, by = GetBucket(newx,newy)
	local tx,ty = GetTub(bx,by, newx, newy)
	local b = World.Buckets[bx] and World.Buckets[bx][by]
	if b then

	local t = b.tubs[tx] and b.tubs[tx][ty]
	
		if t then
			if t == "air" then
				return false
			else
				return true
			end
		else
			return false
		end
	end	
end


local function ClearTub(mx, my)
	local bx,by = GetBucket(mx,my)
	local tx, ty = GetTub(bx,by,mx,my)
	if World.Buckets[bx][by].tubs[tx][ty] then
		World.Buckets[bx][by].tubs[tx][ty] = nil
	
		for i = -1, 1 do
			for j = -1, 1 do
				if World.Buckets[bx][by].tubs[tx+i] and World.Buckets[bx][by].tubs[tx+i][ty+j] then
					local tub = World.Buckets[bx][by].tubs[tx+i][ty+j]
					World.Buckets[bx][by].tubs[tx+i][ty+j] = SetEdgeTexture(World.Buckets[bx][by], tub, tx+i, ty+j)
					tub[3] = love.graphics.newImage(tub[2])
				end
			end
		end
		
		World.Buckets[bx][by].buffer = nil
	end
end

local function ConvertMouse(mx, my)
return CAMERA_X+mx, CAMERA_Y+my

end

local function InRange(mx,my)
	if mx > player.x - 40 and mx < player.x+player.width*player.sx+40 then
		if my > player.y - 40 and my < player.y+player.height*player.sy+40 then
			return true
		else
			return false
		end
	else
		return false
	end
end

local mouse_timer = 0
local mouse_interval = 0.3
local newy

function player:Update(dt)
	-- ======== MOUSE STUFF =========
	mouse_timer = mouse_timer + dt
	if mouse_timer > mouse_interval then
		mouse_timer = mouse_timer - mouse_interval
		if love.mouse.isDown("l") then
			local mx, my = ConvertMouse(mouse.x, mouse.y)
			if InRange(mx,my) then
				ClearTub(mx,my)
			end
		end
	end
	
	-- ========== GRAVITY ===========
	newy = self.y  + self.vy*dt
	if self:Collides(self.x,newy+self.height*self.sy) or self:Collides(self.x+self.width,newy+self.height*self.sy) then
	 self.vy = math.min(self.vy, 0)
	else
		self.vy = self.vy + GRAVITY*dt
		self.y = newy
	end
	CAMERA_Y = self.y	-CAMERA_OFFSETY
	--===============================
	
end


function player:Draw()
	if player.active then
		Draw(player.image, player.x-CAMERA_X, player.y-CAMERA_Y,player.rot, player.sx, player.sy, player.ox, player.oy)
	end
end

CAMERA_X = player.x	-CAMERA_OFFSETX
CAMERA_Y = player.y	-CAMERA_OFFSETY






