local Success1 = false
local Success2 = false
local Success3 = false
local Success4 = false
local Success5 = false

RegisterNetEvent("jailbreak:start")
AddEventHandler("jailbreak:start", function(args)
    local hasitems = exports["prp-inventory"]:hasEnoughOfItem("thermite",1,false) and exports["prp-inventory"]:hasEnoughOfItem("electronickit",1,false) 
    if hasitems then
        if args == "First" then
            -- print('ananiste')
            local outcome = exports["prp-thermite"]:startGame(10,1,10,500)
            -- print('XD')
            if outcome then
                TriggerEvent('inventory:removeItem',"thermite", 1)
                FreezeEntityPosition(PlayerPedId(), true)
                TriggerEvent("attachItem","minigameThermite")
                RequestAnimDict("weapon@w_sp_jerrycan")
                while ( not HasAnimDictLoaded( "weapon@w_sp_jerrycan" ) ) do
                    Wait(10)
                end
                Wait(100)
                TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                Wait(5000)
                TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
            
                TriggerEvent("destroyProp")
                ClearPedTasks(PlayerPedId())
                TriggerEvent("notification","Thermite Success!")
                FreezeEntityPosition(PlayerPedId(), false)
                Success1 = true
            else
                local coords = GetEntityCoords(PlayerPedId())
                exports["prp-thermite"]:startFireAtLocation(coords.x, coords.y, coords.z, 10000)                    
                TriggerEvent('inventory:removeItem',"thermite", 1)
                Success1 = false
                FreezeEntityPosition(PlayerPedId(), false)
            end
    
            TriggerEvent("prp-states:stateSet",16,2200)
        
        elseif args == "Second" then
            local outcome = exports["prp-thermite"]:startGame(15,1,10,500)
            if outcome then
                TriggerEvent('inventory:removeItem',"thermite", 1)
                FreezeEntityPosition(PlayerPedId(), true)
                TriggerEvent("attachItem","minigameThermite")
                RequestAnimDict("weapon@w_sp_jerrycan")
                while ( not HasAnimDictLoaded( "weapon@w_sp_jerrycan" ) ) do
                    Wait(10)
                end
                Wait(100)
                TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                Wait(5000)
                TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
            
                TriggerEvent("destroyProp")
                ClearPedTasks(PlayerPedId())

                TriggerEvent("notification","Thermite Success!")
                FreezeEntityPosition(PlayerPedId(), false)
                Success2 = true
            else
                local coords = GetEntityCoords(PlayerPedId())
                exports["prp-thermite"]:startFireAtLocation(coords.x, coords.y, coords.z, 10000) 
                TriggerEvent('inventory:removeItem',"thermite", 1)
                Success2 = false
                FreezeEntityPosition(PlayerPedId(), false)
            end
    
            TriggerEvent("prp-states:stateSet",16,2200)

        elseif args == "Third" then
            local outcome = exports["prp-thermite"]:startGame(15,1,10,500)
            if outcome then
                TriggerEvent('inventory:removeItem',"thermite", 1)
                FreezeEntityPosition(PlayerPedId(), true)
                TriggerEvent("attachItem","minigameThermite")
                RequestAnimDict("weapon@w_sp_jerrycan")
                while ( not HasAnimDictLoaded( "weapon@w_sp_jerrycan" ) ) do
                    Wait(10)
                end
                Wait(100)
                TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                Wait(5000)
                TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
            
                TriggerEvent("destroyProp")
                ClearPedTasks(PlayerPedId())

                TriggerEvent("notification","Thermite Success!")
                FreezeEntityPosition(PlayerPedId(), false)
                Success3 = true
            else
                local coords = GetEntityCoords(PlayerPedId())
                exports["prp-thermite"]:startFireAtLocation(coords.x, coords.y, coords.z, 10000) 
                TriggerEvent('inventory:removeItem',"thermite", 1)
                Success3 = false
                FreezeEntityPosition(PlayerPedId(), false)
            end
    
            TriggerEvent("prp-states:stateSet",16,2200)
        elseif args == "Third" then
            local outcome = exports["prp-thermite"]:startGame(15,1,10,500)
            if outcome then
                TriggerEvent('inventory:removeItem',"thermite", 1)
                FreezeEntityPosition(PlayerPedId(), true)
                TriggerEvent("attachItem","minigameThermite")
                RequestAnimDict("weapon@w_sp_jerrycan")
                while ( not HasAnimDictLoaded( "weapon@w_sp_jerrycan" ) ) do
                    Wait(10)
                end
                Wait(100)
                TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                Wait(5000)
                TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
            
                TriggerEvent("destroyProp")
                ClearPedTasks(PlayerPedId())

                TriggerEvent("notification","Thermite Success!")
                FreezeEntityPosition(PlayerPedId(), false)
                Success3 = true
            else
                local coords = GetEntityCoords(PlayerPedId())
                exports["prp-thermite"]:startFireAtLocation(coords.x, coords.y, coords.z, 10000) 
                TriggerEvent('inventory:removeItem',"thermite", 1)
                Success3 = false
                FreezeEntityPosition(PlayerPedId(), false)
            end
    
            TriggerEvent("prp-states:stateSet",16,2200)
        
        elseif args == "Four" then
            local outcome = exports["prp-thermite"]:startGame(15,1,10,500)
            if outcome then
                TriggerEvent('inventory:removeItem',"thermite", 1)
                FreezeEntityPosition(PlayerPedId(), true)
                TriggerEvent("attachItem","minigameThermite")
                RequestAnimDict("weapon@w_sp_jerrycan")
                while ( not HasAnimDictLoaded( "weapon@w_sp_jerrycan" ) ) do
                    Wait(10)
                end
                Wait(100)
                TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                Wait(5000)
                TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
            
                TriggerEvent("destroyProp")
                ClearPedTasks(PlayerPedId())

                TriggerEvent("notification","Thermite Success!")
                FreezeEntityPosition(PlayerPedId(), false)
                TriggerServerEvent("jailbreak:finish_sv", "1")
                Success4 = true
            else
                local coords = GetEntityCoords(PlayerPedId())
                exports["prp-thermite"]:startFireAtLocation(coords.x, coords.y, coords.z, 10000) 
                TriggerEvent('inventory:removeItem',"thermite", 1)
                Success4 = false
                FreezeEntityPosition(PlayerPedId(), false)
            end
    
            TriggerEvent("prp-states:stateSet",16,2200)
        elseif args == "Five" then
            local outcome = exports["prp-thermite"]:startGame(15,1,10,500)
            if outcome then
                TriggerEvent('inventory:removeItem',"thermite", 1)
                FreezeEntityPosition(PlayerPedId(), true)
                TriggerEvent("attachItem","minigameThermite")
                RequestAnimDict("weapon@w_sp_jerrycan")
                while ( not HasAnimDictLoaded( "weapon@w_sp_jerrycan" ) ) do
                    Wait(10)
                end
                Wait(100)
                TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
                Wait(5000)
                TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire",2.0, -8, -1,49, 0, 0, 0, 0)
            
                TriggerEvent("destroyProp")
                ClearPedTasks(PlayerPedId())

                TriggerEvent("notification","Thermite Success!")
                FreezeEntityPosition(PlayerPedId(), false)
                TriggerServerEvent("jailbreak:finish_sv", "2")
                Success5 = true
            else
                local coords = GetEntityCoords(PlayerPedId())
                exports["prp-thermite"]:startFireAtLocation(coords.x, coords.y, coords.z, 10000) 
                TriggerEvent('inventory:removeItem',"thermite", 1)
                Success5 = false
                FreezeEntityPosition(PlayerPedId(), false)
            end
    
            TriggerEvent("prp-states:stateSet",16,2200)
        end
    else
        TriggerEvent("DoShortHudText", "Your missing stuff!")

    end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local Ped = PlayerPedId()
        local pedPos = GetEntityCoords(Ped, false)
        local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, 2809.6164550781,1547.6730957031,24.533981323242)
        local distance2 = Vdist(pedPos.x, pedPos.y, pedPos.z, 2800.7084960938,1514.0743408203,24.531812667847)
        local distance3 = Vdist(pedPos.x, pedPos.y, pedPos.z, 2792.4313964844,1482.4478759766,24.532499313354)
        local distance4 = Vdist(pedPos.x, pedPos.y, pedPos.z, 1846.6743164063,2604.7338867188,45.578563690186)
        local distance5 = Vdist(pedPos.x, pedPos.y, pedPos.z, 1820.0710449219,2604.6967773438,45.576549530029)
        if distance <= 1.2 then
            if Success1 == false then
                SendNUIMessage({openSection = "toolSelect", tool = "electricLock", card = "2"})
                DrawMarker(27,2809.6164550781,1547.6730957031,23.6, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 222, 2, 2, 60, 0, 0, 2, 0, 0, 0, 0)
                if IsControlJustPressed(1, 38) then
                    TriggerEvent("jailbreak:start", "First")
                    TriggerEvent("Alert:Cops:Grid")
                    TriggerEvent('urp:alert:jailbreak')
                end
            end
        elseif distance2 <= 1.2 then
            if Success1 == true and Success2 == false then
                SendNUIMessage({openSection = "toolSelect", tool = "electricLock", card = "2"})
                DrawMarker(27, 2800.7084960938,1514.0743408203,23.6, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 222, 2, 2, 60, 0, 0, 2, 0, 0, 0, 0)
                if IsControlJustPressed(1, 38) then
                    TriggerEvent("jailbreak:start", "Second")
                    TriggerEvent("Alert:Cops:Grid")
                    TriggerEvent('urp:alert:jailbreak')
                end
            end
        elseif distance3 <= 1.2 then
            if Success2 == true and Success3 == false then
                SendNUIMessage({openSection = "toolSelect", tool = "electricLock", card = "2"})
                DrawMarker(27, 2792.4313964844,1482.4478759766,23.6, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 222, 2, 2, 60, 0, 0, 2, 0, 0, 0, 0)
                if IsControlJustPressed(1, 38) then
                    TriggerEvent("jailbreak:start", "Third")
                    TriggerEvent("Alert:Cops:Grid")
                    TriggerEvent('urp:alert:jailbreak')
                end
            end
        elseif distance4 <= 1.2 then
            if Success3 == true and Success4 == false then
                SendNUIMessage({openSection = "toolSelect", tool = "electricLock", card = "2"})
                DrawMarker(27, 1846.6743164063,2604.7338867188,44.7, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 222, 2, 2, 60, 0, 0, 2, 0, 0, 0, 0)
                if IsControlJustPressed(1, 38) then
                    TriggerEvent("jailbreak:start", "Four")
                    TriggerEvent("Alert:Cops:PrisionBreak")
                    TriggerEvent('urp:alert:jailbreak')
                end
            end
        elseif distance5 <= 1.2 then
            if Success4 == true and Success5 == false then
                SendNUIMessage({openSection = "toolSelect", tool = "electricLock", card = "2"})
                DrawMarker(27, 1820.0710449219,2604.6967773438,44.7, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 222, 2, 2, 60, 0, 0, 2, 0, 0, 0, 0)
                if IsControlJustPressed(1, 38) then
                    TriggerEvent("jailbreak:start", "Five")
                    TriggerEvent("Alert:Cops:PrisionBreak")
                    TriggerEvent('urp:alert:jailbreak')
                end
            end
        else
            SendNUIMessage({openSection = "toolSelect", tool = "", card = ""})
            Citizen.Wait(1000)
        end
      
    end
