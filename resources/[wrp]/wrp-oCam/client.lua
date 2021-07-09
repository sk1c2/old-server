-- Test

Citizen.CreateThread( function()
    while true do
        playerPed = PlayerPedId() 
        if IsControlPressed(0, 25) and IsPedInAnyVehicle(PlayerPedId(), true) then
            print('true')
            if IsPedDoingDriveby(playerPed) then
                if GetFollowPedCamViewMode() == 0 or GetFollowVehicleCamViewMode() == 0 then
                    SetPlayerCanDoDriveBy(PlayerId(),false)
                    SetFollowPedCamViewMode(4)
                    SetFollowVehicleCamViewMode(4)
                    Wait(50)
                    SetPlayerCanDoDriveBy(PlayerId(),true)
                end
            else
                DisableControlAction(0,36,true)
                if GetPedStealthMovement(playerPed) == 1 then
                    SetPedStealthMovement(playerPed,0)
                end
            end
        else
            SetFollowVehicleCamViewMode(0)
        end
        Wait(1)
    end
end)