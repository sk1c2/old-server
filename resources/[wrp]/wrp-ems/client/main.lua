Keys = {
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

local FirstSpawn = true

thecount = 0
isCop = false
isEMS = false
ragdol = 1    
local IsDead = false
inwater = false

RegisterNetEvent('nowCopDeathOff')
AddEventHandler('nowCopDeathOff', function()
    isCop = false
end)

RegisterNetEvent('nowCopDeath')
AddEventHandler('nowCopDeath', function()
    isCop = true
    mymodel = GetEntityModel(GetPlayerPed(-1))
end)

RegisterNetEvent('nowEMSDeathOff')
AddEventHandler('nowEMSDeathOff', function()
    isEMS = false
end)

RegisterNetEvent('hasSignedOnEms')
AddEventHandler('hasSignedOnEms', function()
    isEMS = true
end)

function DrawText3DDs(x,y,z, text)
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
RegisterNetEvent("ems:in")
AddEventHandler("ems:in" , function(off)
    local job = exports['isPed']:isPed('job')
    if(off == "true") then
        if job == 'OffEMS' then

            LocalPlayer = exports['wrp-base']:getModule("LocalPlayer")
            Player = LocalPlayer:getCurrentCharacter()
            LocalPlayer:setJob(Player.id, 'EMS')
            TriggerEvent('DoLongHudText', 'You\'re now on duty!')
            TriggerServerEvent('attemptdutyems', 'EMS', exports['isPed']:isPed('cid'), Player.first_name, Player.last_name, Player.callsign)
            TriggerEvent('hasSignedOnEms')
        end
    elseif(off == "false") then
        if job == 'EMS' then
            LocalPlayer = exports['wrp-base']:getModule("LocalPlayer")
            Player = LocalPlayer:getCurrentCharacter()
            LocalPlayer:setJob(Player.id, 'OffEMS')
            TriggerEvent('DoLongHudText', 'You\'re now off duty!')
            TriggerServerEvent('attemptoffdutyems')
            TriggerEvent('nowEMSDeathOff')
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(8)
        local Getmecuh = PlayerPedId()
        local x,y,z = 310.8429, -597.2324, 43.2841
        local drawtext = "[E] Open Menu"

        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 1.2 then
            local job = exports['isPed']:isPed('job')
            if job == 'EMS' or job == 'OffEMS' then
                DrawText3DDs(x,y,z, drawtext) 
                if IsControlJustReleased(0, 38) then
                    exports['wrp-menudialog']:AddButton("Clock In" , "Clock On Duty" , "ems:in" , true)
                    exports['wrp-menudialog']:AddButton("Clock Off" , "Clock Off Duty" , "ems:in", false)
                end
            end
        end
    end
end)

function GetDeath()
    if IsDead then
        return true
    elseif not IsDead then
        return false
    end
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.40, 0.40)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function OnPlayerDeath()
	IsDead = true
	TriggerServerEvent('wrp-ambulancejob:setDeathStatus', true)
    TriggerEvent('wrp-hospital:client:ResetLimbs')
    TriggerEvent('wrp-hospital:client:RemoveBleed')
	deathTimer()

end


RegisterNetEvent('doTimer')
AddEventHandler('doTimer', function()
    while IsDead do
        Citizen.Wait(0)
        if thecount > 0 then
            drawTxt(0.94, 1.44, 1.0,1.0,0.6, "Respawn: ~r~" .. math.ceil(thecount) .. "~w~ seconds remaining", 255, 255, 255, 255)
		else	
            drawTxt(0.94, 1.44, 1.0,1.0,0.6, "~w~ PRESS ~r~H ~w~TO ~r~RESPAWN ~w~ FOR ~r~$5,000 ~w~OR WAIT FOR A ~r~MEDIC", 255, 255, 255, 255)	
        end
    end
end)

dragged = false
RegisterNetEvent('deathdrop')
AddEventHandler('deathdrop', function(beingDragged)
    dragged = beingDragged
    if beingDragged and IsDead then
        --TriggerEvent('resurrect:relationships')
    end
      if not beingDragged and IsDead then
        SetEntityHealth(GetPlayerPed(-1), 200.0)
        SetEntityCoords( GetPlayerPed(-1), GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 0.0, 0.0) )
    end 
end)


RegisterNetEvent('resurrect:relationships')
AddEventHandler('resurrect:relationships', function()
    local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
    NetworkResurrectLocalPlayer(plyPos, true, true, false)
    resetrelations()
end)


RegisterNetEvent('ressurection:relationships:norevive')
AddEventHandler('ressurection:relationships:norevive', function()
    resetrelations()
end)

deathanims = {
    [1] = "dead_a",
    [2] = "dead_b",
    [3] = "dead_c",
    [4] = "dead_d",
    [5] = "dead_e",
    [6] = "dead_f",
    [7] = "dead_g",
    [8] = "dead_h",

}

myanim = "dead_a"

