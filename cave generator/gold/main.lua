local draw = love.graphics.drawlocal rect = love.graphics.rectanglelocal random = math.randomlocal floor = math.floorlocal t = {}math.randomseed(20)local width = 200local height = 200for i = 1, width do	t[i] = {}	for j = 1, height do		t[i][j] = {108,61,37,255}	endendlocal size = 4local function SetPixels(t,x,y)local size = 1 +  random(-1,3)	for i = 1, size do				for j = 1, size+random(-1,3) do			i = i + random(-1,2)			if not t[i+x] then				t[i+x] = {}			end			t[i+x][j+y] = nil		end	endendlocal function CountPixels(x,y)	local count = 0	for i = -1, 1 do		for j = -1, 1 do			if t[i+x] and t[i+x][j+y] then				count = count + 1			end		end	end	return countendlocal function test()	for i = 1, width do		for j = 1, height do			if random(1000) >  998	then				SetPixels(t,i,j)			end		end	end		for i = 1, width do		for j = 1, height do			if random(10) == 1 then				t[i][j] = nil			end		end	endendlocal function meep()	for i = 1, width do		for j = 1, height do			local count = CountPixels(i,j)			if count < 4 then				t[i][j] = nil			elseif count > 5 then				t[i][j] = {108,61,37,255}			end		end	endendfunction love.mousepressed()for i = 1, width do	t[i] = {}	for j = 1, height do		t[i][j] = {108,61,37,255}	endend	print("test")	test()endfunction love.keypressed()	meep()endfunction love.draw()	for i = 1, width do		for j = 1, height do			if t[i] and t[i][j] then				love.graphics.setColor(unpack(t[i][j]))				rect("fill", i*size, j*size, size-1, size-1)			end		end	end	love.graphics.print(love.timer.getFPS(), 10, 10)end