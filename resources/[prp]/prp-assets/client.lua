local once = true
local oldval = false
local oldvalped = false

-- Pointing --

local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        BlockWeaponWheelThisFrame()
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(17)
        DisableControlAction(0, 37, true) --Disable Tab
    end
end)

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

TimerEnabled = false

function TryTackle()
    if not TimerEnabled then
        --print("attempting a tackle.")
        t, distance = GetClosestPlayer()
        if(distance ~= -1 and distance < 3) then
            local maxheading = (GetEntityHeading(GetPlayerPed(-1)) + 15.0)
            local minheading = (GetEntityHeading(GetPlayerPed(-1)) - 15.0)
            local theading = (GetEntityHeading(t))

            TriggerServerEvent('CrashTackle',GetPlayerServerId(t))
            TriggerEvent("animation:tacklelol") 

            TimerEnabled = true
            Citizen.Wait(4500)
            TimerEnabled = false
        else
            TimerEnabled = true
            Citizen.Wait(1000)
            TimerEnabled = false
        end
    end
end

RegisterNetEvent('playerTackled')
AddEventHandler('playerTackled', function()
    SetPedToRagdoll(GetPlayerPed(-1), math.random(8500), math.random(8500), 0, 0, 0, 0) 
    TimerEnabled = true
    Citizen.Wait(1500)
    TimerEnabled = false
end)

RegisterNetEvent('animation:tacklelol')
AddEventHandler('animation:tacklelol', function()

    if not handCuffed and not IsPedRagdoll(GetPlayerPed(-1)) then

        local lPed = GetPlayerPed(-1)

        RequestAnimDict("swimming@first_person@diving")
        while not HasAnimDictLoaded("swimming@first_person@diving") do
            Citizen.Wait(1)
        end
            
        if IsEntityPlayingAnim(lPed, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3) then
            ClearPedSecondaryTask(lPed)
        else
            TaskPlayAnim(lPed, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 8.0, -8, -1, 49, 0, 0, 0, 0)
            seccount = 3
            while seccount > 0 do
                Citizen.Wait(100)
                seccount = seccount - 1
            end
            ClearPedSecondaryTask(lPed)
            SetPedToRagdoll(GetPlayerPed(-1), 150, 150, 0, 0, 0, 0) 
        end        
    end
end)

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local closestPed = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then

		for index,value in ipairs(players) do
			local target = GetPlayerPed(value)
			if(target ~= ply) then
				local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
				local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
				if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
					closestPlayer = value
					closestPed = target
					closestDistance = distance
				end
			end
		end
		
		return closestPlayer, closestDistance, closestPed

	else
		TriggerEvent("DoShortHudText","Inside Vehicle.",2)
	end
end

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

--Blind Fire
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local ped = PlayerPedId()
		if IsPedInCover(ped, 1) and not IsPedAimingFromCover(ped, 1) then 
			DisableControlAction(2, 24, true) 
			DisableControlAction(2, 142, true)
			DisableControlAction(2, 257, true)
		end		
	end
end)

-- Camera Lock --

local INPUT_AIM = 0
local INPUT_AIM = 0
local UseFPS = false
local justpressed = 0

-- this prevents certain camera modes
local disable = 0

-- Roll --
RegisterCommand('roll', function(source, args)
    local times = args[1]
    -- print(times)
    local weight = args[2]
    -- print(weight)

    TriggerEvent('roll', times, weight)
end)

RegisterNetEvent("roll")
AddEventHandler("roll",function(times,weight)

    times = tonumber(times)
    weight = tonumber(weight)
    rollAnim()
    local strg = ""
    for i = 1, times do
        if i == 1 then
            strg = strg .. " " .. math.random(weight) .. "/" .. weight
        else
            strg = strg .. " | " .. math.random(weight) .. "/" .. weight
        end

    end
    TriggerServerEvent("3dme:shareDisplay", "Dice rolled " .. strg, GetPlayerServerId(PlayerId()))
end)

function rollAnim()
    loadAnimDict( "anim@mp_player_intcelebrationmale@wank" ) 
    Citizen.Wait(500)
    TaskPlayAnim( PlayerPedId(), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(1500)
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'dice', 0.1)
    ClearPedTasks(PlayerPedId())
    Citizen.Wait(500)
