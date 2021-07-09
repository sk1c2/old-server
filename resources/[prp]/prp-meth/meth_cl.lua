local MissionStarted = nil
local PlayerData = {}
local cooldownEnabled = false
local isPlayingAnim, isDestroying = false, false
hint = false

Citizen.CreateThread(function()
	Config.PoliceCount = Config.PoliceCount or 0
	while true do
		Citizen.Wait(6)
		local x,y,z = -706.612, -964.3323, 30.40825
		local Playermate = PlayerPedId()
		local plyCoords = GetEntityCoords(Playermate)
		local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,706.5895, -964.419, 30.40825,false)
		local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
		local Player = LocalPlayer:getCurrentCharacter()  
		if distance < 2.5 then
			if hint == false or Player.methint == false then
				DrawText3Ds(706.0171, -964.2112, 29.40825+1.1, '[E] $15,000 Meth Hint')
				if IsControlJustPressed(0, 38) then
					if Player.cash >= 15000 then
						TriggerEvent("phone:addnotification", "Toby Walter","<b>Toby Walter</b> <br>You find these throughout your home</br> There are several on a car <br> When one is slightly open </br> It is said that it is ajar!</br><b> What am I?</b> <br>Head to the beach and look around!</br>") -- ADD HINT HERE PLEASE ALFIE
						TriggerServerEvent('urp_meth:methHint', exports['isPed']:isPed('cid'), true)
						TriggerEvent('prp-ac:removeban', 15000)
						TriggerEvent('prp-banned:getID', 'methkey', 1)
						TriggerServerEvent('prp-meth:hintObtain', exports['isPed']:isPed('cid'))
						hint = true
					else
						TriggerEvent('DoShortHudText', 'You do not have enough cash on you', 2)
					end
				end
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

ped = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(6)
		local x,y,z = -706.612, -964.3323, 30.40825
		local Playermate = PlayerPedId()
		local plyCoords = GetEntityCoords(Playermate)
		local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,706.5895, -964.419, 30.40825,false)
		if distance < 2.5 then
			local pedType = `a_m_m_soucent_01`

			RequestModel(pedType)
			while not HasModelLoaded(pedType) do
				Citizen.Wait(0)
			end
			ped = CreatePed(26, pedType, 706.0171, -964.2112, 29.40825, 271.25784, 1, 1)
			DecorSetBool(ped, 'ScriptedPed', true)
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
			TaskSetBlockingOfNonTemporaryEvents(ped, true)
			SetPedFleeAttributes(ped, 0, 0)
			SetPedCombatAttributes(ped, 17, 1)
			SetEntityInvincible(ped, true)
			FreezeEntityPosition(ped, true)
		
			SetPedSeeingRange(ped, 0.0)
			SetPedHearingRange(ped, 0.0)
			SetPedAlertness(ped, 0)
			SetPedKeepTask(ped, true)
			Citizen.Wait(10000000000000000)
		else
			if ped ~= nil then
				DeletePed()
			end
		end
	end
end)

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

function GetVecDist(v1,v2)
	if not v1 or not v2 or not v1.x or not v2.x then
		return 0
	end
	return math.sqrt(  ( (v1.x or 0) - (v2.x or 0) )*(  (v1.x or 0) - (v2.x or 0) )+( (v1.y or 0) - (v2.y or 0) )*( (v1.y or 0) - (v2.y or 0) )+( (v1.z or 0) - (v2.z or 0) )*( (v1.z or 0) - (v2.z or 0) )  )
end

