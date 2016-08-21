local ability = {}
ability.description = "Create bubbles to trap bats"

function ability:trigger(parent)
	table.insert(objects["bullet"], bubble:new(parent.x - 4, parent.y))
end

--BUBBLES--

bubble = class("bubble")

function bubble:init(x, y)
	self.x = x
	self.y = y
	
	self.width = 15
	self.height = 15
	
	self.speedx = 0
	self.speedy = -25
	
	self.active = true
	
	self.passive = true
	
	self.gravity = 0
	
	self.bats = {}
end

function bubble:update(dt)
	if love.math.random(10) == 1 then
		self.speedx = love.math.random(-64, 64)
	end
	
	for k, v in pairs(self.bats) do
		if (self.y - 3) + self.height < 0 then
			v:die(false, false)
			self.remove = true
		end
		
		local mulX, mulY = 4, 6
		if v.struggle then
			mulX, mulY = 8, 16
		end
		v.x = self.x - 15 + math.cos(love.timer.getTime() * mulX) * 6
		
		v.y = self.y - 7 + math.sin(love.timer.getTime() * mulX) * mulY
	end
end

function bubble:draw()
	love.graphics.circle("line", self.x * scale, self.y * scale, 15 * scale)
	love.graphics.circle("fill", (self.x - 3) * scale, (self.y - 3) * scale, 3 * scale)
end

function bubble:passiveCollide(name, data)
	if name == "bat" then
		for k = #self.bats, 1, -1 do
			if self.bats[k] == data then
				return
			end
		end
		
		if love.math.random() < 0.1 then
			data.struggle = true
		end
		data.mask["barrier"] = false
		table.insert(self.bats, data)
	end
end

return ability