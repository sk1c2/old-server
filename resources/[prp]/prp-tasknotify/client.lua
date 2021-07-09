function openGui(clr,msg,time)
    guiEnabled = true
    SendNUIMessage({runProgress = true, colorsent = clr, textsent = msg, fadesent = time})
end

function closeGui()
    guiEnabled = false
    SendNUIMessage({closeProgress = true})
end

RegisterNetEvent("tasknotify:guiupdate")
AddEventHandler("tasknotify:guiupdate", function(color,message,time)
    openGui(color,message,time)
end)

RegisterNetEvent("tasknotify:guiclose")
AddEventHandler("tasknotify:guiclose", function()
    closeGui()
end)

RegisterNetEvent('DoLongHudText')
AddEventHandler('DoLongHudText', function(text,color,length)
    if not color then color = 1 end
    if not length then length = 12000 end
    TriggerEvent("tasknotify:guiupdate",color, text, 12000)
end)

RegisterNetEvent('DoShortHudText')
AddEventHandler('DoShortHudText', function(text,color,length)
    if not color then color = 1 end
    if not length then length = 10000 end
    TriggerEvent("tasknotify:guiupdate",color, text, 10000)
end)