RegisterServerEvent('prp-fish:getFish')
AddEventHandler('prp-fish:getFish', function()
local source = source
    local roll = math.random(1,11)
    if roll == 1 then
        TriggerClientEvent('prp-banned:getID', source, "fish", math.random(1,2))
    end
    if roll == 2 then
        TriggerClientEvent('prp-banned:getID', source, 'plastic', math.random(1,2))
    end
    if roll == 3 then
        TriggerClientEvent('prp-banned:getID', source, 'aluminium', math.random(1,2))
    end
    if roll == 5 then
        TriggerClientEvent('prp-banned:getID', source, "fishingbass", math.random(1,2))
    end
    if roll == 6 then
        TriggerClientEvent('prp-banned:getID', source, "fishingbluefish", math.random(1,2))
    end
    if roll == 7 then
        TriggerClientEvent('prp-banned:getID', source, "fishingcod", math.random(1,2))
    end
    if roll == 8 then
        TriggerClientEvent('prp-banned:getID', source, "fishingwhale", math.random(1,2))
    end
    if roll == 9 then
        TriggerClientEvent('prp-banned:getID', source, "fishingdolphin", math.random(1,2))
    end
    if roll == 10 then
        TriggerClientEvent('prp-banned:getID', source, "fishingshark", math.random(1,2))
    end
    if roll == 12 then
        TriggerClientEvent('prp-banned:getID', source, "rubber", math.random(1,2))
    end
end)

RegisterServerEvent('fish:returnDepo')
AddEventHandler('fish:returnDepo', function(sellfish)
    TriggerClientEvent("prp-ac:InfoPass", source, sellfish)
end)

RegisterServerEvent('fish:checkAndTakeDepo')
AddEventHandler('fish:checkAndTakeDepo', function()
    TriggerEvent("prp-ac:ban", source, 500)
end)