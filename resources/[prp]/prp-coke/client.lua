local PlayerData            = {}
local SelectedID 			= nil
local Goons 				= {}
JobVan = 0

-- Blip Settings:
local DeliveryBlip
local blip
local DeliveryBlipCreated = false

-- Job Settings:
local isVehicleLockPicked = false
local JobVanPlate = ''
local DeliveryInProgress = false
local InsideJobVan = false
local vanIsDelivered = false

-- Delivery Stage:
local NearJobVehicle = false
local NearOtherVehicle = false
local drugsTaken = false
local drugBoxInHand = false

-- Drug Sale Settings:
local streetName
local _
local canSellDrugs = false
local DrugSellTimer = GetGameTimer() - 2 * 2500

-- Usable Item Event:
RegisterNetEvent("t1ger_drugs:UsableItem")
AddEventHandler("t1ger_drugs:UsableItem",function()
	local player = PlayerPedId()
	if IsPedInAnyVehicle(player) then
		exports["prp-taskbar"]:taskBar(5000,"Decrypting Data",false,false)
		Citizen.Wait(10)
		exports["prp-taskbar"]:taskBar(5000,"Hacking Into Network",false,false,playerVeh)
		Citizen.Wait(10)
		exports["prp-taskbar"]:taskBar(25000,"Uploading Virus",false,false,playerVeh)
	else
		FreezeEntityPosition(player,false)
		TaskStartScenarioInPlace(player, 'WORLD_HUMAN_STAND_MOBILE', 0, true)
		exports["prp-taskbar"]:taskBar(5000,"Decrypting Data",false,false)
		Citizen.Wait(10)
		exports["prp-taskbar"]:taskBar(5000,"Hacking Into Network",false,false)
		Citizen.Wait(10)
		exports["prp-taskbar"]:taskBar(25000,"Uploading Virus",false,false)
	end
	Citizen.Wait(4000)
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start",5,45,0,HackingMinigame)
end)

-- Function for Hacking Success/Fail:
function HackingMinigame(success)
    local player = PlayerPedId()
    TriggerEvent('mhacking:hide')
    if success then
		Citizen.Wait(350)
		ChooseDrugMenu()
		TriggerEvent('DoLongHudText', "You successfully hacked into the network")
		FreezeEntityPosition(player,false)
		ClearPedTasks(player)
    else
		TriggerEvent('DoLongHudText', "You failed to hack into the network")
		FreezeEntityPosition(player,false)
		ClearPedTasks(player)
	end
end

-- Function for Drugs Choose Menu:
function ChooseDrugMenu()
	local player = PlayerPedId()
	TriggerServerEvent("t1ger_drugs:GetSelectedJob", 'coke', 5000, 1, 3, exports['isPed']:isPed('cash'))
end

