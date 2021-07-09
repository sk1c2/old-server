local debug = false -- change to true if you want to debug script for errors

RegisterNetEvent('FinishMoneyCheckForVehPlane')
RegisterNetEvent('vehshop:spawnVehiclePlane')
local vehshop_blips = {}
local financedPlates = nil
local buyPlate = nil
local inrangeofvehshop = false
local currentlocation = nil
local boughtcar = false
local vehicle_price = 0
local backlock = false
local firstspawn = 0
local commissionbuy = 0
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
local currentCarSpawnLocation = 0
local ownerMenu = false

local vehshopDefault = {
	opened = false,
	title = "Aviation Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Vehicles", description = ""},
			}
		},
		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {
				{name = "Job Vehicles", description = ''},
			}
		},		
	}
}

vehshop = vehshopDefault
local vehshopOwner = {
	opened = false,
	title = "Aviation Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,

		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Vehicles", description = ""},
			}
		},

		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {
				{name = "Sports", description = ''},
--				{name = "Drift", description = ''},
--				{name = "Sold/Reserved", description = ''},
			}
		},
		["sports"] = {
			title = "sports",
			name = "sports",
			buttons = {
				{model = "frogger", name = "Frogger Helicopter", costs = 350000, description = {} }, 
				{model = "havok", name = "Havok Helicopter", costs = 200000, description = {} }, 
				{model = "volatus", name = "Volatus Helicopter", costs = 500000, description = {} }, 
				{model = "swift2", name = "Swift Deluxe Helicopter", costs = 650000, description = {} },
				{model = "supervolito", name = "Super Volito Helicopter", costs = 400000, description = {} },
				{model = "supervolito2", name = "Super Volito Helicopter Deluxe", costs = 600000, description = {} },
				{model = "seasparrow", name = "Sea Sparrow Water Helicopter", costs = 350000, description = {} },
				{model = "skylift", name = "Skylift Helicopter", costs = 700000, description = {} },
				{model = "maverick", name = "Maverick Helicopter", costs = 275000, description = {} },
				{model = "buzzard2", name = "Buzzard Helicopter", costs = 300000, description = {} },
				{model = "duster", name = "Crop Duster Plane", costs = 150000, description = {} },
				{model = "dodo", name = "Dodo Water Plane", costs = 200000, description = {} },
				{model = "luxor", name = "Luxor Plane", costs = 650000, description = {} },
				{model = "luxor2", name = "Luxor Deluxe Plane", costs = 1000000, description = {} },
				{model = "mammatus", name = "Mammatus Plane", costs = 250000, description = {} },
				{model = "nimbus", name = "Nimbus Plane", costs = 500000, description = {} },
				{model = "seabreeze", name = "Sea Breeze Plane", costs = 300000, description = {} },
				{model = "howard", name = "Howard NX-25 Plane", costs = 375000, description = {} },
				{model = "microlight", name = "Microlight Plane", costs = 120000, description = {} },
				{model = "velum2", name = "Velum Plane", costs = 300000, description = {} },
				{model = "besra", name = "Bestra Plane", costs = 450000, description = {} },
				{model = "vestra", name = "Vestra Plane", costs = 250000, description = {} },
				{model = "stunt", name = "Stunt Mallard Plane", costs = 175000, description = {} },
			}
		}
	}
}



local fakecar = {model = '', car = nil}
local vehshop_locations = {
	{
		entering = { -1017.41, -2976.167, 13.94901, 238.866424 },
		inside = {-978.5508, -2995.286, 13.94508}, 
		outside = {-1017.41, -2976.167, 13.94901, 238.866424},
	}
}

local carspawns = {
	[1] =  { ['x'] = -979.4418,['y'] = -2943.835,['z'] = 13.94507,['h'] = 152.2358856, ['info'] = ' car1' },
	[2] =  { ['x'] = -966.1052,['y'] = -2953.88,['z'] = 13.94507,['h'] = 152.2358856, ['info'] = ' car2' },
	[3] =  { ['x'] = -951.7958,['y'] = -2968.58,['z'] = 13.94507,['h'] = 92.3468933, ['info'] = ' car3' },
	[4] =  { ['x'] = -945.3527,['y'] = -2994.984,['z'] = 13.94507,['h'] = 58.465591, ['info'] = ' car4' },
	[5] =  { ['x'] = -957.9617,['y'] = -3015.014,['z'] = 13.94507,['h'] = 58.71971, ['info'] = ' car5' },
	[6] =  { ['x'] = -979.2865,['y'] = -3019.731,['z'] = 13.94507,['h'] = 10.599, ['info'] = ' car6' },
	[7] =  { ['x'] = -998.2585,['y'] = -3013.507,['z'] = 13.94507,['h'] = 328.07526, ['info'] = ' car7' },
	[8] = { ['x'] = -1013.998, ['y'] = -3004.01, ['z'] = 13.94507, ['h'] = 328.07526, ['info'] = ' car8'},
}

