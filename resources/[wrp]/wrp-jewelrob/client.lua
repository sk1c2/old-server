local leftdoor, rightdoor		= nil, nil
local HasAlreadyEnteredArea 	= false
local IsAbleToRob				= false
local policeclosed				= false
local IsBusy, HasNotified		= false, false
local CopsOnline 				= 0
local shockingevent 			= false
job = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		job = exports['isPed']:isPed('job')
		TriggerServerEvent('wrp-jewelrob:getjob', job)
	end
end)

RegisterNetEvent('wrp-jewelrobbery:policeclosure')
AddEventHandler('wrp-jewelrobbery:policeclosure', function()
	policeclosed = true
	storeclosed = false
	IsAbleToRob = false
end)

RegisterNetEvent('wrp-jewelrobbery:resetcases')
AddEventHandler('wrp-jewelrobbery:resetcases', function(list)
	if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -622.2496, -230.8000, 38.05705, true)  < 20.0  then
		for i, v in pairs(Config.CaseLocations) do
			if v.Broken then
				RemoveModelSwap(v.Pos.x, v.Pos.y, v.Pos.z, 0.1, GetHashKey(v.Prop1), GetHashKey(v.Prop), false )
			end
		end
	end
	Config.CaseLocations = list
	HasNotified = false
	policeclosed = false
	storeclosed = false
	IsAbleToRob = false
	HasAlreadyEnteredArea = false
end)



RegisterNetEvent('wrp-jewelrobbery:setcase')
AddEventHandler('wrp-jewelrobbery:setcase', function(casenumber, switch)
	Config.CaseLocations[casenumber].Broken = switch
	HasAlreadyEnteredArea = false
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z, currentStreetHash, intersectStreetHash)
		currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
		intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
	end
end)


RegisterNetEvent('wrp-jewelrobbery:loadconfig')
AddEventHandler('wrp-jewelrobbery:loadconfig', function(casestatus)
	while not DoesEntityExist(GetPlayerPed(-1)) do
		Citizen.Wait(100)
	end
	Config.CaseLocations = casestatus
	if GetDistanceBetweenCoords(plyloc, -622.2496, -230.8000, 38.05705, true)  < 20.0 then
		for i, v in pairs(Config.CaseLocations) do
			if v.Broken then
				CreateModelSwap(v.Pos.x, v.Pos.y, v.Pos.z, 0.1, GetHashKey(v.Prop1), GetHashKey(v.Prop), false )
			end
		end
	end
end)


RegisterNetEvent('wrp-jewelrobbery:playsound')
AddEventHandler('wrp-jewelrobbery:playsound', function(x,y,z, soundtype)
	ply = GetPlayerPed(-1)
	plyloc = GetEntityCoords(ply)
	if GetDistanceBetweenCoords(plyloc,x,y,z,true) < 20.0 then
		if soundtype == 'break' then
			PlaySoundFromCoord(-1, "Glass_Smash", x,y,z, 0, 0, 0)
		elseif soundtype == 'nonbreak' then
			PlaySoundFromCoord(-1, "Drill_Pin_Break", x,y,z, "DLC_HEIST_FLEECA_SOUNDSET", 0, 0, 0)
		end
	end
end)


AddEventHandler('wrp-jewelrobbery:EnteredArea', function()
	for i, v in pairs(Config.CaseLocations) do
		if v.Broken then
			CreateModelSwap(v.Pos.x, v.Pos.y, v.Pos.z, 0.1, GetHashKey(v.Prop1), GetHashKey(v.Prop), false )
		end
	end
end)

AddEventHandler('wrp-jewelrobbery:LeftArea', function()
	for i, v in pairs(Config.CaseLocations) do
		if v.Broken then
			RemoveModelSwap(v.Pos.x, v.Pos.y, v.Pos.z, 0.1, GetHashKey(v.Prop1), GetHashKey(v.Prop), false )
		end
	end
end)

function UnAuthJob()
	local UnAuthjob = false
	for i,v in pairs(Config.UnAuthJobs) do
		if job == v then
			UnAuthjob = true
			break
		end
	end

	return UnAuthjob
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


Citizen.CreateThread( function()
	while true do 
		ply = GetPlayerPed(-1)
		plyloc = GetEntityCoords(ply)
		IsInArea = false
		
		if GetDistanceBetweenCoords(plyloc, -622.2496, -230.8000, 38.05705, true)  < 20.0 then
			IsInArea = true
		end
		
		if IsInArea and not HasAlreadyEnteredArea then
			TriggerEvent('wrp-jewelrobbery:EnteredArea')
			shockingevent = false
			if Config.Closed and not (CheckPolice() >= Config.MinPolice) and not policeclosed then
				leftdoor = GetClosestObjectOfType(-631.9554, -236.3333, 38.20653, 11.0, GetHashKey("p_jewel_door_l"), false, false, false)
				rightdoor = GetClosestObjectOfType(-631.9554, -236.3333, 38.20653, 11.0, GetHashKey("p_jewel_door_r1"), false, false, false)			
				ClearAreaOfPeds(-622.2496, -230.8000, 38.05705, 10.0, 1)
				storeclosed = true
				HasNotified = false
			else
				leftdoor = GetClosestObjectOfType(-631.9554, -236.3333, 38.20653, 11.0, GetHashKey("p_jewel_door_l"), false, false, false)
				rightdoor = GetClosestObjectOfType(-631.9554, -236.3333, 38.20653, 11.0, GetHashKey("p_jewel_door_r1"), false, false, false)			
				storeclosed = false
				Citizen.Wait(100)
				freezedoors(false)
				IsAbleToRob = true
			
			end
			HasAlreadyEnteredArea = true
		end

		if not IsInArea and HasAlreadyEnteredArea then
			TriggerEvent('wrp-jewelrobbery:LeftArea')
			HasAlreadyEnteredArea = false
			shockingevent = false
			IsAbleToRob = false
			storeclosed = false
			HasNotified = false
		end
		
		if Config.Closed and not (CheckPolice() >= Config.MinPolice) and not storeclosed and not policeclosed then
			Citizen.Wait(1250)
		else
			Citizen.Wait(3250)
		end
	end
end)

