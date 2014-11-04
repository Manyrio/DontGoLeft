
--======= locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor

local CAMERA = CAMERA
local GAME = GAME

local VARIATION_SIZE = 10

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

local Textures = {}

local Icons = {}

local Data = ItemTypes

local function AdjustPixel(img, x,y, r, g, b, a)
	local r1, g1, b1, a1 = img:getPixel(x,y)
	img:setPixel(x,y,r1+r, g1+g, b1+b, a1+a)
end
			
local function SetBackGroundTexture(texture,r,g,b,a)
	for i = 0,TUB_SIZE-1 do --set the background color
		for j = 0,TUB_SIZE-1 do
			texture[i][j] = {r,g,b,a}
		end
	end
end

local function AddForeGround(texture,r,g,b,a, offset)
	for i = 1, random(1,5) do --random colour variation
		local x = random(0,TUB_SIZE-2)
		local y = random(0,TUB_SIZE-2)
		
		texture[x][y] = {r+offset,g+offset,b+offset,a}
		texture[x+1][y] = {r+offset,g+offset,b+offset,a}
		texture[x][y+1] = {r+offset,g+offset,b+offset,a}
		texture[x+1][y+1] = {r+offset,g+offset,b+offset,a}	
	end
end

local function InitialiseTexture()
	local t = {}
	for i = 0, TUB_SIZE do
		t[i] = {}
	end
	return t
end

