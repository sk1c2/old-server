part1 = false
part2 = false
part3 = false
part4 = false
part5 = false
Temperature = 20
Temperature2 = 20

RegisterNetEvent('burgershot:pickup')
AddEventHandler('burgershot:pickup', function()
	TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "burgerjob_counter")
end)

RegisterNetEvent('burgershot:pickup2')
AddEventHandler('burgershot:pickup2', function()
	TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "burgerjob_counter2")
end)

RegisterNetEvent('burgershot:pickup3')
AddEventHandler('burgershot:pickup3', function()
	TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "burgerjob_counter3")
end)

RegisterNetEvent('burgershot:shelf')
AddEventHandler('burgershot:shelf', function()
    local rank = exports["isPed"]:GroupRank("BurgerShot")
    if rank > 0 then
	    TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "burgerjob_shelf")
    end
end)

RegisterNetEvent('burgershot:drinks')
AddEventHandler('burgershot:drinks', function()
    local rank = exports["isPed"]:GroupRank("BurgerShot")
    if rank > 0 then
        FreezeEntityPosition(PlayerPedId(), true)
        exports["wrp-taskbar"]:taskBar(10000,"Preparing Drinks")
        FreezeEntityPosition(PlayerPedId(), false)
	    TriggerEvent("wrp-ac:triggeredItemSpawn", "12", "Craft")
    end
end)

RegisterNetEvent('burgershot:food')
AddEventHandler('burgershot:food', function()
    local rank = exports["isPed"]:GroupRank("BurgerShot")
    if rank > 0 then
        ExecuteCommand('e handshake')
        FreezeEntityPosition(PlayerPedId(), true)
        exports["wrp-taskbar"]:taskBar(10000,"Preparing Food")
        FreezeEntityPosition(PlayerPedId(), false)
	    TriggerEvent("wrp-ac:triggeredItemSpawn", "31", "Craft")
    end
end)

RegisterNetEvent('burgershot:storage')
AddEventHandler('burgershot:storage', function()
    local rank = exports["isPed"]:GroupRank("BurgerShot")
    if rank > 0 then
	    TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "Stolen-Goods")
    end
end)

RegisterNetEvent('burgershot:fries')
AddEventHandler('burgershot:fries', function()
    local job = exports['isPed']:isPed('job')
    if job == 'BurgerShot' then
        FreezeEntityPosition(PlayerPedId(), true)
        exports["wrp-taskbar"]:taskBar(8000,"Frying The Fries")
        FreezeEntityPosition(PlayerPedId(), false)
        if exports['wrp-inventory']:hasEnoughOfItem('potato', 1) then
            TriggerEvent('inventory:removeItem', 'potato', 1)
	        TriggerEvent('wrp-banned:getID', 'fries', 1)
        end
    end
end)


RegisterNetEvent('iatra:openCounter')
AddEventHandler('iatra:openCounter', function()
    TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "bakery_counter")
end)

RegisterNetEvent('iatra:openStorage:shelf')
AddEventHandler('iatra:openStorage:shelf', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
	    TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "bakery_shelf")
    end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

RegisterNetEvent('wrp-obtaindrinkiatria')
AddEventHandler('wrp-obtaindrinkiatria', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['wrp-taskbar']:taskBar(5000, 'Pouring Drinks')
        ClearPedTasks(PlayerPedId())
        TriggerEvent("wrp-ac:triggeredItemSpawn", "513", "Craft")
    end
end)

RegisterNetEvent('wrp-graborder')
AddEventHandler('wrp-graborder', function()
    loadAnimDict('mini@repair')
    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
    exports['wrp-taskbar']:taskBar(5000, 'Grabbing Order')
    ClearPedTasks(PlayerPedId())
    TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "bakery_counter")
end)


RegisterNetEvent('wrp-collectdrink')
AddEventHandler('wrp-collectdrink', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['wrp-taskbar']:taskBar(5000, 'Grabbing Drinks')
        ClearPedTasks(PlayerPedId())
        TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "bakery_drinks")
    end
end)

RegisterNetEvent('wrp-collectbottom')
AddEventHandler('wrp-collectbottom', function()
    loadAnimDict('mini@repair')
    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
    exports['wrp-taskbar']:taskBar(5000, 'Grabbing Order')
    ClearPedTasks(PlayerPedId())
    TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "bakery_counter")
end)

