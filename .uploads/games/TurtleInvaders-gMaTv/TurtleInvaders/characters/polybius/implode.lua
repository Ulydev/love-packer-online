local ability = {}
ability.description = "Reflect colliding projectiles"

function ability:init(parent)
	self.parent = parent

	self.active = true

	self.timer = 0
	self.fade = 1

	self.activeTimer = 8
end

function ability:trigger(parent)
	if parent then
		self:init(parent)
	end
end

function ability:update(dt)
	if not self.active then
		return
	end

	if self.activeTimer > 0 then
		self.activeTimer = self.activeTimer - dt
	else
		self:reset()
	end

	self.timer = self.timer + 0.5 * dt
	self.fade = math.abs( math.sin( self.timer * math.pi ) / 2 ) + 0.5

	for k, v in pairs(objects["bullet"]) do
		if v.speedy > 0 then
			if self:intersects(v.x, v.y, v.width, v.height) then
				local p = self.parent
				if v.x < (p.x + (p.width * 1/ 3)) then
					v.speedx, v.speedy = -v.speedy, -v.speedy
				elseif v.x >= (p.x + (p.width * 1/3)) and v.x < (p.x + (p.width * 2 / 3)) then
					v.speedy = -v.speedy
				else
					v.speedx, v.speedy = v.speedy, -v.speedy
				end
			end
		end
	end
end

function ability:reset()
	self.active = false
end

function ability:intersects(x, y, width, height)
	local circleX, circleY = self.parent.x, (self.parent.y - self.parent.height / 2)

	local circleDistanceX, circleDistanceY = math.abs(circleX - x), math.abs(circleY - y)

	if (circleDistanceX <= width / 2) or (circleDistanceY <= height / 2) then
		cornerDistance = math.pow(circleDistanceX - width / 2, 2) + math.pow(circleDistanceY - height / 2, 2)

		blipSound:play()

		return cornerDistance <= math.pow(self.parent.width, 2)
	end
end

function ability:draw()
	if not self.active then
		return
	end

	love.graphics.setScissor(self.parent.x * scale, (self.parent.y - self.parent.height / 2) * scale, self.parent.width * scale, self.parent.width / 2 * scale)

	love.graphics.setColor(255, 255, 255, 255 * self.fade)
	
	love.graphics.circle("line", (self.parent.x + self.parent.width / 2) * scale, (self.parent.y + 10) * scale, self.parent.width)

	love.graphics.setColor(255, 255, 255, 255)
	
	love.graphics.setScissor()
end

return ability