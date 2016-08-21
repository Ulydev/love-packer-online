local ability = {}
ability.name = "Shed Skin"
ability.description = "Able to revive from death one time"
ability.passive = true

local scuttlesNoTail = love.graphics.newImage("characters/scuttles/shiprevive.png")

local defaultDie = player.die
function ability:init(parent)
    parent.die = function(self)
        self.shouldDraw = false
        
        self.active = false
        
        gameCreateExplosion(self)
        
        self.y = util.getHeight()
        
        reviveTimer = timer:new(1, function()
            self:addLife(math.ceil(self:getMaxHealth() / 2))
            
            self.initialize = false
            
            self.active = true
            
            self.shouldDraw = true
            
            self.die = defaultDie
            
            self.graphic = scuttlesNoTail
            
            reviveTimer = nil
        end)
    end
    
    self.parent = parent
end

function ability:update(dt)
    if reviveTimer then
        reviveTimer:update(dt)
    end
end

return ability