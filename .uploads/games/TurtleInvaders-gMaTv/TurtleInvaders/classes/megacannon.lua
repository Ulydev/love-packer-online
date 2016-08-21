megacannon = class("megacannon")

function megacannon:init(player)
	self.parent = player

	self.y = 0
	self.x = player.x
	self.width = 16
	self.height = player.y

	self.baseQuadi = 1

	self.boomQuadi = 1
	self.boomTimer = 0

	self.beami = 1

	self.initialize = false

	self.active = true
	--self.static = true

	self.speedx = 0
	self.speedy = 0

	self.gravity = 0

	self.mask =
	{
		["bat"] = true,
		["powerup"] = true,
		["bullet"] = true,
		["boss"] = false
	}

	megaCannonSound:play()

	self.passive = true
end

function megacannon:passiveCollide(name, data)
	if not self.initialize then
		return
	end

	local pass = true
	if name == "bullet" then
		if data.speedy <= 0 then
			pass = false
		end
	end

	if name == "boss" or name == "player" then
		pass = false
	end

	if pass then
		if name == "bat" then
			gameAddScore(100)
		end

		fizzleSound:play()

		shakeValue = 10

		table.insert(fizzles, fizzle:new(data, name))
		
		data.remove = true
	end
end

function megacannon:update(dt)
	self.x = self.parent.x + (self.parent.width / 2) - 11

	self.boomTimer = self.boomTimer + 18 * dt
	self.boomQuadi = math.floor(self.boomTimer % #megaCannonBoomQuads) + 1

	if not self.initialize then
		if self.boomQuadi == 15 then
			self.initialize = true
		end
	else
		self.baseQuadi = math.floor(self.boomTimer % 5) + 1
		self.beami = math.floor(self.boomTimer % #megaCannonBeamQuads) + 1

		if not megaCannonSound:isPlaying() then
			self.remove = true
		end
	end
end

function megacannon:draw()
	local x, y = self.parent.x + (self.parent.width / 2) - 40, self.parent.y - 60

	love.graphics.draw(megaCannonBoomImage, megaCannonBoomQuads[self.boomQuadi], x * scale, y * scale)
	if not self.initialize then
		return
	end

	for y = 2, math.floor(self.height / 22) - 1 do
		love.graphics.draw(megaCannonBeamImage, megaCannonBeamQuads[self.beami], (self.parent.x + (self.parent.width / 2) - 11) * scale, (self.parent.y - 16 - (y + 1) * 22) * scale)
	end

	love.graphics.draw(megaCannonBaseImage, megaCannonBaseQuads[self.baseQuadi], x * scale, y * scale)
end