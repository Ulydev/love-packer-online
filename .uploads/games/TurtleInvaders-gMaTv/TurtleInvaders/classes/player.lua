player = class("player")

function player:init(characterData)
	self.name = characterData.name

	self.width = characterData.width
	self.height = characterData.height

	self.graphic = characterData.graphic

	self.x = 200 - self.width / 2
	self.y = util.getHeight() / scale

	self.initialize = false

	self.active = true

	self.speedx = 0
	self.speedy = 0

	self.maxSpeedx = 200

	self.gravity = 0

	self.maxShootTimer = 1/3
	self.shootingTimer = self.maxShootTimer

	self.mask =
	{
		["barrier"] = true,
		["bat"] = true,
		["fire"] = true
	}

	self.maxHealth = 3
	self.health = self.maxHealth

	self.ability = characterData.ability

	if self.ability then
		if self.ability.init and (self.ability.passive or self.ability.passiveInit) then
			self.ability:init(self)
		end
		table.insert(abilities, self.ability)
	end

	self.powerup = "none"

	self.invincible = false
	self.invincibleTimer = 0
	self.shouldDraw = true

	self.isAnimated = characterData.animated
	self.animationTimer = 0
	self.animationQuadi = 1
	self.animationQuads = characterData.quads
	self.animationSpeed = characterData.animationspeed
	self.animationCount = characterData.animationframes

	self.shieldImage = characterData.shieldImage
	self.shieldTimer = 0
	self.shieldQuad = 1
	self.shieldQuads = characterData.shieldQuads
	self.shieldRate = characterData.shieldspeed
	self.shieldStopAtEnd = characterData.shieldstopatend

	self.shieldWidth = characterData.shieldwidth
	self.shieldHeight = characterData.shieldheight
end

function player:update(dt)
	if not self.initialize then
		if self.y > util.getHeight() / scale - self.height then
			self.speedy = - 120
			return
		else
			self.initialize = true
			self.speedy = 0
		end
	end

	if self.isAnimated then
		self.animationTimer = self.animationTimer + dt

		if self.animationTimer >= self.animationSpeed then
			self.animationTimer = 0
			self.animationQuadi = self.animationQuadi + 1
			if self.animationQuadi > #self.animationQuads then
				self.animationQuadi = 1
			end
		end
	end

	if self.powerup == "shield" then
		if #self.shieldQuads > 1 then
			if self.shieldStopAtEnd then
				if self.shieldQuad < #self.shieldQuads then
					self.shieldTimer = self.shieldTimer + self.shieldRate * dt
				end
			else
				self.shieldTimer = self.shieldTimer + self.shieldRate * dt
			end
			self.shieldQuad = math.floor(self.shieldTimer % #self.shieldQuads) + 1
		end
	end

	self.shootingTimer = math.max(self.shootingTimer - dt, 0)

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

	local speed = 0
	if self.powerup ~= "freeze" then
		if self.leftkey then
			speed = -self.maxSpeedx
		elseif self.rightkey then
			speed = self.maxSpeedx
		end
	end
	self.speedx = speed
end

function player:draw()
	if not self.shouldDraw then
		return
	end

	if self.isAnimated then
		love.graphics.draw(self.graphic, self.animationQuads[self.animationQuadi], self.x * scale, self.y * scale)

		self:drawShield()
		return
	end
	love.graphics.draw(self.graphic, self.x * scale, self.y * scale)

	self:drawShield()
end

function player:drawShield()
	if self.powerup == "shield" then
		love.graphics.draw(self.shieldImage, self.shieldQuads[self.shieldQuad], (self.x + (self.width / 2) - self.shieldWidth / 2) * scale, (self.y + (self.height / 2) - self.shieldHeight / 2) * scale)
	end
end

function player:upCollide(name, data)
	if name == "bat" or name == "fire" then
		return false
	end
end

function player:downCollide(name, data)
	if name == "bat" or name == "fire" then
		return false
	end
end

function player:leftCollide(name, data)
	if name == "bat" or name == "fire" then
		return false
	end
end

function player:rightCollide(name, data)
	if name == "bat" or name == "fire" then
		return false
	end
end

function player:passiveCollide(name, data)
	if name == "powerup" then
		data.remove = true
		if data.t == "oneup" then
			if not data.isSuper then
				self:addLife(1)
			else
				self.maxHealth = self.maxHealth + difficultyi
				self:addLife(self:getMaxHealth())
			end
			return
		elseif data.t == "shield" then
			shieldSound:play()
		end

		if self.powerup == "none" then
			self.powerup = data.t
		end
	end
end

function player:moveLeft(move)
	self.leftkey = move
end

function player:moveRight(move)
	self.rightkey = move
end

function player:triggerAbility()
	if self.ability then
		if not self.ability.passive then
			if self.ability.trigger then
				if abilityKills == (self.maxHealth * 2) then
					self.ability:trigger(self)
					abilityKills = 0
				else
					if self.ability.active then
						self.ability:trigger()
					end
				end
			end
		end
	end
end

function player:shoot()
	if self.shootingTimer == 0 then
		if self.powerup == "nobullets" or self.powerup == "freeze" or megaCannonSound:isPlaying() then
			return
		end

		if self.ability then
			if self.ability.active then
				if self.ability.shoot then
					self.ability:shoot()
					self.shootingTimer = self.maxShootTimer
					return
				end
			end
		end

		if self.powerup == "shotgun" then
			table.insert(objects["bullet"], bullet:new(self.x + (self.width / 2) - 1, self.y - 1, "normal", {-100, -100}))

			table.insert(objects["bullet"], bullet:new(self.x + self.width / 2 - 1, self.y - 1, "normal", {0, -180}))

			table.insert(objects["bullet"], bullet:new(self.x + (self.width / 2) - 1, self.y - 1, "normal", {100, -100}))
		else
			local bulletType = "normal"

			if self:isValidBullet(self.powerup) then
				bulletType = self.powerup
			elseif self.powerup == "mega" then
				table.insert(objects["bullet"], megacannon:new(self))
				self:setPowerup("none")
				return
			end

			table.insert(objects["bullet"], bullet:new(self.x + self.width / 2 - 1, self.y - 1, bulletType, {0, -180}))			
		end

		self.shootingTimer = self.maxShootTimer
	end
end

function player:setPowerup(powerup)
	self.powerup = powerup
end

function player:getPowerup()
	return self.powerup
end

function player:addLife(add, pierce)
	if add < 0 then
		if self.invincible then
			return
		end
		hurtSound[love.math.random(#hurtSound)]:play()
		self.invincible = true

		comboValue = 0
		comboTimer = 0
		
		superPlayer = false
	else
		addLifeSound:play()
	end

	self.health = util.clamp(self.health + add, 0, self.maxHealth)

	if self.health == 0 then
		self:die()
	end
end

function player:die()
	self.remove = true

	gameCreateExplosion(self)

	if self.ability then
		if self.ability.reset then
			self.ability:reset()
		end
	end
		
	gameOver = true

	gameOverSound:play()
end

function player:getMaxHealth()
	return self.maxHealth
end

function player:addMaxHealth()
	self.maxHealth = self.maxHealth + difficultyi
	self:addLife(self.maxHealth)
end

function player:getHealth()
	return self.health
end

function player:isValidBullet(powerType)
	return (powerType == "laser" or powerType == "anti")
end
