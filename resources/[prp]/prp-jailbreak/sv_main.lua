RegisterServerEvent("jailbreak:finish_sv")
AddEventHandler("jailbreak:finish_sv", function(step)
    if step == "1" then
        TriggerEvent('wrp-doors_sv:setState', "PRISON", vector3(1844.9689941406,2605.1655273438,45.572898864746), false, false)
    elseif step == "2" then
        TriggerEvent('wrp-doors_sv:setState', "PRISON", vector3(1818.5279541016,2608.2858886719,45.592784881592), false, false)
        TriggerEvent('wrp-doors_sv:setState', "PRISON", vector3(1791.07, 2593.75, 46.07), false, true)
        TriggerEvent('wrp-doors_sv:setState', "PRISON", vector3(1786.36900, 2600.218, 45.99691), false, false)
        TriggerEvent('wrp-doors_sv:setState', "PRISON", vector3(1796.9868164063,2596.5417480469,45.701606750488), false, false)
        TriggerEvent('wrp-doors_sv:setState', "PRISON", vector3(1797.1591796875,2591.8620605469,45.795680999756), false, false)
        TriggerEvent("jailbreak:Start:Countdown", 300000) -- 5 mins
        TriggerEvent("jailbreak:Start:Relock", 7200000) -- 2hours
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div style="padding: 0.475vw; padding-left: 0.8vw; padding-right: 0.7vw; margin: 0.1vw; background-color: rgba(138, 18, 18); border-radius: 10px 10px 10px 10px;"><span style="font-weight: bold;">Goverment: </span>There is currently a jailbreak at bolingbroke, stay clear of the area or you may end up arrested or shot.</div>',
            args = {}
        })
    end
end)

RegisterServerEvent("jailbreak:Start:Countdown")
AddEventHandler("jailbreak:Start:Countdown", function(time)
    Citizen.Wait(time)
    exports.ghmattimysql:execute("UPDATE _jailtimes SET `time` = @newJailTime", {
        ['@newJailTime'] = "0"
    })

    TriggerClientEvent("jailbreak:force:unjail", -1)
    
end)


RegisterServerEvent("jailbreak:Start:Relock")
AddEventHandler("jailbreak:Start:Relock", function(time)
    Citizen.Wait(time)
    TriggerEvent('wrp-doors_sv:setState', "PRISON", vector3(1818.5279541016,2608.2858886719,45.592784881592), true, false)
    TriggerEvent('wrp-doors_sv:setState', "PRISON", vector3(1786.36900, 2600.218, 45.99691), true, false)
    TriggerEvent('wrp-doors_sv:setState', "PRISON", vector3(1796.9868164063,2596.5417480469,45.701606750488), true, false)
    TriggerEvent('wrp-doors_sv:setState', "PRISON", vector3(1797.1591796875,2591.8620605469,45.795680999756), true, false)
    TriggerEvent('wrp-doors_sv:setState', "PRISON", vector3(1844.9689941406,2605.1655273438,45.572898864746), true, false)
end)