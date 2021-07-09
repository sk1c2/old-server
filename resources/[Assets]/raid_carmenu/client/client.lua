local enabled = false
local player = false
local veh = 0

damageLevel, currPlate, currName, currFuel, currEngineStatus = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if veh ~= 0 then
            if enabled then
                refreshUI()
            else
                Wait(100)
            end
        else
            Wait(250)
        end
    end
end)

RegisterCommand('engine', function()
    local engine = not GetIsVehicleEngineRunning(veh)
    if engine == true then
        TriggerEvent('toggleit')
        TriggerEvent('DoLongHudText', 'Engine on.')
    else
        TriggerEvent('toggleit')
        Citizen.Wait(10)
        TriggerEvent('DoLongHudText', 'Engine off.', 2)
    end
end)

Citizen.CreateThread(function()
    while true do
        player = PlayerPedId()
        veh = GetVehiclePedIsIn(player, false)
        if veh ~= 0 then
            if enabled then
                damageLevel = GetVehicleEngineHealth(veh)
                currPlate = GetVehicleNumberPlateText(veh)
                currName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                currFuel = GetVehicleFuelLevel(veh)
                currEngineStatus = GetIsVehicleEngineRunning(veh)
            end
        end
        Wait(1000)
    end
end)

function EnableGUI(enable)
    enabled = enable
    SetNuiFocus(enable, enable)
    SendNUIMessage({
        type = "enablecarmenu",
        enable = enable
    })
end

function checkSeat(player, veh, seatIndex)
    local ped = GetPedInVehicleSeat(veh, seatIndex);
    if ped == player then
        return seatIndex;
    elseif ped ~= 0 then
        return false;
    else
        return true;
    end
end

function refreshUI()
    local settings = {}
    if veh ~= 0 and damageLevel ~= nil then
        settings.seat1 = checkSeat(player, veh, -1)
        settings.seat2 = checkSeat(player, veh,  0)
        settings.seat3 = checkSeat(player, veh,  1)
        settings.seat4 = checkSeat(player, veh,  2)
        settings.engineAccess = settings.seat1 == -1 and true or false
        if GetVehicleDoorAngleRatio(veh, 0) ~= 0 then settings.door0 = true end
        if GetVehicleDoorAngleRatio(veh, 1) ~= 0 then settings.door1 = true end
        if GetVehicleDoorAngleRatio(veh, 2) ~= 0 then settings.door2 = true end
        if GetVehicleDoorAngleRatio(veh, 3) ~= 0 then settings.door3 = true end
        if GetVehicleDoorAngleRatio(veh, 4) ~= 0 then settings.hood = true end
        if GetVehicleDoorAngleRatio(veh, 5) ~= 0 then settings.trunk = true end

        if not IsVehicleWindowIntact(veh, 0) then settings.windowr1 = true end
        if not IsVehicleWindowIntact(veh, 1) then settings.windowl1 = true end
        if not IsVehicleWindowIntact(veh, 2) then settings.windowr2 = true end
        if not IsVehicleWindowIntact(veh, 3) then settings.windowl2 = true end

        if currEngineStatus then settings.engine = true else settings.engine = false end
        settings.plate, settings.name, settings.fuel = currPlate, currName, currFuel
        local overallDamage = damageLevel / 10
        if overallDamage < 100 then settings.damage = overallDamage - 15 else settings.damage = 100 end

        SendNUIMessage({ type = "refreshcarmenu", settings = settings })
    else SendNUIMessage({ type = "resetcarmenu" }) end
end

RegisterNUICallback('openDoor', function(data, cb)
    doorIndex = tonumber(data['doorIndex'])
    player = PlayerPedId()
    veh = GetVehiclePedIsIn(player, false)

    if veh ~= 0 then
        local lockStatus = GetVehicleDoorLockStatus(veh)
        if lockStatus == 1 or lockStatus == 0 then
            if (GetVehicleDoorAngleRatio(veh, doorIndex) == 0) then
                SetVehicleDoorOpen(veh, doorIndex, false, false)
            else
                SetVehicleDoorShut(veh, doorIndex, false)
            end
        end
    end
    cb('ok')
end)

RegisterNUICallback('switchSeat', function(data, cb)
    seatIndex = tonumber(data['seatIndex'])
    player = PlayerPedId()
    veh = GetVehiclePedIsIn(player, false)
    if veh ~= 0 then
        SetPedIntoVehicle(player, veh, seatIndex)
    end
    cb('ok')
end)


RegisterCommand('seat', function(src, args)
    local id = tonumber(args[1])
    player = PlayerPedId()
    veh = GetVehiclePedIsIn(player, false)
    if veh ~= 0 then
        SetPedIntoVehicle(player, veh, id)
    end
end)

RegisterCommand('door', function(src, args)
    local id = tonumber(args[1])
    player = PlayerPedId()
    veh = GetVehiclePedIsIn(player, false)

    if veh ~= 0 then
        local lockStatus = GetVehicleDoorLockStatus(veh)
        if lockStatus == 1 or lockStatus == 0 then
            if (GetVehicleDoorAngleRatio(veh, id) == 0) then
                SetVehicleDoorOpen(veh, id, false, false)
            else
                SetVehicleDoorShut(veh, id, false)
            end
        end
    end
end)

