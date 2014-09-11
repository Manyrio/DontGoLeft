--[[==================================================================
This thread needs to:
generate the initial terrain

send the relevant active tiles.

saved the map



GENERATING TERRAIN
Simplex noise:
layers
cave distribution
ore distribution


--=========================================================================]]


--====================== thread.lua ==================
--====================================================

require ('love.timer')
require ('love.image')

local random = math.random

local this_thread = love.thread.getThread("engine")
local main_thread = love.thread.getThread("main")

local EVENTS = {}

while true do
	for event, func in pairs(EVENTS) do
		local data = this_thread:receive(event)
		if data then
			func(data)
		end
	end
end


function EVENTS.UpdatePlayer(data)
--[[
extract data coords

check tiles are all ready.

]]
end

function EVENTS.UpdateTerrain(data)
--[[
parse the removal of the block
resend the new tile

]]
end
