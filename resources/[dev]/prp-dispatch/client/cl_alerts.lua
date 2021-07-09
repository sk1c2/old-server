local currentCallSign = ""

local exlusionZones = {
    {1713.1795654297,2586.6862792969,59.880760192871,250}, -- prison
    {-106.63687896729,6467.7294921875,31.626684188843,45}, -- paleto bank
    {251.21984863281,217.45391845703,106.28686523438,20}, -- city bank
    {-622.25042724609,-230.93577575684,38.057060241699,10}, -- jewlery store
    {699.91052246094,132.29960632324,80.743064880371,55}, -- power 1
    {2739.5505371094,1532.9992675781,57.56616973877,235}, -- power 2
    {12.53, -1097.99, 29.8, 10} -- Adam's Apple / Pillbox Weapon shop
}

local ped = PlayerPedId()
local isInVehicle = IsPedInAnyVehicle(ped, true)
Citizen.CreateThread( function()
    while true do
        Wait(1000)
        ped = PlayerPedId()
        isInVehicle = IsPedInAnyVehicle(ped, true)
    end
end)

function getRandomNpc(basedistance)
    local basedistance = basedistance
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom

    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if ped ~= PlayerPedId() and distance < basedistance and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
        end
        success, ped = FindNextPed(handle)
    until not success

    EndFindPed(handle)

    return rped
end

