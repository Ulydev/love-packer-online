bullet = class("bullet")

function bullet:init(x, y, t, velocity)
	self.x = x
	self.y = y

	self.width = 2
	self.height = 2

	local color = {247, 218, 100}
	local sound = bulletSound

	if t == "laser" then
		color = {255, 73, 56}
		sound = laserSound

		self.height = 10
	elseif t == "anti" then
		color = {147, 101, 184}
	elseif t == "freeze" then
		color = {44, 130, 201}
	end

	self.color = color
	sound:play()

	self.speedx = velocity[1]
	self.speedy = velocity[2]

	self.active = true

	self.gravity = 0

	self.mask =
	{
		["bat"] = true,
		["player"] = true
	}

	self.passive = true

	self.t = t

	self.batCount = 0
	self.batKillTime = 0
end

function bullet:update(dt)
	if self.y < -self.height or self.y > util.getHeight() then
		self.remove = true
	end

	if self.batCount > 0 then
		if self.batKillTime < 0.5 then
			self.batKillTime = self.batKillTime + dt
		else
			self.batCount = 0
		end
	end
end

function bullet:draw()
	love.graphics.setColor(unpack(self.color))
	love.graphics.rectangle("fill", self.x * scale, self.y * scale, self.width * scale, self.height * scale)

	love.graphics.setColor(255, 255, 255)
end

function bullet:passiveCollide(name, data)
	if name == "bat" then
		if self.speedy > 0 then
			return
		end
		
		displayInfo:setEnemyData(data)

		local anti = false
		if self.t == "anti" then
			anti = true
		end
		data:die(false, anti)

		if self.t == "laser" then
			self.batCount = self.batCount + 1

			if self.batCount == 2 then
				achievements[10]:unlock(true)
			end

			return
		end

		self.remove = true
	end

	if name == "boss" then
		if self.speedy > 0 then
			return
		end

		data:takeDamage(-2)

		displayInfo:setEnemyData(data)

		self.remove = true
	end

	if name == "player" then
		if self.speedy < 0 then
			return
		end

		if self.t == "freeze" then
			data:setPowerup("freeze")
		end

		self.remove = true

		if data:getPowerup() == "shield" then
			if self.t ~= "laser" then
				return
			end
		end

		data:addLife(-1)
	end
end