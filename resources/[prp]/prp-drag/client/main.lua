dragStatus = {}
dragStatus.isDragged = false
isInVehicle = false
InVehicle = nil
local vehicle

function GetPlayers() -- function to get players
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

GetClosestPlayer = function()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end

function DragMe()
    local closestPlayer, closestDistance = GetClosestPlayer()
    local targetPed = GetPlayerPed(closestPlayer)
    local isInCar = IsPedSittingInAnyVehicle(PlayerPedId())
    if closestPlayer ~= -1 and closestDistance <= 3.0 and not isInCar and CanDoWhileDead(targetPed) then
        TriggerServerEvent('dragme:drag', GetPlayerServerId(closestPlayer))
    end
end

RegisterNetEvent('civDrag')
AddEventHandler('civDrag', function()
    local closestPlayer, closestDistance = GetClosestPlayer()
    local targetPed = GetPlayerPed(closestPlayer)
    local isInCar = IsPedSittingInAnyVehicle(PlayerPedId())
    if closestPlayer ~= -1 and closestDistance <= 3.0 and not isInCar and CanDoWhileDead(targetPed) then
        TriggerServerEvent('dragme:drag', GetPlayerServerId(closestPlayer))
	else
        TriggerEvent('DoLongHudText', 'There is no player(s) nearby!', 2)
	end
end)

function CanDoWhileDead(targetPed)
    if Config.OnlyWhileDead then
        return IsPedDeadOrDying(targetPed)
    else
        return true
    end
end

RegisterNetEvent('dragme:drag')
AddEventHandler('dragme:drag', function(draggerId)
    dragStatus.isDragged = not dragStatus.isDragged
    dragStatus.draggerId = draggerId
    isInVehicle = false
    vehicle = nil
end)

RegisterNetEvent('dragme:detach')
AddEventHandler('dragme:detach', function()
    dragStatus.isDragged = false
    isInVehicle = false
    vehicle = nil
end)

Citizen.CreateThread(function()
    local playerPed
    local targetPed

    while true do
        Citizen.Wait(0)
        local sleep = true
        playerPed = PlayerPedId()

        if not CanDoWhileDead(playerPed) then
            isInVehicle = false
        end

        if dragStatus.isDragged then
            sleep = false
            targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.draggerId))

            -- undrag if target is in an vehicle
            if not IsPedSittingInAnyVehicle(targetPed) and not IsPedSittingInAnyVehicle(playerPed) and CanDoWhileDead(playerPed) and not isInVehicle then
                AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            else
                dragStatus.isDragged = false
                DetachEntity(playerPed, true, false)
            end

            if IsPedDeadOrDying(targetPed, true) then
                dragStatus.isDragged = false
                DetachEntity(playerPed, true, false)
            end
        elseif isInVehicle then
            sleep = false
            DisableAllControlActions(0)
            EnableControlAction(0, 1)
            EnableControlAction(0, 2)
            AttachEntityToEntity(playerPed, InVehicle, -1, 0.0, 0.0, 0.4, 0.0, 0.0, 0.0, false, false, true, true, 2, true)
--        elseif not exports['prp-trunk']:isInTrunk() and not isInVehicle and not exports['prp-drag']:isCarrying() then
--        WTF IS THIS SHIT 
            isInVehicle = false
            DetachEntity(playerPed, true, false)
        end
        if sleep == true then
            Citizen.Wait(500)
        end
    end
end)