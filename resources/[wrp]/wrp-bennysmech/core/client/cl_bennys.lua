--[[
cl_bennys.lua
Functionality that handles the player for Benny's.
Handles applying mods, etc.
]]

--#[Global Variables]#--
isPlyInBennys = false

--#[Local Variables]#--
job = nil
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        job = exports['isPed']:isPed('job')
    end
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


-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(6)
--         local Getmecuh = PlayerPedId()
--         local x,y,z = 1132.957, -778.5645, 57.60438
--         local drawtext = "[E] Open Crafting"
--         local plyCoords = GetEntityCoords(Getmecuh)
--         local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
--         if job == 'HarmonyRepairs' then
--             if distance <= 1.2 then
--                 DrawText3DDs(x,y,z, drawtext) 
--                 if IsControlJustReleased(0, 38) then
--                     TriggerEvent("wrp-ac:triggeredItemSpawn", "30", "Craft");
--                 end
--             end
--         end
--         Getmecuh2 = PlayerPedId()
--         x2,y2,z2 = 1125.621, -778.593, 57.62167
--         drawtext2 = "[E] Open Stash"
--         plyCoords2 = GetEntityCoords(Getmecuh2)
--         distance2 = GetDistanceBetweenCoords(plyCoords2.x,plyCoords2.y,plyCoords2.z,x2,y2,z2,false)
--         if distance2 <= 1.2 then
--             if job == 'HarmonyRepairs' then
--                 if distance2 <= 1.2 then
--                     DrawText3DDs(x2,y2,z2, drawtext2) 
--                     if IsControlJustReleased(0, 38) then
--                         TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "biz")
--                     end
--                 end
--             end
--         end
--         x3,y3,z3 = 1160.185, -779.7595, 57.60514
--         drawtext3 = "[E] Spawn Flatbed | [F] Spawn Tow Truck"
--         plyCoords3 = GetEntityCoords(Getmecuh2)
--         distance3 = GetDistanceBetweenCoords(plyCoords3.x,plyCoords3.y,plyCoords3.z,x3,y3,z3,false)
--         if distance3 <= 1.2 then
--             if job == 'HarmonyRepairs' then
--                 if distance3 <= 1.2 then
--                     DrawText3DDs(x3,y3,z3, drawtext3) 
--                     if IsControlJustReleased(0, 38) then
--                         if DoesEntityExist(flatbed) then
--                             DeleteEntity(flatbed)
--                             TriggerEvent('DoShortHudText', 'Vehicle Despawned', 2)
--                         end
--                         RequestModel('flatbed')
--                         while (not HasModelLoaded('flatbed')) do
--                             Citizen.Wait(100)
--                             RequestModel('flatbed')
--                         end
--                         flatbed = CreateVehicle('flatbed', 1134.714, -795.3476, 57.58862, 67.2077, true,false)
--                         local plate = GetVehicleNumberPlateText(flatbed)
--                         TriggerServerEvent('garage:addKeys', plate)
--                         Citizen.Wait(1000)
--                         TriggerEvent('DoShortHudText', 'Vehicle is Waiting In The Back For You!')
--                     end
--                     if IsControlJustReleased(0, 23) then
--                         if DoesEntityExist(towtruck) then
--                             DeleteEntity(towtruck)
--                             TriggerEvent('DoShortHudText', 'Vehicle Despawned', 2)
--                         end
--                         RequestModel('f450towtruk')
--                         while (not HasModelLoaded('f450towtruk')) do
--                             Citizen.Wait(100)
--                             RequestModel('f450towtruk')
--                         end
--                         towtruck = CreateVehicle('f450towtruk', 1132.007, -797.3289, 57.58514, 0, true,false)
--                         Citizen.Wait(100)
--                         local plate = GetVehicleNumberPlateText(towtruck)
--                         TriggerServerEvent('garage:addKeys', plate)
--                         Citizen.Wait(1000)
--                         TriggerEvent('DoShortHudText', 'Vehicle is Waiting In The Back For You!')
--                     end
--                 end
--             end
--         end
--     end
-- end)

local plyFirstJoin = false


local nearDefault = false
-- Bennys

--TunerShop
local bennyLocation2 = vector3(937.12, -970.84, 38.93)

-- CamelTowing
local bennyLocation3 = vector3(1174.93, 2640.15, 37.75)

-- Quick Fix
local bennyLocation4 = vector3(-1146.16, -2864.62, 13.94)


-- Bennys
local bennyHeading = 319.73135375977
--TunerShop
local bennyHeading2 = 225.25
-- CamelTowing
local bennyHeading3 = 177.08
-- Quick fix
local bennyHeading4 = 331.5

