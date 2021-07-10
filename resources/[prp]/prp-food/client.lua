part1 = false
part2 = false
part3 = false
part4 = false
part5 = false
Temperature = 20
Temperature2 = 20

RegisterNetEvent('burgershot:pickup')
AddEventHandler('burgershot:pickup', function()
	TriggerEvent("prp-ac:triggeredItemSpawn", "1", "burgerjob_counter")
end)

RegisterNetEvent('burgershot:pickup2')
AddEventHandler('burgershot:pickup2', function()
	TriggerEvent("prp-ac:triggeredItemSpawn", "1", "burgerjob_counter2")
end)

RegisterNetEvent('burgershot:pickup3')
AddEventHandler('burgershot:pickup3', function()
	TriggerEvent("prp-ac:triggeredItemSpawn", "1", "burgerjob_counter3")
end)

RegisterNetEvent('burgershot:shelf')
AddEventHandler('burgershot:shelf', function()
    local rank = exports["isPed"]:GroupRank("BurgerShot")
    if rank > 0 then
	    TriggerEvent("prp-ac:triggeredItemSpawn", "1", "burgerjob_shelf")
    end
end)

RegisterNetEvent('burgershot:fridge')
AddEventHandler('burgershot:fridge', function()
    local rank = exports["isPed"]:GroupRank("BurgerShot")
    if rank > 0 then
	    TriggerEvent("prp-ac:triggeredItemSpawn", "1", "burgerjob_fridge")
    end
end)

RegisterNetEvent('burgershot:drinks')
AddEventHandler('burgershot:drinks', function()
    local rank = exports["isPed"]:GroupRank("BurgerShot")
    if rank > 0 then
        FreezeEntityPosition(PlayerPedId(), true)
        exports["prp-taskbar"]:taskBar(10000,"Preparing Drinks")
        FreezeEntityPosition(PlayerPedId(), false)
	    TriggerEvent("prp-ac:triggeredItemSpawn", "12", "Craft")
    end
end)

RegisterNetEvent('burgershot:food')
AddEventHandler('burgershot:food', function()
    local rank = exports["isPed"]:GroupRank("BurgerShot")
    if rank > 0 then
        ExecuteCommand('e handshake')
        FreezeEntityPosition(PlayerPedId(), true)
        exports["prp-taskbar"]:taskBar(10000,"Preparing Food")
        FreezeEntityPosition(PlayerPedId(), false)
	    TriggerEvent("prp-ac:triggeredItemSpawn", "31", "Craft")
    end
end)

RegisterNetEvent('burgershot:storage')
AddEventHandler('burgershot:storage', function()
    local rank = exports["isPed"]:GroupRank("BurgerShot")
    if rank > 0 then
	    TriggerEvent("prp-ac:triggeredItemSpawn", "1", "Stolen-Goods")
    end
end)

RegisterNetEvent('burgershot:fries')
AddEventHandler('burgershot:fries', function()
    local job = exports['isPed']:isPed('job')
    if job == 'BurgerShot' then
        FreezeEntityPosition(PlayerPedId(), true)
        exports["prp-taskbar"]:taskBar(8000,"Frying The Fries")
        FreezeEntityPosition(PlayerPedId(), false)
        if exports['prp-inventory']:hasEnoughOfItem('potato', 1) then
            TriggerEvent('inventory:removeItem', 'potato', 1)
	        TriggerEvent('prp-banned:getID', 'fries', 1)
        end
    end
end)


RegisterNetEvent('iatra:openCounter')
AddEventHandler('iatra:openCounter', function()
    TriggerEvent("prp-ac:triggeredItemSpawn", "1", "bakery_counter")
end)

