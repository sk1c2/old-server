local chicken = vehicleBaseRepairCost

RegisterServerEvent('wrp-bennys:attemptPurchase')
AddEventHandler('wrp-bennys:attemptPurchase', function(cid, cash, type, upgradeLevel)
    local source = source
    if type == "repair" then
        if cash >= chicken then
            TriggerClientEvent('wrp-bennys:purchaseSuccessful', source, chicken)
        else
            TriggerClientEvent('wrp-bennys:purchaseFailed', source)
        end
    elseif type == "performance" then
        if cash >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('wrp-bennys:purchaseSuccessful', source, vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('wrp-bennys:purchaseFailed', source)
        end
    else
        if cash >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('wrp-bennys:purchaseSuccessful', source, vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('wrp-bennys:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('wrp-bennys:updateRepairCost')
AddEventHandler('wrp-bennys:updateRepairCost', function(cost)
    chicken = cost
end)

RegisterServerEvent('updateVehicle')
AddEventHandler('updateVehicle', function(myCar)
    exports.ghmattimysql:execute('UPDATE `__vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate']   = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)

RegisterCommand('breasty', function(source)
    local src = source
    local player = exports['wrp-base']:GetCurrentCharacterInfo(source)
    TriggerClientEvent('DoShortHudText', src, player.id)
end)