function InVeh()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

function resetrelations()
    Citizen.Wait(1000)
    if isCop or isEMS then
        SetPedRelationshipGroupDefaultHash(GetPlayerPed(-1),GetHashKey('MISSION2'))
        SetPedRelationshipGroupHash(GetPlayerPed(-1),GetHashKey('MISSION2'))
    else
        SetPedRelationshipGroupDefaultHash(GetPlayerPed(-1),GetHashKey('PLAYER'))
        SetPedRelationshipGroupHash(GetPlayerPed(-1),GetHashKey('PLAYER'))
    end
end

local disablingloop = false
RegisterNetEvent('disableAllActions')
AddEventHandler('disableAllActions', function()
    if not disablingloop then
        myanim = "dead_a"
        disablingloop = true
        Citizen.Wait(100)
        while GetEntitySpeed(GetPlayerPed(-1)) > 0.5 do
            Citizen.Wait(1)
        end 
        Citizen.Wait(100)
        TriggerEvent("resurrect:relationships")
      --  SetPedCanRagdoll(GetPlayerPed(-1), false)
        
        TriggerEvent("deathAnim")
        TriggerEvent("disableAllActions2")
        local inveh = 0
        while IsDead do
            if IsEntityInWater(GetPlayerPed(-1)) then
                inwater = true
            else
                inwater = false
            end
            SetEntityInvincible(GetPlayerPed(-1), true)
            Citizen.Wait(1) 
            if InVeh() then
                if not inveh then
                    inveh = true
                end
            elseif not InVeh() and inveh and GetEntityHeightAboveGround(GetPlayerPed(-1)) < 2.0 or inveh == 0 and GetEntityHeightAboveGround(GetPlayerPed(-1)) < 2.0 then
                inveh = false
                Citizen.Trace("Not In Veh DA")
                TriggerEvent("deathAnim")
            elseif not InVeh() then
                if (GetEntitySpeed(GetPlayerPed(-1)) > 0.3  and not inwater) or (not IsEntityPlayingAnim(GetPlayerPed(-1), "dead", myanim, 1) and not inwater) then
                    TriggerEvent("deathAnim")
                elseif (not IsEntityPlayingAnim(GetPlayerPed(-1), "dam_ko", "drown", 1) and inwater) then
                    TriggerEvent("deathAnim")
                end 
            end

        end
        SetEntityInvincible(GetPlayerPed(-1), false)
      --  SetPedCanRagdoll(GetPlayerPed(-1), true)
        disablingloop = false
    end
end)


RegisterNetEvent('disableAllActions2')
AddEventHandler('disableAllActions2', function()

        while IsDead do

            Citizen.Wait(1) 

            DisableInputGroup(0)
            DisableInputGroup(1)
            DisableInputGroup(2)
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 74, true)
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, Keys['W'], true) -- W
			DisableControlAction(0, Keys['A'], true) -- A
			DisableControlAction(0, 31, true) -- S (fault in Keys table!)
			DisableControlAction(0, 30, true) -- D (fault in Keys table!)

			DisableControlAction(0, Keys['R'], true) -- Reload
			DisableControlAction(0, Keys['CAPS'], true) -- Caps Lock
			DisableControlAction(0, Keys['B'], true) -- Point
			DisableControlAction(0, Keys['SPACE'], true) -- Jump
			DisableControlAction(0, Keys['Q'], true) -- Cover
			DisableControlAction(0, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(0, Keys['F'], true) -- Also 'enter'?
			DisableControlAction(0, Keys['LEFTCTRL'], true) -- Prone

			DisableControlAction(0, Keys['F1'], true) -- Disable phone
			DisableControlAction(0, Keys['F2'], true) -- Inventory
			DisableControlAction(0, Keys['F3'], true) -- Animations
			DisableControlAction(0, Keys['F6'], true) -- Job

			DisableControlAction(0, Keys['C'], true) -- Disable looking behind
			DisableControlAction(0, Keys['X'], true) -- Disable clearing animation
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth

			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

            


             
            if IsControlJustPressed(1,29) then
                SetPedToRagdoll(GetPlayerPed(-1), 26000, 26000, 3, 0, 0, 0) 
                 Citizen.Wait(22000)
                 TriggerEvent("deathAnim")
            end

            DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
            DisableControlAction(1, 140, true) --Disables Melee Actions
            DisableControlAction(1, 141, true) --Disables Melee Actions
            DisableControlAction(1, 142, true) --Disables Melee Actions 
            DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
            DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing

        end
        SetPedCanRagdoll(GetPlayerPed(-1), false)
end)

local tryingAnim = false
local enteringveh = false
RegisterNetEvent('respawn:sleepanims')
AddEventHandler('respawn:sleepanims', function()
    if not enteringveh then
        enteringveh = true
        ClearPedTasksImmediately(GetPlayerPed(-1))
        Citizen.Wait(1000)
        enteringveh = false   
    end
end)
function deadcaranim()
   loadAnimDict( "veh@low@front_ps@idle_duck" ) 
   TaskPlayAnim(GetPlayerPed(-1), "veh@low@front_ps@idle_duck", "sit", 8.0, -8, -1, 1, 0, 0, 0, 0)
