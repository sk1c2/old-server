local fixingvehicle = false
local justUsed = false
local retardCounter = 0
local lastCounter = 0 
local HeadBone = 0x796e;
job = nil
local wheelChair = nil

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5000)
    	job = exports['isPed']:isPed('job')
	end
end)

-- local jailBounds = PolyZone:Create({
--   vector2(1855.8966064453, 2701.9802246094),
--   vector2(1775.4013671875, 2770.5339355469),
--   vector2(1646.7535400391, 2765.9870605469),
--   vector2(1562.7836914063, 2686.6459960938),
--   vector2(1525.3662109375, 2586.5190429688),
--   vector2(1533.7038574219, 2465.5300292969),
--   vector2(1657.5997314453, 2386.9389648438),
--   vector2(1765.8286132813, 2404.4763183594),
--   vector2(1830.1740722656, 2472.1193847656),
--   vector2(1855.7557373047, 2569.0361328125)
-- }, {
--     name = "jail_bounds",
--     minZ = 30,
--     maxZ = 70.5,
--     debugGrid = false,
--     gridDivisions = 25
-- })

local validWaterItem = {
    ["oxygentank"] = true,
    ["water"] = true,
    ["vodka"] = true,
    ["beer"] = true,
    ["whiskey"] = true,
    ["coffee"] = true,
    ["fishtaco"] = true,
    ["taco"] = true,
    ["burrito"] = true,
    ["churro"] = true,
    ["hotdog"] = true,
    ["greencow"] = true,
    ["donut"] = true,
    ["eggsbacon"] = true,
    ["icecream"] = true,
    ["mshake"] = true,
    ["sandwich"] = true,
    ["hamburger"] = true,
    ["cola"] = true,
    ["jailfood"] = true,
    ["bleederburger"] = true,
    ["heartstopper"] = true,
    ["torpedo"] = true,
    ["meatfree"] = true,
    ["moneyshot"] = true,
    ["fries"] = true,
    ["slushy"] = true,
    ['softdrink'] = true,
    ['bscoffee'] = true,

}



Citizen.CreateThread(function()

    
    TriggerServerEvent("inv:playerSpawned");
end)


Citizen.CreateThread(function()
    while true do 
     Citizen.Wait(10)
     if IsControlJustPressed(0, 311) then 
        if not exports['prp-deathmanager']:GetDeath() then
            TriggerEvent("OpenInv")
        else
            TriggerEvent('DoLongHudText', 'Stop trying to open your pockets when dead!')
        end
      end
    end
end)
RegisterNetEvent('inventory:bandage')
AddEventHandler('inventory:bandage', function()
    TriggerEvent('HealSlow')
    -- TriggerEvent('prp-hospital:client:UsePainKiller', 1)
    TriggerEvent('prp-hospital:client:RemoveBleed')
end)

RegisterNetEvent('HealSlow')
AddEventHandler("HealSlow", function()
    local player = PlayerPedId()
    for i = 1, 30 do

        if GetEntityHealth(player) >= 200 then
            break
        end
        
        SetEntityHealth(player, GetEntityHealth(player) + 1)
        Citizen.Wait(math.random(500, 1000))
    end
end)

local applying = false
RegisterNetEvent('ApplyArmor')
AddEventHandler('ApplyArmor', function()
    -- print("triggering")
    while applying == true do
        Citizen.Wait(0)
        -- print("triggering2")
        SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
    end
end)

RegisterNetEvent('hadcocaine')
AddEventHandler('hadcocaine', function(arg1,arg2,arg3)
    dstamina = 0

	if math.random(100) > 50 then
		Drugs1()
	else
		Drugs2()
    end

	SetRunSprintMultiplierForPlayer(PlayerId(), 1.1)
	dstamina = 200

    while dstamina > 0 do

        Citizen.Wait(1000)
        RestorePlayerStamina(PlayerId(), 1.0)
        dstamina = dstamina - 1

        if IsPedRagdoll(PlayerPedId()) then
            SetPedToRagdoll(PlayerPedId(), math.random(5), math.random(5), 3, 0, 0, 0)
        end

        local armor = GetPedArmour(PlayerPedId())
        if armor >= 80 then
            return
        end
        SetPedArmour(PlayerPedId(),armor+3)

	  	if math.random(500) < 3 then
	  		if math.random(100) > 50 then
	  			Drugs1()
	  		else
	  			Drugs2()
	  		end
		  	Citizen.Wait(math.random(30000))
		end

        if math.random(100) > 91 and IsPedRunning(PlayerPedId()) then
            SetPedToRagdoll(PlayerPedId(), math.random(1000), math.random(1000), 3, 0, 0, 0)
        end
        
    end

    dstamina = 0

    if IsPedRunning(PlayerPedId()) then
        SetPedToRagdoll(PlayerPedId(),1000,1000, 3, 0, 0, 0)
    end

    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)

end)

RegisterNetEvent('hadcrack')
AddEventHandler('hadcrack', function(arg1,arg2,arg3)
    dstamina = 0
    Citizen.Wait(1000)

	if math.random(100) > 50 then
		Drugs1()
	else
		Drugs2()
	end
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.35)
	dstamina = 30

    while dstamina > 0 do

        Citizen.Wait(1000)
        RestorePlayerStamina(PlayerId(), 1.0)
        dstamina = dstamina - 1

        if IsPedRagdoll(PlayerPedId()) then
            SetPedToRagdoll(PlayerPedId(), math.random(5), math.random(5), 3, 0, 0, 0)
        end

	  	if math.random(500) < 100 then
	  		if math.random(100) > 50 then
	  			Drugs1()
	  		else
	  			Drugs2()
	  		end
		  	Citizen.Wait(math.random(30000))
		end

        if math.random(100) > 91 and IsPedRunning(PlayerPedId()) then
            SetPedToRagdoll(PlayerPedId(), math.random(1000), math.random(1000), 3, 0, 0, 0)
        end
        
    end

    dstamina = 0

    if IsPedRunning(PlayerPedId()) then
        SetPedToRagdoll(PlayerPedId(),6000,6000, 3, 0, 0, 0)
    end

    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)

end)
 
-- DRUG FUNCS
function Drugs1()
	StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
	Citizen.Wait(5000)
	SetPedMoveRateOverride(PlayerId(), 10.0)
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
	StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
	Citizen.Wait(8000)
	StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
	Citizen.Wait(12000)
	StopScreenEffect("DrugsMichaelAliensFightIn")
	StopScreenEffect("DrugsMichaelAliensFight")
	StopScreenEffect("DrugsMichaelAliensFightOut")

end

function Drugs2()
	StartScreenEffect("DrugsTrevorClownsFightIn", 3.0, 0)
	StartScreenEffect("DrugsTrevorClownsFight", 3.0, 0)
	Citizen.Wait(8000)
	StartScreenEffect("DrugsTrevorClownsFightOut", 3.0, 0)
	Citizen.Wait(8000)
	SetPedMoveRateOverride(PlayerId(), 0.0)
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
	Citizen.Wait(100000)
	StopScreenEffect("DrugsTrevorClownsFight")
	StopScreenEffect("DrugsTrevorClownsFightIn")
	StopScreenEffect("DrugsTrevorClownsFightOut")
end

-- RegisterNetEvent('inventory-jail')
-- AddEventHandler('inventory-jail', function(startPosition, cid, name)
--     if (hasEnoughOfItem("okaylockpick",1,false)) then
--         local plyPed = PlayerPedId()
--         local coord = GetPedBoneCoords(plyPed, HeadBone)
--         local inPoly = jailBounds:isPointInside(coord)
--         if inPoly  then
--              TriggerServerEvent("prp-ac:triggeredItemSpawn", startPosition, cid, "1", name);
--         end
--     end
-- end)

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then

		for index,value in ipairs(players) do
			local target = GetPlayerPed(value)
			if(target ~= ply) then
				local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
				local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
				if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
					closestPlayer = value
					closestDistance = distance
				end
			end
		end
		
		return closestPlayer, closestDistance

	else
		TriggerEvent("DoLongHudText","Inside Vehicle.",2)
	end

