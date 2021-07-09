local repayTime = 168 * 60 -- hours * 60
local timer = ((60 * 1000) * 10) -- 10 minute timer


RegisterServerEvent('house:updatespawns')
AddEventHandler('house:updatespawns', function(info, hid)
    local src = source
    local table = info
    local house_id = hid
    exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE house_id = ?', {hid}, function(result)
        exports.ghmattimysql:execute("UPDATE __housedata SET `data` = @data WHERE `house_id` = @house_id", {
            ['@data'] = json.encode(table),
            ['@house_id'] = house_id
        })
        TriggerClientEvent('UpdateCurrentHouseSpawns', src, hid, json.encode(info))
    end)
end)


RegisterServerEvent('housing:attemptsale')
AddEventHandler('housing:attemptsale', function(cid,price,house_id,house_model, storage, clothing,garages)
    TriggerClientEvent('housing:findsalecid', -1, cid, price, house_id, house_model, storage, clothing, garages)
end)

RegisterServerEvent('house:purchasehouse')
AddEventHandler('house:purchasehouse', function(cid,house_id,house_model,upfront,price,housename,garages)
    local src = source
    exports.ghmattimysql:execute('SELECT `housename` FROM __housedata WHERE `housename`= ?', {housename}, function(data)
        local penis = data[1].cid
        if penis == nil then
            exports.ghmattimysql:execute("UPDATE __housedata SET `cid` = @cid, `upfront` = @upfront, `housename` = @housename, `garages` = @garages, `house_model` = @house_model, `overall` = @overall, `payments` = @payments, `due` =@due, `days` = @days WHERE `house_id` = @house_id", {
                ['@cid'] = cid,
                ['@upfront'] = upfront,
                ['@housename'] = housename,
                ['@garages'] = json.encode(garages),
                ['@house_model'] = house_model,
                ['@overall'] = price,
                ['@payments'] = "14",
                ['@house_id'] = house_id,
                ['@days'] = repayTime,
                ['@due'] = price - upfront
            })
            TriggerClientEvent('DoLongHudText', src, "Congratulations, you now own " .. housename .. "!", 6)
        else
            TriggerClientEvent("DoLongHudText", src, "This house is already sold...", 2)
        end
    end)
end)


RegisterServerEvent('housing:requestSpawnTable')
AddEventHandler('housing:requestSpawnTable', function(table, id, house_name)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE `house_id` = @house_id', { ['@house_id'] = id }, function(result)
        if result[1] ~= nil then
            TriggerClientEvent('UpdateCurrentHouseSpawns', src, id, result[1].data)
        else
            exports.ghmattimysql:execute("INSERT INTO __housedata (data, house_id, housename) VALUES (@data, @house_id, @housename)", {
            ['@house_id'] = id,
            ['@data'] = json.encode(table),
            ['@housename'] = house_name
            })
        end
    end)
end)


RegisterServerEvent('housing:getGarage')
AddEventHandler('housing:getGarage', function(house_id, house_model, cid)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM __housekeys WHERE `house_id`= ? AND `house_model`= ?  AND `cid` = ?', {house_id, house_model, cid}, function(returnData)
        if returnData[1] ~= nil then
            TriggerClientEvent('sendGarges', src, json.decode(returnData[1].garages), returnData[1].house_id, returnData[1].housename)
        end
    end)
    exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE `house_id`= ? AND `house_model`= ?  AND `cid` = ?', {house_id, house_model, cid}, function(penis)
        if penis[1] ~= nil then
            TriggerClientEvent('sendGarges', src, json.decode(penis[1].garages),penis[1].house_id, penis[1].housename)
        end
    end)
  
end)


