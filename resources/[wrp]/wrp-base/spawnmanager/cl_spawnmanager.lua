URP.SpawnManager = {}

function URP.SpawnManager.Initialize(self)
    Citizen.CreateThread(function()
        FreezeEntityPosition(PlayerPedId(), true)

        TransitionToBlurred(500)
        DoScreenFadeOut(500)

        ShutdownLoadingScreen()

        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)

        SetCamRot(cam, 0.0, 0.0, -45.0, 2)
        SetCamCoord(cam, -682.0, -1092.0, 226.0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)

        local ped = PlayerPedId()

        SetEntityCoordsNoOffset(ped, -682.0, -1092.0, 200.0, false, false, false, true)

        SetEntityVisible(ped, false)

        TriggerEvent("wrp-base:spawnInitialized")
        TriggerServerEvent("wrp-base:spawnInitialized")

        DoScreenFadeIn(500)

        while IsScreenFadingIn() do
            Citizen.Wait(2)
        end
    end)
end

function URP.SpawnManager.InitializeSwapChar(self)
    Citizen.CreateThread(function()
        FreezeEntityPosition(PlayerPedId(), true)

        TransitionToBlurred(500)
        DoScreenFadeOut(500)

        ShutdownLoadingScreen()

        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)

        SetCamRot(cam, 0.0, 0.0, -45.0, 2)
        SetCamCoord(cam, -682.0, -1092.0, 226.0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)

        local ped = PlayerPedId()

        SetEntityCoordsNoOffset(ped, -682.0, -1092.0, 200.0, false, false, false, true)

        SetEntityVisible(ped, false)

        DoScreenFadeIn(500)

        while IsScreenFadingIn() do
            Citizen.Wait(0)
        end
    end)
end

RegisterNetEvent('wrp-base:SwapChar')
AddEventHandler('wrp-base:SwapChar', function()
    URP.SpawnManager:InitializeSwapChar()
end)

cam = 0
function URP.SpawnManager.InitialSpawn(self)
    Citizen.CreateThread(function()
        DisableAllControlActions(0)

        TransitionToBlurred(500)        
        DoScreenFadeOut(500)

        while IsScreenFadingOut() do
            Citizen.Wait(3)
        end

        -- local character = URP.LocalPlayer:getCurrentCharacter()
        --local new = character.new == 1

        local spawn = URP.Enums.SpawnLocations.Initial[1]

        spawn = {
            model = "mp_m_freemode_01",
            x = spawn[1],
            y = spawn[2],
            z = spawn[3],
            heading = spawn[4]
        }

        if spawn.model then
            RequestModel(spawn.model)

            while not HasModelLoaded(spawn.model) do
                RequestModel(spawn.model)
                Wait(0)
            end

            SetPlayerModel(PlayerId(), spawn.model)
            SetModelAsNoLongerNeeded(spawn.model)
            SetPedDefaultComponentVariation(PlayerPedId())
        end

        --TriggerEvent("wrp-base:initialSpawnModelLoaded")

        RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

        local ped = PlayerPedId()

        SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)

        SetEntityVisible(ped, true)
        FreezeEntityPosition(PlayerPedId(), false)

        NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)
        
        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped)
        --ClearPlayerWantedLevel(PlayerId())

        local startedCollision = GetGameTimer()

        while not HasCollisionLoadedAroundEntity(ped) do
            if GetGameTimer() - startedCollision > 8000 then break end
            Citizen.Wait(0)
        end

        Citizen.Wait(500)
        local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
        local Player = LocalPlayer:getCurrentCharacter()
        TriggerServerEvent('hotel:createRoom', Player.id)
        
        while IsScreenFadingIn() do
            Citizen.Wait(3)
        end

        TransitionFromBlurred(500)
        EnableAllControlActions(0)

        --if new then TriggerEvent("wrp-base:newCharacterSpawned") end
        TriggerEvent("wrp-base:playerSpawned")
        --TriggerEvent("playerSpawned")
    end)
end

function runCams()
    DoScreenFadeOut(100)
    Citizen.Wait(100)
    startcam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    cam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    RenderScriptCams(false, true, 500, true, true)
    SetCamActiveWithInterp(cam, cam2, 3700, true, true)
    SetEntityVisible(PlayerPedId(), true, 0)
    FreezeEntityPosition(PlayerPedId(), false)
    SetPlayerInvisibleLocally(PlayerPedId(), false)
    SetPlayerInvincible(PlayerPedId(), false)
    killcam = true
    DestroyCam(startcam, false)
    DestroyCam(cam, false)
    DestroyCam(cam2, false)
    Citizen.Wait(2000)
    DoScreenFadeIn(5000)
    Wait(4500)
end

function confirmSpawning(isClothesSpawn)
	Citizen.Wait(1)
	killcam = false
	local camselection = currentselection
	DoScreenFadeOut(1)
	if(not DoesCamExist(cam)) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	local x,y,z,h
    x = -1044.615
    y = -2749.328
    z = 21.36
    h = 324.80
	
	i = 3200
	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
	SetCamActive(cam,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	DoScreenFadeIn(1500)
	local camAngle = -90.0
	while i > 1 and camselection == currentselection and not killcam do
		local factor = i / 50
		if i < 1 then i = 1 end
		i = i - factor
		SetCamCoord(cam, x,y,z+i)
		if i < 1200 then
			DoScreenFadeIn(600)
		end
		if i < 90.0 then
			camAngle = i - i - i
		end
		SetCamRot(cam, camAngle, 0.0, 0.0)
		Citizen.Wait(1)
    end
end

AddEventHandler("wrp-base:firstSpawn", function()
    URP.SpawnManager:InitialSpawn()

    Citizen.CreateThread(function()
        Citizen.Wait(600)
        DestroyAllCams(true)
        RenderScriptCams(false, true, 1, true, true)
        FreezeEntityPosition(PlayerPedId(), false)
    end)
end)

RegisterNetEvent('wrp-base:clearStates')
AddEventHandler('wrp-base:clearStates', function()
 	TriggerEvent("isJudgeOff")
    TriggerEvent("nowCopSpawnOff")
    TriggerEvent("nowEMSDeathOff")
    TriggerEvent("police:noLongerCop")
    TriggerEvent("nowCopDeathOff")
    TriggerEvent("ResetFirstSpawn")
    TriggerEvent("stopSpeedo")
    TriggerEvent("keys:reset")
    TriggerEvent("phone:reset")
    TriggerServerEvent("fuckmylifelmao")
    TriggerServerEvent("judge:commandsoff")
    TriggerServerEvent("doctor:commandsoff")
    TriggerServerEvent("TokoVoip:removePlayerFromAllRadio",GetPlayerServerId(PlayerId()))
    TriggerEvent("wk:disableRadar")
end)
