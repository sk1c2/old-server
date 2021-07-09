function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

local checkingForSessions
local exludedZones = {
    [1] = {['x'] = 238.41,['y'] = -404.68,['z'] = 47.93,["r"] = 20},
    [2] = {['x'] = 234.16,['y'] = -418.85,['z'] = -118.19,["r"] = 60},
    [3] = {['x'] = 257.02,['y'] = -368.93,['z'] = -44.13,["r"] = 40},
    [4] = {['x'] = 323.47,['y'] = -1619.64,['z'] = -66.78,["r"] = 100},
}

function URP.Admin.CheckForSessions(self)
    if checkingForSessions then return else checkingForSessions = true end

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2000)

            local players = URP._Admin.Players

            for k,v in pairs(players) do
                local src = v.src
                local playerId = GetPlayerFromServerId(src)
                if not src then
                    URP._Admin.Players[src].sessioned = true
                else
                    if not NetworkIsPlayerActive(playerId) or not NetworkIsPlayerConnected(playerId) then URP._Admin.Players[src].sessioned = true end
                end
            end
        end
    end)
end

function URP.Admin.Init(self)
    self.Menu:Init()
    self:CheckForSessions()
    self:AFKCheck()
end

local afk = {
    checkingAFK = nil,
    isAfk = false,
    msgAFK = false,
    stringToType = "",
    event = nil,
    posStart = nil,
    afkStart = nil
}
stop = true
function URP.Admin.BeginAFK(self, stop)
    if stop then
        afk.isAfk = false
        afk.msgAFK = false
        afk.stringToType = ""
        afk.afkStart = nil
        afk.posStart = nil
        URP.Admin:SetStatus("Playing")
        if afk.event then
            RemoveEventHandler(afk.event)
        end
        return
    end

    if afk.msgAFK then return end

    self:SetStatus("AFK")
    afk.stringToType = ""

    for i = 1, 5 do
        local c = string.char(GetRandomIntInRange(97, 122))
        afk.stringToType = afk.stringToType .. string.lower(c)
    end

    afk.event = AddEventHandler("wrp-admin:afkStringCheck", function(text)
        if string.lower(text) == afk.stringToType then URP.Admin:BeginAFK(true) return end
    end)

    afk.msgAFK = true
    local beginTime = GetGameTimer()

    Citizen.CreateThread(function()
        local lastNotify = 0

        while true do
            Citizen.Wait(1000)

            if not afk.msgAFK then return end
            
            local curTime = GetGameTimer()

            if curTime - lastNotify >= 6500 then
                lastNotify = GetGameTimer()

                local string = [[<center><span style="font-size:28px;color:red;">You have been detected as AFK. Please type the message below within 5 minutes!<br /><hr style="border-color: rgba(255, 0, 0, 0.5);">%s</span></center>]]
                TriggerEvent("pNotify:SendNotification", {text = string.format(string, afk.stringToType), layout = "top", timeout = 5000, type = "error", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, queue = "afk", progressBar = false})
            end

            if curTime - beginTime >= 300000 then TriggerServerEvent("wrp-admin:Disconnect", "AFK Kick") return end
        end
    end)
end

function URP.Admin.AFKCheck(self)
    if afk.checkingAFK then return else afk.checkingAFK = true end

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)

            local ped = PlayerPedId()
            
            local curPos = GetEntityCoords(ped, false)
            local curTime = GetGameTimer()

            local rank = URP.Admin:GetPlayerRank()
            local rankData = URP.Admin:GetRankData(rank)
            local inExluded = false

            for i,v in ipairs(exludedZones) do
                if #(vector3(v.x,v.y,v.z) - GetEntityCoords(PlayerPedId())) < v.r then
                    inExluded = true
                end
            end

            if rankData and not rankData.allowafk and not inExluded then
                afk.posStart = afk.posStart and afk.posStart or curPos

                if Vdist2(afk.posStart, curPos) <= 20.0 then afk.afkStart = afk.afkStart and afk.afkStart or GetGameTimer() else afk.afkStart = nil afk.posStart = nil end
                if IsPedRagdoll(ped) then afk.afkStart = nil afk.posStart = nil end

                if afk.afkStart and curTime - afk.afkStart >= 1200000 and not afk.isAfk then
                    URP.Admin:BeginAFK()
                else
                    if afk.isAfk == true then
                        URP.Admin:BeginAFK(true)
                    end
                end
            end
        end
    end)
