RegisterServerEvent('wrp-uber:pay')
AddEventHandler('wrp-uber:pay', function(money)
    local source = source
    local LocalPlayer = exports['wrp-base']:getModule('LocalPlayer')
    if money ~= nil then
       TriggerClientEvent('wrp-ac:InfoPass', source, money)
       TriggerClientEvent('DoLongHudText', source, 'You got $'.. money .. ' for 1 drop.', 1)
    end
end)