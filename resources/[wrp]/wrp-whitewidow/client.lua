part1 = false
part2 = false
part3 = false
part4 = false
part5 = false
Temperature = 20
Temperature2 = 20

RegisterNetEvent('weed:fertilizer')
AddEventHandler('weed:fertilizer', function()
	local job = exports['isPed']:isPed('job')
	if job == 'WhiteWidow' then
        TriggerEvent("animation:fertilizer")
        FreezeEntityPosition(GetPlayerPed(-1),true)
		exports['wrp-taskbar']:taskBar(10000, 'Grabbing Fertilizer')
        TriggerEvent('wrp-banned:getID',"highgradefert", 1)
        FreezeEntityPosition(GetPlayerPed(-1),false)
	end
end)

RegisterNetEvent('animation:fertilizer')
AddEventHandler('animation:fertilizer', function()

		inanimation = true
		local lPed = GetPlayerPed(-1)
		RequestAnimDict("amb@world_human_gardener_plant@male@base")
		while not HasAnimDictLoaded("amb@world_human_gardener_plant@male@base") do
			Citizen.Wait(0)
		end
		
		if IsEntityPlayingAnim(lPed, "amb@world_human_gardener_plant@male@base", "base", 3) then
			ClearPedSecondaryTask(lPed)
		else
			TaskPlayAnim(lPed, "amb@world_human_gardener_plant@male@base", "base", 8.0, -8, -1, 49, 0, 0, 0, 0)
			seccount = 10
			while seccount > 0 do
				Citizen.Wait(1000)
				seccount = seccount - 1
			end
			ClearPedSecondaryTask(lPed)
		end		
		inanimation = false

end)

Citizen.CreateThread(function()
    while part1 == true do
        Citizen.Wait(10000)
        Temperature = Temperature - 3
        if Temperature <= 30 then
           Temperature = 30
           part1 = false
        end 
    end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

RegisterNetEvent('wrp-cookshit')
AddEventHandler('wrp-cookshit', function()
    local job = exports['isPed']:isPed('job')
    if job == 'WhiteWidow' then
    if Temperature < 50 then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['wrp-taskbar']:taskBar(5000, 'Pouring Fertilizer..')
        ClearPedTasks(PlayerPedId())
        Temperature = Temperature + 10
        part1 = true
    else
        if exports['wrp-inventory']:hasEnoughOfItem('highgradefert', 2) then
            exports['wrp-taskbar']:taskBar(2500, 'Setting Fertilizer..')
            Citizen.Wait(100)
            exports['wrp-taskbar']:taskBar(2500, 'Checking Fertilizer')
            Citizen.Wait(100)
            if Temperature < 50 then
                TriggerEvent('DoLongHudText', 'You let the fertilizer set for to long!', 2)
            else
                Citizen.Wait(10)
                exports['wrp-taskbar']:taskBar(2500, 'Checking Fertilizer..')
                Citizen.Wait(100)
                exports['wrp-taskbar']:taskBar(15000, 'Allowing Fertilizer to set..')
                Citizen.Wait(100)
                TriggerEvent('DoLongHudText', 'Fertilizer has set!')
                exports['wrp-taskbar']:taskBar(2500, 'Picking the weed!')
                Citizen.Wait(100)
                TriggerEvent('wrp-banned:getID', 'weedq', math.random(1,5))
                TriggerEvent('inventory:removeItem', 'highgradefert', 2)
            end
        end
    end
    end
end)

RegisterNetEvent('weed:make')
AddEventHandler('weed:make', function()
	local job = exports['isPed']:isPed('job')
	if job == 'WhiteWidow' then
        TriggerEvent("wrp-ac:triggeredItemSpawn", "86", "Craft");
    end
end)

RegisterNetEvent('weed:stash')
AddEventHandler('weed:stash', function()
	local job = exports['isPed']:isPed('job')
	if job == 'WhiteWidow' then
		TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "storage-whitewidow")	
	end
end)

RegisterNetEvent('whitewidow:pickup')
AddEventHandler('whitewidow:pickup', function()
	TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "whitewidow_counter")
end)