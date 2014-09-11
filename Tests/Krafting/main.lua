--[[

	44, 52

	1 2
	2 6
	3 28
	4 4
	5 2
	6 2

--]]

local tinsert = table.insert

local player = {}

player = {}
player.grid = {}

local test = love.image.newImageData("sword.png")

local function mapImage(x,y,r,g,b,a)

player.grid[x] = player.grid[x] or {}
--print(r,g,b,a)
	if a == 255 then
		player.grid[x][y] = {r,g,b,a}
	else
		player.grid[x][y] = false
	end
end

--test:mapPixel(mapImage)

local function GetNeighbors(grid, i, j)
	local t = {}
	tinsert(t, (grid[i-1][j-1] or false) )
	tinsert(t, (grid[i][j-1] or false))
	tinsert(t, (grid[i+1][j-1] or false))
	tinsert(t, (grid[i+1][j] or false))
	tinsert(t, (grid[i+1][j+1] or false))
	tinsert(t, (grid[i][j+1] or false))
	tinsert(t, (grid[i-1][j+1] or false))
	tinsert(t, (grid[i-1][j] or false))
	return t
end

local function CheckExposed(image, neighbors)

	---[[
	local a = 0
	local b = 0
	
	for j = 1, #neighbors do
		a = 0
		local i = j
		local count = 0
		while (not neighbors[i]) and i <=#neighbors and count <9 do
				a = a+1
				i = i + 1
				if i > #neighbors then
					i = 1
				end
				count = count +1
		end
		b = math.max(b,a)
	end
	image.exposed[b] = (image.exposed[b] or 0) + 1
	--]]
end

local function CheckPerimeter(image, n,i,j)
	if not n[2] then --top
		image.perim = image.perim + 1
		tinsert(image.outline, {i,j})
		tinsert(image.outline, {i+1, j})
	end
	if not n[4] then --left
		image.perim = image.perim + 1
		tinsert(image.outline, {i+1,j})
		tinsert(image.outline, {i+1, j+1})
	end
	if not n[6] then --right
		image.perim = image.perim + 1
		tinsert(image.outline, {i+1, j+1})
		tinsert(image.outline, {i, j+1})
	end
	if not n[8] then --bottom
		image.perim = image.perim + 1
		tinsert(image.outline, {i, j+1})
		tinsert(image.outline, {i,j})
	end
end

function table_count(tt, item)
  local count
  count = 0
  for ii,xx in pairs(tt) do
    if item[1] == xx[1] and item[2] == xx[2] then count = count + 1 end
  end
  return count
end


-- Remove duplicates from a table array (doesn't currently work
-- on key-value tables)
function table_unique(tt)
  local newtable
  newtable = {}
  for ii,xx in ipairs(tt) do
    if(table_count(newtable, xx) == 0) then
      newtable[#newtable+1] = xx
    end
  end
  return newtable
end

local function GetAngles(image)
	local outline = image.outline
	
	for i = 1, #outline do
		local angle = math.atan2(my-ay, mx-ax)-1.5
		degangle = math.deg(angle)
		if (degangle >= 0 and degangle < 90) then
			if image.grid[outline[i][1]][outline[i][2]-1] then

			end
		elseif (degangle >= 90 and degangle < 180 then 
	end
end

local function ScanImage(image)
	image.volume = 0
	image.perim = 0
	image.exposed = {}
	image.outline = {}
	image.angles = {}
	
	for i = 1, #image.grid do
		for j = 1, #image.grid[i] do
			if image.grid[i][j] then
				local neighbors = GetNeighbors(image.grid,i,j)
				image.volume = image.volume + 1
				CheckPerimeter(image, neighbors,i,j)
				CheckExposed(image,neighbors)
				
			end
		end
	end
	
	image.outline = table_unique(image.outline) --remove duplicates
	
	GetAngles(image)
	
end



--[[
local p2 = {}
local function test()
local a,b = 1,1
local p = player["64"]
	for i = 1, #p,2 do
		p2[a] = {}
		for j = 1, #p[i],2 do
			if p[i][j] and p[i][j][1] then
			ar = (p[i][j][1] or 0 + p[i+1][j][1] or 0 + p[i][j+1][1] or 0 + p[i+i][j+1][1] or 0)/4
			ag = (p[i][j][2] or 0 + p[i+1][j][2] or 0 + p[i][j+1][2] or 0 + p[i+i][j+1][2] or 0)/4
			ab = (p[i][j][3] or 0 + p[i+1][j][3] or 0 + p[i][j+1][3] or 0 + p[i+i][j+1][3] or 0)/4
			aa = (p[i][j][4] or 0 + p[i+1][j][4] or 0 + p[i][j+1][4] or 0 + p[i+i][j+1][4] or 0)/4
			
			
			p2[a][b] = {p[i][j][1],p[i][j][2],p[i][j][3],p[i][j][4]}
			b = b + 1
			end
			print(a,b, ar, ag, ab, aa)
		end
		a = a +1
		b = 1
		
	end

end


function getneighbours(point)

end
--]]



function love.mousepressed()
test:mapPixel(mapImage)
 ScanImage(player)
 print(player.volume, player.perim)
 for k,v in pairs(player.exposed) do
	print("sides exposed:",k,"number :", v)
 end
end

--=======================================================================
--=======================================================================

function love.update()

end

function love.draw()
--[[
	for i = 1, #player["64"] do
		for j = 1, #player["64"][i] do
			love.graphics.setColor(player["64"][i][j])
			love.graphics.rectangle("fill", i*4,j*4,4,4)
		end
	end
	
	for i = 1, #p2 do
		for j = 1, #p2[i] do
			if p2[i][j] then
			love.graphics.setColor(p2[i][j])
			love.graphics.rectangle("fill", 120 + i*4,j*4,4,4)
			end
		end
	end
	--]]
end