local originalCategory = nil
local originalMod = nil
local originalPrimaryColour = nil
local originalSecondaryColour = nil
local originalPearlescentColour = nil
local originalWheelColour = nil
local originalDashColour = nil
local originalInterColour = nil
local originalWindowTint = nil
local originalWheelCategory = nil
local originalWheel = nil
local originalWheelType = nil
local originalCustomWheels = nil
local originalNeonLightState = nil
local originalNeonLightSide = nil
local originalNeonColourR = nil
local originalNeonColourG = nil
local originalNeonColourB = nil
local originalXenonColour = nil
local originalOldLivery = nil
local originalPlateIndex = nil

local attemptingPurchase = false
local isPurchaseSuccessful = false

--#[Local Functions]#--
local function isNear(pos1, pos2, distMustBe)
    local diff = pos2 - pos1
	local dist = (diff.x * diff.x) + (diff.y * diff.y)

	return (dist < (distMustBe * distMustBe))
end

local function saveVehicle()
    local plyPed = PlayerPedId()
    local veh = GetVehiclePedIsIn(plyPed, false)
    local vehicleMods = {
        neon = {},
        colors = {},
        extracolors = {},
        dashColour = -1,
        interColour = -1,
        lights = {},
        tint = GetVehicleWindowTint(veh),
        wheeltype = GetVehicleWheelType(veh),
        platestyle = GetVehicleNumberPlateTextIndex(veh),
        mods = {},
        smokecolor = {},
        xenonColor = -1,
        oldLiveries = 24,
        extras = {},
        plateIndex = 0,
    }

    vehicleMods.xenonColor = GetCurrentXenonColour(veh)
    vehicleMods.lights[1], vehicleMods.lights[2], vehicleMods.lights[3] = GetVehicleNeonLightsColour(veh)
    vehicleMods.colors[1], vehicleMods.colors[2] = GetVehicleColours(veh)
    vehicleMods.extracolors[1], vehicleMods.extracolors[2] = GetVehicleExtraColours(veh)
    vehicleMods.smokecolor[1], vehicleMods.smokecolor[2], vehicleMods.smokecolor[3] = GetVehicleTyreSmokeColor(veh)
    vehicleMods.dashColour = GetVehicleInteriorColour(veh)
    vehicleMods.interColour = GetVehicleDashboardColour(veh)
    vehicleMods.oldLiveries = GetVehicleLivery(veh)
    vehicleMods.plateIndex = GetVehicleNumberPlateTextIndex(veh)

    for i = 0, 3 do
        vehicleMods.neon[i] = IsVehicleNeonLightEnabled(veh, i)
    end

    for i = 0,16 do
        vehicleMods.mods[i] = GetVehicleMod(veh,i)
    end

    for i = 17, 22 do
        vehicleMods.mods[i] = IsToggleModOn(veh, i)
    end

    for i = 23, 48 do
        vehicleMods.mods[i] = GetVehicleMod(veh,i)
    end

    for i = 1, 12 do
        local ison = IsVehicleExtraTurnedOn(veh, i)
        if 1 == tonumber(ison) then
            vehicleMods.extras[i] = 1
        else
            vehicleMods.extras[i] = 0
        end
    end
	local myCar = exports['wrp-base']:FetchVehProps(veh)
    TriggerServerEvent('updateVehicle2',myCar)  
end

--#[Global Functions]#--
function AttemptPurchase(type, upgradeLevel)

    if upgradeLevel ~= nil then
        upgradeLevel = upgradeLevel + 2
    end
    local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    TriggerServerEvent("wrp-mechanic:attemptPurchase", Player.id, Player.cash, type, upgradeLevel)

    attemptingPurchase = true

    while attemptingPurchase do
        Citizen.Wait(1)
    end

    if not isPurchaseSuccessful then
        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end

    return isPurchaseSuccessful
end

function RepairVehicle()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleFixed(plyVeh)
    SetVehicleDirtLevel(plyVeh, 0.0)
    SetVehiclePetrolTankHealth(plyVeh, 4000.0)
    TriggerEvent('veh.randomDegredation',10,plyVeh,3)
end

function GetCurrentMod(id)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local mod = GetVehicleMod(plyVeh, id)
    local modName = GetLabelText(GetModTextLabel(plyVeh, id, mod))

    return mod, modName
end

function GetCurrentWheel()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local wheel = GetVehicleMod(plyVeh, 23)
    local wheelName = GetLabelText(GetModTextLabel(plyVeh, 23, wheel))
    local wheelType = GetVehicleWheelType(plyVeh)

    return wheel, wheelName, wheelType
end

function GetCurrentCustomWheelState()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local state = GetVehicleModVariation(plyVeh, 23)

    if state then
        return 1
    else
        return 0
    end
