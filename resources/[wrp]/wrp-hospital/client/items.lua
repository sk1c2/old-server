function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

RegisterNetEvent("wrp-hospital:items:gauze")
AddEventHandler("wrp-hospital:items:gauze", function(item)
    loadAnimDict("missheistdockssetup1clipboard@idle_a")
    TaskPlayAnim( PlayerPedId(), "missheistdockssetup1clipboard@idle_a", "idle_a", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Packing Wounds', 1500, function()
        local finished = exports["wrp-taskbar"]:taskBar(1500,"Packing Wounds")
        if finished == 100 then
        TriggerEvent('wrp-hospital:client:FieldTreatBleed')
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("wrp-hospital:items:bandage")
AddEventHandler("wrp-hospital:items:bandage", function(item)
    loadAnimDict("missheistdockssetup1clipboard@idle_a")
    TaskPlayAnim( PlayerPedId(), "missheistdockssetup1clipboard@idle_a", "idle_a", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Using Bandage', 5000, function()
        local finished = exports["wrp-taskbar"]:taskBar(5000,"Using Bandage")
        if finished == 100 then
        local maxHealth = GetEntityMaxHealth(PlayerPedId())
		local health = GetEntityHealth(PlayerPedId())
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 16))
        SetEntityHealth(PlayerPedId(), newHealth)
        TriggerEvent('wrp-hospital:client:RemoveBleed')
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("wrp-hospital:items:healplayer")
AddEventHandler("wrp-hospital:items:healplayer", function(item)
--    exports["urp_taskbar"]:StartDelayedFunction('Using Bandage', 5000, function()
    local maxHealth = GetEntityMaxHealth(PlayerPedId())
	local health = GetEntityHealth(PlayerPedId())
	local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 16))
    SetEntityHealth(PlayerPedId(), newHealth)
    TriggerEvent('wrp-hospital:client:RemoveBleed')
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("wrp-hospital:items:firstaid")
AddEventHandler("wrp-hospital:items:firstaid", function(item)
    loadAnimDict("missheistdockssetup1clipboard@idle_a")
    TaskPlayAnim( PlayerPedId(), "missheistdockssetup1clipboard@idle_a", "idle_a", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Using First Aid', 10000, function()
        local finished = exports["wrp-taskbar"]:taskBar(10000,"Using First Aid")
        if finished == 100 then
        local maxHealth = GetEntityMaxHealth(PlayerPedId())
		local health = GetEntityHealth(PlayerPedId())
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
        SetEntityHealth(PlayerPedId(), newHealth)
        TriggerEvent('wrp-hospital:client:RemoveBleed')
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("wrp-hospital:items:medkit")
AddEventHandler("wrp-hospital:items:medkit", function(item)
    loadAnimDict("missheistdockssetup1clipboard@idle_a")
    TaskPlayAnim( PlayerPedId(), "missheistdockssetup1clipboard@idle_a", "idle_a", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Using Medkit', 20000, function()
        local finished = exports["wrp-taskbar"]:taskBar(20000,"Using Medkit")
        if finished == 100 then
        SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
        TriggerEvent('wrp-hospital:client:FieldTreatLimbs')
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("wrp-hospital:items:vicodin")
AddEventHandler("wrp-hospital:items:vicodin", function(item)
    loadAnimDict("mp_suicide")
    TaskPlayAnim( PlayerPedId(), "mp_suicide", "pill", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Taking Oxycodone', 1000, function()

        local finished = exports["wrp-taskbar"]:taskBar(10000,"Taking Oxycodone")
        if finished == 100 then


        TriggerEvent('wrp-hospital:client:UsePainKiller', 1)
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("wrp-hospital:items:ifak")
AddEventHandler("wrp-hospital:items:ifak", function(item)
    loadAnimDict("mp_suicide")
    TaskPlayAnim( PlayerPedId(), "amb@world_human_clipboard@male@idle_a", "idle_c", 3.0, 1.0, 10000, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Using IFAK', 10000, function()

        local finished = exports["wrp-taskbar"]:taskBar(10000,"Using IFAK")
        if finished == 100 then

            
        TriggerEvent('wrp-hospital:client:UsePainKiller', 1)
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("wrp-hospital:items:hydrocodone")
AddEventHandler("wrp-hospital:items:hydrocodone", function(item)
    loadAnimDict("mp_suicide")
    TaskPlayAnim( PlayerPedId(), "mp_suicide", "pill", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Taking Hydrocodone', 1000, function()

        local finished = exports["wrp-taskbar"]:taskBar(1000,"Taking Hydrocodone")
        if finished == 100 then


        TriggerEvent('wrp-hospital:client:UsePainKiller', 2)
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("wrp-hospital:items:morphine")
AddEventHandler("wrp-hospital:items:morphine", function(item)
    loadAnimDict("mp_suicide")
    TaskPlayAnim( PlayerPedId(), "mp_suicide", "pill", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Taking Morphine', 2000, function()

        local finished = exports["wrp-taskbar"]:taskBar(2000,"Taking Morphine")
        if finished == 100 then

        
        TriggerEvent('wrp-hospital:client:UsePainKiller', 6)
        ClearPedTasks(PlayerPedId())
    end
end)