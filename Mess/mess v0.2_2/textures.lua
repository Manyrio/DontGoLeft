
--======= locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor

local Draw = love.graphics.draw

--========================================


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
		local t = love.image.newImageData(TUB_SIZE,TUB_SIZE)
		local offset = random(-5,5)
		for i = 0,TUB_SIZE-1 do --set the background color
			for j = 0,TUB_SIZE-1 do
				local r,g,b,a = unpack(Data[tex].background)
				
				r,g,b = r+offset, g+offset, b+offset
				t:setPixel(i,j, r,g,b,a)
			end
		end
		
		for i = 1, random(1,5) do --random colour variation
			local x = random(0,TUB_SIZE-2)
			local y = random(0,TUB_SIZE-2)
			local r,g,b,a = unpack(Data[tex].background)
			
			t:setPixel(x,y,r+offset+10,g+offset+10,b+offset+10,a)
			t:setPixel(x+1,y,r+offset+10,g+offset+10,b+offset+10,a)
			t:setPixel(x,y+1,r+offset+10,g+offset+10,b+offset+10,a)
			t:setPixel(x+1,y+1,r+offset+10,g+offset+10,b+offset+10,a)
			
		end
		
		for i = 1, random(1,5) do --random colour variation
			local x = random(0,TUB_SIZE-2)
			local y = random(0,TUB_SIZE-2)
			local r,g,b,a = unpack(Data[tex].background)
			t:setPixel(x,y,r+offset-10,g+offset-10,b+offset-10,a)
			t:setPixel(x+1,y,r+offset-10,g+offset-10,b+offset-10,a)
			t:setPixel(x,y+1,r+offset-10,g+offset-10,b+offset-10,a)
			t:setPixel(x+1,y+1,r+offset-10,g+offset-10,b+offset-10,a)
			
		end
		
		
		Textures[tex][#Textures[tex]+1] = {tex,t}

		return Textures[tex][#Textures[tex]]
	else
		return Textures[tex][random(20)]
	end
end


local function CheckSides(t,tex,left,right,top,bottom)
		

	for i = 0, TUB_SIZE-1 do --cut off the edges if needed
		for j = 0, TUB_SIZE-1 do
			
			if (i< (left and (left[1] == tex) and 0 or 2)) or (i > (right and (right[1] == tex) and TUB_SIZE-1 or TUB_SIZE-1-2)) then
				t:setPixel(i,j,1,1,1,0)
			end
			
			if (j< (top and (top[1] == tex) and 0 or 2)) or (j > (bottom and (bottom[1] == tex) and TUB_SIZE-1 or TUB_SIZE-1-2)) then
				t:setPixel(i,j,0,0,0,0)
			end
		end
	end
	
	if not top then
		for i = (left and (left[1] == tex) and 0 or 2), (right and (right[1] == tex) and TUB_SIZE-1 or TUB_SIZE-1-2),2 do
			local j = 0
			if random(3) == 2 then
				
				t:setPixel(i,j,0,0,0,255)
				t:setPixel(i+1,j,0,0,0,255)
				t:setPixel(i,j+1,0,0,0,255)
				t:setPixel(i+1,j+1,0,0,0,255)
				j = 2
				AdjustPixel(t, i,j,20,20,20,0)
				AdjustPixel(t, i+1,j,20,20,20,0)
				AdjustPixel(t, i,j+1,20,20,20,0)
				AdjustPixel(t, i+1,j+1,20,20,20,0)
			else
				j = 2
				t:setPixel(i,j,0,0,0,255)
				t:setPixel(i+1,j,0,0,0,255)
				t:setPixel(i,j+1,0,0,0,255)
				t:setPixel(i+1,j+1,0,0,0,255)
				j = 4
				AdjustPixel(t, i,j,20,20,20,0)
				AdjustPixel(t, i+1,j,20,20,20,0)
				AdjustPixel(t, i,j+1,20,20,20,0)
				AdjustPixel(t, i+1,j+1,20,20,20,0)
			end
		
		end
	end
	
	if not left then
		for j = (top and (top[1] == tex) and 0 or 2), (bottom and (bottom[1] == tex) and TUB_SIZE-1 or TUB_SIZE-1-2),2 do
			local i = 0
			if random(3) == 2 then
				
				t:setPixel(i,j,0,0,0,255)
				t:setPixel(i+1,j,0,0,0,255)
				t:setPixel(i,j+1,0,0,0,255)
				t:setPixel(i+1,j+1,0,0,0,255)
				i = 2
				AdjustPixel(t, i,j,20,20,20,0)
				AdjustPixel(t, i+1,j,20,20,20,0)
				AdjustPixel(t, i,j+1,20,20,20,0)
				AdjustPixel(t, i+1,j+1,20,20,20,0)
			else
				i = 2
				t:setPixel(i,j,0,0,0,255)
				t:setPixel(i+1,j,0,0,0,255)
				t:setPixel(i,j+1,0,0,0,255)
				t:setPixel(i+1,j+1,0,0,0,255)
				i = 4
				AdjustPixel(t, i,j,20,20,20,0)
				AdjustPixel(t, i+1,j,20,20,20,0)
				AdjustPixel(t, i,j+1,20,20,20,0)
				AdjustPixel(t, i+1,j+1,20,20,20,0)
			end
		
		end
	end
	---[[
	if not right then
		for j = (top and (top[1] == tex) and 0 or 2), (bottom and (bottom[1] == tex) and TUB_SIZE-1 or TUB_SIZE-1-2),2 do
			local i = TUB_SIZE-2
			if random(3) == 2 then
				
				t:setPixel(i,j,0,0,0,255)
				t:setPixel(i+1,j,0,0,0,255)
				t:setPixel(i,j+1,0,0,0,255)
				t:setPixel(i+1,j+1,0,0,0,255)
				i = TUB_SIZE-4
				AdjustPixel(t, i,j,20,20,20,0)
				AdjustPixel(t, i+1,j,20,20,20,0)
				AdjustPixel(t, i,j+1,20,20,20,0)
				AdjustPixel(t, i+1,j+1,20,20,20,0)
			else
				i = TUB_SIZE-5
				t:setPixel(i,j,0,0,0,255)
				t:setPixel(i+1,j,0,0,0,255)
				t:setPixel(i,j+1,0,0,0,255)
				t:setPixel(i+1,j+1,0,0,0,255)
				i = TUB_SIZE-6
				AdjustPixel(t, i,j,20,20,20,0)
				AdjustPixel(t, i+1,j,20,20,20,0)
				AdjustPixel(t, i,j+1,20,20,20,0)
				AdjustPixel(t, i+1,j+1,20,20,20,0)
			end
		
		end
	end 
	--]]
end

function SetEdgeTexture(b, t, i, j)



		
		local left, right, top, bottom
		
		if j == 0 then --checking top
			local test = World.Buckets[b.i][b.j-1]
			if test then
				test = test.tubs[i]
				if test and test[BUCKET_YCOUNT] then
					top = test[BUCKET_YCOUNT]
				end
			end
		else
			if b.tubs[i] then
				top = b.tubs[i][j-1]
			end
		end
		
		if j == BUCKET_YCOUNT then --checking bottom
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
			local test = World.Buckets[b.i-1][b.j]
			if test then
				test = test.tubs[BUCKET_XCOUNT]
				if test and test[j] then
					left = test[j]
				end
			end
		else
			if b.tubs[i-1] then
				left = b.tubs[i-1][j]
			end
		end
		
		if i == BUCKET_XCOUNT then --checking right
			local test = World.Buckets[b.i+1][b.j]
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
		if left or right or top or bottom then
		local nt = {t[1], love.image.newImageData(love.image.newEncodedImageData(t[2],"bmp"))}
		
		
			CheckSides(nt[2],nt[1],left,right,top,bottom)
			return nt
		else
			return t
		end
				
end








