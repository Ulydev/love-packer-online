megabat = class("megabat")

function megabat:init(speedx)
	self.x = 170
	self.y = -bossImage:getHeight()

	self.width = 60
	self.height = 30

	self.active = true

	self.mask =
	{
		["bullet"] = true,
		["barrier"] = true
	}

	self.speedx = speedx
	self.speedy = 0

	self.gravity = 0

	self.timer = 0
	self.quadi = 1

	menuSong:stop()

	bossSong:play()

	local health = 60
	if difficultyi > 1 then
		health = 60 + (difficultyi - 1) * 40
	end

	self.realHealth = health 
	self.realMaxHealth = self.realHealth

	self.health = self.realMaxHealth / 20
	self.maxHealth = self.health

	self.initialize = false

	displayInfo:setEnemyData(self)

	self.invincible = false
	self.invincibleTimer = 0

	self.shouldDraw = true

	local shootTimerMax = 3
	if difficultyi == 2 then
		maxShootTime = 2
	elseif difficultyi == 3 then
		maxShootTime = 1
	end
	self.shootTimerMax = shootTimerMax
	
	self.shootTimer = self.shootTimerMax

	self.deathDelay = 0.05

	self.fade = 1
end

function megabat:update(dt)
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

	self.timer = self.timer + 8 * dt
	self.quadi = math.floor(self.timer % #bossQuads) + 1

	if not self.initialize then
		if self.y + (self.height / 2) < (util.getHeight() / scale) / 2 then
			self.speedy = 100
		else
			self.speedy = 0
			self.initialize = true
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

	if self.realHealth < self.realMaxHealth / 2 then
		if self.shootTimer > 0 then
			self.shootTimer = self.shootTimer - dt
		else
			self:shoot()
		end
	end
end

function megabat:leftCollide(name, data)
	if name == "barrier" then
		self.speedx = -self.speedx
		return false
	end
end

function megabat:rightCollide(name, data)
	if name == "barrier" then
		self.speedx = -self.speedx
		return false
	end
end

function megabat:draw()
	if not self.shouldDraw then
		return
	end
	love.graphics.setColor(255, 255, 255, 255 * self.fade)

	love.graphics.draw(bossImage, bossQuads[self.quadi], self.x * scale, self.y * scale)

	love.graphics.setColor(255, 255, 255, 255)
end

function megabat:shoot()
	table.insert(objects["bullet"], bullet:new(self.x + (self.width / 2) - 1, self.y + self.height + 1, "normal", {-100, 100}))

	table.insert(objects["bullet"], bullet:new(self.x + (self.width / 2) - 1, self.y + self.height + 1, "normal", {100, 100}))

	self.shootTimer = self.shootTimerMax
end

function megabat:getHealth()
	return self.health
end

function megabat:getMaxHealth()
	return self.maxHealth
end

function megabat:takeDamage(damageValue)
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
		self.dead = true
	end
end

function megabat:die()
	if displayInfo:getEnemyData() == self then
		displayInfo:setEnemyData(nil)
	end

	bossSong:stop()

	menuSong:play()

	gameAddScore(1000)

	achievements[1]:unlock(true)
	
	if objects["player"][1] then
		objects["player"][1]:addMaxHealth()
	end
	
	self.remove = true
end