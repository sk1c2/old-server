local call_index = 0

RegisterServerEvent("prp-mdt:Open")
AddEventHandler("prp-mdt:Open", function(cid)
	local usource = source
	exports.ghmattimysql:execute('SELECT * FROM __characters WHERE id = ?', {cid}, function(result)
		local job = result[1].job
    	if job == 'Police' then
    		MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_reports` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(reports)
    			for r = 1, #reports do
    				reports[r].charges = json.decode(reports[r].charges)
    			end
    			MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_warrants` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(warrants)
    				for w = 1, #warrants do
    					warrants[w].charges = json.decode(warrants[w].charges)
    				end

    				local officer = GetCharacterName(usource)
					TriggerClientEvent('prp-mdt:toggleVisibilty', usource, reports, warrants, officer, job)
    			end)
    		end)
		elseif job == 'DOJ' then
			MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_reports` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(reports)
    			for r = 1, #reports do
    				reports[r].charges = json.decode(reports[r].charges)
    			end
    			MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_warrants` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(warrants)
    				for w = 1, #warrants do
    					warrants[w].charges = json.decode(warrants[w].charges)
    				end

    				local officer = GetCharacterName(usource)
					TriggerClientEvent('prp-mdt:toggleVisibilty', usource, reports, warrants, officer, job)
    			end)
    		end)
		elseif job == 'FIB' then
			MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_reports` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(reports)
    			for r = 1, #reports do
    				reports[r].charges = json.decode(reports[r].charges)
    			end
    			MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_warrants` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(warrants)
    				for w = 1, #warrants do
    					warrants[w].charges = json.decode(warrants[w].charges)
    				end

    				local officer = GetCharacterName(usource)
					TriggerClientEvent('prp-mdt:toggleVisibilty', usource, reports, warrants, officer, job)
    			end)
    		end)
		end
	end)
end)

RegisterServerEvent("prp-mdt:getOffensesAndOfficer")
AddEventHandler("prp-mdt:getOffensesAndOfficer", function()
	local usource = source
	local charges = {}
	MySQL.Async.fetchAll('SELECT * FROM fine_types', {
	}, function(fines)
		for j = 1, #fines do
			if fines[j].category == 0 or fines[j].category == 1 or fines[j].category == 2 or fines[j].category == 3 then
				table.insert(charges, fines[j])
			end
		end

		local officer = GetCharacterName(usource)

		TriggerClientEvent("prp-mdt:returnOffensesAndOfficer", usource, charges, officer)
	end)
end)

RegisterServerEvent("prp-mdt:checkloginsql")
AddEventHandler("prp-mdt:checkloginsql", function(username , password , cid)
	local usource = source
	local mdtusers = MySQL.Sync.fetchAll('SELECT * FROM `__mdtusers` WHERE `uid` = @cid ', {
		['@cid'] = cid
	})
	if(mdtusers[1]) then
		if(mdtusers[1].username == username and mdtusers[1].password == password) then
		TriggerClientEvent("prp-mdt:openmdt" , usource)
		else
			TriggerClientEvent('DoLongHudText', usource, 'Invailed Username / Password!', 2)
		end
	end
	
	
end)

RegisterServerEvent('prp-mdt:register')
AddEventHandler('prp-mdt:register', function(username , password , cid)
	local usource = source
	local checkmdtusers = MySQL.Sync.fetchAll('SELECT * FROM `__mdtusers` WHERE `uid` = @cid ', {
		['@cid'] = cid
	})
	if(checkmdtusers[1]) then
		return TriggerClientEvent('DoLongHudText', usource, 'You are already have account!', 2)
	end

	local registeruser = 	MySQL.Async.insert('INSERT INTO `__mdtusers` (`uid`, `username`, `password`) VALUES (@uid , @username , @password)', {
		['@uid'] = cid,
		['@username'] = username,
		['@password'] = password,
	})
	 TriggerClientEvent('DoLongHudText', usource, 'Your account has been created!', 3)
TriggerClientEvent("prp-mdt:movepagetologin" , usource)

	
	
end)


