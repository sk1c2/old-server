RegisterServerEvent('admin:revivePlayer')
AddEventHandler('admin:revivePlayer', function(target)
    if target ~= nil then
        TriggerClientEvent('admin:revivePlayerClient', target)
        TriggerClientEvent('wrp-hospital:client:RemoveBleed', target) 
        TriggerClientEvent('wrp-hospital:client:ResetLimbs', target)
    end
end)