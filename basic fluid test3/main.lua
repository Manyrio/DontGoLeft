--======= STANDARD LOCALS ==============
local draw = love.graphics.draw
local rect = love.graphics.rectangle
local floor = math.floor
local ceil = math.ceil
local tinsert = table.insert
local random = math.random 


--==================================
--[[
if down, fill down

if bottom left or right, distribute between them






--]]



local tsize = 60
local blocksize = 8

local offset = 30


local t = {}

local function FillT()
	for i = 0, tsize do
		for j = 0, tsize do
			if not t[i] then
				t[i] = {}
			end
			t[i][j] = {f = 0}
		end
	end


	for i = 0, tsize do
		for j = 0, tsize do
			if i == 0 or j == 0 or i == tsize or j == tsize then
				t[i][j].solid = true
			end
		end
	end

end

FillT()


local function CheckSides(x,y)
local l, r, bl, b, br
	l = not t[x-1][y].solid and not (t[x-1][y].f >= blocksize) and t[x-1][y]
	r = not t[x+1][y].solid and not (t[x+1][y].f >= blocksize) and t[x+1][y]
	bl = not t[x-1][y+1].solid and not (t[x-1][y+1].f >= blocksize) and t[x-1][y+1]
	b = not t[x][y+1].solid and not (t[x][y+1].f >= blocksize) and t[x][y+1]
	br = not t[x+1][y+1].solid and not (t[x+1][y+1].f >= blocksize) and t[x+1][y+1]


	return l,r,bl,b,br
end


local function CheckWater(dt) --not the same dt as update
local tub
	
	for i = tsize, 0,-1 do
		for j = tsize,0,-1 do
	
			tub = t[i][j]
			if not tub.solid and tub.f > 0 then
			
				local l, r, bl, b, br = CheckSides(i,j)
				local avg
				--print(b)
				if b then
					b.f,tub.f = b.f + math.min(blocksize-b.f,tub.f), tub.f - math.min(blocksize-b.f, tub.f)
				end
				
				if bl and br and not t[i][j+1].solid then
					bl.f,br.f,tub.f = bl.f + math.min(blocksize-bl.f, tub.f/2),
														br.f + math.min(blocksize-br.f, tub.f/2),
														tub.f - (math.min(blocksize-bl.f, tub.f/2) + math.min(blocksize-br.f, tub.f/2))
				elseif l and r then
					avg = (l.f+ r.f+tub.f)/3
					l.f,
					tub.f,
					r.f
					= 
					l.f + (avg-l.f),
					tub.f + (avg-tub.f),
					r.f + (avg-r.f)
				
				elseif l then
					avg = (l.f+ tub.f)/2
					l.f,
					tub.f
					= 
					l.f + (avg-l.f),
					tub.f + (avg-tub.f)
				elseif r then
					avg = (r.f+tub.f)/2
					tub.f,
					r.f
					= 
					tub.f + (avg-tub.f), 
					r.f + (avg-r.f)
				
				end
				if tub.f < 0.01 then
					tub.f = 0
				end
			end
		end
	end


end


function love.mousepressed(x,y,button)
x = floor((x-offset)/blocksize)
y = floor((y-offset)/blocksize)

	if button == "r" then
		if t[x][y].solid then
			t[x][y].f = 0
			t[x][y].solid = nil
		else
			t[x][y].solid = true
		end
	end
end


local step = 0.01
local counter = 0



function love.update(dt)

local x, y = love.mouse.getPosition()
x = floor((x-offset)/blocksize)
y = floor((y-offset)/blocksize)



	counter = counter + dt
	if counter > step then
		CheckWater(counter)
		counter = counter - step
	end

	if not t[x] or not t[x][y] then
		return
	end

	if love.mouse.isDown("l") then
		if love.keyboard.isDown("lshift") then
			if not (t[x][y].solid) then
				t[x][y].f =0
			end
		else
			if not (t[x][y].solid) or not (t[x][y].f >= blocksize) then
				t[x][y].f = floor(1000*dt)--math.min(blocksize, t[x][y].f + 1)
			end
		end
	end
	
end


local tub
function love.draw()
	
	for i = 0, tsize do
		for j = 0, tsize do
			tub = t[i][j]
			if tub.solid then
				love.graphics.setColor(255,255,255,255)
				rect("fill", i*blocksize+offset, j*blocksize+offset, blocksize,blocksize)
			elseif tub.f > 0 then
					love.graphics.setColor(120, 120, 255, 255)
					rect("fill", i*blocksize+offset, j*blocksize+offset+blocksize-math.min(blocksize,tub.f), blocksize, math.min(blocksize,tub.f))
					--love.graphics.setColor(255, 255, 255, 255)
					--love.graphics.print(floor(tub.f), i*blocksize+offset, j*blocksize+offset)
			end
		end
	end
	love.graphics.print(love.timer.getFPS(), 20, 20)
end