end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

RegisterNetEvent('prp-stealtrigger')
AddEventHandler('prp-stealtrigger', function()
    local cid = exports["isPed"]:isPed("cid")
    local closestPlayer, closestDistance = GetClosestPlayer()
    loadAnimDict("random@shop_robbery")
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TaskPlayAnim(PlayerPedId(-1), "random@shop_robbery", "robbery_action_b", 8.0, -8, -1, 16, 0, 0, 0, 0)
        if ( IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "dead", "dead_a", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "amb@code_human_cower_stand@male@base", "base", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "amb@code_human_cower@male@base", "base", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "random@arrests@busted", "idle_a", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "mp_arresting", "idle", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "random@mugging3", "handsup_standing_base", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missfbi5ig_22", "hands_up_anxious_scientist", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missfbi5ig_22", "hands_up_loop_scientist", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missminuteman_1ig_2", "handsup_base", 3) ) then
            if IsPedArmed(GetPlayerPed(-1), 7) then
                local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                local finished = exports["prp-taskbar"]:taskBar(3000,"Robbing",false,false,playerVeh)
                if (finished == 100) then
                    TriggerServerEvent('prp-inventory:openInventorySteal', GetPlayerServerId(closestPlayer))
                    ClearPedTasks(GetPlayerPed(-1))
                end
            end
        end
    else
        TriggerEvent("DoLongHudText", "Too far", 2)
    end
end)

RegisterCommand('steal', function()
    local cid = exports["isPed"]:isPed("cid")
    local closestPlayer, closestDistance = GetClosestPlayer()
    loadAnimDict("random@shop_robbery")
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TaskPlayAnim(PlayerPedId(-1), "random@shop_robbery", "robbery_action_b", 8.0, -8, -1, 16, 0, 0, 0, 0)
        if ( IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "dead", "dead_a", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "amb@code_human_cower_stand@male@base", "base", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "amb@code_human_cower@male@base", "base", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "random@arrests@busted", "idle_a", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "mp_arresting", "idle", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "random@mugging3", "handsup_standing_base", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missfbi5ig_22", "hands_up_anxious_scientist", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missfbi5ig_22", "hands_up_loop_scientist", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missminuteman_1ig_2", "handsup_base", 3) ) then
            if IsPedArmed(GetPlayerPed(-1), 7) then
                local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                local finished = exports["prp-taskbar"]:taskBar(3000,"Robbing",false,false,playerVeh)
                if (finished == 100) then
                    TriggerServerEvent('prp-inventory:openInventorySteal', GetPlayerServerId(closestPlayer))
                    ClearPedTasks(GetPlayerPed(-1))
                end
            end
        end
    else
        TriggerEvent("DoLongHudText", "Too far", 2)
    end
end)

RegisterNetEvent('prp-inventory:openInventorySteal')
AddEventHandler('prp-inventory:openInventorySteal', function(data)
    local cid = exports["isPed"]:isPed("cid")
    TriggerEvent('prp-ac:triggeredItemSpawn', "1", "ply-"..data.id)
--    print(data.id)
end)

RegisterNetEvent('cash:remove')
AddEventHandler('cash:remove', function()
    TriggerServerEvent('prp-ac:money')
end)

RegisterNetEvent('bank:add')
AddEventHandler('bank:add', function()
    TriggerServerEvent('prp-ac:money')
end)

RegisterNetEvent('bank:remove')
AddEventHandler('bank:remove', function()
    TriggerServerEvent('prp-ac:money')
end)

RegisterNetEvent('cash:add')
AddEventHandler('cash:add', function()
    TriggerServerEvent('prp-ac:money')
end)

RegisterNetEvent('prp-ac:removeban')
AddEventHandler('prp-ac:removeban', function(cash)
    local src = source
    local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    LocalPlayer:removeCash(Player.id, cash)
end)

RegisterNetEvent('prp-ac:checkforban')
AddEventHandler('prp-ac:checkforban', function(amount)
    local src = source
    local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    LocalPlayer:addBank(Player.id, amount)
    TriggerEvent("banking:updateBalance", amount)
end)

RegisterNetEvent('prp-ac:passInfoBan')
AddEventHandler('prp-ac:passInfoBan', function(amount)
    local src = source
    local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    LocalPlayer:removeBank(Player.id, amount)
    TriggerEvent("banking:updateBalance", amount)
end)

RegisterNetEvent('prp-ac:InfoPass')
AddEventHandler('prp-ac:InfoPass', function(cash)
    local src = source
    local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    LocalPlayer:addCash(Player.id, cash)
end)

RegisterNetEvent('license:remove')
AddEventHandler('license:remove', function(argh, cash)
    local src = source
    local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    -- print(Player.id)
    LocalPlayer:removeCash(argh, cash)
end)

RegisterNetEvent('prp-ac:removebanall')
AddEventHandler('prp-ac:removebanall', function(cash)
    local src = source
    local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    LocalPlayer:setCash(Player.id, cash)
end)

-- RegisterCommand('steal', function()
--     local closestPlayer, closestDistance = GetClosestPlayer()
--     RequestAnimDict("random@shop_robbery")
--     while not HasAnimDictLoaded("random@shop_robbery") do
--         Citizen.Wait(0)
-- 	end
--     if closestPlayer ~= -1 and closestDistance <= 3.0 then
--         if ( IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "dead", "dead_a", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "amb@code_human_cower_stand@male@base", "base", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "amb@code_human_cower@male@base", "base", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "random@arrests@busted", "idle_a", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "mp_arresting", "idle", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "random@mugging3", "handsup_standing_base", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missfbi5ig_22", "hands_up_anxious_scientist", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missfbi5ig_22", "hands_up_loop_scientist", 3) or IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "missminuteman_1ig_2", "handsup_base", 3) ) then
--             if IsPedArmed(GetPlayerPed(-1), 7) then
--                 local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
--                 local Player = LocalPlayer:getCurrentCharacter()
--                 local closestPlayer, closestDistance = GetClosestPlayer()
--                 if closestPlayer ~= -1 and closestDistance <= 3.0 then
--                     TriggerServerEvent('prp-inventory:openInventorySteal', GetPlayerServerId(closestPlayer))
--                 else
--                     TriggerEvent("DoLongHudText", "Too far", 2)
--                 end
--             end
--         end
--     end
-- end)


RegisterCommand('search', function()
    local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    if Player.job == 'Police' then
        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            TriggerServerEvent('prp-inventory:openInventorySteal3', GetPlayerServerId(closestPlayer))
        else
            TriggerEvent("DoLongHudText", "Too far", 2)
        end
    else
        TriggerEvent("DoLongHudText", "Not Police", 2)
    end
end)


