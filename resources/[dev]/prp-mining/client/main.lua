local PlayerData                = {}
GRPCore                             = nil

local blip1 = {}
local blips = false
local blipActive = false
local mineActive = false
local washingActive = false
local remeltingActive = false
local firstspawn = false
local impacts = 0
local timer = 0
local locations = {
    { ['x'] = -591.47,  ['y'] = 2076.52,  ['z'] = 131.37},
    { ['x'] = -590.35,  ['y'] = 2071.76,  ['z'] = 131.29},
    { ['x'] = -589.61,  ['y'] = 2069.3,  ['z'] = 131.19},
    { ['x'] = -588.6,  ['y'] = 2064.03,  ['z'] = 130.96},
}

Citizen.CreateThread(function()
    while GRPCore == nil do
      TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)
      Citizen.Wait(0)
    end
end)  

RegisterNetEvent('grp:playerLoaded')
AddEventHandler('grp:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('grp:setJob')
AddEventHandler('grp:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent("grp_miner:washing")
AddEventHandler("grp_miner:washing", function()
    Washing()
end)

RegisterNetEvent("grp_miner:remelting")
AddEventHandler("grp_miner:remelting", function()
    Remelting()
end)

RegisterNetEvent('grp_miner:timer')
AddEventHandler('grp_miner:timer', function()
    local timer = 0
    local ped = PlayerPedId()
    
    Citizen.CreateThread(function()
		while timer > -1 do
			Citizen.Wait(150)

			if timer > -1 then
				timer = timer + 1
            end
            if timer == 100 then
                break
            end
		end
    end) 

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.WashingX, Config.WashingY, Config.WashingZ, true) < 5 then
                Draw3DText( Config.WashingX, Config.WashingY, Config.WashingZ+0.5 -1.400, ('Washing stones in progress ' .. timer .. '%'), 4, 0.1, 0.1)
            end
            if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ, true) < 5 then
                Draw3DText( Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ+0.5 -1.400, ('Remelting stones in progress ' .. timer .. '%'), 4, 0.1, 0.1)
            end
            if timer == 100 then
                timer = 0
                break
            end
        end
    end)
end)

