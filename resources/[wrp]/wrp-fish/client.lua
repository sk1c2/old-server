local isFishing = false
local inZone = false
local cancel = false
local veh = 0
local canSpawn = true
local zones = {
    'OCEANA',
    'ELYSIAN',
    'CYPRE',
    'DELSOL',
    'LAGO',
    'ZANCUDO',
    'ALAMO',
    'NCHU',
    'CCREAK',
    'PALCOV',
    'PALETO',
    'PROCOB',
    'ELGORL',
    'SANCHIA',
    'PALHIGH',
    'DELBE',
    'PBLUFF',
    'SANDY',
    'GRAPES',
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local plyCords = GetEntityCoords(PlayerPedId())
        local dis = GetDistanceBetweenCoords(plyCords, 471.2034, 2607.535, 44.47722, true) 
        if dis <= 5 then
            DrawText3Ds(471.2034, 2607.535, 44.47722,'[E] Sell Fish')
            if IsControlJustReleased(0, 38) then
                if exports["wrp-inventory"]:hasEnoughOfItem("fish",2,false) then 
                    TriggerEvent("inventory:removeItem", "fish", 2)
                    local finished = exports["wrp-taskbar"]:taskBar(2000,"Selling Fish",true,false,playerVeh)
                    if finished == 100 then
                        SellItems(math.random(40,50))
                        Citizen.Wait(2000)
                    end
                elseif exports['wrp-inventory']:hasEnoughOfItem('fishingbass',2, false) then
                    TriggerEvent("inventory:removeItem", "fishingbass", 2)
                    exports["wrp-taskbar"]:taskBar(2000,"Selling Fish",true,false,playerVeh)
                    local ItemSell = math.random(50,60)
                    SellItems(ItemSell)
                    TriggerEvent('DoLongHudText', 'You have sold two bass for $' .. ItemSell .. '!')
                    Citizen.Wait(2000)
                elseif exports['wrp-inventory']:hasEnoughOfItem('fishingbluefish',2, false) then
                    TriggerEvent("inventory:removeItem", "fishingbluefish", 2)
                    exports["wrp-taskbar"]:taskBar(2000,"Selling Fish",true,false,playerVeh)
                    local ItemSell = math.random(40,60)
                    SellItems(ItemSell)
                    TriggerEvent('DoLongHudText', 'You have sold two blue fish for $' .. ItemSell .. '!')
                    Citizen.Wait(2000)
                elseif exports['wrp-inventory']:hasEnoughOfItem('fishingcod',2, false) then
                    TriggerEvent("inventory:removeItem", "fishingcod", 2)
                    exports["wrp-taskbar"]:taskBar(2000,"Selling Fish",true,false,playerVeh)
                    local ItemSell = math.random(50,100)
                    SellItems(ItemSell)
                    TriggerEvent('DoLongHudText', 'You have sold two cod for $' .. ItemSell .. '!')
                    Citizen.Wait(2000)
                elseif exports['wrp-inventory']:hasEnoughOfItem('fishingwhale',2, false) then
                    TriggerEvent("inventory:removeItem", "fishingwhale", 2)
                    exports["wrp-taskbar"]:taskBar(2000,"Selling Fish",true,false,playerVeh)
                    local ItemSell = math.random(400,500)
                    SellItems(ItemSell)
                    TriggerEvent('DoLongHudText', 'You have sold two baby whales for $' .. ItemSell .. '!')
                    Citizen.Wait(2000)
                elseif exports['wrp-inventory']:hasEnoughOfItem('fishingdolphin',2, false) then
                    TriggerEvent("inventory:removeItem", "fishingdolphin", 2)
                    exports["wrp-taskbar"]:taskBar(2000,"Selling Fish",true,false,playerVeh)
                    local ItemSell = math.random(250,400)
                    SellItems(ItemSell)
                    TriggerEvent('DoLongHudText', 'You have sold two dolphins for $' .. ItemSell .. '!')
                    Citizen.Wait(2000)
                elseif exports['wrp-inventory']:hasEnoughOfItem('fishingshark',2, false) then
                    TriggerEvent("inventory:removeItem", "fishingshark", 2)
                    exports["wrp-taskbar"]:taskBar(2000,"Selling Fish",true,false,playerVeh)
                    local ItemSell = math.random(300,500)
                    SellItems(ItemSell)
                    TriggerEvent('DoLongHudText', 'You have sold two baby sharks for $' .. ItemSell .. '!')
                    Citizen.Wait(2000)
                else 
                    TriggerEvent('DoLongHudText', 'You dont have enough fish in your pockets to sell!', 2)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local Getmecuh = PlayerPedId()
		local drawtext2 = "[E] Rent A Boat ($500)"
		local x,y,z =  -3424.41, 982.81, 8.43
		local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z ,false)
        local car = GetHashKey('marquis')
        if distance <= 5 and veh == 0 then
			DrawText3Ds(x,y,z, drawtext2) 
            if IsControlJustReleased(0, 38) then
                if canSpawn == true then
                    TriggerEvent('wrp-base:getdata', 500)
                    Citizen.Wait(500)
                        canSpawn = false
                        RequestModel(car)
                        while not HasModelLoaded(car) do
                            Citizen.Wait(0)
                        end
                        veh = CreateVehicle(car, -3448.48, 971.98, 1.91, 0.0, true, false)
                        SetEntityAsMissionEntity(veh, true, true)
                        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                        TriggerServerEvent('garage:addKeys', GetVehicleNumberPlateText(veh))
                    elseif Player.cash < 500 then
                        TriggerEvent('DoLongHudText', 'You cant afford the Deposit!', 2)
                    end
                else
                    TriggerEvent('DoLongHudText', 'Vehicle is already out!', 2)
                end
		    else
			if distance >= 1.2 then
				Citizen.Wait(1000)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local Getmecuh = PlayerPedId()
		local drawtext2 = '[E] Return the Boat'
		local x,y,z =  -3424.41, 982.81, 8.43
		local plyCoords = GetEntityCoords(Getmecuh)
		local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z ,false)
        if distance <= 20 and veh ~= 0 then
			DrawText3Ds(x,y,z, drawtext2) 
            if IsControlJustReleased(0, 38) then
                DeleteVehicle(veh)
                veh = 0
                TriggerEvent('DoLongHudText', 'Vehicle Returned', 1)
                SetEntityCoords(GetPlayerPed(-1), -3424.41, 982.81, 8.43)
                Citizen.Wait(2000)
                canSpawn = true
            end 
		else
			if distance >= 1.2 then
				Citizen.Wait(1000)	
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local Getmecuh = PlayerPedId()
		local drawtext2 = "[E] Rent A Boat ($500)"
		local x,y,z =  1308.91, 4362.29, 41.55
		local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z ,false)
        local car = GetHashKey('suntrap')
        if distance <= 5 and veh == 0 then
			DrawText3Ds(x,y,z, drawtext2) 
            if IsControlJustReleased(0, 38) then
                if canSpawn == true then
                    TriggerEvent('wrp-base:getdata', 500)
                    Citizen.Wait(500)
                        canSpawn = false
                        RequestModel(car)
                        while not HasModelLoaded(car) do
                            Citizen.Wait(0)
                        end
                        veh = CreateVehicle(car, 1299.69, 4194.82, 30.91, 0.0, true, false)
                        SetEntityAsMissionEntity(veh, true, true)
                        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                        TriggerServerEvent('garage:addKeys', GetVehicleNumberPlateText(veh))
                    elseif Player.cash < 500 then
                        TriggerEvent('DoLongHudText', 'You cant afford the Deposit!', 2)
                    end
                else
                TriggerEvent('DoLongHudText', 'Vehicle is already out!', 2)
            end
		else
			if distance >= 1.2 then
				Citizen.Wait(1000)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local Getmecuh = PlayerPedId()
		local drawtext2 = '[E] Return the Boat'
		local x,y,z =  1302.839, 4225.832, 33.9087
		local plyCoords = GetEntityCoords(Getmecuh)
		local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z ,false)
        if distance <= 20 and veh ~= 0 then
			DrawText3Ds(x,y,z, drawtext2) 
            if IsControlJustReleased(0, 38) then
                DeleteVehicle(veh)
                veh = 0
                TriggerEvent('DoLongHudText', 'Vehicle Returned', 1)
                SetEntityCoords(GetPlayerPed(-1), 1302.839, 4225.832, 33.9087)
                Citizen.Wait(2000)
                canSpawn = true
            end
		else
			if distance >= 1.2 then
				Citizen.Wait(1000)
				
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local Getmecuh = PlayerPedId()
		local drawtext2 = "[E] Rent A Boat ($500)"
		local x,y,z =  3807.98, 4478.62, 6.37
		local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z ,false)
        local car = GetHashKey('tropic')
        if distance <= 5 and veh == 0 then
			DrawText3Ds(x,y,z, drawtext2) 
            if IsControlJustReleased(0, 38) then
                if canSpawn == true then
                    TriggerEvent('wrp-base:getdata', 500)
                    Citizen.Wait(500)
                        canSpawn = false
                        RequestModel(car)
                        while not HasModelLoaded(car) do
                            Citizen.Wait(0)
                        end
                        veh = CreateVehicle(car, 3865.89, 4476.66, 1.53, 0.0, true, false)
                        boat = GetVehicleNumberPlateText(vehicle)
                        SetEntityAsMissionEntity(veh, true, true)
                        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                        TriggerServerEvent('garage:addKeys', GetVehicleNumberPlateText(veh))
                    elseif Player.cash < 500 then
                        TriggerEvent('DoLongHudText', 'You cant afford the Deposit!', 2)
                    end
                else
                    TriggerEvent('DoLongHudText', 'Vehicle is already out!', 2)
                end
		    else
			if distance >= 1.2 then
				Citizen.Wait(1000)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local Getmecuh = PlayerPedId()
		local drawtext2 = "[E] Return the Boat"
		local x,y,z = 3865.944, 4463.568, 2.73844
		local plyCoords = GetEntityCoords(Getmecuh)
		local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z ,false)
        if distance <= 20 and veh ~= 0 then
			DrawText3Ds(x,y,z, drawtext2) 
            if IsControlJustReleased(0, 38) then
                DeleteVehicle(veh)
                veh = 0
                TriggerEvent('DoLongHudText', 'Vehicle Returned', 1)
                SetEntityCoords(GetPlayerPed(-1), 3865.944, 4463.568, 2.73844)
                Citizen.Wait(2000)
                canSpawn = true
            end
		else
			if distance >= 1.2 then
				Citizen.Wait(1000)
			end
		end
	end