RegisterServerEvent('prp-mdt:updatepass')
AddEventHandler('prp-mdt:updatepass', function(password , cid)
	local usource = source
	print(password)

	local checkmdtusers = MySQL.Sync.fetchAll('SELECT * FROM `__mdtusers` WHERE `uid` = @cid ', {
		['@cid'] = cid
	})
	if(checkmdtusers[1]) then
		MySQL.Async.execute('UPDATE `__mdtusers` SET `password` = @password WHERE `uid` = @id', {
			['@id'] = cid,
			['@password'] = password
		})
	end
TriggerClientEvent("prp-mdt:movepagetologin" , usource)
end)




RegisterServerEvent("prp-mdt:performOffenderSearch")
AddEventHandler("prp-mdt:performOffenderSearch", function(query)
	local usource = source
	local matches = {}
	MySQL.Async.fetchAll("SELECT * FROM `__characters` WHERE LOWER(`first_name`) LIKE @query OR LOWER(`last_name`) LIKE @query OR CONCAT(LOWER(`first_name`), ' ', LOWER(`last_name`)) LIKE @query", {
		['@query'] = string.lower('%'..query..'%') -- % wildcard, needed to search for all alike results
	}, function(result)

		for index, data in ipairs(result) do
			table.insert(matches, data)
		end

		TriggerClientEvent("prp-mdt:returnOffenderSearchResults", usource, matches)
	end)
end)

RegisterServerEvent("prp-mdt:getOffenderDetails")
AddEventHandler("prp-mdt:getOffenderDetails", function(offender)
	local usource = source

	local result = MySQL.Sync.fetchAll('SELECT * FROM `user_mdt` WHERE `char_id` = @id', {
		['@id'] = offender.id
	})
	offender.notes = ""
	offender.mugshot_url = ""
	offender.bail = false
	if result[1] then
		offender.notes = result[1].notes
		offender.mugshot_url = result[1].mugshot_url
		offender.bail = result[1].bail
	end

	local convictions = MySQL.Sync.fetchAll('SELECT * FROM `user_convictions` WHERE `char_id` = @id', {
		['@id'] = offender.id
	})
	if convictions[1] then
		offender.convictions = {}
		for i = 1, #convictions do
			local conviction = convictions[i]
			offender.convictions[conviction.offense] = conviction.count
		end
	end

	local warrants = MySQL.Sync.fetchAll('SELECT * FROM `mdt_warrants` WHERE `char_id` = @id', {
		['@id'] = offender.id
	})
	if warrants[1] then
		offender.haswarrant = true
	end

	local phone_number = MySQL.Sync.fetchAll('SELECT `phone_number` FROM `__characters` WHERE `id` = @id', {
		['@id'] = offender.id
	})
	offender.phone_number = phone_number[1].phone_number

	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM `__vehicles` WHERE `cid` = @cid', {
		['@cid'] = offender.id
	})
	for i = 1, #vehicles do
		vehicles[i].state, vehicles[i].stored, vehicles[i].job, vehicles[i].fourrieremecano, vehicles[i].vehiclename, vehicles[i].ownerName = nil
		vehicles[i].vehicle = json.decode(vehicles[i].vehicle)
		vehicles[i].model = vehicles[i].vehicle.model
		if vehicles[i].vehicle.color1 then
			if colors[tostring(vehicles[i].vehicle.color2)] and colors[tostring(vehicles[i].vehicle.color1)] then
				vehicles[i].color = colors[tostring(vehicles[i].vehicle.color2)] .. " on " .. colors[tostring(vehicles[i].vehicle.color1)]
			elseif colors[tostring(vehicles[i].vehicle.color1)] then
				vehicles[i].color = colors[tostring(vehicles[i].vehicle.color1)]
			elseif colors[tostring(vehicles[i].vehicle.color2)] then
				vehicles[i].color = colors[tostring(vehicles[i].vehicle.color2)]
			else
				vehicles[i].color = "Unknown"
			end
		end
		vehicles[i].vehicle = nil
	end
	offender.vehicles = vehicles

	TriggerClientEvent("prp-mdt:returnOffenderDetails", usource, offender)
end)

