local playersHealing = {}

RegisterServerEvent('prp-ambulancejob:revive')
AddEventHandler('prp-ambulancejob:revive', function(data, target)

	if Player.job == 'EMS' then
		xPlayer.addMoney(Config.ReviveReward)
		TriggerClientEvent('admin:revivePlayerClient', target)
	else
	end
end)

RegisterServerEvent('prp-ambulancejob:revivePD')
AddEventHandler('prp-ambulancejob:revivePD', function(data, target)
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
		TriggerClientEvent('prp-hospital:client:RemoveBleed', target) 
        TriggerClientEvent('prp-hospital:client:ResetLimbs', target)
	end
end)

RegisterServerEvent('admin:healPlayer')
AddEventHandler('admin:healPlayer', function(target)
	if target ~= nil then
		TriggerClientEvent('urp_basicneeds:healPlayer', target)
	end
end)

RegisterServerEvent('prp-ambulancejob:heal')
AddEventHandler('prp-ambulancejob:heal', function(target, type)

	TriggerClientEvent('prp-ambulancejob:heal', target, type)

	TriggerClientEvent('prp-hospital:client:RemoveBleed', target) 	
	TriggerClientEvent('prp-ambulancejob:heal', target, type)
	--TriggerClientEvent('MF_SkeletalSystem:HealBones', target, "all")
	TriggerClientEvent('prp-hospital:client:RemoveBleed', target) 
	TriggerClientEvent('prp-hospital:client:ResetLimbs', target)
end)

RegisterServerEvent('prp-ambulancejob:putInVehicle')
AddEventHandler('prp-ambulancejob:putInVehicle', function(data, target)

	if Player.job == 'EMS' then
		TriggerClientEvent('prp-ambulancejob:putInVehicle', target)
	else
	end
end)

RegisterServerEvent('prp-ambulancejob:pullOutVehicle')
AddEventHandler('prp-ambulancejob:pullOutVehicle', function(data, target)

	if Player.job == 'EMS' then
		TriggerClientEvent('prp-ambulancejob:pullOutVehicle', target)
	end
end)

RegisterServerEvent('prp-ambulancejob:drag')
AddEventHandler('prp-ambulancejob:drag', function(data, target)
	_source = source
	if Player.job == 'EMS' then
		TriggerClientEvent('prp-ambulancejob:drag', target, _source)
	else
	end
end)

RegisterServerEvent('prp-ambulancejob:undrag')
AddEventHandler('prp-ambulancejob:undrag', function(data, target)
	_source = source
	if Player.job == 'EMS' then
		TriggerClientEvent('prp-ambulancejob:un_drag', target, _source)
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

RegisterServerEvent('prp-ambulancejob:drag')
AddEventHandler('prp-ambulancejob:drag', function(target)
	TriggerClientEvent('prp-ambulancejob:drag', target, source)
end)



