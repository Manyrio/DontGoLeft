
--======= locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor

local CAMERA = CAMERA
local GAME = GAME

local Draw = love.graphics.draw

local microtime = love.timer.getMicroTime

--========================================


local Creature = {}

Creature.__index = Creature


function Creature:Create(bucket)
	
	local c = {}
	c.__index = Creature
	setmetatable(c,c)
	
	c.x = 0
	c.y = 0
	c.sx = 1
	c.sy = 1
	c.rot = 0
	c.ox = 0
	c.oy = 0
	c.active = true
	c.bucket = bucket
	c.vx = 0
	c.vy = 0 
	c.falls = true

	c.timer = 0
	c.mintime = 2
	c.maxtime = 8
	c.checktime = math.random(c.mintime,c.maxtime)
	
	
	

	return c
end

function Creature:Draw()
	if self.active then

		Draw(self.drawable, self:GetX(), self:GetY(),self.rot, self.sx,self.sy,self.ox, self.oy)
	end
end

function Creature:GetX()
	return self.x + self.bucket.x-CAMERA.X

end

function Creature:GetY()
	return self.y + self.bucket.y-CAMERA.Y

end

function Creature:CheckCollides(newx, newy)
local bx,by,tx,ty,bucket

	if newx > BUCKET_WIDTH then
		bx = self.bucket.i+1
		tx = floor((newx-BUCKET_WIDTH)/TUB_SIZE)
	elseif newx < 0 then
		bx = self.bucket.i-1
		tx = floor((BUCKET_WIDTH-newx)/TUB_SIZE)
	else
		bx = self.bucket.i
		tx = floor((newx)/TUB_SIZE)
	end
	
	if newy > BUCKET_HEIGHT then
		by = self.bucket.j+1
		ty = floor((newx-BUCKET_WIDTH)/TUB_SIZE)
	elseif newy < 0 then
		by= self.bucket.j-1
		ty = floor((BUCKET_WIDTH-newx)/TUB_SIZE)
	else
		by = self.bucket.j
		ty = floor((newy)/TUB_SIZE)
	end
	--print(self.bucket.i, self.bucket.j, bx, by)
	bucket = World.Buckets[bx] and World.Buckets[bx][by]
	if not bucket then return true end
	if bucket.tubs[tx] and bucket.tubs[tx][ty] then
		return true
	else
		return false
	end
end

function Creature:Decide()
	local r = math.random(#self.decisions)
	self.decisions[r]()
end

function Creature:AddDecision(dec)
	table.insert(self.decisions, dec)
end

function Creature:Update(dt)
	if self.active then
		local newy = self.y + self.vy*dt
		local newx = self.x + self.vx *dt
		if self.collides then
			if self:CheckCollides(newx, self.y) or self:CheckCollides(newx, self.y+self.height) or self:CheckCollides(newx+self.height, self.y) or self:CheckCollides(newx+self.height, self.y+self.height) then--check x
				if self.canjump then
					self.vy = -230 --edit this for a variable JUMP_HEIGHT
					print("jump")
				else
					--make a new decision
					self.timer = 0
					self.checktime = math.random(self.mintime, self.maxtime)
					
				end
			else
				self.x = newx
			end
			if self:CheckCollides(self.x, newy+self.height) or self:CheckCollides(self.x+self.width, newy+self.height) then --check the bottom
				self.vy = math.min(self.vy,0)
			elseif self:CheckCollides(self.x, newy) or self:CheckCollides(self.x+self.width, newy) then --check the top
				self.vy = 0
			else
				self.y = newy
			end
		else
			self.y = newy
			self.x = newx
		end
		
		if self.falls then
			self.vy = self.vy + GRAVITY*dt
		end
		if self.vx > 0 then
			self.sx = -1
			self.ox = 32
		else
			self.sx = 1
			self.ox = 0
		end
		
		self.timer = self.timer +dt
		if self.timer > self.checktime then
			print("Test")
			self.timer = 0
			self.checktime = math.random(self.mintime, self.maxtime)
			self:Decide()
		end
		
		local newbx,newby
		if self.x > BUCKET_WIDTH then
			self.x = self.x-BUCKET_WIDTH
			newbx = self.bucket.i+1
		elseif self.x < 0 then
			self.x = BUCKET_WIDTH-self.x
			newbx = self.bucket.i-1
		end
		
		if self.y > BUCKET_HEIGHT then
			self.y = self.y-BUCKET_HEIGHT
			newby = self.bucket.j+1
		elseif self.y < 0 then
			self.y = BUCKET_HEIGHT-self.y
			newby = self.bucket.j-1
		end
		
		if newbx or newby then
			newbx = newbx or self.bucket.i
			newby = newby or self.bucket.j
			if World.Buckets[newbx] and World.Buckets[newbx][newby] then
				for i = 1, #self.bucket.creatures do
					if self.bucket.creatures[i] == self then
						table.remove(self.bucket.creatures, i)
						break
					end
				end
				if not World.Buckets[newbx][newby].creatures then
					World.Buckets[newbx][newby].creatures = {}
				end
				table.insert(World.Buckets[newbx][newby].creatures, self)
				self.bucket = World.Buckets[newbx][newby]
			end
		end
	end
end

local Cow = {}
Cow.__index = Creature
setmetatable(Cow,Cow)


Cow.drawable = love.graphics.newImage("cow.png")
Cow.collides = true
Cow.falls = true
Cow.canjump = true

function Cow:Create(b)
	local c = Creature:Create(b)
	c.__index = Cow
	setmetatable(c,c)
	c.width = 32
	c.height = 40
	c.decisions = {}

	
	return c

end

function CheckCreatures(b)
	local c = Cow:Create(b)
	c.x = 40
	c.y = 40
	
	c:AddDecision(function() c.vx = random(50,100) end)
	c:AddDecision(function() c.vx = -random(50,100) end)
	c:AddDecision(function() c.vx = 0 end)
	
	table.insert(b.creatures, c)
	
end
