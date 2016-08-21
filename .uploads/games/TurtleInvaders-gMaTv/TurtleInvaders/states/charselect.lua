function charSelectInit()
	charSelections = {}
	for x = 1, #gameCharacters do
		charSelections[x] = newCharSelection((love.graphics.getWidth() / scale) / 2 - 170 + (math.mod( (x - 1), 6 ) * 60), ((love.graphics.getHeight() / scale) * 0.55) - 60 + math.floor( (x - 1) / 6 ) * 60, x)
	end

	chooseFont = love.graphics.newFont("graphics/monofonto.ttf", 40 * scale)
	abilityFont = love.graphics.newFont("graphics/monofonto.ttf", 18 * scale)

	currentCharacterSelection = 1
	
	charBats = {}

	charTimer = timer:new(2, function()
		table.insert(charBats, bat:new(love.math.random(370), -14, {love.math.random(-30, 30), love.math.random(30, 90)}, 0))
	end)
end

function charSelectUpdate(dt)
	charTimer:update(dt)

	for k, v in pairs(charBats) do
		if v.y > util.getHeight() or v.x + v.width < 0 or v.x > util.getWidth() then
			table.remove(charBats, k)
		end

		v:update(dt)

		v.x = v.x + v.speedx * dt
		v.y = v.y + v.speedy * dt
	end
end

function charSelectDraw()
	if mobileMode then
		love.graphics.draw(backImage, util.getHeight() * 0.01, util.getHeight() * 0.011)
	end

	for k, v in pairs(charBats) do
		v:draw()
	end

	love.graphics.setFont(chooseFont)
	love.graphics.print("Choose a character", util.getWidth() / 2 - chooseFont:getWidth("Choose a character") / 2, love.graphics.getHeight() * .05)

	if charSelections then
		local selectedCharacter = charSelections[currentCharacterSelection].char
		love.graphics.setFont(abilityFont)

		local description = selectedCharacter.ability.description
		if not description then
			description = "No ability set."
		end
		love.graphics.print(description, util.getWidth() / 2 - abilityFont:getWidth(description) / 2, love.graphics.getHeight() * 0.85)
	end

	for k, v in pairs(charSelections) do
		if currentCharacterSelection == k then
			
			local offset = math.floor((math.sin(love.timer.getTime() * math.pi * 2) + 1) / 2 * 3)
			love.graphics.line((v.x - offset) * scale, (v.y - offset) * scale, ((v.x + 8) - offset) * scale, (v.y - offset) * scale)
			love.graphics.line((v.x - offset) * scale, (v.y - offset) * scale, (v.x - offset) * scale, ((v.y + 8) - offset) * scale)

			love.graphics.line(((v.x + v.width - 8) + offset) * scale, (v.y - offset) * scale, ((v.x + v.width) + offset) * scale, (v.y - offset) * scale)
			love.graphics.line(((v.x + v.width) + offset) * scale, (v.y - offset) * scale, ((v.x + v.width) + offset) * scale, ((v.y + 8) - offset) * scale)

			love.graphics.line(((v.x + v.width) + offset) * scale, ((v.y + v.height - 8) + offset) * scale, ((v.x + v.width) + offset) * scale, ((v.y + v.height) + offset) * scale)
			love.graphics.line(((v.x + v.width - 8) + offset) * scale, ((v.y + v.height) + offset) * scale, ((v.x + v.width) + offset) * scale, ((v.y + v.height) + offset) * scale)

			offset = math.floor((math.sin(love.timer.getTime() * math.pi * 2) + 1) / 2 * 3)
			love.graphics.line((v.x - offset) * scale, ((v.y + v.height) + offset) * scale, ((v.x + 8) - offset) * scale, ((v.y + v.height) + offset) * scale)
			love.graphics.line((v.x - offset) * scale, ((v.y + v.height - 8) + offset) * scale, (v.x - offset) * scale, (((v.y + v.height) + offset) * scale))
			
		end
		v:draw()
	end
end

function charSelectKeyPressed(key)
	if key == "d" or key == "right" then
		charSelectChangeChars(1)
	elseif key == "a" or key == "left" then
		charSelectChangeChars(-1)
	elseif key == "space" then
		util.changeState("game", charSelections[currentCharacterSelection].char)
	elseif key == "escape" then
		util.changeState("title", 1)
	end
end

function charSelectGamePadPressed(joystick, button)
	if joystick == currentGamePad then
		if button == "dpright" then
			charSelectChangeChars(1)
		elseif button == "dpleft" then
			charSelectChangeChars(-1)
		elseif button == "a" then
			util.changeState("game", charSelections[currentCharacterSelection].char)
		elseif button == "b" then
			util.changeState("title", 1)
		end
	end
end

function charSelectChangeChars(i)
	currentCharacterSelection = currentCharacterSelection + i
	if currentCharacterSelection > #gameCharacters then
		currentCharacterSelection = 1
	elseif currentCharacterSelection < 1 then
		currentCharacterSelection = #gameCharacters
	end
end

function charSelectTouchPressed(id, x, y, pressure)
	for k, v in pairs(charSelections) do
		if isTapped(v.x * scale, v.y * scale, v.width * scale, v.height * scale) then
			
			if currentCharacterSelection ~= k then
				currentCharacterSelection = k
			else
				util.changeState("game", charSelections[currentCharacterSelection].char)
			end
			
			break
		end
	end

	if isTapped(util.getWidth() * 0.01, util.getHeight() * 0.011, 16 * scale, 16 * scale) then
		util.changeState("title")
	end
end

function newCharSelection(x, y, chari)
	local charselect = {}

	charselect.x = x
	charselect.y = y

	charselect.width = 40
	charselect.height = 40

	charselect.char = gameCharacters[chari]

	charselect.taps = 0

	function charselect:draw()
		local character = self.char

		if character.animated then
			love.graphics.draw(character.graphic, character.quads[1], (self.x + (self.width / 2) - character.width / 2) * scale, (self.y + (self.height / 2) - character.height / 2) * scale)
			return
		end	
		love.graphics.draw(character.graphic, (self.x + (self.width / 2) - character.width / 2) * scale, (self.y + (self.height / 2) - character.height / 2) * scale)
	end

	function charselect:mousepressed(x, y, button)
		return x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height
	end

	return charselect
end