-- Event to browse through available locations:
RegisterNetEvent("t1ger_drugs:BrowseAvailableJobs")
AddEventHandler("t1ger_drugs:BrowseAvailableJobs",function(spot,drugType,minReward,maxReward)
	local id = math.random(1,#Config.Jobs)
	local currentID = 0
	while Config.Jobs[id].InProgress and currentID < 100 do
		currentID = currentID+1
		id = math.random(1,#Config.Jobs)
	end
	if currentID == 100 then
		TriggerEvent('DoLongHudText', "No coke runs are available, please try again later!")
	else
		SelectedID = id
		TriggerEvent("t1ger_drugs:startMainEvent",id,drugType,minReward,maxReward)
		PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
	end
end)

VanSpawned = false
GoonsSpawned = false
-- Core Mission Part
RegisterNetEvent('t1ger_drugs:startMainEvent')
AddEventHandler('t1ger_drugs:startMainEvent', function(id,drugType,minReward,maxReward)
	local Goons = {}
	local selectedJob = Config.Jobs[id]
	local minRewardD = minReward
	local maxRewardD = maxReward
	local typeDrug = drugType
	selectedJob.InProgress = true
	TriggerServerEvent("t1ger_drugs:syncJobsData",Config.Jobs)
	TriggerEvent("phone:addnotification", "Toby Walter","<b> -- Toby Walter -- <b> <br> Head over to the marker on your GPS to start your snow run! Be aware, they may be a few mad men trying to defend the area. <br>")
	Citizen.Wait(500)
	local playerPed = GetPlayerPed(-1)
	local JobCompleted = false
	local blip = CreateMissionBlip(selectedJob.Spot)
	
	while not JobCompleted and not StopTheJob do
		Citizen.Wait(0)
		
		if Config.Jobs[id].InProgress == true then
		
			local coords = GetEntityCoords(playerPed)
			
            if (GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) > 60) and DeliveryInProgress == false then
				exports['prp-interaction']:showInteraction('Reach the Vehicle marked on your GPS')
			end
			
			if (GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) < 150) and not selectedJob.VanSpawned then
				ClearAreaOfVehicles(selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, 15.0, false, false, false, false, false) 
				local jobCoords = {selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z}
				selectedJob.VanSpawned = true
				TriggerServerEvent("t1ger_drugs:syncJobsData",Config.Jobs)
				Citizen.Wait(500)
				RequestModel(GetHashKey(Config.JobVan))
				while not HasModelLoaded(GetHashKey(Config.JobVan)) do
					Wait(1)
					RequestModel(GetHashKey(Config.JobVan))
				end
				local hash = GetHashKey(Config.JobVan)
				vehicle = CreateVehicle(hash, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, selectedJob.Heading)
					SetEntityCoordsNoOffset(vehicle, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z)
					SetEntityHeading(vehicle,selectedJob.Heading)
					FreezeEntityPosition(vehicle, true)
					SetVehicleOnGroundProperly(vehicle)
					FreezeEntityPosition(vehicle, false)
					JobVan = vehicle
					SetEntityAsMissionEntity(vehicle, true, true)
					SetVehicleDoorsLockedForAllPlayers(vehicle, true)
			end	
			
			if (GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) < 150) and not selectedJob.GoonsSpawned then
				ClearAreaOfPeds(selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, 50, 1)
				selectedJob.GoonsSpawned = true
				TriggerServerEvent("t1ger_drugs:syncJobsData",Config.Jobs)
				Citizen.Wait(500)
				SetPedRelationshipGroupHash(GetPlayerPed(-1), GetHashKey("PLAYER"))
				AddRelationshipGroup('JobNPCs')
				local i = 0
				for k,v in pairs(selectedJob.Goons) do
					RequestModel(GetHashKey(v.ped))
					while not HasModelLoaded(GetHashKey(v.ped)) do
						Wait(1)
					end
					Goons[i] = CreatePed(4, GetHashKey(v.ped), v.x, v.y, v.z, v.h, false, true)
					NetworkRegisterEntityAsNetworked(Goons[i])
					SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(Goons[i]), true)
					SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(Goons[i]), true)
					SetPedCanSwitchWeapon(Goons[i], true)
					SetPedArmour(Goons[i], 100)
					SetPedAccuracy(Goons[i], 60)
					SetEntityInvincible(Goons[i], false)
					SetEntityVisible(Goons[i], true)
					SetEntityAsMissionEntity(Goons[i])
					RequestAnimDict(v.animDict) 
					while not HasAnimDictLoaded(v.animDict) do
						Citizen.Wait(0) 
					end 
					TaskPlayAnim(Goons[i], v.animDict, v.anim, 8.0, -8, -1, 49, 0, 0, 0, 0)
					GiveWeaponToPed(Goons[i], GetHashKey(v.weapon), 255, false, false)
					SetPedDropsWeaponsWhenDead(Goons[i], false)
					SetPedFleeAttributes(Goons[i], 0, false)	
					SetPedRelationshipGroupHash(Goons[i], GetHashKey("JobNPCs"))	
					TaskGuardCurrentPosition(Goons[i], 5.0, 5.0, 1)
					i = i +1
				end
            end
			
			if DeliveryInProgress == false and (GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) < 60) and (GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) > 10) then
				exports['prp-interaction']:showInteraction('Kill the goons that guard the Vehicle')
			end
			
			if selectedJob.VanSpawned and (GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) < 60) and not selectedJob.JobPlayer then
				selectedJob.JobPlayer = true
				TriggerServerEvent("t1ger_drugs:syncJobsData",Config.Jobs)
				Citizen.Wait(500)
				SetPedRelationshipGroupHash(GetPlayerPed(-1), GetHashKey("PLAYER"))
				AddRelationshipGroup('JobNPCs')
				local i = 0
                for k,v in pairs(selectedJob.Goons) do
                    ClearPedTasksImmediately(Goons[i])
                    i = i +1
                end
                SetRelationshipBetweenGroups(0, GetHashKey("JobNPCs"), GetHashKey("JobNPCs"))
                SetRelationshipBetweenGroups(5, GetHashKey("JobNPCs"), GetHashKey("PLAYER"))
                SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("JobNPCs"))
            end
			
			if isVehicleLockPicked == false and (GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) < 10) then
				exports['prp-interaction']:showInteraction('Steal and lockpick the Vehicle')
			end
			
			local VanPosition = GetEntityCoords(JobVan) 
			
			if (GetDistanceBetweenCoords(coords, VanPosition.x, VanPosition.y, VanPosition.z, true) <= 2) and isVehicleLockPicked == false then
				DrawText3Ds(VanPosition.x, VanPosition.y, VanPosition.z, "[G] - Lockpick")
				if IsControlJustPressed(1, 47) then 
					if exports["prp-lockpicking"]:lockpick2(500,1,2,10) == 100 then
						LockpickJobVan(selectedJob, JobVan)
						Citizen.Wait(500)
					else
						TriggerEvent('DoLongHudText', 'You failed!')
					end
				end
			end
			
			if isVehicleLockPicked == true and vanIsDelivered == false then
				if not InsideJobVan then
					exports['prp-interaction']:showInteraction('Get into the Vehicle')
				end
			end
			
			if IsPedInAnyVehicle(GetPlayerPed(-1), true) and isVehicleLockPicked == true then
				if GetDistanceBetweenCoords(coords, selectedJob.Spot.x, selectedJob.Spot.y, selectedJob.Spot.z, true) < 5 then
					local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
					if GetEntityModel(vehicle) == GetHashKey(Config.JobVan) then
						RemoveBlip(blip)
						for k,v in pairs(Config.DeliverySpot) do
							if DeliveryBlipCreated == false then
								PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
								DeliveryBlipCreated = true
								DeliveryBlip = AddBlipForCoord(v.x, v.y, v.z)
								SetBlipColour(DeliveryBlip,5)
								BeginTextCommandSetBlipName("STRING")
								AddTextComponentString("Delivery Location")
								EndTextCommandSetBlipName(DeliveryBlip)
								JobVanPlate = GetVehicleNumberPlateText(vehicle)
								SetBlipRoute(DeliveryBlip, true)
								SetBlipRouteColour(DeliveryBlip, 5)
							end	
						end
						
						DeliveryInProgress = true
					end
				end	
			end
						
			if DeliveryInProgress == true and isVehicleLockPicked == true and vanIsDelivered == false then
				if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
					local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
					if GetEntityModel(vehicle) == GetHashKey(Config.JobVan) then
						exports['prp-interaction']:showInteraction('Deliver the Vehicle to the destination on your GPS')
					end
				end
			end
			
			if DeliveryInProgress == true then
                local coords = GetEntityCoords(GetPlayerPed(-1))
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                if GetEntityModel(vehicle) == GetHashKey(Config.JobVan) then
                    InsideJobVan = true
                else
                    InsideJobVan = false
                end
				for k,v in pairs(Config.DeliverySpot) do
					if InsideJobVan then
						if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DeliveryDrawDistance) then
							DrawMarker(Config.DeliveryMarkerType, v.x, v.y, v.z-0.97, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, Config.DeliveryMarkerScale.x, Config.DeliveryMarkerScale.y, Config.DeliveryMarkerScale.z, Config.DeliveryMarkerColor.r, Config.DeliveryMarkerColor.g, Config.DeliveryMarkerColor.b, Config.DeliveryMarkerColor.a, false, true, 2, false, false, false, false)
						end
						if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 2.0) and vanIsDelivered == false then
							DrawText3Ds(v.x, v.y, v.z, "[E] - Deliver")
							if IsControlJustPressed(0, 38) then 
								RemoveBlip(DeliveryBlip)
								vanIsDelivered = true
								
								SetVehicleForwardSpeed(JobVan, 0)
								SetVehicleEngineOn(JobVan, false, false, true)
								SetVehicleDoorOpen(JobVan, 2 , false, false)
								SetVehicleDoorOpen(JobVan, 3 , false, false)
								if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
									TaskLeaveVehicle(GetPlayerPed(-1), JobVan, 4160)
									SetVehicleDoorsLockedForAllPlayers(JobVan, true)
								end
								Citizen.Wait(500)
								FreezeEntityPosition(JobVan, true)
							end
						end
					end
				end
			end
			
			if DeliveryInProgress == true and vanIsDelivered == true and not drugBoxInHand and not drugsTaken then
				exports['prp-interaction']:showInteraction('Grab the drug package from the Vehicle')
			end
			
			if DeliveryInProgress == true and vanIsDelivered == true and drugBoxInHand and not drugsTaken then
				exports['prp-interaction']:showInteraction('Put the drug package in your getaway vehicle')
			end
			
			if vanIsDelivered == true then
                local coords = GetEntityCoords(GetPlayerPed(-1))
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                if GetEntityModel(vehicle) == GetHashKey(Config.JobVan) then
                    InsideJobVan = true
                else
                    InsideJobVan = false
                end
				for k,v in pairs(Config.DeliverySpot) do
					if not InsideJobVan and drugsTaken == false then
						if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < ((Config.DeliveryMarkerScale.x)*4)) then
							if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 20.0, 0, 70)
								if GetEntityModel(vehicle) == GetHashKey(Config.JobVan) and not drugBoxInHand then
									local d1 = GetModelDimensions(GetEntityModel(vehicle))
									vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]+0.60,0.0)
									local Distance = GetDistanceBetweenCoords(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, coords.x, coords.y, coords.z, false);
									if Distance < 2.0 then
										DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, "[E] - Grab package from Vehicle")
										NearJobVehicle = true
									else
										NearJobVehicle = false
									end
								elseif GetEntityModel(vehicle) ~= GetHashKey(Config.JobVan) and drugBoxInHand then
									local d1 = GetModelDimensions(GetEntityModel(vehicle))
									vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d1["y"]+0.60,0.0)
									local Distance = GetDistanceBetweenCoords(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, coords.x, coords.y, coords.z, false);
									if Distance < 2.0 then
										DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, "[E] Put package in vehicle")
										NearOtherVehicle = true
									else
										NearOtherVehicle = false
									end
								end
							end
						end
					end
				end
			end
			
			if NearJobVehicle == true and not drugBoxInHand and IsControlJustPressed(0, 38) then
				if exports['prp-inventory']:hasEnoughOfItem('thermite', 1, true) then
					TriggerEvent('DoLongHudText', 'Press Right Arrow to Speed Up The Drill, Left Arrow to Slow It Down, Up Arrow to Push It Closer To The Pins, Down Arrow to Move It Away. Make sure it does not overheat!')
					TriggerEvent("Drilling:Start",function(success)
						if (success) then
							RequestAnimDict("anim@heists@box_carry@")
							while not HasAnimDictLoaded("anim@heists@box_carry@") do
								Citizen.Wait(10)
							end
							TaskPlayAnim(GetPlayerPed(-1),"anim@heists@box_carry@","idle",1.0, -1.0, -1, 49, 0, 0, 0, 0)
							Citizen.Wait(300)
							attachModel = GetHashKey('prop_cs_cardbox_01')
							boneNumber = 28422
							SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263) 
							local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
							RequestModel(attachModel)
							while not HasModelLoaded(attachModel) do
								Citizen.Wait(100)
							end
							attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
							AttachEntityToEntity(attachedProp, GetPlayerPed(-1), bone, 0.0, 0.0, 0.0, 135.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
							drugBoxInHand = true
						else
							drugsTaken = true
							StopTheJob = true
							exports['prp-interaction']:hideInteraction()
						end
					-- local finished = exports['prp-thermite']:startGame(20,1,8,425)
					-- if finished then
					end)
				end
			end
			
			if NearOtherVehicle == true and drugBoxInHand and IsControlJustPressed(0, 38) then
                TriggerEvent('DoLongHudText', "Job completed")
				PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
                ClearPedTasks(GetPlayerPed(-1))
                DeleteEntity(attachedProp)
				TriggerServerEvent("t1ger_drugs:JobReward",minRewardD,maxRewardD,typeDrug)
				exports['prp-interaction']:hideInteraction()
				drugsTaken = true
				StopTheJob = true
			end
		
			if StopTheJob == true then
				
				Config.Jobs[id].InProgress = false
				Config.Jobs[id].VanSpawned = false
				Config.Jobs[id].GoonsSpawned = false
				Config.Jobs[id].JobPlayer = false
				TriggerServerEvent("t1ger_drugs:syncJobsData",Config.Jobs)
				Citizen.Wait(2000)
				DeleteVehicle(JobVan)
				
				if DeliveryInProgress == true then
					RemoveBlip(DeliveryBlip)
				else
					RemoveBlip(blip)
				end
				
				local i = 0
                for k,v in pairs(selectedJob.Goons) do
                    if DoesEntityExist(Goons[i]) then
                        DeleteEntity(Goons[i])
                    end
                    i = i +1
				end
				
				JobCompleted = true
				JobVanPlate = ''
				isVehicleLockPicked = false
				drugsTaken = false
				drugBoxInHand = false
				DeliveryInProgress = false
				vanIsDelivered = false
				DeliveryBlipCreated = false
				break
			end
			
		end		
	end	
