client = {}

clientTriggers = {}

local clientLookup =
{
	{1, 2, 3, 4},
	{4, 1, 2, 3},
	{3, 4, 1, 2},
	{2, 3, 4, 1}
}

local clientSyncPositionTimer = 0
local clientSyncPositionTime = 0.05

local clientSyncLobbyTimer = 0
local clientSyncLobbyTime = 0.05

local clientSyncBatTimer = 0
local clientSyncBatTime = 0.25

function client:update(dt)
	local data = clientSocket:receive()

	if data then
		local cmd = data:split(";")

		if cmd[1] == "playerdata" then
			playerID = tonumber(cmd[3])

			lobbyCards[playerID] = newLobbyCard(26 + (playerID - 1) * 92, cmd[2], playerID)
			
			lobbyCursors[playerID] = newCursor(playerID)

			tabRightSound:play()
		elseif cmd[1] == "lobbydata" then
			local clientID, selection, ready, charNumber = tonumber(cmd[2]), tonumber(cmd[3]), util.toBoolean(cmd[4]), tonumber(cmd[5])

			if not lobbyCards[clientID] then
				return
			end

			lobbyCursors[clientID]:setPosition(selection)

			lobbyCards[clientID]:setReady(ready)

			lobbyCharacters[clientID] = charNumber

			if charNumber ~= nil then
				charSelections[selection].selected = true
			else
				charSelections[selection].selected = false
			end
		elseif cmd[1] == "chat" then
			if cmd[2]:find(client:getUsername()) ~= nil then
				blipSound:play()
			end
			lobbyInsertChat(cmd[2])
		elseif cmd[1] == "shutdown" then
			clientSocket:close()

			util.changeState("netplay")

			netplayOnline = false
		elseif cmd[1] == "moveplayer" then
			if not objects then
				return
			end

			local shipIndex = clientLookup[myLobbyID][tonumber(cmd[3])]

			if not objects["player"][shipIndex] then
				return
			end

			objects["player"][shipIndex].x = tonumber(cmd[2])
		elseif cmd[1] == "shootplayer" then
			if not objects then
				return
			end

			local shipIndex = clientLookup[myLobbyID][tonumber(cmd[2])]

			if not objects["player"][shipIndex] then
				return
			end

			objects["player"][shipIndex]:shoot()
		elseif cmd[1] == "batdata" then
			if not objects then
				return
			end

			local batID, x, y = tonumber(cmd[2]), tonumber(cmd[3]), tonumber(cmd[4])
			
			for k, v in ipairs(objects["bat"]) do
				if v.id == batID then
					v.x = x
					v.y = y
				end
			end
		elseif cmd[1] == "wave" then
			if not objects then
				return
			end

			gameNextWave()
		elseif cmd[1] == "powerupdata" then
			if not objects then
				return
			end

			local powerupID, x, y = tonumber(cmd[2]), tonumber(cmd[3]), tonumber(cmd[4])

			if objects["powerup"][powerupID] then
				objects["powerup"][powerupID].x, objects["powerup"][powerupID].y = x, y
			end
		elseif cmd[1] == "setpowerup" then
			if not objects then
				return
			end

			local shipIndex = clientLookup[myLobbyID][tonumber(cmd[2])]
			
			if not objects["player"][shipIndex] then
				return
			end
		
			objects["player"][shipIndex]:setPowerup(cmd[3])
		elseif cmd[1] == "spawnbat" then
			if not objects then
				return
			end

			gameSpawnBat(tonumber(cmd[2]), tonumber(cmd[3]), {tonumber(cmd[5]), tonumber(cmd[6])}, tonumber(cmd[4]))
		elseif cmd[1] == "spawnpowerup" then
			if not objects then
				return
			end

			table.insert(objects["powerup"], powerup:new(tonumber(cmd[2]), tonumber(cmd[3]), tonumber(cmd[4])))
		elseif cmd[1] == "spawnmegabat" then
			if not objects then
				return
			end

			objects["boss"][1] = megabat:new(tonumber(cmd[2]))
		elseif cmd[1] == "megabatshoot" then
			if not objects then
				return
			else
				if not objects["boss"][1] then
					return
				end
			end

			if objects["boss"][1] then
				objects["boss"][1]:shoot()
			end
		elseif cmd[1] == "useability" then
			if not objects then
				return
			end

			local shipIndex = clientLookup[myLobbyID][tonumber(cmd[2])]
			
			if not objects["player"][shipIndex] then
				return
			end
		
			objects["player"][shipIndex]:triggerAbility()
		end
	end

	if state == "lobby" then
		if clientSyncLobbyTimer < clientSyncLobbyTime then
			clientSyncLobbyTimer = clientSyncLobbyTimer + dt
		else
			clientSocket:send("lobbydata;" .. myLobbyID .. ";" .. lobbyCursors[myLobbyID].selection .. ";" .. tostring(lobbyCards[myLobbyID].ready) .. ";" .. tostring(lobbyCharacters[myLobbyID]) .. ";")
			clientSyncLobbyTimer = 0
		end
	end

	if objects then
		if objects["player"][1] then
			if clientSyncPositionTimer < clientSyncPositionTime then
				clientSyncPositionTimer = clientSyncPositionTimer + dt
			else
				clientSocket:send("moveplayer;" .. util.round(objects["player"][1].x, 2) .. ";" .. myLobbyID .. ";")
				clientSyncPositionTimer = 0
			end
		end
	end

	for x = # clientTriggers, 1, -1 do
		clientSocket:send(clientTriggers[x])
		table.remove(clientTriggers, x)
	end
