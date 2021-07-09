local pendingPing = nil
local isPending = false

function AddBlip(bData)
    pendingPing.blip = AddBlipForCoord(bData.x, bData.y, bData.z)
    SetBlipSprite(pendingPing.blip, bData.id)
    SetBlipAsShortRange(pendingPing.blip, true)
    SetBlipScale(pendingPing.blip, 0.7)
    SetBlipColour(pendingPing.blip, bData.color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(bData.name)
    EndTextCommandSetBlipName(pendingPing.blip)

    pendingPing.count = 0
end

function TimeoutPingRequest()
    Citizen.CreateThread(function()
        local count = 0
        while isPending do
            count = count + 1
            if count >= Config.Timeout and isPending then
                TriggerEvent('DoLongHudText', 'Ping From ' .. pendingPing.name .. ' Timed Out', 1)
                TriggerServerEvent('wrp-ping:server:SendPingResult', pendingPing.id, 'timeout')
                pendingPing = nil
                isPending = false
            end
            Citizen.Wait(1000)
        end
    end)
end

function TimeoutBlip()
    Citizen.CreateThread(function()
        while pendingPing ~= nil do
            if pendingPing.count ~= nil then
                if pendingPing.count >= Config.BlipDuration then
                    RemoveBlip(pendingPing.blip)
                    pendingPing = nil
                else
                    pendingPing.count = pendingPing.count + 1
                end
            end
            Citizen.Wait(1000)
        end
    end)
end

function RemoveBlipDistance()
    local player = PlayerPedId()
    Citizen.CreateThread(function()
        while pendingPing ~= nil do
            local plyCoords = GetEntityCoords(player)
            local dist = math.floor(#(vector2(pendingPing.pos.x, pendingPing.pos.y) - vector2(plyCoords.x, plyCoords.y)))

            if dist < Config.DeleteDistance then
                RemoveBlip(pendingPing.blip)
                pendingPing = nil
            else
                Citizen.Wait(math.floor((dist - Config.DeleteDistance) * 30))
            end
        end
    end)
end

RegisterNetEvent('wrp-ping:client:SendPing')
AddEventHandler('wrp-ping:client:SendPing', function(sender, senderId)
    if pendingPing == nil then
        pendingPing = {}
        pendingPing.id = senderId
        pendingPing.name = sender
        pendingPing.pos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(pendingPing.id)), false) 

        TriggerServerEvent('wrp-ping:server:SendPingResult', pendingPing.id, 'received')
        TriggerEvent('DoLongHudText', 'ID Sent You a Ping, Use /ping accept To Accept', 1)
        isPending = true

        if Config.Timeout > 0 then
            TimeoutPingRequest()
        end

    else
        TriggerEvent('DoLongHudText', sender .. ' Attempted To Ping You', 1)
        TriggerServerEvent('wrp-ping:server:SendPingResult', senderId, 'unable')
    end
end)

RegisterNetEvent('wrp-ping:client:AcceptPing')
AddEventHandler('wrp-ping:client:AcceptPing', function()
    if isPending then
        local playerBlip = { name = pendingPing.name, color = Config.BlipColor, id = Config.BlipIcon, scale = Config.BlipScale, x = pendingPing.pos.x, y = pendingPing.pos.y, z = pendingPing.pos.z }
        AddBlip(playerBlip)

        if Config.RouteToPing then
            SetNewWaypoint(pendingPing.pos.x, pendingPing.pos.y)
        end

        if Config.Timeout > 0 then
            TimeoutBlip()
        end

        if Config.DeleteDistance > 0 then
            RemoveBlipDistance()
        end

        TriggerEvent('DoLongHudText', pendingPing.name .. '\'s Location Showing On Map', 1)
        TriggerServerEvent('wrp-ping:server:SendPingResult', pendingPing.id, 'accept')
        isPending = false
    else
        TriggerEvent('DoLongHudText', 'You Have No Pending Ping', 2)
    end
end)

RegisterNetEvent('wrp-ping:client:RejectPing')
AddEventHandler('wrp-ping:client:RejectPing', function()
    if pendingPing ~= nil then
        TriggerEvent('DoLongHudText', 'Rejected Ping From ' .. pendingPing.name, 2)
        TriggerServerEvent('wrp-ping:server:SendPingResult', pendingPing.id, 'reject')
        pendingPing = nil
        isPending = false
    else
        TriggerEvent('DoLongHudText', 'You Have No Pending Ping', 2)
    end
end)

RegisterNetEvent('wrp-ping:client:RemovePing')
AddEventHandler('wrp-ping:client:RemovePing', function()
    if pendingPing ~= nil then
        RemoveBlip(pendingPing.blip)
        pendingPing = nil
        TriggerEvent('DoLongHudText', 'Player Ping Removed', 2)
    else
        TriggerEvent('DoLongHudText', 'You Have No Pending Ping', 2)
    end
end)