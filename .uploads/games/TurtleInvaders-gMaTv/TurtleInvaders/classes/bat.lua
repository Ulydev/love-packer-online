local batAbilities =
{
	{"shoot", 8},
}

local batPowerups =
{
	{"none", 2},
	{"laser", 18},
	{"freeze", 12}
}

bat = class("bat")

function bat:init(x, y, velocity)
	self.x = x
	self.y = y
	
	self.width = 30
	self.height = 14

	self.speedx = velocity[1]
	self.speedy = velocity[2]

	self.staticSpeed = {self.speedx, self.speedy}

	self.powerupColor = {247, 218, 100}

	self.active = true

	self.timer = 0
	self.quadi = 1

	self.gravity = 0

	self.mask =
	{
		["player"] = true,
		["barrier"] = true
	}

	if not objects then
		return
	end

	local health = 1
	if currentWave > 10 then
		health =  love.math.random(2)
	elseif currentWave > 20 then
		health = love.math.random(3)
	end

	--HANDLE ABILITIES BASED ON DIFFICULTY!
	

	local abilityRandom = love.math.random() --0 to 1

	local bulletTime, shootChance, powerChance = 3, .3, .15
	if difficultyi == 2 then
		bulletTime = 2
		shootChance, powerChance = .35, .2
	elseif difficultyi == 3 then
		bulletTime = 1.5
		shootChance, powerChance = .35, .3
	end
	
	if abilityRandom < shootChance then
		local abilityData = batAbilities[love.math.random(#batAbilities)]

		if currentWave > abilityData[2] then
			self.ability = abilityData[1]

			if abilityData[1] == "shoot" then
				local powerupRandom = love.math.random()

				if powerupRandom < powerChance then
					local powerupData = batPowerups[love.math.random(#batPowerups)]

					if currentWave > powerupData[2] then
						self.powerup = powerupData[1]
					end
				end
			end
		end
	end

	self.bulletTimerMax = bulletTime
	self.bulletTimer = self.bulletTimerMax

	self.angle = 0

	if self.ability == "circle" then
		self.mask["barrier"] = false
	end

	self.maxHealth = health
	self.health = self.maxHealth

	self.setSpeeds = false
end

function bat:update(dt)
	if objects then
		if objects["player"][1] then
			if objects["player"][1]:getPowerup() == "time" then
				dt = dt / 4

				self.speedx = self.staticSpeed[1] / 2
				self.speedy = self.staticSpeed[2] / 2

				if self.setSpeeds then
					self.setSpeeds = false
				end
			else
				if not self.setSpeeds then
					self.speedx = self.staticSpeed[1]
					self.speedy = self.staticSpeed[2]

					self.setSpeeds = true
				end
			end
		end

		if self.ability == "shoot" then
			if self.bulletTimer > 0 then
				self.bulletTimer = self.bulletTimer - dt
			else
				self:shoot()
			end
		end
	end
	
	self.timer = self.timer + 8 * dt
	self.quadi = math.floor(self.timer % 3) + 1

	if self.y > util.getHeight() then
		self.remove = true
	end
end

function bat:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(batImage, batQuads[self.quadi][1], self.x * scale, self.y * scale)

	love.graphics.setColor(unpack(self.powerupColor))
	love.graphics.draw(batImage, batQuads[self.quadi][2], self.x * scale, self.y * scale)
	
	love.graphics.setColor(255, 255, 255)
end

function bat:leftCollide(name, data)
	if name == "barrier" then
		self.speedx = -self.speedx
		return false
	end

	if name == "player" then
		self:die(data)
		return false
	end
end

function bat:rightCollide(name, data)
	if name == "barrier" then
		self.speedx = -self.speedx
		return false
	end

	if name == "player" then
		self:die(data)
		return false
	end
end

function bat:downCollide(name, data)
	if name == "player" then
		self:die(data)
		return false
	end
end

function bat:upCollide(name, data)
	if name == "player" then
		self:die(data)
		return false
	end
end

function bat:getMaxHealth()
	return self.maxHealth
end

function bat:getHealth()
	return self.health
end

function bat:shoot()
	if self.powerup == "shotgun" then
		table.insert(objects["bullet"], bullet:new(self.x + (self.width / 2) - 1, self.y + self.height, "normal", {-100, 120}))
		
		table.insert(objects["bullet"], bullet:new(self.x + (self.width / 2) - 1, self.y + self.height, "normal", {0, 120}))
		
		table.insert(objects["bullet"], bullet:new(self.x + (self.width / 2) - 1, self.y + self.height, "normal", {100, 120}))
	else
		table.insert(objects["bullet"], bullet:new(self.x + (self.width / 2) - 1, self.y + self.height, self.powerup, {0, 120}))
	end

	self.bulletTimer = self.bulletTimerMax
end

function bat:die(player, anti)
	if not player then
		if self.health > 1 then
			self.health = self.health - 1
			return
		end
	end
	
	if displayInfo:getEnemyData() == self then
		displayInfo:setEnemyData(nil)
	end

	self.remove = true

	if not objects["player"][1].ability.passive then
		if not abilities[1].initialize then
			abilityKills = util.clamp(abilityKills + 1, 0, objects["player"][1]:getMaxHealth() * 2)
		end
	end

	gameCreateExplosion(self)

	if player then
		if player:getPowerup() ~= "shield" then
			player:addLife(-1)
		end
		return
	end

	batKillCount = batKillCount + 1

	comboValue = comboValue + 1
	comboTimeout = 0

	local mul = 1
	if anti then
		mul = -1
	end
	gameAddScore(10 * mul)
	
	if self.bulletTimer > 0 and self.bulletTimer < 0.2 then
		achievements[9]:unlock(true)
	end

	local oneup = false
	if objects["player"][1]:getHealth() < objects["player"][1]:getMaxHealth() then
		if love.math.random() < .15 then
			oneup = true
		end
	end

	gameDropPowerup(self.x + (self.width / 2) - 9, self.y + (self.height / 2) - 9, oneup)
end