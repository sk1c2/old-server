local pillboxTeleports = {
    { x = 325.48892211914, y = -598.75372314453, z = 43.291839599609, h = 64.513374328613, text = 'Press ~INPUT_CONTEXT~ ~s~to go to lower Pillbox Entrance' },
    { x = 355.47183227539, y = -596.26495361328, z = 28.773477554321, h = 245.85662841797, text = 'Press ~INPUT_CONTEXT~ ~s~to enter Pillbox Hospital' },
    { x = 359.57849121094, y = -584.90911865234, z = 28.817169189453, h = 245.85662841797, text = 'Press ~INPUT_CONTEXT~ ~s~to enter Pillbox Hospital' },
}

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

local bedOccupying = nil
local bedObject = nil
local bedOccupyingData = nil

local cam = nil

local inBedDict = "missfinale_c1@"
local inBedAnim = "lying_dead_player0"
local getOutDict = 'switch@franklin@bed'
local getOutAnim = 'sleep_getup_rubeyes'

function PrintHelpText(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function LeaveBed()
    RequestAnimDict(getOutDict)
    while not HasAnimDictLoaded(getOutDict) do
        Citizen.Wait(0)
    end

    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(cam, false)

    SetEntityInvincible(PlayerPedId(), false)

    SetEntityHeading(PlayerPedId(), bedOccupyingData.h - 90)
    TaskPlayAnim(PlayerPedId(), getOutDict , getOutAnim ,8.0, -8.0, -1, 0, 0, false, false, false )
    Citizen.Wait(5000)
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerServerEvent('prp-hospital:server:LeaveBed', bedOccupying)

    FreezeEntityPosition(bedObject, false)
    
    bedOccupying = nil
    bedObject = nil
    bedOccupyingData = nil
end

RegisterNetEvent('prp-hospital:client:RPCheckPos')
AddEventHandler('prp-hospital:client:RPCheckPos', function()
    TriggerServerEvent('prp-hospital:server:RPRequestBed', GetEntityCoords(PlayerPedId()))
end)

RegisterNetEvent('prp-hospital:client:RPSendToBed')
AddEventHandler('prp-hospital:client:RPSendToBed', function(id, data)
    bedOccupying = id
    bedOccupyingData = data

    bedObject = GetClosestObjectOfType(data.x, data.y, data.z, 1.0, data.model, false, false, false)
    FreezeEntityPosition(bedObject, true)

    SetEntityCoords(PlayerPedId(), data.x, data.y, data.z)
    
    RequestAnimDict(inBedDict)
    while not HasAnimDictLoaded(inBedDict) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(PlayerPedId(), inBedDict , inBedAnim ,8.0, -8.0, -1, 1, 0, false, false, false )
    SetEntityHeading(PlayerPedId(), data.h + 180)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(cam, PlayerPedId(), 31085, 0, 0, 1.0 , true)
    SetCamFov(cam, 90.0)
    SetCamRot(cam, -90.0, 0.0, GetEntityHeading(PlayerPedId()) + 180, true)

    SetEntityInvincible(PlayerPedId(), true)
            

    Citizen.CreateThread(function()
        while bedOccupyingData ~= nil do
            Citizen.Wait(1)
            PrintHelpText('Press ~INPUT_VEH_DUCK~ to get up')
            if IsControlJustReleased(0, 56) then
                LeaveBed()
            end
        end
    end)
end)

RegisterNetEvent('prp-hospital:client:SendToBed')
AddEventHandler('prp-hospital:client:SendToBed', function(id, data)
    bedOccupying = id
    bedOccupyingData = data

    bedObject = GetClosestObjectOfType(data.x, data.y, data.z, 1.0, data.model, false, false, false)
    FreezeEntityPosition(bedObject, true)

    SetEntityCoords(PlayerPedId(), data.x, data.y, data.z)
    RequestAnimDict(inBedDict)
    while not HasAnimDictLoaded(inBedDict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), inBedDict , inBedAnim ,8.0, -8.0, -1, 1, 0, false, false, false )
    SetEntityHeading(PlayerPedId(), data.h + 180)
    SetEntityInvincible(PlayerPedId(), true)
    SetEntityHeading(PlayerPedId(), GetEntityHeading(bed))

    Citizen.CreateThread(function ()
        Citizen.Wait(5)
        local player = PlayerPedId()
        
        TriggerEvent('DoLongHudText', 'Doctors Are Treating You')
        Citizen.Wait(Config.AIHealTimer * 1000)
        TriggerServerEvent('prp-hospital:server:EnteredBed')
        TriggerEvent('prp-hospital:client:RemoveBleed')
    end)
end)

