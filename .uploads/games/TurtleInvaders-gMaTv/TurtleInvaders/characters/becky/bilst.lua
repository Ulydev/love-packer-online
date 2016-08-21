local ability = {}
ability.passive = false
ability.description = "Deploy Bilst, a crafty bot to defend her."

--[[
    Make the robot move in an arc in front of Becky.
    It'll shoot if a bat is in its sight.
    If shot, it gets destroyed.
    It's timed for 8s of usage.
]]
local bilstImage = love.graphics.newImage("characters/becky/biltz.png")
local bilstQuads = {}
for k = 1, 3 do
	bilstQuads[k] = love.graphics.newQuad((k - 1) * 14, 0, 14, 14, bilstImage:getWidth(), bilstImage:getHeight())
end

function ability:init(parent)
	self.parent = parent

	self.object = bilst:new(parent.x, parent.y, parent, self)
	table.insert(objects["misc"], self.object)

	self.initialize = true
end

function ability:reset()
	self.object = nil
	self.initialize = false
end

function ability:update(dt)
	if self.initialize then
		self.object.staticX, self.object.staticY = self.parent.x+14, self.parent.y
	end
end

function ability:trigger(parent)
	if parent and not self.object then
		self:init(parent)
	end
end

bilst = class("bilst")

function bilst:init(x, y, parent, becky)
	self.x = x
	self.y = y

	self.staticX = x
	self.staticY = y

	self.timer = 0
	self.maxTime = 3

	self.quadi = 1
	self.animationTimer = 0

	self.width = 14
	self.height = 14

	self.active = true
	self.passive = true

	self.speedx = 0
	self.speedy = 0

	self.gravity = 0

	self.shoot = false
	self.coolDown = 1.5

	self.parent = parent
	self.becky = becky
end

function bilst:update(dt)
	self.animationTimer = self.animationTimer + 14 * dt
	self.quadi = math.floor(self.animationTimer % 3) + 1

	self.timer = self.timer + dt
	if self.timer >= self.maxTime then
		self.timer = self.timer - self.maxTime
	end

	local factor = 1.5 - self.timer/self.maxTime

	self.x = self.staticX + math.cos(math.pi * 2 * factor) * 50
	self.y = self.staticY - math.abs( math.sin(math.pi * 2 * factor) ) * 30

	local obj = checkrectangle(self.x, 0, self.width, self.y, {"bat"})
	if #obj > 0 then
		if not self.shoot then
			table.insert(objects["bullet"], bullet:new(self.x + (self.width / 2) - 1, self.y - 1, "normal", {0, -140}))
			self.shoot = true
		end
	end

	if self.shoot then
		self.coolDown = self.coolDown - dt
		if self.coolDown < 0 then
			self.shoot = false
			self.coolDown = 1.5
		end
	end
end

function bilst:draw()
	love.graphics.draw(bilstImage, bilstQuads[self.quadi], self.x * scale, self.y * scale)
end

function bilst:passiveCollide(name, data)
	if name == "bat" then
		self.remove = true
		self.becky:reset()
		gameCreateExplosion(self)
	end
end

return ability