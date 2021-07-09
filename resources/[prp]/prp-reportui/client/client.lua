
-- Show UI
function EnableGUI(show)
    SetNuiFocus(show, show)
    SendNUIMessage({
        show = show,
    })
end

RegisterCommand("bug", function(source, args)
	EnableGUI(true)
end, false)

RegisterNUICallback('submit', function(data, cb)
	EnableGUI(false)
	local title = data.title
	local description = data.description
	local clips = data.clips
	TriggerServerEvent("wrp-reportui:sendReport", title, description, clips)
	TriggerEvent('DoLongHudText', 'Report sent!', 1)
  	cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
	EnableGUI(false)
  	cb('ok')
end)