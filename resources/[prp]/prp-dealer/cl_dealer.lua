local isSelling = false
local blah = false
local customer = {ped = nil, tmr = 9, drug = nil}
local hasAsked = {}
local validZones = {AIRP = "high", ALAMO = "Alamo Sea", ALTA = "low", ARMYB = "Fort Zancudo", BANHAMC = "Banham Canyon Dr", BANNING = "Banning", BAYTRE = "Baytree Canyon", BEACH = "Vespucci Beach", BHAMCA = "Banham Canyon", BRADP = "Braddock Pass", BRADT = "Braddock Tunnel", BURTON = "Burton", CALAFB = "Calafia Bridge", CANNY = "Raton Canyon", CCREAK = "Cassidy Creek", CHAMH = "low", CHIL = "Vinewood Hills", CHU = "Chumash", CMSW = "Chiliad Mountain State Wilderness", CYPRE = "low", DAVIS = "low", DELBE = "low", DELPE = "high", DELSOL = "La Puerta", DESRT = "low", DOWNT = "low", DTVINE = "high", EAST_V = "low", EBURO = "low", ELGORL = "El Gordo Lighthouse", ELYSIAN = "Elysian Island", GALFISH = "Galilee", GALLI = "Galileo Park", golf = "GWC and Golfing Society", GRAPES = "Grapeseed", GREATC = "Great Chaparral", HARMO = "Harmony", HAWICK = "Hawick", HORS = "Vinewood Racetrack", HUMLAB = "high", KOREAT = "high", LACT = "Land Act Reservoir", LAGO = "Lago Zancudo", LDAM = "Land Act Dam", LEGSQU = "high", LMESA = "low", LOSPUER = "La Puerta", MIRR = "low", MORN = "Morningwood", MOVIE = "Richards Majestic", MTCHIL = "Mount Chiliad", MTGORDO = "Mount Gordo", MTJOSE = "Mount Josiah", MURRI = "high", NCHU = "North Chumash", NOOSE = "N.O.O.S.E", OBSERV = "Galileo Observatory", OCEANA = "Pacific Ocean", PALCOV = "Paleto Cove", PALETO = "Paleto Bay", PALFOR = "Paleto Forest", PALHIGH = "Palomino Highlands", PALMPOW = "Palmer-Taylor Power Station", PBLUFF = "Pacific Bluffs", PBOX = "high", PROCOB = "Procopio Beach", RANCHO = "low", RGLEN = "Richman Glen", RICHM = "Richman", ROCKF = "Rockford Hills", RTRAK = "Redwood Lights Track", SanAnd = "San Andreas", SANCHIA = "San Chianski Mountain Range", SANDY = "low", SKID = "high", SLAB = "low", STAD = "high", STRAW = "low", TATAMO = "Tataviam Mountains", TERMINA = "Terminal", TEXTI = "high", TONGVAH = "Tongva Hills", TONGVAV = "Tongva Valley", VCANA = "Vespucci Canals", VESP = "Vespucci", VINE = "Vinewood", WINDF = "Ron Alternates Wind Farm", WVINE = "West Vinewood", ZANCUDO = "Zancudo River", ZP_ORT = "Port of South Los Santos", ZQ_UAR = "Davis Quartz"}
inanim = false
cancelled = false
attachedProp = 0
local has = false
local coords = {}
wanttosell = false
pos = 0
Citizen.CreateThread(function()
    while(true) do
		playerPed = PlayerPedId()
		coords = GetEntityCoords(PlayerPedId())
        Citizen.Wait(1000)
    end
end)

RegisterCommand("corner", function(source, args)
	TriggerEvent('drugs:corner')
end)

RegisterCommand("cornerdrug", function(source, args)
	wanttosell = true
end)

RegisterCommand("corneroff", function(source, args)
	wanttosell = false
end)

function DrawMissionText(m_text, showtime)
	ClearPrints()
	TriggerEvent('DoLongHudText', m_text)
	-- EndTextCommandPrint(showtime, true)
end

