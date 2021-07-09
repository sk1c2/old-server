local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local IsBusy = false
local spawnedVehicles, isInShopMenu = {}, false
local IsDragged                 = false
local CopPed                    = 0
local DragStatus = {}
DragStatus.IsDragged = false

RegisterNetEvent('prp-ambulancejob:drag')
AddEventHandler('prp-ambulancejob:drag', function(copID)

	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId     = tonumber(copID)
	local playerPed
	local targetPed
	playerPed = PlayerPedId()

		if DragStatus.IsDragged then
			targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))

			-- undrag if target is in an vehicle
			if not IsPedSittingInAnyVehicle(targetPed) then
				AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			else
			end
				

		else
			DetachEntity(playerPed, true, false)
		end
end)

RegisterNetEvent('prp-ambulancejob:putInVehicle')
AddEventHandler('prp-ambulancejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				if IsDragged then
					IsDragged = not IsDragged
				end
			end
		end
	end
end)

RegisterNetEvent('prp-ambulancejob:pullOutVehicle')
AddEventHandler('prp-ambulancejob:pullOutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

RegisterNetEvent('prp-ambulancejob:drag')
AddEventHandler('prp-ambulancejob:drag', function(cop)
	IsDragged = not IsDragged
	CopPed = tonumber(cop)
end)

RegisterNetEvent('prp-ambulancejob:un_drag')
AddEventHandler('prp-ambulancejob:un_drag', function(cop)
	IsDragged = not IsDragged
	DetachEntity(GetPlayerPed(-1), true, false)
end)




Citizen.CreateThread(function()
	while true do
	  Wait(0)
		if IsDragged then
		  local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
		  local myped = GetPlayerPed(-1)
		  AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		else
		  --DetachEntity(GetPlayerPed(-1), true, false) --Disabled to fix attatching...
		end
	end
  end)

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end

RegisterNetEvent('prp-ambulancejob:heal')
AddEventHandler('prp-ambulancejob:heal', function(target,healType)
    local playerPed = PlayerPedId(target)
    local maxHealth = GetEntityMaxHealth(playerPed)

    local health = GetEntityHealth(playerPed)
    local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 10))
    SetEntityHealth(playerPed, newHealth)
    TriggerEvent('prp-hospital:client:RemoveBleed')

    TriggerEvent('prp-hospital:client:RemoveBleed')
    TriggerEvent('prp-hospital:client:ResetLimbs')
	TriggerEvent('DoLongHudText', 'You have been healed!', 1)
end)

-- RegisterNetEvent('prp-ambulancejob:heal')
-- AddEventHandler('prp-ambulancejob:heal', function(healType)
--     local playerPed = PlayerPedId()
--     local maxHealth = GetEntityMaxHealth(playerPed)

--     if healType == 'small' then
--         local health = GetEntityHealth(playerPed)
--         local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 10))
--         SetEntityHealth(playerPed, newHealth)
--         TriggerEvent('prp-hospital:client:RemoveBleed')
-- 	elseif healType == 'big' then
-- 		local health = GetEntityHealth(playerPed)
--         local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 10))
--         SetEntityHealth(playerPed, newHealth)
--         TriggerEvent('prp-hospital:client:RemoveBleed')
--         TriggerEvent('prp-hospital:client:ResetLimbs')
--     end

-- 	TriggerEvent('DoLongHudText', 'You have been healed!')
-- end)

function GetPlayers() -- function to get players
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

GetClosestPlayer = function()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end