end)


-- Function for lockpicking the van door:
function LockpickJobVan(selectedJob, vehiclelol)
				
	local playerPed = GetPlayerPed(-1)
	
	local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
	local animName = "machinic_loop_mechandplayer"
	
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(50)
	end
	
	if Config.PoliceNotfiyEnabled == true then
		TriggerServerEvent('t1ger_drugs:DrugJobInProgress',GetEntityCoords(PlayerPedId()),streetName)
	end
	
	SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"),true)
	Citizen.Wait(500)
	FreezeEntityPosition(playerPed, true)
	TaskPlayAnimAdvanced(playerPed, animDict, animName, selectedJob.LockpickPos.x, selectedJob.LockpickPos.y, selectedJob.LockpickPos.z, 0.0, 0.0, selectedJob.LockpickHeading, 3.0, 1.0, -1, 31, 0, 0, 0 )

	exports["prp-taskbar"]:taskBar(7500,"Lockpicking Van",false,false)
	
	ClearPedTasks(playerPed)
	FreezeEntityPosition(playerPed, false)
	isVehicleLockPicked = true
	SetVehicleDoorsLockedForAllPlayers(vehiclelol, false)
	JobVanPlate = GetVehicleNumberPlateText(vehiclelol)
	TriggerServerEvent('garage:addKeys', JobVanPlate)
