RegisterServerEvent('server:givepayJob')
AddEventHandler('server:givepayJob', function(money)
    local source = source
    local LocalPlayer = exports['wrp-base']:getModule('LocalPlayer')
    if money ~= nil then
        if money > 1200 then
            TriggerEvent('wrp-ac:sort', source)
        else
            TriggerClientEvent('wrp-ac:InfoPass', source, money)
        end
    end
end)