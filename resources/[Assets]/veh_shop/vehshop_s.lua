local repayTime = 168 * 60 -- hours * 60
local timer = ((60 * 3000) * 30) -- 10 minute timer

local carTable = {
	[1] = { ["model"] = "gauntlet", ["baseprice"] = 100000, ["commission"] = 15 }, 
	[2] = { ["model"] = "dubsta3", ["baseprice"] = 100000, ["commission"] = 15 },
	[3] = { ["model"] = "landstalker", ["baseprice"] = 100000, ["commission"] = 15 },
	[4] = { ["model"] = "bobcatxl", ["baseprice"] = 100000, ["commission"] = 15 },
	[5] = { ["model"] = "surfer", ["baseprice"] = 100000, ["commission"] = 15 },
	[6] = { ["model"] = "glendale", ["baseprice"] = 100000, ["commission"] = 15 },
	[7] = { ["model"] = "washington", ["baseprice"] = 100000, ["commission"] = 15 },
}

-- Update car table to server
RegisterServerEvent('carshop:table')
AddEventHandler('carshop:table', function(table)
    if table ~= nil then
        carTable = table
        TriggerClientEvent('veh_shop:returnTable', -1, carTable)
        updateDisplayVehicles()
    end
end)

-- Enables finance for 60 seconds
RegisterServerEvent('finance:enable')
AddEventHandler('finance:enable', function(plate)
    if plate ~= nil then
        TriggerClientEvent('finance:enableOnClient', -1, plate)
    end
end)

RegisterServerEvent('buy:enable')
AddEventHandler('buy:enable', function(plate)
    if plate ~= nil then
        TriggerClientEvent('buy:enableOnClient', -1, plate)
    end
end)

-- return table
-- TODO (return db table)
RegisterServerEvent('carshop:requesttable')
AddEventHandler('carshop:requesttable', function()
    local user = source
    local display = MySQL.Sync.fetchAll('SELECT * FROM __pdmcars')
    for k,v in pairs(display) do
        carTable[v.id] = v
        v.price = carTable[v.id].baseprice
    end
    TriggerClientEvent('veh_shop:returnTable', user, carTable)
end)

-- Check if player has enough money
RegisterServerEvent('CheckMoneyForVeh')
AddEventHandler('CheckMoneyForVeh', function(name, model,price,financed, cid, pdmdealer)
    local src = source
    -- local player = exports['wrp-base']:GetCurrentCharacterInfo(src)
    exports.ghmattimysql:execute('SELECT cash FROM __characters WHERE id = ?', {cid}, function(result)
        if financed then
            local financedPrice = math.ceil(price / 1.5)
            
            if result[1].cash >= financedPrice then
                print(financedPrice)
                TriggerClientEvent('wrp-base:getdata', src, financedPrice)
                TriggerClientEvent('FinishMoneyCheckForVeh', src, name, model, price, financed)
            else
                TriggerClientEvent('DoLongHudText', src, 'You dont have enough money on you!', 2)
                TriggerClientEvent('carshop:failedpurchase', src)
            end
        else
            if result[1].cash >= price then
                TriggerClientEvent('wrp-base:getdata', src, price)
                TriggerClientEvent('FinishMoneyCheckForVeh', src, name, model, price, financed)
            else
                TriggerClientEvent('DoLongHudText', src, 'You dont have enough money on you!', 2)
                TriggerClientEvent('carshop:failedpurchase', src)
            end
        end
    end)
end)


RegisterServerEvent('BuyForVeh')
AddEventHandler('BuyForVeh', function(plate, name, model, vehicle, price, personalvehicle, financed, namefull, cid)
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
        TriggerEvent('wrp-business:givepass', 'PDM', math.ceil(downPay / 2))
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
        TriggerEvent('wrp-business:givepass', 'PDM', math.ceil(price / 2))
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
    exports.ghmattimysql:execute('SELECT bank FROM __characters WHERE id = ?', {cid}, function(money)
        local repayTime = 168 * 60 -- hours * 60
        exports.ghmattimysql:execute('SELECT `finance`, `can_pay`, `payments` FROM __vehicles WHERE plate = ?', {pPlate}, function(result)
            if result[1] ~= nil then
                local amountdue = math.floor(result[1].finance/result[1].payments)
                if result[1].finance ~= tonumber(0) then
                    if result[1].can_pay == "true" then
                        if money[1].bank >= amountdue then
                            TriggerClientEvent("wrp-ac:removeban", src, amountdue)
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