--[[
world needs:
a line describing the terrain
layers and distances
special features - houses/villages etc
zones for: scene type, creature types.

--]]



--======= general locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor

--========================================
local CAMERA = CAMERA
local GAME = GAME
local Draw = love.graphics.draw
local microtime = love.timer.getTime
--=======================================
local WorldTypes = WorldTypes
local World = World

tinsert(EVENT_UPDATE, World)
tinsert(EVENT_DRAW, World)
tinsert(EVENT_KEYDOWN, World)

World.Buckets = {}
--World.Container = {}
World.ActiveBuckets = {}

function World:TubExists(bx,by,tx,ty)
	if self.Buckets[bx][by].tubs[tx] 
		and self.Buckets[bx][by].tubs[tx][ty] then
		return true
	end
end

function World:ClearTub(bx, by, tx, ty)
	self.Buckets[bx][by].tubs[tx][ty] = nil
end


function World:GetTub(bx,by,tx,ty)
	if self.Buckets[bx][by].tubs[tx] 
	and self.Buckets[bx][by].tubs[tx][ty] then
		return self.Buckets[bx][by].tubs[tx][ty]
	end
end


function World:UpdateAdjacentTubs(bx,by,tx,ty)
	for i = -1, 1 do
		for j = -1, 1 do
			local tub = self:GetTub(bx,by,tx+i,ty+j)
			if tub then
				self.Buckets[bx][by].tubs[tx+i][ty+j] = SetEdgeTexture(self.Buckets[bx][by],tx+i, ty+j,true)
				tub[4] = love.graphics.newImage(tub[2])
			end
		end
	end
	-- clear the buffer
	self.Buckets[bx][by].buffer = nil
end

function World:DestroyTub(mx,my)
	local bx,by = self:GetBucketCoords(mx,my)
	local tx, ty = self:GetTubeCoords(bx,by,mx,my)
	if self:TubExists(bx, by, tx, ty) then
		CreateItem(bx,by, tx, ty)
		self:ClearTub(bx, by, tx, ty)
		self:UpdateAdjacentTubs(bx,by,tx,ty)
	end
end


function World:Collides(newX, newY)
	local bx, by = self:GetBucketCoords(newX,newY)
	local tx,ty = self:GetTubeCoords(bx,by, newX, newY)
	local b = self.Buckets[bx] and self.Buckets[bx][by]
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

function World:GetBucket(x,y)
	return self.Buckets[x] and self.Buckets[x][y]
end

function World:GetBucketCoords(x,y)
	return floor(x/BUCKET_WIDTH), floor(y/BUCKET_HEIGHT)
end

function World:GetTubeCoords(bx,by,x,y)
	return floor((x-bx*BUCKET_WIDTH)/TUB_SIZE), floor((y-by*BUCKET_HEIGHT)/TUB_SIZE)
end

--=======================================
-- this function needs replacing with something decent

local function iteratePoints(points, maxpoints, ratio)
	add = 0
	for point = 1, #points-1 do
		if #points == maxpoints then break end
		point = point+add
		table.insert(points, point+1, (points[point]+points[point+1])/2+math.random(-ratio,ratio))
		add = add+1
	end
end

function PlotPoints(smoothness, maxpoints, left, right)
	local points = {left,right}
	ratio = math.floor((9^2-1)/(smoothness / 10))
	while #points < maxpoints-1 do
		iteratePoints(points,maxpoints, ratio)
		ratio = ratio/2
	end
	return points
end

--============================================================

local function SetEdges(b,refresh)
	local ioff,joff = 0,0
	if b.progress then
		ioff = b.progress.i
		joff = b.progress.j
	end

	local t1, t2 = microtime(), microtime()
	
	for i = 0, BUCKET_XCOUNT-1 do
		for j = 0, BUCKET_YCOUNT-1 do
			if (i >= ioff) and (j >= joff) then
				joff = 0
				ioff = 0
				
				t2 = microtime()
				if t2-t1 > 0.003 then
					b.progress = {i = i, j = j}
					return
				end
				
				if b.tubs[i] and b.tubs[i][j] then
					b.tubs[i][j] = SetEdgeTexture(b,i,j,refresh)
				end
			end
		end
	end
	
	b.complete = true
	b.progress = nil

