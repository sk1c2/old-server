RegisterServerEvent("updateJailTime")
AddEventHandler("updateJailTime", function(minutes, cid)
    local src = source
    exports.ghmattimysql:execute("UPDATE `__characters` SET `jail` = '" .. minutes .. "' WHERE `id` = '" .. cid .. "'")
end)

RegisterServerEvent("checkJailTime")
AddEventHandler("checkJailTime", function(cid)
    local src = source
    exports.ghmattimysql:execute("SELECT `jail` FROM `__characters` WHERE id = '" .. cid .. "'", {}, function(result)
        if result[1] and result[1].jail then
            TriggerClientEvent("TimeRemaining", src, tonumber(result[1].jail), tonumber(result[1].jail) and tonumber(result[1].jail) <= 0)
--            if result[0] then 
--            TriggerClientEvent("endJailTime", args[1])
--            end 
        end
	end)
end)

RegisterServerEvent("jail:cuttime")
AddEventHandler("jail:cuttime", function(time, cid)
    local src = source
    exports.ghmattimysql:execute("SELECT `jail` FROM `__characters` WHERE id = '" .. cid .. "'", {}, function(result)
        if result[1] and result[1].jail then
            local newtime = result[1].jail - time
            exports.ghmattimysql:execute("UPDATE `__characters` SET `jail` = '" .. newtime .. "' WHERE `id` = '" .. cid .. "'")
            TriggerClientEvent("chatMessagess", src, "DOC | " , 4, "You have " .. newtime .. " months remaining")
        end
	end)
end)


RegisterCommand('unjail', function(source, args)
    local src = source
    local player = exports['prp-base']:GetCurrentCharacterInfo(src)
    if player.job == 'Police' then
        if args[1] then
            TriggerClientEvent("endJailTime", args[1])
        else
            TriggerClientEvent('DoLongHudText', source, 'There are no player with this ID', 2)
        end
    end
end)

RegisterServerEvent('prp-jailhehe')
AddEventHandler('prp-jailhehe', function(targetid, time, name, cid)
    TriggerClientEvent("beginJail", targetid, time, name, cid)
    TriggerClientEvent("drawScaleformJail", targetid, time, name, cid)
end)
-- RegisterCommand('jail', function(source, args)
--     local src = source
--     local player = exports['prp-base']:GetCurrentCharacterInfo(src)
--     local JailPlayer = exports['prp-base']:GetCurrentCharacterInfo(args[1])
--     local name = JailPlayer.first_name .. ' ' .. JailPlayer.last_name 
--     local cid = JailPlayer.id
--     local date = os.date()
--     if player.job == 'Police' then
--         if args[1] then
--             if args[2] then
--                 TriggerClientEvent("beginJail", args[1], args[2], name, cid, date)
--                 Citizen.Wait(1000)
--                 TriggerClientEvent("drawScaleformJail", args[1], args[2], name, cid, date)
--             else
--                 TriggerClientEvent("DoLongHudText", src, 'Invaild jail time. wtf?', 2)
--             end
--         else
--             TriggerClientEvent('DoLongHudText', source, 'here are no player with this ID', 2)
--         end
--     end
-- end)