fizzle = class("fizzle")

function fizzle:init(object, quadType)
	self.x = object.x
	self.y = object.y

	if object.quadi then
		self.quadi = object.quadi

		local graphic, quads = batImage, batQuads[self.quadi][1]
		if quadType == "powerup" then
			graphic = powerupImage
			quads = powerupQuads[self.quadi]
		end

		self.graphic = graphic
		self.quads = quads
	end

	if quadType == "player" then
		self.graphic = object.graphic
	end

	self.width = object.width
	self.height = object.height

	self.fizzleFade = 1

	self.t = quadType
end

function fizzle:update(dt)
	self.fizzleFade = math.max(0, self.fizzleFade - 0.6 * dt)

	if self.fizzleFade == 0 then
		self.remove = true
	end
end

function fizzle:draw()
	love.graphics.setColor(128, 128, 128, 255 * self.fizzleFade)

	if not self.graphic then
		love.graphics.rectangle("fill", self.x * scale, self.y * scale, self.width * scale, self.height * scale)
		return
	elseif not self.quadi then
		love.graphics.draw(self.graphic, self.x * scale, self.y * scale)
		return
	end

	love.graphics.draw(self.graphic, self.quads, self.x * scale, self.y * scale)

	if self.t == "bat" then
		love.graphics.draw(self.graphic, batQuads[self.quadi][2], self.x * scale, self.y * scale)
	end

	love.graphics.setColor(255, 255, 255, 255)
end