local carTable = {
	[1] = { ["model"] = "frogger", ["baseprice"] = 750000, ["commission"] = 15 }, 
	[2] = { ["model"] = "havok", ["baseprice"] = 750000, ["commission"] = 15 },
	[3] = { ["model"] = "seabreeze", ["baseprice"] = 750000, ["commission"] = 15 },
	[4] = { ["model"] = "mammatus", ["baseprice"] = 750000, ["commission"] = 15 },
	[5] = { ["model"] = "seasparrow", ["baseprice"] = 750000, ["commission"] = 15 },
	[6] = { ["model"] = "supervolito2", ["baseprice"] = 750000, ["commission"] = 15 },
	[7] = { ["model"] = "swift2", ["baseprice"] = 750000, ["commission"] = 15 },
	[8] = { ["model"] = "volatus", ["baseprice"] = 750000, ["commission"] = 15 },
}

function updateCarTable(model,price,name)
	carTable[currentCarSpawnLocation]["model"] = model
	carTable[currentCarSpawnLocation]["baseprice"] = price
	carTable[currentCarSpawnLocation]["name"] = name
	TriggerServerEvent("carshop:table69Plane",carTable)
	if debug == true then
		print(model)
		print(price)
		print(name)
	end
end

local myspawnedvehs = {}

RegisterNetEvent("car:testdrive69Plane")
AddEventHandler("car:testdrive69Plane", function()
	local myJob = exports['isPed']:isPed('job')
	if myJob == 'SkyHighEnterprise' or #(vector3(-1017.41, -2976.167, 13.94901, 238.866424) - GetEntityCoords(PlayerPedId())) > 20.0 then
	-- local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.000, 0, 70)
	local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    local entityWorld = GetOffsetFromEntityInWorldCoords(ply, 0.0, 20.0, 0.0)
    local rayHandle = CastRayPointToPoint(plyCoords["x"], plyCoords["y"], plyCoords["z"], entityWorld.x, entityWorld.y, entityWorld.z, 10, ply, 0)
    local a, b, c, d, targetVehicle = GetRaycastResult(rayHandle)
	if debug == true then
		print(a)
		print(b)
		print(c)
		print(d)
		print(targetVehicle)
		print(entityWorld)
	end
	if targetVehicle ~= nil then

	-- if not DoesEntityExist(veh) then
	-- 	TriggerEvent('DoLongHudText', 'Could not locate vehicle!', 2)
	-- 	return
	-- end

	local model = GetEntityModel(targetVehicle)
	-- local veh = GetClosestVehicle(-1017.41, -2976.167, 13.94901, 238.866424, 3.000, 0, 70)

	if not DoesEntityExist(veh) then

		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model,-979.0428, -2995.104, 13.94507,55.67469,true,false)
		local vehplate = "CAR"..math.random(10000,99999)
		SetVehicleNumberPlateText(veh, vehplate)
		local plate = GetVehicleNumberPlateText(veh, vehplate)
		Citizen.Wait(100)
		TriggerServerEvent('garage:addKeys', plate)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)

		TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
		myspawnedvehs[veh] = true
		end
	else
		TriggerEvent('DoLongHudText', 'A car is on the spawn point.', 2)
	end
end
end)

