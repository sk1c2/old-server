URP.Commands = URP.Commands or {}

RegisterCommand('die', function(source)
    SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent('prp-base:setRank')
AddEventHandler('prp-base:setRank', function(rank)
    local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    LocalPlayer:setRank(Player.id, rank)
end)

RegisterNetEvent('prp-base:setJob')
AddEventHandler('prp-base:setJob', function(job)
    local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    LocalPlayer:setJob(Player.id, job)
end)

RegisterCommand('job', function()
    local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
    local job = LocalPlayer:getCurrentCharacter().job
    local rank = LocalPlayer:getRank()
    TriggerEvent('DoLongHudText', "Your job is currently: " .. job .. " with the rank of: " .. rank)
end)

RegisterCommand('coords', function()
    print("COORDS: " .. GetEntityCoords(PlayerPedId()))
    print("HEADING: " .. GetEntityHeading(PlayerPedId()))
end)