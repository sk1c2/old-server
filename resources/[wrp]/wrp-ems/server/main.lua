local playersHealing = {}

RegisterServerEvent('wrp-ambulancejob:revive')
AddEventHandler('wrp-ambulancejob:revive', function(data, target)

	if Player.job == 'EMS' then
		xPlayer.addMoney(Config.ReviveReward)
		TriggerClientEvent('admin:revivePlayerClient', target)
	else
	end
end)

RegisterServerEvent('wrp-ambulancejob:revivePD')
AddEventHandler('wrp-ambulancejob:revivePD', function(data, target)
	local Player = data

	if Player.job == 'Police' then
		TriggerClientEvent('admin:revivePlayerClient', target)
	else
	end
end)

RegisterServerEvent('admin:revivePlayer')
AddEventHandler('admin:revivePlayer', function(target)
	if target ~= nil then
		TriggerClientEvent('admin:revivePlayerClient', target)
		TriggerClientEvent('wrp-hospital:client:RemoveBleed', target) 
        TriggerClientEvent('wrp-hospital:client:ResetLimbs', target)
	end
end)

RegisterServerEvent('admin:healPlayer')
AddEventHandler('admin:healPlayer', function(target)
	if target ~= nil then
		TriggerClientEvent('urp_basicneeds:healPlayer', target)
	end
end)

RegisterServerEvent('wrp-ambulancejob:heal')
AddEventHandler('wrp-ambulancejob:heal', function(target, type)

	TriggerClientEvent('wrp-ambulancejob:heal', target, type)

	TriggerClientEvent('wrp-hospital:client:RemoveBleed', target) 	
	TriggerClientEvent('wrp-ambulancejob:heal', target, type)
	--TriggerClientEvent('MF_SkeletalSystem:HealBones', target, "all")
	TriggerClientEvent('wrp-hospital:client:RemoveBleed', target) 
	TriggerClientEvent('wrp-hospital:client:ResetLimbs', target)
end)

RegisterServerEvent('wrp-ambulancejob:putInVehicle')
AddEventHandler('wrp-ambulancejob:putInVehicle', function(data, target)

	if Player.job == 'EMS' then
		TriggerClientEvent('wrp-ambulancejob:putInVehicle', target)
	else
	end
end)

RegisterServerEvent('wrp-ambulancejob:pullOutVehicle')
AddEventHandler('wrp-ambulancejob:pullOutVehicle', function(data, target)

	if Player.job == 'EMS' then
		TriggerClientEvent('wrp-ambulancejob:pullOutVehicle', target)
	end
end)

RegisterServerEvent('wrp-ambulancejob:drag')
AddEventHandler('wrp-ambulancejob:drag', function(data, target)
	_source = source
	if Player.job == 'EMS' then
		TriggerClientEvent('wrp-ambulancejob:drag', target, _source)
	else
	end
end)

RegisterServerEvent('wrp-ambulancejob:undrag')
AddEventHandler('wrp-ambulancejob:undrag', function(data, target)
	_source = source
	if Player.job == 'EMS' then
		TriggerClientEvent('wrp-ambulancejob:un_drag', target, _source)
	else
	end
end)

function getPriceFromHash(hashKey, jobGrade, type)
	if type == 'helicopter' then
		local vehicles = Config.AuthorizedHelicopters[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = Config.AuthorizedVehicles[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

RegisterServerEvent('wrp-ambulancejob:drag')
AddEventHandler('wrp-ambulancejob:drag', function(target)
	TriggerClientEvent('wrp-ambulancejob:drag', target, source)
end)



