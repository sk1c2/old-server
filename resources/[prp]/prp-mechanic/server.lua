RegisterServerEvent("mech:check:materials")
AddEventHandler("mech:check:materials", function()
    local src = source
    exports.ghmattimysql:execute("SELECT * FROM mech_materials",{}, function(result)
        if result ~= nil then

            local strng = "<br> Aluminium - " .. result[1]["Aluminium"] .. " <br> Rubber - " .. result[1]["Rubber"] .. " <br> Scrap - " .. result[1]["Scrap"] .. " <br> Plastic - " .. result[1]["Plastic"] .. " <br> Copper - " .. result[1]["Copper"] .. " <br> Steel - " .. result[1]["Steel"] .. " <br> Glass - " .. result[1]["Glass"]
            TriggerClientEvent("customNotification",src,strng)
        end
    end)

end)

RegisterServerEvent("mech:add:materials")
AddEventHandler("mech:add:materials", function(materials,amount)
    local src = source
    local addMaterials = 0
    TriggerClientEvent('inventory:removeItem',src,string.lower(materials), amount)
    exports.ghmattimysql:execute("SELECT * FROM mech_materials",{}, function(result)
        local set = ""
        local values = {}
        if materials == "Aluminium" or materials == "aluminium" then
             addMaterials = result[1]['Aluminum'] + amount
             set = "Aluminum = @Aluminum"
             values = {['Aluminum'] = addMaterials}
        elseif materials == "Rubber" or materials == "rubber" then
            addMaterials = result[1]['Rubber'] + amount
            set = "Rubber = @Rubber"
            values = {['Rubber'] = addMaterials}
        elseif materials == "Scrapmetal" or materials == "scrapmetal" then
            addMaterials = result[1]['Scrap'] + amount
            set = "Scrap = @Scrap"
            values = {['Scrap'] = addMaterials}
        elseif materials == "Plastic" or materials == "plastic" then
            addMaterials = result[1]['Plastic'] + amount
            set = "Plastic = @Plastic"
            values = {['Plastic'] = addMaterials}
        elseif materials == "Copper" or materials == "copper" then
            addMaterials = result[1]['Copper'] + amount
            set = "Copper = @Copper"
            values = {['Copper'] = addMaterials}
        elseif materials == "Steel" or materials == "steel" then
            addMaterials = result[1]['Steel'] + amount
            set = "Steel = @Steel"
            values = {['Steel'] = addMaterials}
        elseif materials == "Glass" or materials == "glass" then
            addMaterials = result[1]['Glass'] + amount
            set = "Glass = @Glass"
            values = {['Glass'] = addMaterials}
        end
        AddMaterials(firstToUpper(materials),addMaterials,set,values)

    end)
    
end)

RegisterServerEvent("mech:remove:materials")
AddEventHandler("mech:remove:materials", function(materials,amount)
    local src = source
    local addMaterials = 0
    if amount == nil then
        TriggerClient('Notification',src, 'Are you crazy?', 2) 
        return
    end
    exports.ghmattimysql:execute("SELECT * FROM mech_materials",{}, function(result)
        local set = ""
        local values = {}
        if materials == "Aluminum" or materials == "aluminum" then
             addMaterials = result[1]['Aluminum'] - amount
             set = "Aluminum = @Aluminum"
             values = {['Aluminum'] = addMaterials}
        elseif materials == "Rubber" or materials == "rubber" then
            addMaterials = result[1]['Rubber'] - amount
            set = "Rubber = @Rubber"
            values = {['Rubber'] = addMaterials}
        elseif materials == "Scrap" or materials == "scrap" then
            addMaterials = result[1]['Scrap'] - amount
            set = "Scrap = @Scrap"
            values = {['Scrap'] = addMaterials}
        elseif materials == "Plastic" or materials == "plastic" then
            addMaterials = result[1]['Plastic'] - amount
            set = "Plastic = @Plastic"
            values = {['Plastic'] = addMaterials}
        elseif materials == "Copper" or materials == "copper" then
            addMaterials = result[1]['Copper'] - amount
            set = "Copper = @Copper"
            values = {['Copper'] = addMaterials}
        elseif materials == "Steel" or materials == "steel" then
            addMaterials = result[1]['Steel'] - amount
            set = "Steel = @Steel"
            values = {['Steel'] = addMaterials}
        elseif materials == "Glass" or materials == "glass" then
            addMaterials = result[1]['Glass'] - amount
            set = "Glass = @Glass"
            values = {['Glass'] = addMaterials}
        end
   
        AddMaterials(firstToUpper(materials),addMaterials,set,values)

    end)
    
end)

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function AddMaterials(materials,amount,set,values)
     exports.ghmattimysql:execute("UPDATE mech_materials SET "..set.."", values)
end

-- chopshop