end)

-- RegisterNetEvent("Alert:Cops:Grid")
-- AddEventHandler("Alert:Cops:Grid", function()
--     local street1 = GetStreetAndZone()
--     local gender = IsPedMale(PlayerPedId())
--     local plyPos = GetEntityCoords(PlayerPedId())
--     TriggerServerEvent("dispatch:svNotify", {
--         dispatchCode = "10-39",
--         dispatchMessage = "Güç Şebekesinde Arıza Tespit Edildi",
--         firstStreet = street1,
--         gender = gender,
--         isImportant = true,
--         priority = 3,
--         blipSprite = 354,
--         blipColor = 46,
--         recipientList = {
--             police = "police"
--         },
--         origin = {
--             x = 2809.6164550781,
--             y = 1547.6730957031,
--             z = 24.533981323242
--         }
--     })
-- end)

-- RegisterNetEvent("Alert:Cops:PrisionBreak")
-- AddEventHandler("Alert:Cops:PrisionBreak", function()
--     local street1 = GetStreetAndZone()
--     local gender = IsPedMale(PlayerPedId())
--     local plyPos = GetEntityCoords(PlayerPedId())
--     TriggerServerEvent("dispatch:svNotify", {
--         dispatchCode = "10-69",
--         dispatchMessage = "Prision Break",
--         firstStreet = street1,
--         gender = gender,
--         isImportant = true,
--         priority = 3,
--         blipSprite = 285,
--         blipColor = 1,
--         recipientList = {
--             police = "police"
--         },
--         origin = {
--             x = 1846.6137695313,
--             y = 2604.6706542969,
--             z = 45.579109191895
--         }
--     })
-- end)


function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 245)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 410
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 133)
end


function GetStreetAndZone()
    local plyPos = GetEntityCoords(PlayerPedId(), true)
    local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local zone = GetLabelText(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
    local street = street1 .. ", " .. zone
    return street
end