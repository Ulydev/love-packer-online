local ability = {}

ability.passive = true
ability.description = "More health, but slower speed"
function ability:init(parent)
	parent.maxSpeedx = parent.maxSpeedx - 35

	parent.maxHealth = parent.maxHealth + 1
	parent.health = parent.health + 1
end

return ability