function destroyMethDrug()
	RequestAnimDict('anim@heists@narcotics@trash')
		isPlayingAnim = true
		isDestroying = true
		TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0, -1, 2, 0.0, false, false, false)
		Citizen.Wait(800)
		ClearPedTasks(PlayerPedId())
		Citizen.Wait(1000)
		TriggerEvent('DoLongHudText', 'Throwing pseudoephedrine into the garbage.')
		local amount = exports['prp-inventory']:getQuantity('pseudoephedrine')
		TriggerEvent('inventory:removeItem', 'pseudoephedrine', amount)
		TriggerServerEvent('prp-meth:pseudo', amount)
		local price = amount * 50
		local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
		local Player = LocalPlayer:getCurrentCharacter()  
		LocalPlayer:addCash(Player.id, price)
		isPlayingAnim = false
		isDestroying = false
		ClearPedTasks(PlayerPedId())
		TriggerEvent('DoLongHudText', 'You have received $' ..price.. ' from dumping this drug.')
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isPlayingAnim and not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'throw_b') then
			RequestAnimDict('anim@heists@narcotics@trash')
				TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0, -1, 2, 0.0, false, false, false)

			Citizen.Wait(800)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)

		for k,v in pairs(Config.DestroyLocations) do
			local distance = #(playerCoords - v)


			if distance < 3.0 then
				coords = v
				DrawText3Ds(coords.x, coords.y, coords.z, 'Press ~g~[E]~s~ to ~y~Throw pseudoephedrine~s~')

				if IsControlJustReleased(0, 38) and not isDestroying then
					if exports['prp-inventory']:hasEnoughOfItem('pseudoephedrine', 1) then
						destroyMethDrug()
					else
						TriggerEvent('DoLongHudText', 'You do not have any pseudoephedrine.')
					end
				end
			else
				Citizen.Wait(3000)
			end
		end
	end
