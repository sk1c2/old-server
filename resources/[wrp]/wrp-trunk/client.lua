local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }

local player = PlayerPedId()
local inside = false

function DrawText3DTest(x,y,z, text)
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

function CamTrunk()
    if(not DoesCamExist(cam)) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
        SetCamRot(cam, 0.0, 0.0, 0.0)
        SetCamActive(cam,  true)
        RenderScriptCams(true,  false,  0,  true,  true)
        SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
    end
    AttachCamToEntity(cam, PlayerPedId(), 0.0,-2.5,1.0, true)
    SetCamRot(cam, -30.0, 0.0, GetEntityHeading(PlayerPedId()) )
end

local offsets = {
	[1] = { ["name"] = "vic", ["yoffset"] = 0.0, ["zoffset"] = -0.5 },
	[2] = { ["name"] = "taxi", ["yoffset"] = 0.0, ["zoffset"] = -0.5 },
    [3] = { ["name"] = "buccaneer", ["yoffset"] = 0.5, ["zoffset"] = 0.0 },
    [4] = { ["name"] = "peyote", ["yoffset"] = 0.35, ["zoffset"] = -0.15 },
    [5] = { ["name"] = "regina", ["yoffset"] = 0.2, ["zoffset"] = -0.35 },
    [6] = { ["name"] = "pigalle", ["yoffset"] = 0.2, ["zoffset"] = -0.15 },
    [7] = { ["name"] = "glendale", ["yoffset"] = 0.0, ["zoffset"] = -0.35 },
}

RegisterNetEvent('trunkgetinlol')
AddEventHandler('trunkgetinlol', function()
	player = PlayerPedId()
	local plyCoords = GetEntityCoords(player, false)
	--local vehicle = VehicleInFront()
	local lockStatus = GetVehicleDoorLockStatus(vehicle)
	coordA = GetEntityCoords(player, 1)
    coordB = GetOffsetFromEntityInWorldCoords(player, 0.0, 100.0, 0.0)
	vehicle = getVehicleInDirection(coordA, coordB)
	local OffSet = TrunkOffset(vehicle)
	if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and not inside and GetVehiclePedIsIn(player, false) == 0 then
		if lockStatus == 4 or lockStatus == 2 then
			TriggerEvent('DoLongHudText', 'This vehicle is locked', 2)
		elseif GetVehicleDoorAngleRatio(vehicle, 5) ~= 0.0 then
			inside = true
			local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
			if OffSet > 0 then
				AttachEntityToEntity(player, vehicle, 0, -0.1,(d1["y"]+0.85) + offsets[OffSet]["yoffset"],(d2["z"]-0.87) + offsets[OffSet]["zoffset"], 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
			else
				AttachEntityToEntity(player, vehicle, 0, -0.1,d1["y"]+0.85,d2["z"]-0.87, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
			end
			local testdic = "fin_ext_p1-7"
        	local testanim = "cs_devin_dual-7"
			SetBlockingOfNonTemporaryEvents(player, true)      
        	SetPedSeeingRange(player, 0.0)     
       		SetPedHearingRange(player, 0.0)        
        	SetPedFleeAttributes(player, 0, false)     
        	SetPedKeepTask(player, true)
			ClearPedTasks(player)
			RequestAnimDict('fin_ext_p1-7')
			while not HasAnimDictLoaded('fin_ext_p1-7') do
				Citizen.Wait(100)
			end
        	TaskPlayAnim(player, testdic, testanim, 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)	
			if not (IsEntityPlayingAnim(player, 'fin_ext_p1-7', 'cs_devin_dual-7', 3) == 1) then
		    	Streaming('fin_ext_p1-7', function()
					TaskPlayAnim(player, 'fin_ext_p1-7', 'cs_devin_dual-7', 1.0, -1, -1, 49, 0, 0, 0, 0)
		    	end)
			end
		    SetVehicleDoorShut(vehicle, 5, false) 
			while inside do
				Citizen.Wait(1)
				CamTrunk()
		    	car = GetEntityAttachedTo(player)
		    	carxyz = GetEntityCoords(car, 0)
		   		local visible = true
		   		DisableAllControlActions(0)
		   		DisableAllControlActions(1)
				DisableAllControlActions(2)
				EnableControlAction(0, Keys['F'], true)
		   		EnableControlAction(0, 0, true) --- V - camera
		   		EnableControlAction(0, 249, true) --- N - push to talk	
		   		EnableControlAction(2, 1, true) --- camera moving
		   		EnableControlAction(2, 2, true) --- camera moving	
		   		EnableControlAction(0, 177, true) --- BACKSPACE
				EnableControlAction(0, 200, true) --- ESC
				local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
            	local DropPosition = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]-0.2,0.0)
            	if DropPosition["x"] == 0.0 then
                	local vehCoords = GetEntityCoords(PlayerPedId())
                	DrawText3DTest(vehCoords.x, vehCoords.y, vehCoords.z, "[G] Open/Close | [F] Climb Out")
            	else
                	DrawText3DTest(DropPosition["x"],DropPosition["y"],DropPosition["z"],"[G] Open/Close | [F] Climb Out")
            	end
					
				

				if IsDisabledControlJustReleased(0,47) then

					if GetVehicleDoorAngleRatio(vehicle, 5) > 0.0 then
						SetVehicleDoorShut(vehicle, 5, 1, true)
							
					else
						SetVehicleDoorOpen(vehicle, 5, 1, true)
						Citizen.Wait(500)
						SetVehicleDoorOpen(vehicle, 5, 1, true)
							
					end
						
				end
                    
                
           	 	if IsControlJustReleased(0,23) then
                	DetachEntity(player)
					ClearPedTasks(player)	
					CamDisable()  
		    		inside = false		
		   			ClearAllHelpMessages()
				end
			end
			DoScreenFadeOut(10)
       		Citizen.Wait(1000)
        	CamDisable()
        
			DetachEntity(player)

			if DoesEntityExist(vehicle) then
				local DropPosition = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]-0.5,0.0)
				SetEntityCoords(player,DropPosition["x"],DropPosition["y"],DropPosition["z"])
			end
			SetVehicleDoorOpen(vehicle, 5, false)
			DoScreenFadeIn(2000)
		else
			TriggerEvent('DoLongHudText', 'The trunk is closed?!', 2)
		end
	end