RegisterServerEvent('house:enterhouse')
AddEventHandler('house:enterhouse', function(cid,isRealEstate,house_id,house_model,furniture)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE `house_id`= ?', {house_id}, function(data)
        if isRealEstate == true then
            if json.encode(data) == '[]' then
                TriggerClientEvent('house:entersuccess', src, house_id, house_model, furniture)
            else
                for k, v in pairs(data) do
                    TriggerClientEvent('house:entersuccess', src, house_id, house_model, data[1].furniture)
                    TriggerClientEvent('UpdateCurrentHouseSpawns', src, house_id, data[1].data, json.decode(data[1].garages), data[1].housename)
                end
            end
        else
            if data[1].force_locked ~= "locked" and data[1].status ~= "locked" then
                if json.encode(data) == '[]' then
                    TriggerClientEvent('house:entersuccess', src, house_id, house_model, furniture)
                else
                    for k, v in pairs(data) do
                        TriggerClientEvent('house:entersuccess', src, house_id, house_model, data[1].furniture)
                        TriggerClientEvent('UpdateCurrentHouseSpawns', src, house_id, data[1].data, json.decode(data[1].garages), data[1].housename)
                    end
                end
            end
        end
    end)
    print(house_id)
    print(house_model)
    exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE `house_id`= ?', {house_id}, function(data3)
        if data3[1].force_locked ~= "locked" then
            exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE `cid`= ?', {cid}, function(data)
                for k, v in pairs(data) do
                    if v.house_id == house_id then
                        TriggerClientEvent('house:entersuccess', src, house_id, house_model, data[1].furniture)
                        TriggerClientEvent('UpdateCurrentHouseSpawns', src, house_id, data[1].data, json.decode(data[1].garages), data[1].housename)
                        break
                    end
                end
                exports.ghmattimysql:execute('SELECT * FROM __housekeys WHERE `cid`= ?', {cid}, function(returnData)
                    for k, v in pairs(returnData) do
                        if v.house_id == house_id then
                            exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE `house_id`= ?', {v.house_id}, function(penis)
                                for k, v in pairs(penis) do
                                    if v.house_id == house_id then
                                        TriggerClientEvent('house:entersuccess', src, house_id, house_model, penis[1].furniture)
                                        TriggerClientEvent('UpdateCurrentHouseSpawns', src, house_id, penis[1].data, json.decode(penis[1].garages), penis[1].housename)
                                        TriggerClientEvent('DoLongHudText', src, "Entering shared property", 1)
                                    end
                                end
                            end)
                        end
                    end
                end)
            end)
        else
            TriggerClientEvent('DoLongHudText', src, "This house is forced locked by a realtor", 2)
            return
        end
    end)
end)

RegisterServerEvent('house:givekey')
AddEventHandler('house:givekey', function(house_id,house_model,house_name,cid, firstname, lastname, target)
    local src = source
    local player = exports['wrp-base']:GetCurrentCharacterInfo(target)
    exports.ghmattimysql:execute('SELECT `house_id` FROM __housekeys WHERE `cid`= ?', {cid}, function(data)
        local penis = json.encode(data)
        if penis == "[]" then
            exports.ghmattimysql:execute('SELECT `garages` FROM __housedata WHERE `house_id`= ?', {house_id}, function(test)
                local garages = test[1].garages
                local name = firstname .. " " .. lastname
                exports.ghmattimysql:execute('INSERT INTO __housekeys(cid, house_id, house_model, housename, name, garages) VALUES(?, ?, ?, ?, ?, ?)', {player.id, house_id, house_model, house_name, player.first_name .. " " .. player.last_name, garages})
                TriggerClientEvent('DoLongHudText', target, "You have received keys to " .. house_name .. ".", 6)
                TriggerClientEvent('DoLongHudText', src, "You gave " .. player.first_name .. " " .. player.last_name .. " keys to " .. house_name .. ".", 1)
            end)
        else
            TriggerClientEvent("DoLongHudText", src, "This player already has keys to " .. house_name .. ".", 2)
        end
    end)
end)

RegisterServerEvent('house:retrieveKeys')
AddEventHandler('house:retrieveKeys', function(house_id, house_model)
    local src = source
    local shared = {}
    exports.ghmattimysql:execute('SELECT * FROM __housekeys WHERE `house_id`= ?', {house_id}, function(data)
        for k, v in pairs(data) do
            if v ~= nil then
                if v.house_id == house_id then
                    local random = math.random(1111,9999)
                    shared[random] = {}
                    local name = v.name
                    table.insert(shared[random], {["sharedHouseName"] = v.housename, ["sharedId"] = v.cid, ["sharedName"] = name})
                    TriggerClientEvent('house:returnKeys', src, shared)
                end
            end
        end
    end)
end)

