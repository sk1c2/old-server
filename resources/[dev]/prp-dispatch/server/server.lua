RegisterServerEvent("dispatch:svNotify")
AddEventHandler("dispatch:svNotify", function(data)
    TriggerClientEvent('dispatch:clNotify', -1, data)
end)


RegisterNetEvent('server:wrp-outlawalert:gunshotInProgress')
AddEventHandler('server:wrp-outlawalert:gunshotInProgress', function(targetCoords)
TriggerClientEvent('wrp-outlawalert:gunshotInProgress', targetCoords)
end)

RegisterNetEvent('wrp-blip:shotsfired')
AddEventHandler('wrp-blip:shotsfired', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-outlawalert:gunshotInProgress', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:vehiclecrash')
AddEventHandler('wrp-blips:vehiclecrash', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:vehiclecrash', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:combatprog')
AddEventHandler('wrp-blips:combatprog', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-outlawalert:combatInProgress', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:vehicletheft')
AddEventHandler('wrp-blips:vehicletheft', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:vehiclesteal', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:downedperson')
AddEventHandler('wrp-blips:downedperson', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:downedperson', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:officerdownA')
AddEventHandler('wrp-blips:officerdownA', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:policealertA', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:officerdownB')
AddEventHandler('wrp-blips:officerdownB', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:policealertB', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:medicDownA')
AddEventHandler('wrp-blips:medicDownA', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:tenForteenA', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:medicDownB')
AddEventHandler('wrp-blips:medicDownB', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:tenForteenB', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-alerts:panic')
AddEventHandler('wrp-alerts:panic', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:panic', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:storerobbery')
AddEventHandler('wrp-blips:storerobbery', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:storerobbery', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:houserobbery')
AddEventHandler('wrp-blips:houserobbery', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:houserobbery', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:banktruck')
AddEventHandler('wrp-blips:banktruck', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:banktruck', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:jewelrobbey')
AddEventHandler('wrp-blips:jewelrobbey', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:jewelrobbey', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:jailbreak')
AddEventHandler('wrp-blips:jailbreak', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:jailbreak', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:fleecarobbery')
AddEventHandler('wrp-blips:fleecarobbery', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:fleecarobbery', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:bigbankrobbery')
AddEventHandler('wrp-blips:bigbankrobbery', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:bigbankrobbery', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:powerplant')
AddEventHandler('wrp-blips:powerplant', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:powerplant', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:drugjob')
AddEventHandler('wrp-blips:drugjob', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:drugjob', playerId, plyPos)
    end
end)

RegisterNetEvent('wrp-blips:vehicle-suspicion')
AddEventHandler('wrp-blips:vehicle-suspicion', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('wrp-alerts:vehiclesuspicion', playerId, plyPos)
    end
end)