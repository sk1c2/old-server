RegisterNetEvent('chat:EmergencySend911r')
AddEventHandler('chat:EmergencySend911r', function(fal, caller, msg)
    if exports['isPed']:isPed('job') == 'Police' then
        TriggerEvent('chatMessagess', '911 RESPONSE: '.. caller, 1, 'Sent to: '.. fal .. ' : '.. msg )
    end
end)

RegisterNetEvent('chat:EmergencySend311r')
AddEventHandler('chat:EmergencySend311r', function(fal, caller, msg)
    if exports['isPed']:isPed('job') == 'Police' then
        TriggerEvent('chatMessagess', '311 RESPONSE: '.. caller, 4, 'Sent to: '.. fal .. ' : '.. msg )
    end
end)

RegisterNetEvent('chat:EmergencySend911')
AddEventHandler('chat:EmergencySend911', function(fal, caller, msg)
    if exports['isPed']:isPed('job') == 'Police' then
        TriggerEvent('chatMessagess', '[911] ', 1, '( Caller ID: '.. caller .. ' | ' .. fal ..' ) '.. msg )
        PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    end
end)

RegisterNetEvent('chat:EmergencySend311')
AddEventHandler('chat:EmergencySend311', function(fal, caller, msg)
    if exports['isPed']:isPed('job') == 'Police' then
        TriggerEvent('chatMessagess', '[311] ', 4, '( Caller ID: '.. caller .. ' | ' .. fal ..' ) '.. msg )
        PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    end
end)