end

-- Function for job blip in progress:
function CreateMissionBlip(location)
	local blip = AddBlipForCoord(location.x,location.y,location.z)
	SetBlipSprite(blip, 1)
	SetBlipColour(blip, 5)
	AddTextEntry('MYBLIP', "Drug Job")
	BeginTextCommandSetBlipName('MYBLIP')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, 0.9) -- set scale
	SetBlipAsShortRange(blip, true)
	SetBlipRoute(blip, true)
	SetBlipRouteColour(blip, 5)
	return blip
end

-- Function for Mission text:
function DrawMissionText(text)
    SetTextScale(0.5, 0.5)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(0.5,0.955)
end

-- Drug Effects Event:
RegisterNetEvent("t1ger_drugs:DrugEffects")
AddEventHandler("t1ger_drugs:DrugEffects", function(k,v)
    local playerPed = PlayerId()
	local ped = GetPlayerPed(-1)
	if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
		TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING_POT", 0, true)
		exports['prp-taskbar']:taskBar(v.UsableTime, v.ProgressBarText)
		ClearPedTasks(PlayerPedId())
	else
		exports['prp-taskbar']:taskBar(v.UsableTime, v.ProgressBarText)
	end
	if v.BodyArmor then
		if GetPedArmour(ped) <= (100-v.AddArmorValue) then
			AddArmourToPed(ped,v.AddArmorValue)
		elseif GetPedArmour(ped) <= 99 then
			SetPedArmour(ped,100)
		end
	end
	if v.PlayerHealth then
		if GetEntityHealth(ped) <= (200-v.AddHealthValue) then
			SetEntityHealth(ped,GetEntityHealth(ped)+v.AddHealthValue)
		elseif GetEntityHealth(ped) <= 199 then
			SetEntityHealth(ped,200)
		end
	end
	local timer = 0
	while timer < v.EffectDuration do
		if v.FasterSprint then
			SetRunSprintMultiplierForPlayer(playerPed,v.SprintValue)
		end
		if v.TimeCycleModifier then
			SetTimecycleModifier(v.TimeCycleModifierType)
		end
		if v.MotionBlur then
			SetPedMotionBlur(playerPed, true)
		end
		if v.UnlimitedStamina then
			ResetPlayerStamina(playerPed)
		end
		Citizen.Wait(1000)
		timer = timer + 1
	end
    SetTimecycleModifier("default")
	SetPedMotionBlur(playerPed, false)
    SetRunSprintMultiplierForPlayer(playerPed,1.0)
end)

