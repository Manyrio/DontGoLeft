
--======= locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor

local CAMERA = CAMERA
local GAME = GAME

local Draw = love.graphics.draw

local microtime = love.timer.getMicroTime

--========================================

local thread = love.thread:getThread()

local Buckets = {}

require 'gamedata.lua'

--==========================================



local function FillBucket(b, a,depth, label)
	local found
	
	if label ~= "air" then
		for i = 0, BUCKET_XCOUNT-1 do
			for j = 0, BUCKET_YCOUNT-1 do
				if (j*TUB_SIZE)+b.y > depth + World.Points[a][i+1] then
					if not b.tubs[i] then b.tubs[i] = {} end
						b.tubs[i][j] = label
						found = depth
				end
			end
		end
	end
	return found
end

local function NewFillBucket(b, i)
	local oldlabel 
	for j = 1, #SELECTED_WORLD.layers do
		local info = SELECTED_WORLD.layers[j]
		local dist = World.Points[i][1]+info.depth
		if info.label then
			local test = FillBucket(b,i,info.depth, info.label)

			if not oldlabel and World.Points[i][1]+info.depth > b.y and World.Points[i][1]+info.depth < b.y+BUCKET_HEIGHT then
				b.type = "surface"			
			end
			if test then
				oldlabel = test
			end
		end
	end
end

local function CheckOres(b)
	local depth = (World.Points[b.i][1]+World.Points[b.i+1][1])/2
	for ore, info in pairs(SELECTED_WORLD.Ores) do
		if b.y > info.mindepth+depth and b.y < info.maxdepth+depth then
			
			if true then
				local t = {}
				for i = 0, BUCKET_XCOUNT-1 do
					t[i] = {}
				end
				
				
				for a = 1, random(50) do
					local x,y = random(0,BUCKET_XCOUNT), random(0,BUCKET_YCOUNT)
				--	print(x,y)
					for i = 1, info.size-random(info.size) do
						for j = 1, info.size-random(info.size) do
							if t[i+x] and (y+j < BUCKET_YCOUNT) then
								t[i+x][y+j] = true
							end
						end
					end
				end
				
				for x = 0, BUCKET_XCOUNT-1 do
					for y = 0, BUCKET_YCOUNT-1 do
						
							local count = 0
							for i = -1,1 do
								for j = -1,1 do
									if t[x+i] and t[x+i][y+j] then
										count = count + 1
									end
								end
							end							
							
							if count < 5 then
								t[x][y] = nil
							elseif count > 6 then
								t[x][y] = true
							end
					end					
				end	
				
				for x = 0, BUCKET_XCOUNT-1 do
					for y = 0, BUCKET_YCOUNT-1 do
						if t[x][y] then
							b.tubs[x][y] = ore
						end
					end
				end
			
				end
		
		end
	end
end

local function PlotHoles(b)

end

function NewBucket(world,i,j)
	if not CRASH_WHEN_GOING_TO_THE_LEFT and  not World.Points[i] then
		return 
	end

	local b = {}

	b.tubs = {}
	
	b.items = {}

	b.Draw = DrawBucket
	b.Update = UpdateBucket
	b.i = i
	b.j = j
	
	if not World.Buckets[i] then
		World.Buckets[i] = {}
	end
	
	World.Buckets[i][j] = b
	
	b.x = i*BUCKET_WIDTH-1
	b.y = j*BUCKET_HEIGHT-1

		NewFillBucket(b,i) -- needs renaming
	
		if b.type == "surface" then
		b.creatures = {}
			CheckCreatures(b)
		end
		
		CheckOres(b)	
		
		PlotHoles(b)

	return b
end

--========================================================
--================================================================================
--================================================================================
--================================================================================
--[[
data needs to contain:
the line coordinates for the bucket
the world name
the buccket coordinates
--]]


while true do
	local receive = thread:demand("NewBucket", data)
	
	NewBucket(data)
	
	






--================================================================================
--================================================================================
--================================================================================
--================================================================================






function love.load()
  --create a thread named worker running the code in thread.lua
  thread = love.thread.newThread("worker", "thread.lua")
  --start the thread
  thread:start()
end


function love.update(dt)
  local imageData = thread:receive("progress")
  -- Only run this if it recieved something
  if imageData then
    image = love.graphics.newImage(imageData)
  end
end

function love.draw()
  if image then
    love.graphics.draw(image, 0,0)
  end
  local x,y = love.mouse.getPosition()
  love.graphics.circle("line",x,y,30,48)
end

function love.keypressed(k)
  -- Start the thread when spacebar is pressed
  if k==" " then
    --send the message to start
    thread:send("run", true)
  end
  if k=="q" then
    --send the message to quit
    thread:send("quit", true)
  end
end



--================================================================================
--================================================================================
--================================================================================
--================================================================================
--================================================================================


--You must require the love modules in threads to use them
--require("love.thread") --this module doesn't need to be required
require("love.timer")
require("love.image")

--To perform thread operations, you have to find yourself
local this_thread = love.thread.getThread() --or love._curthread

function generateImage()
  math.randomseed(love.timer.getTime())
  function pixelFunction(x, y, r, g, b, a)
    r = math.random(10) + b + x % 10
    g = math.random(10) + r + y % 10
    b = math.random(10) + a + x*y % 20
    a = math.random(10) + g + x+y % 15
    return math.ceil(r), math.ceil(g), math.ceil(b), math.ceil(a)
  end
  local image = love.image.newImageData(512,512)
  local response = nil
  --The thread will never leave this loop until quit recieves true
  while true do
    image:mapPixel(pixelFunction)
    --send the updated image back to the main process.
    this_thread:send("progress", image)
    if this_thread:receive("quit") then
      --leave the function and finish the thread execution
      return
    end
  end
end

--This waits for the main process to send a signal to start
this_thread:demand("run")
generateImage()
--When this part is reached the thread terminates


--in main thread
function MainThread.SendData(data)
local a = 1
	while thread:peek("queue"..a) do
		a = a+1
	end
	thread:send("queue"..a, data)
end

-- in  sub thread
while true do
	run = thread:demand("run")
	local a = 1
	while true do
		local receive = thread:receive("queue"..a)
		if receive then
			--do stuff
			a = a+1
		else
			break
		end
	end
	
	--do other stuff
end
	