function CreateBaseTexture(ItemTypeLabel,b,i,j)
	Textures[ItemTypeLabel] = Textures[ItemTypeLabel] or {}
	--if we have 10 different then use existing
	if #Textures[ItemTypeLabel] >= VARIATION_SIZE then
		return Textures[ItemTypeLabel][random(VARIATION_SIZE)]
	end

	local texture = InitialiseTexture()
	local offset = random(-5,5)	
	local r,g,b,a = unpack(Data[ItemTypeLabel].background)
	r,g,b,a = r+offset, g+offset, b+offset, a
	
	SetBackGroundTexture(texture,r,g,b,a)
	AddForeGround(texture,r,g,b,a,10) -- highlights
	AddForeGround(texture,r,g,b,a,-10) -- lowlights
	
	Textures[ItemTypeLabel][#Textures[ItemTypeLabel]+1] = {oretype = ItemTypeLabel, texture = texture}

	return Textures[ItemTypeLabel][#Textures[ItemTypeLabel]]
end


local function CheckSides(tub,left,right,top,bottom,refresh)
	if not tub then return end
	local imgtable = tub.texture 
	
	local index = (left and left.oretype or 0)..(right and right.oretype or 0)..(top and top.oretype or 0)..(bottom and bottom.oretype or 0)

	tub.imgtable = tub.imgtable or {}
	
	tub.imgtable[index] = tub.imgtable[index] or {}
	
	if #tub.imgtable[index] >= 1 then
		return tub.imgtable[index][random(1)]
	end

	local img = love.image.newImageData(TUB_SIZE, TUB_SIZE)
	--if (left and (left.oretype == tub.oretype) and 2 or 0) == 0 then
		-- ???		
	--end
	
	for i = (left and (tub.oretype == "dirt") and 0 or left and (left.oretype == tub.oretype) and 0 or 2), (right and (tub.oretype == "dirt") and TUB_SIZE-1 or right and (right.oretype == tub.oretype) and TUB_SIZE-1 or TUB_SIZE-1-2) do
		for j = (top and (tub.oretype == "dirt") and 0 or top and (top.oretype == tub.oretype) and 0 or 2), (bottom and (tub.oretype == "dirt") and TUB_SIZE-1 or bottom and (bottom.oretype == tub.oretype) and TUB_SIZE-1 or TUB_SIZE-1-2) do
			img:setPixel(i,j,unpack(imgtable[i][j]))
		end
	end
	
	if left and left.oretype == "dirt" and not (tub.oretype == left.oretype) then
		for i = 0,1 do
			for j = (top and ((top.oretype == tub.oretype) or (top.oretype == "dirt")) and 0 or 2), (bottom and ((bottom.oretype == tub.oretype) or (bottom.oretype == "dirt")) and TUB_SIZE-1 or TUB_SIZE-1-2) do
				img:setPixel(i,j,unpack(Data.dirt.background))
			end
		end
	end
	
	if right and right.oretype == "dirt" and not (tub.oretype == right.oretype) then
		for i = TUB_SIZE-2,TUB_SIZE-1 do
			for j = (top and ((top.oretype == tub.oretype) or (top.oretype == "dirt")) and 0 or 2), (bottom and ((bottom.oretype == tub.oretype) or (bottom.oretype == "dirt")) and TUB_SIZE-1 or TUB_SIZE-1-2) do
				img:setPixel(i,j,unpack(Data.dirt.background))
			end
		end
	end
	
	if top and top.oretype == "dirt" and not (tub.oretype == top.oretype) then
		for j = 0,1 do
			for i = (left and ((left.oretype == tub.oretype) or (left.oretype == "dirt")) and 0 or 2), (right and ((right.oretype == tub.oretype) or (right.oretype == "dirt")) and TUB_SIZE-1 or TUB_SIZE-1-2) do
				img:setPixel(i,j,unpack(Data.dirt.background))
			end
		end
	end
	
	if bottom and bottom.oretype == "dirt" and not (tub.oretype == bottom.oretype) then
		for j = TUB_SIZE-2,TUB_SIZE-1 do
			for i = (left and ((left.oretype == tub.oretype) or (left.oretype == "dirt")) and 0 or 2), (right and ((right.oretype == tub.oretype) or (right.oretype == "dirt")) and TUB_SIZE-1 or TUB_SIZE-1-2) do
				img:setPixel(i,j,unpack(Data.dirt.background))
			end
		end
	end
	---[[
	
	
	for i = 0, TUB_SIZE-1,2 do --cut off the edges if needed
		for j = 0, TUB_SIZE-1,2 do
			local r,g,b,a = unpack(imgtable[i][j])
			r,g,b,a = r-40,g-40,b-40,a
			if not left or left and (left.oretype ~= tub.oretype) and not (tub.oretype == "dirt") then
				if i == 0 then
					if (j > (top and (top.oretype == tub.oretype) and 0 or 2)) and (j < (bottom and (bottom.oretype == tub.oretype) and TUB_SIZE-1 or TUB_SIZE-1-2)) then
					
					if random(3) == 3 then
						
						img:setPixel(i,j,r,g,b,a)
						img:setPixel(i+1,j,r,g,b,a)
						img:setPixel(i,j+1,r,g,b,a)
						img:setPixel(i+1,j+1,r,g,b,a)
						local i = i + 2
						AdjustPixel(img, i,j, 10,10,10,0)
						AdjustPixel(img, i+1,j, 10,10,10,0)
						AdjustPixel(img, i,j+1, 10,10,10,0)
						AdjustPixel(img, i+1,j+1, 10,10,10,0)
					else
						local i = i + 2
						img:setPixel(i,j,r,g,b,a)
						img:setPixel(i+1,j,r,g,b,a)
						img:setPixel(i,j+1,r,g,b,a)
						img:setPixel(i+1,j+1,r,g,b,a)
						
						i = i + 2
						AdjustPixel(img, i,j, 10,10,10,0)
						AdjustPixel(img, i+1,j, 10,10,10,0)
						AdjustPixel(img, i,j+1, 10,10,10,0)
						AdjustPixel(img, i+1,j+1, 10,10,10,0)
					end
					end
				end
			end
			
			if not right or right and (right.oretype ~= tub.oretype) and not (tub.oretype == "dirt") then
				if i == (TUB_SIZE-2) then
					if (j > (top and (top.oretype == tub.oretype) and 0 or 2)) and (j < (bottom and (bottom.oretype == tub.oretype) and TUB_SIZE-1 or TUB_SIZE-1-2)) then
					
					
					if random(3) == 3 then
						local i = TUB_SIZE-2
						img:setPixel(i,j,r,g,b,a)
						img:setPixel(i+1,j,r,g,b,a)
						img:setPixel(i,j+1,r,g,b,a)
						img:setPixel(i+1,j+1,r,g,b,a)
					 i = i - 2
						AdjustPixel(img, i,j, 10,10,10,0)
						AdjustPixel(img, i+1,j, 10,10,10,0)
						AdjustPixel(img, i,j+1, 10,10,10,0)
						AdjustPixel(img, i+1,j+1, 10,10,10,0)
					else
						local i = TUB_SIZE-4
						img:setPixel(i,j,r,g,b,a)
						img:setPixel(i+1,j,r,g,b,a)
						img:setPixel(i,j+1,r,g,b,a)
						img:setPixel(i+1,j+1,r,g,b,a)
						
						 i = i - 2
						AdjustPixel(img, i,j, 10,10,10,0)
						AdjustPixel(img, i+1,j, 10,10,10,0)
						AdjustPixel(img, i,j+1, 10,10,10,0)
						AdjustPixel(img, i+1,j+1, 10,10,10,0)
					end
					end
				end
			end
			

			
			if not top or top and (top.oretype ~= tub.oretype) and not (tub.oretype == "dirt") then
				if j == 0 then
					if (i > (left and (left.oretype == tub.oretype) and 0 or 2)) and (i < (right and (right.oretype == tub.oretype) and TUB_SIZE-1 or TUB_SIZE-1-2)) then
					
					
						if random(3) == 3 then
							img:setPixel(i,j,r,g,b,a)
							img:setPixel(i+1,j,r,g,b,a)
							img:setPixel(i,j+1,r,g,b,a)
							img:setPixel(i+1,j+1,r,g,b,a)
							
							local j = j + 2
							AdjustPixel(img, i,j, 10,10,10,0)
							AdjustPixel(img, i+1,j, 10,10,10,0)
							AdjustPixel(img, i,j+1, 10,10,10,0)
							AdjustPixel(img, i+1,j+1, 10,10,10,0)
						else
							local j = j + 2
							img:setPixel(i,j,r,g,b,a)
							img:setPixel(i+1,j,r,g,b,a)
							img:setPixel(i,j+1,r,g,b,a)
							img:setPixel(i+1,j+1,r,g,b,a)
							
							 j = j + 2
							AdjustPixel(img, i,j, 10,10,10,0)
							AdjustPixel(img, i+1,j, 10,10,10,0)
							AdjustPixel(img, i,j+1, 10,10,10,0)
							AdjustPixel(img, i+1,j+1, 10,10,10,0)
						end
					end
				end
			end
			
			if not bottom or bottom and (bottom.oretype ~= tub.oretype) and not (tub.oretype == "dirt") then
				if j == (TUB_SIZE-2) then
					if (i > (left and (left.oretype == tub.oretype) and 0 or 2)) and (i < (right and (right.oretype == tub.oretype) and TUB_SIZE-1 or TUB_SIZE-1-2)) then
					
					
					if random(3) == 3 then
						local j = TUB_SIZE-2
						img:setPixel(i,j,r,g,b,a)
						img:setPixel(i+1,j,r,g,b,a)
						img:setPixel(i,j+1,r,g,b,a)
						img:setPixel(i+1,j+1,r,g,b,a)
						
						j = j - 2
						AdjustPixel(img, i,j, 10,10,10,0)
						AdjustPixel(img, i+1,j, 10,10,10,0)
						AdjustPixel(img, i,j+1, 10,10,10,0)
						AdjustPixel(img, i+1,j+1, 10,10,10,0)
						
					else
						local j = TUB_SIZE-4
						img:setPixel(i,j,r,g,b,a)
						img:setPixel(i+1,j,r,g,b,a)
						img:setPixel(i,j+1,r,g,b,a)
						img:setPixel(i+1,j+1,r,g,b,a)
						
						j = j - 2
						AdjustPixel(img, i,j, 10,10,10,0)
						AdjustPixel(img, i+1,j, 10,10,10,0)
						AdjustPixel(img, i,j+1, 10,10,10,0)
						AdjustPixel(img, i+1,j+1, 10,10,10,0)
					end
					end
				end
			end				
			
		end
	end
	
	tub.imgtable[index][#tub.imgtable[index]+1] = {oretype = tub.oretype,texture = imgtable,imgdata = img}
	return tub.imgtable[index][#tub.imgtable[index]]
end

local function GetTop(b,i,j)
	return j == 0
	and World:GetBucket(b.i, b.j-1):GetTub(i,BUCKET_YCOUNT-1)
	or b:GetTub(i,j-1)
end

local function GetBottom(b,i,j)
	return j == BUCKET_YCOUNT-1 
	and World:GetBucket(b.i,b.j+1):GetTub(i,0)
	or b:GetTub(i,j+1)
end

local function GetLeft(b,i,j)
	return i == 0 
	and World:GetBucket(b.i-1,b.j):GetTub(BUCKET_XCOUNT-1,j)
	or b:GetTub(i-1,j)
end

local function GetRight(bucket,i,j)
	return i == BUCKET_XCOUNT-1 
	and World:GetBucket(bucket.i+1,bucket.j):GetTub(0,j)
	or bucket:GetTub(i+1,j)
end

function SetEdgeTexture(bucket,i,j,refresh)
	local tub = bucket:GetTub(i,j)
	local top = GetTop(bucket,i,j)
	local bottom = GetBottom(bucket,i,j)
	local left = GetLeft(bucket,i,j)
	local right = GetRight(bucket,i,j)

	return CheckSides(tub,left,right,top,bottom,refresh)
end

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





