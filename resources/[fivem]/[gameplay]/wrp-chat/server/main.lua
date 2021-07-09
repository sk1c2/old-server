--[[

  urpCore RP Chat

--]]

AddEventHandler('chatMessage', function(source, name, message)
    CancelEvent()
    end)
  
  -- TriggerEvent('es:addCommand', 'me', function(source, args, user)
  --    local name = getIdentity(source)
  --    TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname, table.concat(args, " "))
  -- end) 



  --- TriggerEvent('es:addCommand', 'me', function(source, args, user)
  ---    local name = getIdentity(source)
  ---    TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname, table.concat(args, " "))
  -- end) 
  --[[TriggerEvent('es:addCommand', 'me', function(source, args, user)
    local name = getIdentity(source)
    table.remove(args, 2)
    TriggerClientEvent('wrp-qalle-chat:me', -1, source, name.firstname, table.concat(args, " "))
end)


 RegisterCommand('tweet', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(6)
    local name = getIdentity(source)
    fal = name.firstname .. " " .. name.lastname
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 3px;"><i class="fab fa-twitter"></i> @{0}:<br> {1}</div>',
        args = { fal, msg }
    })
end, false)

 RegisterCommand('anontweet', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(11)
    local name = getIdentity(source)
    fal = name.firstname .. " " .. name.lastname
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 3px;"><i class="fab fa-twitter"></i> @Anonymous:<br> {1}</div>',
        args = { fal, msg }
    })
end, false)]]--

 --[[RegisterCommand('ad', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(4)
    local name = getIdentity(source)
    local fal = name.firstname .. " " .. name.lastname
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message advert"><div class="chat-message-header"style="font-weight: bold;">{0}:</div><div class="chat-message-body">{1}</div></div>',
        args = {"AD " .. name.firstname .. ' ' ..name.lastname .. ' ', msg }
    })
end, false)]]--

RegisterServerEvent('chat:oocmessage')
AddEventHandler('chat:oocmessage', function(cid, firstname, lastname, dob, gender, message)
    local playerName = GetPlayerName(source)

    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message tweet"><b>OOC {0} [{1}] :</b> {2}</div>',
        args = {firstname .. ' ' ..lastname .. ' ', source, message }
    })
    PerformHttpRequest("https://discord.com/api/webhooks/797455468703514635/ZWr8D8ycyhmkzzl5mi_hripbhV9gk2F7iwOE69jWpx9Noe4rR7eh_sss4g6bCPrrZI17", function(err, text, headers) end, 'POST', json.encode({username = playerName .. " [" .. source .. "]", content = "OOC Message : " .. message, tts = false}), { ['Content-Type'] = 'application/json' })
end)


function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

RegisterServerEvent("911")
AddEventHandler("911", function(args, cid)
    src = source
    exports.ghmattimysql:execute('SELECT `job`, `first_name`, `last_name`, `phone_number` FROM __characters WHERE id = ?', {cid}, function(result)
        job = result[1].job
        firstname = result[1].first_name
        lastname = result[1].last_name
        phonenumber = result[1].phone_number

        local message = ""


        for k,v in ipairs(args) do
            message = message .. " " .. v
        end


        TriggerClientEvent("GPSTrack:Create", src)
        TriggerClientEvent("animation:phonecall", src)



        for k,v in pairs(GetPlayers()) do
            TriggerClientEvent('wrp-911:display', k, firstname, lastname, phonenumber, tostring(message), src)
        end
    end)
end)

RegisterServerEvent("311")
AddEventHandler("311", function(args, cid)
    src = source
    exports.ghmattimysql:execute('SELECT `job`, `first_name`, `last_name`, `phone_numbers` FROM __characters WHERE id = ?', {cid}, function(result)
        job = result[1].job
        firstname = result[1].first_name
        lastname = result[1].last_name
        phonenumber = result[1].phone_number

        local message = ""


        for k,v in ipairs(args) do
            message = message .. " " .. v
        end


        TriggerClientEvent("GPSTrack:Create", src)
        TriggerClientEvent("animation:phonecall", src)



        for k,v in pairs(GetPlayers()) do
            TriggerClientEvent('wrp-311:display', k, firstname, lastname, phonenumber, tostring(message), src)
        end
    end)
end)

RegisterServerEvent("911r")
AddEventHandler("911r", function(args, cid)
	local src = source
    exports.ghmattimysql:execute('SELECT `job`, `first_name`, `last_name`, `phone_number` FROM __characters WHERE id = ?', {cid}, function(result)
            
        -- table.remove(args, 1)
        job = result[1].job
        firstname = result[1].first_name
        lastname = result[1].last_name
        phonenumber = result[1].phone_number

        if not args[1] or not tonumber(args[1]) then return end
        local target = args[1]


        local canRun = (job == "Police" or job == "EMS") and true or false
        if not canRun then return end

        local message = ""

        for k,v in ipairs(args) do
            if k > 1 then
                message = message .. " " .. v
            end
        end
        TriggerClientEvent("animation:phonecall", src)

        for k,v in pairs(GetPlayers()) do
            TriggerClientEvent('wrp-911r:display', k, target, firstname, lastname, phonenumber, tostring(message))
        end

        TriggerClientEvent("chatMessage", target, "911r | (" .. tonumber(src) ..")", 3, tostring(message))
    end)
end)

RegisterServerEvent("311r")
AddEventHandler("311r", function(args, cid)
	local src = source
    exports.ghmattimysql:execute('SELECT `job`, `first_name`, `last_name`, `phone_number` FROM __characters WHERE id = ?', {cid}, function(result)
            
        -- table.remove(args, 1)
        job = result[1].job
        firstname = result[1].first_name
        lastname = result[1].last_name
        phonenumber = result[1].phone_number

        if not args[1] or not tonumber(args[1]) then return end
        local target = args[1]


        local canRun = (job == "Police" or job == "EMS") and true or false
        if not canRun then return end

        local message = ""

        for k,v in ipairs(args) do
            if k > 1 then
                message = message .. " " .. v
            end
        end
        TriggerClientEvent("animation:phonecall", src)

        for k,v in pairs(GetPlayers()) do
            local player = exports['wrp-base']:GetCurrentCharacterInfo(k)
            TriggerClientEvent('wrp-311r:display', k, target, firstname, lastname, phonenumber, tostring(message))
        end

        TriggerClientEvent("chatMessage", target, "311r | (" .. tonumber(src) ..")", 3, tostring(message))
    end)
end)