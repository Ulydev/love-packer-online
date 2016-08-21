star = class("star")

function star:init(x, y, layer)
	self.x = x
	self.y = y

	self.layer = layer

	self.speed = 15 * ((layer - 1) / 2)
	self.r = (layer / 2)
end

function star:update(dt)
	self.y = self.y + self.speed * scale * dt

	if self.y > util.getHeight() then
		self.y = -4
	end
end

function star:draw()
	love.graphics.setColor(255, 255, 255)

	love.graphics.circle("fill", self.x, self.y, self.r * scale)

	love.graphics.setColor(255, 255, 255)
end