end)
--- suntrap tropic marquis

RegisterNetEvent('wrp-fish:lego')
AddEventHandler('wrp-fish:lego', function()
    if isFishing == false then
        StartFish()
    elseif isFishing == true then
        TriggerEvent('DoLongHudText', 'You are already fishing dingus.', 2)
    end
end)

function checkZone()
    local ply = PlayerPedId()
    local coords = GetEntityCoords(ply)
    local currZone = GetNameOfZone(coords)
    for k,v in pairs(zones) do
        if currZone == v then
            inZone = true
            break
        else
            inZone = false
        end
    end
    
end

function StartFish()
    local ply = PlayerPedId()
    local onBoat = false
    local function GetEntityBelow()
        local Ent = nil
        local CoA = GetEntityCoords(ply, 1)
        local CoB = GetOffsetFromEntityInWorldCoords(ply, 0.0, 0.0, 5.0)
        local RayHandle = CastRayPointToPoint(CoA.x, CoA.y, CoA.z, CoB.x, CoB.y, CoB.z, 10, ply, 0)
        local A,B,C,D,Ent = GetRaycastResult(RayHandle)
        return Ent
    end
    local boat = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.000, 0, 12294)
    checkZone()
    Citizen.Wait(250)
    if IsEntityInWater(boat) and IsPedSwimming(ply) == false and inZone == true then
        if exports["wrp-inventory"]:hasEnoughOfItem('fishingrod',1,false) then
            isFishing = true
            cancel = false
            Fish()
        end
    elseif IsEntityInWater(ply) and IsPedSwimming(ply) == false and inZone == true then 
        if exports["wrp-inventory"]:hasEnoughOfItem('fishingrod',1,false) then
            isFishing = true
            cancel = false
            Fish()
        end
    end
