function loadCharacters()
	local characters = love.filesystem.getDirectoryItems("characters")

	table.sort(characters)

	gameCharacters = {}
	
	for k = 1, #characters do
		table.insert(gameCharacters, createCharacter(characters[k]))
	end
end

function createCharacter(name)
	local character = {}

	character.name = name

	local data = love.filesystem.read("characters/" .. name .. "/data.txt")

	local dataSplit = data:split(";")

	for k = 1, #dataSplit do
		local v = dataSplit[k]:split(":")

		if tonumber(v[2]) then
			character[v[1]] = tonumber(v[2])
		elseif util.toBoolean(v[2]) then
			character[v[1]] = util.toBoolean(v[2])
		else
			character[v[1]] = v[2]
		end
	end

	character.graphic = love.graphics.newImage("characters/" .. name .. "/ship.png")

	if character.ability then
		character.ability = love.filesystem.load("characters/" .. name .. "/" .. character.ability .. ".lua")()
	else
		character.ability = "No ability."
	end

	character.quads = {}
	if character.animated then
		for k = 1, character.animationframes do
			character.quads[k] = love.graphics.newQuad((k - 1) * character.width, 0, character.width, character.height, character.graphic:getWidth(), character.graphic:getHeight())
		end
	end

	if love.filesystem.isFile("characters/" .. name .. "/shield.png") then
		character.shieldImage = love.graphics.newImage("characters/" .. name .. "/shield.png")

		character.shieldQuads = {}
		if character.shieldcount then
			for k = 1, (character.shieldcount or 2) do
				character.shieldQuads[k] = love.graphics.newQuad((k - 1) * character.shieldwidth, 0, character.shieldwidth, character.shieldheight, character.shieldImage:getWidth(), character.shieldImage:getHeight())
			end
		end
	end

	return character
end
