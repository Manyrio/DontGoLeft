--======= locals ===========
local random = math.random
local tinsert = table.insert
local floor = math.floor

local CAMERA = CAMERA
local GAME = GAME

local Draw = love.graphics.draw

--========================================

local Items = ItemTypes
							
							
							
				
local function IconDraw(self,xoff,yoff)
	Draw(self.texture,self.x+xoff,self.y+yoff, 0,1,1,self.ox,self.oy )
end




local function Collides(self,newx,newy)
	local b = World.Buckets[self.bx][self.by]
	local tx,ty = floor(newx/TUB_SIZE), floor(newy/TUB_SIZE)

	if b then
		local t = b.tubs[tx] and b.tubs[tx][ty]
	
		if t then
			if t == "air" then
				return false
			else
				return true
			end
		else
			return false
		end
	end	
end

local function InPlayerRange(self,x,y)
	if x > player.x-player.reach and x < player.x+player.width+player.reach then
		if y > player.y-player.reach and y < player.y+player.height+player.reach then
			return true
		end
	else
		return false
	end
end

local function TweenToPlayer(self, x, y, dt)
	self.x = self.x + (player.x+player.width/2-x)*dt*2
	self.y = self.y + (player.y+player.height/2-y)*dt*2
end

local function Pickup(self, x, y,i,j)
	if (x >= player.x-5) and (x <= player.x + player.width+5) then
		if (y >= player.y-5) and (y <= player.y + player.height+5) then
			local found
			for i = 1, #player.items do
				if player.items[i].type == self.type and player.items[i].count < Items[self.type].stack then
					player.items[i].count = player.items[i].count +1
					found = true
					break
				end
			end
			if not found then
				player.items[#player.items+1] = {type = self.type, count = 1}
			end
			table.remove(World.Shown_Buckets[j].items, i)
		end
	end
end


				---[[
function CreateItem(tex, bx,by,tx,ty)
local bucket = World.Buckets[bx][by]


local item = {}
item.type = tex
item.texture = GetIcon(tex)
item.x = tx*TUB_SIZE
item.y = ty*TUB_SIZE+8
item.vx = 0
item.vy = 0
item.ox = 0
item.oy = 8
item.bx = bx
item.by = by
item.Draw = IconDraw
item.Collides = Collides
item.InPlayerRange = InPlayerRange
item.TweenToPlayer = TweenToPlayer
item.Pickup = Pickup

table.insert(bucket.items, item)
end

--]]