RegisterNetEvent("finance69Plane")
AddEventHandler("finance69Plane", function()
	if #(vector3(-1017.41, -2976.167, 13.94901) - GetEntityCoords(PlayerPedId())) > 200.0 then
		return
	end

	-- local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.000, 0, 70)
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	local entityWorld = GetOffsetFromEntityInWorldCoords(ply, 0.0, 20.0, 0.0)
	local rayHandle = CastRayPointToPoint(plyCoords["x"], plyCoords["y"], plyCoords["z"], entityWorld.x, entityWorld.y, entityWorld.z, 10, ply, 0)
	local a, b, c, d, targetVehicle = GetRaycastResult(rayHandle)
	if targetVehicle ~= nil then
		local vehplate = GetVehicleNumberPlateText(targetVehicle)
		TriggerServerEvent("finance:enable69Plane",vehplate)
	else
		TriggerEvent('DoLongHudText', 'Error finding vehicle - Speak to Keiron')
	end
end)

RegisterNetEvent("buyEnable69Plane")
AddEventHandler("buyEnable69Plane", function()
	local myJob = exports['isPed']:isPed('job')
	if #(vector3(-1017.41, -2976.167, 13.94901) - GetEntityCoords(PlayerPedId())) > 200.0 and myJob == 'SkyHighEnterprise' then
		return
	end

	local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.000, 0, 70)
	-- if not DoesEntityExist(veh) then
	-- 	TriggerEvent('DoLongHudText', 'Could not locate vehicle!', 2)
	-- 	return
	-- end
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, 0)
		local entityWorld = GetOffsetFromEntityInWorldCoords(ply, 0.0, 20.0, 0.0)
		local rayHandle = CastRayPointToPoint(plyCoords["x"], plyCoords["y"], plyCoords["z"], entityWorld.x, entityWorld.y, entityWorld.z, 10, ply, 0)
		local a, b, c, d, targetVehicle = GetRaycastResult(rayHandle)
		if targetVehicle ~= nil then
			print('ok')
			local vehplate = GetVehicleNumberPlateText(targetVehicle)
			if vehplate == '1CARSALE' then
				buyPlate = true
				Citizen.Wait(60000)
				buyPlate = nil
			elseif vehplate == '2CARSALE' then
				buyPlate = true
				Citizen.Wait(60000)
				buyPlate = nil
			elseif vehplate == '3CARSALE' then
				buyPlate = true
				Citizen.Wait(60000)
				buyPlate = nil
			elseif vehplate == '4CARSALE' then
				buyPlate = true
				Citizen.Wait(60000)
				buyPlate = nil
			elseif vehplate == '5CARSALE' then
				buyPlate = true
				Citizen.Wait(60000)
				buyPlate = nil
			elseif vehplate == '6CARSALE' then
				buyPlate = true
				Citizen.Wait(60000)
				buyPlate = nil
			elseif vehplate == '7CARSALE' then
				buyPlate = true
				Citizen.Wait(60000)
				buyPlate = nil
			elseif vehplate == '8CARSALE' then
				buyPlate = true
				print('okey daddy')
				Citizen.Wait(60000)
				buyPlate = nil
			else
				TriggerEvent('DoShortHudText', 'ERROR: Report to Keiron')
			end
 			TriggerServerEvent("buy:enable69Plane",vehplate)
		end
end)

RegisterNetEvent("finance:enableOnClient69Plane")
AddEventHandler("finance:enableOnClient69Plane", function(vehnumber)
	financedPlates = true
	print(financedPlates)
	Citizen.Wait(60000)
	financedPlates = nil
end)

RegisterNetEvent("buy:enableOnClient69Plane")
AddEventHandler("buy:enableOnClient69Plane", function(addplate)
	buyPlate = true
	Citizen.Wait(60000)
	buyPlate = nil
end)

RegisterNetEvent("commissionPlane")
AddEventHandler("commissionPlane", function(newAmount)
	local myJob = exports['isPed']:isPed('job')
	if myJob == 'SkyHighEnterprise' or #(vector3(954.1, -954.0, 39.51) - GetEntityCoords(PlayerPedId())) > 50.0 then
	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			carTable[i]["commission"] = 15
			TriggerServerEvent("carshop:tablePlane",carTable)
			end
		end
	end
end)

RegisterNetEvent("veh_plane:returnTable69Plane")
AddEventHandler("veh_plane:returnTable69Plane", function(newTable)
	carTable = newTable
	DespawnSaleVehicles()
	SpawnSaleVehicles()
end)

local hasspawned = false
local spawnedvehicles = {}
local vehicles_spawned = false

