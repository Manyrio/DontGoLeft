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

local microtime = love.timer.getMicroTime
--=======================================

local WorldTypes = WorldTypes


local World = World


tinsert(EVENT_UPDATE, World)
tinsert(EVENT_DRAW, World)
tinsert(EVENT_KEYDOWN, World)




World.Buckets = {}
World.Container = {}
World.Shown_Buckets = {}







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

	local t1,t2
	t1 = microtime()
	for i = 0, BUCKET_XCOUNT-1 do
		for j = 0, BUCKET_YCOUNT-1 do
			if (i >= ioff) and (j >= joff) then
				joff = 0
				ioff = 0
				
				t2 = microtime()
				if t2-t1 > 0.01 then

					b.progress = {}
					b.progress.i = i
					b.progress.j = j
					return
				end
				
				if b.tubs[i] and b.tubs[i][j] then
					b.tubs[i][j][3] = SetEdgeTexture(b, b.tubs[i][j], i, j,refresh)
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
local checktime = 0.01


function World:Update(dt)

  Xpoint = CAMERA.X/BUCKET_WIDTH
  Ypoint = CAMERA.Y/BUCKET_HEIGHT
	timer = timer + dt
	if timer > checktime then
		timer = timer-checktime
	local count = 0
		
		for i = floor(Xpoint-3), floor(Xpoint+4) do --create potential future buckets
			for j = floor(Ypoint-3), floor(Ypoint+4) do
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
		
		if count > 28  then
			
			for i = floor(Xpoint-2), floor(Xpoint+3) do --create potential future buckets
				for j = floor(Ypoint-2), floor(Ypoint+3) do
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
	end
	
	local a = 1
	
	for i = floor(Xpoint), floor(Xpoint+1) do --sets the active buckets
		for j = floor(Ypoint), floor(Ypoint+1) do
			if World.Buckets[i] and World.Buckets[i][j] and World.Buckets[i][j].complete then
				World.Shown_Buckets[a] = World.Buckets[i][j] 
			end
			a = a + 1
		end
	end
		---[[
	for j = 1, #World.Shown_Buckets do
		if World.Shown_Buckets[j] then
			for i = 1,#World.Shown_Buckets[j].items do
				local item = World.Shown_Buckets[j].items[i]
				if item then
					if item:InPlayerRange(World.Shown_Buckets[j].x+item.x,World.Shown_Buckets[j].y+item.y) and not (#player.items == player.bagsize) then
						if not item:Pickup(World.Shown_Buckets[j].x+item.x,World.Shown_Buckets[j].y+item.y,i,j) then
							item:TweenToPlayer(World.Shown_Buckets[j].x+item.x,World.Shown_Buckets[j].y+item.y,dt)
						end
					else
						local newy = item.y + item.vy*dt
						if item:Collides(item.x, newy) then
							item.vy = 0
						else
							item.vy = item.vy + GRAVITY*dt
							item.y = newy
						end
					end
				end
			end
		end
	end	--]]		
	
	
	for j = 1, #World.Shown_Buckets do
		if World.Shown_Buckets[j] then
			World.Shown_Buckets[j]:Update(dt)
		end
	end	
	
end

function World:Draw()
	for i = 1, #World.Shown_Buckets do
		if World.Shown_Buckets[i] then
 		World.Shown_Buckets[i]:Draw()
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






