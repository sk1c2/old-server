local chicken = vehicleBaseRepairCost

RegisterServerEvent('wrp-mechanic:attemptPurchase')
AddEventHandler('wrp-mechanic:attemptPurchase', function(cid, cash, type, upgradeLevel)
    local source = source
    if type == "repair" then
        if cash >= chicken then
            TriggerClientEvent('wrp-mechanic:purchaseSuccessful', source, chicken)
        else
            TriggerClientEvent('wrp-mechanic:purchaseFailed', source)
        end
    elseif type == "performance" then
        if cash >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('wrp-mechanic:purchaseSuccessful', source, vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('wrp-mechanic:purchaseFailed', source)
        end
    else
        if cash >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('wrp-mechanic:purchaseSuccessful', source, vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('wrp-mechanic:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('wrp-bennys:updateRepairCost')
AddEventHandler('wrp-bennys:updateRepairCost', function(cost)
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