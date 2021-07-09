local playerInjury = {}

function GetCharsInjuries(source)
    return playerInjury[source]
end

RegisterServerEvent('wrp-hospital:server:SyncInjuries')
AddEventHandler('wrp-hospital:server:SyncInjuries', function(data)
    playerInjury[source] = data
end)