RegisterNetEvent('grp_miner:createblips')
AddEventHandler('grp_miner:createblips', function()
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
                if blips == true and blipActive == false then
                    blip1 = AddBlipForCoord(-597.01, 2091.42, 131.41)
                    blip2 = AddBlipForCoord(Config.WashingX, Config.WashingY, Config.WashingZ)
                    blip3 = AddBlipForCoord(Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ)
                    blip4 = AddBlipForCoord(Config.SellX, Config.SellY, Config.SellZ)
                    SetBlipSprite(blip1, 365)
                    SetBlipColour(blip1, 5)
                    SetBlipAsShortRange(blip1, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Mine")
                    EndTextCommandSetBlipName(blip1)   
                    SetBlipSprite(blip2, 365)
                    SetBlipColour(blip2, 5)
                    SetBlipAsShortRange(blip2, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Washing stones")
                    EndTextCommandSetBlipName(blip2)   
                    SetBlipSprite(blip3, 365)
                    SetBlipColour(blip3, 5)
                    SetBlipAsShortRange(blip3, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Remelting stones")
                    EndTextCommandSetBlipName(blip3)
                    SetBlipSprite(blip4, 272)
                    SetBlipColour(blip4, 5)
                    SetBlipAsShortRange(blip4, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Selling items")
                    EndTextCommandSetBlipName(blip4)    
                    blipActive = true
                elseif blips == false and blipActive == false then
                    RemoveBlip(blip1)
                    RemoveBlip(blip2)
                    RemoveBlip(blip3)
                end
        end
    end)
end)

Citizen.CreateThread(function()
    blip1 = AddBlipForCoord(-596.3391, 2089.087, 131.4126)
    SetBlipSprite(blip1, 365)
    SetBlipColour(blip1, 5)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mines")
    EndTextCommandSetBlipName(blip1)   
end)

Citizen.CreateThread(function()
    blip1 = AddBlipForCoord(1916.2, 582.44, 176.3669)
    SetBlipSprite(blip1, 365)
    SetBlipColour(blip1, 5)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Wash Stone")
    EndTextCommandSetBlipName(blip1)   
end)

Citizen.CreateThread(function()
    blip1 = AddBlipForCoord(1084.172, -2002.115, 31.39398)
    SetBlipSprite(blip1, 365)
    SetBlipColour(blip1, 5)
    SetBlipAsShortRange(blip1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Smeltery")
    EndTextCommandSetBlipName(blip1)   
end)

-- Citizen.CreateThread(function()
--     while true do
-- 	local ped = PlayerPedId()
--         Citizen.Wait(1)
--             if PlayerData.job ~= nil and PlayerData.job.name == 'miner' and not IsEntityDead( ped ) then
--                 if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.CloakroomX, Config.CloakroomY, Config.CloakroomZ, true) < 1 then
--                     DrawMarker(20, Config.CloakroomX, Config.CloakroomY, Config.CloakroomZ, 0, 0, 0, 0, 0, 90.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
--                         if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.CloakroomX, Config.CloakroomY, Config.CloakroomZ, true) < 1 then
--                             GRPCore.ShowHelpNotification('Press ~INPUT_CONTEXT~ to access the miner cloakroom.')
--                                 if IsControlJustReleased(1, 51) then
--                                     Cloakroom() 
--                                 end
--                             end
--                         end
--                     end
--                 end
--             end)

Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
            for i=1, #locations, 1 do
            if GetDistanceBetweenCoords(GetEntityCoords(ped), locations[i].x, locations[i].y, locations[i].z, true) < 1 and mineActive == false then
                DrawMarker(20, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 100.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                    if GetDistanceBetweenCoords(GetEntityCoords(ped), locations[i].x, locations[i].y, locations[i].z, true) < 1 then
                     --   GRPCore.ShowHelpNotification("Press ~INPUT_CONTEXT~ to start mining.")
                            if IsControlJustReleased(1, 51) then
                                if exports['prp-inventory']:hasEnoughOfItem('pickaxe', 1) then
                                Animation()
                                local finished = exports["prp-taskbar"]:taskBar(13000,"⛏️ Mining Ore ⛏️")
                                mineActive = true

                            end
                        end
                    end
            end
        end
    end
end)



Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
        if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.WashingX, Config.WashingY, Config.WashingZ, true) < 3 and washingActive == false then
            DrawMarker(20, Config.WashingX, Config.WashingY, Config.WashingZ, 0, 0, 0, 0, 0, 55.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.WashingX, Config.WashingY, Config.WashingZ, true) < 1 then
                 --    GRPCore.ShowHelpNotification("Press ~INPUT_CONTEXT~ to wash the stones.")
                        if IsControlJustReleased(1, 51) then
                            if exports['prp-inventory']:hasEnoughOfItem('washpan', 1) then
                            if exports['prp-inventory']:hasEnoughOfItem('stone', 1) then
                            TriggerEvent("loopUpdateItems")
                            local finished = exports["prp-taskbar"]:taskBar(10000,"Washing Stones",true,false,playerVeh)
                            TriggerEvent("inventory:removeItem", "stone", 2)
                            TriggerEvent("prp-banned:getID","washedstone", 2)
                            -- TriggerServerEvent("grp_miner:washing")
                         end
                    end    
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
        if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ, true) < 25 and remeltingActive == false then
            DrawMarker(20, Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ, 0, 0, 0, 0, 0, 55.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ, true) < 1 then
                  -- GRPCore.ShowHelpNotification("Press ~INPUT_CONTEXT~ to remelting stones.")
                        if IsControlJustReleased(1, 51) then 
                            if exports['prp-inventory']:hasEnoughOfItem('washedstone', 1) then
                            local finished = exports["prp-taskbar"]:taskBar(5000,"Smelting Stone")
                            TriggerEvent('loopUpdateItems')
                            Citizen.Wait(1500)
                            TriggerEvent( "prp-banned:getID", "minedgoods", 2)
                            TriggerEvent("inventory:removeItem", "washedstone", 2)
                            TriggerEvent('loopUpdateItems')
                        --   TriggerServerEvent("grp_miner:remelting")  
                            end
                    end
                end
            end
        end
    end)

   

-- Citizen.CreateThread(function()
--     while true do
-- 	local ped = PlayerPedId()
--         Citizen.Wait(1)
--             if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.SellX, Config.SellY, Config.SellZ, true) < 2 then
--                 GRPCore.ShowHelpNotification("Press ~INPUT_CONTEXT~ to sell items.")
--                     if IsControlJustReleased(1, 51) then
--                         Jeweler()                          
--             end
--         end
--     end
--  end)
    

Citizen.CreateThread(function()
    local hash = GetHashKey("ig_natalia")

    if not HasModelLoaded(hash) then
        RequestModel(hash)
        Citizen.Wait(100)
    end

    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end

    if firstspawn == false then
        local npc = CreatePed(6, hash, Config.SellX, Config.SellY, Config.SellZ, 129.0, false, false)
        SetEntityInvincible(npc, true)
        FreezeEntityPosition(npc, true)
        SetPedDiesWhenInjured(npc, false)
        SetPedCanRagdollFromPlayerImpact(npc, false)
        SetPedCanRagdoll(npc, false)
        SetEntityAsMissionEntity(npc, true, true)
        SetEntityDynamic(npc, true)
    end
end)

-- function Cloakroom()
--     local elements = {
--         {label = 'Civilian clothes',   value = 'cloakroom1'},
--         {label = 'Work clothes',      value = 'cloakroom2'},
--         {label = 'Work car',       value = 'vehicle'},
--     }

--     GRPCore.UI.Menu.CloseAll()

