local weapons = ""
local playerInjury = {}
local bones = {}
local flagged = {}
currentCops = 0

RegisterServerEvent('urp:reference')
AddEventHandler('urp:reference', function(cid)
	local _source = source
	exports.ghmattimysql:execute('SELECT `first_name`, `last_name`, `callsign` FROM __characters WHERE `id`= ?', {cid}, function(data)
		if data[1].callsign ~= 0 then
			local name = data[1].callsign.. ' | '..  data[1].first_name .. ' ' .. data[1].last_name 
			TriggerClientEvent("urp:addBlip", -1, _source, name)
		else
			TriggerClientEvent('DoLongHudText', _source, 'You need to assign a callsign!', 2)
		end
	end)
end)

RegisterServerEvent('wrp-assign:callsign')
AddEventHandler('wrp-assign:callsign', function(callsign, cid)
	-- local player = exports['wrp-base']:GetCurrentCharacterInfo(source)
	exports.ghmattimysql:execute("UPDATE __characters SET callsign = @callsign WHERE id = @id", { 
		['@id'] = cid,
		['@callsign'] = callsign
	})
end)

-- AddEventHandler('playerDropped', function()
-- 	local src = source
-- 	if src ~= nil then
-- 		local player = exports['wrp-base']:GetCurrentCharacterInfo(src)
-- 		local job = player.job
-- 		if job == 'Police' then
-- 			Citizen.Wait(5000)
-- 			TriggerClientEvent('police:set-job', -1)
-- 		end
-- 	end
-- end)

-- RegisterServerEvent('police:spawned')
-- AddEventHandler('police:spawned', function()
--     local src = source
--     local player = exports['wrp-base']:GetCurrentCharacterInfo(src)
--     local job = player.job
-- 	if job == 'Police' then
-- 		Citizen.Wait(5000)
-- 		TriggerClientEvent("wrp-base:passjob", src, "true")
-- 	end
-- end)
RegisterServerEvent('server:takephone')
AddEventHandler('server:takephone', function(target)
    TriggerClientEvent('inventory:removeItem', target, "mobilephone", 1)
end)

RegisterServerEvent('CrashTackle')
AddEventHandler('CrashTackle', function(player)
	TriggerClientEvent('playerTackled', player)
	TriggerClientEvent('playerTackled', source)
end)


RegisterServerEvent('dragPlayer:disable')
AddEventHandler('dragPlayer:disable', function()
	TriggerClientEvent('drag:stopped', -1, source)
end)

RegisterServerEvent('dr:releaseEscort')
AddEventHandler('dr:releaseEscort', function(releaseID)
	TriggerClientEvent('dr:releaseEscort', tonumber(releaseID))
end)

RegisterServerEvent('police:remmaskGranted')
AddEventHandler('police:remmaskGranted', function(targetplayer)
    TriggerClientEvent('police:remmaskAccepted', targetplayer)
end)

RegisterServerEvent('unseatAccepted')
AddEventHandler('unseatAccepted', function(targetplayer,x,y,z)
    TriggerClientEvent('unseatPlayerFinish', targetplayer,x,y,z)
end)

RegisterServerEvent('police:updateLicenses')
AddEventHandler('police:updateLicenses', function(targetlicense, status, license)
    if status == 1 then
        TriggerEvent('wrp-license:addLicense', targetlicense, license)
    else
        TriggerEvent('wrp-license:removeLicense', targetlicense, license)
    end
end)

RegisterServerEvent('police:cuffGranted2')
AddEventHandler('police:cuffGranted2', function(t,softcuff)
	local src = source
    
	-- print('cuffing')
	TriggerClientEvent('menu:setCuffState', t, true)
	TriggerEvent('police:setCuffState2', t, true)
	if softcuff then
        TriggerClientEvent('handCuffedWalking', t)
        -- print('softcuff')
    else
        -- print('hardcuff')
		TriggerClientEvent('police:getArrested2', t, src)
		TriggerClientEvent('police:cuffTransition',src)
	end
end)

