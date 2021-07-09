URP.Events = URP.Events or {}
URP.Events.Total = 0
URP.Events.Active = {}

function URP.Events.Trigger(self, event, args, callback)
    local id = URP.Events.Total + 1
    URP.Events.Total = id

    id = event .. ":" .. id

    if URP.Events.Active[id] then return end

    URP.Events.Active[id] = {cb = callback}
    
    --TriggerServerEvent("np-events:listenEvent", id, event, args)
end

RegisterNetEvent("np-events:listenEvent")
AddEventHandler("np-events:listenEvent", function(id, data)
    local ev = URP.Events.Active[id]
    
    if ev then
        ev.cb(data)
        URP.Events.Active[id] = nil
    end
end)