RegisterCommand("help" , function(rawCommand , source)
    SetNuiFocus(true , true)
    
    SendNUIMessage({
        type = "open"
    })
end)

RegisterNUICallback("exit", function()
    SetNuiFocus(false , false)
end)

function OpenWelcome()
    SetNuiFocus(true , true)
    
    SendNUIMessage({
        type = "open"
    })
end