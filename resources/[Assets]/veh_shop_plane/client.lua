job = nil

local repairPoints = {
    vector3(-1111.92, -2883.375, 13.94604)
}

local testDrivePoints = {
    vector4(-981.0195, -2995.474, 13.94506, 60.84436)
}

local attemptingPurchase = false
local isPurchaseSuccessful = false
local testDriveMenuOpen = false
local myspawnedvehs = {}
local rank = nil
local insideDriftSchool = true

function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))


    local fov = (1/GetGameplayCamFov())*100

    if onScreen then
        SetTextScale(0.2,0.2)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function distCheck(points)
    local origin = GetEntityCoords(GetPlayerPed(PlayerId()), false)
    local dist = {1000, vector3(0.0,0.0,0.0)}
    for i=1, #points do
        local point = points[i]
        local tempDist = Vdist(point.x, point.y, point.z, origin.x, origin.y, origin.z)
        if tempDist < dist[1] then
            dist = {tempDist, point}
        end
    end
    return dist
end

function repairCost(veh, health)
    if health < 1000.0 then
        local price = math.ceil(1000 - health)
        if rank == 'SkyHighEnterprise' then
            return price * 0.5
        else
            return price
        end
    end
    return 0
end

function repairVehicle(veh)
    SetVehicleFixed(veh)
    SetVehicleDirtLevel(veh, 0.0)
    SetVehiclePetrolTankHealth(veh, 4000.0)
end

local function starts_with(str, start)
    return str:sub(1, #start) == start
 end

function checkPlate(plate)
    return starts_with(plate, "DRIFT")
end

function openGui(enable)
    testDriveMenuOpen = enable
    SetNuiFocus(enable, enable)
    SendNUIMessage({
        type = "enabletestdrive",
        enable = enable,
    })
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
end

RegisterNetEvent('prp-hawntedplaneshit-TAKEMONEY')
AddEventHandler('prp-hawntedplaneshit-TAKEMONEY',function()
    local player = PlayerPedId()
    local veh = GetVehiclePedIsIn(player, false)
    local health = GetVehicleBodyHealth(veh)
    local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    LocalPlayer:removeCash(Player.id, repairCost(veh, health))
    isPurchaseSuccessful = true
    attemptingPurchase = false
end)
   
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if insideDriftSchool then

            local repairDist = distCheck(repairPoints)
            local testDriveDist = distCheck(testDrivePoints)
            local player = PlayerPedId()
            local veh = GetVehiclePedIsIn(player, false)
            local health = GetVehicleBodyHealth(veh)
            if repairDist[1] < 5 and health < 1000.0 and veh ~= 0 and exports['isPed']:isPed('job') == 'SkyHighEnterprise' then
                DrawText3D(repairDist[2].x, repairDist[2].y, repairDist[2].z, "[E] Repair Vehicle $"..repairCost(veh, health))
                DrawMarker(27, repairDist[2].x, repairDist[2].y, repairDist[2].z - 1.0, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 1.0001, 0, 55, 240, 20, 0, 0, 0, 0)
                if IsControlJustPressed(1, 38) then
                    TriggerEvent("prp-hawntedplaneshit-TAKEMONEY")
                    attemptingPurchase = true
                    while attemptingPurchase do
                        Citizen.Wait(1)
                    end
                    if not isPurchaseSuccessful then
                        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                    else
                        local running = true
                        Citizen.CreateThread(function()
                            while running do
                                Citizen.Wait(1)
                                disableControls()
                            end
                        end)
                        local finished = exports["prp-taskbarskill"]:taskBar(4000,math.random(5,9))
                        if finished ~= 100 then
                            running = false
                        end
                        if finished == 100 then
                            local finished2 = exports["prp-taskbarskill"]:taskBar(2000,math.random(4,8))
                            if finished2 ~= 100 then
                                running = false
                            end
                            if finished2 == 100 then

                                running = false
                                repairVehicle(veh)
                            end
                        end
                    end
                end
            elseif #(vector3(-981.0195, -2995.474, 13.94506) - GetEntityCoords(PlayerPedId())) < 2.5000000 and exports['isPed']:isPed('job') == 'SkyHighEnterprise' then
                -- testdrive menu
                local point = testDriveDist[2]
                if IsPedInAnyVehicle(player, true) then
                    DrawText3D(point.x, point.y, point.z, "[E] Put away Test Drive")
                else
                    DrawText3D(point.x, point.y, point.z, "[E] Open Test Drives")
                end
                DrawMarker(27, point.x, point.y, point.z - 1.0, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 1.0001, 0, 55, 240, 20, 0, 0, 0, 0)

                if IsControlJustPressed(1, 38) and not testDriveMenuOpen then
                    if IsPedInAnyVehicle(player, true) then
                    DeleteVehicle(veh)
                    else
                    -- open menu
                    openGui(true)
                    end
                end


            elseif repairDist[1] > 10 and testDriveDist[1] > 10 then
                Citizen.Wait(math.ceil(math.min(repairDist[1], testDriveDist[1]) * 10))
            end
        end
    end
end)

