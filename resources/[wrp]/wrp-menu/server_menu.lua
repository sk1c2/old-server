RegisterServerEvent('wrp-interactions:putInVehicle')
AddEventHandler('wrp-interactions:putInVehicle', function(target)
    TriggerClientEvent('wrp-interactions:putInVehicle', target)
end)

RegisterServerEvent('wrp-interactions:outOfVehicle')
AddEventHandler('wrp-interactions:outOfVehicle', function(target)
    TriggerClientEvent('wrp-interactions:outOfVehicle', target)
end)