--     GRPCore.UI.Menu.Open('default', GetCurrentResourceName(), 'miner_actions', {
--         title    = 'Miner',
--         align    = 'top-left',
--         elements = elements
--     }, function(data, menu)
--         if data.current.value == 'cloakroom1' then
--             menu.close()
--             GRPCore.TriggerServerCallback('grp_skin:getPlayerSkin', function(skin, jobSkin)
--                 TriggerEvent('skinchanger:loadSkin', skin)
--             end)  
--             blips = false
--             blipActive = false
--             TriggerEvent("grp_miner:createblips")
--         elseif data.current.value == 'cloakroom2' then
--             menu.close()
--             GRPCore.TriggerServerCallback('grp_skin:getPlayerSkin', function(skin, jobSkin)
--                 if skin.sex == 0 then
--                     TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
--                 else
--                     TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
--                 end
--                 blips = true
--                 TriggerEvent("grp_miner:createblips")
--             end)
--         elseif data.current.value == 'vehicle' then
--             menu.close()
--             RequestModel("rumpo3")
--             Citizen.Wait(100)
--             CreateVehicle("rumpo3", -283.49, 2533.76, 72.67, 0.0, true, true)
--             GRPCore.ShowNotification("The vehicle was pulled out of the garage.")
--         end
--     end)
-- end

-- function Jeweler()
--     local elements = {
--         {label = 'Sell diamonds',   value = 'diamonds'},
--         {label = 'Sell gold',      value = 'gold'},
--         {label = 'Sell iron',       value = 'iron'},
--         {label = 'Sell copper',       value = 'copper'},
--     }

--     GRPCore.UI.Menu.CloseAll()

--     GRPCore.UI.Menu.Open('default', GetCurrentResourceName(), 'jeweler_actions', {
--         title    = 'Jubiler - sprzedaż',
--         align    = 'top-left',
--         elements = elements
--     }, function(data, menu)
--         if data.current.value == 'diamonds' then
--             menu.close()
--             TriggerServerEvent("grp_miner:selldiamond")
--         elseif data.current.value == 'gold' then
--             menu.close()
--             TriggerServerEvent("grp_miner:sellgold")
--         elseif data.current.value == 'iron' then
--             menu.close()
--             TriggerServerEvent("grp_miner:selliron")
--         elseif data.current.value == 'copper' then
--             menu.close()
--             TriggerServerEvent("grp_miner:sellcopper")
--         end
--     end)
-- end

function Animation()
    Citizen.CreateThread(function()
        while impacts < 5 do
            Citizen.Wait(1)
		local ped = PlayerPedId()
        if exports['prp-inventory']:hasEnoughOfItem('pickaxe', 1) then
                RequestAnimDict("melee@large_wpn@streamed_core")
                Citizen.Wait(100)
                TaskPlayAnim((ped), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 8.0, 8.0, -1, 80, 0, 0, 0, 0)
                SetEntityHeading(ped, 270.0)
                TriggerServerEvent('InteractSound_SV:PlayOnSource', 'pickaxe', 0.5)
                if impacts == 0 then
                    pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true) 
                    AttachEntityToEntity(pickaxe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.18, -0.02, -0.02, 350.0, 100.00, 140.0, true, true, false, true, 1, true)
                end  
                Citizen.Wait(2500)
                ClearPedTasks(ped)
                impacts = impacts+1
                if impacts == 5 then
                    DetachEntity(pickaxe, 1, true)
                    DeleteEntity(pickaxe)
                    DeleteObject(pickaxe)
                    mineActive = false
                    impacts = 0
                    TriggerEvent( "prp-banned:getID", "stone", 2)
                    -- TriggerServerEvent("grp_miner:givestone")
                    break
                end        
            end
        end
    end)
end



function Washing()
    local ped = PlayerPedId()
    RequestAnimDict("amb@prop_human_bum_bin@idle_a")
    washingActive = true
    Citizen.Wait(100)
    FreezeEntityPosition(ped, true)
    TaskPlayAnim((ped), 'amb@prop_human_bum_bin@idle_a', 'idle_a', 8.0, 8.0, -1, 81, 0, 0, 0, 0)
    TriggerEvent("grp_miner:timer")
    Citizen.Wait(15900)
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
    washingActive = false
end

function Remelting()
    local ped = PlayerPedId()
    RequestAnimDict("amb@prop_human_bum_bin@idle_a")
    remeltingActive = true
    Citizen.Wait(100)
    FreezeEntityPosition(ped, true)
    TaskPlayAnim((ped), 'amb@prop_human_bum_bin@idle_a', 'idle_a', 8.0, 8.0, -1, 81, 0, 0, 0, 0)
    TriggerEvent("grp_miner:timer")
    Citizen.Wait(15900)
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
    remeltingActive = false
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100 
    SetTextScale(0.35, 0.35)
    SetTextFont(fontId)
    SetTextProportional(0)
    SetTextColour(255, 255, 255, 215)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()   
end