function isValidZone(playerCoords)
	local zone = GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z)

	if validZones[tostring(zone)] then
		return true
	end

	return false
end

function StopJob(delPed)
	if customer.ped then
		if DoesEntityExist(customer.ped) then
			if customer.blip and DoesBlipExist(customer.blip) then
				RemoveBlip(customer.blip)
				customer.blip = nil
			end

			--[[
				if delPed then
					SetEntityAsNoLongerNeeded(customer.ped)
					DeleteEntity(customer.ped)
				end
			--]]
		end
	end

	isSelling = false
	customer = {ped = nil, tmr = 9, drug = nil}
end

function canPedBeUsed(ped)
	if ped == nil then
		return false
	end

	if not IsEntityAPed(ped) then
		return false
	end

	if ped == PlayerPedId() then
		return false
	end

	if not DoesEntityExist(ped) then
		return false
	end

	if IsPedAPlayer(ped) then
		return false
	end

	if tablefind(hasAsked, tostring(ped)) then
		return false
	end

	if IsPedFatallyInjured(ped) then
		return false
	end

	if IsPedFleeing(ped) or IsPedRunning(ped) or IsPedSprinting(ped) then
		return false
	end

	if IsPedInCover(ped) or IsPedGoingIntoCover(ped) or IsPedGettingUp(ped) then
		return false
	end

	if IsPedInMeleeCombat(ped) then
		return false
	end

	if IsPedShooting(ped) then
		return false
	end

	if IsPedDucking(ped) then
		return false
	end

	if IsPedBeingJacked(ped) then
		return false
	end

	if IsPedSwimming(ped) then
		return false
	end

	if not IsPedOnFoot(ped) then
		return false
	end

	local pedType = GetPedType(ped)
	if pedType == 6 or pedType == 27 or pedType == 29 or pedType == 28 then
		return false
	end

	return true
end

function GetZoneType()
	local zone = GetNameOfZone(GetEntityCoords(PlayerPedId()))
	local zoneType = validZones[tostring(zone)]

	if zoneType ~= nil then
		if zoneType == 'low' or zoneType == 'high' then
			return zoneType
		end
	end

	return 'normal'
end

function NpcBuy()
	local rand = GetRandomIntInRange(0,100)
	local zoneType = GetZoneType()

	if zoneType == 'low' then -- 70% chance of selling in low-risk zones
		return rand > 30
	elseif zoneType == 'high' then -- 30% chance of selling in high-risk zones
		return rand > 70
	else -- 50% chance in normal zones
		return rand > 50
	end
end

function NpcReport()
	local rand = GetRandomIntInRange(0,100)
	local zoneType = GetZoneType()

	if zoneType == 'low' then -- 5% chance of being reported in low-risk zones
		return rand > 95
	elseif zoneType == 'high' then -- 50% chance of being reported in high-risk zones
		return rand > 50
	else -- 15% chance in normal zones
		return rand > 85
	end
end

