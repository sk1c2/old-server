URP = URP or {}
URP.Admin = URP.Admin or {}
URP._Admin = URP._Admin or {}
URP._Admin.Players = {}
URP._Admin.DiscPlayers = {}

RegisterNetEvent('prp-admin:requestJob')
AddEventHandler('prp-admin:requestJob', function(cid, id, job, jobrank)
    -- local lmao = exports['prp-base']:GetCurrentCharacterInfo(target)
    TriggerClientEvent('prp-requestJob', source, cid, job, jobrank, id)
    TriggerClientEvent('DoLongHudText', id, 'Your job has been set to ' .. job .. ' With the rank of ' .. jobrank .. '.')
end)

RegisterServerEvent('admin:setGroup')
AddEventHandler('admin:setGroup', function(target, rank)
    local source = source
    if target ~= nil then
        local identifier = GetPlayerIdentifiers(target.src)[1]
        if identifier ~= nil then
            exports.ghmattimysql:execute('UPDATE __users SET `rank` = ? WHERE `steam` = ?', {rank, identifier}, function(data) 
                TriggerClientEvent('admin:setGroup', source, rank)
            end)
            TriggerClientEvent('DoLongHudText', source, "Set " .. target.src .. "'s rank to " .. rank .. "!")
        end
    end
end)

RegisterServerEvent('admin:getGroup')
AddEventHandler('admin:getGroup', function()
    local source = source
    local identifier = GetPlayerIdentifiers(source)[1]
    exports.ghmattimysql:execute('SELECT `rank` FROM __users WHERE steam= ?', {identifier}, function(data)
        if data ~= nil then
            if data[1].rank ~= nil then
                TriggerClientEvent('admin:setGroup', source, data[1].rank)
                -- print(data[1].rank)
            end
        end
    end)
end)

RegisterServerEvent('prp-admin:Cloak')
AddEventHandler('prp-admin:Cloak', function(src, toggle)
    TriggerClientEvent("prp-admin:Cloak", -1, src, toggle)
end)

RegisterServerEvent('admin:addChatMessage')
AddEventHandler('admin:addChatMessage', function(message)
    TriggerClientEvent('chat:addMessage', -1, {
		template = '<div class="chat-message state"><div class="chat-message-header"style="font-weight: bold;">{0}: {1}</div>',
		args = {'Admin ', message},
	})
end)

RegisterServerEvent('prp-admin:RaveMode')
AddEventHandler('prp-admin:RaveMode', function(toggle)
    local source = source
    TriggerClientEvent('prp-admin:toggleRave', -1, toggle)
end)

RegisterServerEvent('prp-admin:AddPlayer')
AddEventHandler("prp-admin:AddPlayer", function()
    local licenses
    local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            licenses = v
            break
        end
    end

    local stid = HexIdToSteamId(steamIdentifier)
    local ply = GetPlayerName(source)
    local ip = GetPlayerEndpoint(source)
    local scomid = steamIdentifier:gsub("steam:", "")
    local licenseid = licenses:gsub("license:", "")
    local ping = GetPlayerPing(source)
    local data = { src = source, steamid = stid, comid = scomid, name = ply, ip = ip, license = licenseid, ping = ping}

    TriggerClientEvent("prp-admin:AddPlayer", -1, data )
    URP.Admin.AddAllPlayers()
end)

RegisterServerEvent('admin:bringPlayer')
AddEventHandler('admin:bringPlayer', function(target)
    local source = source
    local coords = GetEntityCoords(GetPlayerPed(source))
    TriggerClientEvent('prp-admin:teleportUser', target, coords.x, coords.y, coords.z)
    TriggerClientEvent('DoLongHudText', source, 'You brought this player.')
end)

function URP.Admin.AddAllPlayers(self)
    local xPlayers   = GetPlayers()

    for _, playerId in ipairs(xPlayers) do
         
        local licenses
        local identifiers, steamIdentifier = GetPlayerIdentifiers(playerId)
        for _, v in pairs(identifiers) do
            if string.find(v, "steam") then
                steamIdentifier = v
                break
            end
        end
        for _, v in pairs(identifiers) do
            if string.find(v, "license") then
                licenses = v
                break
            end
        end
        local ip = GetPlayerEndpoint(playerId)
        local licenseid = licenses:gsub("license:", "")
        local ping = GetPlayerPing(playerId)
        local stid = HexIdToSteamId(steamIdentifier)
        local ply = GetPlayerName(playerId)
        local scomid = steamIdentifier:gsub("steam:", "")
        local data = { src = tonumber(playerId), steamid = stid, comid = scomid, name = ply, ip = ip, license = licenseid, ping = ping }

        TriggerClientEvent("prp-admin:AddAllPlayers", source, data)

    end
end

function URP.Admin.AddPlayerS(self, data)
    URP._Admin.Players[data.src] = data
end

AddEventHandler("playerDropped", function()
	local licenses
    local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            licenses = v
            break
        end
    end

    local stid = HexIdToSteamId(steamIdentifier)
    local ply = GetPlayerName(source)
    local ip = GetPlayerEndpoint(source)
    local scomid = steamIdentifier:gsub("steam:", "")
    local licenseid = licenses:gsub("license:", "")
    local ping = GetPlayerPing(source)
    local data = { src = source, steamid = stid, comid = scomid, name = ply, ip = ip, license = licenseid, ping = ping}

    TriggerClientEvent("prp-admin:RemovePlayer", -1, data )
    Wait(600000)
    TriggerClientEvent("prp-admin:RemoveRecent", -1, data)
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