local scenarios = {
    "WORLD_VEHICLE_DRIVE_SOLO",
    "WORLD_GULL_STANDING",
    "WORLD_HUMAN_CLIPBOARD",
    "WORLD_HUMAN_SEAT_LEDGE",
    "WORLD_HUMAN_SEAT_LEDGE_EATING",
    "WORLD_HUMAN_STAND_MOBILE",
    "WORLD_HUMAN_HANG_OUT_STREET",
    "WORLD_HUMAN_SMOKING",
    "WORLD_HUMAN_DRINKING",
    "WORLD_GULL_FEEDING",
    "WORLD_HUMAN_GUARD_STAND",
    "WORLD_HUMAN_SEAT_STEPS",
    "WORLD_HUMAN_STAND_IMPATIENT",
    "WORLD_HUMAN_SEAT_WALL_EATING",
    "WORLD_HUMAN_WELDING",
}
function setScenarioState(pToggle)
    for i = 1, #scenarios do
        SetScenarioTypeEnabled(scenarios[i], pToggle)
    end
end

RegisterNetEvent('prp-hawntedplaneshit:tookmoney')
AddEventHandler('prp-hawntedplaneshit:tookmoney', function(taken)
    isPurchaseSuccessful = taken
    attemptingPurchase = false
end)

RegisterNUICallback('spawntestdrive', function(data, cb)
    openGui(false)

    local model = GetHashKey(data.model)
    Citizen.CreateThread(function()
        Citizen.Wait(10)
        local veh = GetClosestVehicle(-981.0195, -2995.474, 13.000, 0, 70)
        if not DoesEntityExist(veh) then
            if IsModelInCdimage(model) and IsModelValid(model) then
                RequestModel(model)
                while (not HasModelLoaded(model)) do
                    Citizen.Wait(0)
                end
            else
                TriggerEvent("DoLongHudText","Error spawning car.",2)
                return
            end

            veh = CreateVehicle(model, -981.0195, -2995.474, 13.000, 0, 70, 54.33323, true,false)
            local vehplate = "TEST1"..math.random(100,999)
            SetVehicleNumberPlateText(veh, vehplate)
            Citizen.Wait(100)
            TriggerServerEvent("garage:addKeys", vehplate)
            SetModelAsNoLongerNeeded(model)
            SetVehicleOnGroundProperly(veh)
            SetEntityAsMissionEntity(veh,false,true)
            TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
            myspawnedvehs[veh] = true

            SetVehicleModKit(veh, 0)
            SetVehicleMod(veh, 11, 2, false)
            SetVehicleMod(veh, 12, 2, false)
            SetVehicleMod(veh, 13, 2, false)
            SetVehicleMod(veh, 15, 2, false)
            ToggleVehicleMod(veh, 18, true)
        else
            TriggerEvent("DoLongHudText","A car is on the spawn point.",2)
        end
    end)
    cb('ok')
end)

RegisterNUICallback('closemenu', function(data, cb)
    openGui(false)
    cb('ok')
end)

function DrawText3D(x,y,z, text)
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