end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict( dict )
        Citizen.Wait(5)
    end
end

function SetWeaponDrops()
    local handle, ped = FindFirstPed()
    local finished = false

    repeat
        if not IsEntityDead(ped) then
            SetPedDropsWeaponsWhenDead(ped, false)
        end
        finished, ped = FindNextPed(handle)
    until not finished

    EndFindPed(handle)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3)
        SetPedModelIsSuppressed(GetHashKey("a_c_seagull"), true)
        SetPedModelIsSuppressed(GetHashKey("a_m_o_ktown_01"), true)
        if IsPedRunning(PlayerPedId()) and IsControlJustReleased(0, 19) then
            TryTackle()
        end
        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Wait(200)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0
                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
            end
        end
    if IsControlPressed(0, INPUT_AIM) then
      justpressed = justpressed + 1
    end

    if IsControlJustReleased(0, INPUT_AIM) then

        if justpressed < 15 then
            UseFPS = true
        end
        justpressed = 0
    end

    if GetFollowPedCamViewMode() == 1 or GetFollowVehicleCamViewMode() == 1 then
        Citizen.Wait(100)
        SetFollowPedCamViewMode(0)
        SetFollowVehicleCamViewMode(0)
    end


    if UseFPS then
        if GetFollowPedCamViewMode() == 0 or GetFollowVehicleCamViewMode() == 0 then
            Citizen.Wait(100)
            
            SetFollowPedCamViewMode(4)
            SetFollowVehicleCamViewMode(4)
        else
            Citizen.Wait(100)
            
            SetFollowPedCamViewMode(0)
            SetFollowVehicleCamViewMode(0)
        end
        UseFPS = false
    end


    if IsPedArmed(ped,1) or not IsPedArmed(ped,7) then
        if IsControlJustPressed(0,24) or IsControlJustPressed(0,141) or IsControlJustPressed(0,142) or IsControlJustPressed(0,140)  then
           disable = 50
        end
    end
    if disable > 0 then
        disable = disable - 1
        DisableControlAction(0,24)
        DisableControlAction(0,140)
        DisableControlAction(0,141)
        DisableControlAction(0,142)
    end
  end
end)

--REMOVE WEAPONS FROM NPCS 
Citizen.CreateThread(function()
    while true do
      Citizen.Wait(1)
      -- List of pickup hashes (https://pastebin.com/8EuSv2r1)
      RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
      RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
      RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
      local ped = GetPlayerPed(-1)
      if IsPedArmed(ped,1) or IsPedArmed(ped,7) then
        DisableControlAction(0, 36)
        DisableControlAction(0, 62)
        DisableControlAction(0, 132)
        DisableControlAction(0, 224)
        DisableControlAction(0, 280)
        DisableControlAction(0, 281)
      end
   end
end)

pressed4 = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2)
        local ped = GetPlayerPed()
        if IsPedArmed(ped,1) or not IsPedArmed(ped,7) then
            if IsControlJustPressed(0, 120) or IsControlJustPressed(0, 73) then
                pressed4 = pressed4 + 1
                if pressed4 >= 3 then
                    TriggerEvent('DoLongHudText', 'Stop trying to X Spam, Reported!', 2)
                elseif pressed4 > 3 then
                    pressed4 = 3
                end
                while pressed4 >= 3 do
                    Citizen.Wait(1)
                    DisableControlAction(0, 120)
                    DisableControlAction(0, 73)
                end
            end
            local ped = GetPlayerPed(-1)
            Citizen.Wait(2)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
    if pressed4 >= 1 then
        Citizen.Wait(5000)
        print(pressed4)
        pressed4 = pressed4 - 1
    end
    Citizen.Wait(2000)
    end
end)

--removebridge
local Tree = false

AddEventHandler("playerSpawned", function ()
    if not Tree then
        ShutdownLoadingScreenNui() 
        Tree = true
    end
end)

-- Crosshair
-- local plyPed = PlayerPedId()
-- local xhairActive = false
-- local disableXhair = false

