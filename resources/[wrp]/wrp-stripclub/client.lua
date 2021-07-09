dancing = false

function DrawText3D(x, y, z, text) 
    local onScreen, _x, _y = World3dToScreen2d(x, y, z) 
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords()) 
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(0, 0, 0, 0, 155)
    SetTextEdge(1, 0, 0, 0, 250)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(6)
        local ped = PlayerPedId()
        local Getmecuh = PlayerPedId()
        local x,y,z = 109.2703, -1288.77, 29.24971
        local drawtext = "[~g~E~s~] To Dance"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 1.2 and dancing == false then
            DrawText3D(x,y,z, drawtext) 
			if IsControlJustReleased(0, 38) and dancing == false then
				dancing = true
                local testdic = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1"
                local testanim = "ld_girl_a_song_a_p1_f"
                RequestAnimDict(testdic)
                Citizen.Wait(100)
                TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, 120000, 0,0,0,0)
                FreezeEntityPosition(GetPlayerPed(-1),true)
                local dancecooldown = math.random(20000,25000)
                Citizen.Wait(dancecooldown)
                local finished = exports['wrp-taskbarskill']:taskBar(4000,3)
                if finished == 100 then
                    TriggerEvent('wrp-ac:InfoPass', math.random(10,20))
                else
                    dancing = false
                    ClearPedTasks(PlayerPedId(-1))
                    FreezeEntityPosition(GetPlayerPed(-1),false)
                end
            end
		elseif dancing == true then
			local testdic = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1"
			local testanim = "ld_girl_a_song_a_p1_f"
			RequestAnimDict(testdic)
			Citizen.Wait(100)
            TaskPlayAnim(ped, testdic, testanim, 1.0, 1.0, 120000, 0,0,0,0)
            FreezeEntityPosition(GetPlayerPed(-1),true)
			local dancecooldown = math.random(20000,25000)
			Citizen.Wait(dancecooldown)
			local finished = exports['wrp-taskbarskill']:taskBar(4000,3)
			if finished == 100 then
				TriggerEvent('wrp-ac:InfoPass', math.random(10,20))
			else
                dancing = false
                ClearPedTasks(PlayerPedId(-1))
                FreezeEntityPosition(GetPlayerPed(-1),false)
			end
		end
    end
end)

RegisterNetEvent('drinks:bar')
AddEventHandler('drinks:bar', function()
    local rank = exports["isPed"]:GroupRank("VanillaUnicorn")
    if rank > 0 then
	    TriggerEvent("wrp-ac:triggeredItemSpawn", "14", "Shop")
    end
end)