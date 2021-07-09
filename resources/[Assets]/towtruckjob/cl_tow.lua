local currentlyTowedVehicle = nil
towingProcess = false
RegisterNetEvent('asser:tow')
AddEventHandler('asser:tow', function()

	if exports['isPed']:isPed('job') == 'HarmonyRepairs' then
	
		local playerped = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(playerped, true)
		
		local towmodel = GetHashKey('flatbed')
		local isVehicleTow = IsVehicleModel(vehicle, towmodel)
				
		if isVehicleTow then
		
			local coordA = GetEntityCoords(playerped, 1)
			local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
			local targetVehicle = getVehicleInDirection(coordA, coordB)
			
			if currentlyTowedVehicle == nil then
				if targetVehicle ~= 0 then
					if not IsPedInAnyVehicle(playerped, true) then
						if vehicle ~= targetVehicle then
							towingProcess = true
							TriggerEvent("animation:tow")
							exports["prp-taskbar"]:taskBar(10000,"Attaching Vehicle to flatbed")
							AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
							currentlyTowedVehicle = targetVehicle
							TriggerEvent("DoLongHudText", "Vehicle successfully attached to towtruck!")
							towingProcess = false
						else
							TriggerEvent("DoLongHudText", "Are you stupid? You cant tow your own towtruck with your own towtruck?")
						end
					end
				else
					TriggerEvent("DoLongHudText", "There are no vehicles to tow")
				end
			else
				towingProcess = true
				TriggerEvent("animation:tow")
				exports["prp-taskbar"]:taskBar(10000,"Detaching Vehicle from flatbed")
				AttachEntityToEntity(currentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
				DetachEntity(currentlyTowedVehicle, true, true)
				currentlyTowedVehicle = nil
				TriggerEvent("DoLongHudText", "The vehicle has been successfully detached!")
				towingProcess = false
			end
		end
	end
	if exports['isPed']:isPed('job') == 'CamelTowing' then
	
		local playerped = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(playerped, true)
		
		local towmodel = GetHashKey('flatbed')
		local isVehicleTow = IsVehicleModel(vehicle, towmodel)
				
		if isVehicleTow then
		
			local coordA = GetEntityCoords(playerped, 1)
			local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
			local targetVehicle = getVehicleInDirection(coordA, coordB)
			
			if currentlyTowedVehicle == nil then
				if targetVehicle ~= 0 then
					if not IsPedInAnyVehicle(playerped, true) then
						if vehicle ~= targetVehicle then
							towingProcess = true
							TriggerEvent("animation:tow")
							exports["prp-taskbar"]:taskBar(10000,"Attaching Vehicle to flatbed")
							AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
							currentlyTowedVehicle = targetVehicle
							TriggerEvent("DoLongHudText", "Vehicle successfully attached to towtruck!")
							towingProcess = false
						else
							TriggerEvent("DoLongHudText", "Are you stupid? You cant tow your own towtruck with your own towtruck?")
						end
					end
				else
					TriggerEvent("DoLongHudText", "There are no vehicles to tow")
				end
			else
				towingProcess = true
				TriggerEvent("animation:tow")
				exports["prp-taskbar"]:taskBar(10000,"Detaching Vehicle from flatbed")
				AttachEntityToEntity(currentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
				DetachEntity(currentlyTowedVehicle, true, true)
				currentlyTowedVehicle = nil
				TriggerEvent("DoLongHudText", "The vehicle has been successfully detached!")
				towingProcess = false
			end
		end
	end
end)

RegisterNetEvent('animation:tow')
AddEventHandler('animation:tow', function()
	towingProcess = true
    local lPed = PlayerPedId()
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
    end
    while towingProcess do

        if not IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then
            ClearPedSecondaryTask(lPed)
            TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        end
        Citizen.Wait(1)
    end
    ClearPedTasks(lPed)
end)

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end
