local ability = {}

ability.description = "Press A to move past enemies with ease"

function ability:init(turtle)
	self.parent = turtle

	self.coolDown = 1.5
	self.coolDownMax = self.coolDown
	self.coolDownTriggered = false

	self.maxTimer = 8

	self.initialize = false
end

function ability:update(dt)
	if not self.initialize then
		return
	end

	if self.coolDownTriggered then
		if self.coolDown > 0 then
			self.coolDown = self.coolDown - dt
		else
			self.coolDown = self.coolDownMax
			self.coolDownTriggered = false
		end
	end

	if self.maxTimer > 0 then
		self.maxTimer = self.maxTimer - dt
	else
		self.initialize = false
	end
end

function ability:trigger(parent)
	if parent then
		self:init(parent)
		self.initialize = true
	end

	--there's gonna be a cooldown, cool? okay.
	if not self.coolDownTriggered then
		if self.parent.speedx < 0 then
			self:doStep(-60)
		elseif self.parent.speedx > 0 then
			self:doStep(60)
		end
	end
end

function ability:doStep(playerSpeed)
	table.insert(fizzles, fizzle:new(self.parent, "player"))

	self.parent.x = util.clamp(self.parent.x + playerSpeed, 0, love.graphics.getWidth() / scale - self.parent.width)

	self.coolDownTriggered = true
end

return ability