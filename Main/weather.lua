Scene.type.night.weather = {}
Scene.type.night.weather.cloud = {scale = {80,120},
																		height = {0,SCREEN_HEIGHT/4},
																		speed = {80,120},
																		number = 10
																	}
Scene.type.night.weather.rain = {scale = {10,30},
																		rot = -0.8,
																		speed = {140,200},
																		number = 100
																	}
																	
																	Scene.type.day.weather = {}
Scene.type.day.weather.cloud = {scale = {130,170},
																		height = {0,SCREEN_HEIGHT/4},
																		speed = {30,40},
																		number = 10
																	}
Scene.type.day.weather.rain = {scale = {10,30},
																		rot = -0.8,
																		speed = {140,200},
																		number = 0
																	}
																	
																	
																	
weather = {}
weather.maxobjects = 30
weather.entities = {}

weather.timer = 0
weather.interval =  0.1
weather.objects = {}

local NewEnt = {}

function NewEnt.cloud(vars)
local t = {}
t.tex = love.graphics.newImage("img/cloud.png")
t.y =math.random(vars.height[1],vars.height[2])
t.x = 0-t.tex:getWidth() - math.random(200)


t.grav = false
t.scalex = math.random(vars.scale[1], vars.scale[2])/100
t.scaley = t.scalex
t.speed = 100* math.random(vars.speed[1], vars.speed[2])/100
t.offx = (t.tex:getWidth()*t.scalex)/2
t.offy = (t.tex:getHeight()*t.scaley)/2
t.active = true
t.rotspeed = 0
return t
end

function NewEnt.rain(vars)
local t = {}
t.tex = love.graphics.newImage("rain.png")
t.y = (0 - t.tex:getHeight())/2
t.x = math.random(SCREEN_WIDTH+SCREEN_HEIGHT)-SCREEN_WIDTH
if t.x < 1 then
	t.y = t.x* -1
	t.x = 0
end

t.rot = vars.rot

t.grav = true
t.scalex = math.random(vars.scale[1], vars.scale[2])/100
t.scaley = t.scalex
t.speed = 150*math.random(vars.speed[1],vars.speed[2])/100 *(t.scalex+0.5)
t.offx = (t.tex:getWidth()*t.scalex)/2
t.offy = (t.tex:getHeight()*t.scaley)/2
t.active = true
t.rotspeed = 0

return t
end


local function UpdateEnt(self,dt)
--print(self.x, self.y)
self.x = self.x + self.speed*dt
if self.grav then
	self.y = self.y + self.speed*dt	
end
if self.rot then
	self.rot = self.rot + self.rotspeed*dt
end
if self.x > SCREEN_WIDTH or self.y > SCREEN_HEIGHT then
	self.active = false
	weather[self.type].count = weather[self.type].count - 1
end
end

local function DrawEnt(self)
	love.graphics.draw(self.tex, self.x, self.y, self.rot, self.scalex, self.scaley, self.offx, self.offy)
end

function weather.newentity(typ,vars)


local ent = NewEnt[typ](vars)
	ent.type = typ
	ent.update = UpdateEnt
	ent.draw = DrawEnt
	
	return ent
end

function weather:update(dt)
self.timer = self.timer + dt
	if self.timer > self.interval then
		self.timer = self.timer-self.interval
		for typ, vars in pairs(SELECTED_Scene.weather) do
			if not weather[typ] then weather[typ] = {count = 0} end
			
			if weather[typ].count < vars.number then
				local t = weather.newentity(typ,vars)
				for i = 1, #self.objects+1 do
					if not self.objects[i] or not self.objects[i].active then
						self.objects[i] = t
						break
					end
				end
				weather[typ].count = weather[typ].count + 1
			end
		end
	end
	for i = 1, #self.objects do
		if self.objects[i].active then
			self.objects[i]:update(dt)
		end
	end
end

function weather:draw()
	for i = 1, #self.objects do
		if self.objects[i].active then
			self.objects[i]:draw()
		end
	end
end