RegisterServerEvent("housing:unlockRE")
AddEventHandler("housing:unlockRE", function(house_id, house_model)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE house_id = ?', {house_id}, function(result)
        local address = result[1].housename
        if result[1].force_locked == "unlocked" then
            exports.ghmattimysql:execute("UPDATE __housedata SET `force_locked` = @force_locked WHERE `house_id` = @house_id ", {
                ['@force_locked'] = "locked",
                ['@house_id'] = house_id
            })
            TriggerClientEvent("DoLongHudText", src, "Property " ..address.. " has been locked", 1)
        elseif result[1].force_locked == "locked" then
            exports.ghmattimysql:execute("UPDATE __housedata SET `force_locked` = @force_locked WHERE `house_id` = @house_id ", {
                ['@force_locked'] = "unlocked",
                ['@house_id'] = house_id
            })
            TriggerClientEvent("DoLongHudText", src, "Property " ..address.. " has been unlocked", 2)
        end
    end)
end)

RegisterServerEvent("housing:unlock")
AddEventHandler("housing:unlock", function(house_id, house_model)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE house_id = ?', {house_id}, function(result)
        local address = result[1].housename
        if result[1].status == "unlocked" then
            exports.ghmattimysql:execute("UPDATE __housedata SET `status` = @status WHERE `house_id` = @house_id ", {
                ['@status'] = "locked",
                ['@house_id'] = house_id
            })
            TriggerClientEvent("DoLongHudText", src, "The Property " ..address.. " has been locked", 1)
        elseif result[1].status == "locked" then                                                                    
            exports.ghmattimysql:execute("UPDATE __housedata SET `status` = @status WHERE `house_id` = @house_id ", {
                ['@status'] = "unlocked",
                ['@house_id'] = house_id
            })
            TriggerClientEvent("DoLongHudText", src, "The Property " ..address.. " has been unlocked", 2)
        end
    end)
end)

RegisterServerEvent('house:removeKey')
AddEventHandler('house:removeKey', function(house_id, house_model, target)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM __housekeys WHERE house_id = ? AND cid = ?', {house_id, target}, function(data)
        exports.ghmattimysql:execute('DELETE FROM __housekeys WHERE `house_id`= ? AND `house_model`= ? AND `cid`= ?', {house_id, house_model, target})
        TriggerClientEvent('DoLongHudText', src, "You removed " .. data[1].name .. "'s keys.")
        if target ~= nil then
            TriggerClientEvent('DoLongHudText', target, "Your keys were removed by the home owner.", 2)
        end
    end)
end)

RegisterServerEvent("houses:removeSharedKey")
AddEventHandler("houses:removeSharedKey", function(house_id, cid)
    local src = source
    exports.ghmattimysql:execute('DELETE FROM __housekeys WHERE `house_id`= ? AND `cid`= ?', {house_id, cid})
    TriggerClientEvent('DoLongHudText', src, "You have removed your shared key.", 2)

end)

RegisterServerEvent('CheckFurniture')
AddEventHandler('CheckFurniture', function(house_id, house_model)
    local src = source
    exports.ghmattimysql:execute('SELECT `furniture` FROM __housedata WHERE `house_id`= ? AND `house_model`= ?', {house_id, house_model}, function(data)
        TriggerClientEvent('openFurnitureConfirm', src, house_id, house_model, data[1])
    end)
end) 


RegisterServerEvent("house:enterhousebackdoor")
AddEventHandler("house:enterhousebackdoor", function(house_id, house_model)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE house_id = ?', {house_id}, function(result)
        TriggerClientEvent('house:entersuccess', src, house_id, house_model, result[1].furniture)
    end)
end)


RegisterServerEvent('house:evictHouse')
AddEventHandler('house:evictHouse', function(hid, model)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE house_id = ? AND house_model = ?', {hid, model}, function(result)
        if result[1] ~= nil then
            TriggerClientEvent("DoLongHudText", src, result[1].house_name.. " has been deleted", 2)
            exports.ghmattimysql:execute("DELETE FROM __housedata WHERE house_id = @house_id AND house_model = @house_model", {['house_id'] = hid, ['house_model'] = model})
        end
    end)