RegisterNetEvent('RunUseItem')
AddEventHandler('RunUseItem', function(itemid, slot, inventoryName, isWeapon)
    if itemid == nil then
        return
    end
    local ItemInfo = GetItemInfo(slot)
    if tonumber(ItemInfo.quality) ~= nil then
     if tonumber(ItemInfo.quality) < 1 then
         TriggerEvent("DoLongHudText","Item is too worn.",2) 
         if isWeapon then
             TriggerEvent("brokenWeapon")
         end
         return
     end
    end

    if justUsed then
        retardCounter = retardCounter + 1
        if retardCounter > 10 and retardCounter > lastCounter+5 then
            lastCounter = retardCounter
            TriggerServerEvent("exploiter", "Tried using " .. retardCounter .. " items in < 500ms ")
        end
        return
    end

    justUsed = true

    -- if (not hasEnoughOfItem(itemid,1,false)) then
    --     TriggerEvent("DoLongHudText","You dont appear to have this item on you?",2) 
    --     justUsed = false
    --     retardCounter = 0
    --     lastCounter = 0
    --     return
    -- end

    if itemid == "-72657034" then
        TriggerEvent("equipWeaponID",itemid,ItemInfo.information,ItemInfo.id)
        TriggerEvent("inventory:removeItem",itemid, 1)
        justUsed = false
        retardCounter = 0
        lastCounter = 0
        return
    end

    if not isValidUseCase(itemid,isWeapon) then
        justUsed = false
        retardCounter = 0
        lastCounter = 0
        return
    end

    if (itemid == nil) then
        justUsed = false
        retardCounter = 0
        lastCounter = 0
        return
    end

    
    if (isWeapon) then
        TriggerEvent("equipWeaponID",itemid,ItemInfo.information,ItemInfo.id)
        justUsed = false
        retardCounter = 0
        lastCounter = 0
        return
    end



    TriggerEvent("hud-display-item",itemid,"Used")

    Wait(800)

    local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)

    if (not IsPedInAnyVehicle(player)) then
        if (itemid == "Suitcase") then
            TriggerEvent('attach:suitcase')
        end

        if (itemid == "Boombox") then
                TriggerEvent('attach:boombox')
        end
        if (itemid == "Box") then
                TriggerEvent('attach:box')
        end
        if (itemid == "DuffelBag") then
                TriggerEvent('attach:blackDuffelBag')
        end
        if (itemid == "MedicalBag") then
                TriggerEvent('attach:medicalBag')
        end
        if (itemid == "SecurityCase") then
                TriggerEvent('attach:securityCase')
        end
        if (itemid == "Toolbox") then
                TriggerEvent('attach:toolbox')
        end
        if itemid == "wheelchair" then
            if not DoesEntityExist(wheelChair) then
                local wheelChairModel = `npwheelchair`
                RequestModel(wheelChairModel)
                while not HasModelLoaded(wheelChairModel) do
                    Citizen.Wait(0)
                end
                wheelChair = CreateVehicle(wheelChairModel, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), true, false)
                SetVehicleOnGroundProperly(wheelChair)
                SetVehicleNumberPlateText(wheelChair, "PILLBOX".. math.random(9))
                SetPedIntoVehicle(PlayerPedId(), wheelChair, -1)
                SetModelAsNoLongerNeeded(wheelChairModel)
                local wheelChairPlate = GetVehicleNumberPlateText(wheelChair)
                TriggerServerEvent('garages:addJobPlate', wheelChairPlate)
                TriggerEvent("keys:addNew", wheelChair, wheelChairPlate)
            elseif DoesEntityExist(wheelChair) and #(GetEntityCoords(wheelChair) - GetEntityCoords(PlayerPedId())) < 3.0 and GetPedInVehicleSeat(wheelChair,-1) == 0 then
                DeleteVehicle(wheelChair)
                wheelChair = nil
            else
                TriggerEvent("DoLongHudText","Too far away from the wheelchair or someone is sitting in it !",1)
            end
        end
    end

    local remove = false
    local drugitem = false
    local fooditem = false
    local drinkitem = false
    local healitem = false

    if (itemid == "joint" or itemid == "weed5oz" or itemid == "weedq" or itemid == "beer" or itemid == "vodka" or itemid == "whiskey" or itemid == "lsdtab") then
        drugitem = true
    end

    if (itemid == "fakeplate") then
      TriggerEvent("fakeplate:change")
    end

    if (itemid == "tuner") then
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        local finished = exports["prp-taskbar"]:taskBar(2000,"Connecting Tuner Laptop",false,false,playerVeh)
        if (finished == 100) then
        --  if (finished == 100) then
            TriggerEvent("tuner:open")
        end
    end

    if (itemid == "electronickit" or itemid == "lockpick") then
      TriggerServerEvent("robbery:triggerItemUsedServer",itemid)
      
    end
    if (itemid == "locksystem") then
        TriggerServerEvent("robbery:triggerItemUsedServer",itemid)
    end

    if (itemid == "thermite") then
      TriggerServerEvent("robbery:triggerItemUsedServer",itemid)
      TriggerEvent('prp-robbery:securityBlueUsed')
    end

    if (itemid == "racingslick") then
        if exports['isPed']:isPed('job') == 'tuner_carshop' then
            TriggerEvent('prp-illegals-upgrade-tire', exports['isPed']:isPed('cid'))
        end
    end

    if (itemid == "racingclutch") then
        if exports['isPed']:isPed('job') == 'tuner_carshop' then
            TriggerEvent('prp-illegals-upgrade-clutch', exports['isPed']:isPed('cid'))
        end
    end

    if (itemid == "racingintercooler") then
        if exports['isPed']:isPed('job') == 'tuner_carshop' then
            TriggerEvent('prp-illegals-upgrade-intercooler', exports['isPed']:isPed('cid'))
        end
    end

    if (itemid == "racinginjectors") then
        if exports['isPed']:isPed('job') == 'tuner_carshop' then
            TriggerEvent('prp-illegals-upgrade-fuelinjector', exports['isPed']:isPed('cid'))
        end
    end

    if (itemid == "racingforge") then
        if exports['isPed']:isPed('job') == 'tuner_carshop' then
            TriggerEvent('prp-illegals-upgrade-forgeengine', exports['isPed']:isPed('cid'))
        end
    end

    if (itemid == "racingremap") then
        if exports['isPed']:isPed('job') == 'tuner_carshop' then
            TriggerEvent('prp-illegals-upgrade-remap', exports['isPed']:isPed('cid'))
        end
    end

    if(itemid == "evidencebag") then
        TriggerEvent("evidence:startCollect", itemid, slot)
        local itemInfo = GetItemInfo(slot)
        local data = itemInfo.information
        if data == '{}' then
            TriggerEvent("DoLongHudText","Start collecting evidence!",1) 
            TriggerEvent("inventory:updateItem", itemid, slot, '{"used": "true"}')
            --
        else
            local dataDecoded = json.decode(data)
            if(dataDecoded.used) then
                print('YOURE ALREADY COLLECTING EVIDENCE!')
            end
        end
    end

    if (itemid == "lsdtab" or itemid == "blunt") then
        TriggerEvent("animation:PlayAnimation","weed")
        remove = true
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        local finished = exports["prp-taskbar"]:taskBar(3000,"Smokin On That Loud..",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("Evidence:StateSet",2,1200)
            TriggerEvent("Evidence:StateSet",24,1200)
            TriggerEvent("fx:run", "lsd", 180, nil, (itemid == "blunt" and true or false))
        end
    end

    if (itemid == "beavisvape") then
        TriggerEvent("Vape:StartVaping")
    end

    if (itemid == "decryptersess" or itemid == "decrypterfv2" or itemid == "decrypterenzo") then
      if (#(GetEntityCoords(player) - vector3( 1275.49, -1710.39, 54.78)) < 3.0) then
        exports["urp_taskbar"]:StartDelayedFunction("Decrypting Data", 25000, function()
            -- TriggerEvent("pixerium:check",3,"robbery:decrypt",true)
            TriggerEvent('unerium:checkrobbery:decrypt1')
        end)
      end
      if #(GetEntityCoords(player) - vector3( 2328.94, 2571.4, 46.71)) < 3.0 then
          local finished = exports["prp-taskbar"]:taskBar(25000,"Decrypting Data",false,false,playerVeh)
          if finished == 100 then
            -- TriggerEvent("pixerium:check",3,"robbery:decrypt2",true)
            TriggerEvent('unerium:checkrobbery:decrypt2')
          end
      end
      if #(GetEntityCoords(player) - vector3( 1208.73,-3115.29, 5.55)) < 3.0 then
          local finished = exports["prp-taskbar"]:taskBar(25000,"Decrypting Data",false,false,playerVeh)
          if finished == 100 then
            TriggerEvent('unerium:checkrobbery:decrypt3')
            -- TriggerEvent("pixerium:check",3,"robbery:decrypt3",true)
          end
      end
      
    end 
    if (itemid == "pix1") then
      if (#(GetEntityCoords(player) - vector3( 1275.49, -1710.39, 54.78)) < 3.0) then
        TriggerEvent("inventory:removeItem",'pix1', 1)
          local finished = exports["prp-taskbar"]:taskBar(25000,"Decrypting Data",false,false,playerVeh)
          FreezeEntityPosition(PlayerPedId(), true)
          if (finished == 100) then
            TriggerEvent("Crypto:Unerium",math.random(1,2))
            FreezeEntityPosition(PlayerPedId(), false)
          end
      end
    end  
    if (itemid == "pix2") then
      if (#(GetEntityCoords(player) - vector3( 1275.49, -1710.39, 54.78)) < 3.0) then
        TriggerEvent("inventory:removeItem",'pix2', 1)
          local finished = exports["prp-taskbar"]:taskBar(25000,"Decrypting Data",false,false,playerVeh)
          FreezeEntityPosition(PlayerPedId(), true)
          if (finished == 100) then
            TriggerEvent("Crypto:GiveUnerium",math.random(5,12))
            FreezeEntityPosition(PlayerPedId(), false)
          end
      end
    end


    -- DRUGS BELOW 

    if (itemid == "wateringcan") then
        TriggerServerEvent('prp-DopePlant:wateringcan')
    end

    if (itemid == "purifiedwater") then
        TriggerServerEvent('prp-DopePlant:purifiedwater')
    end

    if (itemid == "lowgradefert") then
        TriggerServerEvent('prp-DopePlant:lowgradefert')
    end

    if (itemid == "highgradefert") then
        TriggerServerEvent('prp-DopePlant:highgradefert')
    end

    if (itemid == "lowgrademaleseed") then
        if hasEnoughOfItem('plantpot', 1) then
            TriggerEvent('prp-weed:startcrop', 'male')
        end
    end

    if (itemid == "highgrademaleseed") then
        if hasEnoughOfItem('plantpot', 1) then
            TriggerServerEvent('prp-DopePlant:highgrademaleseed')
        end
    end

    if (itemid == "lowgradefemaleseed") then
        if hasEnoughOfItem('plantpot', 1) then
            TriggerEvent('prp-weed:startcrop', 'female')
        end
    end

    if (itemid == "dopebag") then
        if hasEnoughOfItem('drugscales', 1) and hasEnoughOfItem('trimmedweed', 5) then
            TriggerServerEvent('prp-DopePlant:dopebag')
        end
    end

    if (itemid == "highgradefemaleseed") then
        if hasEnoughOfItem('plantpot', 1) then
            TriggerServerEvent('prp-DopePlant:highgradefemaleseed')
        end
    end

    --END DRUGS HERE
    if (itemid == "dnaanalyzer") then
        TriggerEvent('urp_dna:AnalyzeDNA')
    end

    if (itemid == 'ammoanalyzer') then
        TriggerEvent('urp_dna:AnalyzeAmmo')
    end

    if (itemid == "fishingrod") then
        TriggerEvent("prp-fish:lego")
    end


    if (itemid == "femaleseed") then
       TriggerEvent("Evidence:StateSet",4,1600)
       TriggerEvent("weed:startcropInsideCheck","female")
       
    end

    if (itemid == "maleseed") then
        TriggerEvent("Evidence:StateSet",4,1600)
        TriggerEvent("weed:startcropInsideCheck","male")
        
    end

    if (itemid == "weedoz") then
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        local finished = exports["prp-taskbar"]:taskBar(5000,"Packing Q Bags",false,false,playerVeh)
        if (finished == 100) then
            CreateCraftOption("weedq", 100, true)
        end
        
    end

    if (itemid == "weed12oz") then
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        local finished = exports["prp-taskbar"]:taskBar(5000,"Packing Bags",false,false,playerVeh)
        if (finished == 100) then
            CreateCraftOption("weed5oz", 100, true)
        end
        
    end

    if (itemid == "weed5oz") then
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        local finished = exports["prp-taskbar"]:taskBar(5000,"Packing Bags",false,false,playerVeh)
        if (finished == 100) then
            CreateCraftOption("weedoz", 100, true)
        end
        
    end

    if (itemid == "lighter") then
        TriggerEvent("animation:PlayAnimation","lighter")
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        local finished = exports["prp-taskbar"]:taskBar(2000,"Starting Fire",false,false,playerVeh)
        if (finished == 100) then
            ClearPedTasks(PlayerPedId())
        end
        
    end
    
    if (itemid == "radio") then
        TriggerEvent('radioGui')
    end

    if (itemid == "joint") then
        remove = true
        local finished = exports["prp-taskbar"]:taskBar(2000,"Smoking Joint",false,false,playerVeh)
        if (finished == 100) then
            Wait(200)
            TriggerEvent("animation:PlayAnimation","weed")
            TriggerEvent("Evidence:StateSet",3,600)
            TriggerEvent("Evidence:StateSet",4,600)        
            TriggerEvent("stress:timed",1000,"WORLD_HUMAN_SMOKING_POT")
        end
    end

    if (itemid == "fireworkfountain") then
        TriggerEvent('firework:fountain')
        remove = true
    end

    if (itemid == "fireworkrocket") then
        TriggerEvent('firework:rocket')
        remove = true
    end

    if (itemid == "fireworkshotburst") then
        TriggerEvent('firework:shotburst')
        remove = true
    end

    if (itemid == "vodka" or itemid == "beer" or itemid == "whiskey") then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","changethirst",true,itemid,playerVeh)
        TriggerEvent("Evidence:StateSet", 8, 600)
        local alcoholStrength = 0.5
        if itemid == "vodka" or itemid == "whiskey" then alcoholStrength = 1.0 end
        TriggerEvent("fx:run", "alcohol", 180, alcoholStrength)
    end

    if (itemid == "coffee" or itemid == "bscoffee") then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","coffee:drink",true,itemid,playerVeh)
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    end

    if (itemid == "chips") then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:Condiment",true,itemid,playerVeh)
    end

    if (itemid == "fishtaco") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:FishTaco",true,itemid,playerVeh)
    end

    if (itemid == "taco" or itemid == "burrito") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:Taco",true,itemid,playerVeh)
    end

    if (itemid == "churro" or itemid == "hotdog") then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:Condiment",true,itemid,playerVeh)
    end

    if (itemid == "greencow") then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","changethirst",true,itemid,playerVeh)
    end

    if (itemid == "donut" or itemid == "eggsbacon") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:Condiment",true,itemid,playerVeh)
    end

    if (itemid == "icecream" or itemid == "mshake") then
        TaskItem("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drinking","changethirst",true,itemid,playerVeh)
    end

    if (itemid == "cgummies") then
        ExecuteCommand("e pill")
        TriggerEvent("fx:run", "alcohol", 180, alcoholStrength)
    end

    if itemid == "clotion" then
        AttachPropAndPlayAnimation("amb@code_human_in_car_mp_actions@grab_crotch@std@ds@base", "idle_a", 49, 8000,"🍆 Rubbing It In 🍆", "healed:useOxy",true,itemid,playerVeh)
    end

    
    if (itemid == "advlockpick") then
        local myJob = exports["isPed"]:isPed("job")
        if myJob ~= "News" then
            TriggerEvent('prp-robbery:advLockpickUse')
        else
            TriggerEvent("DoLongHudText","Nice news reporting, you shit lord idiot.")
        end   

    end


    if (itemid == "Gruppe6Card3") then

        TriggerEvent('prp-doors:UseRedKeycard') 
        TriggerEvent('sec:usegroup6card')
        remove = true

    end


    if (itemid == "usbdevice") then
        TriggerEvent("t1ger_drugs:UsableItem")
    end
    -- if (itemid == "portableatm") then
    --     TriggerEvent('bank:OpenATM')
    -- end
    if (itemid == "heavyammo") then
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        remove = true
        local finished = exports["prp-taskbar"]:taskBar(5000,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("actionbar:ammo",1788949567,50,true)
        end
    end

    if (itemid == "pistolammo") then
        TriggerEvent('inventory:removeItem', 'pistolammo', 1)
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        --remove = true
        local finished = exports["prp-taskbar"]:taskBar(5000,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("actionbar:ammo",1950175060,50,true)
        end
    end

    if (itemid == "rifleammo") then
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        remove = true
        local finished = exports["prp-taskbar"]:taskBar(5000,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("actionbar:ammo",218444191,50,true)
        end
    end

    if (itemid == "shotgunammo") then
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        remove = true
        local finished = exports["prp-taskbar"]:taskBar(5000,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("actionbar:ammo",-1878508229,50,true)
        end
    end

    if (itemid == "subammo") then
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        remove = true
        local finished = exports["prp-taskbar"]:taskBar(5000,"Reloading",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("actionbar:ammo",1820140472,50,true)
        end
    end


    if (itemid == "armor") then
        TriggerEvent('inventory:removeItem', 'armor', 1)
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        applying = true
        local finished = exports["prp-taskbar"]:taskBar(10000,"Armor",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("ApplyArmor")
            SetPlayerMaxArmour(PlayerId(), 60 )
            SetPedArmour( PlayerPedId(), 60 )
            TriggerEvent("UseBodyArmor")
            applying = false
        else
            applying = false
        end
    end

    if (itemid == "binoculars") then 
        TriggerEvent("binoculars:Activate2")        
    end

    if (itemid == "camera") then
        if job == "News" then
            TriggerEvent("camera:setCamera")
        end
    end

    if (itemid == "idcard") then
        TriggerServerEvent('idcard:run', ItemInfo.information)
    end

    if (itemid == "nitrous") then
        local currentVehicle = GetVehiclePedIsIn(player, false)
        
        if not IsToggleModOn(currentVehicle,18) then
            TriggerEvent("DoLongHudText","You need a Turbo to use NOS!",2)
        else
            local finished = 0
            local cancelNos = false
            Citizen.CreateThread(function()
                while finished ~= 100 and not cancelNos do
                    Citizen.Wait(100)
                    if GetEntitySpeed(GetVehiclePedIsIn(player, false)) > 11 then
                        exports["prp-taskbar"]:closeGuiFail()
                        cancelNos = true
                    end
                end
            end)
            remove = true
            finished = exports["prp-taskbar"]:taskBar(20000,"Nitrous")
            if (finished == 100 and not cancelNos) then
                TriggerEvent("NosStatus")
                TriggerEvent("noshud", 100, false)
            else
                TriggerEvent("DoLongHudText","You can't drive and hook up nos at the same time.",2)
            end
        end
    end

    if (itemid == "redpack") then
        remove = true
        TriggerServerEvent('loot:redpack', itemid)
    end


    if (itemid == "lockpick") then

        local myJob = exports["isPed"]:isPed("job")
        if myJob ~= "news" then
            TriggerEvent("inv:lockPick",false,inventoryName,slot)
            TriggerEvent("houseRobberies:attempt")
        else
            TriggerEvent("DoLongHudText","Nice news reporting, you shit lord idiot.")
        end       
        
    end

    if (itemid == "umbrella") then
        TriggerEvent("animation:PlayAnimation","umbrella")
        
    end

    if (itemid == "repairkit") then
      TriggerEvent('veh:repairing',inventoryName,slot,itemid)
           
    end

    if (itemid =="advrepairkit") then
      TriggerEvent('veh:repairing',inventoryName,slot,itemid)
           
    end

    if (itemid) == "infadvrepairkit" then
        TriggerEvent('veh:repairing', inventoryName, slot, itemid)
    end
    if (itemid == "securityblue")  then
    end

    if (itemid == "Largesupplycrate") then
        if (hasEnoughOfItem("2227010557",1,false)) then
            remove = true
            local finished = exports["prp-taskbar"]:taskBar(15000,"Opening supply crate.",false,false,playerVeh)
            if (finished == 100) then
                TriggerEvent("inventory:removeItem","2227010557", 1)

                TriggerServerEvent('loot:useItem', itemid)
            end
        else
            TriggerEvent("DoLongHudText","You are missing something to open the crate with",2)
        end
    end

    if (itemid == "Gruppe6Card2")  then
        TriggerServerEvent("robbery:triggerItemUsedServer",itemid)
    end

    if (itemid == "Gruppe6Card22")  then
        TriggerEvent("prp-robbery:legionHack")
        TriggerServerEvent('robbery:triggerItemUsedServer', itemid)
    end    

    if (itemid == "ciggy") then
        if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
            local finished = exports["prp-taskbar"]:taskBar(2000,"Smoking Ciggy",false,false,playerVeh)
            if (finished == 100) then
                if exports["prp-inventory"]:getQuantity("ciggy") > 0 then
                    TriggerEvent('client:lowerStress', 1000)
                    remove = true
                end
            end
        elseif GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
            TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_SMOKING", 0,"Smoke")
            local finished = exports["prp-taskbar"]:taskBar(2000,"Smoking Ciggy",false,false,playerVeh)
            if (finished == 100) then
                if exports["prp-inventory"]:getQuantity("ciggy") > 0 then
                    TriggerEvent('client:lowerStress', 1000)
                    remove = true
                end
            end
        end
    end

    if (itemid == "cigar") then
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        local finished = exports["prp-taskbar"]:taskBar(1000,"Lighting Up",false,false,playerVeh)
        if (finished == 100) then
            Wait(300)
            TriggerEvent("animation:PlayAnimation","cigar")
        end
    end

    if (itemid == "oxygentank") then
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        remove = true  
        local finished = exports["prp-taskbar"]:taskBar(30000,"Oxygen Tank",false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent("UseOxygenTank")
        end
    end

    if (itemid == "bandage") then
        TriggerEvent('inventory:removeItem', 'bandage', 1)
        TaskItem("amb@world_human_clipboard@male@idle_a", "idle_c", 49,10000,"Healing","inventory:bandage",false,itemid,playerVeh)
        TriggerEvent('inventory:bandage', 1)
        ClearPedTasks(PlayerPedId())
        TriggerEvent('HealSlow')
    end

    if (itemid == "coke50g") then
        CreateCraftOption("coke5g", 80, true)
        
    end

    if (itemid == "bakingsoda") then 
        CreateCraftOption("1gcrack", 80, true)
    end

    if (itemid == "glucose") then 
        CreateCraftOption("1gcocaine", 80, true)
        
    end

    if (itemid == "drivingtest") then 
        local ItemInfo = GetItemInfo(slot)
        if (ItemInfo.information ~= "No information stored") then
            local data = json.decode(ItemInfo.information)
            TriggerServerEvent("driving:getResults", data.ID)
        end
    end

    if (itemid == "1gcocaine") then
        TriggerEvent("attachItemObjectnoanim","drugpackage01")
        TriggerEvent("Evidence:StateSet",2,1200)
        TriggerEvent("Evidence:StateSet",6,1200)
        TaskItem("anim@amb@nightclub@peds@", "missfbi3_party_snort_coke_b_male3", 49, 5000, "Coke Gaming", "hadcocaine", true,itemid,playerVeh)
    end

    if (itemid == "1gcrack") then 
        TriggerEvent("attachItemObjectnoanim","crackpipe01")
        TriggerEvent("Evidence:StateSet",2,1200)
        TriggerEvent("Evidence:StateSet",6,1200)
        TaskItem("switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 49, 5000, "Smoking Quack", "hadcrack", true,itemid,playerVeh)
    end

    if (itemid == "treat") then
        local model = GetEntityModel(player)
        if model == GetHashKey("a_c_chop") then
            TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49, 1200, "Treat Num's", "hadtreat", true,itemid,playerVeh)
        end
    end

    if (itemid == "IFAK") then
        loadAnimDict("amb@world_human_clipboard@male@idle_a")
        TaskPlayAnim( PlayerPedId(), "amb@world_human_clipboard@male@idle_a", "idle_c", 3.0, 1.0, 5000, 49, 0, 0, 0, 0 ) 
        remove = true
        Citizen.Wait(5000)
        TriggerEvent('inventory:bandage', 2)
        ClearPedTasks(PlayerPedId())
        TriggerEvent('HealSlow')
    end

    if (itemid == "notepad") then
        TriggerEvent('prp-notepad:note')
        TriggerEvent('prp-notepad:OpenNotepadGui')
    end

    if (itemid == "oxy") then
        ExecuteCommand("e pill")
        remove = true 
        ClearPedTasks(PlayerPedId())
        TriggerEvent('HealSlow')
    end

    if (itemid == "sandwich" or itemid == "hamburger") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:Condiment",true,itemid,playerVeh)
    end

    if (itemid == "cola" or itemid == "water" or itemid == "softdrink") then
        AttachPropAndPlayAnimation("amb@world_human_drinking@beer@female@idle_a", "idle_e", 49,6000,"Drink","changethirst",true,itemid,playerVeh)
    end


    if (itemid == "jailfood" or itemid == "bleederburger" or itemid == "heartstopper" or itemid == "torpedo" or itemid == "meatfree" or itemid == "moneyshot" or itemid == "fries") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","inv:wellfed",true,itemid,playerVeh)
        --attachPropsToAnimation(itemid, 6000)
        --TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49, 6000, "Eating", "inv:wellfed", true,itemid)
    end

    if (itemid == "souffle" or itemid == "latticetopped" or itemid == 'brownie' or itemid == 'glazingdonut' or itemid == 'coconutmaca' or itemid == 'thumbcookie' or itemid == 'pretzel' or itemid == "eclair" or itemid == "creampuff" or itemid == "strudel" or itemid == "cinnamonroll" or itemid == "rasberryrouladeslice") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","inv:wellfed",true,itemid,playerVeh)
    end

    if (itemid == "methbag") then
        local finished = exports["prp-taskbarskill"]:taskBar(2500,10)
        if (finished == 100) then 
            assmeth = CreateObject('crackpipe01', 1.0, 1.0, 1.0, 1, 1, 0)
            -- TriggerEvent("attachItemObjectnoanim","crackpipe01")
            TriggerEvent("Evidence:StateSet",2,1200)
            TriggerEvent("Evidence:StateSet",6,1200)
            TaskItem("switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 49, 1500, "💩 Smoking Ass Meth 💩", "hadcocaine", true, itemid,playerVeh)
            DeleteObject(assmeth)
        end
    end
    if itemid == "slushy" then
        --attachPropsToAnimation(itemid, 6000)
        TriggerEvent("healed:useOxy")
        AttachPropAndPlayAnimation("amb@world_human_drinking@beer@female@idle_a", "idle_e", 49, 6000,"Eating", "inv:wellfed",true,itemid,playerVeh)
    end

    if (itemid == "shitlockpick") then
        lockpicking = true
        TriggerEvent("animation:lockpickinvtestoutside") 
        remove = true
        local finished = exports["prp-taskbarskill"]:taskBar(2500,math.random(5,20))
        if (finished == 100) then    
            TriggerEvent("police:uncuffMenu")
            ClearPedTasks(PlayerPedId())
        end
        lockpicking = false
    end

    if (itemid == "cuffs") then
        remove = true
        TriggerEvent('urp_handcuffs:cuffcheck')
    end

    if (itemid == "watch") then
        CreateCraftOption("electronics", 40, true)
    end

    if (itemid == "harness") then
        local veh = GetVehiclePedIsIn(player, false)
        local driver = GetPedInVehicleSeat(veh, -1)
        if (PlayerPedId() == driver) then
            TriggerEvent("vehicleMod:useHarnessItem")
            remove = true
        end
    end

    if (itemid == "backpack") then
        local info = json.decode(ItemInfo.information)
        TriggerEvent('prp-ac:triggeredItemSpawn', "1", "backpack-" .. info.serial)
    end

    if remove == true then
        TriggerEvent("inventory:removeItem",itemid, 1)
    end

    Wait(500)
    retardCounter = 0
    justUsed = false


end)

function GetIdentifierWithoutSteam(Identifier)
    return string.gsub(Identifier, "steam:", "")
end

function AttachPropAndPlayAnimation(dictionary,animation,typeAnim,timer,message,func,remove,itemid,vehicle)
    if itemid == "hamburger" or itemid == "heartstopper" or itemid == "bleederburger" then
        TriggerEvent("attachItem", "hamburger")
    elseif itemid == "sandwich" then
        TriggerEvent("attachItem", "sandwich")
    elseif itemid == "donut" then
        TriggerEvent("attachItem", "donut")
    elseif itemid == "water" or itemid == "cola" or itemid == "vodka" or itemid == "whiskey" or itemid == "beer" or itemid == "coffee" or itemid == "softdrink" then
        TriggerEvent("attachItem", itemid)
    elseif itemid == "fishtaco" or itemid == "taco" then
        TriggerEvent("attachItem", "taco")
    elseif itemid == "greencow" then
        TriggerEvent("attachItem", "energydrink")
    elseif itemid == "slushy" then
        TriggerEvent("attachItem", "cup")
    end
    TaskItem(dictionary, animation, typeAnim, timer, message, func, remove, itemid,vehicle)
end

RegisterNetEvent('randPickupAnim')
AddEventHandler('randPickupAnim', function()
    loadAnimDict('pickup_object')
    TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    Wait(1000)
    ClearPedSecondaryTask(PlayerPedId())
end)



local clientInventory = {};
RegisterNetEvent('current-items')
AddEventHandler('current-items', function(inv)
    clientInventory = inv
end)



RegisterNetEvent('SniffRequestCID')
AddEventHandler('SniffRequestCID', function(src)
    local cid = exports["isPed"]:isPed("cid")
    TriggerServerEvent("SniffCID",cid,src)
end)



function GetItemInfo(checkslot)
    for i,v in pairs(clientInventory) do
        if (tonumber(v.slot) == tonumber(checkslot)) then
            local info = {["information"] = v.information,["id"] = v.item_id, ["quality"] = v.quality }
            return info
        end
    end
    return "No information stored";
end

-- item id, amount allowed, crafting.
function CreateCraftOption(id, add, craft)
    TriggerEvent("CreateCraftOption", id, add, craft)
end

-- Animations
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function TaskItem(dictionary,animation,typeAnim,timer,message,func,remove,itemid,playerVeh)
    loadAnimDict( dictionary ) 
    TaskPlayAnim( PlayerPedId(), dictionary, animation, 8.0, 1.0, -1, typeAnim, 0, 0, 0, 0 )
    local timer = tonumber(timer)
    if timer > 0 then
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        local finished = exports["prp-taskbar"]:taskBar(timer,message,false,false,playerVeh)
        if (finished == 100) then
            TriggerEvent(func)
            ClearPedTasks(PlayerPedId())
            TriggerEvent("destroyProp")
        end
    else
        TriggerEvent(func)
    end

    if remove then
        TriggerEvent("inventory:removeItem",itemid, 1)
    end
end



function GetCurrentWeapons()
    local returnTable = {}
    for i,v in pairs(clientInventory) do
        if (tonumber(v.item_id)) then
            local t = { ["hash"] = v.item_id, ["id"] = v.id, ["information"] = v.information, ["name"] = v.item_id, ["slot"] = v.slot }
            returnTable[#returnTable+1]=t
        end
    end   
    if returnTable == nil then 
        return {}
    end
    return returnTable
end

function getQuantity(itemid)
    local amount = 0
    for i,v in pairs(clientInventory) do
        if (v.item_id == itemid) then
            if v.quality < 1 then
                -- add no amount
            else
                amount = amount + v.amount
            end
        end
    end
    return amount
end

function hasEnoughOfItem(itemid, amount, shouldReturnText)
    if shouldReturnText == nil then shouldReturnText = true end
    if itemid == nil or itemid == 0 or amount == nil or amount == 0 then if shouldReturnText then TriggerEvent("DoLongHudText","I dont seem to have " .. tostring(itemid) .. " in my pockets.",2) end return false end
    amount = tonumber(amount)
    local slot = 0
    local found = false
    if getQuantity(itemid) >= amount then
        return true
    end
    if (shouldReturnText) then
        TriggerEvent("DoLongHudText","I dont have enough of that item or too worn",2) 
    end
    return false
end


function isValidUseCase(itemID,isWeapon)
    local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)
    if playerVeh ~= 0 then
        local model = GetEntityModel(playerVeh)
        if IsThisModelACar(model) or IsThisModelABike(model) or IsThisModelAQuadbike(model) then
            if IsEntityInAir(playerVeh) then
                Wait(1000)
                if IsEntityInAir(playerVeh) then
                    TriggerEvent("DoLongHudText","You appear to be flying through the air",2) 
                    return false
                end
            end
        end
    end

    if not validWaterItem[itemID] and not isWeapon then
        if IsPedSwimming(player) then
            local targetCoords = GetEntityCoords(player, 0)
            Wait(700)
            local plyCoords = GetEntityCoords(player, 0)
            if #(targetCoords - plyCoords) > 1.3 then
                TriggerEvent("DoLongHudText","Cannot be moving while swimming to use this.",2) 
                return false
            end
        end

        if IsPedSwimmingUnderWater(player) then
            TriggerEvent("DoLongHudText","Cannot be underwater to use this.",2) 
            return false
        end
    end

    return true
end

-- Citizen.CreateThread(function()
--     while true do
--         if IsControlPressed(0, 289) then
--             print('this is inventory')
--             SendNUIMessage({openInventory = t})
--         end
--     end
-- end)





























-- DNA



RegisterNetEvent('evidence:addDnaSwab')
AddEventHandler('evidence:addDnaSwab', function(dna)
    TriggerEvent("DoLongHudText", "DNA Result: " .. dna,1)    
end)

RegisterNetEvent('CheckDNA')
AddEventHandler('CheckDNA', function()
    TriggerServerEvent("Evidence:checkDna")
end)

RegisterNetEvent('evidence:dnaSwab')
AddEventHandler('evidence:dnaSwab', function()
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 5) then
        TriggerServerEvent("police:dnaAsk", GetPlayerServerId(t))
    end
end)

RegisterNetEvent('evidence:swabNotify')
AddEventHandler('evidence:swabNotify', function()
    TriggerEvent("DoLongHudText", "DNA swab taken.",1)
end)


function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end


-- DNA AND EVIDENCE END
























-- this is the upside down world, be careful.


function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end
function DrawText3Ds(x,y,z, text)
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

local burgies = 0
RegisterNetEvent('inv:wellfed')
AddEventHandler('inv:wellfed', function()
    TriggerEvent("Evidence:StateSet",25,3600)
    TriggerEvent("changehunger")
    TriggerEvent("changehunger")
    TriggerEvent("client:newStress",false,10)
    TriggerEvent("changehunger")
    TriggerEvent("changethirst")
    burgies = 0
end)


RegisterNetEvent('animation:lockpickinvtestoutside')
AddEventHandler('animation:lockpickinvtestoutside', function()
    local lPed = PlayerPedId()
    RequestAnimDict("veh@break_in@0h@p_m_one@")
    while not HasAnimDictLoaded("veh@break_in@0h@p_m_one@") do
        Citizen.Wait(0)
    end
    
    while lockpicking do        
        TaskPlayAnim(lPed, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 16, 0.0, 0, 0, 0)
        Citizen.Wait(2500)
    end
    ClearPedTasks(lPed)
end)

RegisterNetEvent('animation:lockpickinvtest')
AddEventHandler('animation:lockpickinvtest', function(disable)
    local lPed = PlayerPedId()
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
    end
    if disable ~= nil then
        if not disable then
            lockpicking = false
            return
        else
            lockpicking = true
        end
    end
    while lockpicking do

        if not IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then
            ClearPedSecondaryTask(lPed)
            TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        end
        Citizen.Wait(1)
    end
    ClearPedTasks(lPed)
end)



RegisterNetEvent('inv:lockPick')
AddEventHandler('inv:lockPick', function(isForced,inventoryName,slot)
    TriggerEvent("robbery:scanLock",true)
    if lockpicking then return end

    lockpicking = true
    playerped = PlayerPedId()
    targetVehicle = GetVehiclePedIsUsing(playerped)
    local itemid = 21

    if targetVehicle == 0 then
        coordA = GetEntityCoords(playerped, 1)
        coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
        targetVehicle = getVehicleInDirection(coordA, coordB)
        local driverPed = GetPedInVehicleSeat(targetVehicle, -1)
        if targetVehicle == 0 then
            lockpicking = false
            return
        end

        if driverPed ~= 0 then
            lockpicking = false
            return
        end
            local d1,d2 = GetModelDimensions(GetEntityModel(targetVehicle))
            local leftfront = GetOffsetFromEntityInWorldCoords(targetVehicle, d1["x"]-0.25,0.25,0.0)

            local count = 5000
            local dist = #(vector3(leftfront["x"],leftfront["y"],leftfront["z"]) - GetEntityCoords(PlayerPedId()))
            while dist > 2.0 and count > 0 do
                dist = #(vector3(leftfront["x"],leftfront["y"],leftfront["z"]) - GetEntityCoords(PlayerPedId()))
                Citizen.Wait(1)
                count = count - 1
                DrawText3Ds(leftfront["x"],leftfront["y"],leftfront["z"],"Move here to lockpick.")
            end

            if dist > 2.0 then
                lockpicking = false
                return
            end


            TaskTurnPedToFaceEntity(PlayerPedId(), targetVehicle, 1.0)
            Citizen.Wait(1000)
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.4)
            local triggerAlarm = GetVehicleDoorLockStatus(targetVehicle) > 1
            if triggerAlarm then
                SetVehicleAlarm(targetVehicle, true)
                StartVehicleAlarm(targetVehicle)
            end


            TriggerEvent("civilian:alertPolice",20.0,"lockpick",targetVehicle)
           
            TriggerEvent("animation:lockpickinvtestoutside")
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.4)



 
            local finished = exports["prp-taskbarskill"]:taskBar(25000,3)

            if finished ~= 100 then
                 lockpicking = false
                return
            end

            local finished = exports["prp-taskbarskill"]:taskBar(2200,10)

            if finished ~= 100 then
                 lockpicking = false
                return
            end


            if finished == 100 then
                if triggerAlarm then
                    SetVehicleAlarm(targetVehicle, false)
                end
                local chance = math.random(50)
                if #(GetEntityCoords(targetVehicle) - GetEntityCoords(PlayerPedId())) < 10.0 and targetVehicle ~= 0 and GetEntitySpeed(targetVehicle) < 5.0 then

                    SetVehicleDoorsLocked(targetVehicle, 1)
                    TriggerEvent("DoLongHudText", "Vehicle Unlocked.",1)
                    TriggerEvent('InteractSound_CL:PlayOnOne', 'unlock', 0.1)

                end
            end
        lockpicking = false
    else
        if targetVehicle ~= 0 and not isForced then

            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.4)
            local triggerAlarm = GetVehicleDoorLockStatus(targetVehicle) > 1
            if triggerAlarm then
                SetVehicleAlarm(targetVehicle, true)
                StartVehicleAlarm(targetVehicle)
            end

            SetVehicleHasBeenOwnedByPlayer(targetVehicle,true)
            TriggerEvent("civilian:alertPolice",12.0,"lockpick",targetVehicle)
           
            TriggerEvent("animation:lockpickinvtest")
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockpick', 0.4)

           
            local carTimer = GetVehicleHandlingFloat(targetVehicle, 'CHandlingData', 'nMonetaryValue')
            if carTimer == nil then
                carTimer = math.random(25000,180000)
            end
            if carTimer < 25000 then
                carTimer = 25000
            end

            if carTimer > 180000 then
                carTimer = 180000
            end
            
            carTimer = math.ceil(carTimer / 3)


            local myJob = exports["isPed"]:isPed("job")
            if myjob == "mecano" then
                carTimer = 4000
            end

            TriggerEvent("civilian:alertPolice",12.0,"lockpick",targetVehicle)

            local finished = exports["prp-taskbarskill"]:taskBar(math.random(5000,25000),math.random(10,20))
            if finished ~= 100 then
                 lockpicking = false
                return
            end

            local finished = exports["prp-taskbarskill"]:taskBar(math.random(5000,25000),math.random(10,20))
            if finished ~= 100 then
                 lockpicking = false
                return
            end


            TriggerEvent("civilian:alertPolice",12.0,"lockpick",targetVehicle)
            local finished = exports["prp-taskbarskill"]:taskBar(1500,math.random(5,15))
            if finished ~= 100 then
                TriggerEvent("DoLongHudText", "The lockpick bent out of shape.",2)
                TriggerEvent("inventory:removeItem","lockpick", 1)                
                 lockpicking = false
                return
            end     


            Citizen.Wait(500)
            if finished == 100 then
                if triggerAlarm then
                    SetVehicleAlarm(targetVehicle, false)
                end
                local chance = math.random(50)
                if #(GetEntityCoords(targetVehicle) - GetEntityCoords(PlayerPedId())) < 10.0 and targetVehicle ~= 0 and GetEntitySpeed(targetVehicle) < 5.0 then

                    local plate = GetVehicleNumberPlateText(targetVehicle)
                    SetVehicleDoorsLocked(targetVehicle, 1)
                    TriggerServerEvent("garage:addKeys", plate)
                    TriggerEvent("DoLongHudText", "Ignition Working.",1)
                    SetEntityAsMissionEntity(targetVehicle,false,true)
                    SetVehicleHasBeenOwnedByPlayer(targetVehicle,true)
                    TriggerEvent("chop:plateoff",plate)

                end
                lockpicking = false
            end
        end
    end
    lockpicking = false
end)

local reapiring = false
RegisterNetEvent('veh:repairing')
AddEventHandler('veh:repairing', function(inventoryName,slot,itemid)
    local playerped = PlayerPedId()
    local coordA = GetEntityCoords(playerped, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)

    local advanced = false
    if itemid == "advrepairkit" then
        advanced = true
    end
    if itemid == "infadvrepairkit" then
        advanced = true
    end

    if targetVehicle ~= 0 then

        local d1,d2 = GetModelDimensions(GetEntityModel(targetVehicle))
        local moveto = GetOffsetFromEntityInWorldCoords(targetVehicle, 0.0,d2["y"]+0.5,0.2)
        local dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
        local count = 1000
        local fueltankhealth = GetVehiclePetrolTankHealth(targetVehicle)

        while dist > 1.5 and count > 0 do
            dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
            Citizen.Wait(1)
            count = count - 1
            DrawText3Ds(moveto["x"],moveto["y"],moveto["z"],"Move here to repair.")
        end

        if reapiring then return end
        reapiring = true
        
        local timeout = 20

        NetworkRequestControlOfEntity(targetVehicle)

        while not NetworkHasControlOfEntity(targetVehicle) and timeout > 0 do 
            NetworkRequestControlOfEntity(targetVehicle)
            Citizen.Wait(100)
            timeout = timeout -1
        end


        if dist < 1.5 then
            TriggerEvent("animation:repair",targetVehicle)
            fixingvehicle = true

            local repairlength = 1000

            if advanced then
                local timeAdded = 0
                for i=0,5 do
                    if IsVehicleTyreBurst(targetVehicle, i, false) then
                        if IsVehicleTyreBurst(targetVehicle, i, true) then
                            timeAdded = timeAdded + 1200
                        else
                           timeAdded = timeAdded + 800
                        end
                    end
                end
                local fuelDamage = 48000 - (math.ceil(fueltankhealth)*12)
                repairlength = ((3500 - (GetVehicleEngineHealth(targetVehicle) * 3) - (GetVehicleBodyHealth(targetVehicle)) / 2) * 5) + 2000
                repairlength = repairlength + timeAdded + fuelDamage
            else
                local timeAdded = 0
                for i=0,5 do
                    if IsVehicleTyreBurst(targetVehicle, i, false) then
                        if IsVehicleTyreBurst(targetVehicle, i, true) then
                            timeAdded = timeAdded + 1600
                        else
                           timeAdded = timeAdded + 1200
                        end
                    end
                end
                local fuelDamage = 48000 - (math.ceil(fueltankhealth)*12)
                repairlength = ((3500 - (GetVehicleEngineHealth(targetVehicle) * 3) - (GetVehicleBodyHealth(targetVehicle)) / 2) * 3) + 2000
                repairlength = repairlength + timeAdded + fuelDamage
            end



            local finished = exports["prp-taskbarskill"]:taskBar(15000,math.random(10,20))
            if finished ~= 100 then
                fixingvehicle = false
                reapiring = false
                ClearPedTasks(playerped)
                return
            end

            if finished == 100 then
                
                local myJob = exports["isPed"]:isPed("job")
                if myJob == "mecano" then

                    SetVehicleEngineHealth(targetVehicle, 1000.0)
                    SetVehicleBodyHealth(targetVehicle, 1000.0)
                    SetVehiclePetrolTankHealth(targetVehicle, 4000.0)

                    if math.random(100) > 95 then
                        TriggerEvent("inventory:removeItem","repairtoolkit",1)
                    end

                else

                    TriggerEvent('veh.randomDegredation',30,targetVehicle,3)

                    if advanced then
                        TriggerEvent("inventory:removeItem","advrepairkit", 1)
                        TriggerEvent('veh.randomDegredation',30,targetVehicle,3)
                        if GetVehicleEngineHealth(targetVehicle) < 900.0 then
                            SetVehicleEngineHealth(targetVehicle, 900.0)
                        end
                        if GetVehicleBodyHealth(targetVehicle) < 945.0 then
                            SetVehicleBodyHealth(targetVehicle, 945.0)
                        end

                        if fueltankhealth < 3800.0 then
                            SetVehiclePetrolTankHealth(targetVehicle, 3800.0)
                        end

                    else

                        local timer = math.ceil(GetVehicleEngineHealth(targetVehicle) * 5)
                        if timer < 2000 then
                            timer = 2000
                        end
                        local finished = exports["prp-taskbarskill"]:taskBar(timer,math.random(5,15))
                        if finished ~= 100 then
                            fixingvehicle = false
                            reapiring = false
                            ClearPedTasks(playerped)
                            return
                        end

                        if math.random(100) > 95 then
                            TriggerEvent("inventory:removeItem","repairtoolkit",1)
                        end

                        if GetVehicleEngineHealth(targetVehicle) < 200.0 then
                            SetVehicleEngineHealth(targetVehicle, 200.0)
                        end
                        if GetVehicleBodyHealth(targetVehicle) < 945.0 then
                            SetVehicleBodyHealth(targetVehicle, 945.0)
                        end

                        if fueltankhealth < 2900.0 then
                            SetVehiclePetrolTankHealth(targetVehicle, 2900.0)
                        end                        

                        if GetEntityModel(targetVehicle) == `BLAZER` then
                            SetVehicleEngineHealth(targetVehicle, 600.0)
                            SetVehicleBodyHealth(targetVehicle, 800.0)
                        end
                    end                    
                end

                for i = 0, 5 do
                    SetVehicleTyreFixed(targetVehicle, i) 
                end
            end
            ClearPedTasks(playerped)
        end
        fixingvehicle = false
    end
    reapiring = false
end)

-- Animations
RegisterNetEvent('animation:load')
AddEventHandler('animation:load', function(dict)
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end)

RegisterNetEvent('animation:repair')
AddEventHandler('animation:repair', function(veh)
    SetVehicleDoorOpen(veh, 4, 0, 0)
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
    end

    TaskTurnPedToFaceEntity(PlayerPedId(), veh, 1.0)
    Citizen.Wait(1000)

    while fixingvehicle do
        local anim3 = IsEntityPlayingAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 3)
        if not anim3 then
            TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        end
        Citizen.Wait(1)
    end
    SetVehicleDoorShut(veh, 4, 1, 1)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        BlockWeaponWheelThisFrame()
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(17)
        DisableControlAction(0, 37, true) --Disable Tab
    end
end)