RegisterNetEvent("tp:emsRevive")
AddEventHandler("tp:emsRevive", function()

    local closestPlayer, closestDistance = GetClosestPlayer()

    if closestPlayer == -1 or closestDistance > 2.0 then
		TriggerEvent('DoLongHudText', 'There is no player(s) nearby!',2)
    else
                    
		local closestPlayerPed = GetPlayerPed(closestPlayer)
	
		if IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_a", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_b", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_c", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_d", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_e", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_f", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_g", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_h", 3)then
			local playerPed = PlayerPedId()
				
			TriggerEvent('DoLongHudText', 'Revive In Progress')
	
				TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				Citizen.Wait(10000)
				ClearPedTasks(playerPed)
				TriggerServerEvent('admin:revivePlayer', GetPlayerServerId(closestPlayer))
				-- TriggerServerEvent('prp-ambulancejob:revive', GetPlayerServerId(closestPlayer))
			if Config.ReviveReward > 0 then
				TriggerEvent('DoLongHudText', 'You have revived '.. GetPlayerName(closestPlayer)..' and earned $'..Config.ReviveReward)
				LocalPlayer = exports['prp-base']:getModule("LocalPlayer")
				Player = LocalPlayer:getCurrentCharacter()
				TriggerServerEvent('prp-business:givepass', 'EMS', math.random(850, 1000))
				LocalPlayer:addCash(Player.id, math.random(500, 650))
			else
				TriggerEvent('DoLongHudText', 'You have successfully revived player')
			end
		else
			TriggerEvent('DoLongHudText', 'Player is conscious please take them to pillbox to get further treatment!', 2)
		end
    end
end)

RegisterNetEvent("tp:pdrevive")
AddEventHandler("tp:pdrevive", function()

    local closestPlayer, closestDistance = GetClosestPlayer()

    if closestPlayer == -1 or closestDistance > 2.0 then
		TriggerEvent('DoLongHudText', 'There is no player(s) nearby!',2)
    else
                    
		local closestPlayerPed = GetPlayerPed(closestPlayer)
	
		if IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_a", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_b", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_c", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_d", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_e", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_f", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_g", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_h", 3)then
			local playerPed = PlayerPedId()
				
			TriggerEvent('DoLongHudText', 'Revive In Progress')
	
				TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				Citizen.Wait(10000)
				ClearPedTasks(playerPed)
				TriggerServerEvent('admin:revivePlayer', GetPlayerServerId(closestPlayer))
				TriggerEvent('prp-hospital:client:FinishServices')
				-- TriggerServerEvent('prp-ambulancejob:revive', GetPlayerServerId(closestPlayer))
	
			if 1 + 1 > 0 then
				TriggerEvent('DoLongHudText', 'You have revived '.. GetPlayerName(closestPlayer)..' !')
			else
				TriggerEvent('DoLongHudText', 'You have successfully revived player')
			end
		else
			TriggerEvent('DoLongHudText', 'Player is conscious please take them to pillbox to get further treatment!', 2)
		end
    end
end)

-- RegisterCommand('cure', function()
--     local closestPlayer, closestDistance = GetClosestPlayer()

--     if closestPlayer == -1 or closestDistance > 2.0 then
-- 		TriggerEvent('DoLongHudText', 'There is no player(s) nearby!',2)
--     else
                    
--     local closestPlayerPed = GetPlayerPed(closestPlayer)
 
--     if IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_a", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_b", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_c", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_d", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_e", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_f", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_g", 3) or IsEntityPlayingAnim(closestPlayerPed, "dead", "dead_h", 3)then
--         local playerPed = PlayerPedId()
               
--         TriggerEvent('DoLongHudText', 'Cure In Progress')
 
--             TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
--             Citizen.Wait(10000)
--             ClearPedTasks(playerPed)
 
-- 			TriggerServerEvent('admin:revivePlayer', GetPlayerServerId(closestPlayer))
 
--         if Config.ReviveReward > 0 then
--             TriggerEvent('DoLongHudText', 'You have revived '.. GetPlayerName(closestPlayer)..' and earned $'..Config.ReviveReward)
--         else
--             TriggerEvent('DoLongHudText', 'You have successfully revived player')
--         end
--     else
--         TriggerEvent('DoLongHudText', 'Player is conscious please take them to pillbox to get further treatment!',2)
--         end
--     end
-- end)

