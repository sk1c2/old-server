local addedGarages = {}

DecorRegister("CurrentFuel", 3)
Fuel = 0
local houseGarage = {}
local enableHgarage = false
local houseShell = ""
local houseID = 0
local curHouseGarage = ""

RegisterNetEvent("garages:getVehicles")
RegisterNetEvent('garages:StoreVehicle')
RegisterNetEvent('garages:SelVehicle')
--

local markerColor = 
{
	["Red"] = 222,
	["Green"] = 50,
	["Blue"] = 50
}
local garagesRunning = false

local garages = {
	[1] = { loc = {484.77066040039,-77.643089294434,77.600166320801}, spawn = {469.40374755859,-65.764274597168,76.935157775879}, garage = "A"},
	[2] = { loc = {-331.96115112305,-781.52337646484,33.964477539063}, spawn = {-334.75921630859,-777.63739013672,33.965934753418}, garage = "B"},

	[3] = { loc = {-451.37295532227,-794.06591796875,30.543809890747}, spawn = {-453.78579711914,-799.77722167969,30.544193267822}, garage = "C"},
	[4] = { loc = {399.51190185547,-1346.2742919922,31.121940612793}, spawn = {404.08923339844,-1340.2329101563,31.123672485352}, garage = "D"},

	[5] = { loc = {598.77319335938,90.707237243652,92.829048156738}, spawn = {604.99200439453,90.680313110352,92.638885498047}, garage = "E"},
	[6] = { loc = {641.53442382813,205.42562866211,97.186958312988}, spawn = {643.27648925781,200.49697875977,96.490730285645}, garage = "F"},

	[7] = { loc = {82.359413146973,6418.9575195313,31.479639053345}, spawn = {68.428749084473,6394.8129882813,31.233980178833}, garage = "G"},

	[8] = { loc = {-794.578125,-2020.8499755859,8.9431390762329}, spawn = {-773.12854003906,-2034.2691650391,8.8856906890869}, garage = "H"},

	[9] = { loc = {-669.15631103516,-2001.7552490234,7.5395741462708}, spawn = {-666.11407470703,-1993.1220703125,6.9599323272705}, garage = "I"},

	[10] = { loc = {-606.86322021484,-2236.7624511719,6.0779848098755}, spawn = {-617.38104248047,-2228.3828125,6.0075860023499}, garage = "J"},

	[11] = { loc = {-166.60482788086,-2143.9333496094,16.839847564697}, spawn = {-166.0227355957,-2150.9533691406,16.704912185669}, garage = "K"},

	[12] = { loc = {-38.922565460205,-2097.2663574219,16.704851150513}, spawn = {-42.358554840088,-2106.9069824219,16.704837799072}, garage = "L"},

	[13] = { loc = {-70.179389953613,-2004.4139404297,18.016941070557}, spawn = {-66.245826721191,-2012.8634033203,18.016965866089}, garage = "M"},

	[14] = { loc = {549.47796630859,-55.197559356689,71.069190979004}, spawn = {549.47796630859,-55.197559356689,71.069190979004}, garage = "Impound Lot"},

	[15] = { loc = {364.27685546875,297.84490966797,103.49515533447}, spawn = {370.07534790039,291.43197631836,103.33471679688}, garage = "O"},

	[16] = { loc = {-338.31619262695,266.79782104492,85.741966247559}, spawn = {-334.42706298828,278.54644775391,85.945793151855}, garage = "P"},

	[17] = { loc = {273.66683959961,-343.83737182617,44.919876098633}, spawn = {272.68188476563,-334.81295776367,44.919876098633}, garage = "Q"},

	[18] = { loc = {66.215492248535,13.700443267822,69.047248840332}, spawn = {61.096534729004,24.754076004028,69.682136535645}, garage = "R"},

	[19] = { loc = {3.3330917358398,-1680.7877197266,29.170293807983}, spawn = {3.3330917358398,-1680.7877197266,29.170293807983}, garage = "Imports"},

	[20] = { loc = {286.67013549805,79.613700866699,94.362899780273}, spawn = {282.82489013672,76.622230529785,94.36026763916}, garage = "S"},

	[21] = { loc = {211.79,-808.38,30.833}, spawn = {212.04,-800.325,30.89}, garage = "T"},

	[22] = { loc = {447.65,-1021.23,28.45}, spawn = {447.65,-1021.23,28.45}, garage = "Police Department"},
	

	[23] = { loc = {-25.59,-720.86,32.62}, spawn = {-25.59,-720.86,32.22}, garage = "House"},
	[24] = { loc = {570.81,2729.85,42.07}, spawn = {570.81,2729.85,42.07}, garage = 'Harmony Garage'},

	[25] = { loc = {-1287.1, 293.02, 64.82}, spawn = {-1287.1, 293.02, 64.82}, garage = 'Richman Garage'},
	[26] = { loc = {-1579.01,-889.11,9.38,}, spawn = {-1579.01,-889.11,9.38,}, garage = 'Pier Garage'},
	[27] = { loc = {-305.58, -990.15, 31.08}, spawn = {-300.92, -988.07, 31.08}, garage = '24/7 Garage'},

	[28] =  { loc = {986.28, -208.47, 70.46}, spawn = {986.28, -208.47, 70.46}, garage = 'Run Down Hotel' },

	[29] =  { loc = {847.36, -3219.15, 5.97}, spawn = {847.36, -3219.15, 5.97}, garage = 'Docks' },

	[30] =  { loc = {-1479.6,-666.556,28.4}, spawn = {-1479.6,-666.556,28.4}, garage = 'Q' },
	[31] =  { loc = {1038.04,-764.42,57.93}, spawn = {1040.11,-775.55,58.02}, garage = 'U' },
	[32] =  { loc = {-1271.528,-3380.873,13.94016}, spawn = {-1271.528, -3380.873, 13.94016}, garage = 'LSIA Aircraft'},
	[33] = { loc = {328.7053, -577.0226, 28.79684}, spawn = {328.7053, -577.0226, 28.79684}, garage = 'Pillbox Garage'},
	[34] = { loc = {-460.5631, -272.8553, 35.78092}, spawn = {-460.5631, -272.8553, 35.78092}, garage = 'Townhall Garage'},

}

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent("house:garagelocations")
AddEventHandler("house:garagelocations", function(sentmygarages,id,shell)
	houseGarage = sentmygarages
	houseShell = shell
	houseID = id
	enableHgarage = true
	curHouseGarage = houseShell..'-'..houseID
end)



