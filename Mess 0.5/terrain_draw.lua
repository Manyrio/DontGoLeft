--[[
Draws nearly everything in the scene


Handling Tile removal and placement:
Removing a tile:
send the block to be removed 
if multiple blocks are removed before the thread has caught them, 
	add the extra removed blocks to the data being sent

Adding a tile:
draw over the top of other tiles
send the new tile to the thread
next update from the thread, wipe the temp tiles

]]



--=================== STANDARD LOCALS ==================

local random = math.random
local tinsert = table.insert
local floor = math.floor

--======================================


main_thread = love.thread.getThread("main")
terrain_thread = love.thread.newThread("engine", "terrain_thread.lua")
terrain_thread:start()


local EVENTS = {}

local image

function love.update(dt)
	-- receive events
	for event, func in pairs(EVENTS) do
		local data = main_thread:receive(event)
		if data then
			func(data)
		end
	end	


	--[[
	check the camera coords
	if (camera coords have moved enough) then
		terrain_thread:send()
	end
	]]
end

function EVENTS.GetImage(data)
	image = love.graphics.newImage(data)
end

function EVENTS.error(data)
	print(data)
end


--[[




]]

