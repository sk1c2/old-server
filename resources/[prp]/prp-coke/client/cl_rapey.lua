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
            if exports['wrp-inventory']:hasEnoughOfItem('coke50g', 1) then
                Citizen.Wait(10)
                exports['wrp-interaction']:showInteraction('[E] Bag Cocaine | [F] Create Crack')
                if IsControlJustReleased(0, 38) then
                    if exports['wrp-inventory']:hasEnoughOfItem('drugscales', 1) then
                        ProcessingCocaine = true
                        local lPed = PlayerPedId()
            
                        RequestAnimDict("mini@repair")
                        while not HasAnimDictLoaded("mini@repair") do
                            Citizen.Wait(100)
                        end
                        ClearPedSecondaryTask(lPed)
                        TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
                        exports['wrp-taskbar']:taskBar(10000, 'Packaging Cocaine.')
                        if exports['wrp-inventory']:hasEnoughOfItem('coke50g', 1) then
                            local amount = exports['wrp-inventory']:getQuantity('coke50g')
                            if exports['wrp-inventory']:hasEnoughOfItem('dopebag', math.ceil(amount*5)) then
                                local amount = exports['wrp-inventory']:getQuantity('coke50g')
                                TriggerEvent('DoLongHudText', 'Cocaine Packaged!')
                                TriggerEvent("inventory:removeItem", 'coke50g', amount)
                                TriggerEvent('inventory:removeItem', 'dopebag', math.ceil(amount*5))
                                local luck = math.random(1,3)
                                if luck == 3 then
                                    TriggerEvent('inventory:removeItem', 'drugscales', 1)
                                end
                                local baggiedcoke = amount * 5
                                TriggerEvent('wrp-banned:getID', 'coke5g', baggiedcoke)
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
                        exports['wrp-taskbar']:taskBar(10000, 'Preparing Crack.')
                        if exports['wrp-inventory']:hasEnoughOfItem('coke50g', 1) then
                            local amount = exports['wrp-inventory']:getQuantity('coke50g')
                            if exports['wrp-inventory']:hasEnoughOfItem('dopebag', math.ceil(amount*8)) then
                                if exports['wrp-inventory']:hasEnoughOfItem('bakingsoda', 1) then
                                    local amount = exports['wrp-inventory']:getQuantity('coke50g')
                                    TriggerEvent('DoLongHudText', 'Crack Successfully Prepared!')
                                    TriggerEvent('inventory:removeItem', 'coke50g', amount)
                                    TriggerEvent('inventory:removeItem', 'dopebag', math.ceil(amount*8))
                                    local luck = math.random(1,3)
                                    if luck == 3 then
                                        TriggerEvent('inventory:removeItem', 'drugscales', 1)
                                    end
                                    local crack = amount * 8
                                    TriggerEvent('wrp-banned:getID', '1gcrack', crack)
                                    ProcessingCocaine = false
                                    Citizen.Wait(10000)
                                end
                            end
                        end
                    end
                end
            end
        elseif distance < 200 and not ProcessingCocaine then
            exports['wrp-interaction']:hideInteraction()
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

RegisterNetEvent('wrp-snow:inrangeMate')
AddEventHandler('wrp-snow:inrangeMate', function(player)
    exports['wrp-interaction']:showInteraction('[E] Process Cocaine.')
end)