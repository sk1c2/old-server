local motels = {}
local houses = {}

RegisterServerEvent('hotel:createRoom')
AddEventHandler('hotel:createRoom', function(cid)
    houses = {}
    motels = {}
    local src = source
    local pussy = 0
    local number = math.random(1,4)
    local asshole = {}
    exports.ghmattimysql:execute("SELECT * FROM __housing WHERE cid= ?", {cid}, function(data)
        asshole = data
        if data[1] == nil then
            table.insert(motels, {owner = cid, roomnumber = number})
            exports.ghmattimysql:execute("SELECT * FROM __housedata WHERE cid= ?", {cid}, function(chicken)
                for k, r in pairs(chicken) do
                    if r ~= nil then
                        if r.housename ~= nil then
                            local random = math.random(1111,9999)
                            houses[random] = {}
                            table.insert(houses[random], {["house_name"] = r.housename, ["house_model"] = r.house_model, ["house_id"] = r.house_id})
                        end
                    end
                end
                for k, v in pairs(motels) do
                    if v.owner == cid then
                        pussy = v.roomnumber
                    end
                end
                print(pussy)
                TriggerClientEvent('hotel:createRoom1', src, pussy, 1, houses)
                TriggerClientEvent('hotel:SetID', src, cid)
            end)
        else
            
            exports.ghmattimysql:execute("SELECT * FROM __housedata WHERE cid= ?", {cid}, function(chicken)
                for k, v in pairs(chicken) do
                    if v ~= nil then
                        if v.housename ~= nil then
                            local random = math.random(1111,9999)
                            houses[random] = {}
                            table.insert(houses[random], {["house_name"] = v.housename, ["house_model"] = v.house_model, ["house_id"] = v.house_id})
                            TriggerClientEvent('hotel:createRoom1', src, asshole[1].roomNumber, asshole[1].roomType, houses)
                            TriggerClientEvent('hotel:SetID', src, cid)
                            return
                        end
                    end
                end
                TriggerClientEvent('hotel:createRoom1', src, asshole[1].roomNumber, asshole[1].roomType, 0)
                TriggerClientEvent('hotel:SetID', src, cid)
            end)
        end
    end)
end)

RegisterServerEvent('hotel:updatelocks')
AddEventHandler('hotel:updatelocks', function(status)
    local src = source
    TriggerClientEvent('hotel:updateLockStatus', src, status)
end)

RegisterServerEvent('hotel:clearStates')
AddEventHandler('hotel:clearStates', function(cid)
    for k, v in pairs(motels) do
        if v.owner == cid then
            table.remove(motels, k)
        end
    end
end)

RegisterServerEvent('hotel:upgradeApartment')
AddEventHandler('hotel:upgradeApartment', function(cid, roomType, roomNumber)
    local src = source
    for k, v in pairs(motels) do
        if v.owner == cid then
            table.remove(motels, k)
        end
    end
    if roomType == 1 then
        exports.ghmattimysql:execute('INSERT INTO __housing(cid, roomType, roomNumber) VALUES(?, ?, ?)', {cid, 2, roomNumber})
        TriggerClientEvent('newRoomType', src, 2)
        TriggerClientEvent('DoLongHudText', src, "Congratulations, your new Integrity Apartment is available with Room Number: [" .. tonumber(roomNumber) .. "]")
    else
        TriggerClientEvent('DoLongHudText', src, "You already have an Integrity Apartment with the Room Number: [" .. tonumber(roomNumber) .. "]")
    end
end)