RegisterServerEvent('wrp-pizza:cash')
AddEventHandler('wrp-pizza:cash', function(money)
    local source = source
    local LocalPlayer = exports['wrp-base']:getModule('LocalPlayer')
    if money ~= nil then
       TriggerClientEvent('wrp-ac:InfoPass', source, money)
       TriggerClientEvent('DoLongHudText', source, 'You got $'.. money .. '.', 1)
    end
end)