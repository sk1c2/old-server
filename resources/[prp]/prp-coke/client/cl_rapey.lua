ProcessingCocaine = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local Getmecuh = PlayerPedId()
        local x,y,z = 1945.779, 5180.074, 47.98377
        local drawtext = "[E] Process Cocaine"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 1.2 then
            Citizen.Wait(100)
            if exports['prp-inventory']:hasEnoughOfItem('coke50g', 1) then
                Citizen.Wait(10)
                exports['prp-interaction']:showInteraction('[E] Bag Cocaine | [F] Create Crack')
                if IsControlJustReleased(0, 38) then
                    if exports['prp-inventory']:hasEnoughOfItem('drugscales', 1) then
                        ProcessingCocaine = true
                        local lPed = PlayerPedId()
            
                        RequestAnimDict("mini@repair")
                        while not HasAnimDictLoaded("mini@repair") do
                            Citizen.Wait(100)
                        end
                        ClearPedSecondaryTask(lPed)
                        TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
                        exports['prp-taskbar']:taskBar(10000, 'Packaging Cocaine.')
                        if exports['prp-inventory']:hasEnoughOfItem('coke50g', 1) then
                            local amount = exports['prp-inventory']:getQuantity('coke50g')
                            if exports['prp-inventory']:hasEnoughOfItem('dopebag', math.ceil(amount*5)) then
                                local amount = exports['prp-inventory']:getQuantity('coke50g')
                                TriggerEvent('DoLongHudText', 'Cocaine Packaged!')
                                TriggerEvent("inventory:removeItem", 'coke50g', amount)
                                TriggerEvent('inventory:removeItem', 'dopebag', math.ceil(amount*5))
                                local luck = math.random(1,3)
                                if luck == 3 then
                                    TriggerEvent('inventory:removeItem', 'drugscales', 1)
                                end
                                local baggiedcoke = amount * 5
                                TriggerEvent('prp-banned:getID', 'coke5g', baggiedcoke)
                                ProcessingCocaine = false
                                Citizen.Wait(10000)
                            end
                        end
                    end
                    if IsControlJustPressed(0, 23) then
                        ProcessingCocaine = true
                        local lPed = PlayerPedId()
            
                        RequestAnimDict("mini@repair")
                        while not HasAnimDictLoaded("mini@repair") do
                            Citizen.Wait(100)
                        end
                        ClearPedSecondaryTask(lPed)
                        TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
                        exports['prp-taskbar']:taskBar(10000, 'Preparing Crack.')
                        if exports['prp-inventory']:hasEnoughOfItem('coke50g', 1) then
                            local amount = exports['prp-inventory']:getQuantity('coke50g')
                            if exports['prp-inventory']:hasEnoughOfItem('dopebag', math.ceil(amount*8)) then
                                if exports['prp-inventory']:hasEnoughOfItem('bakingsoda', 1) then
                                    local amount = exports['prp-inventory']:getQuantity('coke50g')
                                    TriggerEvent('DoLongHudText', 'Crack Successfully Prepared!')
                                    TriggerEvent('inventory:removeItem', 'coke50g', amount)
                                    TriggerEvent('inventory:removeItem', 'dopebag', math.ceil(amount*8))
                                    local luck = math.random(1,3)
                                    if luck == 3 then
                                        TriggerEvent('inventory:removeItem', 'drugscales', 1)
                                    end
                                    local crack = amount * 8
                                    TriggerEvent('prp-banned:getID', '1gcrack', crack)
                                    ProcessingCocaine = false
                                    Citizen.Wait(10000)
                                end
                            end
                        end
                    end
                end
            end
        elseif distance < 200 and not ProcessingCocaine then
            exports['prp-interaction']:hideInteraction()
            Citizen.Wait(10000)
        end
    end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

RegisterNetEvent('prp-snow:inrangeMate')
AddEventHandler('prp-snow:inrangeMate', function(player)
    exports['prp-interaction']:showInteraction('[E] Process Cocaine.')
end)