-- RegisterCommand("togglexhair", function()
--     disableXhair = not disableXhair
-- end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(500)
--         plyPed = PlayerPedId()
--         isArmed = IsPedArmed(plyPed, 7)

--         if isArmed then
--             if IsPlayerFreeAiming(PlayerId()) then
--                     if not xhairActive then
--                         SendNUIMessage("xhairShow")
--                         xhairActive = true
--                     end
--             elseif xhairActive then
--                 SendNUIMessage("xhairHide")
--                 xhairActive = false
--             end
--         elseif IsPedInAnyVehicle(plyPed, false) then
--             if xhairActive then
--                 SendNUIMessage("xhairHide")
--                 xhairActive = false
--             end
--         else
--             if xhairActive then
--                 SendNUIMessage("xhairHide")
--                 xhairActive = false
--             end
--         end

--     end
-- end)

-- Delete Props When Hitting Them With a Vehicle
local Props = {
    [729253480] = true,
    [-655644382] = true,
    [589548997] = true,
    [793482617] = true,
    [1502931467] = true,
    [1803721002] = true,
    [-1651641860] = true,
    [-156356737] = true,
    [1043035044] = true,
    [862871082] = true,
    [-1798594116] = true,
    [865627822] = true,
    [840050250] = true,
    [1821241621] = true,
    [-797331153] = true,
    [-949234773] = true,
    [1191039009] = true,
    [-463994753] = true,
    [-276539604] = true,
    [1021745343] = true,
    [-1063472968] = true,
    [1441261609] = true,
    [-667908451] = true,
    [-365135956] = true,
    [-157127644] = true,
    [-1057375813] = true,
    [-639994124] = true,
    [173177608] = true,
    [-879318991] = true,
    [-1529663453] = true,
    [267702115] = true,
    [1847069612] = true,
    [1452666705] = true,
    [681787797] = true,
    [1868764591] = true,
    [-1648525921] = true,
    [-1114695146] = true,
    [-943634842] = true,
    [-331378834] = true,
    [431612653] = true,
    [-97646180] = true,
    [1437508529] = true,
    [-2007495856] = true,
    [-16208233304] = true,
    [2122387284] = true,
    [1411103374] = true,
    [-216200273] = true,
    [1322893877] = true,
    [93794225] = true,
    [373936410] = true,
    [-872399736] = true,
    [-1178167275] = true,
    [1327054116] = true,
}