function BuyMenu()
	for i = 1, #carspawns do

		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			local addplate = financedPlates
			if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= nil and GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 then
				ClearPedTasksImmediately(PlayerPedId())
			end
			DisableControlAction(0,23)
			if IsControlJustReleased(0,74) and buyPlate ~= nil then
				TriggerEvent('DoLongHudText', 'Attempting Purchase', 1)
				AttemptBuy(i,false)
			end

			if IsControlJustReleased(0,23) or IsDisabledControlJustReleased(0,23) then
				if financedPlates ~= nil then
					TriggerEvent('DoLongHudText', 'Attempting Purchase', 1)
					AttemptBuy(i,true)
				end
			end
		end
	end
end

function GetClosestPlayer()
	local entity = GetNearestPlayerToEntity(GetPlayerPed(PlayerId()))
	if entity ~= nil then
		return GetPlayerServerId(entity)
	else
		return -1
	end
end

function AttemptBuy(tableid,financed)
	local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    local entityWorld = GetOffsetFromEntityInWorldCoords(ply, 0.0, 20.0, 0.0)
    local rayHandle = CastRayPointToPoint(plyCoords["x"], plyCoords["y"], plyCoords["z"], entityWorld.x, entityWorld.y, entityWorld.z, 10, ply, 0)
    local a, b, c, d, targetVehicle = GetRaycastResult(rayHandle)
	if targetVehicle ~= nil then
		if financed then
	--		print("financed")
		end

		local model = carTable[tableid]["model"]
		local commission = carTable[tableid]["commission"]
		local baseprice = carTable[tableid]["baseprice"]
		local name = carTable[tableid]["name"]
		local price = baseprice + (baseprice * commission/ 100)

		currentlocation = vehshop_blips[1]
		local pdmdealer = GetClosestPlayer()
		Citizen.Wait(100)
		TaskWarpPedIntoVehicle(PlayerPedId(),targetVehicle,-1)
		print(model)
		print(price)
		print(financed)
		print(exports['isPed']:isPed('cid'))
		print(pdmdealer)
		TriggerServerEvent('CheckMoneyForVeh69Plane', model, price, financed, exports['isPed']:isPed('cid'), pdmdealer)
		commissionbuy = (baseprice * commission / 200)
	else
		TriggerEvent('DoLongHudText', 'Could not locate vehicle', 2)
	end
end

function OwnerMenu()
	if not vehshop.opened then
		currentCarSpawnLocation = 0
		ownerMenu = false
	end
	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			ownerMenu = true
			currentCarSpawnLocation = i
			if IsControlJustReleased(0,38) then
				TriggerEvent('DoLongHudText', 'We Opened', 1)
				if vehshop.opened then
					CloseCreator()
				else
					OpenCreator()
				end
			end
		end
	end
end

function DrawPrices()
	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 15.5000000 then
			local commission = 15
			local baseprice = carTable[i]["baseprice"]
			local price = baseprice + (baseprice * commission/100)
			local myJob = exports['isPed']:isPed('job')
			local veh = GetClosestVehicle(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], 3.000, 0, 70)
			local addplate = financedPlates
			if myJob == 'SkyHighEnterprise' then
				if financedPlates ~= nil and buyPlate ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " | Com: %" ..commission.. " | [E] to change | [H] to buy | [F] to Finance ")
				elseif financedPlates ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], "$" .. math.ceil(price/1.5) .. " upfront, $" .. math.ceil(price) .. " | Com: %" ..commission.. " | [E] to change | [F] to Finance ")
				elseif buyPlate ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " | Com: %" ..commission.. " | [E] to change | [H] to buy. ")
				else
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " | Com: %" ..commission.. " | [E] to change")
				end
			else
				if financedPlates ~= nil and buyPlate ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " [H] to buy | $" .. math.ceil(price/1.5) .. " upfront, $" .. math.ceil(price) .. " over 10 weeks, [F] to finance. ")
				elseif financedPlates ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], "$" .. math.ceil(price/1.5) .. " upfront, $" .. math.ceil(price) .. " over 10 weeks, [F] to finance. ")
				elseif buyPlate ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " [H] to buy. ")
				else
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"Buy Price: $" .. math.ceil(price) .. " ")
				end
			end
		end
	end
end

function DrawText3D(x,y,z, text)
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