RegisterNetEvent('iatra:openStorage:shelf')
AddEventHandler('iatra:openStorage:shelf', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
	    TriggerEvent("prp-ac:triggeredItemSpawn", "1", "bakery_shelf")
    end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

RegisterNetEvent('prp-obtaindrinkiatria')
AddEventHandler('prp-obtaindrinkiatria', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['prp-taskbar']:taskBar(5000, 'Pouring Drinks')
        ClearPedTasks(PlayerPedId())
        TriggerEvent("prp-ac:triggeredItemSpawn", "513", "Craft")
    end
end)

RegisterNetEvent('prp-graborder')
AddEventHandler('prp-graborder', function()
    loadAnimDict('mini@repair')
    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
    exports['prp-taskbar']:taskBar(5000, 'Grabbing Order')
    ClearPedTasks(PlayerPedId())
    TriggerEvent("prp-ac:triggeredItemSpawn", "1", "bakery_counter")
end)


RegisterNetEvent('prp-collectdrink')
AddEventHandler('prp-collectdrink', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['prp-taskbar']:taskBar(5000, 'Grabbing Drinks')
        ClearPedTasks(PlayerPedId())
        TriggerEvent("prp-ac:triggeredItemSpawn", "1", "bakery_drinks")
    end
end)

RegisterNetEvent('prp-collectbottom')
AddEventHandler('prp-collectbottom', function()
    loadAnimDict('mini@repair')
    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
    exports['prp-taskbar']:taskBar(5000, 'Grabbing Order')
    ClearPedTasks(PlayerPedId())
    TriggerEvent("prp-ac:triggeredItemSpawn", "1", "bakery_counter")
end)

RegisterNetEvent('prp-bakerystoragemain')
AddEventHandler('prp-bakerystoragemain', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['prp-taskbar']:taskBar(5000, 'Accessing Storage')
        ClearPedTasks(PlayerPedId())
        TriggerEvent("prp-ac:triggeredItemSpawn", "1", "bakery_storage")
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

RegisterNetEvent('prp-souffle')
AddEventHandler('prp-souffle', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
                if Temperature < 50 then
                    loadAnimDict('mini@repair')
                    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
                    exports['prp-taskbar']:taskBar(5000, 'Heating Up Cooker')
                    ClearPedTasks(PlayerPedId())
                    Temperature2 = Temperature2 + 10
                    part1 = true
                else
                    if exports['prp-inventory']:hasEnoughOfItem('foodingredient', 1) then
                        exports['prp-taskbar']:taskBar(2500, 'Putting Ingredients Into Cooker..')
                        Citizen.Wait(100)
                        exports['prp-taskbar']:taskBar(2500, 'Checking Temperature..')
                        Citizen.Wait(100)
                        if Temperature < 50 then
                            TriggerEvent('DoLongHudText', 'You left the Cooker Too Long! Its cold!', 2)
                        else
                            Citizen.Wait(10)
                            exports['prp-taskbar']:taskBar(2500, 'Mixing Ingredients')
                            Citizen.Wait(100)
                            exports['prp-taskbar']:taskBar(15000, 'Allowing Ingredients to Set')
                            Citizen.Wait(100)
                            TriggerEvent('DoLongHudText', 'Ingredients have Set!')
                            exports['prp-taskbar']:taskBar(2500, 'Taking out the Souffle')
                            Citizen.Wait(100)
                            TriggerEvent('prp-banned:getID', 'souffle', math.random(1,5))
                            TriggerEvent('inventory:removeItem', 'foodingredient', 2)
                        end
                    end
                end
            end
        end)

RegisterNetEvent('prp-latticepie')
AddEventHandler('prp-latticepie', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    if Temperature < 50 then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['prp-taskbar']:taskBar(5000, 'Heating Up Microwave')
        ClearPedTasks(PlayerPedId())
        Temperature = Temperature + 10
        part1 = true
    else
        if exports['prp-inventory']:hasEnoughOfItem('foodingredient', 1) then
            exports['prp-taskbar']:taskBar(2500, 'Putting Ingredients Into Microwave..')
            Citizen.Wait(100)
            exports['prp-taskbar']:taskBar(2500, 'Checking Microwave..')
            Citizen.Wait(100)
            if Temperature < 50 then
                TriggerEvent('DoLongHudText', 'You left the Microwave Too Long! Its cold!', 2)
            else
                Citizen.Wait(10)
                exports['prp-taskbar']:taskBar(2500, 'Checking Lattice Topped Pie Slice')
                Citizen.Wait(100)
                exports['prp-taskbar']:taskBar(15000, 'Allowing Pie to Set')
                Citizen.Wait(100)
                TriggerEvent('DoLongHudText', 'Pie has Set!')
                exports['prp-taskbar']:taskBar(2500, 'Taking out the Pie')
                Citizen.Wait(100)
                TriggerEvent('prp-banned:getID', 'latticetopped', math.random(1,5))
                TriggerEvent('inventory:removeItem', 'foodingredient', 2)
            end
        end
    end
    end
end)

RegisterNetEvent('prp-brownie')
AddEventHandler('prp-brownie', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    if Temperature < 50 then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['prp-taskbar']:taskBar(5000, 'Heating Up Microwave')
        ClearPedTasks(PlayerPedId())
        Temperature = Temperature + 10
        part1 = true
    else
        if exports['prp-inventory']:hasEnoughOfItem('foodingredient', 1) then
            exports['prp-taskbar']:taskBar(2500, 'Putting Ingredients Into Microwave..')
            Citizen.Wait(100)
            exports['prp-taskbar']:taskBar(2500, 'Checking Microwave..')
            Citizen.Wait(100)
            if Temperature < 50 then
                TriggerEvent('DoLongHudText', 'You left the Microwave Too Long! Its cold!', 2)
            else
                Citizen.Wait(10)
                exports['prp-taskbar']:taskBar(2500, 'Checking Brownie')
                Citizen.Wait(100)
                exports['prp-taskbar']:taskBar(15000, 'Allowing Brownie to Set')
                Citizen.Wait(100)
                TriggerEvent('DoLongHudText', 'Brownie has Set!')
                exports['prp-taskbar']:taskBar(2500, 'Taking out the Brownie')
                Citizen.Wait(100)
                TriggerEvent('prp-banned:getID', 'brownie', math.random(1,5))
                TriggerEvent('inventory:removeItem', 'foodingredient', 2)
            end
        end
    end
    end
end)

RegisterNetEvent('prp-doughnut')
AddEventHandler('prp-doughnut', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    if Temperature < 50 then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['prp-taskbar']:taskBar(5000, 'Heating Up Microwave')
        ClearPedTasks(PlayerPedId())
        Temperature = Temperature + 10
        part1 = true
    else
        if exports['prp-inventory']:hasEnoughOfItem('foodingredient', 1) then
            exports['prp-taskbar']:taskBar(2500, 'Putting Ingredients Into Microwave..')
            Citizen.Wait(100)
            exports['prp-taskbar']:taskBar(2500, 'Checking Microwave..')
            Citizen.Wait(100)
            if Temperature < 50 then
                TriggerEvent('DoLongHudText', 'You left the Microwave Too Long! Its cold!', 2)
            else
                Citizen.Wait(10)
                exports['prp-taskbar']:taskBar(2500, 'Checking Glazed Doughnut')
                Citizen.Wait(100)
                exports['prp-taskbar']:taskBar(15000, 'Allowing Glazed Doughnut to Set')
                Citizen.Wait(100)
                TriggerEvent('DoLongHudText', 'Doughnut has Set!')
                exports['prp-taskbar']:taskBar(2500, 'Taking out the Doughnut')
                Citizen.Wait(100)
                TriggerEvent('prp-banned:getID', 'glazingdonut', math.random(1,5))
                TriggerEvent('inventory:removeItem', 'foodingredient', 2)
            end
        end
    end
    end
end)

RegisterNetEvent('prp-macaroon')
AddEventHandler('prp-macaroon', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    if Temperature < 50 then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['prp-taskbar']:taskBar(5000, 'Heating Up Microwave')
        ClearPedTasks(PlayerPedId())
        Temperature = Temperature + 10
        part1 = true
    else
        if exports['prp-inventory']:hasEnoughOfItem('foodingredient', 1) then
            exports['prp-taskbar']:taskBar(2500, 'Putting Ingredients Into Microwave..')
            Citizen.Wait(100)
            exports['prp-taskbar']:taskBar(2500, 'Checking Microwave..')
            Citizen.Wait(100)
            if Temperature < 50 then
                TriggerEvent('DoLongHudText', 'You left the Microwave Too Long! Its cold!', 2)
            else
                Citizen.Wait(10)
                exports['prp-taskbar']:taskBar(2500, 'Checking Coconut Macaroon')
                Citizen.Wait(100)
                exports['prp-taskbar']:taskBar(15000, 'Allowing Coconut Macaroon to Set')
                Citizen.Wait(100)
                TriggerEvent('DoLongHudText', 'Macaroon has Set!')
                exports['prp-taskbar']:taskBar(2500, 'Taking out the Macaroon')
                Citizen.Wait(100)
                TriggerEvent('prp-banned:getID', 'coconutmaca', math.random(1,5))
                TriggerEvent('inventory:removeItem', 'foodingredient', 2)
            end
        end
    end
    end
end)

RegisterNetEvent('prp-thumbprintcookie')
AddEventHandler('prp-thumbprintcookie', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    exports['prp-taskbar']:taskBar(2000, 'Grabbing Cookie from Refridgerator')
    TriggerEvent('prp-banned:getID', 'thumbcookie', 1)
    end
end)

RegisterNetEvent('prp-pretzel')
AddEventHandler('prp-pretzel', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    exports['prp-taskbar']:taskBar(2000, 'Grabbing Pretzel from Refridgerator')
    TriggerEvent('prp-banned:getID', 'pretzel', 1)
    end
end)

RegisterNetEvent('prp-eclair')
AddEventHandler('prp-eclair', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    exports['prp-taskbar']:taskBar(2000, 'Grabbing Eclair from Refridgerator')
    TriggerEvent('prp-banned:getID', 'eclair', 1)
    end
end)

RegisterNetEvent('prp-creampuff')
AddEventHandler('prp-creampuff', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    exports['prp-taskbar']:taskBar(2000, 'Getting a Cream Puff')
    TriggerEvent('prp-banned:getID', 'creampuff', 1)
    end
end)

RegisterNetEvent('prp-strudel')
AddEventHandler('prp-strudel', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    exports['prp-taskbar']:taskBar(2000, 'Grabbing a Strudel')
    TriggerEvent('prp-banned:getID', 'strudel', 1)
    end
end)

RegisterNetEvent('prp-cinnanomroll')
AddEventHandler('prp-cinnanomroll', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    if Temperature < 50 then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['prp-taskbar']:taskBar(5000, 'Heating Up Cooker')
        ClearPedTasks(PlayerPedId())
        Temperature = Temperature + 10
        part1 = true
    else
        if exports['prp-inventory']:hasEnoughOfItem('foodingredient', 1) then
            exports['prp-taskbar']:taskBar(2500, 'Putting Ingredients Into Cooker..')
            Citizen.Wait(100)
            exports['prp-taskbar']:taskBar(2500, 'Checking Cooker..')
            Citizen.Wait(100)
            if Temperature < 50 then
                TriggerEvent('DoLongHudText', 'You left the Cooker Too Long! Its cold!', 2)
            else
                Citizen.Wait(10)
                exports['prp-taskbar']:taskBar(2500, 'Checking Cinnamon Roll')
                Citizen.Wait(100)
                exports['prp-taskbar']:taskBar(15000, 'Allowing Cinnamon Roll to Set')
                Citizen.Wait(100)
                TriggerEvent('DoLongHudText', 'Cinnamon Roll has Set!')
                exports['prp-taskbar']:taskBar(2500, 'Taking out the Cinnamon Roll')
                Citizen.Wait(100)
                TriggerEvent('prp-banned:getID', 'cinnamonroll', math.random(1,5))
                TriggerEvent('inventory:removeItem', 'foodingredient', 2)
            end
        end
    end
    end
end)

RegisterNetEvent('prp-raspberryslice')
AddEventHandler('prp-raspberryslice', function()
    local job = exports['isPed']:isPed('job')
    if job == 'Bakery' then
    if Temperature < 50 then
        loadAnimDict('mini@repair')
        TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        exports['prp-taskbar']:taskBar(5000, 'Heating Up Cooker')
        ClearPedTasks(PlayerPedId())
        Temperature = Temperature + 10
        part1 = true
    else
        if exports['prp-inventory']:hasEnoughOfItem('foodingredient', 1) then
            exports['prp-taskbar']:taskBar(2500, 'Putting Ingredients Into Cooker..')
            Citizen.Wait(100)
            exports['prp-taskbar']:taskBar(2500, 'Checking Cooker..')
            Citizen.Wait(100)
            if Temperature < 50 then
                TriggerEvent('DoLongHudText', 'You left the Cooker Too Long! Its cold!', 2)
            else
                Citizen.Wait(10)
                exports['prp-taskbar']:taskBar(2500, 'Checking Raspberry Slice')
                Citizen.Wait(100)
                exports['prp-taskbar']:taskBar(15000, 'Allowing Raspberry Slice to Set')
                Citizen.Wait(100)
                TriggerEvent('DoLongHudText', 'Raspberry Slice has Set!')
                exports['prp-taskbar']:taskBar(2500, 'Taking out the Roulade Roll')
                Citizen.Wait(100)
                TriggerEvent('prp-banned:getID', 'rasberryrouladeslice', math.random(1,5))
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
        TriggerEvent("prp-ac:triggeredItemSpawn", "6969", "Craft")
    end
end)

RegisterNetEvent('keys:get')
AddEventHandler('keys:get', function()
    local PlayerPed = PlayerPedId(-1)
    if exports['isPed']:isPed('job') == 'Police' then
        if exports['prp-inventory']:hasEnoughOfItem('pdkeyfob', 1) then
        TriggerEvent('DoLongHudText', 'You allready have a keyfob Dingus!', 2)
        else
            TriggerEvent('prp-banned:getID', 'pdkeyfob', 1)
        end
    end
end)