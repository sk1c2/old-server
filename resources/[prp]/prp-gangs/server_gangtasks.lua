RegisterServerEvent('trade:pay')
AddEventHandler('trade:pay', function(money)
    local source = source
    local LocalPlayer = exports['prp-base']:getModule('LocalPlayer')
    if money ~= nil then
       TriggerClientEvent('prp-ac:checkforban', source, money)
       TriggerClientEvent('DoLongHudText', source, 'You got $'.. money .. ' for 100 Gold Bars!', 1)
    end
end)