end  


function Fish()
    if cancel == false then
        local ply = PlayerPedId()
       --playerAnim() 
        TaskStartScenarioInPlace(ply, 'WORLD_HUMAN_STAND_FISHING', 0, true)
        timer = math.random(10000,30000)
        Citizen.Wait(timer)
        Catch()
    end
end

function Repeat()
    timer = math.random(10000,30000)
    if cancel == false then
        Citizen.Wait(timer)
        Catch()
    end
end

function Catch()
    if cancel == false then
        local ply = PlayerPedId()
        TriggerEvent('DoLongHudText', 'There is a fish on the line.', 1)
        local finished = exports["wrp-taskbarskill"]:taskBar(math.random(1000,2000),math.random(15,20))
        if finished == 100 then
            local finished2 = exports["wrp-taskbarskill"]:taskBar(3000,math.random(2,5))
            if finished2 == 100 then
                isFishing = false
                local rdn = math.random(1,100)
                if rdn <= 4 then
                    TriggerEvent("inventory:removeItem", "fishingrod", 1)
                    SetCurrentPedWeapon(ply, `WEAPON_UNARMED`, true)
                    ClearPedTasksImmediately(ply)
                elseif rdn > 4 then
                    TriggerEvent('DoLongHudText', 'You caught a Fish!', 1)
                    TriggerServerEvent('wrp-fish:getFish')
                    SetCurrentPedWeapon(ply, `WEAPON_UNARMED`, true)
                    ClearPedTasksImmediately(ply)
                end
            elseif finished or finished2 ~= 100 then
                TriggerEvent('DoLongHudText', 'The fish got away.', 2)
                Repeat()
            else
                isFishing = false
            end
        else
            SetCurrentPedWeapon(ply, `WEAPON_UNARMED`, true)
            ClearPedTasksImmediately(ply)
            isFishing = false
        end
    end
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

function SellItems(sellfish)
    TriggerServerEvent('fish:returnDepo', sellfish)
    Citizen.Wait(2000)
    if sellfish > 2000 then
        TriggerServerEvent('wrp-ac:sort')
    end
end


local blips = {
    {title="Chumash Boat Rental", colour=3, id=356, scale=0.7, x = -3424.41, y = 982.81, z = 8.43},
    {title="North Boat Rental", colour=3, id=356, scale=0.7, x = 1308.91, y = 4362.29, z = 41.55},
    {title="Catfish View Boat Rental", colour=3, id=356, scale=0.7, x = 3807.98, y = 4478.62, z = 6.37},
 }
     
Citizen.CreateThread(function()
   for _, info in pairs(blips) do
     info.blip = AddBlipForCoord(info.x, info.y, info.z)
     SetBlipSprite(info.blip, info.id)
     SetBlipDisplay(info.blip, 4)
     SetBlipScale(info.blip, info.scale)
     SetBlipColour(info.blip, info.colour)
     SetBlipAsShortRange(info.blip, true)
     BeginTextCommandSetBlipName("STRING")
     AddTextComponentString(info.title)
     EndTextCommandSetBlipName(info.blip)
   end
end)