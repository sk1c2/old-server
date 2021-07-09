CasinoOpen = false
Debug = false
RegisterServerEvent('prp-unlock:casino')
AddEventHandler('prp-unlock:casino', function()
    local src = source
    TriggerClientEvent('prp-casino:unlock', -1)
    TriggerClientEvent("phone:addnotification", -1, "Casino","<b> -- Casino -- <b> <br> The Casino is Open! Head down there now to have the chance to win some serious money! <br>")
    CasinoOpen = true
end)


RegisterServerEvent('prp-casino:lock')
AddEventHandler('prp-casino:lock', function()
    local src = source
    TriggerClientEvent('prp-casino:lock', -1)
    TriggerClientEvent("phone:addnotification", -1, "Casino","<b> -- Casino -- <b> <br> The Casino is now Closed! Be sure to head there another day to have the chance to win some serious money! <br>")
    CasinoOpen = false
end)


RegisterNetEvent('prp-casino:CheckIfOpen')
AddEventHandler('prp-casino:CheckIfOpen', function()
    local src = source
    if CasinoOpen then
        TriggerClientEvent('prp-casino:unlock', src)
        Citizen.Wait(120000)
        TriggerClientEvent("phone:addnotification", src, "Casino","<b> -- Casino -- <b> <br> The Casino is Open! Head down there now to have the chance to win some serious money! <br>")
        if Debug then
            print('Casino is Open')
        end
    else
        TriggerClientEvent('prp-casino:lock', src)
        if Debug then
            print('Casino is Not Open')
        end
    end
end)