RegisterNetEvent("tp:emssmallheal")
AddEventHandler('tp:emssmallheal', function()
	IsBusy = false
    local closestPlayer, closestDistance = GetClosestPlayer()

    if closestPlayer == -1 or closestDistance > 2.0 then
        TriggerEvent('DoLongHudText', 'There is no player(s) nearby!', 2)
	else
					
    		IsBusy = true

			local closestPlayerPed = GetPlayerPed(closestPlayer)
			local health = GetEntityHealth(closestPlayerPed)

			if health > 0 then
				local playerPed = PlayerPedId()
	
				IsBusy = true
				TriggerEvent('DoLongHudText', 'Small Healing In Progress', 1)
				TriggerEvent('prp-hospital:client:RemoveBleed')
				TriggerEvent('prp-hospital:client:ResetLimbs')
				TriggerEvent("animation:PlayAnimation","layspike")
				Citizen.Wait(2000)
				ClearPedTasks(playerPed)
	
				TriggerServerEvent('prp-ambulancejob:heal', GetPlayerServerId(closestPlayer))
	
				TriggerEvent('DoLongHudText', 'You have successfully healed '..GetPlayerName(closestPlayer), 1)
				IsBusy = false
			else
			TriggerEvent('DoLongHudText', 'Player is unconscious please take them to pillbox to get further treatment!', 2)
		end
	end
end)


-- RegisterNetEvent("tp:emssmallheal")
-- AddEventHandler("tp:emssmallheal", function()
-- 	if IsBusy then return end

--     local closestPlayer, closestDistance = GetClosestPlayer()

--     if closestPlayer == -1 or closestDistance > 2.0 then
--         TriggerEvent('DoLongHudText', 'There is no player(s) nearby!',2)
-- 	else
					
--     		IsBusy = true
 
-- 			local closestPlayerPed = GetPlayerPed(closestPlayer)
-- 			local health = GetEntityHealth(closestPlayerPed)

-- 			if health > 0 then
-- 				local playerPed = PlayerPedId()
	
-- 				IsBusy = true
-- 				TriggerEvent('DoLongHudText', 'Small Healing In Progress')
-- 				TriggerEvent("animation:PlayAnimation","layspike")
-- 				Citizen.Wait(2000)
-- 				ClearPedTasks(playerPed)
	
-- 				TriggerEvent('prp-hospital:items:healplayer')
-- 				Citizen.Wait(1000)
-- 				TriggerEvent('prp-hospital:items:healplayer')
				
-- 				TriggerEvent('DoLongHudText', 'You have successfully healed player')
-- 				IsBusy = false
-- 			else
-- 				TriggerEvent('DoLongHudText', 'Player is unconscious please take them to pillbox to get further treatment!',2)
-- 			end
-- 	end
-- end)

RegisterCommand('healsmall', function()
	if exports['isPed']:isPed('job') == 'EMS' then
    	local closestPlayer, closestDistance = GetClosestPlayer()
		IsBusy = false

    	if closestPlayer == -1 or closestDistance > 2.0 then
        TriggerEvent('DoLongHudText', 'There is no player(s) nearby!', 2)
		else
					
    			IsBusy = true

				local closestPlayerPed = GetPlayerPed(closestPlayer)
				local health = GetEntityHealth(closestPlayerPed)

				if health > 0 then
					local playerPed = PlayerPedId()
	
					IsBusy = true
					TriggerEvent('DoLongHudText', 'Small Healing In Progress', 1)
					TriggerEvent('prp-hospital:client:RemoveBleed')
					TriggerEvent('prp-hospital:client:ResetLimbs')
					TriggerEvent("animation:PlayAnimation","layspike")
					Citizen.Wait(2000)
					ClearPedTasks(playerPed)
	
					TriggerServerEvent('prp-ambulancejob:heal', GetPlayerServerId(closestPlayer))
	
					TriggerEvent('DoLongHudText', 'You have successfully healed '..GetPlayerName(closestPlayer), 1)
					IsBusy = false
				else
					TriggerEvent('DoLongHudText', 'Player is unconscious please take them to pillbox to get further treatment!', 2)
				end
			end
	end
end)

