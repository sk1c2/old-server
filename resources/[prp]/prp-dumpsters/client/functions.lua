function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

showPercent = function(time)
	percent = true
	TimeLeft = 0
	repeat
	TimeLeft = TimeLeft + 1
	Citizen.Wait(time)
	until(TimeLeft == 100)
	percent = false
end

openBin = function(entity)
	searching = true
	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_SHOPPING_CART", 0, true)

	if math.random(100) >= 75 then TriggerEvent('wrp-status:applyStatus', 'Agitated') end

	CreateThread(function()
        while true do
          Wait(0)

          if searching then
            local animation = IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_BUM_SHOPPING_CART")
            if not animation then TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_SHOPPING_CART", 0, true) end
            Citizen.Wait(1)
          else
            ClearPedTasks(PlayerPedId())
            return
          end
        end
	end)

	local f = exports["wrp-taskbar"]:taskBar(math.random(17500, 25000),"Searching Dumpster")

    if f == 100 then
    	cachedBins[entity] = true
		TriggerServerEvent('wrp-dumpsters:getItem')
    print('asdasdasd')
		searching = false
    end
end