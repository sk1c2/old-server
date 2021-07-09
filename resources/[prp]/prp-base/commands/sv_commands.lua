RegisterNetEvent('prp-base:setRank')
AddEventHandler('prp-base:setRank', function(target, rank)
    local source = source
    if target ~= nil then
        TriggerClientEvent('prp-base:setRank', target, rank)
    end
end)
        
RegisterNetEvent('prp-base:setJob')
AddEventHandler('prp-base:setJob', function(target, job)
    local source = source
    if target ~= nil then
        TriggerClientEvent('prp-base:setJob', target, job)
    end
end)