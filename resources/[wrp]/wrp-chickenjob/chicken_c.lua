local startX = 2388.725 
local startY = 5044.985
local startZ = 46.304

local converterX = -96.007   
local converterY = 6206.92
local converterZ = 31.02

local converterX2 = -100.64  
local converterY2 = 6202.30
local converterZ2 = 31.02

local packingX = -106.44 
local packingY = 6204.29
local packingZ = 31.02

local packingX2 = -104.20 
local packingY2 = 6206.45
local packingZ2 = 31.02

local sellX = -328.14
local sellY = -2700.65
local sellZ = 7.55


local chicken1
local chicken2
local chicken3
local Zlapany1 = 0
local Zlapany2 = 0
local Zlapany3 = 0
local splashed = 0
local share = false
local prop
local packedintothecar = false
local carton
local meat
local packs = 0

local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
		job = exports['isPed']:isPed('job')
		if job == 'Chicken' then
            havingchickenstartJob = true
            if chickenstartHQBlip == nil or chickenstartHQBlip == 0 then
                chickenstartHQBlip = AddBlipForCoord(startX, startY, startZ)
                SetBlipSprite(chickenstartHQBlip, 126)
                SetBlipDisplay(chickenstartHQBlip, 4)
                SetBlipScale(chickenstartHQBlip, 0.7)
                SetBlipColour(chickenstartHQBlip, 46)
                SetBlipAsShortRange(chickenstartHQBlip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Chicken Farm")
                EndTextCommandSetBlipName(chickenstartHQBlip)
            end    
        else
            havingchickenstartJob = false
            if chickenstartHQBlip ~= nil or chickenstartHQBlip ~= 0 then
                RemoveBlip(chickenstartHQBlip)
                chickenstartHQBlip = 0
            end
        end
    end
end)