RegisterNetEvent('wrp-bakerystoragemain')
AddEventHandler('wrp-bakerystoragemain', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['wrp-taskbar']:taskBar(5000, 'Accessing Storage')
        ClearPedTasks(PlayerPedId())
        TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "bakery_storage")
    end
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

RegisterNetEvent('wrp-souffle')
AddEventHandler('wrp-souffle', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
                if Temperature < 50 then
                    loadAnimDict('mini@repair')
                    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
                    exports['wrp-taskbar']:taskBar(5000, 'Heating Up Cooker')
                    ClearPedTasks(PlayerPedId())
                    Temperature2 = Temperature2 + 10
                    part1 = true
                else
                    if exports['wrp-inventory']:hasEnoughOfItem('foodingredient', 1) then
                        exports['wrp-taskbar']:taskBar(2500, 'Putting Ingredients Into Cooker..')
                        Citizen.Wait(100)
                        exports['wrp-taskbar']:taskBar(2500, 'Checking Temperature..')
                        Citizen.Wait(100)
                        if Temperature < 50 then
                            TriggerEvent('DoLongHudText', 'You left the Cooker Too Long! Its cold!', 2)
                        else
                            Citizen.Wait(10)
                            exports['wrp-taskbar']:taskBar(2500, 'Mixing Ingredients')
                            Citizen.Wait(100)
                            exports['wrp-taskbar']:taskBar(15000, 'Allowing Ingredients to Set')
                            Citizen.Wait(100)
                            TriggerEvent('DoLongHudText', 'Ingredients have Set!')
                            exports['wrp-taskbar']:taskBar(2500, 'Taking out the Souffle')
                            Citizen.Wait(100)
                            TriggerEvent('wrp-banned:getID', 'souffle', math.random(1,5))
                            TriggerEvent('inventory:removeItem', 'foodingredient', 2)
                        end
                    end
                end
            end
        end)

RegisterNetEvent('wrp-latticepie')
AddEventHandler('wrp-latticepie', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    if Temperature < 50 then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['wrp-taskbar']:taskBar(5000, 'Heating Up Microwave')
        ClearPedTasks(PlayerPedId())
        Temperature = Temperature + 10
        part1 = true
    else
        if exports['wrp-inventory']:hasEnoughOfItem('foodingredient', 1) then
            exports['wrp-taskbar']:taskBar(2500, 'Putting Ingredients Into Microwave..')
            Citizen.Wait(100)
            exports['wrp-taskbar']:taskBar(2500, 'Checking Microwave..')
            Citizen.Wait(100)
            if Temperature < 50 then
                TriggerEvent('DoLongHudText', 'You left the Microwave Too Long! Its cold!', 2)
            else
                Citizen.Wait(10)
                exports['wrp-taskbar']:taskBar(2500, 'Checking Lattice Topped Pie Slice')
                Citizen.Wait(100)
                exports['wrp-taskbar']:taskBar(15000, 'Allowing Pie to Set')
                Citizen.Wait(100)
                TriggerEvent('DoLongHudText', 'Pie has Set!')
                exports['wrp-taskbar']:taskBar(2500, 'Taking out the Pie')
                Citizen.Wait(100)
                TriggerEvent('wrp-banned:getID', 'latticetopped', math.random(1,5))
                TriggerEvent('inventory:removeItem', 'foodingredient', 2)
            end
        end
    end
    end
end)

RegisterNetEvent('wrp-brownie')
AddEventHandler('wrp-brownie', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    if Temperature < 50 then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['wrp-taskbar']:taskBar(5000, 'Heating Up Microwave')
        ClearPedTasks(PlayerPedId())
        Temperature = Temperature + 10
        part1 = true
    else
        if exports['wrp-inventory']:hasEnoughOfItem('foodingredient', 1) then
            exports['wrp-taskbar']:taskBar(2500, 'Putting Ingredients Into Microwave..')
            Citizen.Wait(100)
            exports['wrp-taskbar']:taskBar(2500, 'Checking Microwave..')
            Citizen.Wait(100)
            if Temperature < 50 then
                TriggerEvent('DoLongHudText', 'You left the Microwave Too Long! Its cold!', 2)
            else
                Citizen.Wait(10)
                exports['wrp-taskbar']:taskBar(2500, 'Checking Brownie')
                Citizen.Wait(100)
                exports['wrp-taskbar']:taskBar(15000, 'Allowing Brownie to Set')
                Citizen.Wait(100)
                TriggerEvent('DoLongHudText', 'Brownie has Set!')
                exports['wrp-taskbar']:taskBar(2500, 'Taking out the Brownie')
                Citizen.Wait(100)
                TriggerEvent('wrp-banned:getID', 'brownie', math.random(1,5))
                TriggerEvent('inventory:removeItem', 'foodingredient', 2)
            end
        end
    end
    end
end)