function SpawnSaleVehicles()
	if not hasspawned then
		TriggerServerEvent("carshop:requesttable69Plane")
		Citizen.Wait(1500)
	end
	DespawnSaleVehicles(true)
	hasspawned = true
	for i = 1, #carTable do
		local model = GetHashKey(carTable[i]["model"])
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model,carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]-1,carspawns[i]["h"],false,false)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)

		FreezeEntityPosition(veh,true)
		spawnedvehicles[#spawnedvehicles+1] = veh
		SetVehicleNumberPlateText(veh, i .. "CARSALE")
	end
	vehicles_spawned = true
end

function DespawnSaleVehicles(pDontWait)
	if pDontWait == nil and not pDontWait then
		Wait(15000)
	end
	for i = 1, #spawnedvehicles do
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(spawnedvehicles[i]))
	end
	vehicles_spawned = false
end

Controlkey = {["generalUse"] = {38,"E"},["generalUseSecondary"] = {191,"Enter"}}
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["generalUse"] = table["generalUse"]
	Controlkey["generalUseSecondary"] = table["generalUseSecondary"]
end)

--[[Functions]]--

function LocalPed()
	return PlayerPedId()
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function IsPlayerInRangeOfVehshop()
	return inrangeofvehshop
end

function ShowVehshopBlips(bool)
	if bool and #vehshop_blips == 0 then
		for station,pos in pairs(vehshop_locations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			-- 60 58 137
			SetBlipSprite(blip,575)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Sky High Enterprises')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			SetBlipScale(blip, 0.6)
			SetBlipColour(blip, 46)
			vehshop_blips[#vehshop_blips+1]= {blip = blip, pos = loc}
		end
		Citizen.CreateThread(function()
			while #vehshop_blips > 0 do
				Citizen.Wait(1)
				local inrange = false
				local myJob = exports['isPed']:isPed('job')

				if #(vector3(-980.8151, -2994.869, 13.94484) - GetEntityCoords(LocalPed())) < 5.0 then
					local veh = GetVehiclePedIsUsing(LocalPed())
					if myspawnedvehs[veh] ~= nil then
						DrawText3D(-980.8151, -2994.869, 13.94484,"["..Controlkey["generalUse"][2].."] to Return The Vehicle")
						if IsControlJustReleased(0,Controlkey["generalUse"][1]) then
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
						end
					end
				end

				for i,b in ipairs(vehshop_blips) do
					if #(vector3(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]) - GetEntityCoords(LocalPed())) < 200 then
						currentlocation = b
						if not vehicles_spawned then
--							print("Spawning Display Vehicles?")
							SpawnSaleVehicles()
						end
						if #(vector3(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]) - GetEntityCoords(LocalPed())) < 200 then
							DrawPrices()
						end

						if myJob == 'SkyHighEnterprise' then
							OwnerMenu()
						end
						BuyMenu()
					else
						if vehicles_spawned then
--							print("Despawning Display ?")
							DespawnSaleVehicles()
						end
						Citizen.Wait(1000)
					end
				end
				inrangeofvehshop = inrange
			end
		end)
	elseif bool == false and #vehshop_blips > 0 then
		for i,b in ipairs(vehshop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		vehshop_blips = {}
	end
end

function f(n)
	return n + 0.0001
end

function try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function OpenCreator()
	boughtcar = false
	if ownerMenu then
		vehshop = vehshopOwner
	else
		vehshop = vehshopDefault
	end

	local ped = LocalPed()
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])

	vehshop.currentmenu = "main"
	vehshop.opened = true
	vehshop.selectedbutton = 0
end

function CloseCreator(veh, price, financed)
	Citizen.CreateThread(function()
		local ped = LocalPed()
		local pPrice = price
		if not boughtcar then
			local pos = currentlocation.pos.entering
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
		else
			local vehicle = veh
			local price = price		
			local veh = GetVehiclePedIsUsing(ped)
			local model = GetEntityModel(veh)
			local colors = table.pack(GetVehicleColours(veh))
			local extra_colors = table.pack(GetVehicleExtraColours(veh))

			local mods = {}
			for i = 0,24 do
				mods[i] = GetVehicleMod(veh,i)
			end
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
			local pos = currentlocation.pos.outside

			FreezeEntityPosition(ped,false)
			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(0)
			end
			personalvehicle = CreateVehicle(model,pos[1],pos[2],pos[3],pos[4],true,false)
			SetModelAsNoLongerNeeded(model)


			for i,mod in pairs(mods) do
				SetVehicleModKit(personalvehicle,0)
				SetVehicleMod(personalvehicle,i,mod)
			end

			SetVehicleOnGroundProperly(personalvehicle)

			local plate = GetVehicleNumberPlateText(personalvehicle)
			SetVehicleHasBeenOwnedByPlayer(personalvehicle,true)
			local id = NetworkGetNetworkIdFromEntity(personalvehicle)
			SetNetworkIdCanMigrate(id, true)
			Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
			SetVehicleColours(personalvehicle,colors[1],colors[2])
			SetVehicleExtraColours(personalvehicle,extra_colors[1],extra_colors[2])
			TaskWarpPedIntoVehicle(PlayerPedId(),personalvehicle,-1)
			SetEntityVisible(ped,true)			
			local primarycolor = colors[1]
			local secondarycolor = colors[2]	
			local pearlescentcolor = extra_colors[1]
			local wheelcolor = extra_colors[2]
			local VehicleProps = exports['wrp-base']:FetchVehProps(personalvehicle)
			local model = GetEntityModel(personalvehicle)
			print(model)
			TriggerServerEvent('garage:addKeys', plate)
			local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
			local Player = LocalPlayer:getCurrentCharacter()
			local firstname = Player.first_name .. ' ' .. Player.last_name
			TriggerServerEvent('BuyForVeh69', plate, name, model, vehicle, price, VehicleProps, financed, exports['isPed']:isPed('cid'), firstname)
			DespawnSaleVehicles()
			SpawnSaleVehicles()
		end
		vehshop.opened = false
		vehshop.menu.from = 1
		vehshop.menu.to = 10
	end)
end

RegisterNetEvent("carshop:failedpurchasePlane")
AddEventHandler("carshop:failedpurchasePlane", function()
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	TaskLeaveVehicle(PlayerPedId(),veh,0)
end)


function drawMenuButton(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,255,55,55,220)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,250)
	DrawText(0.255, 0.254)
