
local DontShowPoundCarsInGarage = true


RegisterServerEvent("garages:CheckGarageForVeh")
AddEventHandler("garages:CheckGarageForVeh", function(cid)
    local src = source
	-- local player = exports['prp-base']:GetCurrentCharacterInfo(src)
	exports.ghmattimysql:execute('SELECT * FROM __vehicles WHERE cid = ?', {cid}, function(vehicles)
		TriggerClientEvent('phone:Garage', src, vehicles)
    end)
end)


RegisterServerEvent('garage:getVehicles')
AddEventHandler('garage:getVehicles', function(cid)
	local source = source
	local VEHICLES = {}
	if DontShowPoundCarsInGarage then
		exports.ghmattimysql:execute('SELECT `vehicle`, `body_damage`, `engine_damage`, `id`, `name`, `state`, `garage`, `plate` FROM __vehicles WHERE `cid` = @cid', {
			['@cid']  = cid,
			['@state'] = 'In'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				local body = v.body_damage
				local engine = v.engine_damage
				table.insert(VEHICLES, {vehicle = vehicle, id = v.id, name = v.name, state = v.state, garage = v.garage, plate = v.plate, body_damage = v.body_damage, engine_damage = v.engine_damage})
			end
			TriggerClientEvent('garages:getVehicles', source, VEHICLES)
			--print(json.encode(VEHICLES))
		end)
	else
		exports.ghmattimysql:execute('SELECT `vehicle`, `body_damage`, `engine_damage`, `id`, `state`, `garage`, `plate` FROM __vehicles WHERE `cid` = @cid', {
			['@cid']  = cid,
			['@state'] = 'Out',
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				local body = v.body_damage
				local engine = v.engine_damage
				table.insert(VEHICLES, {vehicle = vehicle, id = v.id, state = v.state, garage = v.garage, plate = v.plate})
			end
			TriggerClientEvent('garages:getVehicles', source, VEHICLES)
			--print(json.encode(VEHICLES))
		end)
	end
end)


RegisterServerEvent("garages:SetVehIn")
AddEventHandler("garages:SetVehIn",function(plate, garage, fuelvalue, enginehealth, bodyhealth)
	local src = source
	exports.ghmattimysql:execute("UPDATE __vehicles SET `state` = @state, `garage` = @garage, `fuel` = @fuel, `engine_damage` = @engine_damage, `body_damage` = @body_damage WHERE `plate` = @plate", {
		['garage'] = garage, 
		['state'] = "In", 
		['plate'] = plate,
		['fuel'] = fuelvalue,
		['engine_damage'] = enginehealth,
		['body_damage'] = bodyhealth
	})
end)

RegisterServerEvent('garages:CheckForSpawnVeh')
AddEventHandler('garages:CheckForSpawnVeh', function(veh_id, garageCost, current_used_garage, cid)
	local src = source
	-- local player = exports['prp-base']:GetCurrentCharacterInfo(src)
	exports.ghmattimysql:execute('SELECT `cash` FROM __characters WHERE id = ?', {cid}, function(result)
		if result[1].cash >= garageCost then
			if garageCost >= 1 then
				TriggerClientEvent("prp-base:getdata", src, garageCost)
			else
				-- TriggerEvent("prp-ac:removeban", src, 0)
			end
			local veh_id = veh_id
			exports.ghmattimysql:execute('SELECT * FROM __vehicles WHERE id = ?', {veh_id}, function(result)
				if current_used_garage == result[1].garage then
					name = result[1].name
					plate = result[1].plate
					vehicle = result[1].vehicle
					state = result[1].state
					fuel = result[1].fuel
					enginehealth_car = result[1].engine_damage
					bodyhealth_car = result[1].body_damage
					exports.ghmattimysql:execute('SELECT `state` FROM __vehicles WHERE plate = ?', {plate}, function(vehicles)
						if tostring(vehicles[1].state) ~= 'Out' then
							-- if (tonumber(vehicles[1].financetimer) ~= 0 and tonumber(vehicles[1].finance) ~=0) then
								TriggerClientEvent('garages:SpawnVehicle', src, name, plate, vehicle, state, fuel, enginehealth_car, bodyhealth_car)
							-- else
							-- 	TriggerClientEvent('DoLongHudText', src, 'Your vehicle finance bill is due, pay it and you can have your car back, idiot!')
							-- end
						else 
							TriggerClientEvent('DoLongHudText', src, 'You cannot pull the same car out twice!')
						end
					end)
				end
			end)
		else
			TriggerClientEvent('DoLongHudText', src, 'You need $' .. garageCost, 2)
		end
	end)
end)

RegisterServerEvent('garages:SetVehOut')
AddEventHandler('garages:SetVehOut', function(vehicle, plate)
	local src = source
	exports.ghmattimysql:execute("UPDATE __vehicles SET `state` = @state WHERE `plate` = @plate", {
		['state'] = "Out", 
		['plate'] = plate
	})
end)

RegisterServerEvent('garages:SetVehIngarage')
AddEventHandler('garages:SetVehIngarage', function(plate)
	local src = source
	exports.ghmattimysql:execute('SELECT * FROM __vehicles WHERE plate = ?', {plate}, function(result)
		if result[1] ~= nil then
			exports.ghmattimysql:execute("UPDATE __vehicles SET `state` = @state WHERE `plate` = @plate", {
				['state'] = "In", 
				['plate'] = plate
			})
		end
	end)
end)

RegisterServerEvent("garages:CheckForVeh")
AddEventHandler('garages:CheckForVeh', function(cid)
	local src = source
	-- local player = exports['prp-base']:GetCurrentCharacterInfo(src)
	-- exports.ghmattimysql:execute('SELECT `plate` FROM __vehicles WHERE cid = ?', {cid}, function(result)
	exports.ghmattimysql:execute('SELECT * FROM __vehicles WHERE `cid` = @cid AND `state` = @state', {
		['@cid'] = cid, 
		['@state'] = "Out" or "In"
	}, function(result)
		if result[1] ~= nil then
			local plates = result[1].plate
			TriggerClientEvent('garages:StoreVehicle', src, plates)
		else
			TriggerClientEvent('DoLongHudText', src, 'You dont own this car')
		end
		
	end)
end)

RegisterServerEvent('imp:ImpoundCar')
AddEventHandler('imp:ImpoundCar', function(plate)
	exports.ghmattimysql:execute("UPDATE __vehicles SET `garage` = @garage, `state` = @state WHERE `plate` = @plate", {
		['garage'] = 'Impound Lot', 
		['state'] = 'Normal Impound', 
		['plate'] = plate
	})
end)

AddEventHandler('onResourceStart', function(resource)
	if GetCurrentResourceName() == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			exports.ghmattimysql:execute("UPDATE __vehicles SET `state` = @state", {
				['state'] = 'In',  
			})
		end)
	end
end)
