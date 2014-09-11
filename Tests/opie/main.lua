--[[
needed:
multiple rings
drag items to rings



]]


--======= general locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor
local sin = math.sin
--==================================



local ring = {}

ring.x = 200
ring.y = 200
ring.sx = 1
ring.sy = 1
ring.center = love.graphics.newImage("center ring.png")
ring.arrow = love.graphics.newImage("ring arrow.png")
ring.crot = 0
ring.arot = 0
ring.timer = 0
ring.alpha = 0


local mouse = {}

function ring.update(dt)

ring.timer = ring.timer + dt
	ring.crot = ring.timer*2
	 mouse.x, mouse.y = love.mouse.getPosition()
	ring.arot = ring.arot + (math.atan2((mouse.x-ring.x),(ring.y-mouse.y)) - ring.arot)*dt*10
	
if ring.growing then
		if ring.alpha > 255 then 
			ring.growing = nil
			ring.alpha = 255
			return
		end
		ring.alpha = ring.alpha + 800*dt
		ring.sx = math.min(1, ring.sx+dt*10)
		ring.sy = ring.sx
elseif ring.shrinking then
	if ring.alpha < 0 then 
			ring.shrinking = nil
			ring.alpha = 0
			return
	end
		ring.alpha = ring.alpha - 800*dt 
		ring.sx = math.max(0, ring.sx-dt*10)
		ring.sy = ring.sx
	end
end



function love.keypressed(key,uni)
	if key == "5" then
		ring.x = mouse.x
		ring.y = mouse.y
		ring.growing = true
		ring.shrinking = nil
	end
end

function love.keyreleased(key)
	if key == "5" then
		ring.shrinking = true
		ring.growing = nil
	end
end



function love.update(dt)
	ring.update(dt)
end




function love.draw()
	love.graphics.setColor(255,255,255,ring.alpha)
	love.graphics.draw(ring.center, ring.x, ring.y, ring.crot, ring.sx/2, ring.sy/2, 128, 128)
	love.graphics.draw(ring.arrow, ring.x, ring.y, ring.arot, ring.sx, ring.sy, 32, 120)
	-- keep an eye on the framerate
	love.graphics.print(love.timer.getFPS(), 400, 400)
end