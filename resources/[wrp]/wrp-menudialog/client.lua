
exports('AddButton', function(title , description , trigger , par)
    SetNuiFocus(true , true)
    SendNUIMessage({addbutton = true , title = title , description = description , trigger = trigger , par = par })
end)


exports('SetTitle', function(title)
    SendNUIMessage({SetTitle = true , title = title})
end)

RegisterNUICallback("clicked" , function(data , cb)
    local trigger = data.trigger
    local d = data.server
    local d = data.server
    TriggerServerEvent(trigger ,tostring(data.param ))
    TriggerEvent(trigger , tostring(data.param ))
    
end)
RegisterNUICallback("close" , function(data , cb)
    SetNuiFocus(false , false)
end)





