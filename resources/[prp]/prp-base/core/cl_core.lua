function URP.Core.Initialize(self)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)
            if NetworkIsSessionStarted() then
                TriggerEvent("wrp-base:playerSessionStarted")
                --TriggerServerEvent("wrp-base:playerSessionStarted")
                break
            end
        end
    end)
end
URP.Core:Initialize()

AddEventHandler("wrp-base:playerSessionStarted", function()
    URP.SpawnManager:Initialize()
end)

RegisterNetEvent("wrp-base:waitForExports")
AddEventHandler("wrp-base:waitForExports", function()
    if not URP.Core.ExportsReady then return end

    while true do
        Citizen.Wait(3)
        if exports and exports["wrp-base"] then
            TriggerEvent("wrp-base:exportsReady")
            return
        end
    end
end)
 
function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

RegisterNetEvent("customNotification")
AddEventHandler("customNotification", function(msg, length, type)

	TriggerEvent("chatMessage","SYSTEM",4,msg)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        health = GetEntityMaxHealth(PlayerPedId())
        if health < 200 then
            SetPedMaxHealth(PlayerPedId(), 200)
            Citizen.Wait(10)
            SetEntityMaxHealth(PlayerPedId(), 200)
            Citizen.Wait(10)
            SetEntityHealth(PlayerPedId(), 200)
            -- print('Module Triggered')
        end
    end
end)