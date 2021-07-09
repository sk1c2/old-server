local repayTime = 168 * 60 -- hours * 60
local timer = ((60 * 3000) * 30) -- 10 minute timer

local carTable = {
	[1] = { ["name"] = "Kawasaki Ninja ZX10R", ["model"] = "zx10", ["baseprice"] = 250000, ["commission"] = 25 }, 
	[2] = { ["name"] = "BMW LW M4", ["model"] = "m4", ["baseprice"] = 287500, ["commission"] = 25 }, 
	[3] = { ["name"] = "Honda Integra Type R", ["model"] = "dc5", ["baseprice"] = 250000, ["commission"] = 25 }, 
	[4] = { ["name"] = "Dodge Challenger Raid", ["model"] = "raid", ["baseprice"] = 320000, ["commission"] = 25 }, 
	[5] = { ["name"] = "Lamborghini Murcielago LW LP670", ["model"] = "lwlp670", ["baseprice"] = 390000, ["commission"] = 25 }, 
	[6] = { ["name"] = "Liberty Walk GTR", ["model"] = "lwgtr", ["baseprice"] = 600000, ["commission"] = 25 }, 
	[7] = { ["name"] = "Bentley CGT Dragon", ["model"] = "bdragon", ["baseprice"] = 390000, ["commission"] = 25 }, 
}


-- Update car table to server
RegisterServerEvent('carshop:table69')
AddEventHandler('carshop:table69', function(table)
    if table ~= nil then
        carTable = table
        TriggerClientEvent('veh_shop:returnTable69', -1, carTable)
        updateDisplayVehicles()
    end
end)

-- Enables finance for 60 seconds
RegisterServerEvent('finance:enable69')
AddEventHandler('finance:enable69', function(plate)
    if plate ~= nil then
        TriggerClientEvent('finance:enableOnClient69', -1, plate)
    end
end)

RegisterServerEvent('buy:enable69')
AddEventHandler('buy:enable69', function(plate)
    if plate ~= nil then
        TriggerClientEvent('buy:enableOnClient69', -1, plate)
    end
end)

-- return table
-- TODO (return db table)
RegisterServerEvent('carshop:requesttable69')
AddEventHandler('carshop:requesttable69', function()
    local user = source
    local display = MySQL.Sync.fetchAll('SELECT * FROM __pdmcars')
    for k,v in pairs(display) do
        carTable[v.id] = v
        v.price = carTable[v.id].baseprice
    end
    TriggerClientEvent('veh_shop:returnTable69', user, carTable)
end)

-- Check if player has enough money
RegisterServerEvent('CheckMoneyForVeh69')
AddEventHandler('CheckMoneyForVeh69', function(name, model,price,financed, cid, pdmdealer)
    local src = source
    exports.ghmattimysql:execute('SELECT `cash` FROM __characters WHERE id = ?', {cid}, function(result)
        if financed then
            local financedPrice = math.ceil(price / 1.5)
            if result[1].cash >= financedPrice then
                print(financedPrice)
                TriggerClientEvent('prp-base:getdata', src, financedPrice)
                TriggerClientEvent('FinishMoneyCheckForVeh69', src, name, model, price, financed)
            else
                TriggerClientEvent('DoLongHudText', src, 'You dont have enough money on you!', 2)
                TriggerClientEvent('carshop:failedpurchase', src)
            end
        else
            if result[1].cash >= price then
                TriggerClientEvent('prp-base:getdata', src, price)
                TriggerClientEvent('FinishMoneyCheckForVeh69', src, name, model, price, financed)
            else
                TriggerClientEvent('DoLongHudText', src, 'You dont have enough money on you!', 2)
                TriggerClientEvent('carshop:failedpurchase', src)
            end
        end
    end)
end)


