--GABE'S ABILITY
local ability = {}
ability.description = "Rapid fire dual bullet barrage! Pew pew!"

function ability:init(parent)
	self.parent = parent

	self.realShootFunction = parent.shoot

	self.realShootTimer = parent.maxShootTimer

	parent.maxShootTimer = 1/3

	self.timer = 8

	self.active = true
end

function ability:update(dt)
	if not self.active then
		return
	end

	if self.timer > 0 then
		self.timer = self.timer - dt
	else
		self:reset()
	end
end

function ability:trigger(parent)
	self.active = false

	if parent then
		self:init(parent)
	end
end

function ability:shoot()
	local v = self.parent
	table.insert(objects["bullet"], bullet:new(v.x + (v.width * 1/5) - 1, v.y - 1, "none", {0, -180}))
			
	table.insert(objects["bullet"], bullet:new((v.x + v.width) - 8 - 1, v.y - 1, "none", {0, -180}))
end

function ability:reset()
	if not self.parent then
		return
	end
	
	self.parent.maxShootTimer = self.realShootTimer

	self.active = false
end

return ability