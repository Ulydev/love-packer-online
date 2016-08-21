function lobbyInit(playerID, playerNick)
	if not charSelections then
		charSelections = {}
		for x = 1, #gameCharacters do
			charSelections[x] = newCharSelection(20 + math.mod( (x - 1), 5 ) * 60, 20 + math.floor( (x - 1) / 5 ) * 60, x)
		end
	end
	
	lobbyCards = {}
	lobbyCursors = {}
	lobbyCharacters = {}
	
	chooseFont = love.graphics.newFont("graphics/monofonto.ttf", 40)
	mainFont = love.graphics.newFont("graphics/monofonto.ttf", 18)
	
	myLobbyID = playerID
	currentLobbySelection = playerID
	
	lobbyCards[playerID] = newLobbyCard(26 + (playerID - 1) * 92, playerNick, playerID)
	lobbyCursors[playerID] = newCursor(playerID)
	
	playerCursorColors =
	{
		{255, 55, 0, 95},
		{0, 55, 255, 95},
		{255, 205, 0, 95},
		{55, 255, 9, 95}
	}

	lobbyCountDown = false
	lobbyTimer = 3
	lobbyFade = 0

	chatLog = {}

	chatKeyboard = keyboard:new("Enter chat text.", 24)

	chatKeyboard.onReturn = function()
		if #chatKeyboard:getText() == 0 then
			return
		end

		local chatString = client:getUsername() .. ": " .. chatKeyboard:getText()

		lobbyInsertChat(chatString)

		table.insert(clientTriggers, "chat;" .. chatString .. ";")
	end

	chatState = false
end

function lobbyUpdate(dt)
	if lobbyCountDown then
		lobbyTimer = lobbyTimer - dt
		if lobbyTimer < 0 then
			lobbyFade = math.min(lobbyFade + 0.6 * dt, 1)
			if lobbyFade == 1 then
				util.changeState("game", charSelections[lobbyCursors[myLobbyID].selection].char)
			end
			lobbyTimer = 0
		end
	end

	if chatState then
		chatKeyboard:update(dt)
	end
end

