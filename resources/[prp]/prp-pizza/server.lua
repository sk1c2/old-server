RegisterServerEvent('prp-pizza:cash')
AddEventHandler('prp-pizza:cash', function(money)
    local source = source
    local LocalPlayer = exports['prp-base']:getModule('LocalPlayer')
    if money ~= nil then
       TriggerClientEvent('prp-ac:InfoPass', source, money)
       TriggerClientEvent('DoLongHudText', source, 'You got $'.. money .. '.', 1)
    end
end)