RegisterServerEvent('BuyForVeh69')
AddEventHandler('BuyForVeh69', function(plate, name, model, vehicle, price, personalvehicle, financed, cid, namefull)
	local src = source
    fullname = namefull
    if financed then
        local cols = 'cid, plate, model, vehicle, buy_price, payments, finance, financetimer, name, fullname'
        local val = '@cid, @plate, @model, @vehicle, @buy_price, @payments, @finance, @financetimer, @name, @fullname'
        local downPay = math.ceil(price / 1.5)
        
        print(cid)
        MySQL.Async.execute('INSERT INTO __vehicles ( '..cols..' ) VALUES ( '..val..' )',{
            ['@cid']   = cid,
            ['@plate']   = plate,
            ['@model'] = model,
            ['@vehicle'] = json.encode(personalvehicle),
            ['@name'] = vehicle,
            ['@fullname'] = fullname,
            ['@buy_price'] = price,
            ['@payments'] = '14',
            ['@finance'] = price - downPay,
            ['@financetimer'] = repayTime,
        })
        TriggerEvent('prp-business:givepass', 'tuner_carshop', math.ceil(downPay / 1.2))
    else
        MySQL.Async.execute('INSERT INTO __vehicles (cid, plate, model, vehicle, name, fullname) VALUES (@cid, @plate, @model, @vehicle, @name, @fullname)',{
            ['@cid']   =  cid,
            ['@plate']   = plate,
            ['@model'] = model,
            ['@vehicle'] = json.encode(personalvehicle),
            ['@name'] = vehicle,
            ['@buy_price'] = price,
            ['@fullname'] = fullname,
        })
        TriggerEvent('prp-business:givepass', 'tuner_carshop', math.ceil(price))
    end
end)

-- Get All finance > 0 then take 10min off
-- Every 10 Min
function updateFinance()
    MySQL.Async.fetchAll('SELECT financetimer, plate FROM __vehicles WHERE financetimer > @financetimer', {
        ["@financetimer"] = 0
    }, function(result)
        for i=1, #result do
            local financeTimer = result[i].financetimer
            local plate = result[i].plate
            local newTimer = financeTimer - 10
            if financeTimer ~= nil then
                MySQL.Sync.execute('UPDATE __vehicles SET financetimer = @financetimer WHERE plate = @plate', {
                    ['@plate'] = plate,
                    ['@financetimer'] = newTimer
                })
            end
            if financeTimer < 100 then
                exports.ghmattimysql:execute("UPDATE __vehicles SET `can_pay` = @can_pay WHERE `plate` = @plate ", {
                    ['@can_pay'] = "true",
                    ['@plate'] = plate
                })
            end
        end
    end)
    SetTimeout(timer, updateFinance)
end
SetTimeout(timer, updateFinance)

RegisterNetEvent('RS7x:phonePayment')
AddEventHandler('RS7x:phonePayment', function(plate, cid)
    local src = source
    local pPlate = plate
    exports.ghmattimysql:execute('SELECT `bank` FROM __characters WHERE id = ?', {cid}, function(money)
        local repayTime = 168 * 60 -- hours * 60
        exports.ghmattimysql:execute('SELECT `finance`, `payments`, `can_pay` FROM __vehicles WHERE plate = ?', {pPlate}, function(result)
            if result[1] ~= nil then
                local amountdue = math.floor(result[1].finance/result[1].payments)
                if result[1].finance ~= tonumber(0) then
                    if result[1].can_pay == "true" then
                        if money[1].bank >= amountdue then
                            -- TriggerClientEvent("prp-ac:removeban", src, amountdue)
                            exports.ghmattimysql:execute("UPDATE __vehicles SET `payments` = @payments, `finance` = @finance, `financetimer` = @financetimer, `can_pay` = @can_pay WHERE `plate` = @plate", {
                                ['@plate'] = pPlate,
                                ['@payments'] = result[1].payments - 1,
                                ['@finance'] = result[1].finance - amountdue,
                                ['@financetimer'] = repayTime,
                                ['@can_pay'] = "false"
                            })
                    
                        else
                            TriggerClientEvent("DoLongHudText", src, "You cant afford the payment of $" ..amountdue, 2)
                        end
                    else
                        TriggerClientEvent("DoLongHudText", src, "You need to wait a week to pay your car payment again", 2)
                    end
                else
                    Citizen.Wait(10000)
                    TriggerClientEvent("DoLongHudText", src, "This car is already paid off")
                end
            end
        end)
    end)
end)

function updateDisplayVehicles()
    for i=1, #carTable do
        exports.ghmattimysql:execute("UPDATE __pdmcars SET model=@model, commission=@commission, baseprice=@baseprice WHERE id=@id", {
            ['@id'] = i,
            ['@model'] = carTable[i]["model"],
            ['@commission'] = carTable[i]["commission"],
            ['@baseprice'] = carTable[i]["baseprice"]
        })
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        updateDisplayVehicles()
    end
end)