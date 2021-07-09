RegisterNetEvent('fib:enter')
AddEventHandler('fib:enter', function()
	local Getmecuh = PlayerPedId()
	local rank = exports["isPed"]:GroupRank("Police")
	if rank > 9 then
	    DoScreenFadeOut(400)
	    Citizen.Wait(500)
	    SetEntityCoords(Getmecuh, 136.07, -761.84, 242.15)
	    Citizen.Wait(500)
	    DoScreenFadeIn(500)
    end
end)

RegisterNetEvent('fib:exit')
AddEventHandler('fib:exit', function()
	local Getmecuh = PlayerPedId()
	local rank = exports["isPed"]:GroupRank("Police")
	if rank > 9 then
	    DoScreenFadeOut(400)
	    Citizen.Wait(500)
	    SetEntityCoords(Getmecuh, 176.22, -728.61, 39.40)
	    Citizen.Wait(500)
	    DoScreenFadeIn(500)
    end
end)

RegisterNetEvent('fib:armory')
AddEventHandler('fib:armory', function()
	local rank = exports["isPed"]:GroupRank("Police")
	if rank > 9 then
        TriggerEvent('prp-ac:triggeredItemSpawn', 27, "Shop")
    end
end)


RegisterNetEvent('fib:evidence')
AddEventHandler('fib:evidence', function()
	local rank = exports["isPed"]:GroupRank("Police")
	if rank > 9 then
		TriggerEvent("prp-ac:triggeredItemSpawn", "1", "trash-2")
	end
end)