end)

RegisterServerEvent("houses:PropertyOutstanding")
AddEventHandler("houses:PropertyOutstanding", function()
    local src = source
    TriggerClientEvent("housing:info:realtor", src, "PropertyOutstanding")
end)

RegisterServerEvent("house:PropertyOutstanding")
AddEventHandler("house:PropertyOutstanding", function(house_id, house_model)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE house_id = ? AND house_model = ?', {house_id, house_model}, function(result)
        if result[1] ~= nil then
            TriggerClientEvent("DoLongHudText", src, "The Property Outstanding Balance is $" ..result[1].overall - result[1].due.. " with a pending payment of $" ..math.floor(result[1].due/result[1].payments))
        end
    end)    
end)

RegisterServerEvent("housing:garagesSET")
AddEventHandler("housing:garagesSET", function(garages, house_id)
    local src = source
    exports.ghmattimysql:execute("UPDATE __housedata SET `garages` = @garages WHERE `house_id` = @house_id", {
        ['@garages'] = json.encode(garages),
        ['@house_id'] = house_id
    })
    
        -- TriggerClientEvent('UpdateCurrentHouseSpawns', src, hid, json.encode(info))  
end)


RegisterServerEvent("house:dopayment")
AddEventHandler("house:dopayment", function(house_id, house_model, cash)
    local src = source
        exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE house_id = ? AND house_model = ?', {house_id, house_model}, function(result)
            if result[1] ~= nil then
                local amountdue = math.floor(result[1].due/result[1].payments)
                if result[1].can_pay ~= "false" then
                    if result[1].due ~= tonumber(0) then
                        if cash >= amountdue then
                            TriggerClientEvent("wrp-ac:removeban", src, amountdue)
                            exports.ghmattimysql:execute("UPDATE __housedata SET `payments` = @payments, `due` = @due, `days` = @days, `can_pay` = @can_pay WHERE `house_id` = @house_id AND `house_model` = @house_model", {
                                ['@payments'] = result[1].payments - 1,
                                ['@due'] = result[1].due - amountdue,
                                ['@house_id'] = house_id,
                                ['@days'] = repayTime,
                                ['@can_pay'] = "false",
                                ['@house_model'] = house_model
                            })
                            local paymentsleft = result[1].payments - 1
                            Citizen.Wait(5000)
                            TriggerClientEvent("DoLongHudText", src, "Your still have " ..paymentsleft.. " payments left and a existing mortage of $" ..result[1].due - amountdue, 1)
                        else
                            TriggerClientEvent("DoLongHudText", src, "You cant afford the payment of $" ..amountdue, 2)
                        end
                     
                    else
                        Citizen.Wait(10000)
                        TriggerClientEvent("DoLongHudText", src, "Your house is fully paid off!")
                    end
                else
                    TriggerClientEvent("DoLongHudText", src, "You just recently paid your mortgage payment. You need to wait a week", 2)
                end
            end
        end)
   
end)

function updateFinance()
    exports.ghmattimysql:execute('SELECT days, house_id FROM __housedata WHERE days > @days', {
        ["@days"] = 0
    }, function(result)
        for i=1, #result do
            local days = result[i].days
            local house_id = result[i].id
            local newTimer = days - 10
            if days ~= nil then
                exports.ghmattimysql:execute('UPDATE __housedata SET days = @days WHERE house_id = @house_id', {
                    ['@house_id'] = house_id,
                    ['@days'] = newTimer
                })
            end
            if days < 100 then
                exports.ghmattimysql:execute("UPDATE __housedata SET `can_pay` = @can_pay WHERE `house_id` = @house_id ", {
                    ['@can_pay'] = "true",
                    ['@house_id'] = house_id
                })
            end
        end
    end)
    SetTimeout(timer, updateFinance)
end
SetTimeout(timer, updateFinance)


RegisterServerEvent('housing:nearHouses')
AddEventHandler('housing:nearHouses', function(id)
    exports.ghmattimysql:execute('SELECT * FROM houses_ __housedata house_id = @house_id', {['house_id'] = id}, function(result)
        TriggerClientEvent("clrp-housing:givenearhouse", -1, result)
    end)
 
end)