end)
veh = 0
DropoffLocation = 0
Citizen.CreateThread(function()
	local SmokeActive = false
	local timer = 0
	while true do
		Citizen.Wait(3)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)

		if not MissionStarted then
			local distance = #(playerCoords - Config.HintLocation)

			if distance < 3.0 then
				local hintLocation = Config.HintLocation

				if IsControlJustPressed(0, 38) then
					local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
					local Player = LocalPlayer:getCurrentCharacter()			  
					if hint == true or tonumber(Player.methint) == 1 then
						local count = exports['police']:CopsOnline()
						if exports['police']:CopsOnline() then
							if count >= Config.MinPoliceCount then
								if exports['prp-inventory']:hasEnoughOfItem('methkey', 1) then
									response = true
									if response then
										if not cooldownEnabled then
											TriggerServerEvent('prp-meth:pass')
											TriggerServerEvent('urp_meth:cooldown')
											TaskGoStraightToCoord(hintLocation, 10.0, 10, Config.HintHeading, 0.5)
											Citizen.Wait(3000)
											ClearPedTasksImmediately(playerPed)
											RequestAnimDict('timetable@jimmy@doorknock@')
												TaskPlayAnim(playerPed, 'timetable@jimmy@doorknock@', 'knockdoor_idle', 8.0, 8.0, -1, 4, 0, 0, 0, 0)
												SetEntityHeading(playerPed, Config.HintHeading)
												Citizen.Wait(0)

												while IsEntityPlayingAnim(playerPed, 'timetable@jimmy@doorknock@', 'knockdoor_idle', 3) do
													Citizen.Wait(0)
												end
												TriggerServerEvent('3dme:shareDisplay', 'a note slides under the door that says you\'ll get information soon')
												ClearPedTasksImmediately(playerPed)

												local random = math.random(1, #Config.TruckLocations)

												MissionStarted = {
													TruckLoc = Config.TruckLocations[random].pos,
													Heading = Config.TruckLocations[random].heading,
													Dropoff = Config.DropoffLocations[math.random(1, #Config.DropoffLocations)],
													Count = 0,
												}

												DropoffLocation = MissionStarted.Dropoff

												local spawn = MissionStarted.TruckLoc
												local near = GetStreetNameFromHashKey(GetStreetNameAtCoord(spawn.x, spawn.y, spawn.z))
												SetNewWaypoint(spawn.x, spawn.y, spawn.z)
												Citizen.Wait(math.random(2000, 3000))
												TriggerEvent("phone:addnotification", "Ping","You can find the truck near: <br>"..near.."</br> <br>Don't be late!</br>~ <b>Toby Walter</b>")
												-- TriggerServerEvent("urp_meth:sendText", "You can find the truck near "..near..". Don't be late!", spawn)
										else
											TriggerEvent('DoLongHudText', "Things are hot right now, wait for shit to cool down", 2)
										end
									else
										TriggerEvent('DoShortHudText', "Run Stupid He called the cops")
										Citizen.Wait(10000)
										TriggerEvent('InteractSound_CL:PlayOnOne', 'copstheme', 1.0)
									end
								else
									TriggerEvent('DoLongHudText', 'You forgot the key that Walter gave you!', 2)
								end
							else
								TriggerEvent('DoLongHudText', "No one is home come back and try again later.", 2)
							end
						end
					else
						TriggerEvent('DoLongHudText', 'Come back when you have the hint, dumbass', 2)
					end
				end
			end
		else
			if not TruckSpawned and MissionStarted then
				local distance = #(playerCoords - MissionStarted.TruckLoc)

				if distance < Config.TruckSpawnDistance then
					local random = math.random(1, #Config.TruckModels)
					local vehModel = Config.TruckModels[random]
					local hash = GetHashKey(vehModel)

					while not HasModelLoaded(hash) do
						RequestModel(hash)
						Citizen.Wait(0)
					end

					local coords = MissionStarted.TruckLoc
					veh = CreateVehicle(hash, coords, MissionStarted.Heading, true, true)
					SetVehicleMod(veh, 18, 2)
                    exports["prp-oGasStations"]:SetFuel(veh, 100)
					local plate = GetVehicleNumberPlateText(veh)
					TriggerServerEvent('garage:addKeys', plate)
					SetVehicleDoorsLockedForAllPlayers(veh, false)
					SetEntityAsMissionEntity(veh, true, true)
					TruckSpawned = veh
				end
			else
				if IsPedInAnyVehicle(PlayerPedId()) then
					local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

					if vehicle == TruckSpawned then
						if not WaypointSet then
							WaypointSet = true
							SetNewWaypoint(MissionStarted.Dropoff.x, MissionStarted.Dropoff.y)
							TriggerEvent('DoLongHudText', 'Find a passenger to cook the meth in the back before delivery.')
						end

						if not MethCook then
							local foundCook = false
							for k=1,4,1 do
								if not foundCook and not IsVehicleSeatFree(TruckSpawned, k) then
									local passenger = GetPedInVehicleSeat(TruckSpawned, k) 
									if passenger ~= -1 and passenger ~= PlayerPedId() and DoesEntityExist(passenger) then
										foundCook = passenger
									end
								end
							end

							if foundCook and foundCook ~= playerPed then
								if GetEntitySpeed(TruckSpawned) * 2.236936 > Config.MinSpeedtoCook then
									TriggerEvent('DoLongHudText','Your passenger has started cooking the meth.')
									MethCook = NetworkGetPlayerIndexFromPed(foundCook)
									TriggerServerEvent('urp_meth:BeginCooking', GetPlayerServerId(MethCook))
								else
									if not notified then
										TriggerEvent('DoLongHudText', 'Drive above ' ..Config.MinSpeedtoCook.. 'MPH to begin the cook.')
										notified = true
									end
								end
							end
						else
							if not SmokeActive then
								TriggerServerEvent('urp_meth:SyncSmoke', NetworkGetNetworkIdFromEntity(TruckSpawned))
								SmokeActive = true
							end

							if CookFinished then
								print(DropoffLocation.x, DropoffLocation.y, DropoffLocation.z)
								while true do
									Citizen.Wait(4)
								local playerPed = PlayerPedId()
								local playerCoords = GetEntityCoords(playerPed)
								distance = GetDistanceBetweenCoords(playerCoords.x,playerCoords.y,playerCoords.z,DropoffLocation.x,DropoffLocation.y,DropoffLocation.z,false)
								
								if distance < Config.DrawTextDistance then
									local place = DropoffLocation
									DrawText3Ds(place.x, place.y, place.z, 'Press [~g~E~s~] to deliver the meth', 3.0)

									if distance < Config.DrawTextDistance and IsControlJustReleased(0, 38) then
										print('ok')
										local veh = TruckSpawned
										local maxSeats = GetVehicleMaxNumberOfPassengers(veh)

										for seat = -1, maxSeats-1,1 do
											local player = GetPedInVehicleSeat(veh, seat)
											if player and player ~= 0 then
												TaskLeaveVehicle(player, veh, 16)
											end
										end

										TriggerServerEvent('urp_meth:RewardPlayers', GetPlayerServerId(MethCook))
										TriggerServerEvent('urp_meth:RemoveTruck',  NetworkGetNetworkIdFromEntity(TruckSpawned))
										
										Citizen.Wait(0)
										SetEntityAsMissionEntity(veh, false, false)
										DeleteVehicle(veh)
										MissionStarted = nil
										TruckSpawned = false
										WaypointSet = false
										MethCook = false
										SmokeActive = false
										notified = false
										CookFinished = false
										TriggerEvent('DoLongHudText', 'You delivered the meth.')
									end
								else
									local vehicle = false

									if IsPedInAnyVehicle(player) then
										vehicle = GetVehiclePedIsIn(player, false)
									end

									if not vehicle or vehicle ~= TruckSpawned then
										--cancel and remove truck server side
										Citizen.Wait(0)
										DeleteVehicle(veh)
										MissionStarted = nil
										TruckSpawned = false
										WaypointSet = false
										MethCook = false
										SmokeActive = false
										notified = false
										CookFinished = false
									end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

function BeginCooking(driver)
	local Driver = driver

	TriggerEvent('DoLongHudText', 'You have started cooking Meth.')

	local truck = GetVehiclePedIsIn(PlayerPedId())
	local doCount = true

	Citizen.CreateThread(function()
		while Driver do
			Citizen.Wait(0)

			local doBreak, driverMsg
			local currentPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(currentPed, false)

			if not IsPedInAnyVehicle(currentPed) then
				doBreak = "You A Hoe For Leaving The Driver"
				driverMsg = "The Cook Said Fuck This I'm Out!"
			else
				if GetEntitySpeed(vehicle) * 2.236936 < Config.MinSpeedtoCook then
					if not CurrentlyStopped then
						local CanContinue = false
						CurrentlyStopped = true
						Citizen.CreateThread(function()
							local timer = GetGameTimer()
							while (GetGameTimer() - timer) < Config.MaxVehicleStopTime * 1000 do
								Citizen.Wait(0)
							end
							if GetEntitySpeed(vehicle) * 2.236936 < Config.MinSpeedtoCook then
								CanContinue = true
								TriggerEvent('DoLongHudText', 'Somebody snitched, get the fuck outta here!')
								Citizen.Wait(1000)
								local coords = GetEntityCoords(vehicle)
								local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
								TriggerEvent('meth:alertPD')
								CurrentlyStopped = false
							else
								CanContinue = true
								CurrentlyStopped = false
							end
						end)
					end
				else
					if CanContinue then
						CurrentlyStopped = false
					end
				end
			end
			if doBreak then
				TriggerEvent('DoLongHudText', doBreak)
				TriggerServerEvent('urp_meth:RemoveTruck', NetworkGetNetworkIdFromEntity(truck))
				TriggerServerEvent('urp_meth:FinishCook', Driver, false, driverMsg)
				Driver = false
				Truck = false
				doCount = false
				CurrentlyStopped = false
			end
		end
	end)

	exports["prp-taskbar"]:taskBar(math.floor(Config.CookTimerA * 60 * 1000), "Preparing Ingredients.")
	Citizen.Wait(10)
	if doCount then
		exports["prp-taskbar"]:taskBar(math.floor(Config.CookTimerB * 60 * 1000), "Cooking Meth.")
		Citizen.Wait(10)
	else
		return
	end

	if doCount then
		exports["prp-taskbar"]:taskBar(math.floor(Config.CookTimerC * 60 * 1000), "Allowing Meth to Set.")
		Citizen.Wait(10)
	else
		return
	end

	if doCount then
		exports["prp-taskbar"]:taskBar(math.floor(Config.CookTimerD * 60 * 1000), "Packaging Meth.")
		Citizen.Wait(10)
	else
		return
	end

	if doCount then
		TriggerEvent('DoLongHudText', "You finished the cook.")
		TriggerServerEvent('urp_meth:FinishCook', Driver, true, "The cook has finished.")
		MissionStarted = nil
		Driver = false
	end

end

function dump(o)
	if type(o) == 'table' then
	   local s = '{ '
	   for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. dump(v) .. ','
	   end
	   return s .. '} '
	else
	   return tostring(o)
	end
 end

SmokingTrucks = {}

function SyncSmoke(netId)
	SmokingTrucks[netId] = false
end

local SmokeSpawnDist = 50.0
function SmokeTracker()
	while true do
		Citizen.Wait(1000)
		local ped = PlayerPedId()
		local plypos = GetEntityCoords(ped)
		local removeList = {}
		for k,v in pairs(SmokingTrucks) do
			local doesExist = NetworkDoesEntityExistWithNetworkId(k)
			local ent
			if doesExist then
				ent = NetworkGetEntityFromNetworkId(k)
			end
			if not v then
				if DoesEntityExist(ent) then
					local pos = GetEntityCoords(ent)
					local dist = GetVecDist(pos, plypos)
					if dist < SmokeSpawnDist then
						if not HasNamedPtfxAssetLoaded("core") then
							RequestNamedPtfxAsset("core")
						end
						while not HasNamedPtfxAssetLoaded("core") do
							Citizen.Wait(0)
						end
						SetPtfxAssetNextCall("core")
						StartNetworkedParticleFxLoopedOnEntity("exp_grd_grenade_smoke", ent, 0.0,0.0,0.5, 0.0,0.0,0.0, 1.0, false,false,false)
						SmokingTrucks[k] = true
					end
				end
			else
				if (not ent and SmokingTrucks[k]) or (ent and not DoesEntityExist(ent)) then
					SmokingTrucks[k] = false
				end
			end
		end
	end
end

Citizen.CreateThread(function()
	SmokeTracker()
end)

function FinishCooking(result, msg)
	if result then
		TriggerEvent('DoLongHudText', msg)
		CookFinished = true
	else
		TriggerEvent('DoLongHudText', msg)
		MethCook = false
		DidNotify = false
	end
end

function NotifyPolice(pos, msg)
	TriggerEvent('DoLongHudText', msg)
	local blip = AddBlipForRadius(pos.x, pos.y, pos.z, 50.0)
	SetBlipHighDetail(blip, true)
	SetBlipColour(blip, 1)
	SetBlipAlpha(blip, 80)
	local timer = GetGameTimer()
	while GetGameTimer() - timer < Config.TrackableNotifyTimer * 1000 do
		Citizen.Wait(0)
		if IsControlJustPressed(0, 36) then
			SetNewWaypoint(pos.x, pos.y)
		end
	end
	RemoveBlip(blip)
end

function RemoveTruck(netId)
	if not netId then
		return
	end
	SmokingTrucks[netId] = nil
	Citizen.CreateThread(function()
		local doesExist = NetworkDoesEntityExistWithNetworkId(netId)
		local ent
		if doesExist then
			Citizen.Wait(5000)
			ent = NetworkGetEntityFromNetworkId(netId)
			AddExplosion(GetEntityCoords(ent), "EXPLOSION_HI_OCTANE", 1000.0, 1, 0, 1)
			Citizen.Wait(5000)
			DeleteEntity(ent)
		end
	end)
end

function CheckPolice(allowEms)
	if exports['isPed']:isPed('job') then
		local job = exports['isPed']:isPed('job')
		if job == 'Police' then
			return true
		end

		if allowEms and job == 'EMS' then
			return true
		end
	end

	return false
end

RegisterNetEvent('urp_meth:setCooldown')
AddEventHandler('urp_meth:setCooldown', function(state)
	cooldownEnabled = state
end)

RegisterNetEvent('urp_meth:BeginCooking')
AddEventHandler('urp_meth:BeginCooking', function(target, source)
	BeginCooking(target)
end)

RegisterNetEvent('urp_meth:FinishCook')
AddEventHandler('urp_meth:FinishCook', function(result, msg)
	FinishCooking(result, msg)
	print('triggered')
	while true do
		CookFinished = true
		Citizen.Wait(100)
	end
end)

RegisterNetEvent('urp_meth:SyncSmoke')
AddEventHandler('urp_meth:SyncSmoke', function(netId)
	SyncSmoke(netId)
end)

RegisterNetEvent('urp_meth:NotifyCops')
AddEventHandler('urp_meth:NotifyCops', function(pos,msg)
	msg = "Strange odors have been reported"
	Citizen.CreateThread(function()
		NotifyPolice(pos,msg)
	end)
end)

RegisterNetEvent('urp_meth:sendTextC')
AddEventHandler('urp_meth:sendTextC', function(number, message, coords)
	TriggerServerEvent('esx_addons_gcphone:startCall', 'Anonymous', message, coords, {
	coords = coords.x, coords.y, coords.z
	})
end)

RegisterNetEvent('urp_meth:RemoveSmoke')
AddEventHandler('urp_meth:RemoveSmoke', function(netId)
	RemoveTruck(netId)
end)