end

function client:getUsername()
	return nickName
end

function client:disconnect()
	clientSocket:send("disconnect;" .. myLobbyID .. ";")
end

--[[
	GAME SYNCS
--]]

local oldGameInit = gameInit
function gameInit(playerData)
	oldGameInit(playerData)

	if netplayOnline then
		for k = 1, #lobbyCards do
			local shipIndex = clientLookup[myLobbyID][k]

			local clientCharacter = charSelections[lobbyCursors[k].selection].char

			local temp = player:new(clientCharacter)

			temp.x = 40 + (k - 1) * 40

			objects["player"][shipIndex] = temp
		end
	end

	local oldEnemyCallback = enemyTimer.callback
	local oldWaveCallback = waveTimer.callback

	enemyTimer.callback = function(self)
		if netplayOnline then
			if myLobbyID ~= 1 then
				return
			end
		end
		oldEnemyCallback(self)
	end

	waveTimer.callback = function(self)
		if netplayOnline then
			if myLobbyID ~= 1 then
				return
			end
		end

		oldWaveCallback(self)
	end
end

local oldGameDropPowerup = gameDropPowerup
function gameDropPowerup(x, y, oneUp, superUp)
	if netplayOnline then
		if myLobbyID ~= 1 then
			return
		end
	end
	oldGameDropPowerup(x, y, oneUp, superUp)
end

local oldNextWave = gameNextWave
function gameNextWave()
	oldNextWave()

	if netplayOnline then
		if myLobbyID == 1 then
			table.insert(clientTriggers, "wave;")
		end
	end
end

local oldPowerupInit = powerup.init
powerup.init = function(self, x, y, i)
	oldPowerupInit(self, x, y, i)

	if netplayOnline then
		if myLobbyID == 1 then
			table.insert(clientTriggers, "spawnpowerup;" .. x .. ";" .. y .. ";" .. i .. ";")
		end
	end
end

--[[
	PLAYER SYNCS
--]]

local oldPlayerShoot = player.shoot
player.shoot = function(self)
	oldPlayerShoot(self)

	if netplayOnline then
		clientSocket:send("shootplayer;" .. myLobbyID .. ";")
	end
end

local oldPlayerSetPowerup = player.setPowerup
player.setPowerup = function(self, powerup)
	oldPlayerSetPowerup(self, powerup)

	if netplayOnline then
		table.insert(clientTriggers, "setpowerup;" .. myLobbyID .. ";" .. powerup)
	end
end

local oldPlayerTriggerAbility = player.triggerAbility
player.triggerAbility = function(self)
	oldPlayerTriggerAbility(self)

	if netplayOnline then
		table.insert(clientTriggers, "useability;" .. myLobbyID .. ";")
	end
end

--[[
	BAT SYNCS
--]]

local oldBatInit = bat.init
bat.init = function(self, x, y, velocity, id)
	oldBatInit(self, x, y, velocity, id)

	if netplayOnline then
		if myLobbyID == 1 then
			table.insert(clientTriggers, "spawnbat;" .. x .. ";" .. y .. ";" .. id .. ";" .. velocity[1] .. ";" .. velocity[2] .. ";")
		end
	end
end

--[[
	MEGA BAT SYNCS
--]]

local oldMegaBatInit = megabat.init
megabat.init = function(self, speed)
	if netplayOnline then
		if myLobbyID == 1 then
			table.insert(clientTriggers, "spawnmegabat;" .. speed .. ";")
		end
	end

	oldMegaBatInit(self, speed)
end

local oldMegaBatShoot = megabat.shoot
megabat.shoot = function (self)
	if netplayOnline then
		if myLobbyID ~= 1 then
			return
		end
	end

	oldMegaBatShoot(self)

	if netplayOnline then
		table.insert(clientTriggers, "megabatshoot;")
	end
end