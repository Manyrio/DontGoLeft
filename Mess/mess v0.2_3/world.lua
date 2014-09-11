--[[
label buckets as their key constituent, eg air, mud, dirt

label airpockets, ore deposits etc extra

need to replace fillbucket with a function that properly accounts for different levels

each world needs: % gold ore
				  % silver ore
				  % diamond
				  etc
					
	since graphcis functions cant be called in a thread, coudl pre render an image in a thread instead

--]]



--======= locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor

local Draw = love.graphics.draw
local microtime = love.timer.getMicroTime

--========================================

World = {}

CURRENT_WORLD = nil

tinsert(EVENT_UPDATE, World)
tinsert(EVENT_DRAW, World)
tinsert(EVENT_KEYDOWN, World)


WorldTypes = {} --probably needs moving to antoher file

WorldTypes.Spawn = {smooth = 20,
					size = 50, --size in buckets
					xheight = -500,
					yheight = 2500,
					startx = 1600,
					starty = 0,
					layers = {
							{label = nil, depth = -6000},
							{label = "dirt", depth = 2000},
							{label = "stone", depth = 8000},
							{label = "rock", depth = 15000},
								{label = "deadstone", depth = 20000},
							},
					Ores = { gold = {size = 3,mindepth = 3000, maxdepth = 20000, rare = 1000},
									mud = {size = 10,mindepth = 2000, maxdepth = 7000, rare = 1000},
				
							}
					
					}

World.Buckets = {}
World.Container = {}



BUCKET_XCOUNT = floor(SCREEN_WIDTH/TUB_SIZE + 0.5)
BUCKET_YCOUNT = floor(SCREEN_HEIGHT/TUB_SIZE + 0.5)

BUCKET_WIDTH = BUCKET_XCOUNT*TUB_SIZE
BUCKET_HEIGHT = BUCKET_YCOUNT*TUB_SIZE



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



--==========================================
Active_Buckets = {}


local function DrawBucket(self)
	if self.complete then
		if self.buffer then
			love.graphics.draw(self.buffer, self.x-CAMERA_X, self.y-CAMERA_Y)
		else

		self.buffer = love.graphics.newFramebuffer(1024,1024)
		love.graphics.setRenderTarget(self.buffer)
			for i = 0, BUCKET_XCOUNT-1 do
				for j = 0, BUCKET_YCOUNT-1 do
					if self.tubs[i] and self.tubs[i][j]and self.tubs[i][j][1] then
					
							if not self.tubs[i][j][4] then
									self.tubs[i][j][4] = love.graphics.newImage(self.tubs[i][j][2])
							end
							love.graphics.draw(self.tubs[i][j][4], i*TUB_SIZE, j*TUB_SIZE)
					end
				end
			end

		
			
			love.graphics.setRenderTarget()
			love.graphics.draw(self.buffer, floor(self.x-CAMERA_X), floor(self.y-CAMERA_Y)) -- shoudl reduce flicker
		end
	end
end






local function SetEdges(b,refresh)
local ioff,joff = 0,0
if b.progress then
	ioff = b.progress.i
	joff = b.progress.j
end

	local t1,t2
	t1 = microtime()
	for i = 0, BUCKET_XCOUNT-1 do
		for j = 0, BUCKET_YCOUNT-1 do
			if (i >= ioff) and (j >= joff) then
				joff = 0
				ioff = 0
				
				t2 = microtime()
				if t2-t1 > 0.005 then

					b.progress = {}
					b.progress.i = i
					b.progress.j = j
					return
				end
				
				if b.tubs[i] and b.tubs[i][j] then
					b.tubs[i][j] = SetEdgeTexture(b, b.tubs[i][j], i, j,refresh)
				end
			end
		end
	end
	
	b.complete = true
	b.progress = nil

end

