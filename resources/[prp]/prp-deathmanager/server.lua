RegisterServerEvent('admin:revivePlayer')
AddEventHandler('admin:revivePlayer', function(target)
    if target ~= nil then
        TriggerClientEvent('admin:revivePlayerClient', target)
        TriggerClientEvent('prp-hospital:client:RemoveBleed', target) 
        TriggerClientEvent('prp-hospital:client:ResetLimbs', target)
    end
end)