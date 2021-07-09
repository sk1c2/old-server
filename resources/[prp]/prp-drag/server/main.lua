RegisterServerEvent('dragme:drag')
AddEventHandler('dragme:drag', function(target)
    TriggerClientEvent('dragme:drag', target, source)
end)

RegisterServerEvent('dragme:detach')
AddEventHandler('dragme:detach', function()
    TriggerClientEvent('dragme:detach', source)
end)