RegisterServerEvent("prp-mdt:getOffenderDetailsById")
AddEventHandler("prp-mdt:getOffenderDetailsById", function(char_id)
	local usource = source

	local result = MySQL.Sync.fetchAll('SELECT * FROM `__characters` WHERE `id` = @id', {
		['@id'] = char_id
	})
	local offender = result[1]

	if not offender then
		TriggerClientEvent("prp-mdt:closeModal", usource)
		TriggerClientEvent("prp-mdt:sendNotification", usource, "This person no longer exists.")
		return
	end

	local result = MySQL.Sync.fetchAll('SELECT * FROM `user_mdt` WHERE `char_id` = @id', {
		['@id'] = offender.id
	})
	offender.notes = ""
	offender.mugshot_url = ""
	offender.bail = false
	if result[1] then
		offender.notes = result[1].notes
		offender.mugshot_url = result[1].mugshot_url
		offender.bail = result[1].bail
	end

	local convictions = MySQL.Sync.fetchAll('SELECT * FROM `user_convictions` WHERE `char_id` = @id', {
		['@id'] = offender.id
	}) 
	if convictions[1] then
		offender.convictions = {}
		for i = 1, #convictions do
			local conviction = convictions[i]
			offender.convictions[conviction.offense] = conviction.count
		end
	end

	local warrants = MySQL.Sync.fetchAll('SELECT * FROM `mdt_warrants` WHERE `char_id` = @id', {
		['@id'] = offender.id
	})
	if warrants[1] then
		offender.haswarrant = true
	end

	local phone_number = MySQL.Sync.fetchAll('SELECT `phone_number` FROM `__characters` WHERE `id` = @id', {
		['@id'] = offender.id
	})
	offender.phone_number = phone_number[1].phone_number

	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM `__vehicles` WHERE `cid` = @cid', {
		['@cid'] = offender.id
	})
	for i = 1, #vehicles do
		vehicles[i].state, vehicles[i].stored, vehicles[i].job, vehicles[i].fourrieremecano, vehicles[i].vehiclename, vehicles[i].ownerName = nil
		vehicles[i].vehicle = json.decode(vehicles[i].vehicle)
		vehicles[i].model = vehicles[i].vehicle.model
		if vehicles[i].vehicle.color1 then
			if colors[tostring(vehicles[i].vehicle.color2)] and colors[tostring(vehicles[i].vehicle.color1)] then
				vehicles[i].color = colors[tostring(vehicles[i].vehicle.color2)] .. " on " .. colors[tostring(vehicles[i].vehicle.color1)]
			elseif colors[tostring(vehicles[i].vehicle.color1)] then
				vehicles[i].color = colors[tostring(vehicles[i].vehicle.color1)]
			elseif colors[tostring(vehicles[i].vehicle.color2)] then
				vehicles[i].color = colors[tostring(vehicles[i].vehicle.color2)]
			else
				vehicles[i].color = "Unknown"
			end
		end
		vehicles[i].vehicle = nil
	end
	offender.vehicles = vehicles

	TriggerClientEvent("prp-mdt:returnOffenderDetails", usource, offender)
end)

RegisterServerEvent("prp-mdt:saveOffenderChanges")
AddEventHandler("prp-mdt:saveOffenderChanges", function(id, changes, identifier)
	local usource = source
	MySQL.Async.fetchAll('SELECT * FROM `user_mdt` WHERE `char_id` = @id', {
		['@id']  = id
	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE `user_mdt` SET `notes` = @notes, `mugshot_url` = @mugshot_url, `bail` = @bail WHERE `char_id` = @id', {
				['@id'] = id,
				['@notes'] = changes.notes,
				['@mugshot_url'] = changes.mugshot_url,
				['@bail'] = changes.bail
			})
		else
			MySQL.Async.insert('INSERT INTO `user_mdt` (`char_id`, `notes`, `mugshot_url`, `bail`) VALUES (@id, @notes, @mugshot_url, @bail)', {
				['@id'] = id,
				['@notes'] = changes.notes,
				['@mugshot_url'] = changes.mugshot_url,
				['@bail'] = changes.bail
			})
		end

		if changes.convictions ~= nil then
			for conviction, amount in pairs(changes.convictions) do	
				MySQL.Async.execute('UPDATE `user_convictions` SET `count` = @count WHERE `char_id` = @id AND `offense` = @offense', {
					['@id'] = id,
					['@count'] = amount,
					['@offense'] = conviction
				})
			end
		end

		for i = 1, #changes.convictions_removed do
			MySQL.Async.execute('DELETE FROM `user_convictions` WHERE `char_id` = @id AND `offense` = @offense', {
				['@id'] = id,
				['offense'] = changes.convictions_removed[i]
			})
		end

		TriggerClientEvent("prp-mdt:sendNotification", usource, "Offender changes have been saved.")
	end)
end)

