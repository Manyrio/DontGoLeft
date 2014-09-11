

test = {}


local startx = 10
local starty = 10

local endx = 200
local endy = 100

local bx = 150
local by = 200


local function GetXPoint(sx, ex, bx)
	return (1-t)*(1-t)*sx + 2*(1-t)*t*bx+t*t*ex
end

local function GetYPoint(sy, ey, by)
	return (1-t)*(1-t)*starty + 2*(1-t)*t*by+t*t*endy
end

function test:draw()
love.graphics.setColor(255,255,255,255)

local x, y
	for x = -40, 40 do
		
		love.graphics.rectangle("fill",x,100-math.sqrt((-5*(x*x))+1000*x-49872),2,2)
	end
end