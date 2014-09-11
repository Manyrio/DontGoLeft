
--[[
create table tubs_size by tub_size
add texture



--]]


--======= locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor

local Draw = love.graphics.draw

--========================================
local randomline = {}

for i = 1, 20 do
	for j = 1, random(4) do
		tinsert(randomline, (random(2) == 2) or false)
	end
end

local Lines = {}
--=======================================

local Create = {}

local Textures = {}

local Data = {
							dirt = {
											background = {107,76,53,255},
											foreground = {119,92,45,255},
											},
							stone = {
											background = {163, 163, 163, 255},
											foreground = {120,120,120,255},
											},
							rock = {
											background = {115,115,115,255},
											foreground = {80,80,80,255},
											},
							deadstone = {
											background = {59,60,111,255},
											foreground = {20,21,65,255},
											},
							gold = {
											background = {199,205,152,255},
											foreground = {215,203,67,255},
											},
							mud = {
											background = {91,84,109,255},
											foreground = {80,70,90,255},
											}
							}
local function AdjustPixel(img, x,y, r, g, b, a)
	local r1, g1, b1, a1 = img:getPixel(x,y)
	img:setPixel(x,y,r1+r, g1+g, b1+b, a1+a)

end
							



							
function CreateBaseTexture(tex,b,i,j)

	if not Textures[tex] then
		Textures[tex] ={}
	end
	
	if #Textures[tex] < 20 then
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
		return Textures[tex][random(20)]
	end
end


local function CheckSides(t,left,right,top,bottom,refresh)
	if not t then return end
	local imgtable = t[2]
	if refresh then 
		imgtable = t[3]
	end
	local index = (left and 1 or 0)..(right and 1 or 0)..(top and 1 or 0)..(bottom and 1 or 0)
		
	if not t[3] then 
		t[3] = {}
	end
	
	if not t[3][index] then
		t[3][index] = {}
	end
	
	if #t[3][index] < 20 then
	
		local img = love.image.newImageData(TUB_SIZE, TUB_SIZE)
		if (left and (left[1] == t[1]) and 2 or 0) == 0 then
			
		end
		
		for i = (left and (left[1] == t[1]) and 0 or 2), (right and (right[1] == t[1]) and TUB_SIZE-1 or TUB_SIZE-1-2) do
			for j = (top and (top[1] == t[1]) and 0 or 2), (bottom and (bottom[1] == t[1]) and TUB_SIZE-1 or TUB_SIZE-1-2) do
				
				img:setPixel(i,j,unpack(imgtable[i][j]))
			end
		end
		
		 
		---[[
		
		
		for i = 0, TUB_SIZE-1,2 do --cut off the edges if needed
			for j = 0, TUB_SIZE-1,2 do
				local r,g,b,a = unpack(imgtable[i][j])
				r,g,b,a = r-20,g-20,b-20,a
				if not left then
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
				
				if not right then
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
				

				
				if not top then
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
				
				if not bottom then
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
		return t[3][index][random(20)]
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








