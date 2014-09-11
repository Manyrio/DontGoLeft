--======= locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor

local CAMERA = CAMERA
local GAME = GAME

local Draw = love.graphics.draw

--========================================

local GUI = GUI

tinsert(EVENT_UPDATE, GUI)
tinsert(EVENT_DRAW,GUI)

local HotBar = {}
HotBar.Icons = {}

for i = 1, 10 do
	local t = {}
	
	HotBar[i] = t
end



function HotBar:Draw()


end


function GUI:Update()

end

function GUI:Draw()
	for i = 1, #player.items do
		love.graphics.setColor(1,1,1,255)
		love.graphics.print(player.items[i].type..": "..player.items[i].count,50*i, 30) 
		love.graphics.setColor(255,255,255,255)
	end
	
	HotBar:Draw()
end