function GetPedInfrontOfEntity(entity)
	local playerCoords = GetEntityCoords(entity)
	local inDirection  = GetOffsetFromEntityInWorldCoords(entity, 0.0, 5.0, 0.0)
	local rayHandle    = StartExpensiveSynchronousShapeTestLosProbe(playerCoords, inDirection, 10, entity, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and canPedBeUsed(entityHit) then
		return entityHit
	else
		return nil
	end
end

RegisterNetEvent('sell:check')
AddEventHandler('sell:check', function()
	local methqty = exports['wrp-inventory']:getQuantity('vanmeth')
	if methqty > 0 then
		TriggerEvent('notify')
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)

		if isValidZone(playerCoords) and IsPedOnFoot(playerPed) then
			if customer.ped == nil then
				if wanttosell then
				local handle, ped = FindFirstPed()
				repeat
					success, ped = FindNextPed(handle)
					local pos = GetEntityCoords(ped)
					local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords['x'], coords['y'], coords['z'], true)
					if not IsPedInAnyVehicle(playerPed) then
						if DoesEntityExist(ped) then
							if not IsPedDeadOrDying(ped) then
								if not IsPedInAnyVehicle(ped) then
									local pedType = GetPedType(ped)
									if pedType ~= 28 and not IsPedAPlayer(ped) then
										currentped = pos
										if distance <= 1.5 and ped ~= playerPed and ped ~= oldped then
											if exports['wrp-inventory']:getQuantity('vanmeth') > 0 then
												TriggerEvent('sell:check')
												DrawText3Ds(pos.x, pos.y, pos.z, 'Press [H] to sell drugs')
												if has then
													if IsControlJustPressed(0, 74) then
														oldped = ped
														customer.ped = ped
														customer.drug = drug
														SetBlockingOfNonTemporaryEvents(customer.ped, 1)
														TaskStandStill(customer.ped, 3500)
														TaskLookAtEntity(customer.ped, playerPed, 3500, 1, 1)
														DrawMissionText("Asking the person if they are interested...")
														customer.blip = AddBlipForEntity(customer.ped)
														SetBlipColour(customer.blip, 2)
														SetBlipCategory(customer.blip, 3)
														table.insert(hasAsked, tostring(ped))
														if #hasAsked > 25 then
															table.remove(hasAsked, 1)
														end
													else
														StopJob(true)
													end
												end
											end -- control end
										end
									end
								end
							end
						end
					end
				until not success
				EndFindPed(handle)
				end

			else
				if isSelling then
					if not IsPedFatallyInjured(customer.ped) then
						if GetDistanceBetweenCoords(playerCoords, GetEntityCoords(customer.ped), true) < 2.501 then
							if customer.tmr > 1 then
								TaskStandStill(customer.ped, 1500)
								TaskLookAtEntity(customer.ped, playerPed, 1500, 2048, 3)
								TaskTurnPedToFaceEntity(customer.ped, playerPed, 1500)
								customer.tmr = customer.tmr - 1
								DrawMissionText(string.format("Stay beside the buyer for another %s seconds to make the deal", customer.tmr), 1000)
								Citizen.Wait(1000)
							else -- customer.tmr else
								if GetDistanceBetweenCoords(playerCoords, GetEntityCoords(customer.ped), true) < 2.0 then
									blah = true
									TriggerEvent("drugGiveAnim")
									TaskStandStill(customer.ped, 4500)
									TaskLookAtEntity(customer.ped, playerPed, 3500, 2048, 3)
									TaskTurnPedToFaceEntity(customer.ped, playerPed, 3500)
									Citizen.Wait(4500)
									StopJob(true)
								else -- distance else
									DrawMissionText("The buyer has canceled the transaction.", 3000)
									StopJob(true)
								end -- distance end
							end -- customer.tmr end
						else -- distance else
							DrawMissionText("The buyer is too far away, the transaction has been canceled.", 3000)
							StopJob(true)
						end --distance end
					else -- dead/injured else
						DrawMissionText("The buyer is dead.", 3000)
						StopJob(true)
					end --dead/injured end
				else -- isSelling else
					Citizen.Wait(2000)
					if NpcBuy() then
						isSelling = true
						TaskStandStill(customer.ped, 3500)
						TaskLookAtEntity(customer.ped, playerPed, 3500, 1, 1)
						Citizen.Wait(3000)
					else -- NpcBuy else
						DrawMissionText("The buyer has rejected your offer!", 1000)
						if NpcReport() then
							reportPlayer()
						end
						StopJob(false)
						Citizen.Wait(1000)
					end -- NpcBuy end
				end -- isSelling end
			end -- customer.ped end
		else
			Citizen.Wait(2000)
		end
	end -- while end
end)

function tablefind(tab,el)
	for index, value in pairs(tab) do
		if value == el then
			return index
		end
	end
end

function reportPlayer()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	TriggerEvent('urp:alert:drugjob')
end

