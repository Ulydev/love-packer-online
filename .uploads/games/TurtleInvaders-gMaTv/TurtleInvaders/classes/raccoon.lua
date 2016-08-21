raccoon = class("raccoon")

function raccoon:init()
	self.x = 178
	self.y = 94

	self.width = 44
	self.height = 54

	self.mask =
	{
		["barrier"] = true
	}

	self.gravity = 0

	self.quadi = 1
	self.timer = 0

	self.active = true

	self.speedx = 0
	self.speedy = 0

	local speeds = {-180, 180}
	self.speed = speeds[love.math.random(#speeds)]

	menuSong:stop()

	bossSong:play()

	local health = 100
	if difficultyi > 1 then
		health = 100 + (difficultyi - 1) * 40
	end

	self.realHealth = health 
	self.realMaxHealth = self.realHealth

	self.health = self.realMaxHealth / 20
	self.maxHealth = self.health

	self.initialize = false

	self.fade = 0

	self.fadeIn = true

	self.deathDelay = 0.05

	self.shouldDraw = true

	self.invincible = false
	self.invincibleTimer = 0
	
	self.fadeTimer = 0

	displayInfo:setEnemyData(self)
end

function raccoon:update(dt)
	if self.dead then
		if self.fade > 0 then
			if self.deathDelay > 0 then
				self.deathDelay = self.deathDelay - dt
				shakeValue = 10
			else
				table.insert(explosions, explosion:new(love.math.random(self.x, self.x + self.width), love.math.random(self.y, self.y + self.height)))
				self.deathDelay = 0.05
			end
			self.fade = math.max(self.fade - 0.6 * dt, 0)
		else
			self:die()
		end
		return
	end

	if not self.fadeIn then
		self.fade = math.max(self.fade - 0.6 * dt, 0)
	else
		self.fade = math.min(self.fade + 0.6 * dt, 1)
	end

	if not self.initialize then
		if self.fade == 1 then
			self.speedx = self.speed

			self.initialize = true
		end
	else
		self.fadeTimer = self.fadeTimer + dt
		if self.fadeTimer > 3 then
			self.fadeIn = not self.fadeIn
			self.fadeTimer = 0
		end
	end

	if self.invincible then
		self.invincibleTimer = self.invincibleTimer + 8 * dt

		if math.floor(self.invincibleTimer % 2) == 0 then
			self.shouldDraw = false
		else
			self.shouldDraw = true
		end

		if self.invincibleTimer > 16 then
			self.shouldDraw = true
			self.invincibleTimer = 0
			self.invincible = false
		end
	end
end

function raccoon:leftCollide(name, data)
	if name == "barrier" then
		self.speedx = -self.speedx
		return false
	end
end

function raccoon:rightCollide(name, data)
	if name == "barrier" then
		self.speedx = -self.speedx
		return false
	end
end

function raccoon:draw()
	if not self.shouldDraw then
		return
	end

	love.graphics.setColor(255, 255, 255, 255 * self.fade)
	love.graphics.draw(raccoonImage, raccoonQuads[self.quadi], self.x * scale, self.y * scale + math.sin(love.timer.getTime() * 8) * 10 * scale)

	love.graphics.setColor(255, 255, 255, 255)
end

function raccoon:takeDamage(damageValue)
	if self.invincible then
		return
	end

	self.realHealth = util.clamp(self.realHealth + damageValue, 0, self.realMaxHealth)

	if self.realHealth > 0 then
		if self.realHealth % 20 == 0 then
			self.health = self.health - 1
			self.invincible = true
		end
	else
		self.speedx = 0
		self.fade = 1
		self.dead = true
	end
end

function raccoon:getHealth()
	return self.health
end

function raccoon:getMaxHealth()
	return self.maxHealth
end

function raccoon:die()
	if displayInfo:getEnemyData() == self then
		displayInfo:setEnemyData(nil)
	end

	bossSong:stop()

	menuSong:play()

	achievements[2]:unlock(true)
	
	gameAddScore(3000)

	if objects["player"][1] then
		objects["player"][1]:addMaxHealth()
	end
	
	self.remove = true
end