RegisterNetEvent("tp:emsbigheal")
AddEventHandler("tp:emsbigheal", function()
	if exports['isPed']:isPed('job') == 'EMS' then
		IsBusy = false
					local closestPlayer, closestDistance = GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 2.0 then
						TriggerEvent('DoLongHudText', 'There is no player(s) nearby!',2)
					else
						
		IsBusy = true
	
				local closestPlayerPed = GetPlayerPed(closestPlayer)
				local health = GetEntityHealth(closestPlayerPed)

				if health > 0 then
					local playerPed = PlayerPedId()
		
					IsBusy = true
					TriggerEvent('DoLongHudText', 'Big Healing In Progress')
					TriggerEvent('prp-hospital:client:RemoveBleed')
					TriggerEvent('prp-hospital:client:ResetLimbs')
					TriggerEvent("animation:PlayAnimation","layspike")
					Citizen.Wait(2000)
					ClearPedTasks(playerPed)
		
					TriggerEvent('prp-hospital:client:FinishServices')
		
					TriggerEvent('DoLongHudText', 'You have successfully healed player')
					IsBusy = false
				else
					TriggerEvent('DoLongHudText', 'Player is unconscious please take them to pillbox to get further treatment!',2)
				end
			end
		end
end)

RegisterCommand('healbig', function()
	if exports['isPed']:isPed('job') == 'EMS' then
		IsBusy = false
					local closestPlayer, closestDistance = GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 2.0 then
						TriggerEvent('DoLongHudText', 'There is no player(s) nearby!',2)
					else
						
		IsBusy = true
	
				local closestPlayerPed = GetPlayerPed(closestPlayer)
				local health = GetEntityHealth(closestPlayerPed)

				if health > 0 then
					local playerPed = PlayerPedId()
		
					IsBusy = true
					TriggerEvent('DoLongHudText', 'Big Healing In Progress')
					TriggerEvent('prp-hospital:client:RemoveBleed')
					TriggerEvent('prp-hospital:client:ResetLimbs')
					TriggerEvent("animation:PlayAnimation","layspike")
					Citizen.Wait(2000)
					ClearPedTasks(playerPed)
		
					TriggerEvent('prp-hospital:client:FinishServices')
		
					TriggerEvent('DoLongHudText', 'You have successfully healed player')
					IsBusy = false
				else
					TriggerEvent('DoLongHudText', 'Player is unconscious please take them to pillbox to get further treatment!',2)
				end
		end
	end
end)

RegisterNetEvent("tp:emsputinvehicle")
AddEventHandler("tp:emsputinvehicle", function()
    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('prp-ambulancejob:putInVehicle', GetPlayerServerId(closestPlayer))
    else
		TriggerEvent('DoLongHudText', 'There is no player(s) nearby!',2)
    end
end)

RegisterNetEvent("tp:emstakeoutvehicle")
AddEventHandler("tp:emstakeoutvehicle", function()
    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('prp-ambulancejob:pullOutVehicle', GetPlayerServerId(closestPlayer))
    else
		TriggerEvent('DoLongHudText', 'There is no player(s) nearby!',2)
    end
end)

RegisterNetEvent("tp:emsdrag")
AddEventHandler("tp:emsdrag", function()
    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('prp-ambulancejob:drag', GetPlayerServerId(closestPlayer))
    else
		TriggerEvent('DoLongHudText', 'There is no player(s) nearby!',2)
    end
end)

RegisterNetEvent("tp:emsundrag")
AddEventHandler("tp:emsundrag", function()
    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('prp-ambulancejob:undrag', GetPlayerServerId(closestPlayer))
    else
		TriggerEvent('DoLongHudText', 'There is no player(s) nearby!',2)
    end
end)