local chicken = vehicleBaseRepairCost

RegisterServerEvent('prp-mechanic:attemptPurchase')
AddEventHandler('prp-mechanic:attemptPurchase', function(cid, cash, type, upgradeLevel)
    local source = source
    if type == "repair" then
        if cash >= chicken then
            TriggerClientEvent('prp-mechanic:purchaseSuccessful', source, chicken)
        else
            TriggerClientEvent('prp-mechanic:purchaseFailed', source)
        end
    elseif type == "performance" then
        if cash >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('prp-mechanic:purchaseSuccessful', source, vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('prp-mechanic:purchaseFailed', source)
        end
    else
        if cash >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('prp-mechanic:purchaseSuccessful', source, vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('prp-mechanic:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('prp-bennys:updateRepairCost')
AddEventHandler('prp-bennys:updateRepairCost', function(cost)
    chicken = cost
end)

RegisterServerEvent('updateVehicle2')
AddEventHandler('updateVehicle2', function(myCar)
    exports.ghmattimysql:execute('UPDATE `__vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate']   = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)