local myroomtype = 0
local showGarages = false



local blips = {
	{469.40374755859,-65.764274597168,76.935157775879,"A"},
	{-331.96115112305,-781.52337646484,33.964477539063,"B"},
	{328.7053, -577.0226, 28.79684, 'Pillbox'},
	{-451.37295532227,-794.06591796875,30.543809890747,"C"},
	{399.51190185547,-1346.2742919922,31.121940612793,"D"},
	{598.77319335938,90.707237243652,92.829048156738,"E"},
	{641.53442382813,205.42562866211,97.186958312988,"F"},
	{82.359413146973,6418.9575195313,31.479639053345,"G"},
	{-794.578125,-2020.8499755859,8.9431390762329,"H"},
	{-669.15631103516,-2001.7552490234,7.5395741462708,"I"},
	{-606.86322021484,-2236.7624511719,6.0779848098755,"J"},
	{-166.60482788086,-2143.9333496094,16.839847564697,"K"},
	{-38.922565460205,-2097.2663574219,16.704851150513,"L"},
	{-70.179389953613,-2004.4139404297,18.016941070557,"M"},
	{549.47796630859,-55.197559356689,71.069190979004,"Impound Lot"},
	{364.27685546875,297.84490966797,103.49515533447,"O"},
	{-338.31619262695,266.79782104492,85.741966247559,"P"},
	{273.66683959961,-343.83737182617,44.919876098633,"Q"},
	{66.215492248535,13.700443267822,69.047248840332,"R"},
	{3.3330917358398,-1680.7877197266,29.170293807983,"Imports"},
	{286.67013549805,79.613700866699,94.362899780273,"S"},
	{211.79,-808.38,30.833,"T"},
	{447.65,-1021.23,28.45,"Police Department"},
	{-25.59,-720.86,32.62, "Highrise Garage"},
	{570.81,2729.85,42.07,'Harmony Garage'},

	{ -1287.1, 293.02, 64.82, ' Richman Garage' },
	{ -1579.01,-889.11,9.38, ' Pier Garage' },
	{ -305.58, -990.15, 31.08, 'Apartment Garage' },
	{ 986.28, -208.47, 70.46, 'Run Down Hotel' },
	{847.36, -3219.15, 5.97, 'Docks' },

	{-1479.6,-666.556,28.4, 'Q' },
	{-1271.528, -3380.873, 13.94016, 'LSIA' },
	{-460.5631, -272.8553, 35.78092, 'Townhall'}
	
}



