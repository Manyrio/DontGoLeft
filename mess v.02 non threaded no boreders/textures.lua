
--======= locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor

local CAMERA = CAMERA
local GAME = GAME

local Draw = love.graphics.draw

--========================================

--========================================
local randomline = {}

for i = 1, 20 do
	for j = 1, random(4) do
		tinsert(randomline, (random(2) == 2) or false)
	end
end

--=======================================

local Create = {}

Textures = {}

local Icons = {}

local Data = ItemTypes

local function AdjustPixel(img, x,y, r, g, b, a)
	local r1, g1, b1, a1 = img:getPixel(x,y)
	img:setPixel(x,y,r1+r, g1+g, b1+b, a1+a)

end
							



							
function CreateBaseTexture(tex,b,i,j)

	if not Textures[tex] then
		Textures[tex] ={}
	end
	
	if #Textures[tex] < 10 then
		local t = {}
		for i = 0, TUB_SIZE do
			t[i] = {}
		end
		
		
			local offset = random(-5,5)
		
		local r,g,b,a = unpack(Data[tex].background)
		r,g,b,a = r+offset, g+offset, b+offset, a
		
	
		for i = 0,TUB_SIZE-1 do --set the background color
			for j = 0,TUB_SIZE-1 do
				t[i][j] = {r,g,b,a}
			end
		end
		
		for i = 1, random(1,5) do --random colour variation
			local x = random(0,TUB_SIZE-2)
			local y = random(0,TUB_SIZE-2)
			
			
			local r,g,b,a = unpack(Data[tex].background)
			
			t[x][y] = {r+offset+10,g+offset+10,b+offset+10,a}
			t[x+1][y] = {r+offset+10,g+offset+10,b+offset+10,a}
			t[x][y+1] = {r+offset+10,g+offset+10,b+offset+10,a}
			t[x+1][y+1] = {r+offset+10,g+offset+10,b+offset+10,a}
			
			
		end
		
		for i = 1, random(1,5) do --random colour variation
			local x = random(0,TUB_SIZE-2)
			local y = random(0,TUB_SIZE-2)
			local r,g,b,a = unpack(Data[tex].background)
			t[x][y] = {r+offset-10,g+offset-10,b+offset-10,a}
			t[x+1][y] = {r+offset-10,g+offset-10,b+offset-10,a}
			t[x][y+1] = {r+offset-10,g+offset-10,b+offset-10,a}
			t[x+1][y+1] = {r+offset-10,g+offset-10,b+offset-10,a}
			
		end
		 local im = love.image.newImageData(TUB_SIZE, TUB_SIZE)
		 for i = 0, TUB_SIZE-1 do
			for j = 0, TUB_SIZE-1 do
				im:setPixel(i,j,unpack(t[i][j]))
			end
		end
		
		im = love.graphics.newImage(im)
		
		Textures[tex][#Textures[tex]+1] = im

		return random(10)
	else
		return random(10)
	end
end



function SetEdgeTexture(b, t, i, j,refresh)
	local left, right, top, bottom
	
	if j == 0 then --checking top
		local test = World.Buckets[b.i][b.j-1]
		if test then
			if test.tubs[i] and test.tubs[i][BUCKET_YCOUNT-1] then
				top = test.tubs[i][BUCKET_YCOUNT-1]
			end
		end
	else
		if b.tubs[i] then
			top = b.tubs[i][j-1]
		end
	end
	
	if j == BUCKET_YCOUNT-1 then --checking bottom
		local test = World.Buckets[b.i][b.j+1]
		if test then
			test = test.tubs[i]
			if test and test[0] then
				bottom = test[0]
			end
		end
	else
		if b.tubs[i] then
			bottom = b.tubs[i][j+1]
		end
	end
	
	if i == 0 then --checking left
		local test = World.Buckets[b.i-1] and World.Buckets[b.i-1][b.j]
		if test then
			test = test.tubs[BUCKET_XCOUNT-1]
			if test and test[j] then
				left = test[j]
			end
		end
	else
		if b.tubs[i-1] then
			left = b.tubs[i-1][j]
		end
	end
	
	if i == BUCKET_XCOUNT-1 then --checking right
		local test = World.Buckets[b.i+1] and World.Buckets[b.i+1][b.j]
		if test then
			test = test.tubs[0]
			if test and test[j] then
				right= test[j]
			end
		end
	else
		if b.tubs[i+1] then
			right = b.tubs[i+1][j]
		end
	end
	
	

	return (left and 1 or 0)..(right and 1 or 0)..(top and 1 or 0)..(bottom and 1 or 0)
	
end


--============================================================
--============================================================

CreateIcon = {}

function CreateIcon(tex)
	local img = love.image.newImageData(8,8)
	
	for i = 0,7 do
		for j = 0, 7 do
			img:setPixel(i,j, unpack(Data[tex].background))
		end
	end
	img = love.graphics.newImage(img)
	Icons[tex] = img
	return img
end


function GetIcon(tex)
	return Icons[tex] or CreateIcon(tex)
end





