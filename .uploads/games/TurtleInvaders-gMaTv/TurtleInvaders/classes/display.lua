display = class("display")

function display:init()
	self.x = 2
	self.y = 0

	self.width = util.getWidth() / scale
	self.height = util.getHeight() - self.y

	self.powerupTime = 8

	self.drainPowerup = false

	self.player = nil

	self.powerupFade = 1

	self.abilityFade = 1
	self.abilitySine = 0
end

function display:update(dt)
	if self.drainPowerup then
		self.powerupTime = math.max(0, self.powerupTime - dt)
		self.powerupFade = (self.powerupTime / 8)

		if self.powerupTime <= 0 then
			self.drainPowerup = false

			if self.player then
				self.player:setPowerup("none")
			end
			self.powerupTime = 8
			self.powerupFade = 1
		end
	end

	if abilityKills > 0 then
		self.abilitySine = self.abilitySine + 0.5 * dt

		self.abilityFade = math.abs( math.sin( self.abilitySine * math.pi ) / 2 ) + 0.5
	else
		self.abilitySine = 0
	end
end

function display:setEnemyData(enemy)
	self.enemyData = enemy
end

function display:getEnemyData()
	return self.enemyData
end

function display:draw()
	love.graphics.setColor(255, 255, 255, 160)
	
	if objects["player"][1] then
		self.player = objects["player"][1]
	end
	local player = self.player

	--Player info
	love.graphics.print("Player", self.x * scale, self.y * scale)

	for x = 1, player:getMaxHealth() do
		love.graphics.setColor(255, 255, 255, 160)

		local quadi, color = 1, 1
		if x > player:getHealth() then
			quadi = 2
		end

		if abilityKills / 2 >= x then
			love.graphics.setColor(255, 255, 255, 160 * self.abilityFade)

			color = 2
		end
		
		love.graphics.draw(healthImage, healthQuads[quadi][color], self.x + 2 * scale + math.mod((x - 1), 6) * 9 * scale, self.y + 26 * scale + math.floor((x - 1) / 6) * 9 * scale)
	end
	love.graphics.setColor(255, 255, 255, 160)

	--Score
	love.graphics.print("Score", love.graphics.getWidth() / 2 - hudFont:getWidth("Score") / 2, self.y * scale)

	love.graphics.print(score, love.graphics.getWidth() / 2 - hudFont:getWidth(score) / 2, self.y + 18 * scale)

	--Enemy info
	love.graphics.print("Enemy", (self.x + self.width) * scale - hudFont:getWidth("Enemy") - 4 * scale, self.y)

	if self.enemyData then
		local enemy = self.enemyData
		for x = 1, enemy:getMaxHealth() do
			local quadi = 1
			if x > enemy:getHealth() then
				quadi = 2
			end
			love.graphics.draw(healthImage, healthQuads[quadi][1], ( (self.x + self.width) * scale - hudFont:getWidth("Enemy") / 2 - 27 * scale ) + math.mod((x - 1), 6) * 9 * scale, self.y + 26 * scale + math.floor((x - 1) / 6) * 9 * scale)
		end
	end

	--Powerup info
	local powerupValue = player:getPowerup()
	if powerupValue ~= "none" then
		local powerup, niceName, powerupTimeValue = self:getDisplayInfo(powerupValue)

		--display current powerup
		love.graphics.setColor(255, 255, 255, 160 * self.powerupFade)
		love.graphics.draw(powerupImage, powerupQuads[powerup], self.x * scale + hudFont:getWidth("Player") + 8 * scale, self.y * scale + hudFont:getHeight() / 2 - powerupImage:getHeight() / 2)
			
		if not self.drainPowerup then
			self.powerupTime = powerupTimeValue
			self.drainPowerup = true
		end
	end

	love.graphics.setColor(255, 255, 255, 255)
end

function display:getDisplayInfo(powerupValue)
	local i, name, time = 1, "Shotgun", 8

	if powerupValue == "time" then
		i, name = 2, "Time Slow"
	elseif powerupValue == "mega" then
		i, name, time = 9, "Mega Laser", 5
	elseif powerupValue == "shield" then
		i, name = 3, "Shield"
	elseif powerupValue == "laser" then
		i, name = 4, "Laser"
	elseif powerupValue == "freeze" then
		i, name = 5, "Frozen"
	elseif powerupValue == "anti" then
		i, name = 6, "Anti-Score"
	elseif powerupValue == "nobullets" then
		i, name = 7, "No Bullets"
	elseif powerupValue == "nopower" then
		i, name = 8, "No Powerups"
	end

	return i, name, time
end