local playerInjury = {}

function GetCharsInjuries(source)
    return playerInjury[source]
end

RegisterServerEvent('prp-hospital:server:SyncInjuries')
AddEventHandler('prp-hospital:server:SyncInjuries', function(data)
    playerInjury[source] = data
end)