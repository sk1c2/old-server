RegisterServerEvent('CrashTackle')
AddEventHandler('CrashTackle', function(target)
	TriggerClientEvent("playerTackled", target)
end)