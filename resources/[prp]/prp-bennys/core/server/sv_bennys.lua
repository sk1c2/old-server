local chicken = vehicleBaseRepairCost

RegisterServerEvent('prp-bennys:attemptPurchase')
AddEventHandler('prp-bennys:attemptPurchase', function(cid, cash, type, upgradeLevel)
    local source = source
    if type == "repair" then
        if cash >= chicken then
            TriggerClientEvent('prp-bennys:purchaseSuccessful', source, chicken)
        else
            TriggerClientEvent('prp-bennys:purchaseFailed', source)
        end
    elseif type == "performance" then
        if cash >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('prp-bennys:purchaseSuccessful', source, vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('prp-bennys:purchaseFailed', source)
        end
    else
        if cash >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('prp-bennys:purchaseSuccessful', source, vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('prp-bennys:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('prp-bennys:updateRepairCost')
AddEventHandler('prp-bennys:updateRepairCost', function(cost)
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
    local player = exports['prp-base']:GetCurrentCharacterInfo(source)
    TriggerClientEvent('DoShortHudText', src, player.id)
end)