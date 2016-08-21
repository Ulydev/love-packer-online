local ability = {}

ability.description = "Bullets will home in on the closest enemy"

function ability:init(parent)
	self.setTarget = false
	
	self.initialize = true
	
	self.target = nil

	self.timer = 8

	self.parent = parent

	self.maxTimer = parent.maxShootTimer

	parent.maxShootTimer = 1/2
	
	self.oldParentShoot = parent.shoot
	parent.shoot = function(self)
		if self.shootingTimer == 0 then
			table.insert(objects["bullet"], rocket:new(self.x + (self.width / 2) - 1, self.y, "normal", {0, -100}))
			
			self.shootingTimer = self.maxShootTimer
		end
	end
end

function ability:update(dt)
	if not self.initialize then
		return
	end

	if self.timer > 0 then
		self.timer = self.timer - dt
	else
		self:reset()
	end
end

function ability:trigger(parent)
	if not parent or self.initialize then
		return
	end

	self:init(parent)
end

function ability:reset()
	if self.initialize then
		self.parent.shoot = self.oldParentShoot
		self.parent.maxShootTimer = self.maxTimer
		self.initialize = false
	end
end

--ROCKETS--

rocket = class("rocket", bullet)

function rocket:init(x, y)
	bullet.init(self, x, y, "normal", {0, 0})
	
	self.mask["player"] = false
	
	self.parent = objects["player"][1]

	self.destroyTimer = 0
end

function rocket:update(dt)
	local nearest = 1
	for k, v in pairs(objects["bat"]) do
		if util.dist(self.x, self.y, v.x, v.y) <= 20 then
			nearest = k
		end
	end

	if objects["bat"][nearest] then
		self.parent.ability.target = objects["bat"][nearest]
	end

	if self.parent.ability.target then
		local spinfactor = math.pi/60
				
		local a = math.atan2(self.speedy, self.speedx)
		local a2 = math.atan2((self.parent.ability.target.y + (self.parent.ability.target.height / 2))-self.y, self.parent.ability.target.x-self.x)
		if a < a2 and a2 - a > math.pi then 
			spinfactor = spinfactor * (-1)
		elseif a > a2 and a - a2 <= math.pi then 
			spinfactor = spinfactor * (-1) 
		end
					
		a = a + spinfactor
		
		if a < 0 then 
			a = a + math.pi*2
		elseif a >= math.pi*2 then 
			a = a - math.pi*2 
		end
					
		local speed = 200
		self.speedx = speed*math.cos(a)
		self.speedy = speed*math.sin(a)
	end

	self.destroyTimer = self.destroyTimer + dt
	if self.destroyTimer > 2 then
		gameCreateExplosion(self)
		self.remove = true
	end
end

function rocket:draw()
	bullet.draw(self)
end

function rocket:passiveCollide(name, data)
	if name == "player" then
		return
	end
	
	bullet.passiveCollide(self, name, data)
end

return ability