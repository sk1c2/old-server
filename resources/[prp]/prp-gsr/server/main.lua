gsrData = {}


RegisterCommand('gsr', function(source, args, user)
    local Source = source
    local src = source
    local number = tonumber(args[1])
    if args[1] ~= nil then 
        local steam = GetPlayerIdentifiers(Source)[1]
        local userData = promise:new()
    
        exports.ghmattimysql:execute('SELECT uid FROM __users WHERE steam = ?', {steam}, function(data)
            userData:resolve(data)
        end)
    
        local uid = Citizen.Await(userData)
        local player = exports['prp-base']:GetCurrentCharacterInfo(src)
		if player.job == 'Police' then
        	CancelEvent()
        	local identifier = GetPlayerIdentifiers(number)[1]
            if identifier ~= nil then
            	gsrcheck(source, identifier)
        	end
        else
            TriggerClientEvent("DoLongHudText", Source, "You are not whitelisted to use this command", 2)
    	end
    else
        TriggerClientEvent("DoLongHudText", Source, "Correct Usage Is: /gsr (player id)", 1)
    end
end)

AddEventHandler('playerDropped', function(source)
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        gsrData[identifier] = nil
    end
end)

RegisterNetEvent("GSR:Remove")
AddEventHandler("GSR:Remove", function()
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        gsrData[identifier] = nil
    end
end)

RegisterServerEvent('GSR:SetGSR')
AddEventHandler('GSR:SetGSR', function()
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    gsrData[identifier] = os.time(os.date("!*t")) + Config.gsrTime
end)

function gsrcheck(source, identifier)
    local Source = source
    local identifier = identifier
	if Config.UseCharName then
        Wait(100)
        print('ok')
		-- local fullName = string.format("%s %s", nameData.first_name, nameData.last_name)
		if gsrData[identifier] ~= nil then
            TriggerClientEvent("DoLongHudText", Source, 'Test comes back POSITIVE (Has Shot)')
    	else
            TriggerClientEvent("DoLongHudText", Source, 'Test comes back NEGATIVE (Has Not Shot)')
    	end
	else
    	if gsrData[identifier] ~= nil then
            TriggerClientEvent("DoLongHudText", Source, 'Test comes back POSITIVE (Has Shot)')
    	else
            TriggerClientEvent("DoLongHudText", Source, 'Test comes back NEGATIVE (Has Not Shot)')
    	end
	end
end

RegisterServerEvent('GSR:Status2')
AddEventHandler('GSR:Status2', function(playerid)
    local Source = source
    local identifier = GetPlayerIdentifiers(playerid)[1]
    if Config.UseCharName then
		-- local nameData = getIdentity(identifier)
		Wait(100)
		-- local fullName = string.format("%s %s", nameData.first_name, nameData.last_name)
        if gsrData[identifier] ~= nil then
            TriggerClientEvent("notification", Source, 'Test comes back POSITIVE (Has Shot)')
		
        else
            TriggerClientEvent("notification", Source, 'Test comes back NEGATIVE (Has Not Shot)')
    	end
	else
    	if gsrData[identifier] ~= nil then
            TriggerClientEvent("notification", Source, 'Test comes back POSITIVE (Has Shot)')
    	else
            TriggerClientEvent("notification", Source, 'Test comes back NEGATIVE (Has Not Shot)')
    	end
	end
end)

RegisterServerEvent('GSR:Status')
AddEventHandler('GSR:Status', function(source, cb)
    local Source = source
    local identifier = GetPlayerIdentifiers(Source)[1]
    if gsrData[identifier] ~= nil then
        if cb ~= nil then
            cb(true)
        end
    else
        if cb ~= nil then
            cb(false)
        end
    end
end)

function removeGSR()
    for k, v in pairs(gsrData) do
        if v <= os.time(os.date("!*t")) then
            gsrData[k] = nil
        end
    end
end

function gsrTimer()
    removeGSR()
    SetTimeout(Config.gsrAutoRemove, gsrTimer)
end

gsrTimer()