end

function drawMenuRight(txt,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.2, 0.2)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(250,250,250, 255)
	end

	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 + 0.025, y - menu.height/3 + 0.0002)

	if selected then
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,255,255,255,255)
	else
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,255,55,55,220)
	end
end

function drawMenuTitle(txt,x,y)
	local menu = vehshop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)

	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,250)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function ButtonSelected(button)
	local ped = PlayerPedId()
	local this = vehshop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Vehicles" then
			OpenMenu('vehicles')
		elseif btn == "Motorcycles" then
			OpenMenu('motorcycles')
		elseif btn == "Cycles" then
			OpenMenu('cycles')
		end
	elseif this == "vehicles" then
		if btn == "Sports" then
			OpenMenu('sports')
		elseif btn == "Sedans" then
			OpenMenu('sedans')
		elseif btn == "Job Vehicles" then
			OpenMenu('jobvehicles')
		elseif btn == "Compacts" then
			OpenMenu('compacts')
		elseif btn == "Coupes" then
			OpenMenu('coupes')
		elseif btn == "Sports Classics" then
			OpenMenu("sportsclassics")
		elseif btn == "casino" then
			OpenMenu('casino')
		elseif btn == "Muscle" then
			OpenMenu('muscle')
		elseif btn == "Off-Road" then
			OpenMenu('offroad')
		elseif btn == "SUVs" then
			OpenMenu('suvs')
		elseif btn == "Vans" then
			OpenMenu('vans')
		end
	elseif this == "jobvehicles" or this == "compacts" or this == "coupes" or this == "sedans" or this == "sports" or this == "sportsclassics" or this == "casino" or this == "muscle" or this == "offroad" or this == "suvs" or this == "vans" or this == "industrial" or this == "cycles" or this == "motorcycles" then
		if ownerMenu then
			updateCarTable(button.model,button.costs,button.name)
		else
			TriggerServerEvent('CheckMoneyForVeh69Plane',button.name, button.model, button.costs)
		end
	end
end

