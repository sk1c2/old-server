RegisterServerEvent('server:givepayJob')
AddEventHandler('server:givepayJob', function(money)
    local source = source
    local LocalPlayer = exports['prp-base']:getModule('LocalPlayer')
    if money ~= nil then
        if money > 1200 then
            TriggerEvent('prp-ac:sort', source)
        else
            TriggerClientEvent('prp-ac:InfoPass', source, money)
        end
    end
end)