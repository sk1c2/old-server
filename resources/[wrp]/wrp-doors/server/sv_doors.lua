local steamIds = {
    ["steam:11000010aa15521"] = true --kevin
}



RegisterServerEvent('wrp-doors:alterlockstate2')
AddEventHandler('wrp-doors:alterlockstate2', function()
    --URP.DoorCoords[10]["lock"] = 0

    TriggerClientEvent('wrp-doors:alterlockstateclient', source, URP.DoorCoords)

end)

RegisterServerEvent('wrp-doors:alterlockstate')
AddEventHandler('wrp-doors:alterlockstate', function(alterNum)
    print('lockstate:', alterNum)
    URP.alterState(alterNum)
end)

RegisterServerEvent('wrp-doors:ForceLockState')
AddEventHandler('wrp-doors:ForceLockState', function(alterNum, state)
    URP.DoorCoords[alterNum]["lock"] = state
    TriggerClientEvent('URP:Door:alterState', -1,alterNum,state)
end)

function isDoorLocked(door)
    if URP.DoorCoords[door].lock == 1 then
        return true
    else
        return false
    end
end