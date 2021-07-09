RegisterServerEvent('heli:forward.spotlight')
AddEventHandler('heli:forward.spotlight', function(state)
	local serverID = source
	TriggerClientEvent('heli:forward.spotlight', -1, serverID, state)
end)

RegisterServerEvent('heli:tracking.spotlight')
AddEventHandler('heli:tracking.spotlight', function(target_vehicle)
	local serverID = source
	TriggerClientEvent('heli:tracking.spotlight', -1, serverID, target_vehicle)
end)

RegisterServerEvent('heli:target.change')
AddEventHandler('heli:target.change', function(new_target)
	local serverID = source
	TriggerClientEvent('heli:target.change', -1, serverID, new_target)
end)

RegisterServerEvent('heli:manual.spotlight')
AddEventHandler('heli:manual.spotlight', function()
	local serverID = source
	TriggerClientEvent('heli:manual.spotlight', -1, serverID)
end)