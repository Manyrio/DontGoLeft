
--[[

generate terrain

populate buckets










--]]


--======= locals ===========
local random = math.random
local tinsert = table.insert


World = {}

tinsert(EVENT_UPDATE, World)
tinsert(EVENT_DRAW, World)


WorldTypes = {}

WorldTypes.Normal = {}


BUCKET_WIDTH = SCREEN_WIDTH/10
BUCKET_HEIGHT = SCREEN_HEIGHT/10

--=======================================


	smoothness = 5
	iterations = 9
	points = {}


		
function run()
	beginratio = math.floor((9^2-1)/(smoothness / 10))
	points = {}
	for i = 1, iterations do
		routine()
		beginratio = beginratio/2
	end
end

function routine()
	add = 0
	for point = 1, #points do
		point = point+add
		if point >= #points then return end
		point1 = points[point]
		point2 = points[point+1]
		point3 = (point1+point2)/2+math.random(-beginratio,beginratio)
		table.insert(points, point+1, point3)
		add = add+1
	end
end






function World:Update(dt)

end

function World:Draw()

end
