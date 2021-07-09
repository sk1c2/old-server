local jobs = {
  {id = 1, active = 0, coords = vector3(61.61838, 127.0134, 79.216), shopId = 1, drop = {26.33855,279.3335,109.55}, pickup = {-170.607,242.3632,93.277}, dropAmount = 5},
  {id = 2, active = 0, coords = vector3(2760.77, 3472.35,  55.63), shopId = 2, drop = {26.33855,279.3335,109.55}, pickup = {2760.77, 3472.35,  55.63}, dropAmount = 5},

}

RegisterServerEvent("trucker:returnCurrentJobs")
AddEventHandler("trucker:returnCurrentJobs", function()
  TriggerClientEvent("trucker:updateJobs", source, jobs)
end)

RegisterServerEvent("trucker:jobTaken")
AddEventHandler("trucker:jobTaken", function(id)
    jobs[id].active = 1
    TriggerClientEvent("trucker:updateJobs", -1, jobs)
end)

RegisterServerEvent("trucker:jobFinished")
AddEventHandler("trucker:jobFinished", function(id)
  jobs[id].active = 0
  TriggerClientEvent("trucker:updateJobs", -1, jobs)
end)

RegisterServerEvent("trucker:jobfailure")
AddEventHandler("trucker:jobfailure", function(bool, id)
  jobs[id].active = 0
  TriggerClientEvent("trucker:updateJobs", -1, jobs)
end)

RegisterServerEvent("trucker:CarUsed")
AddEventHandler("trucker:CarUsed", function(i)
  TriggerClientEvent("trucker:acceptspawn", source, i)
end)

RegisterServerEvent('server:givepayJob')
AddEventHandler('server:givepayJob', function(money)
    local source = source
    local LocalPlayer = exports['prp-base']:getModule('LocalPlayer')
    if money ~= nil then
       TriggerClientEvent('prp-ac:InfoPass', source, money)
       TriggerClientEvent('DoLongHudText', source, 'You got $'.. money .. ' for 5 Loose Buds of Weed.', 1)
    end
end)