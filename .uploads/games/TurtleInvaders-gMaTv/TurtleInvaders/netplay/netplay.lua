function netplayInit()
	clientSocket = require 'socket'.udp()

	if _EMULATEHOMEBREW then
		clientSocket:settimeout(0)
	end
	
	netplayX = love.graphics.getWidth() / 2 - 180 * scale
	netplayY = love.graphics.getHeight() / 2 - 105 * scale
	netplayWidth = 360
	netplayHeight = 210
	
	mainFont = love.graphics.newFont("graphics/monofonto.ttf", 24 * scale)
	logoFont = love.graphics.newFont("graphics/monofonto.ttf", 16 * scale)
	
	netplayTabi = 1
	netplaySelectioni = 1
	
	defaultNicknames =
	{
		"Ninjahat",
		"RCode",
		"Yeesus",
		"Grommet",
		"Smart.Oh",
		"BotTank",
		"ZeroTriple"
	}
	
	netplayTimeout = 0
	
	netplaySelectionFunctions =
	{
		{
			"Nickname:",
			function()
				if mobileMode then
					love.keyboard.setTextInput(true)
				end
				netplayTextEntry = true
			end
		},
		{
			"Party name:",
			function()
				if mobileMode then
					love.keyboard.setTextInput(true)
				end
				netplayTextEntry = true
			end
		},
		{
			"",
			function()
			end
		},
		{
			"Browse Servers",
			function()
				util.changeState("browser")
			end,
		},
		{
			"Start Rivals",
			function()
				if not clientSocket then
					return
				else
					if not netplayOnline then
						if not sendData then
							clientSocket:setpeername(ipAddress, portNumber)

							clientSocket:send("connect;" .. nickName .. ";")

							sendData = true
						end

						while true do
							data, msg = clientSocket:receive()
								
							if data then
								local cmd = data:split(";")
								if cmd[1] == "connected" then
									onlineName = nickName

									saveSettings()
										
									util.changeState("lobby", tonumber(cmd[2]), cmd[3])

									netplayOnline = true

									sendData = false
									
									break
								end
							end

							if not sendData then
								if not netplayOnline then
									break
								end
							end
						end
					end
				end
			end
		}
		
	}

	nickName = defaultNicknames[love.math.random(#defaultNicknames)]

	toolTips = 
	{
		"Enter an online nickname to use.",
		"Enter the party name to use.",
		"",
		"Browse online servers.",
		"Begin online co-op"
	}
	
	toolTipScrollTime = 0
	toolTipPosition = netplayX + 8 * scale

	partyName = "My Party"
end

function netplayUpdate(dt)
	if toolTipScrollTime < 1 then
		toolTipScrollTime = toolTipScrollTime + dt
	else
		toolTipPosition = toolTipPosition - (60 * scale) * dt
		if toolTipPosition + logoFont:getWidth(toolTips[netplaySelectioni]) < 0 then
			toolTipPosition = netplayX + netplayWidth * scale
		end
	end
	
	if sendData then
		if not netplayOnline then
			netplayTimeout = netplayTimeout + dt
			if netplayTimeout > 3 then
				netplayTimeout = 0

				clientSocket:close()

				sendData = false
			end
		end
	end
end

function netplayDraw()
	if mobileMode then
		love.graphics.draw(backImage, util.getHeight() * 0.01, util.getHeight() * 0.011)

		if netplayTextEntry then
			love.graphics.draw(keyboardImage, util.getHeight() * 0.1, util.getHeight() * 0.011)
		end
	end

	love.graphics.setFont(mainFont)
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Online Play", netplayX, netplayY)
	
	love.graphics.setFont(logoFont)
	
	love.graphics.setColor(127, 127, 127)
	if netplaySelectioni == 1 then
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.print("Nickname: " .. nickName, netplayX + 16 * scale, netplayY + 32 * scale)

	love.graphics.setColor(127, 127, 127)
	if netplaySelectioni == 2 then
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.print("Party name: " .. partyName, netplayX + 16 * scale, netplayY + 54 * scale)

	love.graphics.setColor(127, 127, 127)
	if netplaySelectioni == 4 then
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.print("Browse servers", netplayX + 16 * scale, netplayY + 98 * scale)
	
	 love.graphics.setColor(127, 127, 127)
	if netplaySelectioni == 5 then
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.print("Start Co-op", netplayX + 16 * scale, netplayY + 120 * scale)
	
	if toolTips[netplaySelectioni] then
		love.graphics.setColor(255, 255, 255)
		love.graphics.setScissor(netplayX, (netplayY + netplayHeight * scale) - logoFont:getHeight(), netplayWidth * scale, logoFont:getHeight())
		
		love.graphics.print(toolTips[netplaySelectioni], toolTipPosition, (netplayY + netplayHeight * scale) - logoFont:getHeight())
		
		love.graphics.setScissor()
	end
end

function netplayTextInput(text)
	if netplayTextEntry then
		if netplaySelectioni == 1 then
			if #nickName < 8 then
				nickName = nickName .. text
			end
		elseif netplaySelectioni == 2 then
			if #partyName < 8 then
				partyName = partyName .. text
			end
		end
	end
end

function netplayTouchPressed(id, x, y, pressure)
	if isTapped(util.getWidth() * 0.01, util.getHeight() * 0.011, 16 * scale, 16 * scale) then
		util.changeState("title", 2)
	elseif isTapped(util.getWidth() * 0.1, util.getHeight() * 0.011, 16 * scale, 16 * scale) then
		if not love.keyboard.hasTextInput() then
			if not netplayTextEntry then
				return
			end

			love.keyboard.setTextInput(true)
		end
	end

	for k = 1, #netplaySelectionFunctions do
		local v = netplaySelectionFunctions[k][1]

		if v ~= "" then
			if isTapped(netplayX + 16 * scale, netplayY + (32 + (k - 1) * 22) * scale, logoFont:getWidth(v), 16 * scale) then
				
				if netplaySelectioni ~= k then
					netplaySelectioni = k
				else
					netplaySelectionFunctions[netplaySelectioni][2]()
				end

				break
			end
		end
	end
end

function netplayKeyPressed(key)
	if netplayTextEntry then
		if key == "backspace" then
			if netplaySelectioni == 1 then
				nickName = nickName:sub(1, -2)
			elseif netplaySelectioni == 2 then
				partyName = partyName:sub(1, -2)
			end
		elseif key == "return" then
			love.keyboard.setTextInput(false)
			netplayTextEntry = false
		end
		return
	end

	if key == "s" or key == "down" then
	   netplayChangeSelection(1)
	elseif key == "w" or key == "up" then
		netplayChangeSelection(-1)
	elseif key == "space" then
		netplaySelectionFunctions[netplaySelectioni][2]()    
	elseif key == "escape" then
		util.changeState("title", 2)
	end
end

function netplayChangeSelection(i)
	if netplaySelectioni + i == 3 then
		netplaySelectioni = netplaySelectioni + i
	end

	netplaySelectioni = util.clamp(netplaySelectioni + i, 1, 5)
	
	toolTipScrollTime = 0
	toolTipPosition = netplayX + 8 * scale
end