RegisterNetEvent('wrp-doughnut')
AddEventHandler('wrp-doughnut', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    if Temperature < 50 then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['wrp-taskbar']:taskBar(5000, 'Heating Up Microwave')
        ClearPedTasks(PlayerPedId())
        Temperature = Temperature + 10
        part1 = true
    else
        if exports['wrp-inventory']:hasEnoughOfItem('foodingredient', 1) then
            exports['wrp-taskbar']:taskBar(2500, 'Putting Ingredients Into Microwave..')
            Citizen.Wait(100)
            exports['wrp-taskbar']:taskBar(2500, 'Checking Microwave..')
            Citizen.Wait(100)
            if Temperature < 50 then
                TriggerEvent('DoLongHudText', 'You left the Microwave Too Long! Its cold!', 2)
            else
                Citizen.Wait(10)
                exports['wrp-taskbar']:taskBar(2500, 'Checking Glazed Doughnut')
                Citizen.Wait(100)
                exports['wrp-taskbar']:taskBar(15000, 'Allowing Glazed Doughnut to Set')
                Citizen.Wait(100)
                TriggerEvent('DoLongHudText', 'Doughnut has Set!')
                exports['wrp-taskbar']:taskBar(2500, 'Taking out the Doughnut')
                Citizen.Wait(100)
                TriggerEvent('wrp-banned:getID', 'glazingdonut', math.random(1,5))
                TriggerEvent('inventory:removeItem', 'foodingredient', 2)
            end
        end
    end
    end
end)

RegisterNetEvent('wrp-macaroon')
AddEventHandler('wrp-macaroon', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    if Temperature < 50 then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['wrp-taskbar']:taskBar(5000, 'Heating Up Microwave')
        ClearPedTasks(PlayerPedId())
        Temperature = Temperature + 10
        part1 = true
    else
        if exports['wrp-inventory']:hasEnoughOfItem('foodingredient', 1) then
            exports['wrp-taskbar']:taskBar(2500, 'Putting Ingredients Into Microwave..')
            Citizen.Wait(100)
            exports['wrp-taskbar']:taskBar(2500, 'Checking Microwave..')
            Citizen.Wait(100)
            if Temperature < 50 then
                TriggerEvent('DoLongHudText', 'You left the Microwave Too Long! Its cold!', 2)
            else
                Citizen.Wait(10)
                exports['wrp-taskbar']:taskBar(2500, 'Checking Coconut Macaroon')
                Citizen.Wait(100)
                exports['wrp-taskbar']:taskBar(15000, 'Allowing Coconut Macaroon to Set')
                Citizen.Wait(100)
                TriggerEvent('DoLongHudText', 'Macaroon has Set!')
                exports['wrp-taskbar']:taskBar(2500, 'Taking out the Macaroon')
                Citizen.Wait(100)
                TriggerEvent('wrp-banned:getID', 'coconutmaca', math.random(1,5))
                TriggerEvent('inventory:removeItem', 'foodingredient', 2)
            end
        end
    end
    end
end)

RegisterNetEvent('wrp-thumbprintcookie')
AddEventHandler('wrp-thumbprintcookie', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    exports['wrp-taskbar']:taskBar(2000, 'Grabbing Cookie from Refridgerator')
    TriggerEvent('wrp-banned:getID', 'thumbcookie', 1)
    end
end)

RegisterNetEvent('wrp-pretzel')
AddEventHandler('wrp-pretzel', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    exports['wrp-taskbar']:taskBar(2000, 'Grabbing Pretzel from Refridgerator')
    TriggerEvent('wrp-banned:getID', 'pretzel', 1)
    end
end)

RegisterNetEvent('wrp-eclair')
AddEventHandler('wrp-eclair', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    exports['wrp-taskbar']:taskBar(2000, 'Grabbing Eclair from Refridgerator')
    TriggerEvent('wrp-banned:getID', 'eclair', 1)
    end
end)

RegisterNetEvent('wrp-creampuff')
AddEventHandler('wrp-creampuff', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    exports['wrp-taskbar']:taskBar(2000, 'Getting a Cream Puff')
    TriggerEvent('wrp-banned:getID', 'creampuff', 1)
    end
end)