function lobbyDraw()
	love.graphics.setScreen("top")
	
	for fieldCount = 1, #starFields do
		local v = starFields[fieldCount]

		for k, s in pairs(v) do
			s:draw()
		end
	end
	
	love.graphics.setDepth(-INTERFACE_DEPTH)
	
	love.graphics.setFont(chooseFont)

	local text = "Online Co-Op Lobby"
	if chatState then
		text = "Online Co-Op Chat"
	end
	love.graphics.print(text, util.getWidth() / 2 - chooseFont:getWidth(text) / 2, 16)

	love.graphics.line(36, 61, chooseFont:getWidth(text), 61)
	
	love.graphics.setFont(mainFont)
	
	if not chatState then
		if lobbyCards then
			for k, v in pairs(lobbyCards) do
				v:draw()
			end
		end
		
		local description = charSelections[lobbyCursors[myLobbyID].selection].char.ability.description
		if not description then
			description = "No ability set."
		end
		love.graphics.print(description, util.getWidth() / 2 - mainFont:getWidth(description) / 2, 200)

	    if lobbyCountDown then
	    	love.graphics.setColor(0, 0, 0, 255 * lobbyFade)
		    love.graphics.rectangle("fill", 0, 0, 400, 240)
	    
		    love.graphics.setColor(255, 255, 255, 255)

	    	love.graphics.print("Game starting in " .. math.floor(lobbyTimer) .. "s", util.getWidth() / 2 - mainFont:getWidth("Game starting in " .. math.floor(lobbyTimer) .. "s") / 2, util.getHeight() / 2 - mainFont:getHeight() / 2)
	    end
	else
		love.graphics.setColor(255, 255, 255, 255)

		--love.graphics.setScissor(8, 68, 360, 228)

		for k = 1, #chatLog do
			local off = 0
			if #chatLog > 1 then
				off = (#chatLog - 1) * 20
			end

			love.graphics.print(chatLog[k], 8, (208 - off) + (k - 1) * 20)
		end
		
		--love.graphics.setScissor()
	end

	love.graphics.setDepth(NORMAL_DEPTH)
	
	love.graphics.setScreen("bottom")
	
	for fieldCount = 1, #starFields do
		local v = starFields[fieldCount]

		for k, s in pairs(v) do
			s:draw()
		end
	end
	
	if not chatState then
		if charSelections then
			for k, v in pairs(charSelections) do
				love.graphics.setColor(255, 255, 255)
				if v.selected then
					love.graphics.setColor(128, 128, 128) 
				else
					love.graphics.setColor(255, 255, 255)
				end
				v:draw()
			end
		end
		
	   if lobbyCursors then    
			for k, v in pairs(lobbyCursors) do
				v:draw()
			end
		end

		if lobbyCountDown then
			love.graphics.setColor(0, 0, 0, 255 * lobbyFade)
			love.graphics.rectangle("fill", 0, 0, 320, 240)
			love.graphics.setColor(255, 255, 255, 255)
		end
	else
		chatKeyboard:draw()
	end
	
	love.graphics.setColor(255, 255, 255, 255)
end

function lobbyInsertChat(text)
	table.insert(chatLog, text)

	if #chatLog > 8 then
		table.remove(chatLog, 1)
	end
end

function lobbyKeyPressed(key)
	if key == "rbutton" or key == "lbutton" then
		chatState = not chatState
		if chatState then
			chatKeyboard:open()
		else
			chatKeyboard:close()
		end
	end

	if chatState then
		return
	end

	if lobbyCharacters[myLobbyID] then
		if key == "b" then
			if lobbyCharacters[myLobbyID] then
				lobbyCharacters[myLobbyID] = nil
				
				lobbyCards[myLobbyID]:setReady(false)

				charSelections[lobbyCursors[myLobbyID].selection].selected = false
			end
		elseif key == "start" then
			lobbyCards[myLobbyID]:setReady(true)  
		end
		return
	end

	if key == "cpadright" or key == "right" then
		lobbyCursors[myLobbyID]:move(1)
	elseif key == "cpadleft" or key == "left" then
		lobbyCursors[myLobbyID]:move(-1)
	elseif key == "a" then
		if not lobbyCharacters[myLobbyID] then
			
			local pass = true
			
			for k = #lobbyCharacters, 1, -1 do
				if k ~= myLobbyID then
					if charSelections[k].selected then
						if lobbyCursors[myLobbyID].selection == k then
							explodeSound:play()

							pass = false
							
							break
						end
					end
				end
			end

			if pass then
				lobbyCharacters[myLobbyID] = currentLobbySelection

				charSelections[lobbyCursors[myLobbyID].selection].selected = true
			end
		end
	end
end

function lobbyMousePressed(x, y, button)
	if chatState then
		chatKeyboard:mousepressed(x, y, button)
	end
end

function newLobbyCard(x, name, id)
	local card = {}
	
	card.x = x
	card.y = 68
	card.width = mainFont:getWidth("        ") --lazy but whatever. It's monospaced.
	card.height = 136
	
	card.name = name
	
	card.id = id
	
	card.character = gameCharacters[myLobbyID]
	
	card.ready = false
	card.playToggleSound = false
	
	function card:draw()
		self.character = charSelections[lobbyCursors[self.id].selection].char
		if not self.character.animated then
			love.graphics.draw(self.character.graphic, self.x + self.width / 2 - self.character.graphic:getWidth() / 2, self.y + self.height / 2 - self.character.graphic:getHeight() / 2)
		else
			love.graphics.draw(self.character.graphic, self.character.quads[1], self.x + self.width / 2 - self.character.width / 2, self.y + self.height / 2 - self.character.height / 2)
		end
		love.graphics.print(self.name, self.x + self.width / 2 - mainFont:getWidth(self.name) / 2, self.y + 9)
		
		local quadi = 2
		if self.ready then
			quadi = 1
		end
		love.graphics.draw(serverExistsImage, serverQuads[quadi], self.x + (self.width / 2) - 9, self.y + self.height - 36)
	end

	function card:setReady(ready)
		self.ready = ready

		if self.ready then
			if not self.playToggleSound then
				toggleSound:play()
				self.playToggleSound = true
			end
		else
			self.playToggleSound = false
		end
		
		local countReady = 0
		for k = 1, #lobbyCards do
			if lobbyCards[k].ready then
				countReady = countReady + 1
			end
		end

		if countReady == #lobbyCards then
			lobbyCountDown = true
		else
			lobbyCountDown = false

			lobbyFade = 0
			lobbyTimer = 3
		end
	end
	  
	return card
end

function newCursor(playerID)
	local cursor = {}
	
	cursor.x = charSelections[playerID].x
	cursor.y = charSelections[playerID].y
	cursor.width = 40
	cursor.height = 40
	
	cursor.selection = playerID
	
	cursor.playerID = playerID
	
	function cursor:setPosition(selection)
		self.x = charSelections[selection].x
		self.y = charSelections[selection].y
		self.selection = selection
	end
	
	function cursor:draw()
		love.graphics.push()

		love.graphics.translate(40, 240)
		local v = self
		
		love.graphics.setColor(playerCursorColors[self.playerID])
		
		local offset = math.floor((math.sin(love.timer.getTime() * math.pi * 2) + 1) / 2 * 3)
		love.graphics.line(v.x - offset, v.y - offset, (v.x + 8) - offset, v.y - offset)
		love.graphics.line(v.x - offset, v.y - offset, v.x - offset, (v.y + 8) - offset)

		love.graphics.line((v.x + v.width - 8) + offset, v.y - offset, (v.x + v.width) + offset, v.y - offset)
		love.graphics.line((v.x + v.width) + offset, v.y - offset, (v.x + v.width) + offset, (v.y + 8) - offset)

		love.graphics.line((v.x + v.width) + offset, (v.y + v.height - 8) + offset, (v.x + v.width) + offset, (v.y + v.height) + offset)
		love.graphics.line((v.x + v.width - 8) + offset, (v.y + v.height) + offset, (v.x + v.width) + offset, (v.y + v.height) + offset)

		offset = math.floor((math.sin(love.timer.getTime() * math.pi * 2) + 1) / 2 * 3)
		love.graphics.line(v.x - offset, (v.y + v.height) + offset, (v.x + 8) - offset, (v.y + v.height) + offset)
		love.graphics.line(v.x - offset, (v.y + v.height - 8) + offset, (v.x - offset), (v.y + v.height) + offset)
		
		love.graphics.setColor(255, 255, 255, 255)
		
		love.graphics.pop()
	end
	
	function cursor:move(i)
		self.selection = self.selection + i
		if self.selection > #gameCharacters then
			self.selection = 1
		elseif self.selection < 1 then
			self.selection = #gameCharacters
		end
		self:setPosition(self.selection)
	end
	
	return cursor
end