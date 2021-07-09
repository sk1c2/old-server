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
local plyPed = PlayerPedId()
local xhairActive = false
local disableXhair = false

RegisterCommand("togglexhair", function()
    disableXhair = not disableXhair
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        plyPed = PlayerPedId()
        isArmed = IsPedArmed(plyPed, 7)

        if isArmed then
            if IsPlayerFreeAiming(PlayerId()) then
                if not xhairActive then
                    SendNUIMessage("xhairShow")
                    xhairActive = true
                end
            elseif xhairActive then
                SendNUIMessage("xhairHide")
                xhairActive = false
            end
        elseif IsPedInAnyVehicle(plyPed, false) then
            if xhairActive then
                SendNUIMessage("xhairHide")
                xhairActive = false
            end
        else
            if xhairActive then
                SendNUIMessage("xhairHide")
                xhairActive = false
            end
        end
    end
end)