RegisterCommand('window', function(src, args)
    local id = tonumber(args[1])
    player = PlayerPedId()
    veh = GetVehiclePedIsIn(player, false)
    if veh ~= 0 then
        if not IsVehicleWindowIntact(veh, id) then
            RollUpWindow(veh, id)
            if not IsVehicleWindowIntact(veh, id) then
                RollDownWindow(veh, id)
            end
        else
            RollDownWindow(veh, id)
        end
    end
end)

RegisterNUICallback('togglewindow', function(data, cb)
    windowIndex = tonumber(data['windowIndex'])
    player = PlayerPedId()
    veh = GetVehiclePedIsIn(player, false)
    if veh ~= 0 then
        if not IsVehicleWindowIntact(veh, windowIndex) then
            RollUpWindow(veh, windowIndex)
            if not IsVehicleWindowIntact(veh, windowIndex) then
                RollDownWindow(veh, windowIndex)
            end
        else
            RollDownWindow(veh, windowIndex)
        end
    end
    cb('ok')
end)

RegisterNUICallback('togglealldoor', function(data, cb)
    player = PlayerPedId()
    veh = GetVehiclePedIsIn(player, false)
    if veh ~= 0 then
        SetVehicleDoorShut(veh, 0, false)
        SetVehicleDoorShut(veh, 1, false)
        SetVehicleDoorShut(veh, 2, false)
        SetVehicleDoorShut(veh, 3, false)
        SetVehicleDoorShut(veh, 4, false)
        SetVehicleDoorShut(veh, 5, false)
        SetVehicleDoorShut(veh, 6, false)
    end
    cb('ok')
end)

RegisterNUICallback('lockdoors', function(data, cb)
    player = PlayerPedId()
    veh = GetVehiclePedIsIn(player, false)
    if veh ~= 0 then
        TriggerEvent('lockdoors')
    end
    cb('ok')
end)

RegisterNUICallback('givekeys', function(data, cb)
    player = PlayerPedId()
    veh = GetVehiclePedIsIn(player, false)
    if veh ~= 0 then
        TriggerEvent('garage:addKeys')
    end
    cb('ok')
end)

RegisterNUICallback('convertroof', function(data, cb)
    player = PlayerPedId()
    veh = GetVehiclePedIsIn(player, false)
    if veh ~= 0 then
        local roofState = GetConvertibleRoofState(veh)
        if roofState == 0 then
            LowerConvertibleRoof(veh)
        elseif roofState == 2 then
            RaiseConvertibleRoof(veh)
        end
    end
    cb('ok')
end)

RegisterNUICallback('toggleengine', function(data, cb)
    player = GetPlayerPed(-1)
    veh = GetVehiclePedIsIn(player, false)
    if veh ~= 0 then
        local engine = not GetIsVehicleEngineRunning(veh)

        if not IsPedInAnyHeli(player) then
            SetVehicleEngineOn(veh, engine, false, true)
            SetVehicleJetEngineOn(veh, engine)
        else
            if engine then
                SetVehicleFuelLevel(veh, vehicle_fuel)
            else
                SetVehicleFuelLevel(veh, 0)
            end
        end
    end
    cb('ok')
end)

RegisterNUICallback('toggleunderglow', function(data, cb)
    player = GetPlayerPed(-1)
    veh = GetVehiclePedIsIn(player, false)
    if veh ~= 0 then
        if IsVehicleNeonLightEnabled(veh, 0) or IsVehicleNeonLightEnabled(veh, 1) or IsVehicleNeonLightEnabled(veh, 2) or IsVehicleNeonLightEnabled(veh, 3) then
            SetVehicleNeonLightEnabled(veh, 0, false)
            SetVehicleNeonLightEnabled(veh, 1, false)
            SetVehicleNeonLightEnabled(veh, 2, false)
            SetVehicleNeonLightEnabled(veh, 3, false)
        else
            SetVehicleNeonLightEnabled(veh, 0, true)
            SetVehicleNeonLightEnabled(veh, 1, true)
            SetVehicleNeonLightEnabled(veh, 2, true)
            SetVehicleNeonLightEnabled(veh, 3, true)
            SetVehicleNeonLightEnabled(veh, 4, true)
        end
    end
    cb('ok')
end)

RegisterNUICallback('escape', function(data, cb) EnableGUI(false) cb('ok') end)

RegisterNetEvent('toggleit')
AddEventHandler('toggleit', function()
    player = GetPlayerPed(-1)
    veh = GetVehiclePedIsIn(player, false)
    if veh ~= 0 then
        local engine = not GetIsVehicleEngineRunning(veh)

        if not IsPedInAnyHeli(player) then
            SetVehicleEngineOn(veh, engine, false, true)
            SetVehicleJetEngineOn(veh, engine)
        else
            if engine then
                SetVehicleFuelLevel(veh, vehicle_fuel)
            else
                SetVehicleFuelLevel(veh, 0)
            end
        end
    end
end)

RegisterNetEvent('rapey')
AddEventHandler('rapey', function()
    Citizen.Wait(5)
    EnableGUI(true)
end)