end)

RegisterCommand('trunkgetin', function()
	player = PlayerPedId()
	local plyCoords = GetEntityCoords(player, false)
	--local vehicle = VehicleInFront()
	local lockStatus = GetVehicleDoorLockStatus(vehicle)
	coordA = GetEntityCoords(player, 1)
    coordB = GetOffsetFromEntityInWorldCoords(player, 0.0, 100.0, 0.0)
	vehicle = getVehicleInDirection(coordA, coordB)
	local OffSet = TrunkOffset(vehicle)
	if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and not inside and GetVehiclePedIsIn(player, false) == 0 then
		if lockStatus == 4 or lockStatus == 2 then
			TriggerEvent('DoLongHudText', 'This vehicle is locked', 2)
		elseif GetVehicleDoorAngleRatio(vehicle, 5) ~= 0.0 then
			inside = true
			local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
			if OffSet > 0 then
				AttachEntityToEntity(player, vehicle, 0, -0.1,(d1["y"]+0.85) + offsets[OffSet]["yoffset"],(d2["z"]-0.87) + offsets[OffSet]["zoffset"], 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
			else
				AttachEntityToEntity(player, vehicle, 0, -0.1,d1["y"]+0.85,d2["z"]-0.87, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
			end
			local testdic = "fin_ext_p1-7"
        	local testanim = "cs_devin_dual-7"
			SetBlockingOfNonTemporaryEvents(player, true)      
        	SetPedSeeingRange(player, 0.0)     
       		SetPedHearingRange(player, 0.0)        
        	SetPedFleeAttributes(player, 0, false)     
        	SetPedKeepTask(player, true)
			ClearPedTasks(player)
			RequestAnimDict('fin_ext_p1-7')
			while not HasAnimDictLoaded('fin_ext_p1-7') do
				Citizen.Wait(100)
			end
        	TaskPlayAnim(player, testdic, testanim, 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)	
			if not (IsEntityPlayingAnim(player, 'fin_ext_p1-7', 'cs_devin_dual-7', 3) == 1) then
		    	Streaming('fin_ext_p1-7', function()
					TaskPlayAnim(player, 'fin_ext_p1-7', 'cs_devin_dual-7', 1.0, -1, -1, 49, 0, 0, 0, 0)
		    	end)
			end
		    SetVehicleDoorShut(vehicle, 5, false) 
			while inside do
				Citizen.Wait(1)
				CamTrunk()
		    	car = GetEntityAttachedTo(player)
		    	carxyz = GetEntityCoords(car, 0)
		   		local visible = true
		   		DisableAllControlActions(0)
		   		DisableAllControlActions(1)
				DisableAllControlActions(2)
				EnableControlAction(0, Keys['F'], true)
		   		EnableControlAction(0, 0, true) --- V - camera
		   		EnableControlAction(0, 249, true) --- N - push to talk	
		   		EnableControlAction(2, 1, true) --- camera moving
		   		EnableControlAction(2, 2, true) --- camera moving	
		   		EnableControlAction(0, 177, true) --- BACKSPACE
				EnableControlAction(0, 200, true) --- ESC
				local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
            	local DropPosition = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]-0.2,0.0)
            	if DropPosition["x"] == 0.0 then
                	local vehCoords = GetEntityCoords(PlayerPedId())
                	DrawText3DTest(vehCoords.x, vehCoords.y, vehCoords.z, "[G] Open/Close | [F] Climb Out")
            	else
                	DrawText3DTest(DropPosition["x"],DropPosition["y"],DropPosition["z"],"[G] Open/Close | [F] Climb Out")
            	end
					
				

				if IsDisabledControlJustReleased(0,47) then

					if GetVehicleDoorAngleRatio(vehicle, 5) > 0.0 then
						SetVehicleDoorShut(vehicle, 5, 1, true)
							
					else
						SetVehicleDoorOpen(vehicle, 5, 1, true)
						Citizen.Wait(500)
						SetVehicleDoorOpen(vehicle, 5, 1, true)
							
					end
						
				end
                    
                
           	 	if IsControlJustReleased(0,23) then
                	DetachEntity(player)
					ClearPedTasks(player)	
					CamDisable()  
		    		inside = false		
		   			ClearAllHelpMessages()
				end
			end
			DoScreenFadeOut(10)
       		Citizen.Wait(1000)
        	CamDisable()
        
			DetachEntity(player)

			if DoesEntityExist(vehicle) then
				local DropPosition = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]-0.5,0.0)
				SetEntityCoords(player,DropPosition["x"],DropPosition["y"],DropPosition["z"])
			end
			SetVehicleDoorOpen(vehicle, 5, false)
			DoScreenFadeIn(2000)
		else
			TriggerEvent('DoLongHudText', 'The trunk is closed?!', 2)
		end
	end
end)

function TrunkOffset(veh)
    for i=1,#offsets do
        if GetEntityModel(veh) == GetHashKey(offsets[i]["name"]) then
            return i
        end
    end
    return 0
end

function getVehicleInDirection(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle

	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		
		offset = offset - 1

		if vehicle ~= 0 then break end
	end
	
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	
	if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

function Streaming(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
	end

	if cb ~= nil then
		cb()
	end
end

isInTrunk = function()
	if inside == true then
		return true
	elseif inside == false then
		return false
	end
end	

function CamDisable()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
end

function VehicleInFront()
    local pos = GetEntityCoords(player)
    local entityWorld = GetOffsetFromEntityInWorldCoords(player, 0.0, 6.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, player, 0)
    local _, _, _, _, result = GetRaycastResult(rayHandle)
    return result
end