Citizen.CreateThread(function()
    while true do
        local PropsToDelete = {}
        local ped = PlayerPedId()
        local idle, success = 1000
        local handle, prop = FindFirstObject()
        repeat               
            if Props[GetEntityModel(prop)] then
                if GetObjectFragmentDamageHealth(prop,true) < 1.0 or (GetObjectFragmentDamageHealth(prop,true) ~= nil and GetEntityHealth(prop) < GetEntityMaxHealth(prop)) then
                    PropsToDelete[#PropsToDelete+1] = prop
                end
            end
            
            success, prop = FindNextObject(handle)
        until not success
        EndFindObject(handle)
        Citizen.Wait(1500)
        for i = 1, #PropsToDelete do
            SetEntityCoords(PropsToDelete[i],0,0,0)
        end
        Citizen.Wait(500)
    end
end)

-- Pop Tires If To High
local highestZ = 0
Citizen.CreateThread(function()
        local waittime = 100
        while true do
            Citizen.Wait(waittime)
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if DoesEntityExist(veh) and not IsEntityDead(veh) then
                local model = GetEntityModel(veh)
                if not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) then
                    local vehpos = GetEntityCoords(veh)
					if IsEntityInAir(veh) then
						--print(vehpos.z)
                        waittime = 0
                        if vehpos.z > highestZ then
							highestZ = vehpos.z
							--print(highestZ)
                        end
                        DisableControlAction(0, 59)
                        DisableControlAction(0, 60)
					else						
						if highestZ - vehpos.z >= 13 then
						--	print(highestZ-vehpos.z)
                            local wheels = {0,1,4,5}
                            for i=1, math.random(2) do
								local wheel = math.random(#wheels)
								--print('pop')
                                SetVehicleTyreBurst(veh, wheels[wheel], false, 1000.0)
                                table.remove(wheels, wheel)
                            end
                            highestZ = 0
							waittime = 100
						end
						if highestZ - vehpos.z >= 13 then
						--	print(highestZ-vehpos.z)
                            for i = 0, 5 do
								if not IsVehicleTyreBurst(veh, i, true) or IsVehicleTyreBurst(veh, i, false) then
								--	print('popall')
                                    SetVehicleTyreBurst(veh, i, false, 1000.0)
                                end 
                            end
                            highestZ = 0
                            waittime = 100                           
                        else
                            highestZ = 0
                            waittime = 100
                        end
                    end
                end
            end
        end
	end)

----------Fire Work Ting--------

local box = nil
local animlib = 'anim@mp_fireworks'


RegisterNetEvent('firework:rocket')
AddEventHandler('firework:rocket', function()

	RequestAnimDict(animlib)

	while not HasAnimDictLoaded(animlib) do
		   Citizen.Wait(10)
    end
        
	if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		RequestNamedPtfxAsset("scr_indep_fireworks")
		while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
		   Wait(10)
		end
	end

	local pedcoords = GetEntityCoords(GetPlayerPed(-1))
	local ped = GetPlayerPed(-1)
	local times = 20

	TaskPlayAnim(ped, animlib, 'place_firework_3_box', -1, -8.0, 3000, 0, 0, false, false, false)
	Citizen.Wait(4000)
	ClearPedTasks(ped)
		   
	box = CreateObject(GetHashKey('ind_prop_firework_01'), pedcoords, true, false, false)
	PlaceObjectOnGroundProperly(box)
	FreezeEntityPosition(box, true)
	local firecoords = GetEntityCoords(box)

	Citizen.Wait(10000)
	repeat
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local part1 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", firecoords, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
	times = times - 1
	Citizen.Wait(2000)
	until(times == 0)
	DeleteEntity(box)
	box = nil
end)

RegisterNetEvent('firework:fountain')
AddEventHandler('firework:fountain', function()

	RequestAnimDict(animlib)

	while not HasAnimDictLoaded(animlib) do
		   Citizen.Wait(10)
    end
        
	if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		RequestNamedPtfxAsset("scr_indep_fireworks")
		while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
		   Wait(10)
		end
	end

	local pedcoords = GetEntityCoords(GetPlayerPed(-1))
	local ped = GetPlayerPed(-1)
	local times = 20

	TaskPlayAnim(ped, animlib, 'place_firework_3_box', -1, -8.0, 3000, 0, 0, false, false, false)
	Citizen.Wait(4000)
	ClearPedTasks(ped)
		   
	box = CreateObject(GetHashKey('ind_prop_firework_04'), pedcoords, true, false, false)
	PlaceObjectOnGroundProperly(box)
	FreezeEntityPosition(box, true)
	local firecoords = GetEntityCoords(box)

	Citizen.Wait(10000)
	repeat
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local part1 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", firecoords, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
	times = times - 1
	Citizen.Wait(2000)
	until(times == 0)
	DeleteEntity(box)
	box = nil
end)

RegisterNetEvent('firework:shotburst')
AddEventHandler('firework:shotburst', function()

	RequestAnimDict(animlib)

	while not HasAnimDictLoaded(animlib) do
		   Citizen.Wait(10)
    end
        
	if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		RequestNamedPtfxAsset("scr_indep_fireworks")
		while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
		   Wait(10)
		end
	end

	local pedcoords = GetEntityCoords(GetPlayerPed(-1))
	local ped = GetPlayerPed(-1)
	local times = 20

	TaskPlayAnim(ped, animlib, 'place_firework_3_box', -1, -8.0, 3000, 0, 0, false, false, false)
	Citizen.Wait(4000)
	ClearPedTasks(ped)
		   
	box = CreateObject(GetHashKey('ind_prop_firework_03'), pedcoords, true, false, false)
	PlaceObjectOnGroundProperly(box)
	FreezeEntityPosition(box, true)
	local firecoords = GetEntityCoords(box)

	Citizen.Wait(10000)
	repeat
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local part1 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", firecoords, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
	times = times - 1
	Citizen.Wait(2000)
	until(times == 0)
	DeleteEntity(box)
	box = nil
end)

-- Map Zoom Sens
Citizen.CreateThread(function()
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)
end)