function OpenMenu(menu)
	fakecar = {model = '', car = nil}
	vehshop.lastmenu = vehshop.currentmenu
	if menu == "vehicles" then
		vehshop.lastmenu = "main"
	elseif menu == "bikes"  then
		vehshop.lastmenu = "main"
	elseif menu == 'race_create_objects' then
		vehshop.lastmenu = "main"
	elseif menu == "race_create_objects_spawn" then
		vehshop.lastmenu = "race_create_objects"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "main" then
		CloseCreator()
	elseif vehshop.currentmenu == "jobvehicles" or vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "casino" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
		if DoesEntityExist(fakecar.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
		end
		fakecar = {model = '', car = nil}
		OpenMenu(vehshop.lastmenu)
	else
		OpenMenu(vehshop.lastmenu)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ( IsControlJustPressed(1,Controlkey["generalUse"][1]) or IsControlJustPressed(1, Controlkey["generalUseSecondary"][1]) ) and IsPlayerInRangeOfVehshop() then
			if vehshop.opened then
				CloseCreator()
			else
				OpenCreator()
			end
		end
		if vehshop.opened then

			local ped = LocalPed()
			local menu = vehshop.menu[vehshop.currentmenu]
			local y = vehshop.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false
			local myJob = exports['isPed']:isPed('job')
			for i,button in pairs(menu.buttons) do
				--local br = button.rank ~= nil and button.rank or 0
				if myJob == 'SkyHighEnterprise' and i >= vehshop.menu.from and i <= vehshop.menu.to then

					if i == vehshop.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,vehshop.menu.x,y,selected)

					if button.costs ~= nil then
						drawMenuRight("$"..button.costs,vehshop.menu.x,y,selected)
					end

					y = y + 0.04
					if vehshop.currentmenu == "jobvehicles" or vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "casino" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
						if selected then
							if fakecar.model ~= button.model then
								if DoesEntityExist(fakecar.car) then
									Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
								end
								local pos = currentlocation.pos.inside
								local hash = GetHashKey(button.model)
								RequestModel(hash)
								while not HasModelLoaded(hash) do
									Citizen.Wait(0)


								end
								local veh = CreateVehicle(hash,pos[1],pos[2],pos[3],pos[4],false,false)
								SetModelAsNoLongerNeeded(hash)
								local timer = 9000
								while not DoesEntityExist(veh) and timer > 0 do
									timer = timer - 1
									Citizen.Wait(1)
								end
								TriggerEvent("vehsearch:disablePlane",veh)

								FreezeEntityPosition(veh,true)
								SetEntityInvincible(veh,true)
								SetVehicleDoorsLocked(veh,4)
								--SetEntityCollision(veh,false,false)
								TaskWarpPedIntoVehicle(LocalPed(),veh,-1)
								for i = 0,24 do
									SetVehicleModKit(veh,0)
									RemoveVehicleMod(veh,i)
								end
								fakecar = { model = button.model, car = veh}
								local topspeed = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel') / 2)
								local handling = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock') * 2)
								local braking = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce') * 100)
								local accel = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce') * 100) 
								if button.model == "rumpo" then
									SetVehicleLivery(veh,2)
								end
							end
						end
					end
					if selected and ( IsControlJustPressed(1,Controlkey["generalUse"][1]) or IsControlJustPressed(1, Controlkey["generalUseSecondary"][1])  ) then
						ButtonSelected(button)
					end
				end
			end

			if DoesEntityExist(fakecar.car) then
				if vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
					daz = 6.0
					if fakecar.model == "Chimera" then
						daz = 8.0
					end
					if fakecar.model == "bmx" then
						daz = 8.0
					end
					 x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, -1.5, daz))
		        	Citizen.InvokeNative(0x87D51D72255D4E78,scaleform, x,y,z, 0.0, 180.0, 100.0, 1.0, 1.0, 1.0, 7.0, 7.0, 7.0, 0)
				else
		       		x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, -1.5, 10.0))
		       		Citizen.InvokeNative(0x87D51D72255D4E78,scaleform, x,y,z, 0.0, 180.0, 100.0, 1.0, 1.0, 1.0, 10.0, 10.0, 10.0, 0)		
				end
				TaskWarpPedIntoVehicle(LocalPed(),fakecar.car,-1)
		    end

		end
		if vehshop.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if vehshop.selectedbutton > 1 then
					vehshop.selectedbutton = vehshop.selectedbutton -1
					if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
						vehshop.menu.from = vehshop.menu.from -1
						vehshop.menu.to = vehshop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if vehshop.selectedbutton < buttoncount then
					vehshop.selectedbutton = vehshop.selectedbutton +1
					if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
						vehshop.menu.to = vehshop.menu.to + 1
						vehshop.menu.from = vehshop.menu.from + 1
					end
				end
			end
		end

	end
