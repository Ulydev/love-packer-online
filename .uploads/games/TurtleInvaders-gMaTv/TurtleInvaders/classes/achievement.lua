achievement = class("achievement")

function achievement:init(index, niceName)
	self.index = index

	self.unlocked = false
	self.display = false

	self.lifeTime = 2

	self.title = niceName
	self.y = -28
	self.height = 32

	self.reverse = false
end

function achievement:update(dt)
	if not self.display then
		return
	end

	if not self.reverse then
		if self.y < 0 then
			self.y = math.min(self.y + 80 * dt, 0)
		else
			if self.lifeTime > 0 then
				self.lifeTime = self.lifeTime - dt
			else
				self.reverse = true
			end
		end
	else
		if self.y > -self.height then
			self.y = math.max(self.y - 80 * dt, -self.height)
		else
			self.display = false
		end
	end
end

function achievement:draw()
	if not self.display then
		return
	end
	
	love.graphics.push()
	
	for k, v in pairs(achievements) do
		if v.display then
			love.graphics.translate(0, (k - 1) * self.height)
		end
	end
	
	local x, width = math.floor(400 - hudFont:getWidth("Unlocked!") - 42), hudFont:getWidth("Unlocked!") + 41
	love.graphics.setColor(32, 32, 32, 140)
	love.graphics.rectangle("fill", x, self.y, width, self.height)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(achievementImage, achievementQuads[self.index], x + 4, self.y + self.height / 2 - 15)
	love.graphics.print("Unlocked!", x + 41, self.y + self.height / 2 - hudFont:getHeight() / 2)
	
	love.graphics.pop()
end

function achievement:unlock(display)
	if self.unlocked then
		return
	end

	self.unlocked = true
		
	if not display then
		return
	end

	self.display = true

	saveSettings()
end