-- Convert Item Event:
RegisterNetEvent("t1ger_drugs:ConvertProcess")
AddEventHandler("t1ger_drugs:ConvertProcess", function(k,v)
	
	local animDict = "misscarsteal1car_1_ext_leadin"
	local animName = "base_driver2"
	
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
	
	if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
		TaskPlayAnim(GetPlayerPed(-1),"misscarsteal1car_1_ext_leadin","base_driver2",8.0, -8, -1, 49, 0, 0, 0, 0)
		FreezeEntityPosition(GetPlayerPed(-1), true)
		exports['prp-taskbar']:taskBar(v.ConversionTime, v.ProgressBarText)
		FreezeEntityPosition(GetPlayerPed(-1), false)
		ClearPedTasks(GetPlayerPed(-1))
	else
		exports['prp-taskbar']:taskBar(v.ConversionTime, v.ProgressBarText)
	end
end)

RequestAnimDict("mp_common")
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
--         local player = GetPlayerPed(-1)
--         local playerPos = GetEntityCoords(player, 0)
-- 		local handle, ped = FindFirstPed()
-- 		local success
-- 		repeat
-- 			success, ped = FindNextPed(handle)
-- 			local pos = GetEntityCoords(ped)
-- 			local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerPos.x, playerPos.y, playerPos.z, true)
			