RegisterNetEvent('Garages:ToggleGarageBlip')
AddEventHandler('Garages:ToggleGarageBlip', function()
    showGarages = not showGarages
    local what = 1
   for _, item in pairs(blips) do
        if not showGarages then
            if item.blip ~= nil then
                RemoveBlip(item.blip)
            end
        else
            item.blip = AddBlipForCoord(item[1], item[2], item[3])
            SetBlipSprite(item.blip, 357)

			if what == 14 then
				AddTextComponentString('Impound Lot')
				SetBlipColour(item.blip, 5)
			else
				SetBlipColour(item.blip, 3)
				AddTextComponentString('Garage ' .. item[4])
			end
			what = what + 1



			SetBlipScale(item.blip, 0.6)
			SetBlipAsShortRange(item.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Garage " .. item[4])
			EndTextCommandSetBlipName(item.blip)
        end
    end
end)

Citizen.CreateThread(function()
	showGarages = false
	TriggerEvent('Garages:ToggleGarageBlip')
end)
--


local garage = {title = "garage", currentpos = nil, marker = { r = 0, g = 155, b = 255, a = 200, type = 1 }}
local selectedGarage = false
selectedPage = 0

--[[Functions]]--

function HouseMenuGarage()

	playerCoords = GetEntityCoords(LocalPed())
	impLocation =  vector3(549.48272705078,-55.188056945801,71.063934326172)
    ped = PlayerPedId();
	ClearMenu()
	selectedPage = 0
	exports['prp-menudialog']:SetTitle("Public Garage")		
	exports['prp-menudialog']:AddButton("Store Vehicle" , "Store Vehicle" , "RentrerVehicule")	
	exports['prp-menudialog']:AddButton("Vehicle List" , "Vehicle List" , "ListeVehicule", 0)	
	exports['prp-menudialog']:AddButton("Close Menu" , "Close Menu" , "CloseMenu", 0)	
end

function MenuGarage()

	enableHgarage = false
	playerCoords = GetEntityCoords(LocalPed())
	impLocation =  vector3(549.48272705078,-55.188056945801,71.063934326172)
    ped = PlayerPedId();
	ClearMenu()
	selectedPage = 0
	if current_used_garage == "Impound Lot" then
		Menu.addButton("Vehicle List","ListeVehicule",0)
    Menu.addButton("Close Menu","CloseMenu",nil) 
	else
		exports['prp-menudialog']:SetTitle("Public Garage")		
		exports['prp-menudialog']:AddButton("Store Vehicle" , "Store Vehicle" , "RentrerVehicule")	
		exports['prp-menudialog']:AddButton("Vehicle List" , "Vehicle List" , "ListeVehicule", 0)	
		exports['prp-menudialog']:AddButton("Close Menu" , "Close Menu" , "CloseMenu", 0)	
    -- Menu.addButton("Vehicle List","ListeVehicule",0)
	-- Menu.addButton("Close Menu","CloseMenu",nil) 
	end
end

RegisterNetEvent('RentrerVehicule')
AddEventHandler('RentrerVehicule', function()
	RentrerVehicule()
end)

function RentrerVehicule()
	TriggerServerEvent('garages:CheckForVeh', exports['isPed']:isPed('cid'))
	CloseMenu()
end
carCount = 0
firstCar = 0




 RegisterNetEvent('house:usingGarage')
 AddEventHandler('house:usingGarage', function()
	enableHgarage = false
end)

RegisterNetEvent('ListeVehicule')
AddEventHandler('ListeVehicule', function(page)
	ListeVehicule(page)
end)

function ListeVehicule(page)
	MenuTitle = "My Vehicles :"
	ClearMenu()
	local carCount = 0
    for ind, value in pairs(VEHICLES) do
		carCount = carCount + 1
    end 

	estimate = 15 * (carCount * carCount * 2)
	local count = 0
	for ind, value in pairs(VEHICLES) do
		enginePercent = value.engine_damage / 10
		bodyPercent = value.body_damage / 10
		curGarage = value.garage
        if curGarage == nil then
            curGarage = "Any"
        end
	 
		if enableHgarage then
			current_used_garage = houseShell..'-' .. houseID 
		end
		if ((count >= (page*10)) and (count < ((page*10)+10))) then
			 if value.state == "Normal Impound" then
				 Menu.addButton(tostring(value.name), "OptionVehicle", value.id, "Impounded: $500", " Engine %:" .. enginePercent .. "", " Body %:" .. bodyPercent .. "", "Plate: "..value.plate.."")
			 elseif value.state == "Police Impound" then
				 Menu.addButton(tostring(value.name), "OptionVehicle", value.id, "Impounded: $1500", " Engine %:" .. enginePercent .. ""," Body %:" .. bodyPercent .. "", "Plate: "..value.plate.."")
			 elseif curGarage ~= current_used_garage and curGarage ~= "Any" and value.state ~= "Out" and curGarage ~= "house" then
				 
				 Menu.addButton(tostring(value.name), "OptionVehicle", 0, curGarage, " Engine %:" .. enginePercent .. "", " Body %:" .. bodyPercent .. "", "Plate: "..value.plate.."")
 
			 else
			 
				 Menu.addButton(tostring(value.name), "OptionVehicle", value.id, tostring(value.state) , " Engine %:" .. enginePercent .. ""," Body %:" .. bodyPercent .. "", "Plate: "..value.plate.."")
			 end
		 end

		count = count + 1
   	end  


	   	Menu.addButton("Next ","ListeVehicule",page+1)
	   	if page == 0 then
			Menu.addButton("Return", "ListeVehicule", 0)
	   	else		
			Menu.addButton("Previous","ListeVehicule",page-1)
			Menu.addButton("Return", "ListeVehicule", 0)
	   	end
	
	   TriggerEvent("DoLongHudText", "It will cost $" .. estimate .. " to $" .. estimate + (estimate * 0.15) .. " @ $15 x (carCount x carCount x 2)", 1)
end
	



function OptionVehicle(vehID)
	local vehID = vehID
	MenuTitle = "Options :"

	ClearMenu()
	if vehID == 0 then
		TriggerEvent('DoLongHudText', 'You dont have vehicle in this garage')
		Menu.addButton("Return", "ListeVehicule", 0)
	else
    Menu.addButton("Take Out", "SortirVehicule", vehID)
	
	Menu.addButton("Return", "ListeVehicule", 0)
	end
end

function SortirVehicule(vehID)
	local loc = ""
	local caisseo = ""
	if enableHgarage then
		loc = json.decode(houseGarage)	
	else
		loc = garages[selectedGarage].loc
	end

	if enableHgarage then
		caisseo = GetClosestVehicle(loc.x,loc.y,loc.z, 3.000, 0, 70)
	else
		caisseo = GetClosestVehicle(loc[1], loc[2], loc[3], 3.000, 0, 70)
	end

	local vehID = vehID
	if firstCar == 0 then carCount = 0 end
	local impound = false
	local dist = #(vector3(550.09,-55.45,71.08) - GetEntityCoords(LocalPed()))


	if dist < 15.0 then
		impound = true
	end

	local garagecount = 1
	for i = 1, #garages do
		if current_used_garage == garages[i] then
			garagecount = i
		end
	end
	local garagefree = false

	if addedGarages[current_used_garage] ~= nil then
		garagefree = true
	end
	for i = 1, #garages do
		if garages[i].garage == "House" then 
			garagefree = true
		end
	end
	if current_used_garage == "Impound Lot" and not DoesEntityExist(caisseo) then
		local garageCost = 0
		TriggerServerEvent('garages:CheckForSpawnVeh', vehID, garageCost, current_used_garage, exports['isPed']:isPed('cid'))
	elseif DoesEntityExist(caisseo) then
		TriggerEvent("DoShortHudText", "The area is crowded",2)
	else
		local garageCost = 0
		TriggerServerEvent('garages:CheckForSpawnVeh', vehID, garageCost, current_used_garage, exports['isPed']:isPed('cid'))
	end
	firstCar = 1
	CloseMenu()

end


RegisterNetEvent('CloseMenu')
AddEventHandler('CloseMenu', function()
	CloseMenu()
end)

function CloseMenu()
    Menu.hidden = true
end

function LocalPed()
	return PlayerPedId()
end



if enableHgarage then
	local current_used_garage = houseShell..'-'..houseID
end
current_used_garage = "Any"

Citizen.CreateThread(function()
	Citizen.Wait(1)
	TriggerEvent("RecreateGarages")
end) 


Controlkey = {["generalUse"] = {38,"E"},["generalUseSecondary"] = {18,"Enter"},["generalUseThird"] = {47,"G"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["generalUse"] = table["generalUse"]
	Controlkey["generalUseSecondary"] = table["generalUseSecondary"]
	Controlkey["generalUseThird"] = table["generalUseThird"]
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if enableHgarage then
			local mygarage = json.decode(houseGarage)
	
			local dist = #(vector3(mygarage.x,mygarage.y,mygarage.z) - GetEntityCoords(LocalPed()))
			if dist < 3.0 then
				DrawMarker(20,mygarage.x,mygarage.y,mygarage.z,0,0,0,0,0,0,0.701,1.0001,0.3001,markerColor.Red,markerColor.Green, markerColor.Blue,dist,0,0,0,0)
				DisplayHelpText('~g~'..Controlkey["generalUse"][2]..'~s~ or ~g~'..Controlkey["generalUseSecondary"][2]..'~s~ Accepts ~g~Arrows~s~ Move ~g~Backspace~s~ Exit')
				if IsControlJustPressed(1, 177) and not Menu.hidden then
					CloseMenu()
					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				end
				if ( IsControlJustPressed(1,Controlkey["generalUse"][1]) or IsControlJustPressed(1,Controlkey["generalUseSecondary"][1]) ) and Menu.hidden then
					TriggerServerEvent("garages:CheckGarageForVeh", exports['isPed']:isPed('cid'))
					Citizen.Wait(100)
					TriggerServerEvent('garage:getVehicles', exports["isPed"]:isPed("cid"))
					Citizen.Wait(150)
					HouseMenuGarage()
					selectedGarage = k
					Menu.hidden = not Menu.hidden
				end
				Menu.renderGUI()
			end
		end
	end
end)

AddEventHandler("garages:getVehicles", function(THEVEHICLES)
    VEHICLES = {}
	VEHICLES = THEVEHICLES
end)



RegisterNetEvent("RecreateGarages") -- This is the ^(RED) for garage sign
AddEventHandler("RecreateGarages", function()
	Citizen.Wait(5000)
	if not garagesRunning then
		garagesRunning = true
		for k,v in ipairs(garages) do
			Citizen.CreateThread(function()
				if v.disabled then return end
				local pos = v.loc
				local gar = v.garage
				while garagesRunning do
					Citizen.Wait(1)

					local dist = #(vector3(pos[1],pos[2],pos[3]) - GetEntityCoords(LocalPed()))
					if dist < 35.0 then
						dist = math.floor(200 - (dist * 10))
						if dist < 0 then dist = 0 end
						if myroomtype ~= 3 and gar == "House" then

						else
							DrawMarker(20,pos[1],pos[2],pos[3],0,0,0,0,0,0,0.701,1.0001,0.3001,markerColor.Red,markerColor.Green, markerColor.Blue,dist,0,0,0,0)
						end
					end

					if #(vector3(pos[1],pos[2],pos[3]) - GetEntityCoords(LocalPed())) < 3.0 and IsPedInAnyVehicle(LocalPed(), true) == false then
						if Menu.hidden then
						
							if enableHgarage then
								current_used_garage = houseShell..'-' .. houseID 
							else	
								current_used_garage = garages[k].garage
							end
						else
							DisplayHelpText('~g~'..Controlkey["generalUse"][2]..'~s~ or ~g~'..Controlkey["generalUseSecondary"][2]..'~s~ Accepts ~g~Arrows~s~ Move ~g~Backspace~s~ Exit')
						end

						if IsControlJustPressed(1, 177) and not Menu.hidden then
			
							CloseMenu()
							PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
						end
						if (myroomtype ~= 3 and gar == "House") then

						elseif ( IsControlJustPressed(1,Controlkey["generalUse"][1]) or IsControlJustPressed(1,Controlkey["generalUseSecondary"][1]) ) and Menu.hidden then
							TriggerServerEvent("garages:CheckGarageForVeh", exports['isPed']:isPed('cid'))
							Citizen.Wait(100)
							TriggerServerEvent('garage:getVehicles', exports["isPed"]:isPed("cid"))
							Citizen.Wait(150)
							MenuGarage()
							selectedGarage = k
							Menu.hidden = not Menu.hidden
						
						end
						Menu.renderGUI()
					end
					if dist > 200.0 then
						Citizen.Wait(2000)
					end
				end
			end)
		end
	end
end)

function doCarDamages(eh, bh, veh)
	smash = false
	damageOutside = false
	damageOutside2 = false 
	local engine = eh + 0.0
	local body = bh + 0.0
	if engine < 200.0 then
		engine = 200.0
	end

	if body < 150.0 then
		body = 150.0
	end
	if body < 550.0 then
		smash = true
	end

	if body < 520.0 then
		damageOutside = true
	end

	if body < 520.0 then
		damageOutside2 = true
	end

	local currentVehicle = (veh and IsEntityAVehicle(veh)) and veh or GetVehiclePedIsIn(PlayerPedId(), false)

	Citizen.Wait(100)
	SetVehicleEngineHealth(currentVehicle, engine)
	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, math.random(1,2), true)
		SetVehicleDoorBroken(currentVehicle, math.random(3,4), true)
		SetVehicleDoorBroken(currentVehicle, math.random(5,6), true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(currentVehicle, 985.0)
	end
end


RegisterNetEvent('garages:SpawnVehicle')
AddEventHandler('garages:SpawnVehicle', function(vehicle, plate, customized, state, Fuel, enginehealth, bodyhealth)
	local coordlocation = GetEntityCoords(GetPlayerPed(-1), false)
	local car = GetHashKey(vehicle)
	local customized = json.decode(customized)
	local loc = ""
	if enableHgarage then
	
		loc = json.decode(houseGarage)
		
	else
		loc = garages[selectedGarage].loc
	end


	Citizen.CreateThread(function()			
		Citizen.Wait(1000)
		local caisseo = ""
		if enableHgarage then
			caisseo = GetClosestVehicle(loc.x,loc.y,loc.z, 3.000, 0, 70)
		else
			caisseo = GetClosestVehicle(loc[1], loc[2], loc[3], 3.000, 0, 70)
		end
		if DoesEntityExist(caisseo) then
			TriggerEvent("DoLongHudText", "The area is crowded",2)
		else
			if state == "Out" and coordlocation == nil then
				TriggerEvent("DoLongHudText", "Not in garage", 2)
			else	
				RequestModel(car)
				while not HasModelLoaded(car) do
					Citizen.Wait(0)
				end

				local spawnPos = ""
				if enableHgarage then
					spawnPos = json.decode(houseGarage)
				else
					spawnPos = garages[selectedGarage].spawn
				end


				
				if enableHgarage then
					veh = CreateVehicle(car, spawnPos.x,spawnPos.y,spawnPos.z, 0.0, true, false)
					local netid = NetworkGetNetworkIdFromEntity(veh)
					SetNetworkIdCanMigrate(netid, true)
					NetworkRegisterEntityAsNetworked(VehToNet(veh))
				else
				
					veh = CreateVehicle(car, spawnPos[1], spawnPos[2], spawnPos[3], spawnPos[4], true, false)
					local netid = NetworkGetNetworkIdFromEntity(veh)
					SetNetworkIdCanMigrate(netid, true)
					NetworkRegisterEntityAsNetworked(VehToNet(veh))
				end

			

				SetModelAsNoLongerNeeded(car)
			
				if Fuel < 5 then
					Fuel = 5
				end

			DecorSetInt(veh, "CurrentFuel", Fuel)
			SetVehicleOnGroundProperly(veh)
			SetEntityInvincible(veh, false) 

			SetVehicleModKit(veh, 0)

			SetVehicleNumberPlateText(veh, plate)

			if customized.plate ~= nil then
				SetVehicleNumberPlateText(veh, customized.plate)
			end
		
			if customized.plateIndex ~= nil then
				SetVehicleNumberPlateTextIndex(veh, customized.plateIndex)
			end
		
			doCarDamages(enginehealth, bodyhealth, veh)
			if customized.dirtLevel ~= nil then
				SetVehicleDirtLevel(veh, customized.dirtLevel + 0.0)
			end
		
			if customized.color1 ~= nil then
				local color1, color2 = GetVehicleColours(veh)
				SetVehicleColours(veh, customized.color1, color2)
			end
		
			if customized.color2 ~= nil then
				local color1, color2 = GetVehicleColours(veh)
				SetVehicleColours(veh, color1, customized.color2)
			end
		
			if customized.pearlescentColor ~= nil then
				local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)
				SetVehicleExtraColours(veh, customized.pearlescentColor, wheelColor)
			end
		
			if customized.wheelColor ~= nil then
				local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)
				SetVehicleExtraColours(veh, pearlescentColor, customized.wheelColor)
			end
		
			if customized.wheels ~= nil then
				SetVehicleWheelType(veh, customized.wheels)
			end
		
			if customized.windowTint ~= nil then
				SetVehicleWindowTint(veh, customized.windowTint)
			end
		
			if customized.neonEnabled ~= nil then
				SetVehicleNeonLightEnabled(veh, 0, customized.neonEnabled[1])
				SetVehicleNeonLightEnabled(veh, 1, customized.neonEnabled[2])
				SetVehicleNeonLightEnabled(veh, 2, customized.neonEnabled[3])
				SetVehicleNeonLightEnabled(veh, 3, customized.neonEnabled[4])
			end
		
			if customized.extras ~= nil then
				for id,enabled in pairs(customized.extras) do
					if enabled then
						SetVehicleExtra(veh, tonumber(id), 0)
					else
						SetVehicleExtra(veh, tonumber(id), 1)
					end
				end
			end
		
			if customized.neonColor ~= nil then
				SetVehicleNeonLightsColour(veh, customized.neonColor[1], customized.neonColor[2], customized.neonColor[3])
			end
		
			if customized.modSmokeEnabled ~= nil then
				ToggleVehicleMod(veh, 20, true)
			end
		
			if customized.tyreSmokeColor ~= nil then
				SetVehicleTyreSmokeColor(veh, customized.tyreSmokeColor[1], customized.tyreSmokeColor[2], customized.tyreSmokeColor[3])
			end
		
			if customized.modSpoilers ~= nil then
				SetVehicleMod(veh, 0, customized.modSpoilers, false)
			end
		
			if customized.modFrontBumper ~= nil then
				SetVehicleMod(veh, 1, customized.modFrontBumper, false)
			end
		
			if customized.modRearBumper ~= nil then
				SetVehicleMod(veh, 2, customized.modRearBumper, false)
			end
		
			if customized.modSideSkirt ~= nil then
				SetVehicleMod(veh, 3, customized.modSideSkirt, false)
			end
		
			if customized.modExhaust ~= nil then
				SetVehicleMod(veh, 4, customized.modExhaust, false)
			end
		
			if customized.modFrame ~= nil then
				SetVehicleMod(veh, 5, customized.modFrame, false)
			end
		
			if customized.modGrille ~= nil then
				SetVehicleMod(veh, 6, customized.modGrille, false)
			end
		
			if customized.modHood ~= nil then
				SetVehicleMod(veh, 7, customized.modHood, false)
			end
		
			if customized.modFender ~= nil then
				SetVehicleMod(veh, 8, customized.modFender, false)
			end
		
			if customized.modRightFender ~= nil then
				SetVehicleMod(veh, 9, customized.modRightFender, false)
			end
		
			if customized.modRoof ~= nil then
				SetVehicleMod(veh, 10, customized.modRoof, false)
			end
		
			if customized.modEngine ~= nil then
				fuelmix = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveInertia')
				if tonumber(customized.modEngine) == 1 then
					boost = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
					SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', boost*1)
					SetVehicleMod(veh, 11, tonumber(customized.modEngine), false)
				elseif tonumber(customized.modEngine) == 2 then
					boost = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
					SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', boost*1.2)
					SetVehicleMod(veh, 11, tonumber(customized.modEngine), false)
				elseif tonumber(customized.modEngine) == 3 then
					boost = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
					SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', boost*1.3)
					SetVehicleMod(veh, 11, tonumber(customized.modEngine), false)
				elseif tonumber(customized.modEngine) > 3 then
					boost = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
					SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce', boost*1.4)
				end
				-- SetVehicleMod(veh, 11, tonumber(customized.modEngine), false)
			end
		
			if customized.modBrakes ~= nil then
				SetVehicleMod(veh, 12, tonumber(customized.modBrakes), false)
			end
		
			if customized.modTransmission ~= nil then
				if tonumber(customized.modTransmission) == 1 then
					local clutchup = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift')
					local downshift = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleDownShift')
					SetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', clutchup*1)
					SetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleDownShift', downshift*1)
				elseif tonumber(customized.modTransmission) == 2 then
					local clutchup = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift')
					local downshift = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleDownShift')
					SetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', clutchup*1.3)
					SetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleDownShift', downshift*1.3)
				elseif tonumber(customized.modTransmission) == 3 then
					local clutchup = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift')
					local downshift = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleDownShift')
					SetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleUpShift', clutchup*1.4)
					SetVehicleHandlingFloat(veh, 'CHandlingData', 'fClutchChangeRateScaleDownShift', downshift*1.4)
				end
				SetVehicleMod(veh, 13, tonumber(customized.modTransmission), false)
			end
		
			if customized.modHorns ~= nil then
				SetVehicleMod(veh, 14, customized.modHorns, false)
			end
		
			if customized.modSuspension ~= nil then
				SetVehicleMod(veh, 15, tonumber(customized.modSuspension), false)
			end
		
			if customized.modArmor ~= nil then
				SetVehicleMod(veh, 16, tonumber(customized.modArmor), false)
			end
		
			if customized.modTurbo ~= nil then
				ToggleVehicleMod(veh,  18, customized.modTurbo)
			end
		
			if customized.modXenon ~= nil then
				ToggleVehicleMod(veh,  22, customized.modXenon)
			end
		
			if customized.modFrontWheels ~= nil then
				SetVehicleMod(veh, 23, customized.modFrontWheels, false)
			end
		
			if customized.modBackWheels ~= nil then
				SetVehicleMod(veh, 24, customized.modBackWheels, false)
			end
		
			if customized.modPlateHolder ~= nil then
				SetVehicleMod(veh, 25, customized.modPlateHolder, false)
			end
		
			if customized.modVanityPlate ~= nil then
				SetVehicleMod(veh, 26, customized.modVanityPlate, false)
			end
		
			if customized.modTrimA ~= nil then
				SetVehicleMod(veh, 27, customized.modTrimA, false)
			end
		
			if customized.modOrnaments ~= nil then
				SetVehicleMod(veh, 28, customized.modOrnaments, false)
			end
		
			if customized.modDashboard ~= nil then
				SetVehicleMod(veh, 29, customized.modDashboard, false)
			end
		
			if customized.modDashboardColour ~= nil then
				SetVehicleDashboardColour(veh, customized.modDashboardColour)
			end
		
			if customized.modInteriorColour ~= nil then
				SetVehicleInteriorColour(veh, customized.modInteriorColour)
			end
		
			if customized.modXenonColour ~= nil then
				SetVehicleHeadlightsColour(veh, customized.modXenonColour)
			end
		
			if customized.modDial ~= nil then
				SetVehicleMod(veh, 30, customized.modDial, false)
			end
		
			if customized.modDoorSpeaker ~= nil then
				SetVehicleMod(veh, 31, customized.modDoorSpeaker, false)
			end
		
			if customized.modSeats ~= nil then
				SetVehicleMod(veh, 32, customized.modSeats, false)
			end
		
			if customized.modSteeringWheel ~= nil then
				SetVehicleMod(veh, 33, customized.modSteeringWheel, false)
			end
		
			if customized.modShifterLeavers ~= nil then
				SetVehicleMod(veh, 34, customized.modShifterLeavers, false)
			end
		
			if customized.modAPlate ~= nil then
				SetVehicleMod(veh, 35, customized.modAPlate, false)
			end
		
			if customized.modSpeakers ~= nil then
				SetVehicleMod(veh, 36, customized.modSpeakers, false)
			end
		
			if customized.modTrunk ~= nil then
				SetVehicleMod(veh, 37, customized.modTrunk, false)
			end
		
			if customized.modHydrolic ~= nil then
				SetVehicleMod(veh, 38, customized.modHydrolic, false)
			end
		
			if customized.modEngineBlock ~= nil then
				SetVehicleMod(veh, 39, customized.modEngineBlock, false)
			end
		
			if customized.modAirFilter ~= nil then
				SetVehicleMod(veh, 40, customized.modAirFilter, false)
			end
		
			if customized.modStruts ~= nil then
				SetVehicleMod(veh, 41, customized.modStruts, false)
			end
		
			if customized.modArchCover ~= nil then
				SetVehicleMod(veh, 42, customized.modArchCover, false)
			end
		
			if customized.modAerials ~= nil then
				SetVehicleMod(veh, 43, customized.modAerials, false)
			end
		
			if customized.modTrimB ~= nil then
				SetVehicleMod(veh, 44, customized.modTrimB, false)
			end
		
			if customized.modTank ~= nil then
				SetVehicleMod(veh, 45, customized.modTank, false)
			end
		
			if customized.modWindows ~= nil then
				SetVehicleMod(veh, 46, customized.modWindows, false)
			end
		
			if customized.modLivery ~= nil then
				SetVehicleMod(veh, 48, customized.modLivery, false)
				SetVehicleLivery(veh, customized.modLivery)
			end
		
			if customized.modoldLivery ~= nil then
				SetVehicleLivery(veh, customized.modoldLivery)
			end

--			TriggerEvent("keys:addNew",veh,plate)
			TriggerServerEvent("garage:addKeys", plate)
			SetVehicleHasBeenOwnedByPlayer(veh,true)
			

			local id = NetworkGetNetworkIdFromEntity(veh)
			SetNetworkIdCanMigrate(id, true)
			



			TriggerServerEvent('garages:SetVehOut', veh, plate)

				SetPedIntoVehicle(PlayerPedId(), veh, - 1)

			if GetEntityModel(veh) == `rumpo4` then
				SetVehicleLivery(veh,0)
			end
			
			if GetEntityModel(veh) == `rumpo` then
				SetVehicleLivery(veh,0)
			end

			if GetEntityModel(veh) == `taxi` then

				SetVehicleExtra(veh, 8, 1)
				SetVehicleExtra(veh, 9, 1)
				SetVehicleExtra(veh, 6, 0)

			end

			TriggerEvent("chop:plateoff",plate)
		end
		end
			
		TriggerServerEvent("garages:CheckGarageForVeh", exports['isPed']:isPed('cid'))


	end)
end)



