local ability = {}
ability.passive = true
ability.description = "Fast bullets, lowest health, and no shield"

function ability:init(parent)
	parent.maxHealth = parent.maxHealth - 2
	parent.health = parent.maxHealth

	parent.maxShootTimer = 1/5
	parent.shootingTimer = parent.maxShootTimer
end

return ability