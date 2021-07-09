RegisterServerEvent('prp-uber:pay')
AddEventHandler('prp-uber:pay', function(money)
    local source = source
    local LocalPlayer = exports['prp-base']:getModule('LocalPlayer')
    if money ~= nil then
       TriggerClientEvent('prp-ac:InfoPass', source, money)
       TriggerClientEvent('DoLongHudText', source, 'You got $'.. money .. ' for 1 drop.', 1)
    end
end)