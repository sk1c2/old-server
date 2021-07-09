local repayTime = 168 * 60 -- hours * 60
local timer = ((60 * 3000) * 30) -- 10 minute timer

local carTable = {
	[1] = { ["name"] = "frogger", ["baseprice"] = 750000, ["commission"] = 15 }, 
	[2] = { ["name"] = "havok", ["baseprice"] = 750000, ["commission"] = 15 },
	[3] = { ["name"] = "seabreeze", ["baseprice"] = 750000, ["commission"] = 15 },
	[4] = { ["name"] = "mammatus", ["baseprice"] = 750000, ["commission"] = 15 },
	[5] = { ["name"] = "seasparrow", ["baseprice"] = 750000, ["commission"] = 15 },
	[6] = { ["name"] = "supervolito2", ["baseprice"] = 750000, ["commission"] = 15 },
	[7] = { ["name"] = "swift2", ["baseprice"] = 750000, ["commission"] = 15 },
	[8] = { ["name"] = "volatus", ["baseprice"] = 750000, ["commission"] = 15 },
}


-- Update car table to server
RegisterServerEvent('carshop:table69Plane')
AddEventHandler('carshop:table69Plane', function(table)
    if table ~= nil then
        carTable = table
        TriggerClientEvent('veh_shop:returnTable69Plane', -1, carTable)
        updateDisplayVehicles()
    end
end)

-- Enables finance for 60 seconds
RegisterServerEvent('finance:enable69Plane')
AddEventHandler('finance:enable69Plane', function(plate)
    if plate ~= nil then
        TriggerClientEvent('finance:enableOnClient69Plane', -1, plate)
    end
end)

RegisterServerEvent('buy:enable69Plane')
AddEventHandler('buy:enable69Plane', function(plate)
    if plate ~= nil then
        TriggerClientEvent('buy:enableOnClient69Plane', -1, plate)
    end
end)

-- return table
-- TODO (return db table)
RegisterServerEvent('carshop:requesttable69Plane')
AddEventHandler('carshop:requesttable69Plane', function()
    local user = source
    local display = MySQL.Sync.fetchAll('SELECT * FROM __pdmcars')
    for k,v in pairs(display) do
        carTable[v.id] = v
        v.price = carTable[v.id].baseprice
    end
    TriggerClientEvent('veh_shop:returnTable69', user, carTable)
end)

-- Check if player has enough money
RegisterServerEvent('CheckMoneyForVeh69Plane')
AddEventHandler('CheckMoneyForVeh69Plane', function(model,price,financed, cid, pdmdealer)
    local src = source
    exports.ghmattimysql:execute('SELECT `cash` FROM __characters WHERE id = ?', {cid}, function(result)
        if financed then
            local financedPrice = math.ceil(price / 1.5)
            if result[1].cash >= financedPrice then
                print(financedPrice)
                TriggerClientEvent('prp-base:getdata', src, financedPrice)
                TriggerClientEvent('FinishMoneyCheckForVeh69Plane', src, model, price, financed)
            else
                TriggerClientEvent('DoLongHudText', src, 'You dont have enough money on you!', 2)
                TriggerClientEvent('carshop:failedpurchasePlane', src)
            end
        else
            if result[1].cash >= price then
                TriggerClientEvent('prp-base:getdata', src, price)
                TriggerClientEvent('FinishMoneyCheckForVeh69Plane', src, model, price, financed)
            else
                TriggerClientEvent('DoLongHudText', src, 'You dont have enough money on you!', 2)
                TriggerClientEvent('carshop:failedpurchasePlane', src)
            end
        end
    end)
end)


RegisterServerEvent('BuyForVeh69Plane')
AddEventHandler('BuyForVeh69Plane', function(plate, name, model, vehicle, price, personalvehicle, financed, cid, namefull)
	local src = source
    fullname = namefull
    if financed then
        local cols = 'cid, plate, model, vehicle, buy_price, payments, finance, financetimer, name, fullname'
        local val = '@cid, @plate, @model, @vehicle, @buy_price, @payments, @finance, @financetimer, @name, @fullname'
        local downPay = math.ceil(price / 1.5)
        
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
        TriggerEvent('prp-business:givepass', 'SkyHighEnterprise', math.ceil(downPay / 2))
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
        TriggerEvent('prp-business:givepass', 'SkyHighEnterprise', math.ceil(price / 1.5))
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

RegisterNetEvent('RS7x:phonePaymentPlane')
AddEventHandler('RS7x:phonePaymentPlane', function(plate, cid)
    local src = source
    local pPlate = plate
    exports.ghmattimysql:execute('SELECT `bank` FROM __characters WHERE id = ?', {cid}, function(money)
        local repayTime = 168 * 60 -- hours * 60
        exports.ghmattimysql:execute('SELECT `finance`, `payments`, `can_pay`  FROM __vehicles WHERE plate = ?', {pPlate}, function(result)
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