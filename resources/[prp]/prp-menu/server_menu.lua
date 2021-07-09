RegisterServerEvent('prp-interactions:putInVehicle')
AddEventHandler('prp-interactions:putInVehicle', function(target)
    TriggerClientEvent('prp-interactions:putInVehicle', target)
end)

RegisterServerEvent('prp-interactions:outOfVehicle')
AddEventHandler('prp-interactions:outOfVehicle', function(target)
    TriggerClientEvent('prp-interactions:outOfVehicle', target)
end)
