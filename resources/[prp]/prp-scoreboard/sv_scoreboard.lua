local ST = ST or {}
ST.Scoreboard = {}
ST._Scoreboard = {}
ST._Scoreboard.PlayersS = {}
ST._Scoreboard.RecentS = {}

RegisterServerEvent('prp-scoreboard:AddPlayer')
AddEventHandler("prp-scoreboard:AddPlayer", function()

    local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end

    local stid = HexIdToSteamId(steamIdentifier)
    local ply = GetPlayerName(source)
    local scomid = steamIdentifier:gsub("steam:", "")
    local data = { src = source, steamid = stid, comid = scomid, name = ply }

    TriggerClientEvent("prp-scoreboard:AddPlayer", -1, data )
    ST.Scoreboard.AddAllPlayers()
end)

function ST.Scoreboard.AddAllPlayers(self)
    local xPlayers   = GetPlayers()

    for _, playerId in ipairs(xPlayers) do
        --print(playerId)
        local identifiers, steamIdentifier = GetPlayerIdentifiers(playerId)
        for _, v in pairs(identifiers) do
            if string.find(v, "steam") then
                steamIdentifier = v
                break
            end
        end

        local stid = HexIdToSteamId(steamIdentifier)
        local ply = GetPlayerName(playerId)
        local scomid = steamIdentifier:gsub("steam:", "")
        local data = { src = tonumber(playerId), steamid = stid, comid = scomid, name = ply }

        TriggerClientEvent("prp-scoreboard:AddAllPlayers", source, data)

    end
end

function ST.Scoreboard.AddPlayerS(self, data)
    ST._Scoreboard.PlayersS[data.src] = data
end

AddEventHandler("playerDropped", function()
	local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end

    local stid = HexIdToSteamId(steamIdentifier)
    local ply = GetPlayerName(source)
    local scomid = steamIdentifier:gsub("steam:", "")
    local plyid = source
    local data = { src = source, steamid = stid, comid = scomid, name = ply }

    TriggerClientEvent("prp-scoreboard:RemovePlayer", -1, data )
    Wait(600000)
    TriggerClientEvent("prp-scoreboard:RemoveRecent", -1, plyid)
end)

--[[ function ST.Scoreboard.RemovePlayerS(self, data)
    ST._Scoreboard.RecentS = data
end

function ST.Scoreboard.RemoveRecentS(self, src)
    ST._Scoreboard.RecentS.src = nil
end ]]

function HexIdToSteamId(hexId)
    local cid = math.floor(tonumber(string.sub(hexId, 7), 16))
	local steam64 = math.floor(tonumber(string.sub( cid, 2)))
	local a = steam64 % 2 == 0 and 0 or 1
	local b = math.floor(math.abs(6561197960265728 - steam64 - a) / 2)
	local sid = "STEAM_0:"..a..":"..(a == 1 and b -1 or b)
    return sid
end

Citizen.CreateThread(function()
    while true do 
        local playersonline = GetNumPlayerIndices()
        TriggerClientEvent("prp-scoreboard:playerscount", -1, playersonline)
        Citizen.Wait(10000)
    end
end)