function round(n)
    return math.floor(n + 0.5)
end

function GetVehicleProperties(vehicle)
	local vehicleProps = {}
	vehicleProps["engineHealth"] = GetVehicleEngineHealth(vehicle)
	vehicleProps["bodyHealth"] = GetVehicleBodyHealth(vehicle)
end

AddEventHandler('garages:StoreVehicle', function()
    coordA = GetEntityCoords(PlayerPedId(), 1)
    coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 100.0, 0.0)
    local vehicle = getVehicleInDirection(coordA, coordB)
	local plate = GetVehicleNumberPlateText(vehicle)
	local fuelvalue = exports["prp-oGasStations"]:GetFuel(vehicle)
	local enginehealth = GetVehicleEngineHealth(vehicle)
	local bodyhealth = GetVehicleBodyHealth(vehicle)
	local vehicleProps = GetVehicleProperties(vehicle)
    if vehicle == 0 then
		TriggerEvent('DoShortHudText', 'No vehicle', 2)
		CloseMenu()
	else
		local pos = ""
		if enableHgarage then
			pos = houseShell..'-'..houseID
			current_used_garage = houseShell..'-'..houseID
		else
	
			pos = garages[selectedGarage].loc
			current_used_garage = garages[selectedGarage].garage
		end	
		SetEntityAsMissionEntity(vehicle, true, true)
		DeleteVehicle(vehicle)
		DeleteEntity(vehicle)
		TriggerEvent('keys:remove', vehicle)
		TriggerServerEvent('garages:SetVehIn', plate, current_used_garage, fuelvalue, enginehealth, bodyhealth)
		CloseMenu()
	end
	
end)

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

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
    if distance > 3000 then vehicle = nil end
    return vehicle ~= nil and vehicle or 0
end



local colorblind = false
RegisterNetEvent('option:colorblind')
AddEventHandler('option:colorblind',function()
	colorblind = not colorblind

	if colorblind then
		markerColor = 
		{
			["Red"] = 200,
			["Green"] = 200,
			["Blue"] = 0
		}
	else 
		markerColor = 
		{
			["Red"] = 222,
			["Green"] = 50,
			["Blue"] = 50
		}
	end
end)


function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end