end

RegisterNetEvent("wrp-admin:afkStringCheck")

RegisterNetEvent("wrp-admin:setStatus")
AddEventHandler("wrp-admin:setStatus", function(src, status)
    local player = URP._Admin.Players[src]
    if not player then return else URP._Admin.Players[src].status = status end
end)

RegisterNetEvent("wrp-admin:sendPlayerInfo")
AddEventHandler("wrp-admin:sendPlayerInfo", function(data, discData)
    URP._Admin.Players = data
    URP._Admin.DiscPlayers = discData
end)

RegisterNetEvent("wrp-admin:RemovePlayer")
AddEventHandler("wrp-admin:RemovePlayer", function(data)
    URP._Admin.DiscPlayers[data.src] = data
    URP._Admin.Players[data.src] = nil
end)

RegisterNetEvent("wrp-admin:RemoveRecent")
AddEventHandler("wrp-admin:RemoveRecent", function(data)
    if data ~= nil then
        URP._Admin.DiscPlayers[data.src] = nil
    end
end)

RegisterNetEvent("wrp-admin:AddPlayer")
AddEventHandler("wrp-admin:AddPlayer", function(player)
    URP._Admin.Players[player.src] = player
end)

RegisterNetEvent('wrp-admin:teleportUser')
AddEventHandler('wrp-admin:teleportUser', function(x, y, z)
    SetEntityCoords(PlayerPedId(), x, y, z)
    TriggerEvent('DoLongHudText', 'You were summoned')
end)

RegisterNetEvent("wrp-admin:AddAllPlayers")
AddEventHandler("wrp-admin:AddAllPlayers", function(data)
    URP._Admin.Players[data.src] = data
end)

function URP.Admin.RunCommand(self, args)
    if not args or not args.command then return end
    TriggerServerEvent("wrp-admin:runCommand", args)
end

function URP.Admin.RunClCommand(self, cmd, args)
    if not cmd or not self:CommandExists(cmd) then return end
    self:GetCommandData(cmd).runclcommand(args)
end

RegisterNetEvent("wrp-admin:RunClCommand")
AddEventHandler("wrp-admin:RunClCommand", function(cmd, args)
    URP.Admin:RunClCommand(cmd, args)
end)

RegisterNetEvent("wrp-admin:updateData")
AddEventHandler("wrp-admin:updateData", function(src, type, data)
    if not src or not type or not data then return end
    if not URP._Admin.Players[src] then return end
    
    URP._Admin.Players[src][type] = data
end)

RegisterNetEvent("wrp-admin:noLongerAdmin")
AddEventHandler("wrp-admin:noLongerAdmin", function()
    URP._Admin.Players = {}
    
    for k,v in pairs(URP._Admin.Menu.Menus) do
        if WarMenu.IsMenuOpened(k) then WarMenu.CloseMenu() end
    end
end)

RegisterNetEvent("wrp-admin:bringPlayer")
AddEventHandler("wrp-admin:bringPlayer", function(targPos)
    local ped = PlayerPedId()


    Citizen.CreateThread(function()
        Citizen.Wait(100)
        RequestCollisionAtCoord(targPos[1],targPos[2],targPos[3])
        SetEntityCoordsNoOffset(PlayerPedId(), targPos[1],targPos[2],targPos[3], 0, 0, 2.0)
        FreezeEntityPosition(PlayerPedId(), true)
        SetPlayerInvincible(PlayerId(), true)

        local startedCollision = GetGameTimer()

        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            if GetGameTimer() - startedCollision > 5000 then break end
            Citizen.Wait(0)
        end

        FreezeEntityPosition(PlayerPedId(), false)
        SetPlayerInvincible(PlayerId(), false)
    end)    
end)