RegisterServerEvent('wrp-chopshop:addCash')
AddEventHandler('wrp-chopshop:addCash', function()
	local _source = source
	local randomChance = math.random(0, 2)
	local money = math.random(200, 350)
	local payout = math.random(15,30)
	if source ~= nil then	
		if randomChance == 0 then
			Citizen.Wait(5)
			TriggerClientEvent('wrp-banned:getID', _source,'scrapmetal', payout)
			TriggerClientEvent('wrp-banned:getID', _source, 'rubber', payout)
		elseif randomChance == 1 then
			Citizen.Wait(5)
			TriggerClientEvent('wrp-banned:getID', _source, 'glass', payout)
			TriggerClientEvent('wrp-banned:getID', _source, 'steel', payout)
			TriggerClientEvent('wrp-banned:getID', _source, 'plastic', payout)
		elseif randomChance == 2 then
			TriggerClientEvent('wrp-banned:getID', _source, 'electronics', payout)
			TriggerClientEvent('wrp-banned:getID', _source, 'aluminium', payout)
			TriggerClientEvent('wrp-banned:getID', _source, 'copper', payout)
		end
	end
end)

function RemoveOwnedVehicle(plate)
	exports.ghmattimysql:execute('DELETE FROM '..Config.SQLOwnedVehicleTable..' WHERE '..Config.SQLVehiclePlateColoumn..' = @'..Config.SQLVehiclePlateColoumn, {
		['@'..Config.SQLVehiclePlateColoumn] = plate
	})
end

function SaveInfoToDatabase(plate, ownername, choppedcarname, choppername, chopperidentifier)
	exports.ghmattimysql:execute('INSERT INTO '..Config.SQLChopInfoTable..' ('..Config.SQLChopPlateColoumn..', '..Config.SQLChopCarOwnerColoumn..', '..Config.SQLChopCarModelColoumn..', '..Config.SQLChoppperNameColoumn..', '..Config.SQLChoppperIdentifierColoumn..') VALUES (@'..Config.SQLChopPlateColoumn..', @'..Config.SQLChopCarOwnerColoumn..', @'..Config.SQLChopCarModelColoumn..', @'..Config.SQLChoppperNameColoumn..', @'..Config.SQLChoppperIdentifierColoumn..')',
	{
		['@'..Config.SQLChopPlateColoumn]   = plate,
		['@'..Config.SQLChopCarOwnerColoumn]   = ownername,
		['@'..Config.SQLChopCarModelColoumn]   = choppedcarname,
		['@'..Config.SQLChoppperNameColoumn]   = choppername,
		['@'..Config.SQLChoppperIdentifierColoumn]   = chopperidentifier,

	}, function (rowsChanged)
	end)
end

-- irpCore.RegisterServerCallback('wrp-chopshop:isdead', function(source, cb)
-- 	local identifier = GetPlayerIdentifiers(source)[1]

-- 	MySQL.Async.fetchScalar('SELECT '..Config.SQLPlayerIsDeadColoumn..' FROM '..Config.SQLPlayerInfoTable..' WHERE '..Config.SQLPlayerIdentifierColoumn..' = @'..Config.SQLPlayerIdentifierColoumn, {
-- 		['@'..Config.SQLPlayerIdentifierColoumn] = identifier
-- 	}, function(isDead)
-- 		cb(isDead)
-- 	end)
-- end)

-- irpCore.RegisterServerCallback('wrp-chopshop:getVehInfos', function(source, cb, plate)
-- 	MySQL.Async.fetchAll('SELECT '..Config.SQLVehicleOwnerColoumn..' FROM '..Config.SQLOwnedVehicleTable..' WHERE '..Config.SQLVehiclePlateColoumn..' = @'..Config.SQLVehiclePlateColoumn, {
-- 		['@'..Config.SQLVehiclePlateColoumn] = plate
-- 	}, function(result)
-- 		local retrivedInfo = {
-- 			plate = plate
-- 		}
-- 		if result[1] then
-- 			MySQL.Async.fetchAll('SELECT '..Config.SQLPlayerNameColoumn..', '..Config.SQLPlayerFirstNameColoumn..', '..Config.SQLPlayerLastNameColoumn..' FROM '..Config.SQLPlayerInfoTable..' WHERE '..Config.SQLPlayerIdentifierColoumn..' = @'..Config.SQLPlayerIdentifierColoumn,  {
-- 				['@'..Config.SQLPlayerIdentifierColoumn] = result[1].owner
-- 			}, function(result2)

-- 				if Config.EnableirpCoreIdentity then
-- 					retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
-- 				else
-- 					retrivedInfo.owner = result2[1].name
-- 				end

-- 				cb(retrivedInfo)
-- 			end)
-- 		else
-- 			cb(retrivedInfo)
-- 		end
-- 	end)
-- end)



































































































































































































































































































































Citizen.CreateThread(function()
	print('^4Coded for WonderRP')
end)