RegisterServerEvent("prp-mdt:saveReportChanges")
AddEventHandler("prp-mdt:saveReportChanges", function(data)
	MySQL.Async.execute('UPDATE `mdt_reports` SET `title` = @title, `incident` = @incident WHERE `id` = @id', {
		['@id'] = data.id,
		['@title'] = data.title,
		['@incident'] = data.incident
	})
	TriggerClientEvent("prp-mdt:sendNotification", source, "Report changes have been saved.")
end)

RegisterServerEvent("prp-mdt:deleteReport")
AddEventHandler("prp-mdt:deleteReport", function(id)
	MySQL.Async.execute('DELETE FROM `mdt_reports` WHERE `id` = @id', {
		['@id']  = id
	})
	TriggerClientEvent("prp-mdt:sendNotification", source, "Report has been successfully deleted.")
end)

RegisterServerEvent("prp-mdt:submitNewReport")
AddEventHandler("prp-mdt:submitNewReport", function(data)
	local usource = source
	local author = GetCharacterName(source)
	if tonumber(data.sentence) and tonumber(data.sentence) > 0 then
		data.sentence = tonumber(data.sentence)
	else 
		data.sentence = nil
	end
	charges = json.encode(data.charges)
	data.date = os.date('%m-%d-%Y %H:%M:%S', os.time())
	MySQL.Async.insert('INSERT INTO `mdt_reports` (`char_id`, `title`, `incident`, `charges`, `author`, `name`, `date`, `jailtime`) VALUES (@id, @title, @incident, @charges, @author, @name, @date, @sentence)', {
		['@id']  = data.char_id,
		['@title'] = data.title,
		['@incident'] = data.incident,
		['@charges'] = charges,
		['@author'] = author,
		['@name'] = data.name,
		['@date'] = data.date,
		['@sentence'] = data.sentence
	}, function(id)
		TriggerEvent("prp-mdt:getReportDetailsById", id, usource)
		TriggerClientEvent("prp-mdt:sendNotification", usource, "A new report has been submitted.")
	end)

	for offense, count in pairs(data.charges) do
		MySQL.Async.fetchAll('SELECT * FROM `user_convictions` WHERE `offense` = @offense AND `char_id` = @id', {
			['@offense'] = offense,
			['@id'] = data.char_id
		}, function(result)
			if result[1] then
				MySQL.Async.execute('UPDATE `user_convictions` SET `count` = @count WHERE `offense` = @offense AND `char_id` = @id', {
					['@id']  = data.char_id,
					['@offense'] = offense,
					['@count'] = count + 1
				})
			else
				MySQL.Async.insert('INSERT INTO `user_convictions` (`char_id`, `offense`, `count`) VALUES (@id, @offense, @count)', {
					['@id']  = data.char_id,
					['@offense'] = offense,
					['@count'] = count
				})
			end
		end)
	end
end)

RegisterServerEvent("prp-mdt:performReportSearch")
AddEventHandler("prp-mdt:performReportSearch", function(query)
	local usource = source
	local matches = {}
	MySQL.Async.fetchAll("SELECT * FROM `mdt_reports` WHERE `id` LIKE @query OR LOWER(`title`) LIKE @query OR LOWER(`name`) LIKE @query OR LOWER(`author`) LIKE @query or LOWER(`charges`) LIKE @query", {
		['@query'] = string.lower('%'..query..'%') -- % wildcard, needed to search for all alike results
	}, function(result)

		for index, data in ipairs(result) do
			data.charges = json.decode(data.charges)
			table.insert(matches, data)
		end

		TriggerClientEvent("prp-mdt:returnReportSearchResults", usource, matches)
	end)
end)

RegisterServerEvent("prp-mdt:performVehicleSearch")
AddEventHandler("prp-mdt:performVehicleSearch", function(query)
	local usource = source
	local matches = {}
	MySQL.Async.fetchAll("SELECT * FROM `__vehicles` WHERE LOWER(`plate`) LIKE @query", {
		['@query'] = string.lower('%'..query..'%') -- % wildcard, needed to search for all alike results
	}, function(result)

		for index, data in ipairs(result) do
			local data_decoded = json.decode(data.vehicle)
			data.model = data_decoded.model
			if data_decoded.color1 then
				data.color = colors[tostring(data_decoded.color1)]
				if colors[tostring(data_decoded.color2)] then
					data.color = colors[tostring(data_decoded.color2)] .. " on " .. colors[tostring(data_decoded.color1)]
				end
			end
			table.insert(matches, data)
		end

		TriggerClientEvent("prp-mdt:returnVehicleSearchResults", usource, matches)
	end)
end)