-- 			if distance < 2 and CanSellToPed(ped) and canSellDrugs and not IsPedInAnyVehicle(player, true) then
-- 				if Config.Enable3DTextToSell then
-- 					DrawText3Ds(pos.x, pos.y, pos.z, "Press [H] to offer drugs")
-- 				else
-- 					TriggerEvent('DoLongHudText', "Press [H] to offer drugs")
-- 				end
-- 				if IsControlJustPressed(1,74) then
-- 					oldped = ped
-- 					TaskStandStill(ped,5000.0)
-- 					SetEntityAsMissionEntity(ped)
-- 					FreezeEntityPosition(ped,true)
-- 					FreezeEntityPosition(player,true)
-- 					SetEntityHeading(ped,GetHeadingFromVector_2d(pos.x-playerPos.x,pos.y-playerPos.y)+180)
-- 					SetEntityHeading(player,GetHeadingFromVector_2d(pos.x-playerPos.x,pos.y-playerPos.y))
					
-- 					local chance = math.random(1,3)
-- 					exports['prp-taskbar']:taskBar((Config.SellDrugsTime * 1000), Config.SellDrugsBarText)
-- 					if chance == 1 or chance == 2 then
-- 						TaskPlayAnim(player, "mp_common", "givetake2_a", 8.0, 8.0, 2000, 0, 1, 0,0,0)
-- 						TaskPlayAnim(ped, "mp_common", "givetake2_a", 8.0, 8.0, 2000, 0, 1, 0,0,0)
-- 						TriggerServerEvent("t1ger_drugs:sellDrugs")
-- 					else
-- 						chance = math.random(1,Config.CallPoliceChance)
-- 						if chance == 1 then
-- 							if Config.PoliceNotfiyEnabled == true then
-- 								TriggerServerEvent('t1ger_drugs:DrugSaleInProgress',GetEntityCoords(PlayerPedId()),streetName)
-- 							end
-- 							TriggerEvent('DoLongHudText', "Your offer was rejected and Police is notified")
-- 						else
-- 							TriggerEvent('DoLongHudText', "Your offer was rejected")	
-- 						end
-- 					end
					