end)
RegisterNetEvent('FinishMoneyCheckForVeh69Plane')
AddEventHandler('FinishMoneyCheckForVeh69Plane', function(vehicle, price,financed)
	local vehicle = vehicle
	local price = price
	boughtcar = true
	CloseCreator(vehicle, price,financed)
end)

ShowVehshopBlips(true)
AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		--326 car blip 227 225
		ShowVehshopBlips(true)
		firstspawn = 1
	end
end)

AddEventHandler('vehshop:spawnVehiclePlane', function(v)
	local car = GetHashKey(v)
	local playerPed = PlayerPedId()
	if playerPed and playerPed ~= -1 then
		RequestModel(car)
		while not HasModelLoaded(car) do
			Citizen.Wait(0)
		end
		local playerCoords = GetEntityCoords(playerPed)
		veh = CreateVehicle(car, playerCoords, 0.0, true, false)
		SetModelAsNoLongerNeeded(car)
		TaskWarpPedIntoVehicle(playerPed, veh, -1)
		SetEntityInvincible(veh, true)
	end
end)

local firstspawn = 0

AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		RemoveIpl('v_carshowroom')
		RemoveIpl('shutter_open')
		RemoveIpl('shutter_closed')
		RemoveIpl('shr_int')
		RemoveIpl('csr_inMission')
		RequestIpl('v_carshowroom')
		RequestIpl('shr_int')
		RequestIpl('shutter_closed')
		firstspawn = 1
	end
end)

RegisterCommand('aviationfinance', function(source, args, raw)
	local myJob = exports['isPed']:isPed('job')
	if exports['isPed']:isPed('job') == 'SkyHighEnterprise' then
		TriggerEvent('finance69Plane')
	else
		TriggerEvent('DoLongHudText', 'You dont have permissions for this!', 2)
	end
end)

RegisterCommand('aviationcommission', function(source, args, raw)
	local myJob = exports['isPed']:isPed('job')
	if exports['isPed']:isPed('job') == 'SkyHighEnterprise' then
		local amount = args[1]
		if amount ~= nil then
			TriggerEvent('commissionPlane', amount)
		else
			TriggerEvent('DoLongHudText', 'Invalid amount "/commision [amount]', 1)
		end
	elseif myJob == 'SkyHighEnterprise' then
		local amount = args[1]
		if amount ~= nil then
			TriggerEvent('commission_tunerPlane', amount)
		else
			TriggerEvent('DoLongHudText', 'Invalid amount "/commision [amount]', 1)
		end
	else
		TriggerEvent('DoLongHudText', 'You dont have permissions for this!', 2)
	end
end)

--RegisterCommand('tunertestdrive', function(source, args, raw)
--	local myJob = exports['isPed']:isPed('job')
--	if exports['isPed']:isPed('job') == 'PDM' then
--		TriggerEvent('car:testdrive69')
--	elseif myJob == 'tuner' then
--		TriggerEvent('car:testdrive_tuner')
--	else
--		TriggerEvent('DoLongHudText', 'You dont have permissions for this!', 2)
--	end
--end)
RegisterCommand('aviationtestdrive', function(source, args, raw)
	local myJob = exports['isPed']:isPed('job')
	if exports['isPed']:isPed('job') == 'SkyHighEnterprise' then
		TriggerEvent('car:testdrive69Plane')
	elseif myJob == 'SkyHighEnterprise' then
		TriggerEvent('car:testdrive_tunerPlane')
	else
		TriggerEvent('DoLongHudText', 'You dont have permissions for this!', 2)
	end
end)


RegisterCommand('aviationenableBuy', function(source, args, raw)
	local myJob = exports['isPed']:isPed('job')
	if exports['isPed']:isPed('job') == 'SkyHighEnterprise' then
		TriggerEvent('buyEnable69Plane')
	elseif myJob == 'SkyHighEnterprise' then
		TriggerEvent('tuner:enable_buyPlane')
	else
		TriggerEvent('DoLongHudText', 'You dont have permissions for this!', 2)
	end
end)