end

function GetOriginalWheel()
    return originalWheel
end

function GetOriginalCustomWheel()
    return originalCustomWheels
end

function GetCurrentWindowTint()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    return GetVehicleWindowTint(plyVeh)
end

function GetCurrentVehicleWheelSmokeColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local r, g, b = GetVehicleTyreSmokeColor(plyVeh)

    return r, g, b
end

function GetCurrentNeonState(id)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsVehicleNeonLightEnabled(plyVeh, id)

    if isEnabled then
        return 1
    else
        return 0
    end
end

function GetCurrentNeonColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local r, g, b = GetVehicleNeonLightsColour(plyVeh)

    return r, g, b
end

function GetCurrentXenonState()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsToggleModOn(plyVeh, 22)

    if isEnabled then
        return 1
    else
        return 0
    end
end

function GetCurrentXenonColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    return GetVehicleHeadlightsColour(plyVeh)
end

function GetCurrentTurboState()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsToggleModOn(plyVeh, 18)

    if isEnabled then
        return 1
    else
        return 0
    end
end

function GetCurrentExtraState(extra)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    return IsVehicleExtraTurnedOn(plyVeh, extra)
end

function CheckValidMods(category, id, wheelType)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local tempMod = GetVehicleMod(plyVeh, id)
    local tempWheel = GetVehicleMod(plyVeh, 23)
    local tempWheelType = GetVehicleWheelType(plyVeh)
    local tempWheelCustom = GetVehicleModVariation(plyVeh, 23)
    local validMods = {}
    local amountValidMods = 0
    local hornNames = {}

    if wheelType ~= nil then
        SetVehicleWheelType(plyVeh, wheelType)
    end

    if id == 14 then
        for k, v in pairs(vehicleCustomisation) do 
            if vehicleCustomisation[k].category == category then
                hornNames = vehicleCustomisation[k].hornNames

                break
            end
        end
    end

    local modAmount = GetNumVehicleMods(plyVeh, id)
    for i = 1, modAmount do
        local label = GetModTextLabel(plyVeh, id, (i - 1))
        local modName = GetLabelText(label)

        if modName == "NULL" then
            if id == 14 then
                if i <= #hornNames then
                    modName = hornNames[i].name
                else
                    modName = "Horn " .. i
                end
            else
                modName = category .. " " .. i
            end
        end

        validMods[i] = 
        {
            id = (i - 1),
            name = modName
        }

        amountValidMods = amountValidMods + 1
    end

    if modAmount > 0 then
        table.insert(validMods, 1, {
            id = -1,
            name = "Stock " .. category
        })
    end

    if wheelType ~= nil then
        SetVehicleWheelType(plyVeh, tempWheelType)
        SetVehicleMod(plyVeh, 23, tempWheel, tempWheelCustom)
    end

    return validMods, amountValidMods
end

function RestoreOriginalMod()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleMod(plyVeh, originalCategory, originalMod)
    SetVehicleDoorsShut(plyVeh, true)

    originalCategory = nil
    originalMod = nil
end

function RestoreOriginalWindowTint()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleWindowTint(plyVeh, originalWindowTint)

    originalWindowTint = nil
end

function RestoreOriginalColours()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleColours(plyVeh, originalPrimaryColour, originalSecondaryColour)
    SetVehicleExtraColours(plyVeh, originalPearlescentColour, originalWheelColour)
    SetVehicleDashboardColour(plyVeh, originalDashColour)
    SetVehicleInteriorColour(plyVeh, originalInterColour)

    originalPrimaryColour = nil
    originalSecondaryColour = nil
    originalPearlescentColour = nil
    originalWheelColour = nil
    originalDashColour = nil
    originalInterColour = nil
end

function RestoreOriginalWheels()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local doesHaveCustomWheels = GetVehicleModVariation(plyVeh, 23)

    SetVehicleWheelType(plyVeh, originalWheelType)

    if originalWheelCategory ~= nil then
        SetVehicleMod(plyVeh, originalWheelCategory, originalWheel, originalCustomWheels)
        
        if GetVehicleClass(plyVeh) == 8 then --Motorcycle
            SetVehicleMod(plyVeh, 24, originalWheel, originalCustomWheels)
        end

        originalWheelType = nil
        originalWheelCategory = nil
        originalWheel = nil
        originalCustomWheels = nil
    end
end

function RestoreOriginalNeonStates()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleNeonLightEnabled(plyVeh, originalNeonLightSide, originalNeonLightState)

    originalNeonLightState = nil
    originalNeonLightSide = nil
end

