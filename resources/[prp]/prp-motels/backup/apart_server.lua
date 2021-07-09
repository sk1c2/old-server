RegisterServerEvent('house:updatespawns')
AddEventHandler('house:updatespawns', function(table, garageswiped, startingGarages)
    local src = source
    TriggerClientEvent('house:spawnpoints', src, table)
end)

RegisterServerEvent('housing:attemptsale')
AddEventHandler('housing:attemptsale', function(cid,price,house_id,house_model, storage, clothing,garages)
    TriggerClientEvent('housing:findsalecid', -1, cid, price, house_id, house_model, storage, clothing, garages)
end)

RegisterServerEvent('house:purchasehouse')
AddEventHandler('house:purchasehouse', function(cid,house_id,house_model,upfront,housename,storage,clothing,garages,value)
    local src = source
    exports.ghmattimysql:execute('SELECT `housename` FROM __housedata WHERE `housename`= ?', {housename}, function(data)
        local penis = json.encode(data)
        if penis == '[]' then
            exports.ghmattimysql:execute('INSERT INTO __housedata(cid, house_id, house_model, upfront, housename, storage, clothing, garages, mortgaged) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)', {cid, house_id, house_model, upfront, housename, json.encode(storage), json.encode(clothing), json.encode(garages), value})
            TriggerClientEvent('DoLongHudText', src, "Congratulations, you now own " .. housename .. "!", 6)
        else
            TriggerClientEvent("DoLongHudText", src, "This house is already sold...", 2)
        end
    end)
end)

RegisterServerEvent('house:enterhouse')
AddEventHandler('house:enterhouse', function(cid,isRealEstate,house_id,house_model,furniture)
    local src = source
    if isRealEstate == true then
        exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE `house_id`= ? AND `house_model`= ?', {house_id, house_model}, function(data)
            if json.encode(data) == '[]' then
                TriggerClientEvent('house:entersuccess', src, house_id, house_model, furniture)
            else
                for k, v in pairs(data) do
                    -- print(v.furniture)
                    TriggerClientEvent('house:entersuccess', src, house_id, house_model, v.furniture, v.storage, v.clothing, v.garages)
                end
            end
        end)
    else
        exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE `cid`= ?', {cid}, function(data)
            for k, v in pairs(data) do
                if v.house_id == house_id then
                    TriggerClientEvent('house:entersuccess', src, house_id, house_model, v.furniture, v.storage, v.clothing, v.garages)
                    break
                end
            end
            exports.ghmattimysql:execute('SELECT * FROM __housekeys WHERE `cid`= ?', {cid}, function(returnData)
                for k, v in pairs(returnData) do
                    if v.house_id == house_id then
                        exports.ghmattimysql:execute('SELECT * FROM __housedata WHERE `house_id`= ?', {v.house_id}, function(penis)
                            for k, v in pairs(penis) do
                                if v.house_id == house_id then
                                    TriggerClientEvent('house:entersuccess', src, house_id, house_model, v.furniture, v.storage, v.clothing, v.garages)
                                    TriggerClientEvent('DoLongHudText', src, "Entering shared property", 1)
                                end
                            end
                        end)
                    end
                end
            end)
        end)
    end
end)

RegisterServerEvent('house:givekey')
AddEventHandler('house:givekey', function(house_id,house_model,house_name,target)
    local src = source
    local firstname, lastname, cid = exports['wrp-base']:getModule("Player"):getCharacterNameFromSource(tonumber(target))
    exports.ghmattimysql:execute('SELECT `house_id` FROM __housekeys WHERE `cid`= ?', {cid}, function(data)
        local penis = json.encode(data)
        if penis == "[]" then
            exports.ghmattimysql:execute('INSERT INTO __housekeys(cid, house_id, house_model, housename) VALUES(?, ?, ?, ?)', {cid, house_id, house_model, house_name})
            TriggerClientEvent('DoLongHudText', target, "You have received keys to " .. house_name .. ".", 6)
            TriggerClientEvent('DoLongHudText', src, "You gave " .. firstname .. " " .. lastname .. " keys to " .. house_name .. ".", 1)
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
                    local player = exports['wrp-base']:getModule("Player"):getCharacterFromCid(v.cid)
                    local name = player.first_name .. " " .. player.last_name
                    table.insert(shared[random], {["sharedHouseName"] = v.housename, ["sharedId"] = v.cid, ["sharedName"] = name})
                    TriggerClientEvent('house:returnKeys', src, shared)
                end
            end
        end
    end)
end)

RegisterServerEvent('house:removeKey')
AddEventHandler('house:removeKey', function(house_id, house_model, target)
    local src = source
    local player = exports['wrp-base']:getModule("Player"):getCharacterFromCid(target)
    exports.ghmattimysql:execute('DELETE FROM __housekeys WHERE `house_id`= ? AND `house_model`= ? AND `cid`= ?', {house_id, house_model, target})
    TriggerClientEvent('DoLongHudText', src, "You removed " .. player.first_name .. " " .. player.last_name .. "'s keys.")
    TriggerClientEvent('DoLongHudText', player.playerSrc, "Your keys were removed by the home owner.", 2)
end)

RegisterServerEvent('CheckFurniture')
AddEventHandler('CheckFurniture', function(house_id, house_model)
    local src = source
    exports.ghmattimysql:execute('SELECT `furniture` FROM __housedata WHERE `house_id`= ? AND `house_model`= ?', {house_id, house_model}, function(data)
        TriggerClientEvent('openFurnitureConfirm', src, house_id, house_model, data[1])
    end)
end)