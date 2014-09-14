
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

local Textures = {}

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
		
		
		Textures[tex][#Textures[tex]+1] = {tex,t}

		return Textures[tex][#Textures[tex]]
	else
		return Textures[tex][random(10)]
	end
end


local function CheckSides(t,left,right,top,bottom,refresh)
	if not t then return end
	local imgtable = t[2]
	if refresh then 
		imgtable = t[3]
	end
	local index = (left and left[1] or 0)..(right and right[1] or 0)..(top and top[1] or 0)..(bottom and bottom[1] or 0)
		
	if not t[3] then 
		t[3] = {}
	end
	
	if not t[3][index] then
		t[3][index] = {}
	end
	
	if #t[3][index] < 5 then
	
		local img = love.image.newImageData(TUB_SIZE, TUB_SIZE)
		if (left and (left[1] == t[1]) and 2 or 0) == 0 then
			
		end
		
		for i = (left and (t[1] == "dirt") and 0 or left and (left[1] == t[1]) and 0 or 2), (right and (t[1] == "dirt") and TUB_SIZE-1 or right and (right[1] == t[1]) and TUB_SIZE-1 or TUB_SIZE-1-2) do
			for j = (top and (t[1] == "dirt") and 0 or top and (top[1] == t[1]) and 0 or 2), (bottom and (t[1] == "dirt") and TUB_SIZE-1 or bottom and (bottom[1] == t[1]) and TUB_SIZE-1 or TUB_SIZE-1-2) do
				
				img:setPixel(i,j,unpack(imgtable[i][j]))
			end
		end
		
		if left and left[1] == "dirt" and not (t[1] == left[1]) then
			for i = 0,1 do
				for j = (top and ((top[1] == t[1]) or (top[1] == "dirt")) and 0 or 2), (bottom and ((bottom[1] == t[1]) or (bottom[1] == "dirt")) and TUB_SIZE-1 or TUB_SIZE-1-2) do
					img:setPixel(i,j,unpack(Data.dirt.background))
				end
			end
		end
		
		if right and right[1] == "dirt" and not (t[1] == right[1]) then
			for i = TUB_SIZE-2,TUB_SIZE-1 do
				for j = (top and ((top[1] == t[1]) or (top[1] == "dirt")) and 0 or 2), (bottom and ((bottom[1] == t[1]) or (bottom[1] == "dirt")) and TUB_SIZE-1 or TUB_SIZE-1-2) do
					img:setPixel(i,j,unpack(Data.dirt.background))
				end
			end
		end
		
		if top and top[1] == "dirt" and not (t[1] == top[1]) then
			for j = 0,1 do
				for i = (left and ((left[1] == t[1]) or (left[1] == "dirt")) and 0 or 2), (right and ((right[1] == t[1]) or (right[1] == "dirt")) and TUB_SIZE-1 or TUB_SIZE-1-2) do
					img:setPixel(i,j,unpack(Data.dirt.background))
				end
			end
		end
		
		if bottom and bottom[1] == "dirt" and not (t[1] == bottom[1]) then
			for j = TUB_SIZE-2,TUB_SIZE-1 do
				for i = (left and ((left[1] == t[1]) or (left[1] == "dirt")) and 0 or 2), (right and ((right[1] == t[1]) or (right[1] == "dirt")) and TUB_SIZE-1 or TUB_SIZE-1-2) do
					img:setPixel(i,j,unpack(Data.dirt.background))
				end
			end
		end
		---[[
		
		
		for i = 0, TUB_SIZE-1,2 do --cut off the edges if needed
			for j = 0, TUB_SIZE-1,2 do
				local r,g,b,a = unpack(imgtable[i][j])
				r,g,b,a = r-40,g-40,b-40,a
				if not left or left and (left[1] ~= t[1]) and not (t[1] == "dirt") then
					if i == 0 then
						if (j > (top and (top[1] == t[1]) and 0 or 2)) and (j < (bottom and (bottom[1] == t[1]) and TUB_SIZE-1 or TUB_SIZE-1-2)) then
						
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
				
				if not right or right and (right[1] ~= t[1]) and not (t[1] == "dirt") then
					if i == (TUB_SIZE-2) then
						if (j > (top and (top[1] == t[1]) and 0 or 2)) and (j < (bottom and (bottom[1] == t[1]) and TUB_SIZE-1 or TUB_SIZE-1-2)) then
						
						
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
				

				
				if not top or top and (top[1] ~= t[1]) and not (t[1] == "dirt") then
					if j == 0 then
						if (i > (left and (left[1] == t[1]) and 0 or 2)) and (i < (right and (right[1] == t[1]) and TUB_SIZE-1 or TUB_SIZE-1-2)) then
						
						
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
				
				if not bottom or bottom and (bottom[1] ~= t[1]) and not (t[1] == "dirt") then
					if j == (TUB_SIZE-2) then
						if (i > (left and (left[1] == t[1]) and 0 or 2)) and (i < (right and (right[1] == t[1]) and TUB_SIZE-1 or TUB_SIZE-1-2)) then
						
						
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
		
	
		
		
		t[3][index][#t[3][index]+1] = {t[1],img,imgtable}
		return t[3][index][#t[3][index]]
	else
		return t[3][index][random(5)]
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

	return CheckSides(t,left,right,top,bottom,refresh)
	
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





