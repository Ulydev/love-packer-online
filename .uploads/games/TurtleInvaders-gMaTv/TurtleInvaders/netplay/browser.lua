function browserInit()
	browserX = 20
	browserY = 10
	browserWidth = 360
	browserHeight = 210
	
	mainFont = love.graphics.newFont("graphics/monofonto.ttf", 24)
	logoFont = love.graphics.newFont("graphics/monofonto.ttf", 18)
	
	browserTabNames = {"Server", "Players", "Latency"}
	
	browserTabs = {}
	browserRows = {}
	
	for k = 1, #browserTabNames do
		table.insert(browserTabs, newTab(browserTabNames[k], (browserX + 8) + (k - 1) * 128, browserY + 16))
	end
	
	for k = 1, #serverList do
		table.insert(browserRows, newRow(serverList[k][1] .. ";" .. "?/4" .. ";" .. "?ms", browserX + 8, (browserY + 54) + (k - 1) * 32, serverList[k][2], serverList[k][3]))
	end

	browserPingTimer = 0
	browserPingTime = 3

	browserPingStart = 0

	borwserSelection = 1

	netplayTimeout = 0
end

function browserUpdate(dt)
	if browserPingTimer < browserPingTime then
		browserPingTimer = browserPingTimer + dt
	else
		for k = 1, #serverList do
			local sent = clientSocket:sendto("ping;", serverList[k][2], serverList[k][3])

			if sent > 0 then
				browserRows[k]:ping()
			end

			browserPingStart = love.timer.getTime()
		end
	end

	for k, v in pairs(browserRows) do
		v:update(dt)
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

	local data = clientSocket:receive()

	if data then
		local cmd = data:split(";")
		if cmd[1] == "pong" then
			for k, v in pairs(browserRows) do
				if v.text[1] == cmd[2] then
					browserRows[k].text[2], browserRows[k].text[3] = cmd[3], util.round(love.timer.getTime() - browserPingStart, 2) .. "ms"
				end
			end
		end
	end

	for k, v in pairs(browserRows) do
		if not v.isPinged then
			v.text[2], v.text[3] = "?/4", "?ms"
		end
	end
end

function browserDraw()
	for fieldCount = 1, #starFields do
		local v = starFields[fieldCount]

		for k, s in pairs(v) do
			s:draw()
		end
	end
	
	love.graphics.setFont(mainFont)
	
	for k, v in ipairs(browserTabs) do
		v:draw()
	end
	
	love.graphics.setFont(logoFont)
	
	for k, v in ipairs(browserRows) do
		if borwserSelection == k then
			love.graphics.setColor(255, 255, 255)
		else
			love.graphics.setColor(128, 128, 128)
		end
		v:draw()
	end

	love.graphics.setColor(255, 255, 255)
end

function browserKeyPressed(key)
	if key == "cpadup" or key == "up" then
		borwserSelection = math.max(borwserSelection - 1, 1)
	elseif key == "cpaddown" or key == "down" then
		borwserSelection = math.min(borwserSelection + 1, #serverList)
	elseif key == "a" then
		ipAddress, portNumber = browserRows[borwserSelection].ip, browserRows[borwserSelection].port

		if not browserRows[borwserSelection].text[2]:find("?") then
			netplaySelectionFunctions[5]()
		end
	elseif key == "b" then
		util.changeState("netplay")
	end
end

function newTab(text, x, y)
	local tab = {}
	
	tab.text = text
	
	tab.x = x
	tab.y = y
	
	tab.width = 72
	tab.height = 24
	
	function tab:draw()
		love.graphics.print(self.text, self.x + (self.width / 2) - mainFont:getWidth(self.text) / 2, self.y + (self.height / 2) - mainFont:getHeight() / 2)
	end
	
	return tab
end

function newRow(data, x, y, ip, port)
	local row = {}
	
	row.x = x
	row.y = y

	row.height = 18

	row.text = data:split(";")

	row.ip = ip
	row.port = tonumber(port)
	
	row.isPinged = false

	row.timer = 0
	
	function row:draw()
		for k = 1, #self.text do
			love.graphics.print(self.text[k], (self.x + 36) - logoFont:getWidth(self.text[k]) / 2 + (k - 1) * 128, (self.y + self.height / 2) - logoFont:getHeight() / 2)
		end
	end
	
	function row:ping()
		self.isPinged = true
		self.timer = 0
	end

	function row:update(dt)
		if self.isPinged then
			self.timer = self.timer + dt
			if self.timer > 3 then
				self.isPinged = false
				self.timer = 0
			end
		end
	end

	return row
end