RegisterNetEvent("wrp-admin:bring")
AddEventHandler("wrp-admin:bring", function(target)
    local posR = GetEntityCoords(PlayerPedId(), false)

    local pos = {}
    pos[1] = posR.x
    pos[2] = posR.y
    pos[3] = posR.z

    TriggerServerEvent("wrp-admin:bringPlayerServer",pos,target)   
end)



 
RegisterNetEvent("wrp-admin:runSpawnCommand")
AddEventHandler("wrp-admin:runSpawnCommand", function(model, livery)
    Citizen.CreateThread(function()
        Citizen.Wait(10)
        local hash = GetHashKey(model)

        if not IsModelAVehicle(hash) then return end
        if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
        
        RequestModel(hash)

        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end

        local localped = PlayerPedId()
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)

        local heading = GetEntityHeading(localped)
        local vehicle = CreateVehicle(hash, coords, heading, true, false)

        SetVehicleModKit(vehicle, 0)
        SetVehicleMod(vehicle, 11, 3, false)
        SetVehicleMod(vehicle, 12, 2, false)
        SetVehicleMod(vehicle, 13, 2, false)
        SetVehicleMod(vehicle, 15, 3, false)
        SetVehicleMod(vehicle, 16, 4, false)


        if model == "pol1" then
            SetVehicleExtra(vehicle, 5, 0)
        end

        if model == "police" then
            SetVehicleWheelType(vehicle, 2)
            SetVehicleMod(vehicle, 23, 10, false)
            SetVehicleColours(vehicle, 0, false)
            SetVehicleExtraColours(vehicle, 0, false)
        end

        if model == "pol7" then
            SetVehicleColours(vehicle,0)
            SetVehicleExtraColours(vehicle,0)
        end

        if model == "pol5" or model == "pol6" then
            SetVehicleExtra(vehicle, 1, -1)
        end


        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent("garage:addKeys", plate)
        SetModelAsNoLongerNeeded(hash)
        
        SetVehicleDirtLevel(vehicle, 0)
        SetVehicleWindowTint(vehicle, 0)

        if livery ~= nil then
            SetVehicleLivery(vehicle, tonumber(livery))
        end
    end)
end)

function URP.Admin.teleportMarker(self)
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end

            Citizen.Wait(5)
        end

    else
        TriggerEvent("DoLongHudText", 'Failed to find marker.',2)
    end

end

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function URP.Admin.GetBanTimeFromString(self, time)
    if not time or not type(time) == "string" then return end

    if time == "permanent" then
        return temp, 99999999999999, addedTime
    end

    if time == "0" then
        return 0
    end

    local times = {
        ["m"] = {text = "Minute(s)", time = 0},
        ["h"] = {text = "Hour(s)", time = 0},
        ["d"] = {text = "Day(s)", time = 0},
        ["w"] = {text = "Week(s)", time = 0},
        ["M"] = {text = "Month(s)", time = 0},
        ["y"] = {text = "Year(s)", time = 0}
    }

    local temp = {}
    local timeSum = 0

    for i = 1, #time do
        local l = time:sub(i, i)
        if not tonumber(l) then
            if not times[l] then return false, false, false end
        end
    end

    local l = string.match(time, "%a+")
    if not l then return false, false, false end

    for k,v in pairs(times) do
        local s = string.match(time, "[%d+]?" .. k)

        if s then
            local t = tonumber(string.match(s, "%d+"))

            if not t or t < 0 then return false, false, false end

            times[k].time = t

            if k == "m" then
                timeSum = timeSum + (t * 60)
            elseif k == "h" then
                timeSum = timeSum + (t * 3600)
            elseif k == "d" then
                timeSum = timeSum + (t * 86400)
            elseif k == "w" then
                timeSum = timeSum + (t * 604800)
            elseif k == "M" then
                timeSum = timeSum + (t * 2629746)
            elseif k == "y" then
                timeSum = timeSum + (t * 31556952)
            end
        end
    end

    if IsDuplicityVersion() then
        local curTime = os.time()
        addedTime = timeSum + curTime
    else
        addedTime = false
    end

    local temp = {}

    for k,v in pairs(times) do
        if v.time > 0 then
            temp[k] = v
        end
    end
    return temp, timeSum, addedTime
end

RegisterNetEvent("wrp-admin:ReviveInDistance")
AddEventHandler("wrp-admin:ReviveInDistance", function()
    local playerList = {}

    local players = GetPlayers()
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)


    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
        local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
        if(distance < 50) then
            playerList[index] = GetPlayerServerId(value)
        end
    end

    if playerList ~= {} and playerList ~= nil then

        for k,v in pairs(playerList) do
            TriggerServerEvent('admin:revivePlayer', v)
            TriggerServerEvent('admin:healPlayer', v)
            TriggerEvent("Evidence:ClearDamageStates")
            TriggerEvent('client:lowerStress', 1000)
        end
    end
end)

URP.Admin:Init()