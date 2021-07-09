RegisterNetEvent('wrp-base:setRank')
AddEventHandler('wrp-base:setRank', function(target, rank)
    local source = source
    if target ~= nil then
        TriggerClientEvent('wrp-base:setRank', target, rank)
    end
end)
        
RegisterNetEvent('wrp-base:setJob')
AddEventHandler('wrp-base:setJob', function(target, job)
    local source = source
    if target ~= nil then
        TriggerClientEvent('wrp-base:setJob', target, job)
    end
end)