local function FillBucket(b, a,depth, label)
	for i = 0, BUCKET_XCOUNT-1 do
		for j = 0, BUCKET_YCOUNT-1 do
			if (j*TUB_SIZE)+b.y > depth + World.Points[a][i+1] then
				if not b.tubs[i] then b.tubs[i] = {} end
					b.tubs[i][j] = CreateBaseTexture(label,b,i,j)
			end
		end
	end
end

local function NewFillBucket(b, i)
	for j = 1, #CURRENT_WORLD.layers do
		local info = CURRENT_WORLD.layers[j]
		local dist = World.Points[i][1]+info.depth
			if info.label then
				FillBucket(b,i,info.depth, info.label)
			end
	end
end

local function CheckOres(b)
	for ore, info in pairs(CURRENT_WORLD.Ores) do
		if b.y > info.mindepth and b.y < info.maxdepth then
			if random(10000) >  10000-info.rare then
				local rx, ry = random(BUCKET_XCOUNT-1), random(BUCKET_YCOUNT-1)
				
			for i =  (rx-info.size), (rx+info.size) do
				for j =  (ry-info.size+random(-2,2)), (ry+info.size+random(-2,2)) do
					if not b.tubs[i] then b.tubs[i] = {} end
						b.tubs[i][j] = CreateBaseTexture(ore,b,i,j)
					end	
				end
			end
		end
	end
end

local function NewBucket(world,i,j)
	

	local b = {}

	b.tubs = {}

	b.Draw = DrawBucket
	b.i = i
	b.j = j
	
	if not World.Buckets[i] then
		World.Buckets[i] = {}
	end
	
	World.Buckets[i][j] = b
	
	b.x = i*BUCKET_WIDTH
	b.y = j*BUCKET_HEIGHT 

		NewFillBucket(b,i) -- needs renaming
	
		CheckOres(b)	

	return b
end



local function NewWorld(world)
	--reset some stuff
	CURRENT_WORLD = world
	CAMERA_X = world.startx
	CAMERA_Y = world.starty
	
	
	World.Buckets = {}
	
	World.Points = PlotPoints(world.smooth, world.size, world.xheight, world.yheight)
	
	World.Ores = {} --PlotOres(world)
	
	for i = 1, #World.Points-1 do
		World.Points[i] = PlotPoints(world.smooth, BUCKET_XCOUNT+1, World.Points[i], World.Points[i+1])
	end

	
	
end

NewWorld(WorldTypes.Spawn)




local Xpoint
local Ypoint

local timer = 0
local interval = 0.08

function World:Update(dt)

  Xpoint = CAMERA_X/BUCKET_WIDTH
  Ypoint = CAMERA_Y/BUCKET_HEIGHT
	timer = timer + dt
	
	--if timer > interval then
		timer = timer - interval
		local count = 0
		
		for i = floor(Xpoint-2), floor(Xpoint+2) do --create potential future buckets
			for j = floor(Ypoint-2), floor(Ypoint+2) do
				if not World.Buckets[i] then
					World.Buckets[i] = {}
				end
				
				if World.Buckets[i][j] then
					count = count + 1
				else
					NewBucket(CURRENT_WORLD, i,j)
					break
				end
			end
		end
		
		if count == 25 then
			
			for i = floor(Xpoint-1), floor(Xpoint+1) do --create potential future buckets
				for j = floor(Ypoint-1), floor(Ypoint+1) do
					if World.Buckets[i] and World.Buckets[i][j] then
						local bucket = World.Buckets[i][j]
						if (not bucket.complete) then
								SetEdges(bucket)
							break
						end
					end
				end
			end
		end
	--end
	
	local a = 1
	
	for i = floor(Xpoint), floor(Xpoint+1) do --sets the active buckets
		for j = floor(Ypoint), floor(Ypoint+1) do
			if World.Buckets[i] and World.Buckets[i][j] and World.Buckets[i][j].complete then
				Active_Buckets[a] = World.Buckets[i][j] 
			end
			a = a + 1
		end
	end
		
  
end

function World:Draw()
	for i = 1, #Active_Buckets do
		if Active_Buckets[i] then
 		Active_Buckets[i]:Draw()
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