RegisterServerEvent("prp-mdt:performVehicleSearchInFront")
AddEventHandler("prp-mdt:performVehicleSearchInFront", function(query)
	local usource = source
	local player = exports['prp-base']:GetCurrentCharacterInfo(usource)
    local job = player.job
    if job == 'Police' then
    	MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_reports` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(reports)
    		for r = 1, #reports do
    			reports[r].charges = json.decode(reports[r].charges)
    		end
    		MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_warrants` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(warrants)
    			for w = 1, #warrants do
    				warrants[w].charges = json.decode(warrants[w].charges)
    			end
    			MySQL.Async.fetchAll("SELECT * FROM `__vehicles` WHERE `plate` = @query", {
					['@query'] = query
				}, function(result)
					local officer = GetCharacterName(usource)
    				TriggerClientEvent('prp-mdt:toggleVisibilty', usource, reports, warrants, officer, xPlayer.job.name)
					TriggerClientEvent("prp-mdt:returnVehicleSearchInFront", usource, result, query)
				end)
    		end)
    	end)
	elseif job == 'DOJ' then
		MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_reports` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(reports)
    		for r = 1, #reports do
    			reports[r].charges = json.decode(reports[r].charges)
    		end
    		MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_warrants` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(warrants)
    			for w = 1, #warrants do
    				warrants[w].charges = json.decode(warrants[w].charges)
    			end
    			MySQL.Async.fetchAll("SELECT * FROM `__vehicles` WHERE `plate` = @query", {
					['@query'] = query
				}, function(result)
					local officer = GetCharacterName(usource)
    				TriggerClientEvent('prp-mdt:toggleVisibilty', usource, reports, warrants, officer, xPlayer.job.name)
					TriggerClientEvent("prp-mdt:returnVehicleSearchInFront", usource, result, query)
				end)
    		end)
    	end)
	elseif job == 'FIB' then
		MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_reports` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(reports)
    		for r = 1, #reports do
    			reports[r].charges = json.decode(reports[r].charges)
    		end
    		MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_warrants` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(warrants)
    			for w = 1, #warrants do
    				warrants[w].charges = json.decode(warrants[w].charges)
    			end
    			MySQL.Async.fetchAll("SELECT * FROM `__vehicles` WHERE `plate` = @query", {
					['@query'] = query
				}, function(result)
					local officer = GetCharacterName(usource)
    				TriggerClientEvent('prp-mdt:toggleVisibilty', usource, reports, warrants, officer, xPlayer.job.name)
					TriggerClientEvent("prp-mdt:returnVehicleSearchInFront", usource, result, query)
				end)
    		end)
    	end)
	end
end)

RegisterServerEvent("prp-mdt:getVehicle")
AddEventHandler("prp-mdt:getVehicle", function(vehicle)
	local usource = source
	local result = MySQL.Sync.fetchAll("SELECT * FROM `__characters` WHERE `id` = @query", {
		['@query'] = vehicle.cid
	})
	if result[1] then
		vehicle.cid = result[1].first_name .. ' ' .. result[1].last_name
		vehicle.owner_id = result[1].id
	end

	local data = MySQL.Sync.fetchAll('SELECT * FROM `vehicle_mdt` WHERE `plate` = @plate', {
		['@plate'] = vehicle.plate
	})
	if data[1] then
		if data[1].stolen == 1 then vehicle.stolen = true else vehicle.stolen = false end
		if data[1].notes ~= null then vehicle.notes = data[1].notes else vehicle.notes = '' end
	else
		vehicle.stolen = false
		vehicle.notes = ''
	end

	local warrants = MySQL.Sync.fetchAll('SELECT * FROM `mdt_warrants` WHERE `char_id` = @id', {
		['@id'] = vehicle.owner_id
	})
	if warrants[1] then
		vehicle.haswarrant = true
	end

	local bail = MySQL.Sync.fetchAll('SELECT `bail` FROM user_mdt WHERE `char_id` = @id', {
		['@id'] = vehicle.owner_id
	})
	if bail and bail[1] and bail[1].bail == 1 then vehicle.bail = true else vehicle.bail = false end

	vehicle.type = types[vehicle.type]
	TriggerClientEvent("prp-mdt:returnVehicleDetails", usource, vehicle)
end)

