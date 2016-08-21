local ability = {}
ability.name = "Shatter Bullets"
ability.description = "Creates a ring of spinning bullets"

ability.passiveInit = true
ability.initialize = false

function ability:init(player)
    player.maxHealth = player.maxHealth - 1
    player.health = player.maxHealth
end

function ability:trigger(player)
    if not self.initialize then
        local radial = {0, (math.pi * 7) / 4, (math.pi * 3) / 2, (math.pi * 5) / 4, math.pi, (math.pi * 3) / 4, math.pi / 2, math.pi / 4}
        
        for k = 1, #radial do
            table.insert(objects["bullet"], bulletshield:new((player.x + (player.width / 2) - 1), (player.y + (player.height / 2) - 1), radial[k]))
        end
        
        self.initialize = true
    end
end

function ability:update(dt)
    if self.initialize then
        local count = 0
        for k, v in pairs(objects["bullet"]) do
            if tostring(v):find("bulletshield") then
                count = count + 1
            end
        end
        
        if count == 0 then
            self.initialize = false  
        end
   end
end

--BULLETRING--

bulletshield = class("bulletshield", bullet)

function bulletshield:init(x, y, angle)
    bullet.init(self, x, y, "normal", {0, 0})
    
    print(self)
    
    self.rotation = 0
    self.angle = angle
end

function bulletshield:update(dt)
    self.angle = self.angle + 8 * dt
        
    if objects["player"][1] then
        local player = objects["player"][1]
            
        local x, y = (player.x + (player.width / 2) - 1) - 1, (player.y + (player.height / 2) - 1)
            
        self.x = x + math.cos(self.rotation + self.angle) * 40
		self.y = y + math.sin(self.rotation + self.angle) * 40
    end
end

function bulletshield:draw()
    bullet.draw(self)
end

return ability