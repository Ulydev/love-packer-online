explosion = class("explosion")

function explosion:init(x, y)
	self.x = x
	self.y = y

	self.timer = 0
	self.quadi = 1

	explodeSound:play()
end

function explosion:update(dt)
	if self.quadi < 6 then
		self.timer = self.timer + 8 * dt
		self.quadi = math.floor(self.timer % 6) + 1
	else
		self.remove = true
	end
end

function explosion:draw()
	love.graphics.draw(explosionImage, explosionQuads[self.quadi], self.x * scale, self.y * scale)
end