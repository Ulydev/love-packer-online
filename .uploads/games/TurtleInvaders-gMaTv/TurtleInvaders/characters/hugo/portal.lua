local ability = {}

ability.name = "portal"
ability.description = "Use portals to travel long distances"

local portalImage = love.graphics.newImage("characters/hugo/portal.png")
local portalGradientImage = love.graphics.newImage("characters/hugo/portalgrad.png")
local shootingImage = love.graphics.newImage("characters/hugo/shooting.png")
local gunImage = love.graphics.newImage("characters/hugo/guns.png")

local gunQuads = {}
for i = 1, 8 do
	table.insert(gunQuads, love.graphics.newQuad(0, (i - 1) * 28, gunImage:getWidth(), 28, gunImage:getWidth(), gunImage:getHeight()))
end

local shootingQuads = {}
for y = 1, 2 do
	table.insert(shootingQuads, love.graphics.newQuad(0, (y - 1) * 16, 32, 16, shootingImage:getWidth(), shootingImage:getHeight()))
end

local portalQuads = {}
for x = 1, 2 do
	portalQuads[x] = love.graphics.newQuad((x - 1) * 8, 0, 7, 64, portalImage:getWidth(), portalImage:getHeight())
end

local gradientQuads = {}
for x = 1, 2 do
	gradientQuads[x] = love.graphics.newQuad((x - 1) * 8, 0, 8, 64, portalGradientImage:getWidth(), portalGradientImage:getHeight())
end

--[[
	This ability is pretty hacky how I do a *few* things, but other than that..it's fine.
	I mean come on, this is the most complex ability I had to freaking rewrite!
--]]

function ability:init(turtle)
	self.parent = turtle

	self.timer = 0

	self.gunQuadi = 1

	self.oldDraw = self.parent.draw

	self.timer = 0

	self.reverse = false

	self.portals = {}

	self.parent.draw = function()
		love.graphics.draw(gunImage, gunQuads[self.gunQuadi], (self.parent.x + (self.parent.width / 2) - 28) * scale, self.parent.y * scale)
	end

	self.useTimer = 8

	self.initialize = true
end

function ability:update(dt)
	if not self.initialize then
		return
	end

	for k, v in pairs(self.portals) do
		v:update(dt)
	end

	if self.useTimer > 0 then
				self.useTimer = self.useTimer - dt
			else
				self:reset()
			end

	if self.portals[1] and self.portals[2] then
		if self.portals[1].type == "portal" and self.portals[2].type == "portal" then
			if self.parent.mask["barrier"] then
				self.parent.mask["barrier"] = false
			end
			
			if self.parent.x < self.parent.width / 2 then
				self.parent.x = self.parent.x + (util.getWidth() / scale - self.parent.width / 2)
			elseif self.parent.x > util.getWidth() / scale then
				self.parent.x = self.parent.x - (util.getWidth() / scale - self.parent.width / 2)
			end
			
		end
	end

	if self.gunQuadi == 8 then
		if not self.finishAbility then
			self.parent.draw = self.oldDraw
			self.finishAbility = true
		end
		return
	end

	self.timer = self.timer + 8 * dt
	self.gunQuadi = math.floor(self.timer % 8) + 1

	if self.gunQuadi == 6 then
		self.portals[1] = newPortalShot(self.parent.x - 32, self.parent.y + (self.parent.height / 2), 1, self)

		self.portals[2] = newPortalShot(self.parent.x + self.parent.width, self.parent.y + (self.parent.height / 2), 2, self)
	end
end

function ability:createPortals(x, y, i)
	self.portals[i] = newPortal(x, y, i)
end

function ability:trigger(parent)
	if parent and not self.initialize then
		self:init(parent)
	end
end

function ability:draw()
	if not self.initialize then
		return
	end

	if self.portals[1] and self.portals[2] then
		if self.portals[1].type == "portal" and self.portals[2].type == "portal" then
			if self.parent.shouldDraw and objects["player"][1] then
				if self.parent.x < 0 then
					love.graphics.draw(self.parent.graphic, self.parent.animationQuads[self.parent.animationQuadi], self.parent.x * scale + (util.getWidth() - self.parent.width / 2), self.parent.y * scale)
				elseif self.parent.x + self.parent.width > love.graphics.getWidth() / scale then
					love.graphics.draw(self.parent.graphic, self.parent.animationQuads[self.parent.animationQuadi], self.parent.x * scale - (util.getWidth() - self.parent.width / 2), self.parent.y * scale)
				end
			end
		end
	end

	for k, v in pairs(self.portals) do
		v:draw()
	end
end

function ability:reset()
	if not self.parent then
		return
	end
	
	if self.parent.x < 0 then
		self.parent.x = 0
	elseif self.parent.x + self.parent.width > love.graphics.getWidth() / scale then
		self.parent.x = util.getWidth() / scale - self.parent.width
	end
	self.portals = {}
	self.parent.draw = self.oldDraw
	self.parent.mask["barrier"] = true
	self.initialize = false
	self.active = false
end

--PORTALSHOT--

function newPortalShot(x, y, i, abilityData)
	local shot = {}
	shot.colors = {{0, 128, 255, 255}, {255, 128, 0, 255}}

	shot.x = x
	shot.y = y

	shot.graphic = shootingImage
	shot.quadi = i

	local speed = -180
	if i == 2 then
		speed = 180
	end

	shot.speedx = speed
	shot.speedy = 0

	shot.parent = abilityData

	shot.width = 32
	shot.height = 16
	shot.type = "shot"

	function shot:update(dt)
		if not self.remove then
			self.x = self.x + self.speedx * dt

			if self.x < 0 then
				self.parent:createPortals(0, util.getHeight() / scale - 64, self.quadi)
				self.remove = true
			elseif self.x > util.getWidth() / scale then
				self.parent:createPortals(util.getWidth() / scale - 7, util.getHeight() / scale - 64, self.quadi)
				self.remove = true
			end
		end
	end

	function shot:draw()
		love.graphics.setColor(unpack(self.colors[self.quadi]))
		love.graphics.draw(self.graphic, shootingQuads[self.quadi], self.x * scale, self.y * scale)
		love.graphics.setColor(255, 255, 255)
	end

	return shot
end

--PORTAL--

function newPortal(x, y, i)
	local portal = {}

	portal.x = x
	portal.y = y

	portal.i = i

	portal.colors = {{0, 128, 255, 0}, {255, 128, 0, 0}}

	portal.fade = 1
	portal.sineTimer = 0

	portal.type = "portal"

	function portal:update(dt)
		self.colors[self.i][4] = math.min(self.colors[self.i][4] + 160 * dt, 255)

		if self.colors[self.i][4] == 255 then
			self.sineTimer = self.sineTimer + 0.5 * dt

			self.fade = math.abs( math.sin( self.sineTimer * math.pi ) / 2 ) + 0.5
		end
	end

	local offset = 1
	if i == 2 then
		offset = -1
	end
	portal.offset = offset

	function portal:draw()
		love.graphics.setColor(255, 255, 255, self.colors[self.i][4] * self.fade)
		love.graphics.draw(portalGradientImage, gradientQuads[self.i], (self.x + self.offset) * scale, self.y * scale)

		local r, g, b, a = unpack(self.colors[self.i])
		love.graphics.setColor(r, g, b, a * self.fade)
		love.graphics.draw(portalImage, portalQuads[self.i], self.x * scale, self.y * scale)

		love.graphics.setColor(255, 255, 255, 255)
	end

	return portal
end

return ability