function RestoreOriginalNeonColours()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleNeonLightsColour(plyVeh, originalNeonColourR, originalNeonColourG, originalNeonColourB)

    originalNeonColourR = nil
    originalNeonColourG = nil
    originalNeonColourB = nil
end

function RestoreOriginalXenonColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleHeadlightsColour(plyVeh, originalXenonColour)
    SetVehicleLights(plyVeh, 0)

    originalXenonColour = nil
end

function RestoreOldLivery()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleLivery(plyVeh, originalOldLivery)
end

function RestorePlateIndex()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleNumberPlateTextIndex(plyVeh, originalPlateIndex)
end

function PreviewMod(categoryID, modID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalMod == nil and originalCategory == nil then
        originalCategory = categoryID
        originalMod = GetVehicleMod(plyVeh, categoryID)
    end

    if categoryID == 39 or categoryID == 40 or categoryID == 41 then
        SetVehicleDoorOpen(plyVeh, 4, false, true)
    elseif categoryID == 37 or categoryID == 38 then
        SetVehicleDoorOpen(plyVeh, 5, false, true)
    end

    SetVehicleMod(plyVeh, categoryID, modID)
end

function PreviewWindowTint(windowTintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalWindowTint == nil then
        originalWindowTint = GetVehicleWindowTint(plyVeh)
    end

    SetVehicleWindowTint(plyVeh, windowTintID)
end

function PreviewColour(paintType, paintCategory, paintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    SetVehicleModKit(plyVeh, 0)
    if originalDashColour == nil and originalInterColour == nil and originalPrimaryColour == nil and originalSecondaryColour == nil and originalPearlescentColour == nil and originalWheelColour == nil then
        originalPrimaryColour, originalSecondaryColour = GetVehicleColours(plyVeh)
        originalPearlescentColour, originalWheelColour = GetVehicleExtraColours(plyVeh)
        originalDashColour = GetVehicleDashboardColour(plyVeh)
        originalInterColour = GetVehicleInteriorColour(plyVeh)
    end
    if paintType == 0 then --Primary Colour
        if paintCategory == 1 then --Metallic Paint
            SetVehicleColours(plyVeh, paintID, originalSecondaryColour)
            SetVehicleExtraColours(plyVeh, originalPearlescentColour, originalWheelColour)
        else
            SetVehicleColours(plyVeh, paintID, originalSecondaryColour)
        end
    elseif paintType == 1 then --Secondary Colour
        SetVehicleColours(plyVeh, originalPrimaryColour, paintID)
    elseif paintType == 2 then --Pearlescent Colour
        SetVehicleExtraColours(plyVeh, paintID, originalWheelColour)
    elseif paintType == 3 then --Wheel Colour
        SetVehicleExtraColours(plyVeh, originalPearlescentColour, paintID)
    elseif paintType == 4 then --Dash Colour
        SetVehicleDashboardColour(plyVeh, paintID)
    elseif paintType == 5 then --Interior Colour
        SetVehicleInteriorColour(plyVeh, paintID)
    end
end

function PreviewWheel(categoryID, wheelID, wheelType)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local doesHaveCustomWheels = GetVehicleModVariation(plyVeh, 23)

    if originalWheelCategory == nil and originalWheel == nil and originalWheelType == nil and originalCustomWheels == nil then
        originalWheelCategory = categoryID
        originalWheelType = GetVehicleWheelType(plyVeh)
        originalWheel = GetVehicleMod(plyVeh, 23)
        originalCustomWheels = GetVehicleModVariation(plyVeh, 23)
    end

    SetVehicleWheelType(plyVeh, wheelType)
    SetVehicleMod(plyVeh, categoryID, wheelID, doesHaveCustomWheels)

    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        SetVehicleMod(plyVeh, 24, wheelID, doesHaveCustomWheels)
    end
end

function PreviewNeon(side, enabled)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalNeonLightState == nil and originalNeonLightSide == nil then
        if IsVehicleNeonLightEnabled(plyVeh, side) then
            originalNeonLightState = 1
        else
            originalNeonLightState = 0
        end

        originalNeonLightSide = side
    end

    SetVehicleNeonLightEnabled(plyVeh, side, enabled)
end

function PreviewNeonColour(r, g, b)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalNeonColourR == nil and originalNeonColourG == nil and originalNeonColourB == nil then
        originalNeonColourR, originalNeonColourG, originalNeonColourB = GetVehicleNeonLightsColour(plyVeh)
    end

    SetVehicleNeonLightsColour(plyVeh, r, g, b)
end

function PreviewXenonColour(colour)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if originalXenonColour == nil then
        originalXenonColour = GetVehicleHeadlightsColour(plyVeh)
    end

    SetVehicleLights(plyVeh, 2)
    SetVehicleHeadlightsColour(plyVeh, colour)
end

function PreviewOldLivery(liv)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    if originalOldLivery == nil then
        originalOldLivery = GetVehicleLivery(plyVeh)
    end

    SetVehicleLivery(plyVeh, tonumber(liv))
end

function PreviewPlateIndex(index)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    if originalPlateIndex == nil then
        originalPlateIndex = GetVehicleNumberPlateTextIndex(plyVeh)
    end

    SetVehicleNumberPlateTextIndex(plyVeh, tonumber(index))
end

function ApplyMod(categoryID, modID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if categoryID == 18 then
        ToggleVehicleMod(plyVeh, categoryID, modID)
    elseif categoryID == 11 or categoryID == 12 or categoryID== 13 or categoryID == 15 or categoryID == 16 then --Performance Upgrades
        originalCategory = categoryID
        originalMod = modID

        SetVehicleMod(plyVeh, categoryID, modID)
    else
        originalCategory = categoryID
        originalMod = modID

        SetVehicleMod(plyVeh, categoryID, modID)
    end
end

function ApplyExtra(extraID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isEnabled = IsVehicleExtraTurnedOn(plyVeh, extraID)
    if isEnabled == 1 then
        SetVehicleExtra(plyVeh, tonumber(extraID), 1)
        SetVehiclePetrolTankHealth(plyVeh,4000.0)
    else
        SetVehicleExtra(plyVeh, tonumber(extraID), 0)
        SetVehiclePetrolTankHealth(plyVeh,4000.0)
    end
end

function ApplyWindowTint(windowTintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalWindowTint = windowTintID

    SetVehicleWindowTint(plyVeh, windowTintID)
end

function ApplyColour(paintType, paintCategory, paintID)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local vehPrimaryColour, vehSecondaryColour = GetVehicleColours(plyVeh)
    local vehPearlescentColour, vehWheelColour = GetVehicleExtraColours(plyVeh)

    if paintType == 0 then --Primary Colour
        if paintCategory == 1 then --Metallic Paint
            SetVehicleColours(plyVeh, paintID, vehSecondaryColour)
            -- SetVehicleExtraColours(plyVeh, paintID, vehWheelColour)
            SetVehicleExtraColours(plyVeh, originalPearlescentColour, vehWheelColour)
            originalPrimaryColour = paintID
            -- originalPearlescentColour = paintID
        else
            SetVehicleColours(plyVeh, paintID, vehSecondaryColour)
            originalPrimaryColour = paintID
        end
    elseif paintType == 1 then --Secondary Colour
        SetVehicleColours(plyVeh, vehPrimaryColour, paintID)
        originalSecondaryColour = paintID
    elseif paintType == 2 then --Pearlescent Colour
        SetVehicleExtraColours(plyVeh, paintID, vehWheelColour)
        originalPearlescentColour = paintID
    elseif paintType == 3 then --Wheel Colour
        SetVehicleExtraColours(plyVeh, vehPearlescentColour, paintID)
        originalWheelColour = paintID
    elseif paintType == 4 then --Dash Colour
        SetVehicleDashboardColour(plyVeh, paintID)
        originalDashColour = paintID
    elseif paintType == 5 then --Interior Colour
        SetVehicleInteriorColour(plyVeh, paintID)
        originalInterColour = paintID
    end
end

function ApplyWheel(categoryID, wheelID, wheelType)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local doesHaveCustomWheels = GetVehicleModVariation(plyVeh, 23)

    originalWheelCategory = categoryID
    originalWheel = wheelID
    originalWheelType = wheelType

    SetVehicleWheelType(plyVeh, wheelType)
    SetVehicleMod(plyVeh, categoryID, wheelID, doesHaveCustomWheels)
    
    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        SetVehicleMod(plyVeh, 24, wheelID, doesHaveCustomWheels)
    end
end

function ApplyCustomWheel(state)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    SetVehicleMod(plyVeh, 23, GetVehicleMod(plyVeh, 23), state)
    
    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        SetVehicleMod(plyVeh, 24, GetVehicleMod(plyVeh, 24), state)
    end
end

function ApplyNeon(side, enabled)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalNeonLightState = enabled
    originalNeonLightSide = side

    SetVehicleNeonLightEnabled(plyVeh, side, enabled)
end

function ApplyNeonColour(r, g, b)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalNeonColourR = r
    originalNeonColourG = g
    originalNeonColourB = b

    SetVehicleNeonLightsColour(plyVeh, r, g, b)
end

function ApplyXenonLights(category, state)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    ToggleVehicleMod(plyVeh, category, state)
end

function ApplyXenonColour(colour)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalXenonColour = colour

    SetVehicleHeadlightsColour(plyVeh, colour)
end

function ApplyOldLivery(liv)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    originalOldLivery = liv

    SetVehicleLivery(plyVeh, liv)
end

function ApplyPlateIndex(index)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    originalPlateIndex = index
    SetVehicleNumberPlateTextIndex(plyVeh, index)
end

function ApplyTyreSmoke(r, g, b)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    ToggleVehicleMod(plyVeh, 20, true)
    SetVehicleTyreSmokeColor(plyVeh, r, g, b)
end

function ExitBennys()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    saveVehicle()

    DisplayMenuContainer(false)

    FreezeEntityPosition(plyVeh, false)
    SetEntityCollision(plyVeh, true, true)

    SetTimeout(100, function()
        DestroyMenus()
    end)

    isPlyInBennys = false
end



-- Bennys

RegisterNetEvent('event:control:mechanic')
AddEventHandler('event:control:mechanic', function(useID)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        bennyHeading = 319.73135375977
        if useID == 1 and not isPlyInBennys then -- Bennys
            enterLocation(bennyLocation)
        end
    end
end)

-- TunerShop

RegisterNetEvent('event:control:mechanic2')
AddEventHandler('event:control:mechanic2', function(useID)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        bennyHeading2 = 115.55762146
        if useID == 1 and not isPlyInBennys then -- Bennys
            enterLocation2(bennyLocation2, bennyHeading2)
        end
    end
end)

-- CamelTowing
RegisterNetEvent('event:control:mechanic3')
AddEventHandler('event:control:mechanic3', function(useID)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        bennyHeading = 292.66375732422
        if useID == 1 and not isPlyInBennys then -- Bennys
            enterLocation(bennyLocation3)
        end
    end
end)

-- Quick fix
RegisterNetEvent('event:control:mechanic4')
AddEventHandler('event:control:mechanic4', function(useID)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local bennyHeading4 = 180
        if useID == 1 and not isPlyInBennys then -- Bennys
            enterLocation(bennyLocation4, bennyHeading4)
        end
    end
end)

-- Bennys
function enterLocation(locationsPos, bennyHeading)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isMotorcycle = false

    SetVehicleModKit(plyVeh, 0)
    SetEntityCoords(plyVeh, locationsPos.x,locationsPos.y, locationsPos.z)
    SetEntityHeading(plyVeh, bennyHeading)
    FreezeEntityPosition(plyVeh, true)
    SetEntityCollision(plyVeh, false, true)

    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        isMotorcycle = true
    else
        isMotorcycle = false
    end

    InitiateMenus(isMotorcycle, GetVehicleBodyHealth(plyVeh))

    SetTimeout(100, function()
        if GetVehicleBodyHealth(plyVeh) < 1000.0 then
            DisplayMenu(true, "repairMenu")
        else
            DisplayMenu(true, "mainMenu")
        end
        
        DisplayMenuContainer(true)
        PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end)

    isPlyInBennys = true
end
-- TunerShop
function enterLocation2(locationsPos)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isMotorcycle = false

    SetVehicleModKit(plyVeh, 0)
    SetEntityCoords(plyVeh, locationsPos)
    SetEntityHeading(plyVeh, 229.7)
    FreezeEntityPosition(plyVeh, true)
    SetEntityCollision(plyVeh, false, true)

    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        isMotorcycle = true
    else
        isMotorcycle = false
    end

    InitiateMenus(isMotorcycle, GetVehicleBodyHealth(plyVeh))

    SetTimeout(100, function()
        if GetVehicleBodyHealth(plyVeh) < 1000.0 then
            DisplayMenu(true, "repairMenu")
        else
            DisplayMenu(true, "mainMenu")
        end
        
        DisplayMenuContainer(true)
        PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end)

    isPlyInBennys = true
end
-- CamelTowing
function enterLocation3(locationsPos)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isMotorcycle = false

    SetVehicleModKit(plyVeh, 0)
    SetEntityCoords(plyVeh, locationsPos)
    SetEntityHeading(plyVeh, bennyHeading2)
    FreezeEntityPosition(plyVeh, true)
    SetEntityCollision(plyVeh, false, true)

    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        isMotorcycle = true
    else
        isMotorcycle = false
    end

    InitiateMenus(isMotorcycle, GetVehicleBodyHealth(plyVeh))

    SetTimeout(100, function()
        if GetVehicleBodyHealth(plyVeh) < 1000.0 then
            DisplayMenu(true, "repairMenu")
        else
            DisplayMenu(true, "mainMenu")
        end
        
        DisplayMenuContainer(true)
        PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end)

    isPlyInBennys = true
end
-- Quick fix
function enterLocation4(locationsPos)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)
    local isMotorcycle = false

    SetVehicleModKit(plyVeh, 0)
    SetEntityCoords(plyVeh, locationsPos)
    SetEntityHeading(plyVeh, bennyHeading2)
    FreezeEntityPosition(plyVeh, true)
    SetEntityCollision(plyVeh, false, true)

    if GetVehicleClass(plyVeh) == 8 then --Motorcycle
        isMotorcycle = true
    else
        isMotorcycle = false
    end

    InitiateMenus(isMotorcycle, GetVehicleBodyHealth(plyVeh))

    SetTimeout(100, function()
        if GetVehicleBodyHealth(plyVeh) < 1000.0 then
            DisplayMenu(true, "repairMenu")
        else
            DisplayMenu(true, "mainMenu")
        end
        
        DisplayMenuContainer(true)
        PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end)

    isPlyInBennys = true
end

function disableControls()
    DisableControlAction(1, 38, true) --Key: E
    DisableControlAction(1, 172, true) --Key: Up Arrow
    DisableControlAction(1, 173, true) --Key: Down Arrow
    DisableControlAction(1, 177, true) --Key: Backspace
    DisableControlAction(1, 176, true) --Key: Enter
    DisableControlAction(1, 71, true) --Key: W (veh_accelerate)
    DisableControlAction(1, 72, true) --Key: S (veh_brake)
    DisableControlAction(1, 34, true) --Key: A
    DisableControlAction(1, 35, true) --Key: D
    DisableControlAction(1, 75, true) --Key: F (veh_exit)

    if IsDisabledControlJustReleased(1, 172) then --Key: Arrow Up
        MenuScrollFunctionality("up")
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end

    if IsDisabledControlJustReleased(1, 173) then --Key: Arrow Down
        MenuScrollFunctionality("down")
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end

    if IsDisabledControlJustReleased(1, 176) then --Key: Enter
        MenuManager(true)
        PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end

    if IsDisabledControlJustReleased(1, 177) then --Key: Backspace
        MenuManager(false)
        PlaySoundFrontend(-1, "NO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
end
-- TunerShop

-- #MarkedForMarker
--#[Citizen Threads]#-- Bennys
Citizen.CreateThread(function()
    while true do 
        local plyPed = PlayerPedId()

        if IsPedInAnyVehicle(plyPed, false) then
            local plyPos = GetEntityCoords(plyPed)


            nearDefault = isNear(plyPos, bennyLocation, 10) 

            if nearDefault then

                if not isPlyInBennys and nearDefault then
                    if exports['isPed']:isPed('job') == 'SkyHighEnterprise' then
                        DrawMarker(21, bennyLocation.x, bennyLocation.y, bennyLocation.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 0, 211, 255, true, false, 2, true, nil, nil, false)
                    end
                end



                if nearDefault then
                    if not isPlyInBennys then
                        if exports['isPed']:isPed('job') == 'SkyHighEnterprise' then
                            Draw3DText(bennyLocation.x, bennyLocation.y, bennyLocation.z + 0.5, "[Press ~p~E~w~ - Enter Benny's Motorworks]", 255, 255, 255, 255, 4, 0.45, true, true, true, true, 0, 0, 0, 0, 55)
                            if IsControlJustReleased(1, 38) then
                                TriggerEvent('event:control:mechanic', 1)
                            end
                        end
                        if exports['isPed']:isPed('job') == 'CamelTowing' then
                            Draw3DText(bennyLocation.x, bennyLocation.y, bennyLocation.z + 0.5, "[Press ~p~E~w~ - Enter Benny's Motorworks]", 255, 255, 255, 255, 4, 0.45, true, true, true, true, 0, 0, 0, 0, 55)
                            if IsControlJustReleased(1, 38) then
                                TriggerEvent('event:control:mechanic', 1)
                            end
                        end
                    else
                        disableControls()
                    end
                end

            else
                Wait(1000)
            end
        else
            Wait(2000)
        end

        Citizen.Wait(1)
    end
end)
-- CamelTowing
Citizen.CreateThread(function()
    while true do 
        local plyPed = PlayerPedId()

        if IsPedInAnyVehicle(plyPed, false) then
            local plyPos = GetEntityCoords(plyPed)


            nearDefault = isNear(plyPos, bennyLocation3, 10) 

            if nearDefault then

                if not isPlyInBennys and nearDefault then
                    if exports['isPed']:isPed('job') == 'CamelTowing' then
                        DrawMarker(21, bennyLocation3.x, bennyLocation3.y, bennyLocation3.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 0, 211, 255, true, false, 2, true, nil, nil, false)
                    end
                end



                if nearDefault then
                    if not isPlyInBennys then
                        if exports['isPed']:isPed('job') == 'CamelTowing' then
                            Draw3DText(bennyLocation3.x, bennyLocation3.y, bennyLocation3.z + 0.5, "[Press ~p~E~w~ - Enter CamelTowing Motorworks]", 255, 255, 255, 255, 4, 0.45, true, true, true, true, 0, 0, 0, 0, 55)
                            if IsControlJustReleased(1, 38) then
                                if exports['isPed']:isPed('job') == 'CamelTowing' then
                                    TriggerEvent('event:control:mechanic3', 1)
                                end
                            end      
                        end                  
                    else
                        disableControls()
                    end
                end

            else
                Wait(1000)
            end
        else
            Wait(2000)
        end

        Citizen.Wait(1)
    end
end)
-- Quick fix
Citizen.CreateThread(function()
    while true do 
        local plyPed = PlayerPedId()

        if IsPedInAnyVehicle(plyPed, false) then
            local plyPos = GetEntityCoords(plyPed)


            nearDefault = isNear(plyPos, bennyLocation4, 10) 

            if nearDefault then

                if not isPlyInBennys and nearDefault then
                    if exports['isPed']:isPed('job') == 'SkyHighEnterprise' then
                        DrawMarker(21, bennyLocation4.x, bennyLocation4.y, bennyLocation4.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 0, 211, 255, true, false, 2, true, nil, nil, false)
                    end
                    if exports['isPed']:isPed('job') == 'SkyHighEnterprise' then
                        DrawMarker(21, bennyLocation4.x, bennyLocation4.y, bennyLocation4.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 0, 211, 255, true, false, 2, true, nil, nil, false)
                    end
                end



                if nearDefault then
                    if not isPlyInBennys then
                        if exports['isPed']:isPed('job') == 'SkyHighEnterprise' then
                            Draw3DText(bennyLocation4.x, bennyLocation4.y, bennyLocation4.z + 0.5, "[Press ~p~E~w~ - Enter SkyHighEnterprise Motorworks]", 255, 255, 255, 255, 4, 0.45, true, true, true, true, 0, 0, 0, 0, 55)
                            if IsControlJustReleased(1, 38) then
                                TriggerEvent('event:control:mechanic4', 1)
                            end
                        end
                    else
                        disableControls()
                    end
                end

            else
                Wait(1000)
            end
        else
            Wait(2000)
        end

        Citizen.Wait(1)
    end
end)

--TunerShop--
Citizen.CreateThread(function()
    while true do 
        local plyPed = PlayerPedId()

        if IsPedInAnyVehicle(plyPed, false) then
            local plyPos = GetEntityCoords(plyPed)


            nearDefault = isNear(plyPos, bennyLocation2, 10) 

            if nearDefault then

                if not isPlyInBennys and nearDefault then
                    local job = exports['isPed']:isPed('job')
                    if job == 'tuner_carshop' or job == 'tuner_shop' then
                        DrawMarker(21, bennyLocation2.x, bennyLocation2.y, bennyLocation2.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 148, 0, 211, 255, true, false, 2, true, nil, nil, false)
                    end
                end



                if nearDefault then
                    if not isPlyInBennys then
                        local job = exports['isPed']:isPed('job')
                        if job == 'tuner_carshop' or job == 'tuner_shop' then
                            Draw3DText(bennyLocation2.x, bennyLocation2.y, bennyLocation2.z + 0.5, "[Press ~p~E~w~ - Enter TunerShop Motorworks]", 255, 255, 255, 255, 4, 0.45, true, true, true, true, 0, 0, 0, 0, 55)
                            if IsControlJustReleased(1, 38) then
                                local job = exports['isPed']:isPed('job')
                                if job == 'tuner_carshop' or job == 'tuner_shop' then
                                    TriggerEvent('event:control:mechanic2', 1)
                                end
                            end      
                        end                  
                    else
                        disableControls()
                    end
                end

            else
                Wait(1000)
            end
        else
            Wait(2000)
        end

        Citizen.Wait(1)
    end
end)

--#[Event Handlers]#--
RegisterNetEvent("wrp-mechanic:purchaseSuccessful")
AddEventHandler("wrp-mechanic:purchaseSuccessful", function(cash)
    local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    LocalPlayer:removeCash(Player.id, cash)
    isPurchaseSuccessful = true
    attemptingPurchase = false
    TriggerEvent('DoLongHudText', 'Purchase Successful')
end)

RegisterNetEvent("wrp-mechanic:purchaseFailed")
AddEventHandler("wrp-mechanic:purchaseFailed", function()
    isPurchaseSuccessful = false
    attemptingPurchase = false
    TriggerEvent('DoLongHudText', 'Not enough cash', 2)
end)