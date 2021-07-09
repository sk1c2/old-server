


RegisterServerEvent('wrp-reportui:sendReport')
AddEventHandler('wrp-reportui:sendReport', function(title, description, clips)
	
	sendToDiscord(title, "Description: `" .. description .. "` \n Clips: " .. clips .. ".\n Steam: `" ..GetPlayerName(source).."`", color)
end)

function sendToDiscord(name, message, color)
	local connect = {
		  {
			  ["color"] = color,
			  ["title"] = "**".. name .."**",
			  ["description"] = message,
			  ["footer"] = {
				  ["text"] = "Untiy RP Issues / Bugs",
			  },
		  }
	  }
	PerformHttpRequest('https://discord.com/api/webhooks/861308623333883954/FIRTqPpVNVZtq03noYyqU5OwIMTk8y1mo8n4E5s784ELdg54UhYMGz8vpZhFOouixojH', function(err, text, headers) end, 'POST', json.encode({username = 'Bug Reports', embeds = connect}), { ['Content-Type'] = 'application/json' })
end