RegisterServerEvent('police:SeizeCash')
AddEventHandler('police:SeizeCash', function(target)
	local src = source
	local xPlayer = exports['wrp-base']:GetCurrentCharacterInfo(src)
	local zPlayer = exports['wrp-base']:GetCurrentCharacterInfo(target)
	if not xPlayer.job.name == 'police' then
		print('steam:'..identifier..' User attempted sieze cash')
		return
	end
    exports.ghmattimysql:execute("SELECT `cash` FROM `__characters` WHERE `id` = '" .. zPlayer.id .. "'", function(result)
		local cash = result[1].cash
		TriggerClientEvent('wrp-ac:removeban', target, cash)
		TriggerClientEvent('wrp-ac:InfoPass', src, cash)
		TriggerClientEvent('DoLongHudText', target, 'Your Cash and Marked Bills was seized',1)
		TriggerClientEvent('DoLongHudText', src, 'Seized persons cash: $'..cash, 1)
	end)
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(t)
local src = source
	TriggerEvent('police:setCuffState', t, true)
	TriggerClientEvent('menu:setCuffState', t, true)
	TriggerClientEvent('police:getArrested', t, src)
	TriggerClientEvent('police:cuffTransition',src)
end)

RegisterServerEvent('police:escortAsk')
AddEventHandler('police:escortAsk', function(target)
	local LocalPlayer = exports['wrp-base']:getModule('LocalPlayer')
	TriggerClientEvent('dr:escort', target,source)
end)

RegisterServerEvent('falseCuffs')
AddEventHandler('falseCuffs', function(t)
	TriggerClientEvent('falseCuffs',t)
	TriggerClientEvent('menu:setCuffState', t, false)
end)

RegisterServerEvent('police:setCuffState')
AddEventHandler('police:setCuffState', function(t,state)
	TriggerClientEvent('police:currentHandCuffedState',t,true)
	TriggerClientEvent('menu:setCuffState', t, true)
end)

RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(target,netid)
	local LocalPlayer = exports['wrp-base']:getModule('LocalPlayer')
	TriggerClientEvent('police:forcedEnteringVeh', target, netid)
	TriggerClientEvent('DoLongHudText', source, 'Seating Player', 1)
end)

--- POLICE SEXTION ^^^^^^^^^^^^


RegisterServerEvent('ped:forceTrunkAsk')
AddEventHandler('ped:forceTrunkAsk', function(targettrunk)
TriggerClientEvent('ped:forcedEnteringVeh', targettrunk)
end)

RegisterServerEvent('Evidence:GiveWoundsFinish')
AddEventHandler('Evidence:GiveWoundsFinish', function(data, databone)
    playerInjury[source] = data
    bones[source] = databone
end)

RegisterServerEvent('bones:server:updateServer')
AddEventHandler('bones:server:updateServer', function(data2)
    bones[source] = data2
	-- print('printing bones data ', bones[source])
	TriggerClientEvent('bones:client:updatefromDB', source, data2)
end)

RegisterServerEvent('government:bill')
AddEventHandler('government:bill', function(money)
    local source = source
    local LocalPlayer = exports['wrp-base']:getModule('LocalPlayer')
    if money ~= nil then
       TriggerClientEvent('wrp-ac:InfoPass', source, money)
       TriggerClientEvent('DoLongHudText', source, 'You got $'.. money .. ' for 5 Loose Buds of Weed.', 1)
    end
end)

RegisterServerEvent('sniffAccepted')
AddEventHandler('sniffAccepted', function(data)
	TriggerClientEvent('K9:SniffConfirmed', source)
end)

RegisterServerEvent('reviveGranted')
AddEventHandler('reviveGranted', function(t)
	TriggerClientEvent('reviveFunction', t)
end)

RegisterServerEvent('ems:stomachpumptarget')
AddEventHandler('ems:stomachpumptarget', function(t)
TriggerClientEvent('fx:stomachpump', t)
end)

RegisterServerEvent('ems:healplayer')
AddEventHandler('ems:healplayer', function(t)
TriggerClientEvent('healed:minors', t)
end)

RegisterServerEvent('huntAccepted')
AddEventHandler('huntAccepted', function(player, distance, coords)
TriggerClientEvent('K9:HuntAccepted', player, coords, distance)
end)


RegisterServerEvent('bank:givecash')
AddEventHandler('bank:givecash', function(toPlayer, amount)
    local LocalPlayer = exports['wrp-base']:getModule('LocalPlayer')
    if amount ~= nil then
        TriggerClientEvent('wrp-ac:InfoPass', toPlayer, amount)
    end
end)