function GetStreetAndZone()
    local plyPos = GetEntityCoords(PlayerPedId(),  true)
    local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    zone = tostring(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
    local playerStreetsLocation = GetLabelText(zone)
    local street = street1 .. ", " .. playerStreetsLocation
    return street
end

RegisterNetEvent("police:setCallSign")
AddEventHandler("police:setCallSign", function(pCallSign)
	if pCallSign ~= nil then currentCallSign = pCallSign end
end)

--- Gun Shots ---

Citizen.CreateThread( function()
    local origin = false
    local w = `WEAPON_PetrolCan`
    local w1 = `WEAPON_FIREEXTINGUISHER`
    local w2 = `WEAPON_FLARE`
    local curw = GetSelectedPedWeapon(PlayerPedId())
    local armed = false
    local timercheck = 0
    while true do
        Wait(50)
        

        if not armed then
            if IsPedArmed(ped, 7) and not IsPedArmed(ped, 1) then
                curw = GetSelectedPedWeapon(ped)
                armed = true
                timercheck = 15
            end
        end

        if armed then

            if IsPedShooting(ped) then

                local inArea = false
                for i,v in ipairs(exlusionZones) do
                    local playerPos = GetEntityCoords(ped)
                    if #(vector3(v[1],v[2],v[3]) - vector3(playerPos.x,playerPos.y,playerPos.z)) < v[4] then
                        --if `WEAPON_COMBATPDW` == curw then
                            inArea = true
                        --end
                    end
                end
				if not inArea then
                    origin = true
                    if IsPedCurrentWeaponSilenced(ped) then
						TriggerEvent("civilian:alertPolice",15.0,"gunshot",0,true)
                    elseif isInVehicle then
						TriggerEvent("civilian:alertPolice",150.0,"gunshotvehicle",0,true)
                    else
						TriggerEvent("civilian:alertPolice",550.0,"gunshot",0,true)
                    end

                    --Wait(60000)
                    origin = false
                end
            end

            if timercheck == 0 then
                armed = false
            else
                timercheck = timercheck - 1
            end
        else
             Citizen.Wait(5000)
        end
    end
end)

RegisterNetEvent('prp-outlawalert:gunshotInProgress')
AddEventHandler('prp-outlawalert:gunshotInProgress', function(plyPos)
	if exports['isPed']:isPed('job') == 'Police' then
		if 1 + 1 == 2 then
			local alpha = 250
			local targetCoords = GetEntityCoords(PlayerPedId(), true)
			local gunshotBlip = AddBlipForCoord(plyPos.x, plyPos.y, plyPos.z)

			SetBlipScale(gunshotBlip, 1.3)
			SetBlipSprite(gunshotBlip,  432)
			SetBlipColour(gunshotBlip,  1)
			SetBlipAlpha(gunshotBlip, alpha)
			SetBlipAsShortRange(gunshotBlip, true)
			BeginTextCommandSetBlipName("STRING")              -- set the blip's legend caption
			AddTextComponentString('10-71 Shots Fired')              -- to 'supermarket'
			EndTextCommandSetBlipName(gunshotBlip)
			SetBlipAsShortRange(gunshotBlip,  1)
			PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

			while alpha ~= 0 do
				Citizen.Wait(Config.BlipGunTime * 4)
				alpha = alpha - 1
				SetBlipAlpha(gunshotBlip, alpha)

				if alpha == 0 then
					RemoveBlip(gunshotBlip)
					return
				end
			end

		end
	end
end)

---- Fight ----

Citizen.CreateThread( function()
    local origin3 = false
    while true do
        Wait(1)
        if GetVehiclePedIsUsing(PlayerPedId()) == 0 then
            if IsPedInMeleeCombat(PlayerPedId()) and not origin3 and getRandomNpc(3.0) then
                origin3 = true
                TriggerEvent("civilian:alertPolice",15.0,"fight",0)
                Wait(20000)
                origin3 = false
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

RegisterNetEvent('prp-outlawalert:combatInProgress')
AddEventHandler('prp-outlawalert:combatInProgress', function(playerPos)
	if exports['isPed']:isPed('job') == 'Police' then	
		if Config.gunAlert then
			local alpha = 250
			local targetCoords = GetEntityCoords(PlayerPedId(), true)
			local knife = AddBlipForCoord(playerPos.x, playerPos.y, playerPos.z)

			SetBlipScale(knife, 1.3)
			SetBlipSprite(knife,  437)
			SetBlipColour(knife,  1)
			SetBlipAlpha(knife, alpha)
			SetBlipAsShortRange(knife, true)
			BeginTextCommandSetBlipName("STRING")              -- set the blip's legend caption
			AddTextComponentString('10-11 Fight In Progress')              -- to 'supermarket'
			EndTextCommandSetBlipName(knife)
			SetBlipAsShortRange(knife,  1)
			PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

			while alpha ~= 0 do
				Citizen.Wait(Config.BlipGunTime * 4)
				alpha = alpha - 1
				SetBlipAlpha(knife, alpha)

				if alpha == 0 then
					RemoveBlip(knife)
					return
				end
			end

		end
	end
end)


---- 10-13s Officer Down ----

RegisterNetEvent('police:tenThirteenA')
AddEventHandler('police:tenThirteenA', function()
		local pos = GetEntityCoords(PlayerPedId(),  true)
		local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
		local Player = LocalPlayer:getCurrentCharacter()
		TriggerServerEvent("dispatch:svNotify", {
			dispatchCode = "10-13A",
			firstStreet = GetStreetAndZone(),
			callSign = Player.callsign,
			isImportant = true,
			priority = 3,
			dispatchMessage = "Officer Down",
			origin = {
				x = pos.x,
				y = pos.y,
				z = pos.z
			  }
		})
		TriggerServerEvent('prp-blips:officerdownA', pos)
end)

RegisterNetEvent('prp-alerts:policealertA')
AddEventHandler('prp-alerts:policealertA', function(plyPos)
  if exports['isPed']:isPed('job') == 'Police' or exports['isPed']:isPed('job') == 'EMS' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local policedown = AddBlipForCoord(plyPos.x, plyPos.y, plyPos.z)

		SetBlipSprite(policedown,  126)
		SetBlipColour(policedown,  1)
		SetBlipScale(policedown, 1.3)
		SetBlipAsShortRange(policedown,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-13A Officer Down')
		EndTextCommandSetBlipName(policedown)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', '10-1314', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(policedown, alpha)

		if alpha == 0 then
			RemoveBlip(policedown)
		return
      end
    end
  end
end)

RegisterNetEvent('police:tenThirteenB')
AddEventHandler('police:tenThirteenB', function()
	if exports['isPed']:isPed('job') == 'Police' or exports['isPed']:isPed('job') == 'EMS' then	
		local pos = GetEntityCoords(PlayerPedId(),  true)
		local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
		local Player = LocalPlayer:getCurrentCharacter()
		TriggerServerEvent("dispatch:svNotify", {
			dispatchCode = "10-13B",
			firstStreet = GetStreetAndZone(),
			callSign = Player.callsign,
			isImportant = false,
			priority = 3,
			dispatchMessage = "Officer Down",
			origin = {
				x = pos.x,
				y = pos.y,
				z = pos.z
			}
		})
		TriggerServerEvent('prp-blips:officerdownB', pos)
	end
end)

RegisterNetEvent('prp-alerts:policealertB')
AddEventHandler('prp-alerts:policealertB', function(plyCoords)
if exports['isPed']:isPed('job') == 'Police' or exports['isPed']:isPed('job') == 'EMS' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local policedown2 = AddBlipForCoord(plyCoords.x, plyCoords.y, plyCoords.z)

		SetBlipSprite(policedown2,  126)
		SetBlipColour(policedown2,  1)
		SetBlipScale(policedown2, 1.3)
		SetBlipAsShortRange(policedown2,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-13B Officer Down')
		EndTextCommandSetBlipName(policedown2)
		PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(policedown2, alpha)

		if alpha == 0 then
			RemoveBlip(policedown2)
		return
      end
    end
  end
end)

RegisterCommand('nuifalse', function()
	SetNuiFocus(false, false)
end)

RegisterNetEvent('police:panic')
AddEventHandler('police:panic', function()
		local pos = GetEntityCoords(PlayerPedId(),  true)
		local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
		local Player = LocalPlayer:getCurrentCharacter()
		TriggerServerEvent("dispatch:svNotify", {
			dispatchCode = "10-78",
			firstStreet = GetStreetAndZone(),
			callSign2 = Player.callsign,
			isImportant = false,
			priority = 3,
			dispatchMessage = "Panic Button",
			origin = {
				x = pos.x,
				y = pos.y,
				z = pos.z
			}
		})
		TriggerServerEvent('prp-alerts:panic', pos)
		TriggerEvent("animation:phonecall")
end)

RegisterNetEvent('prp-alerts:panic')
AddEventHandler('prp-alerts:panic', function(plyCoords)
if exports['isPed']:isPed('job') == 'Police' or exports['isPed']:isPed('job') == 'EMS' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local panic = AddBlipForCoord(plyCoords.x, plyCoords.y, plyCoords.z)

		SetBlipSprite(panic,  126)
		SetBlipColour(panic,  1)
		SetBlipScale(panic, 1.3)
		SetBlipAsShortRange(panic,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-78 Officer Panic Botton')
		EndTextCommandSetBlipName(panic)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', '10-1314', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(panic, alpha)

		if alpha == 0 then
			RemoveBlip(panic)
		return
      end
    end
  end
end)


---- 10-14 EMS ----

RegisterNetEvent("police:tenForteenA")
AddEventHandler("police:tenForteenA", function()	
if exports['isPed']:isPed('job') == 'Police' or exports['isPed']:isPed('job') == 'EMS' then	
	local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
	local Player = LocalPlayer:getCurrentCharacter()
	local pos = GetEntityCoords(PlayerPedId(),  true)
	TriggerServerEvent("dispatch:svNotify", {
		dispatchCode = "10-14A",
		firstStreet = GetStreetAndZone(),
		callSign = Player.callsign,
		isImportant = true,
		priority = 3,
		dispatchMessage = "Medic Down",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z
		}
	})
		TriggerServerEvent('prp-blips:medicDownA', pos)
	end
end)

RegisterNetEvent('prp-alerts:tenForteenA')
AddEventHandler('prp-alerts:tenForteenA', function(plyCoords)
  if exports['isPed']:isPed('job') == 'Police' or exports['isPed']:isPed('job') == 'EMS' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local medicDown = AddBlipForCoord(plyCoords.x, plyCoords.y, plyCoords.z)

		SetBlipSprite(medicDown,  126)
		SetBlipColour(medicDown,  1)
		SetBlipScale(medicDown, 1.3)
		SetBlipAsShortRange(medicDown,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-14A Medic Down')
		EndTextCommandSetBlipName(medicDown)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'polalert', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(medicDown, alpha)

		if alpha == 0 then
			RemoveBlip(medicDown)
		return
      end
    end
  end
end)

RegisterNetEvent("police:tenForteenB")
AddEventHandler("police:tenForteenB", function()
if exports['isPed']:isPed('job') == 'Police' or exports['isPed']:isPed('job') == 'EMS' then	
	local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
	local Player = LocalPlayer:getCurrentCharacter()
	local pos = GetEntityCoords(PlayerPedId(),  true)
	TriggerServerEvent("dispatch:svNotify", {
		dispatchCode = "10-14B",
		firstStreet = GetStreetAndZone(),
		callSign = Player.callsign,
		isImportant = false,
		priority = 3,
		dispatchMessage = "Medic Down",
		origin = {
			x = pos.x,
			y = pos.y,
			z = pos.z
		}
	})
		TriggerServerEvent('prp-blips:medicDownB', pos)
	end
end)

RegisterNetEvent('prp-alerts:tenForteenB')
AddEventHandler('prp-alerts:tenForteenB', function(plyCoords)
if exports['isPed']:isPed('job') == 'Police' or exports['isPed']:isPed('job') == 'EMS' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local medicDown2 = AddBlipForCoord(plyCoords.x, plyCoords.y, plyCoords.z)

		SetBlipSprite(medicDown2,  126)
		SetBlipColour(medicDown2,  1)
		SetBlipScale(medicDown2, 1.3)
		SetBlipAsShortRange(medicDown2,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-14B Officer Down')
		EndTextCommandSetBlipName(medicDown2)
		PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(medicDown2, alpha)

		if alpha == 0 then
			RemoveBlip(medicDown2)
		return
      end
    end
  end
end)

---- Down Person ----

RegisterNetEvent('prp-alerts:downalert')
AddEventHandler('prp-alerts:downalert', function(targetCoords)
if exports['isPed']:isPed('job') == 'Police' or exports['isPed']:isPed('job') == 'EMS' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local injured = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite(injured,  126)
		SetBlipColour(injured,  18)
		SetBlipScale(injured, 1.5)
		SetBlipAsShortRange(injured,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-47 Injured Person')
		EndTextCommandSetBlipName(injured)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'dispatch', 0.1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(injured, alpha)

		if alpha == 0 then
			RemoveBlip(injured)
		return
      end
    end
  end
end)

---- Car Crash ----
RegisterNetEvent('prp-alerts:vehiclecrash')
AddEventHandler('prp-alerts:vehiclecrash', function(plyPos)
if exports['isPed']:isPed('job') == 'Police' or exports['isPed']:isPed('job') == 'EMS' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local injured = AddBlipForCoord(plyPos.x, plyPos.y, plyPos.z)

		SetBlipSprite(injured,  488)
		SetBlipColour(injured,  1)
		SetBlipScale(injured, 1.5)
		SetBlipAsShortRange(injured,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-50 Vehicle Crash')
		EndTextCommandSetBlipName(injured)
		PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(injured, alpha)

		if alpha == 0 then
			RemoveBlip(injured)
		return
      end
    end
  end
end)

---- Vehicle Theft ----

RegisterNetEvent('prp-alerts:vehiclesteal')
AddEventHandler('prp-alerts:vehiclesteal', function(plyPos)
if exports['isPed']:isPed('job') == 'Police' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local thiefBlip = AddBlipForCoord(plyPos.x, plyPos.y, plyPos.z)

		SetBlipSprite(thiefBlip,  488)
		SetBlipColour(thiefBlip,  1)
		SetBlipScale(thiefBlip, 1.5)
		SetBlipAsShortRange(thiefBlip,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-60 Vehicle Theft')
		EndTextCommandSetBlipName(thiefBlip)
		PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(thiefBlip, alpha)

		if alpha == 0 then
			RemoveBlip(thiefBlip)
		return
      end
    end
  end
end)

-- Downed person --

RegisterNetEvent('prp-alerts:downedperson')
AddEventHandler('prp-alerts:downedperson', function(plyPos)
	if exports['isPed']:isPed('job') == 'Police' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local thiefBlip = AddBlipForCoord(plyPos.x, plyPos.y, plyPos.z)

		SetBlipSprite(thiefBlip,  429)
		SetBlipColour(thiefBlip,  1)
		SetBlipScale(thiefBlip, 1.5)
		SetBlipAsShortRange(thiefBlip,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-47 Downed Person')
		EndTextCommandSetBlipName(thiefBlip)
		PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(thiefBlip, alpha)

		if alpha == 0 then
			RemoveBlip(thiefBlip)
		return
      end
    end
  end
  if exports['isPed']:isPed('job') == 'EMS' then	
	local alpha = 250
	local targetCoords = GetEntityCoords(PlayerPedId(), true)
	local thiefBlip = AddBlipForCoord(plyPos.x, plyPos.y, plyPos.z)

	SetBlipSprite(thiefBlip,  429)
	SetBlipColour(thiefBlip,  1)
	SetBlipScale(thiefBlip, 1.5)
	SetBlipAsShortRange(thiefBlip,  1)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('10-47 Downed Person')
	EndTextCommandSetBlipName(thiefBlip)
	PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

	while alpha ~= 0 do
		Citizen.Wait(120 * 4)
		alpha = alpha - 1
		SetBlipAlpha(thiefBlip, alpha)

	if alpha == 0 then
		RemoveBlip(thiefBlip)
	return
  end
end
end
end)

-- Drug selling --

RegisterNetEvent('prp-alerts:drugjob')
AddEventHandler('prp-alerts:drugjob', function(plyPos)
if exports['isPed']:isPed('job') == 'Police' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local thiefBlip = AddBlipForCoord(plyPos.x, plyPos.y, plyPos.z)

		SetBlipSprite(thiefBlip,  51)
		SetBlipColour(thiefBlip,  1)
		SetBlipScale(thiefBlip, 1.5)
		SetBlipAsShortRange(thiefBlip,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-15 Drug Selling in Progress')
		EndTextCommandSetBlipName(thiefBlip)
		PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(thiefBlip, alpha)

		if alpha == 0 then
			RemoveBlip(thiefBlip)
		return
      end
    end
  end
end)

RegisterNetEvent('prp-alerts:vehiclesuspicion')
AddEventHandler('prp-alerts:vehiclesuspicion', function(plyPos)
if exports['isPed']:isPed('job') == 'Police' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local thiefBlip = AddBlipForCoord(plyPos.x, plyPos.y, plyPos.z)

		SetBlipSprite(thiefBlip,  51)
		SetBlipColour(thiefBlip,  1)
		SetBlipScale(thiefBlip, 1.5)
		SetBlipAsShortRange(thiefBlip,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-57 Strong Odors Coming From A Van')
		EndTextCommandSetBlipName(thiefBlip)
		PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(thiefBlip, alpha)

		if alpha == 0 then
			RemoveBlip(thiefBlip)
		return
      end
    end
  end
end)

---- Store Robbery ----

RegisterNetEvent('prp-alerts:storerobbery')
AddEventHandler('prp-alerts:storerobbery', function(plyPos)
if exports['isPed']:isPed('job') == 'Police' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local store = AddBlipForCoord(plyPos.x, plyPos.y, plyPos.z)

		SetBlipHighDetail(store, true)
		SetBlipSprite(store,  52)
		SetBlipColour(store,  1)
		SetBlipScale(store, 1.3)
		SetBlipAsShortRange(store,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-31B Robbery In Progress')
		EndTextCommandSetBlipName(store)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'bankalarm', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(store, alpha)

		if alpha == 0 then
			RemoveBlip(store)
		return
      end
    end
  end
end)

RegisterNetEvent('prp-alerts:fleecarobbery')
AddEventHandler('prp-alerts:fleecarobbery', function(plyPos)
	if exports['isPed']:isPed('job') == 'Police' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local truck = AddBlipForCoord(plyPos.x, plyPos.y, plyPos.z)

		SetBlipSprite(truck,  118)
		SetBlipColour(truck,  2)
		SetBlipScale(truck, 1.5)
		SetBlipAsShortRange(Blip,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-90 Fleeca Robbery In Progress')
		EndTextCommandSetBlipName(truck)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'bankalarm', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(truck, alpha)

		if alpha == 0 then
			RemoveBlip(truck)
		return
      end
    end
  end
end)

---- Big Bank Robbery ----

RegisterNetEvent('prp-alerts:bigbankrobbery')
AddEventHandler('prp-alerts:bigbankrobbery', function(plyPos)
	if exports['isPed']:isPed('job') == 'Police' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local truck = AddBlipForCoord(plyPos.x, plyPos.y, plyPos.z)

		SetBlipSprite(truck,  118)
		SetBlipColour(truck,  2)
		SetBlipScale(truck, 1.5)
		SetBlipAsShortRange(Blip,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-90 Big Bank Robbery In Progress')
		EndTextCommandSetBlipName(truck)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'bankalarm', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(truck, alpha)

		if alpha == 0 then
			RemoveBlip(truck)
		return
      end
    end
  end
end)

---- Power Plant ----

RegisterNetEvent('prp-alerts:powerplant')
AddEventHandler('prp-alerts:powerplant', function(plyPos)
	if exports['isPed']:isPed('job') == 'Police' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local truck = AddBlipForCoord(plyPos.x, plyPos.y, plyPos.z)

		SetBlipSprite(truck,  486)
		SetBlipColour(truck,  2)
		SetBlipScale(truck, 1.5)
		SetBlipAsShortRange(Blip,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-90 Power Plant Hit In Progress')
		EndTextCommandSetBlipName(truck)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'bankalarm', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(truck, alpha)

		if alpha == 0 then
			RemoveBlip(truck)
		return
      end
    end
  end
end)

---- House Robbery ----

RegisterNetEvent('prp-alerts:houserobbery')
AddEventHandler('prp-alerts:houserobbery', function(plyPos)
if exports['isPed']:isPed('job') == 'Police' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local burglary = AddBlipForCoord(plyPos.x, plyPos.y, plyPos.z)

		SetBlipHighDetail(burglary, true)
		SetBlipSprite(burglary,  411)
		SetBlipColour(burglary,  1)
		SetBlipScale(burglary, 1.3)
		SetBlipAsShortRange(burglary,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-31A Burglary')
		EndTextCommandSetBlipName(burglary)
		PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(burglary, alpha)

		if alpha == 0 then
			RemoveBlip(burglary)
		return
      end
    end
  end
end)

---- Bank Truck ----

RegisterNetEvent('prp-alerts:banktruck')
AddEventHandler('prp-alerts:banktruck', function(plyPos)
	if exports['isPed']:isPed('job') == 'Police' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local truck = AddBlipForCoord(plyPos.x, plyPos.y, plyPos.z)

		SetBlipSprite(truck,  477)
		SetBlipColour(truck,  47)
		SetBlipScale(truck, 1.5)
		SetBlipAsShortRange(Blip,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-90 Bank Truck In Progress')
		EndTextCommandSetBlipName(truck)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'bankalarm', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(truck, alpha)

		if alpha == 0 then
			RemoveBlip(truck)
		return
      end
    end
  end
end)

---- Jewerly Store ----

RegisterNetEvent('prp-alerts:jewelrobbey')
AddEventHandler('prp-alerts:jewelrobbey', function()
	if exports['isPed']:isPed('job') == 'Police' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local jew = AddBlipForCoord(-634.02, -239.49, 38)

		SetBlipSprite(jew,  487)
		SetBlipColour(jew,  4)
		SetBlipScale(jew, 1.8)
		SetBlipAsShortRange(Blip,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-90 In Progress')
		EndTextCommandSetBlipName(jew)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'bankalarm', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(jew, alpha)

		if alpha == 0 then
			RemoveBlip(jew)
		return
      end
    end
  end
end)

---- Jail Break ----

RegisterNetEvent('prp-alerts:jailbreak')
AddEventHandler('wrp-alerts:jailbreak', function(plyPos)
	if exports['isPed']:isPed('job') == 'Police' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local jail = AddBlipForCoord(1779.65, 2590.39, 50.49)

		SetBlipSprite(jail,  487)
		SetBlipColour(jail,  4)
		SetBlipScale(jail, 1.8)
		SetBlipAsShortRange(jail,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-98 Jail Break')
		EndTextCommandSetBlipName(jail)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'bankalarm', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(jail, alpha)

		if alpha == 0 then
			RemoveBlip(jail)
		return
      end
    end
  end
end)