-- 					SetPedAsNoLongerNeeded(oldped)
-- 					FreezeEntityPosition(ped,false)
-- 					FreezeEntityPosition(player,false)
-- 					Citizen.Wait(Config.DrugSaleCooldown * 1000)
-- 					break
-- 				end
-- 			end
			
-- 		until not success
-- 		EndFindPed(handle)
-- 	end
-- end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		TriggerServerEvent("t1ger_drugs:canSellDrugs")
-- 		Citizen.Wait(Config.DrugSaleCooldown * 1000)
-- 	end
-- end)

function CanSellToPed(ped)
	if not IsPedAPlayer(ped) and not IsPedInAnyVehicle(ped,false) and not IsEntityDead(ped) and IsPedHuman(ped) and GetEntityModel(ped) ~= GetHashKey("s_m_y_cop_01") and GetEntityModel(ped) ~= GetHashKey("s_m_y_dealer_01") and GetEntityModel(ped) ~= GetHashKey("mp_m_shopkeep_01") and ped ~= oldped and canSellDrugs then 
		return true
	end
	return false
end

-- RegisterNetEvent("t1ger_drugs:canSellDrugs")
-- AddEventHandler("t1ger_drugs:canSellDrugs", function(soldAmount)
-- 	canSellDrugs = soldAmount
-- end)

-- Function for 3D text:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

-- Thread for Police Notify
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		streetName,_ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
		streetName = GetStreetNameFromHashKey(streetName)
	end
end)

RegisterNetEvent('t1ger_drugs:OutlawBlipEvent')
AddEventHandler('t1ger_drugs:OutlawBlipEvent', function(targetCoords)
	if isPlayerWhitelisted and Config.PoliceBlipShow then
		local alpha = Config.PoliceBlipAlpha
		local policeNotifyBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.PoliceBlipRadius)

		SetBlipHighDetail(policeNotifyBlip, true)
		SetBlipColour(policeNotifyBlip, Config.PoliceBlipColor)
		SetBlipAlpha(policeNotifyBlip, alpha)
		SetBlipAsShortRange(policeNotifyBlip, true)

		while alpha ~= 0 do
			Citizen.Wait(Config.PoliceBlipTime * 4)
			alpha = alpha - 1
			SetBlipAlpha(policeNotifyBlip, alpha)

			if alpha == 0 then
				RemoveBlip(policeNotifyBlip)
				return
			end
		end
	end
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

RegisterNetEvent("t1ger_drugs:syncJobsData")
AddEventHandler("t1ger_drugs:syncJobsData",function(data)
	Config.Jobs = data
end)
