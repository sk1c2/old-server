RegisterServerEvent("dispatch:svNotify")
AddEventHandler("dispatch:svNotify", function(data)
    TriggerClientEvent('dispatch:clNotify', -1, data)
end)


RegisterNetEvent('server:prp-outlawalert:gunshotInProgress')
AddEventHandler('server:prp-outlawalert:gunshotInProgress', function(targetCoords)
TriggerClientEvent('prp-outlawalert:gunshotInProgress', targetCoords)
end)

RegisterNetEvent('prp-blip:shotsfired')
AddEventHandler('prp-blip:shotsfired', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-outlawalert:gunshotInProgress', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:vehiclecrash')
AddEventHandler('prp-blips:vehiclecrash', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:vehiclecrash', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:combatprog')
AddEventHandler('prp-blips:combatprog', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-outlawalert:combatInProgress', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:vehicletheft')
AddEventHandler('prp-blips:vehicletheft', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:vehiclesteal', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:downedperson')
AddEventHandler('prp-blips:downedperson', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:downedperson', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:officerdownA')
AddEventHandler('prp-blips:officerdownA', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:policealertA', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:officerdownB')
AddEventHandler('prp-blips:officerdownB', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:policealertB', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:medicDownA')
AddEventHandler('prp-blips:medicDownA', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:tenForteenA', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:medicDownB')
AddEventHandler('prp-blips:medicDownB', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:tenForteenB', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-alerts:panic')
AddEventHandler('prp-alerts:panic', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:panic', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:storerobbery')
AddEventHandler('prp-blips:storerobbery', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:storerobbery', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:houserobbery')
AddEventHandler('prp-blips:houserobbery', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:houserobbery', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:banktruck')
AddEventHandler('prp-blips:banktruck', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:banktruck', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:jewelrobbey')
AddEventHandler('prp-blips:jewelrobbey', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:jewelrobbey', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:jailbreak')
AddEventHandler('prp-blips:jailbreak', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:jailbreak', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:fleecarobbery')
AddEventHandler('prp-blips:fleecarobbery', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:fleecarobbery', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:bigbankrobbery')
AddEventHandler('prp-blips:bigbankrobbery', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:bigbankrobbery', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:powerplant')
AddEventHandler('prp-blips:powerplant', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:powerplant', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:drugjob')
AddEventHandler('prp-blips:drugjob', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:drugjob', playerId, plyPos)
    end
end)

RegisterNetEvent('prp-blips:vehicle-suspicion')
AddEventHandler('prp-blips:vehicle-suspicion', function(plyPos)
    for k, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('prp-alerts:vehiclesuspicion', playerId, plyPos)
    end
end)