function CheckPolice()
	if CopsOnline ~= 100 then
		HasAlreadyEnteredArea = false
	end
	CopsOnline = 100
	return 100
end

function freezedoors(status)
	FreezeEntityPosition(leftdoor, status)
	FreezeEntityPosition(rightdoor, status)
end


Citizen.CreateThread( function()
	while true do 
		sleep = 1500
		while IsAbleToRob and not UnAuthJob() and (CheckPolice() >= Config.MinPolice) do
			Citizen.Wait(0)
			sleep = 0
			ply = GetPlayerPed(-1)
			plyloc = GetEntityCoords(ply)
			for i, v in pairs(Config.CaseLocations) do
				if GetDistanceBetweenCoords(plyloc, v.Pos.x, v.Pos.y, v.Pos.z, true) < 1.0  and not v.Broken and not IsBusy then
					local robalbe = false
					local _, weaponname = GetCurrentPedWeapon(ply)
					for index, weapon in pairs (Config.AllowedWeapons) do
						if GetHashKey(weapon.name) == weaponname then
							robalbe = weapon
							break 
						end
					end
					if robalbe then	
						DrawText3Ds(v.Pos.x, v.Pos.y, v.Pos.z + 0.5, 'Press ~g~E~w~ to Break')
						if IsControlJustPressed(0, 38) and not IsBusy and not IsPedWalking(ply) and not IsPedRunning(ply) and not IsPedSprinting(ply) then
							local policenotify = math.random(1,100)
							if not shockingevent  then
								AddShockingEventAtPosition(99, v.Pos.x, v.Pos.y, v.Pos.z,25.0)
								shockingevent = true
							end
							IsBusy = true				
							TaskTurnPedToFaceCoord(ply, v.Pos.x, v.Pos.y, v.Pos.z, 1250)
							Citizen.Wait(1250)
							if not HasAnimDictLoaded("missheist_jewel") then
								RequestAnimDict("missheist_jewel") 
							end
							while not HasAnimDictLoaded("missheist_jewel") do 
							Citizen.Wait(0)
							end
							TaskPlayAnim(ply, 'missheist_jewel', 'smash_case', 1.0, -1.0,-1,1,0,0, 0,0)
							local breakchance = math.random(1, 100)
							if breakchance <= robalbe.chance then
								if policenotify <= Config.PoliceNotifyBroken and not HasNotified then
									local playerCoords = GetEntityCoords(PlayerPedId())
									TriggerEvent('wrp-dispatch:jewelrobbery')
									HasNotified = true
								end
								Citizen.Wait(2100)
								TriggerServerEvent('wrp-jewelrobbery:playsound', v.Pos.x, v.Pos.y, v.Pos.z, 'break')
								CreateModelSwap(v.Pos.x, v.Pos.y, v.Pos.z,  0.1, GetHashKey(v.Prop1), GetHashKey(v.Prop), false )
								ClearPedTasksImmediately(ply)
								TriggerServerEvent("wrp-jewelrobbery:setcase", i, true)
								TriggerEvent('wrp-dispatch:jewelrobbery')
							else
								Citizen.Wait(2100)
								TriggerServerEvent('wrp-jewelrobbery:playsound', v.Pos.x, v.Pos.y, v.Pos.z, 'nonbreak')
								ClearPedTasksImmediately(ply)
								if policenotify <= Config.PoliceNotifyNonBroken and not HasNotified then
									local playerCoords = GetEntityCoords(PlayerPedId())
									TriggerEvent('wrp-dispatch:jewelrobbery')
									HasNotified = true
								end
							end	
							Citizen.Wait(1250)
							IsBusy = false			
						end
					end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
    Wait(900)
    while true do 
        local player = GetEntityCoords(PlayerPedId())
        local distance = #(vector3(-596.47, -283.96, 50.33) - player)
        if distance < 3.0 then
        	Wait(1)
             DrawMarker(27,-596.47, -283.96, 50.33, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 11, 111, 11, 60, 0, 0, 2, 0, 0, 0, 0) 
             DT(-596.47, -283.96, 50.33, "[E] Use Black G6 Card")
			 if IsControlJustReleased(0,38) and distance < 1.0 then
				if CheckPolice() >= Config.MinPolice then
             		if exports["wrp-inventory"]:hasEnoughOfItem("Gruppe6Card",1,false) then
						TriggerEvent("inventory:removeItem", "Gruppe6Card", 1)
						-- TriggerServerEvent("wrp-doors:alterlockstate",61,false)
						TriggerServerEvent('wrp-doors:ForceLockState', 61, 0)
						TriggerServerEvent('wrp-doors:ForceLockState', 62, 0)
						-- TriggerServerEvent("wrp-doors:alterlockstate",62,false)
					 end
             	end
             end
		else
            Wait(3000)
        end        
    end
end)

function DT(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

--test--