Citizen.CreateThread(function()
 local rzeznia = AddBlipForCoord(converterX, converterY, converterZ)
     SetBlipSprite (rzeznia, 463)
     SetBlipDisplay(rzeznia, 4)
     SetBlipScale  (rzeznia, 0.8)
     SetBlipColour (rzeznia, 1)
     SetBlipAsShortRange(rzeznia, true)
     BeginTextCommandSetBlipName("STRING")
     AddTextComponentString('Slaughterhouse')
     EndTextCommandSetBlipName(rzeznia)
 local skupk = AddBlipForCoord(sellX, sellY, sellZ)
     SetBlipSprite (skupk, 478)
     SetBlipDisplay(skupk, 4)
     SetBlipScale  (skupk, 0.6)
     SetBlipColour (skupk, 46)
     SetBlipAsShortRange(skupk, true)
     BeginTextCommandSetBlipName("STRING")
     AddTextComponentString('Chicken Dealer')
     EndTextCommandSetBlipName(skupk)
 end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawText3D2(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
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
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end

Citizen.CreateThread(function()
    while true do
	Citizen.Wait(0)
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, startX, startY, startZ)

		if dist <= 2.0 then
		job = exports['isPed']:isPed('job')
		if job == 'Chicken' then
		DrawMarker(27, startX, startY, startZ-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
		else
		Citizen.Wait(1500)
		end
		
		if dist <= 2.5 then
		DrawText3D2(startX, startY, startZ, "~g~[E]~w~ To start catching chickens")
		end

		if dist <= 0.5 then
			if IsControlJustPressed(0, Keys['E']) then -- "E"
			Lapchickena()
			  end 
			end			
		end
	end
end)

Citizen.CreateThread(function()
    while true do
	Citizen.Wait(0)
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, converterX, converterY, converterZ)
		local distP = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, packingX, packingY, packingZ)
		local distP2 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, packingX2, packingY2, packingZ2)

		if dist <= 25.0 then
		job = exports['isPed']:isPed('job')
		if job == 'Chicken' then
		DrawMarker(27, converterX, converterY, converterZ-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
		DrawMarker(27, packingX, packingY, packingZ-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
		DrawMarker(27, packingX2, packingY2, packingZ2-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
		else
		Citizen.Wait(1500)
		end
		
		if dist <= 1.0 then
		DrawText3D2(converterX, converterY, converterZ, "~g~[E]~w~ To portion the chicken")
		end

		if dist <= 0.5 then
			if IsControlJustPressed(0, Keys['E']) then
			Portionthechicken(1)
			end			
		end
	
		--
		if distP <= 1.0 and packs == 0 then
		DrawText3D2(packingX, packingY, packingZ, "~g~[E]~w~ To pack chicken")
		elseif distP <= 1.0 and packs == 1 then
		DrawText3D2(packingX, packingY, packingZ, "~g~[G]~w~ To stop packing")
		DrawText3D2(packingX, packingY, packingZ+0.1, "~g~[E]~w~ To keep packing")
		end

		if distP <= 0.5 then
			if IsControlJustPressed(0, Keys['E']) then 
			packingchicken(1)
			elseif IsControlJustPressed(0, Keys['G']) then
			StopPacking(1)
			end			
		end
		
		if distP2 <= 2.0 and packs == 0 then
		DrawText3D2(packingX2, packingY2, packingZ2, "~g~[E]~w~ To pack chicken")
		elseif distP2 <= 2.0 and packs == 1 then
		DrawText3D2(packingX2, packingY2, packingZ2, "~g~[G]~w~ To stop packing")
		DrawText3D2(packingX2, packingY2, packingZ2+0.1, "~g~[E]~w~ To keep packing")
		end

		if distP2 <= 0.5 then
			if IsControlJustPressed(0, Keys['E']) then
			packingchicken(2)
			elseif IsControlJustPressed(0, Keys['G']) then
			StopPacking(2)
			end 
			end		
		end	
	end
end)

function packingchicken(position)
if exports["wrp-inventory"]:getQuantity("slaughtered_chicken") >= 2 then
	SetEntityHeading(GetPlayerPed(-1), 40.0)
	local PedCoords = GetEntityCoords(GetPlayerPed(-1))
	meat = CreateObject(GetHashKey('prop_cs_steak'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
	AttachEntityToEntity(meat, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 0x49D9), 0.15, 0.0, 0.01, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	carton = CreateObject(GetHashKey('prop_cs_clothes_box'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
	AttachEntityToEntity(carton, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.13, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)
	packs = 1
	LoadDict("anim@heists@ornate_bank@grab_cash_heels")
	TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
	FreezeEntityPosition(GetPlayerPed(-1), true)
	TriggerEvent('inventory:removeItem', "slaughtered_chicken", 2)
	exports['wrp-taskbar']:taskBar(7500, 'Putting the chicken in the box')
	TriggerEvent('wrp-banned:getID', "packaged_chicken", 1)
	ClearPedTasks(GetPlayerPed(-1))
	DeleteEntity(carton)
	DeleteEntity(meat)
else
	TriggerEvent('DoLongHudText', 'You have nothing to pack!', 2)
	end
end

function StopPacking(position)
	FreezeEntityPosition(GetPlayerPed(-1), false)
	packedintothecar = true
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	while packedintothecar do
	Citizen.Wait(250)
	packedintothecar = false
	Citizen.Wait(900)
	ClearPedTasks(GetPlayerPed(-1))
	DeleteEntity(prop)
	end
end

function Portionthechicken(position)
if exports["wrp-inventory"]:getQuantity("alive_chicken") >= 1 then
local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
	LoadDict(dict)
	FreezeEntityPosition(GetPlayerPed(-1),true)
	TaskPlayAnim(GetPlayerPed(-1), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
	local PedCoords = GetEntityCoords(GetPlayerPed(-1))
	prop = CreateObject(GetHashKey('prop_knife'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
	AttachEntityToEntity(prop, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 0xDEAD), 0.13, 0.14, 0.09, 40.0, 0.0, 0.0, false, false, false, false, 2, true)
	if position == 1 then
	SetEntityHeading(GetPlayerPed(-1), 311.0)
	chicken = CreateObject(GetHashKey('prop_int_cf_chick_01'),-94.87, 6207.008, 30.08, true, true, true)
	SetEntityRotation(chicken,90.0, 0.0, 45.0, 1,true)
	TriggerEvent('inventory:removeItem', "alive_chicken", 1)
	exports['wrp-taskbar']:taskBar(10000, 'Cutting the Rooster')
end
	TriggerEvent('DoLongHudText', 'You slaughtered a chicken!', 1)
	FreezeEntityPosition(GetPlayerPed(-1),false)
	DeleteEntity(chicken)
	DeleteEntity(prop)
	ClearPedTasks(GetPlayerPed(-1))
	TriggerEvent('wrp-banned:getID', "slaughtered_chicken", 2)
else
	TriggerEvent('DoLongHudText', 'You dont have any chickens!', 2)
	end
end

function Lapchickena()
DoScreenFadeOut(500)
Citizen.Wait(500)
SetEntityCoordsNoOffset(GetPlayerPed(-1), 2385.963, 5047.333, 46.400, 0, 0, 1)
RequestModel(GetHashKey('a_c_hen'))
while not HasModelLoaded(GetHashKey('a_c_hen')) do
Wait(1)
end
chicken1 = CreatePed(26, "a_c_hen", 2370.262, 5052.913, 46.437, 276.351, true, false)

chicken2 = CreatePed(26, "a_c_hen", 2372.040, 5059.604, 46.444, 223.595, true, false)
chicken3 = CreatePed(26, "a_c_hen", 2379.192, 5062.992, 46.444, 195.477, true, false)
TaskReactAndFleePed(chicken1, GetPlayerPed(-1))
TaskReactAndFleePed(chicken2, GetPlayerPed(-1))
TaskReactAndFleePed(chicken3, GetPlayerPed(-1))
Citizen.Wait(500)
DoScreenFadeIn(500)
share = true
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(5)
	
if share == true then
	local chicken1Coords = GetEntityCoords(chicken1)
	local chicken2Coords = GetEntityCoords(chicken2)
	local chicken3Coords = GetEntityCoords(chicken3)
	local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
    local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, chicken1Coords.x, chicken1Coords.y, chicken1Coords.z)
	local dist2 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, chicken2Coords.x, chicken2Coords.y, chicken2Coords.z)
	local dist3 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, chicken3Coords.x, chicken3Coords.y, chicken3Coords.z)
	
	if splashed == 3 then
	Zlapany1 = 0
	Zlapany2 = 0
	Zlapany3 = 0
	splashed = 0
	share = false
	TriggerEvent('DoLongHudText', 'Take the chickens to The Slaughter House', 1)
	end
	
	if dist <= 1.0 then
	DrawText3D2(chicken1Coords.x, chicken1Coords.y, chicken1Coords.z+0.5, "~o~[E]~b~ Catch the chicken")
		if IsControlJustPressed(0, Keys['E']) then 
		Zlapany1 = 1
		Hewascaught()
		end	
	elseif dist2 <= 1.0 then
		DrawText3D2(chicken2Coords.x, chicken2Coords.y, chicken2Coords.z+0.5, "~o~[E]~b~ Catch the chicken")
		if IsControlJustPressed(0, Keys['E']) then 
		Zlapany2 = 1
		Hewascaught()
		end	
	elseif dist3 <= 1.0 then
		DrawText3D2(chicken3Coords.x, chicken3Coords.y, chicken3Coords.z+0.5, "~o~[E]~b~ Catch the chicken")
		if IsControlJustPressed(0, Keys['E']) then 
		Zlapany3 = 1
		Hewascaught()
		end	
	end
else
Citizen.Wait(500)
		end	
	end
end)

local ragdoll = false

function Hewascaught()
	LoadDict('move_jump')
	TaskPlayAnim(GetPlayerPed(-1), 'move_jump', 'dive_start_run', 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)
	Citizen.Wait(600)
	SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
	Citizen.Wait(1000)
	ragdoll = true
	local szansaZlapania = math.random(1,100)
	if szansaZlapania <= 60 then
			TriggerEvent('DoLongHudText', 'You managed to catch 1 chicken!', 1)
			TriggerEvent('wrp-banned:getID', "alive_chicken", 1)
			if Zlapany1 == 1 then
				DeleteEntity(chicken1)
				Zlapany1 = 0
				splashed = splashed +1
			elseif Zlapany2 == 1 then
				DeleteEntity(chicken2)
				Zlapany2 = 0
				splashed = splashed +1
			elseif Zlapany3 == 1 then
				DeleteEntity(chicken3)
				Zlapany3 = 0
				splashed = splashed +1
			end
		else
		TriggerEvent('DoLongHudText', 'The chicken escaped your arms!', 2)
	end
end

Citizen.CreateThread(function()
    while true do
	Citizen.Wait(500)
		if ragdoll then
			SetEntityHealth(PlayerPedId(), 200)
			TriggerEvent('wrp-hospital:client:ResetLimbs')
            TriggerEvent('wrp-hospital:client:RemoveBleed')
			ragdoll = false
		end
	end
end)

Citizen.CreateThread(function()
while true do
	Citizen.Wait(5)
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
    	local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, sellX, sellY, sellZ)
	
		if dist <= 2.0 then
			job = exports['isPed']:isPed('job')
			if job == 'Chicken' then
			DrawMarker(27, sellX, sellY, sellZ-0.96, 0, 0, 0, 0, 0, 0, 2.20, 2.20, 2.20, 255, 255, 255, 200, 0, 0, 0, 0)
		else
			Citizen.Wait(1000)
		end
			if dist <= 2.0 then
				DrawText3D2(sellX, sellY, sellZ+0.1, "[E] Sell Packed Chickens")
			if IsControlJustPressed(0, Keys['E']) then 
				Sellchicken()
			  end 
			end	
		end
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	TriggerServerEvent('wrp-chickenjob:reward', money)
end)

function Sellchicken()
if exports["wrp-inventory"]:getQuantity("packaged_chicken") >= 2 then
local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, -0.98))
	prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z,  true,  true, true)
	SetEntityHeading(prop, GetEntityHeading(GetPlayerPed(-1)))
	LoadDict('amb@medic@standing@tendtodead@idle_a')
	TaskPlayAnim(GetPlayerPed(-1), 'amb@medic@standing@tendtodead@idle_a', 'idle_a', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
	TriggerEvent('inventory:removeItem', "packaged_chicken", 2)
	exports['wrp-taskbar']:taskBar(5000, 'Selling the chicken!')
	LoadDict('amb@medic@standing@tendtodead@exit')
	TaskPlayAnim(GetPlayerPed(-1), 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
	ClearPedTasks(GetPlayerPed(-1))
	DeleteEntity(prop)
	TriggerServerEvent('cunt:pay', math.random(50, 90))
else
	TriggerEvent('DoLongHudText', 'You have nothing to sell!', 2)
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(90000)
        cid = exports['isPed']:isPed('cid')
        stress = exports['carandplayerhud']:GetStress(stress)
        food = exports['carandplayerhud']:GetFood(food)
        thirst = exports['carandplayerhud']:GetThirst(thirst2)
        TriggerServerEvent('wrp-Food:Server:RefreshCurrentArmour', food, cid)
        TriggerServerEvent('wrp-Thirst:Server:RefreshCurrentArmour', thirst, cid)
        TriggerServerEvent('wrp-Stress:Server:RefreshCurrentArmour', stress, cid)
        TriggerServerEvent('wrp-Armour:Server:RefreshCurrentArmour', GetPedArmour(PlayerPedId()), cid)
        TriggerServerEvent('wrp-Health:Server:RefreshCurrentArmour', GetEntityHealth(PlayerPedId()), cid)
    end
end)