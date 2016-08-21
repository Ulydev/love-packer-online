barrier = class("barrier")

function barrier:init(x, y, width, height)
	self.x = x
	self.y = y

	self.width = width
	self.height = height

	self.active = true
	self.static = true

	self.speedx = 0
	self.speedy = 0
end