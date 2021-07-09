RegisterCommand('ooc', function(source, args)
  local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
  local Player = LocalPlayer:getCurrentCharacter()
  local cid = exports['isPed']:isPed('cid')
  local firstname = Player.first_name
  local lastname = Player.last_name
  local dob = Player.dob
  local gender = Player.gender
  local text = '' -- edit here if you want to change the language : EN: the person / FR: la personne
  for i = 1,#args do
    text = text .. ' ' .. args[i]
  end
  TriggerServerEvent('chat:oocmessage', cid, firstname, lastname, dob, gender, text)
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "^4" .. name .. "", {0, 153, 204}, "^7 " .. message)
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
    TriggerEvent('chatMessage', "^4" .. name .. "", {0, 153, 204}, "^7 " .. message)
  end
end)

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
  end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^0* " .. name .."  ".."^0  " .. message)
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^0* " .. name .."  ".."^0  " .. message)
  end
end)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/911', 'Emergency! Tell the Police or EMS your situation (Can do when dead)')
  TriggerEvent('chat:addSuggestion', '/311', 'None-Emergency! Tell the Police or EMS your situation (Can do when dead)')
  TriggerEvent('chat:addSuggestion', '/911r', 'Reply to a 911 Call if You are Police or EMS')
  TriggerEvent('chat:addSuggestion', '/311r', 'Reply to a 311 Call if You are Police or EMS')
end)


RegisterCommand('911', function(source, args)
  TriggerServerEvent('911', args, exports['isPed']:isPed('cid'))
  local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
  local Player = LocalPlayer:getCurrentCharacter()
  local firstname = Player.first_name
  local lastname = Player.last_name
  local phone_number = Player.phone_number
  local job = exports['isPed']:isPed('job')
  local cid = exports['isPed']:isPed('cid')
  local message = ""
  local id = GetPlayerFromServerId()
  for k,v in ipairs(args) do
      message = message .. " " .. v
  end
  -- TriggerEvent('chatMessage', '911 | ' ..  firstname .. " | " .. lastname .. " # " .. phone_number, 3, tostring(message))
end)

RegisterCommand('911r', function(source, args)
  TriggerServerEvent('911r', args, exports['isPed']:isPed('cid'))
end)

RegisterCommand('311r', function(source, args)
  TriggerServerEvent('311r', args, exports['isPed']:isPed('cid'))
end)

RegisterCommand('311', function(source, args)
  TriggerServerEvent('311', args, exports['isPed']:isPed('cid'))
  local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
  local Player = LocalPlayer:getCurrentCharacter()
  local firstname = Player.first_name
  local lastname = Player.last_name
  local phone_number = Player.phone_number
  local job = exports['isPed']:isPed('job')
  local cid = exports['isPed']:isPed('cid')
  local message = ""
  for k,v in ipairs(args) do
      message = message .. " " .. v
  end
  -- TriggerEvent('chatMessage', '311 | ' ..  firstname .. " | " .. lastname .. " # " .. phone_number, 3, tostring(message))
end)

RegisterNetEvent('wrp-911:display')
AddEventHandler('wrp-911:display', function(firstname, lastname, phonenumber, message, src)
  if exports['isPed']:isPed('job') == 'Police' then
    TriggerEvent('chatMessage', '911 | ( '.. src .. ' ) ' .. firstname .. " | " .. lastname .. " #" .. phonenumber, 2, tostring(message))
    TriggerEvent("callsound")
    PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
  elseif exports['isPed']:isPed('job') == 'EMS' then
    TriggerEvent('chatMessage', '911 | ( '.. src .. ' ) ' .. firstname .. " | " .. lastname .. " #" .. phonenumber, 2, tostring(message))
    TriggerEvent("callsound")
    PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
  end
end)

RegisterNetEvent('wrp-311:display')
AddEventHandler('wrp-311:display', function(firstname, lastname, phonenumber, message, src)
  if exports['isPed']:isPed('job') == 'Police' then
    TriggerEvent('chatMessage', '311 | ( '.. src .. ' ) ' .. firstname .. " | " .. lastname .. " #" .. phonenumber, 2, tostring(message))
  elseif exports['isPed']:isPed('job') == 'Police' then
    TriggerEvent('chatMessage', '311 | ( '.. src .. ' ) ' .. firstname .. " | " .. lastname .. " #" .. phonenumber, 2, tostring(message))
  end
end)

RegisterNetEvent('wrp-911r:display')
AddEventHandler('wrp-911r:display', function(target, firstname, lastname, phonenumber, message)
  if exports['isPed']:isPed('job') == 'Police' then
    TriggerEvent('chatMessage', '911r -> | ' .. target .. " | " .. firstname .. " | " .. lastname .. " # " .. phonenumber, 3, tostring(message))
  elseif exports['isPed']:isPed('job') == 'Police' then
    TriggerEvent('chatMessage', '911r -> | ' .. target .. " | " .. firstname .. " | " .. lastname .. " # " .. phonenumber, 3, tostring(message))
  end
end)

RegisterNetEvent('wrp-311r:display')
AddEventHandler('wrp-311r:display', function(target, firstname, lastname, phonenumber, message)
  if exports['isPed']:isPed('job') == 'Police' then
    TriggerEvent('chatMessage', '311r -> | ' .. target .. " | " .. firstname .. " | " .. lastname .. " # " .. phonenumber, 3, tostring(message))
  elseif exports['isPed']:isPed('job') == 'Police' then
    TriggerEvent('chatMessage', '311r -> | ' .. target .. " | " .. firstname .. " | " .. lastname .. " # " .. phonenumber, 3, tostring(message))
  end
end)

-- RegisterNetEvent('wrp-chat:911obtain')
-- AddEventHandler('wrp-chat:911obtain', function(message)
--   local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
--   local Player = LocalPlayer:getCurrentCharacter()
--   local name = Player.first_name .. ' ' .. Player.last_name
--   local phone_number = Player.phone_number
--   local job = exports['isPed']:isPed('job')
--   local cid = exports['isPed']:isPed('cid')
--   print('yerr')
--   if job == 'Police' then
--     TriggerEvent('chatMessage', '911 | ' .. Player.first_name .. " | " .. Player.last_name .. " # " .. phone_number, 3, tostring(message))
--   end
-- end)
    -- TriggerClientEvent("chatMessage", src, "911 | " .. char.first_name .. " | " .. char.last_name .. " # " .. phonenumber, 3, tostring(message))