RegisterServerEvent("prp-mdt:getWarrants")
AddEventHandler("prp-mdt:getWarrants", function()
	local usource = source
	MySQL.Async.fetchAll("SELECT * FROM `mdt_warrants`", {}, function(warrants)
		for i = 1, #warrants do
			warrants[i].expire_time = ""
			warrants[i].charges = json.decode(warrants[i].charges)
		end
		TriggerClientEvent("prp-mdt:returnWarrants", usource, warrants)
	end)
end)

RegisterServerEvent("prp-mdt:submitNewWarrant")
AddEventHandler("prp-mdt:submitNewWarrant", function(data)
	local usource = source
	data.charges = json.encode(data.charges)
	data.author = GetCharacterName(source)
	data.date = os.date('%m-%d-%Y %H:%M:%S', os.time())
	MySQL.Async.insert('INSERT INTO `mdt_warrants` (`name`, `char_id`, `report_id`, `report_title`, `charges`, `date`, `expire`, `notes`, `author`) VALUES (@name, @char_id, @report_id, @report_title, @charges, @date, @expire, @notes, @author)', {
		['@name']  = data.name,
		['@char_id'] = data.char_id,
		['@report_id'] = data.report_id,
		['@report_title'] = data.report_title,
		['@charges'] = data.charges,
		['@date'] = data.date,
		['@expire'] = data.expire,
		['@notes'] = data.notes,
		['@author'] = data.author
	}, function()
		TriggerClientEvent("prp-mdt:completedWarrantAction", usource)
		TriggerClientEvent("prp-mdt:sendNotification", usource, "A new warrant has been created.")
	end)
end)

RegisterServerEvent("prp-mdt:deleteWarrant")
AddEventHandler("prp-mdt:deleteWarrant", function(id)
	local usource = source
	MySQL.Async.execute('DELETE FROM `mdt_warrants` WHERE `id` = @id', {
		['@id']  = id
	}, function()
		TriggerClientEvent("prp-mdt:completedWarrantAction", usource)
	end)
	TriggerClientEvent("prp-mdt:sendNotification", usource, "Warrant has been successfully deleted.")
end)

RegisterServerEvent("prp-mdt:getReportDetailsById")
AddEventHandler("prp-mdt:getReportDetailsById", function(query, _source)
	if _source then source = _source end
	local usource = source
	MySQL.Async.fetchAll("SELECT * FROM `mdt_reports` WHERE `id` = @query", {
		['@query'] = query
	}, function(result)
		if result and result[1] then
			result[1].charges = json.decode(result[1].charges)
			TriggerClientEvent("prp-mdt:returnReportDetails", usource, result[1])
		else
			TriggerClientEvent("prp-mdt:closeModal", usource)
			TriggerClientEvent("prp-mdt:sendNotification", usource, "This report cannot be found.")
		end
	end)
end)

RegisterServerEvent("prp-mdt:saveVehicleChanges")
AddEventHandler("prp-mdt:saveVehicleChanges", function(data)
	if data.stolen then data.stolen = 1 else data.stolen = 0 end
	local usource = source
	MySQL.Async.fetchAll('SELECT * FROM `vehicle_mdt` WHERE `plate` = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE `vehicle_mdt` SET `stolen` = @stolen, `notes` = @notes WHERE `plate` = @plate', {
				['@plate'] = data.plate,
				['@stolen'] = data.stolen,
				['@notes'] = data.notes
			})
		else
			MySQL.Async.insert('INSERT INTO `vehicle_mdt` (`plate`, `stolen`, `notes`) VALUES (@plate, @stolen, @notes)', {
				['@plate'] = data.plate,
				['@stolen'] = data.stolen,
				['@notes'] = data.notes
			})
		end
		
		TriggerClientEvent("prp-mdt:sendNotification", usource, "Vehicle changes have been saved.")
	end)
end)

function GetCharacterName(source)
	local player = exports['prp-base']:GetCurrentCharacterInfo(source)
	local result = MySQL.Sync.fetchAll('SELECT first_name, last_name FROM __characters WHERE id = @id', {
		['@id'] = player.id
	})

	if result[1] and result[1].first_name and result[1].last_name then
		return ('%s %s'):format(result[1].first_name, result[1].last_name)
	end
end

function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end