end


function World:New(world)
	--reset some stuff
	SELECTED_WORLD = world
	CAMERA.X = world.startx
	CAMERA.Y = world.starty
	
	self.Buckets = {}
	
	self.Points = PlotPoints(world.smooth, world.size, world.xheight, world.yheight)
	
	for i = 1, #World.Points-1 do
		World.Points[i] = PlotPoints(world.smooth, BUCKET_XCOUNT+1, World.Points[i], World.Points[i+1])
	end
	
	
		

end

World:New(WorldTypes.Spawn)

local Xpoint
local Ypoint

local timer = 0
local interval = 0.08


function World:CreateFutureBuckets(Ypoint, Ypoint)
	local count = 0
	for i = floor(Xpoint-2), floor(Xpoint+2) do --create potential future buckets
		for j = floor(Ypoint-2), floor(Ypoint+2) do
			if not World.Buckets[i] then
				World.Buckets[i] = {}
			end
			
			if World.Buckets[i][j] then
				count = count + 1
			else
				NewBucket(SELECTED_WORLD, i,j)
				break
			end
		end
	end
	return count
end

function World:CompletePartialBuckets(Xpoint, Ypoint)
	for i = floor(Xpoint-1), floor(Xpoint+1) do 
		for j = floor(Ypoint-1), floor(Ypoint+1) do
			if self.Buckets[i] and self.Buckets[i][j] then
				local bucket = self.Buckets[i][j]
				if (not bucket.complete) then
						SetEdges(bucket)
					break
				end
			end
		end
	end
end

function World:SetShownBuckets(Xpoint, Ypoint)
	-- should we empty out ActiveBuckets?
	local a = 1
	for i = floor(Xpoint), floor(Xpoint+1) do --sets the active buckets
		for j = floor(Ypoint), floor(Ypoint+1) do
			if World.Buckets[i] and World.Buckets[i][j] and World.Buckets[i][j].complete then
				World.ActiveBuckets[a] = World.Buckets[i][j] 
			end
			a = a + 1
		end
	end
end

function World:GenerateNewBuckets(Xpoint, Ypoint)
	local count = self:CreateFutureBuckets(Xpoint, Ypoint)
	if count == 25 then -- update the edges of existing buckets
		self:CompletePartialBuckets(Xpoint, Ypoint)
	end
end

function World:Update(dt)

	Xpoint, Ypoint = CAMERA.X/BUCKET_WIDTH, CAMERA.Y/BUCKET_HEIGHT
	timer = timer + dt - interval
	
	self:GenerateNewBuckets(Xpoint, Ypoint)
	self:SetShownBuckets(Xpoint, Ypoint)
	self:UpdateActiveBuckets(dt)
	
end

function World:UpdateActiveBuckets(dt)
	for j = 1, #World.ActiveBuckets do
		if World.ActiveBuckets[j] then
			World.ActiveBuckets[j]:Update(dt,j)
		end
	end	
end

function World:Draw()
	for i = 1, #World.ActiveBuckets do
		if World.ActiveBuckets[i] then
 			World.ActiveBuckets[i]:Draw()
		end
	end
end

function World:KeyPressed(key, uni)
	--[[
	for i,v in pairs(World.Buckets) do
		for j, bucket in pairs(v) do
			local file = love.filesystem.newFile("Bucket"..i..j..".tga")
			file:open('w')
			local img = love.image.newImageData(SCREEN_WIDTH, SCREEN_HEIGHT)
			for a, k in pairs(bucket.tubs) do
				for b, tub in pairs(k) do
					img:setPixel(a,b, 200,200,200,200)
				end
			end
			file:write(img:encode("tga"))
			file:close()
		end
	end
	--]]
end






