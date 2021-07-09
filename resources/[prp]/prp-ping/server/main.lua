cid = nil
RegisterNetEvent('prp-ping:getcid')
AddEventHandler('prp-ping:getcid', function(cid)
	cid = cid
end)

tSrc = nil

-- function getIdentity(source)
--  	local identifier = GetPlayerIdentifiers(source)[1]
--  	TriggerEvent('prp-ping:getcid', cid)
--  	local id = cid
--  	local result = MySQL.Sync.fetchAll("SELECT * FROM __characters WHERE id = @id", {['@id'] = id})
--  	if result[1] ~= nil then
--  		local identity = result[1]

--  		return {
--  			id = identity['id'],
--  			firstname = identity['first_name'],
--  			lastname = identity['last_name'],
--  			dateofbirth = identity['dob'],
--  			sex = identity['gender']

--  		}
--  	else
--  		return nil
--  	end
--  end

RegisterCommand('ping', function(source, args, rawCommand)
    -- local name = getIdentity(source)
	if args[1] ~= nil then
        if args[1]:lower() == 'accept' then
            TriggerClientEvent('prp-ping:client:AcceptPing', source)
        elseif args[1]:lower() == 'reject' then
            TriggerClientEvent('prp-ping:client:RejectPing', source)
        else
            tSrc = tonumber(args[1])
            if source ~= tSrc then
                TriggerClientEvent('prp-ping:client:SendPing', tSrc, 'ID:' ..tSrc , source)
            else
                TriggerClientEvent('DoLongHudText', source, 'Can\'t Ping Yourself', 1)
            end
        end
    end
end, false)

RegisterServerEvent('prp-ping:server:SendPingResult')
AddEventHandler('prp-ping:server:SendPingResult', function(id, result)
    -- local name = getIdentity(source)
	if result == 'accept' then
		TriggerClientEvent('DoLongHudText', id, 'ID: ' .. tSrc .. "'s Accepted Your Ping", 1)
	elseif result == 'reject' then
		TriggerClientEvent('DoLongHudText', id, 'ID: ' .. tSrc .. "'s Rejected Your Ping", 1)
	elseif result == 'timeout' then
		TriggerClientEvent('DoLongHudText', id, 'ID: ' .. tSrc .. "'s Did Not Accept Your Ping", 1)
	elseif result == 'unable' then
		TriggerClientEvent('DoLongHudText', id, 'ID: ' .. tSrc .. "'s Was Unable To Receive Your Ping", 1)
	elseif result == 'received' then
		TriggerClientEvent('DoLongHudText', id, 'You Sent A Ping To ID:' .. tSrc .. '.', 1)
	end
end)