RegisterNetEvent('prp-hospital:client:FinishNancy')
AddEventHandler('prp-hospital:client:FinishNancy', function()
	SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
    TriggerEvent('prp-hospital:client:RemoveBleed')
    TriggerEvent('prp-hospital:client:ResetLimbs')
    TriggerEvent('DoLongHudText', 'Treated.')
end)

RegisterNetEvent('prp-hospital:client:FinishServices')
AddEventHandler('prp-hospital:client:FinishServices', function()
	SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
    TriggerEvent('prp-hospital:client:RemoveBleed')
    TriggerEvent('prp-hospital:client:ResetLimbs')
    TriggerEvent('DoLongHudText', 'Treated.')
    LeaveBed()
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1)
--         local hspDist = GetDistanceBetweenCoords(hspLocs[1]["x"],hspLocs[1]["y"],hspLocs[1]["z"],GetEntityCoords(GetPlayerPed(-1)),true)
--         if hspDist < 5 then
--             if not IsPedInAnyVehicle(PlayerPedId(), true) then
--                 if hspDist < 2 then
-- 					DrawText3DTest(hspLocs[1]["x"],hspLocs[1]["y"],hspLocs[1]["z"], hspLocs[1]["name"])
--                     if IsControlJustReleased(0, 54) then
--                         if (GetEntityHealth(PlayerPedId()) < 201) or (IsInjuredOrBleeding()) then
--                             RequestAnimDict("anim@narcotics@trash")
--                             while not HasAnimDictLoaded("anim@narcotics@trash") do
--                                 Citizen.Wait(0)
--                             end
--                             TaskPlayAnim(PlayerPedId(), "anim@narcotics@trash" , "drop_front" ,8.0, -8.0, -1, 1, 0, false, false, false )
--                             local finished = exports["prp-taskbar"]:taskBar(1700,"Checking Credentials")
--                             if finished == 100 then
--                                 TriggerEvent('reviveFunction')
--                                 TriggerEvent('prp-hospital:client:FinishServices')
--                                 SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
--                                 TriggerEvent('prp-hospital:client:RemoveBleed')
--                                 TriggerEvent('prp-hospital:client:ResetLimbs')
--                                 SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
--                                 TriggerEvent('prp-hospital:client:RemoveBleed')
--                                 TriggerEvent('prp-hospital:client:ResetLimbs')
--                                 ClearPedTasks(PlayerPedId())
--                                 Citizen.Wait(1000)
--                                 TriggerServerEvent('prp-hospital:server:RequestBed')
--                             end
--                         else
--                             TriggerEvent('DoLongHudText', 'You do not need medical attention', 2)
--                         end
--                     end
--                 end
--             end
--         else
--             Citizen.Wait(1000)
--         end
--     end
-- end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local Getmecuh = PlayerPedId()
		local drawtext = "~b~ E ~w~- To Upper Pillbox"
		local plyCoords = GetEntityCoords(Getmecuh)
		local x,y,z = 345.99, -582.71, 28.79
		local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z ,false)
		if distance <= 1.2 then
			DrawText3Ds(x,y,z, drawtext) 
			if IsControlJustReleased(0, 38) then
				Citizen.Wait(500)
				DoScreenFadeOut(400)
				Citizen.Wait(500)
				SetEntityCoords(Getmecuh, 332.20, -595.64, 43.28)
				Citizen.Wait(250)
				DoScreenFadeIn(250)
			end
		else
			if distance >= 1.2 then
				Citizen.Wait(1000)
				
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