RegisterServerEvent("police:check:plate_sv")
AddEventHandler("police:check:plate_sv", function(licensePlate, vehicleClass)
  local src = source
  exports.ghmattimysql:execute('SELECT cid FROM __vehicles WHERE `plate` = @plate', {
	  ['@plate'] =  licensePlate
  }, function(result)
	  if result[1] ~= nil then
		  exports.ghmattimysql:execute('SELECT `phone_number`, `first_name`, `last_name`, `job` FROM __characters WHERE `id` = @id', {
			  ['@id'] =  result[1].cid
		  }, function(shit)
			  local num = shit[1].phone_number
			  local first = num:sub(1, 3)
			  local second = num:sub(4, 6)
			  local third = num:sub(7, 11)
			  local msg = first .. "-" .. second .. "-" .. third
			  local flagged = checkFlag(licensePlate)
			  if flagged then
				  TriggerClientEvent('chatMessagess', src, 'DISPATCH: ', 1, "Name: ".. shit[1].first_name ..' '.. shit[1].last_name .. " Phone #: " .. msg .. " Job: " .. shit[1].job .. " | This Vehicle has been flagged!")
			  else
				  TriggerClientEvent('chatMessagess', src, 'DISPATCH: ', 1, "Name: ".. shit[1].first_name ..' '.. shit[1].last_name .. " Phone #: " .. msg .. " Job: " .. shit[1].job )
			  end
		  end)
	  
	  else
		  TriggerClientEvent('chatMessagess', src, 'DISPATCH: ', 1, "This vehicle has been reported (STOLEN)")
	  end 
  end)	  
end)

RegisterServerEvent("police:check:plate_sv")
AddEventHandler("police:check:plate_sv", function(licensePlate, vehicleClass)
  local src = source
  exports.ghmattimysql:execute('SELECT `cid` FROM __vehicles WHERE `plate` = @plate', {
	  ['@plate'] =  licensePlate
  }, function(result)
	  if result[1] ~= nil then
		  exports.ghmattimysql:execute('SELECT `phone_number`, `first_name`, `last_name`, `job` FROM __characters WHERE `id` = @id', {
			  ['@id'] =  result[1].cid
		  }, function(shit)
			  local num = shit[1].phone_number
			  local first = num:sub(1, 3)
			  local second = num:sub(4, 6)
			  local third = num:sub(7, 11)
			  local msg = first .. "-" .. second .. "-" .. third
			  local flagged = checkFlag(licensePlate)
			  if flagged then
				  TriggerClientEvent('chatMessagess', src, 'DISPATCH: ', 1, "Name: ".. shit[1].first_name ..' '.. shit[1].last_name .. " Phone #: " .. msg .. " Job: " .. shit[1].job .. " | This Vehicle has been flagged!")
			  else
				  TriggerClientEvent('chatMessagess', src, 'DISPATCH: ', 1, "Name: ".. shit[1].first_name ..' '.. shit[1].last_name .. " Phone #: " .. msg .. " Job: " .. shit[1].job )
			  end
		  end)
	  
	  else
		  TriggerClientEvent('chatMessagess', src, 'DISPATCH: ', 1, "This vehicle has been reported (STOLEN)")
	  end 
  end)	  
end)


RegisterServerEvent("flag:plate")
AddEventHandler("flag:plate", function(plate)
  table.insert(flagged, plate)
end)

RegisterServerEvent("remflag:plate")
AddEventHandler("remflag:plate", function(plate)
  table.remove(flagged)
end)

function checkFlag(plate)
  for k, v in ipairs(flagged) do
	  if v == plate then
		  return true
	  else
		  return false
	  end
  end
end

RegisterServerEvent("police:checkbank")
AddEventHandler("police:checkbank", function(target)
	local src = source
	local searcher = exports['wrp-base']:GetCurrentCharacterInfo(target)
	exports.ghmattimysql:execute('SELECT `bank` FROM __characters WHERE id = ?', {searcher.id}, function(result)
		if result[1] ~= nil then
			TriggerClientEvent("DoLongHudText", src, "Target's Bank: " .. result[1].bank)
			TriggerClientEvent("DoLongHudText", target, "Your bank balance has been checked")
		end
	end)
end)

RegisterServerEvent('garages:SetVehImpounded')
AddEventHandler('garages:SetVehImpounded', function(licensePlate)
	exports.ghmattimysql:execute("UPDATE __vehicles SET `garage` = @garage, `state` = @state WHERE `plate` = @plate", {
		['garage'] = 'Impound Lot', 
		['state'] = 'Normal Impound', 
		['plate'] = licensePlate
	})
end)

RegisterServerEvent('garages:SetVehImpounded2')
AddEventHandler('garages:SetVehImpounded2', function(licensePlate)
	exports.ghmattimysql:execute("UPDATE __vehicles SET `garage` = @garage, `state` = @state WHERE `plate` = @plate", {
		['garage'] = 'Impound Lot', 
		['state'] = 'Police Impound', 
		['plate'] = licensePlate
	})
end)

