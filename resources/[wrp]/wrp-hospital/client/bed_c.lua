bedNames = { 'v_med_bed1', 'v_med_bed2'} -- Add more model strings here if you'd like
bedHashes = {}
animDict = 'missfbi5ig_0'
animName = 'lyinginpain_loop_steve'
isOnBed = false

CreateThread(function()
    for k,v in ipairs(bedNames) do
        table.insert( bedHashes, GetHashKey(v))
    end
end)

RegisterCommand('bed', function()
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        if isOnBed then
            ClearPedTasksImmediately(playerPed)
            isOnBed = false
            return
        end

        local playerPos = GetEntityCoords(playerPed, true)

        local bed = nil

        for k,v in ipairs(bedHashes) do
            bed = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, 4.0, v, false, false, false)
            if bed ~= 0 then
                break
            end
        end

        if bed ~= nil and DoesEntityExist(bed) then
            if not HasAnimDictLoaded(animDict) then
                RequestAnimDict(animDict)
            end
            local bedCoords = GetEntityCoords(bed)

            SetEntityCoords(playerPed, bedCoords.x , bedCoords.y, bedCoords.z, 1, 1, 0, 0)
            SetEntityHeading(playerPed, GetEntityHeading(bed) + 180.0)
            TaskPlayAnim(playerPed,animDict, animName, 8.0, 1.0, -1, 45, 1.0, 0, 0, 0)

            isOnBed = true
            TriggerEvent('DoLongHudText', '/e c To Get Out Of Bed')
        end
    end)
end, false)

-- RegisterCommand('end', function()
--     local playerPed = PlayerPedId()
--     local playerPos = GetEntityCoords(playerPed, true)
--     local bedHash = GetHashKey('v_med_bed1')
--     CreateObject(bedHash, playerPos.x, playerPos.y + 1.0, playerPos.z - 0.95, true, true, true)
-- end, false)