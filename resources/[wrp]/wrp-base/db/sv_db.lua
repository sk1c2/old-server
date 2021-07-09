function sendToDiscord9(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Developed with ❤️ by Breasty and Leggy",
              },
          }
      }
    PerformHttpRequest('https://discord.com/api/webhooks/838405850459537429/cWEDbq4QWRqMbcyGiJtKlvINJR6GfCzBzOq4_UNwUpBdMojpSHc3LPTFqpeWMhKEtda2', function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end

RegisterServerEvent('wrp-vpn:blockconnection')
AddEventHandler('wrp-vpn:blockconnection', function(source)
    local steamid  = false
    local license  = false
    local discord  = false
    local xbl      = false
    local liveid   = false
    local ip       = false

	for k,v in pairs(GetPlayerIdentifiers(source))do
			
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamid = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xbl  = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			ip = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		end
		
	end
    sendToDiscord9("VPN Block", "**" .. steamid .. "** has been blocked for using a VPN. \n\n**IP Address : **" .. ip, 65280)
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    local steamid  = false
    local license  = false
    local discord  = false
    local xbl      = false
    local liveid   = false
    local ip       = false

  for k,v in pairs(GetPlayerIdentifiers(source))do
        
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
        identifiers.steam = v
      elseif string.sub(v, 1, string.len("license:")) == "license:" then
        identifiers.license = v
      elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
        identifiers.xbl  = v
      elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
        identifiers.ip = v
      elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
        identifiers.discord = v
      elseif string.sub(v, 1, string.len("live:")) == "live:" then
        identifiers.liveid = v
      end
    
  end


    return identifiers
end

-- AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
--     local player = source
--     local name, setKickReason, deferrals = name, setKickReason, deferrals;
--     local ipIdentifier
--     local identifiers = GetPlayerIdentifiers(player)
--     deferrals.defer()
--     Wait(0)
--     deferrals.update(string.format("Hello %s. Checking for a VPN.", name))
--     for _, v in pairs(identifiers) do
--         if string.find(v, "ip") then
--             ipIdentifier = v:sub(4)
--             break
--         end
--     end
--     Wait(0)
--     if not ipIdentifier then
--         deferrals.done("We could not find your IP Address.")
--     else
--         PerformHttpRequest("http://ip-api.com/json/" .. ipIdentifier .. "?fields=proxy", function(err, text, headers)
--             if tonumber(err) == 200 then
-- 				local identifiers = GetPlayerIdentifiers(player)
--                 local tbl = json.decode(text)
--                 if tbl["proxy"] == false then
--                     deferrals.done()
--                 else
-- 					TriggerEvent('wrp-vpn:blockconnection', player)
--                     deferrals.done("You are using a VPN. Please disable and try again.")
--                 end
--             else
-- 				TriggerEvent('wrp-vpn:blockconnection', player)
--                 deferrals.done("There was an error in the API.")
--             end
--         end)
--     end
-- end)