RegisterNetEvent('drugGiveAnim')
AddEventHandler('drugGiveAnim', function()
	local player = PlayerPedId()
	if DoesEntityExist(player) and not IsEntityDead(player) then
		RequestAnimDict('mp_safehouselost@')
		while (not HasAnimDictLoaded("random@arrests@busted")) do 
			Citizen.Wait(0) 
			RequestAnimDict('mp_safehouselost@')
		end
		if IsEntityPlayingAnim(player, "mp_safehouselost@", "package_dropoff", 3) then
			TaskPlayAnim(player, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
		else
			TaskPlayAnim(player, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
		end
	end
end)

function removeAttachedProp()
	DeleteEntity(attachedProp)
	DeleteObject(attachedProp)
	attachedProp = 0
end

RegisterNetEvent('attachPropDrugsObject')
AddEventHandler('attachPropDrugsObject', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp()
	TriggerEvent("drugGiveAnim")
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	RequestModel(attachModel)
	-- attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	-- AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	Citizen.Wait(3000)
	removeAttachedProp()
end)

RegisterNetEvent('attachPropDrugs')
AddEventHandler('attachPropDrugs', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp()
	TriggerEvent("drugGiveAnim")
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	RequestModel(attachModel)
	-- attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	-- AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	Citizen.Wait(4000)
	item = "money01"
	-- attachPropCash(attachPropList[item]["model"], attachPropList[item]["bone"], attachPropList[item]["x"], attachPropList[item]["y"], attachPropList[item]["z"], attachPropList[item]["xR"], attachPropList[item]["yR"], attachPropList[item]["zR"])
end)

function attachPropCash(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp()
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)

	RequestModel(attachModel)

	-- attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	-- AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	Citizen.Wait(2500)

	removeAttachedProp()
end

RegisterNetEvent('currentlySelling')
AddEventHandler('currentlySelling', function()
	selling = true
	secondsRemaining = 10
end)

RegisterNetEvent('cancel')
AddEventHandler('cancel', function()
	blah = false
end)

RegisterNetEvent('done')
AddEventHandler('done', function()
	selling = false
	secondsRemaining = 0
	StopJob(false)
end)

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end

RegisterNetEvent('notify')
AddEventHandler('notify', function()
	-- BeginTextCommandDisplayHelp('STRING')
	-- AddTextComponentSubstringPlayerName("Press ~INPUT_VEH_HEADLIGHT~ to ~o~Sell Drugs~s~ to the ~y~Pedestrian~s~.")
	-- EndTextCommandDisplayHelp(0, false, true, -1)
	has = true
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)

		if blah then
			local Methpayment = math.random(100, 200)
			local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
			local Player = LocalPlayer:getCurrentCharacter()  
			local methqty = exports['wrp-inventory']:getQuantity('vanmeth')
			if methqty >= 4 then
				local x = 4
				TriggerEvent('currentlySelling')
				local methPay = Methpayment * x
				TriggerEvent('wrp-banned:getID', 'band', math.random(2, 5))
				TriggerEvent('inventory:removeItem', 'vanmeth', x)
				TriggerEvent('done')
				TriggerEvent('cancel')
			elseif methqty == 3 then
				local x = 3
				TriggerEvent('currentlySelling')
				local methPay = Methpayment * x
				TriggerEvent('wrp-banned:getID', 'rollcash', math.random(6, 18))
				TriggerEvent('inventory:removeItem', 'vanmeth', x)
				TriggerEvent('done')
				TriggerEvent('cancel')
			elseif methqty == 2 then
				local x = 2
				TriggerEvent('currentlySelling')
				local methPay = Methpayment * x
				TriggerEvent('wrp-banned:getID', 'rollcash', math.random(4, 12))
				TriggerEvent('inventory:removeItem', 'vanmeth', x)
				TriggerEvent('done')
				TriggerEvent('cancel')
			elseif methqty == 1 then
				local x = 1
				TriggerEvent('currentlySelling')
				local methPay = Methpayment * x
				TriggerEvent('wrp-banned:getID', 'rollcash', math.random(2, 6))
				TriggerEvent('inventory:removeItem', 'vanmeth', x)
				TriggerEvent('done')
				TriggerEvent('cancel')
				blah = false
			end
		else
			Citizen.Wait(500)
		end
	end
end)