

---[=[
local effect = love.graphics.newPixelEffect [[
	extern number radius;
	extern vec2 imageSize;
	extern vec2 direction;

	vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
	{
	   color = vec4(0);
	   vec2 st;
	   vec2 pixdir = direction / imageSize;
	   for (float i = -radius; i <= radius; i++) {
	      st.xy = i * pixdir;
	      color += Texel(tex, tc + st);
	   }
	   return color / (2.0 * radius + 1.0);
	}
]]
--]=]


local radius = 0.0
local img = love.graphics.newImage("ball.png")
local blurHorizontal = love.graphics.newCanvas(50, 50)
local blurVertical = love.graphics.newCanvas(50, 50)



effect:send('imageSize', love.graphics.getWidth(), love.graphics.getHeight())
effect:send('radius', radius)





function love.keypressed(key)
	if key == "up" then
		radius = radius + 1 
	elseif key == "down" then
		radius  = radius - 1
	end
	effect:send("radius", radius) --send the data to the shader
end




function love.draw()
	blurHorizontal:clear()
	blurVertical:clear()
	love.graphics.setPixelEffect()
	love.graphics.print(love.timer.getFPS(), 10, 10)


	love.graphics.setRenderTarget(blurHorizontal)
	love.graphics.draw(img,30, 30)


	love.graphics.setPixelEffect(effect)

	effect:send('direction', 1,0)
	love.graphics.setRenderTarget(blurVertical)
	love.graphics.draw(blurHorizontal, 0,0)

	effect:send('direction', 0,1)
	love.graphics.setRenderTarget()
	love.graphics.draw(blurVertical, 0,0)
end


--=========