
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

local function FillCroppedBackground(tub,extents,img)
	for i = extents.left, extents.right do
		for j = extents.top, extents.bottom do
			img:setPixel(i,j,unpack(tub.texture[i][j]))
		end
	end
end

local function FillSideBackGround(tubs,extents, img)

	local config = {
					left = {imin = 0, imax = 1, jmin = extents.top, jmax = extents.bottom},
					right = {imin = TUB_SIZE-2, imax = TUB_SIZE-1, jmin = extents.top, jmax = extents.bottom},
					top = {imin = extents.left, imax = extents.right, jmin = 0, jmax = 1},
					bottom = {imin = extents.left, imax = extents.right, jmin = TUB_SIZE-2, jmax = TUB_SIZE-1}
				}


	for name,v in pairs(config) do
		if tubs[name] and tubs[name].oretype == "dirt" and not (tubs.center.oretype == tubs[name].oretype) then
			for i = v.imin, v.imax do
				for j = v.jmin, v.jmax do
					img:setPixel(i,j,unpack(ItemTypes.dirt.background))
				end
			end
		end
	end
end


local function GetExtents(tubs)
	local centerTub = tubs.center

	local configs = {
				left = {min = 0, max = 2},
				right = {min = TUB_SIZE-1, max = TUB_SIZE-1-2},
				top = {min = 0, max = 2},
				bottom = {min = TUB_SIZE-1, max = TUB_SIZE-1-2}
			}

	local extents = {}

	for name,v in pairs(configs) do
		if not tubs[name] then
			extents[name] = v.max
		else
			if centerTub.oretype == "dirt" or tubs[name].oretype == centerTub.oretype then
				extents[name] = v.min
			else 
				extents[name] = v.max
			end
		end
	end
	return extents
end

local function GetIndex(tubs)
	return (tubs.left and tubs.left.oretype or 0)..(tubs.right and tubs.right.oretype or 0)..(tubs.top and tubs.top.oretype or 0)..(tubs.bottom and tubs.bottom.oretype or 0)
end

local function SetSquare(img,i,j,r,g,b,a)
	img:setPixel(i,j,r,g,b,a)
	img:setPixel(i+1,j,r,g,b,a)
	img:setPixel(i,j+1,r,g,b,a)
	img:setPixel(i+1,j+1,r,g,b,a)
end

local function AdjustSquare(img,i,j,v)
	AdjustPixel(img, i,j, v,v,v,0)
	AdjustPixel(img, i+1,j,v,v,v,0)
	AdjustPixel(img, i,j+1,v,v,v,0)
	AdjustPixel(img, i+1,j+1,v,v,v,0)
end

local function FillSideEdges(tubs,extents,img)
	local tub = tubs.center
	for i = 0, TUB_SIZE-1,2 do --cut off the edges if needed
		for j = 0, TUB_SIZE-1,2 do
			local r,g,b,a = unpack(tub.texture[i][j])
			r,g,b,a = r-40,g-40,b-40,a

			if not tubs.left or tubs.left and (tubs.left.oretype ~= tub.oretype) and not (tub.oretype == "dirt") then
				if i == 0 then
					if j > extents.top and j < extents.bottom then
					
					if random(3) == 3 then
						SetSquare(img,i,j,r,g,b,a)
						local i = i + 2
						AdjustSquare(img,i,j,10)
					else
						local i = i + 2
						SetSquare(img,i,j,r,g,b,a)
						
						i = i + 2
						AdjustSquare(img,i,j,10)
					end
					end
				end
			end
			
			if not tubs.right or tubs.right and (tubs.right.oretype ~= tub.oretype) and not (tub.oretype == "dirt") then
				if i == (TUB_SIZE-2) then
					if (j > (tubs.top and (tubs.top.oretype == tub.oretype) and 0 or 2)) and (j < (tubs.bottom and (tubs.bottom.oretype == tub.oretype) and TUB_SIZE-1 or TUB_SIZE-1-2)) then
					
					
					if random(3) == 3 then
						local i = TUB_SIZE-2
						SetSquare(img,i,j,r,g,b,a)
					 i = i - 2
						AdjustSquare(img,i,j,10)
					else
						local i = TUB_SIZE-4
						SetSquare(img,i,j,r,g,b,a)
						
						 i = i - 2
						AdjustSquare(img,i,j,10)
					end
					end
				end
			end
			

			
			if not tubs.top or tubs.top and (tubs.top.oretype ~= tub.oretype) and not (tub.oretype == "dirt") then
				if j == 0 then
					if (i > (tubs.left and (tubs.left.oretype == tub.oretype) and 0 or 2)) and (i < (tubs.right and (tubs.right.oretype == tub.oretype) and TUB_SIZE-1 or TUB_SIZE-1-2)) then
					
					
						if random(3) == 3 then
						SetSquare(img,i,j,r,g,b,a)
							local j = j + 2
						AdjustSquare(img,i,j,10)
						else
							local j = j + 2
						SetSquare(img,i,j,r,g,b,a)
							
							 j = j + 2
						AdjustSquare(img,i,j,10)
						end
					end
				end
			end
			
			if not tubs.bottom or tubs.bottom and (tubs.bottom.oretype ~= tub.oretype) and not (tub.oretype == "dirt") then
				if j == (TUB_SIZE-2) then
					if (i > (tubs.left and (tubs.left.oretype == tub.oretype) and 0 or 2)) and (i < (tubs.right and (tubs.right.oretype == tub.oretype) and TUB_SIZE-1 or TUB_SIZE-1-2)) then
					
					
					if random(3) == 3 then
						local j = TUB_SIZE-2
						SetSquare(img,i,j,r,g,b,a)
						
						j = j - 2
						AdjustSquare(img,i,j,10)
						
					else
						local j = TUB_SIZE-4
						SetSquare(img,i,j,r,g,b,a)
						
						j = j - 2
						AdjustSquare(img,i,j,10)
					end
					end
				end
			end				
			
		end
	end
end

local function CheckSides(bucket,tubs,refresh)
	if not tubs.center then return end 
	local tub = tubs.center
	local index = GetIndex(tubs)
	tub.imgtable = tub.imgtable or {}
	tub.imgtable[index] = tub.imgtable[index] or {}
	
	if #tub.imgtable[index] >= 5 then
		return tub.imgtable[index][random(5)]
	end

	local img = love.image.newImageData(TUB_SIZE, TUB_SIZE)

	local extents = GetExtents(tubs)
	FillCroppedBackground(tub,extents,img)
	FillSideBackGround(tubs,extents,img)
	FillSideEdges(tubs, extents, img)
	
	tub.imgtable[index][#tub.imgtable[index]+1] = {oretype = tub.oretype,texture = tub.texture,imgdata = img}
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
	return i == BUCKET_XCOUNT-1 and World:GetBucket(bucket.i+1,bucket.j):GetTub(0,j)
	or bucket:GetTub(i+1,j)
end

function SetEdgeTexture(bucket,i,j,refresh)
	local tubs = {top = GetTop(bucket,i,j),
										    bottom = GetBottom(bucket,i,j),
												left = GetLeft(bucket,i,j),
												right = GetRight(bucket,i,j),
											  center = bucket:GetTub(i,j)}

	return CheckSides(bucket,tubs,refresh)
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





