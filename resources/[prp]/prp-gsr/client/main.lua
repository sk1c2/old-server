local hasShot = false
local ignoreShooting = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        ped = PlayerPedId()
        if IsPedShooting(ped) then
            local currentWeapon = GetSelectedPedWeapon(ped)
            for _,k in pairs(Config.weaponChecklist) do
                if currentWeapon == k then
                    ignoreShooting = true
                    break
                end
            end
            
            if not ignoreShooting then
                TriggerServerEvent('GSR:SetGSR', timer)
                hasShot = true
                ignoreShooting = false
                Citizen.Wait(Config.gsrUpdate)
            end
			ignoreShooting = false
        end
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(2000)
        if Config.waterClean and hasShot then
            ped = PlayerPedId()
            if IsEntityInWater(ped) then
                local animDict = "move_m@_idles@shake_off"
                local animation = "shakeoff_1"
                loadAnimDict(animDict)
                local animLength = GetAnimDuration(animDict, animation)
                TaskPlayAnim(PlayerPedId(), animDict, animation, 1.0, 4.0,animLength, 48, 0, 0, 0, 0)
                local finished = exports["prp-taskbar"]:taskBar(30000,"Cleaning off GSR")
                if IsEntityInWater(ped) then
                    hasShot = false
                    TriggerServerEvent('GSR:Remove')
                    TriggerEvent("DoLongHudText", "You washed off all the GSR", 1)
                else
                    TriggerEvent("DoLongHudText", "You left the water too early and did not wash off the gunshot residue.", 2)
                end
        			
    		
				Citizen.Wait(Config.waterCleanTime)
            end
        end
    end
end)

function status()
    if hasShot then
        TriggerServerEvent('GSR:Status', function(cb)
            if not cb then
                hasShot = false
            end
        end)
    end
end

function updateStatus()
    status()
    SetTimeout(Config.gsrUpdateStatus, updateStatus)
end

updateStatus()