AddEventHandler('playerDropped', function()
	local src = source
	if src ~= nil then
		local player = exports['wrp-base']:GetCurrentCharacterInfo(src)
		exports.ghmattimysql:execute('SELECT `job` FROM __characters WHERE id = ?', {player.id}, function(result)
			if result[1].job == 'Police' then
				exports.ghmattimysql:execute("UPDATE __characters SET job = @job WHERE id = @id", { 
					['@id'] = player.id,
					['@job'] = 'OffPolice'
				})
				currentCops = currentCops - 1
				TriggerClientEvent("job:policecount", -1, currentCops)
				print('Dropped, New Cop Count: ' ..currentCops)
				TriggerEvent('wrp-eblips:server:removePlayerBlipGroup', src, 'Police')
			end
		end)
	end
end)

RegisterServerEvent('wrp-police:obtain-count')
AddEventHandler('wrp-police:obtain-count', function()
	local src = source
	TriggerClientEvent('job:policecount', src, currentCops)
end)

RegisterServerEvent('attemptduty')
AddEventHandler('attemptduty', function(pJobType, cid, first_name, last_name, callsign)
	local src = source
	if src == nil or src == 0 then src = source end
	local job = pJobType and pJobType or 'Police'
	TriggerClientEvent('police:officerOnDuty', src)
	currentCops = currentCops + 1
	TriggerClientEvent("job:policecount", -1, currentCops)
	TriggerEvent('wrp-eblips:server:registerPlayerBlipGroup', src, 'Police')
	TriggerEvent('wrp-eblips:server:registerSourceName', src, callsign .." | ".. first_name .." ".. last_name)
	print(currentCops)
end)

RegisterServerEvent('attemptoffdutypd')
AddEventHandler('attemptoffdutypd', function()
	if currentCops ~= 0 then
		currentCops = currentCops - 1
	else
		currentCops = 0
	end
	TriggerClientEvent("job:policecount", -1, currentCops)
	TriggerEvent('wrp-eblips:server:removePlayerBlipGroup', source, 'Police')
	print(currentCops)
end)

RegisterServerEvent('attemptdutyems')
AddEventHandler('attemptdutyems', function(pJobType, cid, first_name, last_name, callsign)
	local src = source
	if src == nil or src == 0 then src = source end
	local job = pJobType and pJobType or 'EMS'
	TriggerClientEvent('police:officerOnDuty', src)
	TriggerClientEvent("job:policecount", -1, currentCops)
	TriggerEvent('wrp-eblips:server:registerPlayerBlipGroup', src, 'EMS')
	TriggerEvent('wrp-eblips:server:registerSourceName', src, callsign .." | ".. first_name .." ".. last_name)
end)

RegisterServerEvent('attemptoffdutyems')
AddEventHandler('attemptoffdutyems', function()
	TriggerEvent('wrp-eblips:server:removePlayerBlipGroup', source, 'EMS')
end)


local carrying = {}
--carrying[source] = targetSource, source is carrying targetSource
local carried = {}
--carried[targetSource] = source, targetSource is being carried by source

RegisterServerEvent("wrp-CarryPeople:sync")
AddEventHandler("wrp-CarryPeople:sync", function(targetSrc)
	local source = source
	local sourcePed = GetPlayerPed(source)
   	local sourceCoords = GetEntityCoords(sourcePed)
	local targetPed = GetPlayerPed(targetSrc)
        local targetCoords = GetEntityCoords(targetPed)
	if #(sourceCoords - targetCoords) <= 1.0 then 
		TriggerClientEvent("wrp-CarryPeople:syncTarget", targetSrc, source)
		carrying[source] = targetSrc
		carried[targetSrc] = source
	end
end)

RegisterServerEvent("wrp-CarryPeople:stop")
AddEventHandler("wrp-CarryPeople:stop", function(targetSrc)
	local source = source

	if carrying[source] then
		TriggerClientEvent("wrp-CarryPeople:cl_stop", targetSrc)
		carrying[source] = nil
		carried[targetSrc] = nil
	elseif carried[source] then
		TriggerClientEvent("wrp-CarryPeople:cl_stop", carried[source])			
		carrying[carried[source]] = nil
		carried[source] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	
	if carrying[source] then
		TriggerClientEvent("wrp-CarryPeople:cl_stop", carrying[source])
		carried[carrying[source]] = nil
		carrying[source] = nil
	end

	if carried[source] then
		TriggerClientEvent("wrp-CarryPeople:cl_stop", carried[source])
		carrying[carried[source]] = nil
		carried[source] = nil
	end
end)