end
myanim = "dead_a"
RegisterNetEvent('deathAnim')
AddEventHandler('deathAnim', function()
    if not dragged and not tryingAnim and not enteringveh and not InVeh() and IsDead then
        tryingAnim = true
        while GetEntitySpeed(GetPlayerPed(-1)) > 0.5 and not inwater do
            Citizen.Wait(1)
        end        
        Citizen.Trace("Death Anim")
        if inwater then
            SetEntityCoords(GetEntityCoords(GetPlayerPed(-1)))
            SetPedToRagdoll(GetPlayerPed(-1), 26000, 26000, 3, 0, 0, 0) 
        else
            
            loadAnimDict( "dead" ) 
            SetEntityCoords(GetPlayerPed(-1),GetEntityCoords(GetPlayerPed(-1)))
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TaskPlayAnim(GetPlayerPed(-1), "dead", myanim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
        end


        Citizen.Wait(3000)
        tryingAnim = false
    end
end)

function loadAnimDict( dict )
    RequestAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        
        Citizen.Wait( 1 )
    end
end


function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedBeingStunned(GetPlayerPed(-1)) then
		ragdol = 1
		SetPedCanRagdoll(GetPlayerPed(-1), true)
		end
	end
end)

RegisterNetEvent('wrp-ambulancejob:useItem')
AddEventHandler('wrp-ambulancejob:useItem', function(itemName)

	if itemName == 'medkit' then
		local playerPed = PlayerPedId()
		loadAnimDict('amb@world_human_clipboard@male@idle_a')
		TaskPlayAnim( playerPed, "amb@world_human_clipboard@male@idle_a", 'idle_c', 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
 --       exports["urp_taskbar"]:StartDelayedFunction('Healing', 10000, function()
            local finished = exports["wrp-taskbar"]:taskBar(10000,"Hacking")
			if finished == 100 then
			TriggerEvent('wrp-ambulancejob:heal', 'big', true)
			TriggerEvent('wrp-hospital:client:RemoveBleed')
			TriggerEvent('wrp-hospital:client:ResetLimbs')
			ClearPedTasks(playerPed)
		end
	elseif itemName == 'bandage' then
		local playerPed = PlayerPedId()
		loadAnimDict('amb@world_human_clipboard@male@idle_a')
		TaskPlayAnim( playerPed, "amb@world_human_clipboard@male@idle_a", 'idle_c', 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
--        exports["urp_taskbar"]:StartDelayedFunction('Healing', 10000, function()
            local finished = exports["wrp-taskbar"]:taskBar(10000,"Healing")
			if finished == 100 then
			TriggerEvent('wrp-ambulancejob:heal', 'small', true)
			TriggerEvent('wrp-hospital:client:RemoveBleed')
			ClearPedTasks(playerPed)
		end
	end
end)

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)

	TriggerEvent('wrp-hospital:client:RemoveBleed', ped) 
	TriggerEvent('wrp-hospital:client:ResetLimbs', ped)

end

function attemptRevive()
    if IsDead then
        ragdol = 1
        IsDead = false
        isDead = false
        thecount = 240
        TriggerEvent("Heal")
        TriggerEvent('wrp-hospital:client:RemoveBleed') 
        TriggerEvent('wrp-hospital:client:ResetLimbs')
        SetEntityInvincible(GetPlayerPed(-1), false)
        ClearPedBloodDamage(GetPlayerPed(-1))        
        local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
        TriggerEvent("resurrect:relationships")
        ClearPedTasksImmediately(GetPlayerPed(-1))
        Citizen.Wait(500)
        getup()
    end
end

function getup()
    ClearPedSecondaryTask(GetPlayerPed(-1))
    SetPedCanRagdoll(GetPlayerPed(-1), true)
    loadAnimDict( "random@crash_rescue@help_victim_up" ) 
    TaskPlayAnim( GetPlayerPed(-1), "random@crash_rescue@help_victim_up", "helping_victim_to_feet_victim", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    SetCurrentPedWeapon(GetPlayerPed(-1),2725352035,true)
    Citizen.Wait(3000)
    endanimation()
end

RegisterNetEvent("heal")
AddEventHandler('heal', function()
	local ped = GetPlayerPed(-1)
	if DoesEntityExist(ped) and not IsEntityDead(ped) then
		SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
		ragdol = 0
	end
end)

-- Load unloaded IPLs
if Config.LoadIpl then
	Citizen.CreateThread(function()
		RequestIpl('Coroner_Int_on') -- Morgue
	end)
end


--curDist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), 0), 2438.3266601563,4960.3046875,47.27229309082,true)