RegisterNetEvent('wrp-strudel')
AddEventHandler('wrp-strudel', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    exports['wrp-taskbar']:taskBar(2000, 'Grabbing a Strudel')
    TriggerEvent('wrp-banned:getID', 'strudel', 1)
    end
end)

RegisterNetEvent('wrp-cinnanomroll')
AddEventHandler('wrp-cinnanomroll', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    if Temperature < 50 then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['wrp-taskbar']:taskBar(5000, 'Heating Up Cooker')
        ClearPedTasks(PlayerPedId())
        Temperature = Temperature + 10
        part1 = true
    else
        if exports['wrp-inventory']:hasEnoughOfItem('foodingredient', 1) then
            exports['wrp-taskbar']:taskBar(2500, 'Putting Ingredients Into Cooker..')
            Citizen.Wait(100)
            exports['wrp-taskbar']:taskBar(2500, 'Checking Cooker..')
            Citizen.Wait(100)
            if Temperature < 50 then
                TriggerEvent('DoLongHudText', 'You left the Cooker Too Long! Its cold!', 2)
            else
                Citizen.Wait(10)
                exports['wrp-taskbar']:taskBar(2500, 'Checking Cinnamon Roll')
                Citizen.Wait(100)
                exports['wrp-taskbar']:taskBar(15000, 'Allowing Cinnamon Roll to Set')
                Citizen.Wait(100)
                TriggerEvent('DoLongHudText', 'Cinnamon Roll has Set!')
                exports['wrp-taskbar']:taskBar(2500, 'Taking out the Cinnamon Roll')
                Citizen.Wait(100)
                TriggerEvent('wrp-banned:getID', 'cinnamonroll', math.random(1,5))
                TriggerEvent('inventory:removeItem', 'foodingredient', 2)
            end
        end
    end
    end
end)

RegisterNetEvent('wrp-raspberryslice')
AddEventHandler('wrp-raspberryslice', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    if Temperature < 50 then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['wrp-taskbar']:taskBar(5000, 'Heating Up Cooker')
        ClearPedTasks(PlayerPedId())
        Temperature = Temperature + 10
        part1 = true
    else
        if exports['wrp-inventory']:hasEnoughOfItem('foodingredient', 1) then
            exports['wrp-taskbar']:taskBar(2500, 'Putting Ingredients Into Cooker..')
            Citizen.Wait(100)
            exports['wrp-taskbar']:taskBar(2500, 'Checking Cooker..')
            Citizen.Wait(100)
            if Temperature < 50 then
                TriggerEvent('DoLongHudText', 'You left the Cooker Too Long! Its cold!', 2)
            else
                Citizen.Wait(10)
                exports['wrp-taskbar']:taskBar(2500, 'Checking Raspberry Slice')
                Citizen.Wait(100)
                exports['wrp-taskbar']:taskBar(15000, 'Allowing Raspberry Slice to Set')
                Citizen.Wait(100)
                TriggerEvent('DoLongHudText', 'Raspberry Slice has Set!')
                exports['wrp-taskbar']:taskBar(2500, 'Taking out the Roulade Roll')
                Citizen.Wait(100)
                TriggerEvent('wrp-banned:getID', 'rasberryrouladeslice', math.random(1,5))
                TriggerEvent('inventory:removeItem', 'foodingredient', 2)
            end
        end
    end
    end
end)

RegisterNetEvent('urp:churchin')
AddEventHandler('urp:churchin', function()
	local Getmecuh = PlayerPedId()
	DoScreenFadeOut(400)
	Citizen.Wait(500)
	SetEntityCoords(Getmecuh, -785.55, -13.86, -16.77)
	Citizen.Wait(250)
	DoScreenFadeIn(250)
end)

RegisterNetEvent('urp:churchout')
AddEventHandler('urp:churchout', function()
	local Getmecuh = PlayerPedId()
	DoScreenFadeOut(400)
	Citizen.Wait(500)
	SetEntityCoords(Getmecuh, -767.02, -23.19, 41.08)
	Citizen.Wait(250)
	DoScreenFadeIn(250)
end)

RegisterNetEvent('skyhigh:crafting')
AddEventHandler('skyhigh:crafting', function()
    local PlayerPed = PlayerPedId(-1)
    if exports['isPed']:isPed('job') == 'SkyHighEnterprise' then
        TriggerEvent("wrp-ac:triggeredItemSpawn", "6969", "Craft")
    end
end)