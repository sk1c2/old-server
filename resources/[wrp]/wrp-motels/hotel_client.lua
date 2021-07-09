local buildingSpawn = { x = 175.09986877441 , y = -904.7946166992, z = -98.999984741211}
local ingarage = false
--Max X = 190 Min X = ?
-- Max Z = 30 Min Z = -98
local garageNumber = 0
local curRoom = { x = 1420.0, y = 1420.0, z = -900.0 }
local centerPos = { x = 343.01187133789, y = -950.25201416016, z = -99.0 }
local myroomcoords = { x = 175.09986877441 , y = -904.7946166992, z = -98.999984741211 }
local currentRoom = {}
local CurrentForced = {x = 0.0,y = 0.0,z=0.0}
local insideApartment = false
local showhelp = false
currentselection = 1
curappartmentnumber = 0
forcedID = 0
local isnew = false
--max X = ? max Y ? max Z ?
-- min X = ?  min Y ? min Z = 900 ?

-- 3 garages
--{172.55403137207,-1000.921875,-98.999977111816},
--{199.30535888672,-999.80517578125,-99.000007629395},
--{231.96057128906,-977.81085205078,-98.999877929688},


-- jail process
--{402.85455322266,-996.62835693359,-99.000267028809},
-- 175.614 heading

--shop spawn needs to be above ground, its render distance seems to be 90 


-- Anything that needs to happen upon full log in of character, whether its swapped or just logged in, run it here.
-- we should look at pulling all this at one go at some point
RegisterNetEvent('Relog')
AddEventHandler('Relog', function()
	currentselection = 1
	TriggerServerEvent('isVip')
	TriggerEvent('rehab:changeCharecter')
	TriggerServerEvent('checkTypes')
	TriggerEvent("resetinhouse")
	TriggerEvent("fx:clear")
	TriggerServerEvent('tattoos:retrieve')
	TriggerServerEvent('Blemishes:retrieve')
	TriggerServerEvent("currentconvictions")
	TriggerServerEvent("GarageData")
    TriggerServerEvent("Evidence:checkDna")
	TriggerEvent("banking:viewBalance")
	TriggerServerEvent("police:getLicensesCiv")
	TriggerServerEvent('wrp-doors:requestlatest')
	TriggerServerEvent("item:UpdateItemWeight")
	TriggerServerEvent("wrp-weapons:getAmmo")
	TriggerServerEvent("ReturnHouseKeys")
	TriggerServerEvent("requestOffices")
    Wait(500)
    TriggerServerEvent("Police:getMeta")
   	-- Anything that might need to wait for the client to get information, do it here.
	Wait(3000)
	TriggerServerEvent("bones:server:requestServer")
	TriggerEvent("apart:GetItems")
	TriggerServerEvent("TokoVoip:clientHasSelecterCharecter")
	
	Wait(4000)
	TriggerServerEvent('wrp-base:sv:player_control')
	TriggerServerEvent('wrp-base:sv:player_settings')
end)

apartments1 = {
	[1] = { ["x"] = 283.9516,["y"] = -643.2749, ["z"] = 42.01863},
	[2] = { ["x"] = 287.6734,["y"] = -644.5722, ["z"] = 42.01863},
	[3] = { ["x"] = 291.348,["y"] = -645.9218, ["z"] = 42.01863}, 
	[4] = { ["x"] = 281.3154,["y"] = -650.0172, ["z"] = 42.01865}, 
	





}


myRoomNumber = 0
myRoomLock = true
curRoomType = 1
myRoomType = 1
hid = 0 
isForced = false

function inRoom()
	if #(vector3(myroomcoords.x,myroomcoords.y,myroomcoords.z) - GetEntityCoords(PlayerPedId())) < 40.0 then
		return true
	else
		return false
	end
end

RegisterNetEvent('hotel:forceOut')
AddEventHandler('hotel:forceOut', function(roomNumber,roomtype)
	isForced = false
	returnCurrentRoom(roomtype,roomNumber)
	if #(vector3(CurrentForced.x, CurrentForced.y, CurrentForced.z) - GetEntityCoords(PlayerPedId())) < 90.0 then
		CleanUpArea()
		if roomNumber == 2 then
			SetEntityCoords(PlayerPedId(),267.48132324219,-638.818359375,42.020294189453)
		elseif roomNumber == 3 then
			SetEntityCoords(PlayerPedId(),160.26762390137,-641.96905517578,47.073524475098)
		end
	end
	if myRoomNumber == roomNumber then
		CleanUpArea()
		if #(vector3(CurrentForced.x, CurrentForced.y, CurrentForced.z) - GetEntityCoords(PlayerPedId())) < 90.0 then
			if roomNumber == 2 then
				SetEntityCoords(PlayerPedId(),267.48132324219,-638.818359375,42.020294189453)
			elseif roomNumber == 3 then
				SetEntityCoords(PlayerPedId(),160.26762390137,-641.96905517578,47.073524475098)
			end
		end
	end
end)

RegisterNetEvent('hotel:AttemptUpgrade')
AddEventHandler('hotel:AttemptUpgrade', function()
	if #(vector3(260.16, -374.99, -44.14) - GetEntityCoords(PlayerPedId())) < 3.0 then
		local LocalPlayer = exports['wrp-base']:getModule('LocalPlayer')
		local Player = LocalPlayer:getCurrentCharacter()
		if Player.bank >= 25000 then
			TriggerServerEvent('hotel:upgradeApartment', exports['isPed']:isPed('cid'), myRoomType, myRoomNumber)
			TriggerEvent("hotel:myroomtype",myRoomType)
			LocalPlayer:removeBank(exports['isPed']:isPed('cid'), 25000)
		elseif Player.cash >= 25000 then
			TriggerServerEvent('hotel:upgradeApartment', exports['isPed']:isPed('cid'), myRoomType, myRoomNumber)
			TriggerEvent("hotel:myroomtype",myRoomType)
			LocalPlayer:removeCash(exports['isPed']:isPed('cid'), 25000)
		else
			TriggerEvent('DoLongHudText', "Insufficient funds")
		end
	end	
end)

RegisterNetEvent('hotel:AddCashToHotel')
AddEventHandler('hotel:AddCashToHotel', function(amount)
	if inRoom() then
		TriggerServerEvent('hotel:AddCashToHotel', amount)
		Citizen.Wait(555)
		TriggerServerEvent("hotel:getInfo")
	end
end)

RegisterNetEvent('hotel:SetID')
AddEventHandler('hotel:SetID', function(hidX)
	hid = hidX
end)
RegisterNetEvent('hotel:SetID2')
AddEventHandler('hotel:SetID2', function(hidX)
	hid = hidX
	forcedID = hidX
end)
RegisterNetEvent('hotel:RemoveCashFromHotel')
AddEventHandler('hotel:RemoveCashFromHotel', function(amount)
	if inRoom() then
		TriggerServerEvent('hotel:RemoveCashFromHotel', amount)
		Citizen.Wait(555)
		TriggerServerEvent("hotel:getInfo")
	end		
end)

RegisterNetEvent('hotel:AddDMToHotel')
AddEventHandler('hotel:AddDMToHotel', function(amount)
	if inRoom() then
		TriggerServerEvent('hotel:AddDMToHotel', amount)
		Citizen.Wait(555)
		TriggerServerEvent("hotel:getInfo")
	end		
end)

RegisterNetEvent('hotel:RemoveDMFromHotel')
AddEventHandler('hotel:RemoveDMFromHotel', function(amount)
	if inRoom() then
		TriggerServerEvent('hotel:RemoveDMFromHotel', amount)
		Citizen.Wait(555)
		TriggerServerEvent("hotel:getInfo")
	end		
end)

RegisterNetEvent("hotel:forceEnter")
AddEventHandler("hotel:forceEnter", function(roomNumber,roomtype)
	roomNumber = tonumber(roomNumber)
	roomtype = tonumber(roomtype)
	isForced = true
	returnCurrentRoom(roomtype,roomNumber)
end)

function returnCurrentRoom(roomtype,roomNumber)
	if roomtype == 3 then
		local generator = { x = -265.68209838867 , y = -957.06573486328, z = 145.824577331543}
		if roomNumber > 0 and roomNumber < 7 then
			--generator = { x = -143.16976928711 , y = -596.31140136719, z = 61.95349121093}
			--generator.z = (61.9534912) + ((roomNumber * 11.0) * roomType)
			generator = { x = 131.0290527343, y = -644.0509033203, z = 68.025619506836}
			generator.z = (68.0534912) + ((roomNumber * 11.0))
		end

		if roomNumber > 6 and roomNumber < 14 then
			generator = { x = -134.43560791016 , y = -638.13916015625, z = 68.953491210938}
			roomNumber = roomNumber - 6
			generator.z = (61.9534912) + ((roomNumber * 11.0))
		end

		if roomNumber > 13 and roomNumber < 20 then
			generator = { x = -181.440234375 , y = -584.04815673828, z = 68.95349121093}
			roomNumber = roomNumber - 13
			generator.z = (61.9534912) + ((roomNumber * 11.0))
		end

		if roomNumber > 19 and roomNumber < 26 then
			generator = { x = -109.9752227783, y = -570.272351074, z = 61.9534912}
			roomNumber = roomNumber - 19
			generator.z = (61.9534912) + ((roomNumber * 11.0))
		end

		if roomNumber > 25 and roomNumber < 38 then
			generator = { x = -3.9463002681732, y = -693.2456665039, z = 103.0334701538}
			roomNumber = roomNumber - 25
			generator.z = (103.0534912) + ((roomNumber * 11.0))
		end

		if roomNumber > 37 and roomNumber < 49 then
			generator = { x = 140.0758819580, y = -748.12322998, z = 87.0334701538}
			roomNumber = roomNumber - 37
			generator.z = (87.0534912) + ((roomNumber * 11.0))
		end

		if roomNumber > 48 and roomNumber < 60 then
			generator = { x = 131.0290527343, y = -644.0509033203, z = 68.025619506836}
			roomNumber = roomNumber - 48
			generator.z = (68.0534912) + ((roomNumber * 11.0))
		end

		CurrentForced = generator

	elseif roomtype == 2 then 
		local generator = { x = 175.09986877441 , y = -904.7946166992, z = -98.999984741211}
		generator.x = (175.09986877441) + ((roomNumber * 25.0))
		generator.y = (-904.7946166992) - ((roomNumber * 25.0))
		CurrentForced = generator
	end
end


RegisterNetEvent('doApartHelp')
AddEventHandler('doApartHelp', function()
	showhelp = true
end)

RegisterNetEvent('hotel:updateLockStatus')
AddEventHandler('hotel:updateLockStatus', function(newStatus)
	myRoomLock = newStatus
end)

RegisterNetEvent('refocusent')
AddEventHandler('refocusent', function()
	TriggerEvent("DoLongHudText","Refocusing entity - abuse of this will result in a ban",2)
	ClearFocus()
end)

RegisterNetEvent('hotel:createRoomFirst')
AddEventHandler('hotel:createRoomFirst', function(numMultiplier,roomType)
	myRoomNumber = numMultiplier
	myRoomType = roomType
	TriggerEvent("hotel:myroomtype",myRoomType)
end)

local disablespawn = false
RegisterNetEvent('disablespawn')
AddEventHandler('disablespawn', function(selke)
	disablespawn = selke
end)


local myspawnpoints = {}
local spawning = false
RegisterNetEvent('hotel:createRoom1')
AddEventHandler('hotel:createRoom1', function(numMultiplier,roomType,mykeys,illness,isImprisoned,isClothesSpawn)
	local imprisoned = false
	imprisoned = isImprisoned
	spawning = false
	TriggerEvent("spawning",true)
	TriggerServerEvent("vSync:requestSync")
	FreezeEntityPosition(PlayerPedId(),true)
	SetEntityCoords(PlayerPedId(), 152.09986877441 , -1004.7946166992, -98.999984741211)
	SetEntityInvincible(PlayerPedId(),true)
	print(numMultiplier)
	myRoomNumber = numMultiplier
	myRoomType = roomType

	TriggerEvent("hotel:myroomtype",myRoomType)
	myspawnpoints  = {
		[1] =  { ['x'] = -204.93,['y'] = -1010.13,['z'] = 29.55,['h'] = 180.99, ['info'] = ' Altee Street Train Station', ["typeSpawn"] = 1 },
		[2] =  { ['x'] = 272.16,['y'] = 185.44,['z'] = 104.67,['h'] = 320.57, ['info'] = ' Vinewood Blvd Taxi Stand', ["typeSpawn"] = 1 },
		[3] =  { ['x'] = -1833.96,['y'] = -1223.5,['z'] = 13.02,['h'] = 310.63, ['info'] = ' The Boardwalk', ["typeSpawn"] = 1 },
		[4] =  { ['x'] = 145.62,['y'] = 6563.19,['z'] = 32.0,['h'] = 42.83, ['info'] = ' Paleto Gas Station', ["typeSpawn"] = 1 },
		[5] =  { ['x'] = -214.24,['y'] = 6178.87,['z'] = 31.17,['h'] = 40.11, ['info'] = ' Paleto Bus Stop', ["typeSpawn"] = 1 },
		[6] =  { ['x'] = 1122.11,['y'] = 2667.24,['z'] = 38.04,['h'] = 180.39, ['info'] = ' Harmony Motel', ["typeSpawn"] = 1 },
		[7] =  { ['x'] = 453.29,['y'] = -662.23,['z'] = 28.01,['h'] = 5.73, ['info'] = ' LS Bus Station', ["typeSpawn"] = 1 },
		[8] =  { ['x'] = -1266.53,['y'] = 273.86,['z'] = 64.66,['h'] = 28.52, ['info'] = ' The Richman Hotel', ["typeSpawn"] = 1 },
	}

	--[[local devspawn = exports["storage"]:tryGet("vector4","devspawn")
	if devspawn then
		myspawnpoints[#myspawnpoints + 1] = { ['x'] = devspawn.x,['y'] = devspawn.y,['z'] = devspawn.z,['h'] = devspawn.w, ['info'] = 'Dev Spawn', ["typeSpawn"] = 1 }
	end]]--

	if illness == "dead" or illness == "icu" then
		return
	end

	if roomType == 1 then
		myspawnpoints[#myspawnpoints + 1] = { ['x'] = -267.4289,['y'] = -959.689,['z'] = 31.22315,['h'] = 28.214147567749, ['info'] = ' Apartments 1', ["typeSpawn"] = 2 }
	elseif roomType == 2 then
		myspawnpoints[#myspawnpoints + 1] = { ['x'] = 269.3571, ['y'] = -634.2675,['z'] = 42.00,['h'] = 67.09, ['info'] = ' Apartments 2', ["typeSpawn"] = 2 }
	else
		myspawnpoints[#myspawnpoints + 1] = { ['x'] = 173.96,['y'] = -631.29,['z'] = 47.08,['h'] = 303.12, ['info'] = ' Apartments 3', ["typeSpawn"] = 2 }
	end

	--[[local rooster = exports["isPed"]:GroupRank("rooster_academy")
	if rooster >= 2 then
		myspawnpoints[#myspawnpoints + 1] = { ['x'] = -172.83,['y'] = 331.17,['z'] = 93.76,['h'] = 266.08, ['info'] = ' Rooster Cab', ["typeSpawn"] = 1 }
	end]]--
	if mykeys ~= 0 then
		for i, v in pairs(mykeys) do
			local house_model = tonumber(mykeys[i][1]["house_model"])
			local house_id = tonumber(mykeys[i][1]["house_id"])

			local keyinsert = robberycoords[house_id]

			if house_model == 2 then
				keyinsert = robberycoordsMansions[house_id]
				keyinsert["info"] = mykeys[i][1]["house_name"]
			end
			if house_model < 3 or house_model == 5 then
				keyinsert["typeSpawn"] = 3
				keyinsert["info"] = mykeys[i][1]["house_name"]
				keyinsert["house_model"] = mykeys[i][1]["house_model"]
				keyinsert["house_id"] = mykeys[i][1]["house_id"]
				myspawnpoints[#myspawnpoints + 1] = keyinsert
			end
		end
	end
	if isnew == true then
		local apartmentName = ' Apartments 1'
		if roomType == 1 then
			apartmentName = ' Apartments 1'
		elseif roomType == 2 then
			apartmentName = ' Apartments 2'
		else
			apartmentName = ' Apartments 3'
		end

		--[[for k,v in pairs(myspawnpoints) do
			if v.info == apartmentName then
				currentselection = k
			end
		end]]--

		confirmSpawning(true)
	else
		if not imprisoned then
			SendNUIMessage({
				openSection = "main",
			})

			SetNuiFocus(true,true)
			doSpawn(myspawnpoints)
			DoScreenFadeIn(2500)
			doCamera()
		elseif imprisoned then
			TriggerServerEvent("np-shops:getCharecter")
			DoScreenFadeIn(2500)
			doCamera(true)
			prisionSpawn()
		end
	end
 
	

end)

function prisionSpawn()
	spawning = true
	DoScreenFadeOut(100)
	Citizen.Wait(100)


	local x = 1802.51
	local y = 2607.19
	local z = 46.01
	local h = 93.0

	ClearFocus()
	SetNuiFocus(false,false)
	-- spawn them here.
    
    
	RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
	DestroyCam(cam, false)
	SetEntityCoords(PlayerPedId(),x,y,z)
	SetEntityHeading(PlayerPedId(),h)		

	SetEntityInvincible(PlayerPedId(),false)
	FreezeEntityPosition(PlayerPedId(),false)

	Citizen.Wait(2000)
	TriggerEvent("attachWeapons")
	TriggerEvent("spawning",false)

	TriggerEvent("tokovoip:onPlayerLoggedIn", true)
	Citizen.Wait(2000)
	TriggerServerEvent("request-dropped-items")
	TriggerServerEvent("HOWMUCHCASHUHGOT")
	TriggerServerEvent("server-request-update",exports["isPed"]:isPed("cid"))
	TriggerServerEvent("jail:charecterFullySpawend")
	if(DoesCamExist(cam)) then
		DestroyCam(cam, false)
	end
	 TriggerServerEvent("stocks:retrieveclientstocks")
end

RegisterNUICallback('selectedspawn', function(data, cb)

	if spawning then
		return
	end
    currentselection = data.tableidentifier
    -- altercam
    doCamera()
end)
RegisterNUICallback('confirmspawn', function(data, cb)
	spawning = true
	DoScreenFadeOut(100)
	Citizen.Wait(100)
	SendNUIMessage({
		openSection = "close",
	})	
	confirmSpawning(false)
end)

function confirmSpawning(isClothesSpawn)

	local x = myspawnpoints[currentselection]["x"]
	local y = myspawnpoints[currentselection]["y"]
	local z = myspawnpoints[currentselection]["z"]
	local h = myspawnpoints[currentselection]["h"]

	ClearFocus()

	SetNuiFocus(false,false)
	-- spawn them here.
    
    
	RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
	DestroyCam(cam, false)

	
	if myspawnpoints[currentselection]["typeSpawn"] == 1 then
		SetEntityCoords(PlayerPedId(),x,y,z)
		SetEntityHeading(PlayerPedId(),h)		
	elseif myspawnpoints[currentselection]["typeSpawn"] == 2 then
		defaultSpawn()
	elseif myspawnpoints[currentselection]["typeSpawn"] == 3 then
		local house_id = myspawnpoints[currentselection]["house_id"]
		local house_model = myspawnpoints[currentselection]["house_model"]
		TriggerServerEvent("house:enterhouse",exports['isPed']:isPed('cid'), false,house_id,house_model,false)
	else
		print("Error Spawning?")
	end
	
	--TriggerServerEvent("server-request-update")
	SetEntityInvincible(PlayerPedId(),false)
	FreezeEntityPosition(PlayerPedId(),false)
	TriggerEvent("attachWeapons")
	TriggerEvent("spawning",false)
	TriggerEvent('DoLongHudText', "Tax is currently set to: 15%")
	TriggerServerEvent('admin:getGroup')
	TriggerServerEvent('wrp-policejob:spawned')
	TriggerEvent('givemethehandle')
  	TriggerServerEvent('getYP')
	TriggerServerEvent('stocks:retrieve', exports['isPed']:isPed('cid'))
	TriggerServerEvent("raid_clothes:get_character_current", exports['isPed']:isPed('cid'))
	TriggerServerEvent("raid_clothes:get_character_face", exports['isPed']:isPed('cid'))
    TriggerServerEvent("raid_clothes:retrieve_tats", exports['isPed']:isPed('cid'))
    TriggerServerEvent('server-inventory-request-identifier')
    TriggerServerEvent('server-request-update', "ply-"..exports['isPed']:isPed('cid'))
	local cid = exports['isPed']:isPed('cid')
	TriggerServerEvent('bank:getlogs', cid)
		Citizen.Wait(5000)
	DoScreenFadeIn(4000)

	if isClothesSpawn then
		SetEntityCoords(PlayerPedId(), -1044.615, -2749.328, 21.36)
		SetEntityHeading(PlayerPedId(), 324.80)
        FreezeEntityPosition(GetPlayerPed(-1), false)
        RenderScriptCams(false, true, 1, true, true)
		TriggerEvent('raid_clothes:defaultReset')
		if not exports["wrp-inventory"]:hasEnoughOfItem("idcard",1,false) then
			TriggerEvent("wrp-banned:getID","idcard",1,true)
		end
		if not exports["wrp-inventory"]:hasEnoughOfItem("mobilephone",1,false)then
			TriggerEvent("wrp-banned:getID","mobilephone",1)
		end
	end

	TriggerEvent("tokovoip:onPlayerLoggedIn", true)
	Citizen.Wait(2000)

	if(DoesCamExist(cam)) then
		DestroyCam(cam, false)
	end
	TriggerServerEvent("stocks:retrieveclientstocks")


end

--	mykeys[i] = { ["house_name"] = results[i].house_name, ["house_poi"] = pois,  ["table_id"] = results[i].id, ["owner"] = true, ["house_id"] = results[i].house_id, ["house_model"] = results[i].house_model, ["house_name"] = results[i].house_name }

-- "typeSpawn" 1 = no building, 2 = default housing, 3 = house/offices with address
function doSpawn(array)

	for i = 1, #array do

		SendNUIMessage({
			openSection = "enterspawn",
			textmessage = array[i]["info"],
			tableid = i,
		})
	end
	TriggerServerEvent("np-shops:getCharecter")
	-- /halt script fill html and allow selection.
end

cam = 0
local camactive = false
local killcam = true
function doCamera(prison)
	killcam = true
	if spawning then
		return
	end
	Citizen.Wait(1)
	killcam = false
	local camselection = currentselection
	DoScreenFadeOut(1)
	if(not DoesCamExist(cam)) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	local x,y,z,h

	if prison then
		 x = 1802.51
		 y = 2607.19
		 z = 46.01
		 h = 93.0
	else
		 x = myspawnpoints[currentselection]["x"]
		 y = myspawnpoints[currentselection]["y"]
		 z = myspawnpoints[currentselection]["z"]
		 h = myspawnpoints[currentselection]["h"]
	end
	
	i = 3200
	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
	SetCamActive(cam,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	DoScreenFadeIn(1500)
	local camAngle = -90.0
	while i > 1 and camselection == currentselection and not spawning and not killcam do
		local factor = i / 50
		if i < 1 then i = 1 end
		i = i - factor
		SetCamCoord(cam, x,y,z+i)
		if i < 1200 then
			DoScreenFadeIn(600)
		end
		if i < 90.0 then
			camAngle = i - i - i
		end
		SetCamRot(cam, camAngle, 0.0, 0.0)
		Citizen.Wait(1)
	end

end


function defaultSpawn()
	moveToMyHotel(myRoomType)	
	TriggerEvent("hotel:myroomtype",myRoomType)
end


RegisterNetEvent('hotel:teleportRoom')
AddEventHandler('hotel:teleportRoom', function(numMultiplier,roomType)
	local numMultiplier = tonumber(numMultiplier)
	local roomType = tonumber(roomType)
	if (#(vector3(106.11, -647.76, 45.1) - GetEntityCoords(PlayerPedId())) < 5 and roomType == 3) or (#(vector3(160.26762390137,-641.96905517578,47.073524475098) - GetEntityCoords(PlayerPedId())) < 5 and roomType == 3) or (#(vector3(267.48132324219,-638.818359375,42.020294189453) - GetEntityCoords(PlayerPedId())) < 5 and roomType == 2) then
		moveToMultiplierHotel(numMultiplier,roomType)
	elseif (#(vector3(apartments1[numMultiplier]["x"],apartments1[numMultiplier]["y"],apartments1[numMultiplier]["z"]) - GetEntityCoords(PlayerPedId())) < 5 and roomType == 1) then
		moveToMultiplierHotel(numMultiplier,roomType)
	else
		TriggerEvent("DoShortHudText","No Entry Point.",2)
	end
	
end)

				

RegisterNetEvent('attemptringbell')
AddEventHandler("attemptringbell",function(apnm)
	if 
	(#(vector3(160.29, -642.06, 47.08) - GetEntityCoords(PlayerPedId()) < 5)) or
	(#(vector3(267.52, -638.79, 42.02) - GetEntityCoords(PlayerPedId()) < 5)) or
	(#(vector3(313.09, -225.83, 54.23) - GetEntityCoords(PlayerPedId()) < 5))
	then
		TriggerServerEvent("confirmbellring",apnm)
		TriggerEvent("buzzer")
	else
		TriggerEvent("DoLongHudText","You are not near a buzzer point.")
	end
end)

RegisterNetEvent('buzzbuzz')
AddEventHandler("buzzbuzz",function(apartmentnumber)

	if tonumber(apartmentnumber) == 0 then
		return
	end
	if tonumber(curappartmentnumber) == tonumber(apartmentnumber) then
		TriggerEvent('InteractSound_CL:PlayOnOne','doorbell', 0.5)
	end

end)

local penis = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if penis == true then
			TriggerEvent('vSync:toggle',false)
			SetBlackout(false)
			ClearOverrideWeather()
			ClearWeatherTypePersist()
			SetWeatherTypePersist('CLEAR')
			SetWeatherTypeNow('CLEAR')
			SetWeatherTypeNowPersist('CLEAR')
			NetworkOverrideClockTime(23, 0, 0)
		end
	end
end)

RegisterNetEvent('inhotel')
AddEventHandler('inhotel', function(toggle)
	if toggle == true then
		penis = true
	else
		penis = false
		TriggerEvent('vSync:toggle',true)
		TriggerServerEvent('vSync:requestSync')
	end
end)

RegisterNetEvent('buzzer')
AddEventHandler("buzzer",function()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1.0, 'doorbell', 0.5)
end)

function moveToMyHotel(roomType)
	TriggerEvent("resetPhone")
	processBuildType(myRoomNumber,roomType)
end

function moveToMultiplierHotel(numMultiplier,roomType)
	processBuildType(tonumber(numMultiplier),tonumber(roomType))
end

function processBuildType(numMultiplier,roomType)
	DoScreenFadeOut(1)
	insideApartment = true
	TriggerEvent("DensityModifierEnable",false)
	TriggerEvent("inhotel",true)
	SetEntityInvincible(PlayerPedId(), true)
	TriggerEvent("enabledamage",false)
	--DoScreenFadeOut(1)

	TriggerEvent("dooranim")	
	if roomType == 1 then
		buildRoom(numMultiplier,roomType)
		if showhelp then
			TriggerEvent("DoLongHudText","Welcome to the Hotel, Press P to open your phone and use the help app for more information!")
			showhelp = false
		end
	elseif roomType == 2 then
		buildRoom2(numMultiplier,roomType)
	elseif roomType == 3 then
		buildRoom3(numMultiplier,roomType)
	end

	curappartmentnumber = numMultiplier

	TriggerEvent('InteractSound_CL:PlayOnOne','DoorClose', 0.7)
	TriggerEvent("dooranim")

	CleanUpPeds()
	--DoScreenFadeIn(100)
	SetEntityInvincible(PlayerPedId(), false)
	FreezeEntityPosition(PlayerPedId(),false)
	TriggerEvent("enabledamage",true)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
end
function CleanUpPeds()
    local playerped = PlayerPedId()
    local plycoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstPed()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(plycoords - pos)
        if distance < 50.0 and ObjectFound ~= playerped then
    		if IsPedAPlayer(ObjectFound) or IsEntityAVehicle(ObjectFound) then
    		else
    			DeleteEntity(ObjectFound)
    		end            
        end
        success, ObjectFound = FindNextPed(handle)
    until not success
    EndFindPed(handle)
end

function CleanUpArea()
    local playerped = PlayerPedId()
    local plycoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstObject()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(plycoords - pos)
        if distance < 50.0 and ObjectFound ~= playerped then
        	if IsEntityAPed(ObjectFound) then
        		if IsPedAPlayer(ObjectFound) then
        		else
        			DeleteObject(ObjectFound)
        		end
        	else
        		if not IsEntityAVehicle(ObjectFound) and not IsEntityAttached(ObjectFound) then
	        		DeleteObject(ObjectFound)
	        	end
        	end            
        end
        success, ObjectFound = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    curappartmentnumber = 0
    TriggerEvent("DensityModifierEnable",true)
	TriggerEvent("inhotel",false)
end

function buildRoom(numMultiplier,roomType)
	-- this coord is the default object location, we use it to spawn in the interior.

	local generator = { x=175.09986877441 , y = -904.7946166992, z = -98.999984741211}
	generator.x = (175.09986877441) + ((numMultiplier * 12.0))
	
	if numMultiplier == myRoomNumber then
		myroomcoords = generator
	else
		curRoom = generator
	end

	RequestModel(GetHashKey("playerhouse_hotel"))
	while not HasModelLoaded(GetHashKey("playerhouse_hotel")) do
		RequestModel(GetHashKey("playerhouse_hotel"))
		Citizen.Trace("Loading Model")
   		Citizen.Wait(100)
	end

  	SetEntityCoords(PlayerPedId(), 152.09986877441, -1004.7946166992, -98.999984741211)
	SetEntityHeading(PlayerPedId(), 350.25)
	FreezeEntityPosition(PlayerPedId(), true)
	Citizen.Wait(4500)

	local building = CreateObject(GetHashKey('playerhouse_hotel'),generator.x - 0.7,generator.y-0.4,generator.z-1.42,false,false,false)

	FreezeEntityPosition(building,true)
	Citizen.Wait(100)
	
	CreateObject(GetHashKey("v_49_motelmp_stuff"),generator.x,generator.y,generator.z,false,false,false)
	CreateObject(GetHashKey("v_49_motelmp_bed"),generator.x+1.4,generator.y-0.55,generator.z,false,false,false)
	CreateObject(GetHashKey("v_49_motelmp_clothes"),generator.x-2.0,generator.y+2.0,generator.z+0.15,false,false,false)
	CreateObject(GetHashKey("v_49_motelmp_winframe"),generator.x+0.74,generator.y-4.26,generator.z+1.11,false,false,false)
	CreateObject(GetHashKey("v_49_motelmp_glass"),generator.x+0.74,generator.y-4.26,generator.z+1.13,false,false,false)
	CreateObject(GetHashKey("v_49_motelmp_curtains"),generator.x+0.74,generator.y-4.15,generator.z+0.9,false,false,false)

	CreateObject(GetHashKey("v_49_motelmp_screen"),generator.x-2.21,generator.y-0.6,generator.z+0.79,false,false,false)
	--props
	CreateObject(GetHashKey("v_res_fa_trainer02r"),generator.x-1.9,generator.y+3.0,generator.z+0.38,false,false,false)
	CreateObject(GetHashKey("v_res_fa_trainer02l"),generator.x-2.1,generator.y+2.95,generator.z+0.38,false,false,false)

	local sink = CreateObject(GetHashKey("prop_sink_06"),generator.x+1.1,generator.y+4.0,generator.z,false,false,false)
	local chair1 = CreateObject(GetHashKey("prop_chair_04a"),generator.x+2.1,generator.y-2.4,generator.z,false,false,false)
	local chair2 = CreateObject(GetHashKey("prop_chair_04a"),generator.x+0.7,generator.y-3.5,generator.z,false,false,false)
	local kettle = CreateObject(GetHashKey("prop_kettle"),generator.x-2.3,generator.y+0.6,generator.z+0.9,false,false,false)
	local tvCabinet = CreateObject(GetHashKey("Prop_TV_Cabinet_03"),generator.x-2.3,generator.y-0.6,generator.z,false,false,false)
	local tv = CreateObject(GetHashKey("prop_tv_06"),generator.x-2.3,generator.y-0.6,generator.z+0.7,false,false,false)
	local toilet = CreateObject(GetHashKey("Prop_LD_Toilet_01"),generator.x+2.1,generator.y+2.9,generator.z,false,false,false)
	local clock = CreateObject(GetHashKey("Prop_Game_Clock_02"),generator.x-2.55,generator.y-0.6,generator.z+2.0,false,false,false)
	local phone = CreateObject(GetHashKey("v_res_j_phone"),generator.x+2.4,generator.y-1.9,generator.z+0.64,false,false,false)
	local ironBoard = CreateObject(GetHashKey("v_ret_fh_ironbrd"),generator.x-1.7,generator.y+3.5,generator.z+0.15,false,false,false)
	local iron = CreateObject(GetHashKey("prop_iron_01"),generator.x-1.9,generator.y+2.85,generator.z+0.63,false,false,false)
	local mug1 = CreateObject(GetHashKey("V_Ret_TA_Mug"),generator.x-2.3,generator.y+0.95,generator.z+0.9,false,false,false)
	local mug2 = CreateObject(GetHashKey("V_Ret_TA_Mug"),generator.x-2.2,generator.y+0.9,generator.z+0.9,false,false,false)
	CreateObject(GetHashKey("v_res_binder"),generator.x-2.2,generator.y+1.3,generator.z+0.87,false,false,false)
	
	FreezeEntityPosition(sink,true)
	FreezeEntityPosition(chair1,true)	
	FreezeEntityPosition(chair2,true)
	FreezeEntityPosition(tvCabinet,true)	
	FreezeEntityPosition(tv,true)		
	SetEntityHeading(chair1,GetEntityHeading(chair1)+270)
	SetEntityHeading(chair2,GetEntityHeading(chair2)+180)
	SetEntityHeading(kettle,GetEntityHeading(kettle)+90)
	SetEntityHeading(tvCabinet,GetEntityHeading(tvCabinet)+90)
	SetEntityHeading(tv,GetEntityHeading(tv)+90)
	SetEntityHeading(toilet,GetEntityHeading(toilet)+270)
	SetEntityHeading(clock,GetEntityHeading(clock)+90)
	SetEntityHeading(phone,GetEntityHeading(phone)+220)
	SetEntityHeading(ironBoard,GetEntityHeading(ironBoard)+90)
	SetEntityHeading(iron,GetEntityHeading(iron)+230)
	SetEntityHeading(mug1,GetEntityHeading(mug1)+20)
	SetEntityHeading(mug2,GetEntityHeading(mug2)+230)
  	SetEntityCoords(PlayerPedId(), generator.x-1.0755,generator.y-4.20,generator.z+0.10)
  	SetEntityHeading(PlayerPedId(), 350.25)
  	Wait(2000)
  	FreezeEntityPosition(PlayerPedId(), false)


	if not isForced then
		TriggerServerEvent('hotel:getID')
	end


	curRoomType = 1

end

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

--[[
Citizen.CreateThread(function()
	
 	while true do
 		if IsControlJustPressed(1, Controlkey["housingSecondary"][1]) then
			tp =  GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.0, 0.0,-90.0)
			local detector = CreateObject(`xm_detector`,tp.x,tp.y,tp.z,true,true,true)
			FreezeEntityPosition(detector,true)
		end
 		FreezeEntityPosition(PlayerPedId(),false)
		Citizen.Wait(0)
		DrawMarker(27,-221.544921875,-1012.197265625,29.298439025879, 0, 0, 0, 0, 0, 0, 5.001, 5.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)	
		if #(vector3(-221.544921875,-1012.197265625,29.298439025879) - GetEntityCoords(PlayerPedId())) < 5 then
				DisplayHelpText('Press ~g~H~s~ to teleport to base model , press ~g~'..Controlkey["housingSecondary"][2]..'~s~ to spawn into new model')
			if IsControlJustPressed(1, Controlkey["housingMain"][1]) then
				SetEntityCoords(PlayerPedId(),9000.0,0.0,110.0)
			end
		end
	end
end)
]]

function getRotation(input)
	return 360/(10*input)
end

function buildRoom2(numMultiplier,roomType)

	SetEntityCoords(PlayerPedId(), 347.04724121094, -1000.2844848633, -99.194671630859)
 	FreezeEntityPosition(PlayerPedId(), true)
	Citizen.Wait(5000)

	local generator = { x = 175.09986877441 , y = -904.7946166992, z = -98.999984741211}
	generator.x = (175.09986877441) + ((numMultiplier * 25.0))
	generator.y = (-774.7946166992) -- ((numMultiplier * 25.0))
	currentRoom = generator

	if numMultiplier == myRoomNumber then
		myroomcoords = generator
	else
		curRoom = generator
	end

	RequestModel(GetHashKey("clrp_house_1"))
	while not HasModelLoaded(GetHashKey("clrp_house_1")) do
		RequestModel(GetHashKey("clrp_house_1"))
   		Citizen.Wait(100)
	end

	local building = CreateObject(GetHashKey("clrp_house_1"), generator.x, generator.y-0.05, generator.z+1.26253700-89.825, false, false, false)
	FreezeEntityPosition(building, true)
	Citizen.Wait(500)
	SetEntityCoords(PlayerPedId(), generator.x+3.6, generator.y-14.8, generator.z+2.9)
	SetEntityHeading(PlayerPedId(), 358.106)

	local dt = CreateObject(GetHashKey("V_16_DT"), generator.x-1.21854400, generator.y-1.04389600, generator.z+1.39068600, false, false, false)
	local mpmid01 = CreateObject(GetHashKey("V_16_mpmidapart01"), generator.x+0.52447510, generator.y-5.04953700, generator.z+1.32, false, false, false)
	local mpmid09 = CreateObject(GetHashKey("V_16_mpmidapart09"), generator.x+0.82202150, generator.y+2.29612000, generator.z+1.88, false, false, false)
	local mpmid07 = CreateObject(GetHashKey("V_16_mpmidapart07"), generator.x-1.91445900, generator.y-6.61911300, generator.z+1.45, false, false, false)
	local mpmid03 = CreateObject(GetHashKey("V_16_mpmidapart03"), generator.x-4.82565300, generator.y-6.86803900, generator.z+1.14, false, false, false)
	local midData = CreateObject(GetHashKey("V_16_midapartdeta"), generator.x+2.28558400, generator.y-1.94082100, generator.z+1.32, false, false, false)
	local glow = CreateObject(GetHashKey("V_16_treeglow"), generator.x-1.37408500, generator.y-0.95420070, generator.z+1.135, false, false, false)
	local curtins = CreateObject(GetHashKey("V_16_midapt_curts"), generator.x-1.96423300, generator.y-0.95958710, generator.z+1.280, false, false, false)
	local mpmid13 = CreateObject(GetHashKey("V_16_mpmidapart13"), generator.x-4.65580700, generator.y-6.61684000, generator.z+1.259, false, false, false)
	local mpcab = CreateObject(GetHashKey("V_16_midapt_cabinet"), generator.x-1.16177400, generator.y-0.97333810, generator.z+1.27, false, false, false)
	local mpdecal = CreateObject(GetHashKey("V_16_midapt_deca"), generator.x+2.311386000, generator.y-2.05385900, generator.z+1.297, false, false, false)
	local mpdelta = CreateObject(GetHashKey("V_16_mid_hall_mesh_delta"), generator.x+3.69693000, generator.y-5.80020100, generator.z+1.293, false, false, false)
	local beddelta = CreateObject(GetHashKey("V_16_mid_bed_delta"), generator.x+7.95187400, generator.y+1.04246500, generator.z+1.28402300, false, false, false)
	local bed = CreateObject(GetHashKey("V_16_mid_bed_bed"), generator.x+6.86376900, generator.y+1.20651200, generator.z+1.33589100, false, false, false)
	local beddecal = CreateObject(GetHashKey("V_16_MID_bed_over_decal"), generator.x+7.82861300, generator.y+1.04696700, generator.z+1.34753700, false, false, false)
	local bathDelta = CreateObject(GetHashKey("V_16_mid_bath_mesh_delta"), generator.x+4.45460500, generator.y+3.21322800, generator.z+1.21116100, false, false, false)
	local bathmirror = CreateObject(GetHashKey("V_16_mid_bath_mesh_mirror"), generator.x+3.57740800, generator.y+3.25032000, generator.z+1.48871300, false, false, false)

		--props
	local beerbot = CreateObject(GetHashKey("Prop_CS_Beer_Bot_01"), generator.x+1.73134600, generator.y-4.88520200, generator.z+1.91083000, false, false, false)
	local couch = CreateObject(GetHashKey("v_res_mp_sofa"), generator.x-1.48765600, generator.y+1.68100600, generator.z+1.33640500, false, false, false)
	local chair = CreateObject(GetHashKey("v_res_mp_stripchair"), generator.x-4.44770800, generator.y-1.78048800, generator.z+1.21640500, false, false, false)
	local chair2 = CreateObject(GetHashKey("v_res_tre_chair"), generator.x+2.91325400, generator.y-5.27835100, generator.z+1.22746400, false, false, false)
	local plant = CreateObject(GetHashKey("Prop_Plant_Int_04a"), generator.x+2.78941300, generator.y-4.39133900, generator.z+2.12746400, false, false, false)
	local lamp = CreateObject(GetHashKey("v_res_d_lampa"), generator.x-3.61473100, generator.y-6.61465100, generator.z+2.09373700, false, false, false)
	local fridge = CreateObject(GetHashKey("v_res_fridgemodsml"), generator.x+1.90339700, generator.y-3.80026800, generator.z+1.29917900, false, false, false)
	local micro = CreateObject(GetHashKey("prop_micro_01"), generator.x+2.03442400, generator.y-4.64585100, generator.z+2.28995600, false, false, false)
	local sideBoard = CreateObject(GetHashKey("V_Res_Tre_SideBoard"), generator.x+2.84053000, generator.y-4.30947100, generator.z+1.24577300, false, false, false)
	local bedSide = CreateObject(GetHashKey("V_Res_Tre_BedSideTable"), generator.x-3.50363200, generator.y-6.55289400, generator.z+1.30625800, false, false, false)
	local lamp2 = CreateObject(GetHashKey("v_res_d_lampa"), generator.x+2.69674700, generator.y-3.83123500, generator.z+2.09373700, false, false, false)
	local plant2 = CreateObject(GetHashKey("v_res_tre_tree"), generator.x-4.96064800, generator.y-6.09898500, generator.z+1.31631400, false, false, false)
	local table = CreateObject(GetHashKey("V_Res_M_DineTble_replace"), generator.x-3.50712600, generator.y-4.13621600, generator.z+1.29625800, false, false, false)
	local tv = CreateObject(GetHashKey("Prop_TV_Flat_01"), generator.x-5.53120400, generator.y+0.76299670, generator.z+2.17236000, false, false, false)
	local plant3 = CreateObject(GetHashKey("v_res_tre_plant"), generator.x-5.14112800, generator.y-2.78951000, generator.z+1.25950800, false, false, false)
	local chair3 = CreateObject(GetHashKey("v_res_m_dinechair"), generator.x-3.04652400, generator.y-4.95971200, generator.z+1.19625800, false, false, false)
	local lampStand = CreateObject(GetHashKey("v_res_m_lampstand"), generator.x+1.26588400, generator.y+3.68883900, generator.z+1.35556700, false, false, false)
	local stool = CreateObject(GetHashKey("V_Res_M_Stool_REPLACED"), generator.x-3.23216300, generator.y+2.06159000, generator.z+1.20556700, false, false, false)
	local chair4 = CreateObject(GetHashKey("v_res_m_dinechair"), generator.x-2.82237200, generator.y-3.59831300, generator.z+1.25950800, false, false, false)
	local chair5 = CreateObject(GetHashKey("v_res_m_dinechair"), generator.x-4.14955100, generator.y-4.71316600, generator.z+1.19625800, false, false, false)
	local chair6 = CreateObject(GetHashKey("v_res_m_dinechair"), generator.x-3.80622900, generator.y-3.37648300, generator.z+1.19625800, false, false, false)
	local plant4 = CreateObject(GetHashKey("v_res_fa_plant01"), generator.x+2.97859200, generator.y+2.55307400, generator.z+1.85796300, false, false, false)
	local storage = CreateObject(GetHashKey("v_res_tre_storageunit"), generator.x+8.47819500, generator.y-2.50979300, generator.z+1.19712300, false, false, false)
	local storage2 = CreateObject(GetHashKey("v_res_tre_storagebox"), generator.x+9.75982700, generator.y-1.35874100, generator.z+1.29625800, false, false, false)
	local basketmess = CreateObject(GetHashKey("v_res_tre_basketmess"), generator.x+8.70730600, generator.y-2.55503600, generator.z+1.94059590, false, false, false)
	local lampStand2 = CreateObject(GetHashKey("v_res_m_lampstand"), generator.x+9.54306000, generator.y-2.50427700, generator.z+1.30556700, false, false, false)
	local plant4 = CreateObject(GetHashKey("Prop_Plant_Int_03a"), generator.x+9.87521400, generator.y+3.90917400, generator.z+1.20829700, false, false, false)
	local basket = CreateObject(GetHashKey("v_res_tre_washbasket"), generator.x+9.39091500, generator.y+4.49676300, generator.z+1.19625800, false, false, false)
	local wardrobe = CreateObject(GetHashKey("V_Res_Tre_Wardrobe"), generator.x+8.46626300, generator.y+4.53223600, generator.z+1.19425800, false, false, false)
	local basket2 = CreateObject(GetHashKey("v_res_tre_flatbasket"), generator.x+8.51593000, generator.y+4.55647300, generator.z+3.46737300, false, false, false)
	local basket3 = CreateObject(GetHashKey("v_res_tre_basketmess"), generator.x+7.57797200, generator.y+4.55198800, generator.z+3.46737300, false, false, false)
	local basket4 = CreateObject(GetHashKey("v_res_tre_flatbasket"), generator.x+7.12286400, generator.y+4.54689200, generator.z+3.46737300, false, false, false)
	local wardrobe2 = CreateObject(GetHashKey("V_Res_Tre_Wardrobe"), generator.x+7.24382000, generator.y+4.53423500, generator.z+1.19625800, false, false, false)
	local basket5 = CreateObject(GetHashKey("v_res_tre_flatbasket"), generator.x+8.03364600, generator.y+4.54835500, generator.z+3.46737300, false, false, false)
	local switch = CreateObject(GetHashKey("v_serv_switch_2"), generator.x+6.28086900, generator.y-0.68169880, generator.z+2.30326000, false, false, false)
	local table2 = CreateObject(GetHashKey("V_Res_Tre_BedSideTable"), generator.x+5.84416200, generator.y+2.57377400, generator.z+1.22089100, false, false, false)
	local lamp3 = CreateObject(GetHashKey("v_res_d_lampa"), generator.x+5.84912100, generator.y+2.58001100, generator.z+1.95311890, false, false, false)
	--local laundry = CreateObject(GetHashKey("v_res_mlaundry"), generator.x+5.77729800, generator.y+4.60211400, generator.z+1.19674400, false, false, false)
	local ashtray = CreateObject(GetHashKey("Prop_ashtray_01"), generator.x-1.24716200, generator.y+1.07820500, generator.z+1.87089300, false, false, false)
	local candle1 = CreateObject(GetHashKey("v_res_fa_candle03"), generator.x-2.89289900, generator.y-4.35329700, generator.z+2.02881310, false, false, false)
	local candle2 = CreateObject(GetHashKey("v_res_fa_candle02"), generator.x-3.99865700, generator.y-4.06048500, generator.z+2.02530190, false, false, false)
	local candle3 = CreateObject(GetHashKey("v_res_fa_candle01"), generator.x-3.37733400, generator.y-3.66639800, generator.z+2.02526200, false, false, false)
	local woodbowl = CreateObject(GetHashKey("v_res_m_woodbowl"), generator.x-3.50787400, generator.y-4.11983000, generator.z+2.02589900, false, false, false)
	local tablod = CreateObject(GetHashKey("V_Res_TabloidsA"), generator.x-0.80513000, generator.y+0.51389600, generator.z+1.18418800, false, false, false)
	local tapeplayer = CreateObject(GetHashKey("Prop_Tapeplayer_01"), generator.x-1.26010100, generator.y-3.62966400, generator.z+2.37883200, false, false, false)
	local woodbowl2 = CreateObject(GetHashKey("v_res_tre_fruitbowl"), generator.x+2.77764900, generator.y-4.138297000, generator.z+2.10340100, false, false, false)
	local sculpt = CreateObject(GetHashKey("v_res_sculpt_dec"), generator.x+3.03932200, generator.y+1.62726400, generator.z+3.58363900, false, false, false)
	local jewlry = CreateObject(GetHashKey("v_res_jewelbox"), generator.x+3.04164100, generator.y+0.31671810, generator.z+3.58363900, false, false, false)
	local basket6 = CreateObject(GetHashKey("v_res_tre_basketmess"), generator.x-1.64906300, generator.y+1.62675900, generator.z+1.39038500, false, false, false)
	local basket7 = CreateObject(GetHashKey("v_res_tre_flatbasket"), generator.x-1.63938900, generator.y+0.91133310, generator.z+1.39038500, false, false, false)
	local basket8 = CreateObject(GetHashKey("v_res_tre_flatbasket"), generator.x-1.19923400, generator.y+1.69598600, generator.z+1.39038500, false, false, false)
	local basket9 = CreateObject(GetHashKey("v_res_tre_basketmess"), generator.x-1.18293800, generator.y+0.91436380, generator.z+1.39038500, false, false, false)
	local bowl = CreateObject(GetHashKey("v_res_r_sugarbowl"), generator.x-0.26029210, generator.y-6.66716800, generator.z+3.77324900, false, false, false)
	local breadbin = CreateObject(GetHashKey("Prop_Breadbin_01"), generator.x+2.09788500, generator.y-6.57634000, generator.z+2.24041900, false, false, false)
	local knifeblock = CreateObject(GetHashKey("v_res_mknifeblock"), generator.x+1.82084700, generator.y-6.58438500, generator.z+2.27399500, false, false, false)
	local toaster = CreateObject(GetHashKey("prop_toaster_01"), generator.x-1.05790700, generator.y-6.59017400, generator.z+2.26793200, false, false, false)
	local wok = CreateObject(GetHashKey("prop_wok"), generator.x+2.01728800, generator.y-5.57091500, generator.z+2.31793200, false, false, false)
	local plant5 = CreateObject(GetHashKey("Prop_Plant_Int_03a"), generator.x+2.55015600, generator.y+4.60183900, generator.z+1.20829700, false, false, false)
	local tumbler = CreateObject(GetHashKey("p_tumbler_cs2_s"), generator.x-0.90916440, generator.y-4.24099100, generator.z+2.24693200, false, false, false)
	local wisky = CreateObject(GetHashKey("p_whiskey_bottle_s"), generator.x-0.92809300, generator.y-3.99099100, generator.z+2.24693200, false, false, false)
	local tissue = CreateObject(GetHashKey("v_res_tissues"), generator.x+7.95889300, generator.y-2.54847100, generator.z+1.94013400, false, false, false)
	local pants = CreateObject(GetHashKey("V_16_Ap_Mid_Pants4"), generator.x+7.55366500, generator.y-0.25457100, generator.z+1.33009200, false, false, false)
	local pants2 = CreateObject(GetHashKey("V_16_Ap_Mid_Pants5"), generator.x+7.76753200, generator.y+3.00476500, generator.z+1.33052800, false, false, false)
	local hairdryer = CreateObject(GetHashKey("v_club_vuhairdryer"), generator.x+8.12616000, generator.y-2.50562000, generator.z+1.96009390, false, false, false)

	FreezeEntityPosition(dt,true)
	FreezeEntityPosition(mpmid01,true)
	FreezeEntityPosition(mpmid09,true)
	FreezeEntityPosition(mpmid07,true)
	FreezeEntityPosition(mpmid03,true)
	FreezeEntityPosition(midData,true)
	FreezeEntityPosition(glow,true)
	FreezeEntityPosition(curtins,true)
	FreezeEntityPosition(mpmid13,true)
	FreezeEntityPosition(mpcab,true)
	FreezeEntityPosition(mpdecal,true)
	FreezeEntityPosition(mpdelta,true)
	FreezeEntityPosition(couch,true)
	FreezeEntityPosition(chair,true)
	FreezeEntityPosition(chair2,true)
	FreezeEntityPosition(plant,true)
	FreezeEntityPosition(lamp,true)
	FreezeEntityPosition(fridge,true)
	FreezeEntityPosition(micro,true)
	FreezeEntityPosition(sideBoard,true)
	FreezeEntityPosition(bedSide,true)
	FreezeEntityPosition(plant2,true)
	FreezeEntityPosition(table,true)
	FreezeEntityPosition(tv,true)
	FreezeEntityPosition(plant3,true)
	FreezeEntityPosition(chair3,true)
	FreezeEntityPosition(lampStand,true)
	FreezeEntityPosition(chair4,true)
	FreezeEntityPosition(chair5,true)
	FreezeEntityPosition(chair6,true)
	FreezeEntityPosition(plant4,true)
	FreezeEntityPosition(storage2,true)
	FreezeEntityPosition(basket,true)
	FreezeEntityPosition(wardrobe,true)
	FreezeEntityPosition(wardrobe2,true)
	FreezeEntityPosition(table2,true)
	FreezeEntityPosition(lamp3,true)
	-- FreezeEntityPosition(laundry,true)
	FreezeEntityPosition(beddelta,true)
	FreezeEntityPosition(bed,true)
	FreezeEntityPosition(beddecal,true)
	FreezeEntityPosition(tapeplayer,true)
	FreezeEntityPosition(basket7,true)
	FreezeEntityPosition(basket6,true)
	FreezeEntityPosition(basket8,true)
	FreezeEntityPosition(basket9,true)
	SetEntityHeading(beerbot,GetEntityHeading(beerbot)+90)
	SetEntityHeading(couch,GetEntityHeading(couch)-90)
	SetEntityHeading(chair,GetEntityHeading(chair)+getRotation(0.28045480))
	SetEntityHeading(chair2,GetEntityHeading(chair2)+getRotation(0.3276100))
	SetEntityHeading(fridge,GetEntityHeading(chair2)+160)
	SetEntityHeading(micro,GetEntityHeading(micro)-90)
	SetEntityHeading(sideBoard,GetEntityHeading(sideBoard)+90)
	SetEntityHeading(bedSide,GetEntityHeading(bedSide)+180)
	SetEntityHeading(tv,GetEntityHeading(tv)+90)
	SetEntityHeading(plant3,GetEntityHeading(plant3)+90)
	SetEntityHeading(chair3,GetEntityHeading(chair3)+200)
	SetEntityHeading(chair4,GetEntityHeading(chair3)+100)
	SetEntityHeading(chair5,GetEntityHeading(chair5)+135)
	SetEntityHeading(chair6,GetEntityHeading(chair6)+10)
	SetEntityHeading(storage,GetEntityHeading(storage)+180)
	SetEntityHeading(storage2,GetEntityHeading(storage2)-90)
	SetEntityHeading(table2,GetEntityHeading(table2)+90)
	SetEntityHeading(tapeplayer,GetEntityHeading(tapeplayer)+90)
	SetEntityHeading(knifeblock,GetEntityHeading(knifeblock)+180)
	FreezeEntityPosition(PlayerPedId(),false)

	if not isForced then
		TriggerServerEvent('hotel:getID')
	end


	curRoomType = 2
	


end

function FloatTilSafe(numMultiplier,roomType,buildingsent)
	SetEntityInvincible(PlayerPedId(),true)
	FreezeEntityPosition(PlayerPedId(),true)
	local plyCoord = GetEntityCoords(PlayerPedId())
	local processing = 3
	local counter = 100
	local building = buildingsent
	while processing == 3 do
		Citizen.Wait(100)
		if DoesEntityExist(building) then

			processing = 2
		end
		if counter == 0 then
			processing = 1
		end
		counter = counter - 1
	end

	if counter > 0 then
		SetEntityCoords(PlayerPedId(),plyCoord)
		CleanUpPeds()
	elseif processing == 1 then
		if roomType == 2 then
			SetEntityCoords(PlayerPedId(),267.48132324219,-638.818359375,42.020294189453)
		elseif roomType == 3 then
			SetEntityCoords(PlayerPedId(),160.26762390137,-641.96905517578,47.073524475098)
		elseif roomType == 1 then
			SetEntityCoords(PlayerPedId(),312.96966552734,-218.2705078125,54.221797943115)
		end
		TriggerEvent("DoLongHudText","Failed to load, please retry.",2)	
	end
	TriggerEvent("reviveFunction")	

end
--+3,+7 for clothing
---14, -2, z+6 for entrance / exit
--
--generator = { x = 131.0290527343, y = -644.0509033203, z = 68.025619506836}
--{134.37339782715,-637.86877441406,80.064666748047},
--{117.24536132813,-645.98254394531,86.261169433594},


function buildRoom3(numMultiplier,roomType)
	garageNumber = numMultiplier

	--
	SetEntityCoords(PlayerPedId(),305.66970825195,-993.61737060547,-94.195129394531)
	FreezeEntityPosition(PlayerPedId(),true)
	Citizen.Wait(5000)


	local generator = { x = -265.68209838867 , y = -957.06573486328, z = 145.824577331543}

	if numMultiplier > 0 and numMultiplier < 7 then
		--generator = { x = -143.16976928711 , y = -596.31140136719, z = 61.95349121093}
		--generator.z = (61.9534912) + ((numMultiplier * 11.0) * roomType)
		generator = { x = 131.0290527343, y = -644.0509033203, z = 68.025619506836}
		generator.z = (68.0534912) + ((numMultiplier * 11.0))
	end

	if numMultiplier > 6 and numMultiplier < 14 then
		generator = { x = -134.43560791016 , y = -638.13916015625, z = 68.953491210938}
		numMultiplier = numMultiplier - 6
		generator.z = (61.9534912) + ((numMultiplier * 11.0))
	end

	if numMultiplier > 13 and numMultiplier < 20 then
		generator = { x = -181.440234375 , y = -584.04815673828, z = 68.95349121093}
		numMultiplier = numMultiplier - 13
		generator.z = (61.9534912) + ((numMultiplier * 11.0))
	end

	if numMultiplier > 19 and numMultiplier < 26 then
		generator = { x = -109.9752227783, y = -570.272351074, z = 61.9534912}
		numMultiplier = numMultiplier - 19
		generator.z = (61.9534912) + ((numMultiplier * 11.0))
	end

	if numMultiplier > 25 and numMultiplier < 38 then
		generator = { x = -3.9463002681732, y = -693.2456665039, z = 103.0334701538}
		numMultiplier = numMultiplier - 25
		generator.z = (103.0534912) + ((numMultiplier * 11.0))
	end

	if numMultiplier > 37 and numMultiplier < 49 then
		generator = { x = 140.0758819580, y = -748.12322998, z = 87.0334701538}
		numMultiplier = numMultiplier - 37
		generator.z = (87.0534912) + ((numMultiplier * 11.0))
	end

	if numMultiplier > 48 and numMultiplier < 60 then
		generator = { x = 131.0290527343, y = -644.0509033203, z = 68.025619506836}
		numMultiplier = numMultiplier - 48
		generator.z = (68.0534912) + ((numMultiplier * 11.0))
	end

	currentRoom = generator

	if numMultiplier == myRoomNumber then
		myroomcoords = generator
	else
		curRoom = generator
	end

	SetEntityCoords(PlayerPedId(), generator.x - 12.9,generator.y - 1.5,generator.z+8.00)

	local building = CreateObject(`v_16_mesh_shell`,generator.x+3.62430500,generator.y-1.55553200,generator.z+0.0,false,false,false)
	FreezeEntityPosition(building,true)
	FloatTilSafe(numMultiplier,roomType,building)


	CreateObject(`V_16_bed_mesh_windows`,generator.x+0.30707600,generator.y-5.44994300,generator.z+0.0,false,false,false)
	CreateObject(`V_16_bed_mesh_delta`,generator.x-1.76030900,generator.y-0.67466500,generator.z-0.0,false,false,false)
	CreateObject(`V_16_bed_mesh_delta`,generator.x-1.76030900,generator.y-0.67466500,generator.z+0.02,false,false,false)
	CreateObject(`V_16_high_bed_over_normal`,generator.x-1.75513100,generator.y+1.65130700,generator.z-0.0,false,false,false)
	CreateObject(`V_16_bdrm_mesh_bath`,generator.x+5.70348400,generator.y-0.86338900,generator.z+0.0,false,false,false)
	CreateObject(`V_16_bdr_mesh_bed`,generator.x+4.96819100,generator.y-0.72599610,generator.z+0.0,false,false,false)
	CreateObject(`V_16_bdRm_paintings002`,generator.x-0.41010200,generator.y-0.58682690,generator.z+0.15,false,false,false)
	CreateObject(`V_16_high_bed_mesh_lights`,generator.x+0.59020600,generator.y+2.21927200,generator.z-0.01,false,false,false)
	CreateObject(`V_16_high_bed_over_shadow`,generator.x+2.22250100,generator.y+1.72320200,generator.z-0.12,false,false,false)
	CreateObject(`V_16_lgb_rock001`,generator.x+0.30704400,generator.y-5.44356400,generator.z+2.65031600,false,false,false)
	CreateObject(`V_16_lnb_mesh_coffee`,generator.x+0.55458700,generator.y-2.51553800,generator.z+0.0,false,false,false)
	CreateObject(`V_16_high_bed_over_dirt`,generator.x+3.62430500,generator.y-1.55553200,generator.z+0.0,false,false,false)
	CreateObject(`V_16_high_bed_mesh_unit`,generator.x+3.64581600,generator.y+2.85395100,generator.z+0.0,false,false,false)
	CreateObject(`V_16_lng_mesh_stairGlass`,generator.x-7.56569000,generator.y-0.83904900,generator.z+5.030,false,false,false)
	CreateObject(`V_16_lng_mesh_delta`,generator.x-5.13722400,generator.y+0.09224100,generator.z+2.580,false,false,false)
	CreateObject(`V_16_lng_over_normal`,generator.x-1.36473800,generator.y+0.80418800,generator.z+2.580,false,false,false)
	CreateObject(`V_16_lng_mesh_blinds`,generator.x+4.04209900,generator.y-0.44575400,generator.z+7.680,false,false,false)
	CreateObject(`V_16_lng_mesh_windows`,generator.x+4.13028000,generator.y-0.57411700,generator.z+4.800,false,false,false)
	CreateObject(`V_16_high_lng_details`,generator.x+8.45114900,generator.y-0.81883400,generator.z+5.390,false,false,false)
	CreateObject(`V_16_lgb_mesh_lngProp`,generator.x+8.37186000,generator.y-1.07978700,generator.z+4.880,false,false,false)
	CreateObject(`V_16_high_lng_mesh_shelf`,generator.x-1.95027700,generator.y-3.14528700,generator.z+5.100,false,false,false)
	CreateObject(`V_16_knt_c`,generator.x+6.42180800,generator.y-0.99209900,generator.z+4.810,false,false,false)
	CreateObject(`V_16_rpt_mesh_pictures`,generator.x-8.01097500,generator.y-2.66429500,generator.z+5.450,false,false,false)
	CreateObject(`V_16_high_lng_mesh_delta`,generator.x-9.39279700,generator.y+0.07170800,generator.z+2.380,false,false,false)

		
	local table = CreateObject(`V_16_FH_SideBrdLngB_RSref001`,generator.x+5.00673200,generator.y-0.30080600,generator.z+4.890,false,false,false)
	--CreateObject(`V_16_knt_f`,generator.x-11.58236000,generator.y+1.10087100,generator.z+4.890,false,false,false)
	CreateObject(`V_16_high_lng_mesh_plant`,generator.x-3.68126800,generator.y+4.03672500,generator.z+4.590,false,false,false)
	CreateObject(`V_16_high_lng_mesh_tvUnit`,generator.x+9.03048800,generator.y-4.68231400,generator.z+4.900,false,false,false)
	CreateObject(`V_16_high_lng_over_shadow`,generator.x+10.16043000,generator.y-4.83294600,generator.z+4.840,false,false,false)
	CreateObject(`V_16_high_lng_over_shadow2`,generator.x-8.00688600,generator.y-1.29692100,generator.z+3.6,false,false,false)
	local armChairs = CreateObject(`V_16_high_lng_armChairs`,generator.x+1.49934300,generator.y-1.34954600,generator.z+4.85,false,false,false)
	CreateObject(`V_16_high_stp_mesh_unit`,generator.x-13.39290000,generator.y-0.17506300,generator.z+2.35,false,false,false)
	CreateObject(`v_16_v_sofa`,generator.x+7.80983000,generator.y+0.06534800,generator.z+4.85,false,false,false)
	CreateObject(`V_16_lng_mesh_stairGlassB`,generator.x-9.96113500,generator.y-2.60950900,generator.z+6.39,false,false,false)
	local kitchenShadow = CreateObject(`V_16_high_ktn_over_shadows`,generator.x+5.58696700,generator.y+5.58839800,generator.z+4.85,false,false,false)
	local kitchenStuff = CreateObject(`V_16_knt_mesh_stuff`,generator.x-4.19894500,generator.y+8.82334300,generator.z+4.9,false,false,false)
	CreateObject(`V_16_rpt_mesh_pictures003`,generator.x+12.47420000,generator.y+6.88947700,generator.z+5.76,false,false,false)
	CreateObject(`V_16_dnr_a`,generator.x+9.33427000,generator.y+12.73493000,generator.z+6.25,false,false,false)
	CreateObject(`V_16_high_ktn_over_decal`,generator.x+1.23671000,generator.y+8.76967200,generator.z+4.82,false,false,false)
	CreateObject(`V_16_high_ktn_over_shadow`,generator.x+9.23939100,generator.y+12.44786000,generator.z+4.82,false,false,false)
	CreateObject(`V_16_high_kit_mesh_unit`,generator.x-1.81104800,generator.y+9.17513200,generator.z+4.82,false,false,false)
	CreateObject(`V_16_lnb_mesh_tableCenter001`,generator.x+9.90664500,generator.y+6.71798600,generator.z+5.7,false,false,false)
	CreateObject(`V_16_high_ktn_mesh_delta`,generator.x+4.43419300,generator.y+9.17583700,generator.z+4.81,false,false,false)
	CreateObject(`V_16_high_ktn_mesh_windows`,generator.x+4.12927300,generator.y+12.89458000,generator.z+4.81,false,false,false)
	CreateObject(`V_16_high_ktn_mesh_fire`,generator.x+6.25015900,generator.y+5.34384200,generator.z+5.1,false,false,false)
	local tableDin = CreateObject(`v_res_fh_diningtable`,generator.x+9.90193900,generator.y+6.85432300,generator.z+4.84,false,false,false)
	CreateObject(`V_16_dnr_c`,generator.x+9.99221000,generator.y+12.55397000,generator.z+4.84,false,false,false)
	CreateObject(`V_16_lngAS_mesh_delta003`,generator.x+0.69565000,generator.y+13.05990000,generator.z+4.84,false,false,false)
	CreateObject(`V_16_hiigh_ktn_over_normal`,generator.x+3.76106900,generator.y+9.03640600,generator.z+4.84,false,false,false)
	CreateObject(`V_16_high_hall_mesh_delta`,generator.x-18.46974000,generator.y-0.07385800,generator.z+6.2,false,false,false)
	CreateObject(`V_16_high_hall_over_normal`,generator.x-18.30516000,generator.y+1.78606500,generator.z+6.2,false,false,false)
	CreateObject(`V_16_high_hall_over_dirt`,generator.x-18.19183000,generator.y-0.05498100,generator.z+6.2,false,false,false)
	CreateObject(`V_16_high_hall_over_shadow`,generator.x-16.98634000,generator.y-0.46674400,generator.z+6.2,false,false,false)
	CreateObject(`V_16_high_hal_mesh_plant`,generator.x-15.28974000,generator.y+4.79591600,generator.z+6.0,false,false,false)
	CreateObject(`V_16_high_bath_mesh_mirror`,generator.x-4.29534100,generator.y+3.74431100,generator.z+1.2,false,false,false)
	CreateObject(`V_16_high_bath_over_shadow`,generator.x-4.25607300,generator.y+6.22950200,generator.z+0.0,false,false,false)
	CreateObject(`V_16_high_bath_over_normals`,generator.x-4.32515600,generator.y+5.55146000,generator.z+0.0,false,false,false)
	--CreateObject(`V_16_high_bath_showerDoor`,generator.x-4.32213500,generator.y+6.22829300,generator.z+0.0,false,false,false)
	CreateObject(`V_16_high_bath_delta`,generator.x-4.32213500,generator.y+6.22829300,generator.z+0.0,false,false,false)

	--- Study Room ?
	CreateObject(`V_16_mags`,generator.x-10.44022000,generator.y+8.14852500,generator.z+6.23,false,false,false)
	CreateObject(`V_16_HIFI`,generator.x-10.23440000,generator.y+8.07973100,generator.z+6.23,false,false,false)
	CreateObject(`V_16_goldRecords`,generator.x-6.60447500,generator.y+8.12033200,generator.z+7.6,false,false,false)
	CreateObject(`V_16_BasketBall`,generator.x-9.66279400,generator.y+5.33664100,generator.z+7.0,false,false,false)
	CreateObject(`V_16_study_rug`,generator.x-10.4173000,generator.y+8.21256100,generator.z+6.23,false,false,false)
	CreateObject(`V_16_study_sofa`,generator.x-8.57377800,generator.y+6.95918400,generator.z+6.23,false,false,false)
	CreateObject(`V_16_hi_apt_S_Books`,generator.x-10.46981000,generator.y+7.54295200,generator.z+6.62,false,false,false)


	--Heist Room ?
	--CreateObject(`V_16_hi_apt_planningrmstf`,generator.x-10.23550000,generator.y+7.98658200,generator.z+6.23,false,false,false)
	CreateObject(`V_16_high_plan_mesh_delta`,generator.x-10.72429000,generator.y+8.18422700,generator.z+8.5,false,false,false)
	CreateObject(`V_16_high_plan_over_normal`,generator.x-10.24225000,generator.y+8.13986200,generator.z+6.23,false,false,false)
	CreateObject(`V_16_high_pln_mesh_lights`,generator.x-10.38581000,generator.y+8.22193600,generator.z+9.24,false,false,false)
	CreateObject(`V_16_high_pln_over_shadow`,generator.x-14.40226000,generator.y+7.20166000,generator.z+6.23,false,false,false)
	CreateObject(`V_16_high_pln_m_map`,generator.x-10.86284000,generator.y+10.98704000,generator.z+6.55,false,false,false)
	CreateObject(`V_16_highStudWallDirt`,generator.x-7.45147700,generator.y+11.00713000,generator.z+6.23,false,false,false)
	CreateObject(`V_16_hi_studdorrtrim`,generator.x-12.58800000,generator.y+1.08456500,generator.z+0.0,false,false,false)
	CreateObject(`V_16_hi_apt_planningrmstf`,generator.x-10.23550000,generator.y+7.98658200,generator.z+6.23,false,false,false)

	CreateObject(`V_16_Wardrobe`,generator.x+4.04197800,generator.y+6.41092600,generator.z+0.0,false,false,false)
	CreateObject(`V_16_high_ward_over_decal`,generator.x+3.53625300,generator.y+6.29680900,generator.z+0.0,false,false,false)
	CreateObject(`V_16_high_ward_over_shadow`,generator.x+3.89552500,generator.y+6.29853200,generator.z+0.0,false,false,false)
	CreateObject(`V_16_high_ward_over_normal`,generator.x+3.70096300,generator.y+6.29901000,generator.z+0.0,false,false,false)




	---- Props


	local door = CreateObject(`V_ILev_MP_high_FrontDoor`,generator.x-14.59187000,generator.y-1.30682500,generator.z+6.25,false,false,true)
	local lamp = CreateObject(`v_res_fh_lampa_on`,generator.x+5.86731700,generator.y-2.72296000,generator.z+0.5,false,false,false)
	local chair1 = CreateObject(`v_res_fh_easychair`,generator.x+0.64114900,generator.y-4.38969100,generator.z+0.1,false,false,false)
	CreateObject(`v_res_fh_benchshort`,generator.x-3.74095700,generator.y-4.90060600,generator.z+0.1,false,false,false)
	CreateObject(`V_16_shitbench`,generator.x-0.45795000,generator.y+8.45196000,generator.z+0.1,false,false,false)
	local pouf = CreateObject(`v_res_fh_pouf`,generator.x+2.76928800,generator.y-1.43858200,generator.z+0.05,false,false,false)
	local tv = CreateObject(`Prop_TV_Flat_01`,generator.x+10.30526000,generator.y-4.7350230,generator.z+5.8,false,false,false)
	local table2 = CreateObject(`V_Res_FH_CofTblDisp`,generator.x+8.42698100,generator.y-0.80205100,generator.z+4.9,false,false,false)
	local scope = CreateObject(`Prop_T_Telescope_01b`,generator.x+11.87588000,generator.y+3.78066000,generator.z+4.8,false,false,false)
	local plant = CreateObject(`v_res_mplanttongue`,generator.x-0.89350100,generator.y+12.45097000,generator.z+4.8,false,false,false)
	local stool = CreateObject(`v_res_fh_kitnstool`,generator.x+1.50922800,generator.y+5.23503600,generator.z+4.8,false,false,false)
	local stool2 = CreateObject(`v_res_fh_kitnstool`,generator.x+0.71056300,generator.y+5.23717500,generator.z+4.8,false,false,false)
	local stool3 = CreateObject(`v_res_fh_kitnstool`,generator.x+0.00570800,generator.y+5.23717500,generator.z+4.8,false,false,false)
	local table3 = CreateObject(`v_res_fh_sidebrddine`,generator.x+10.23037000,generator.y+12.51273000,generator.z+4.8,false,false,false)




	
	FreezeEntityPosition(tableDin,true)
	FreezeEntityPosition(door,true)
	FreezeEntityPosition(lamp,true)
	FreezeEntityPosition(chair1,true)
	FreezeEntityPosition(pouf,true)
	FreezeEntityPosition(table2,true)
	FreezeEntityPosition(plant,true)
	FreezeEntityPosition(stool,true)
	FreezeEntityPosition(stool2,true)
	FreezeEntityPosition(stool3,true)
	FreezeEntityPosition(table3,true)

	SetEntityHeading(table,GetEntityHeading(table)-90)
	SetEntityHeading(armChairs,GetEntityHeading(armChairs)-25)
	SetEntityHeading(kitchenShadow,GetEntityHeading(kitchenShadow)+90)
	SetEntityHeading(kitchenStuff,GetEntityHeading(kitchenStuff)-34)
	SetEntityHeading(door,GetEntityHeading(door)+90)
	SetEntityHeading(lamp,GetEntityHeading(lamp)+90)
	SetEntityHeading(chair1,GetEntityHeading(chair1)+180)
	SetEntityHeading(pouf,GetEntityHeading(pouf)+15)
	SetEntityHeading(tv,GetEntityHeading(tv)+180)
	SetEntityHeading(table2,GetEntityHeading(table2)+90)
	SetEntityHeading(scope,GetEntityHeading(scope)+180)
	if not isForced then
		TriggerServerEvent('hotel:getID')
	end



	FreezeEntityPosition(PlayerPedId(),false)

	

	curRoomType = 3


end

function renderPropsWhereHouse()
	CreateObject(`ex_prop_crate_bull_sc_02`,1003.63013,-3108.50415,-39.9669662,false,false,false)
	CreateObject(`ex_prop_crate_wlife_bc`,1018.18011,-3102.8042,-40.08757,false,false,false)
	CreateObject(`ex_prop_crate_closed_bc`,1006.05511,-3096.954,-37.7579666,false,false,false)
	CreateObject(`ex_prop_crate_wlife_sc`,1003.63013,-3102.8042,-37.85769,false,false,false)
	CreateObject(`ex_prop_crate_jewels_racks_sc`,1003.63013,-3091.604,-37.8579666,false,false,false)

	CreateObject(`ex_Prop_Crate_Closed_BC`,1013.330000003,-3102.80400000,-35.62896000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1015.75500000,-3102.80400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1015.75500000,-3102.80400000,-39.86697000,false,false,false)


	CreateObject(`ex_Prop_Crate_Jewels_BC`,1018.18000000,-3091.60400000,-39.85885000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3111.38400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_BC`,1003.63000000,-3091.60400000,-39.86697000,false,false,false)

	CreateObject(`ex_Prop_Crate_Jewels_BC`,1026.75500000,-3106.52900000,-39.85903000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3106.52900000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_SC`,1010.90500000,-3108.50400000,-39.86585000,false,false,false)

	CreateObject(`ex_Prop_Crate_Art_BC`,1013.33000000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_BC`,1015.75500000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_SC_02`,1010.90500000,-3096.95400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_SC`,993.35510000,-3111.30400000,-39.84156000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_BC`,993.35510000,-3108.95400000,-39.86697000,false,false,false)

	CreateObject(`ex_Prop_Crate_Gems_SC`,1013.33000000,-3096.95400000,-37.6577600,false,false,false)
	CreateObject(`ex_Prop_Crate_clothing_BC`,1018.180000000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_clothing_BC`,1008.48000000,-3096.95400000,-39.83868000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1003.63000000,-3108.50400000,-35.61234000,false,false,false)
	CreateObject(`ex_Prop_Crate_Narc_BC`,1026.75500000,-3091.59400000,-37.65797000,false,false,false)

	CreateObject(`ex_Prop_Crate_Narc_BC`,1026.75500000,-3091.59400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_SC`,1008.48000000,-3108.50400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Tob_SC`,1018.18000000,-3096.95400000,-37.78240000,false,false,false)
	CreateObject(`ex_Prop_Crate_Wlife_BC`,1018.18000000,-3091.60400000,-35.74857000,false,false,false)
	CreateObject(`ex_Prop_Crate_Med_BC`,1008.48000000,-3091.60400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_SC`,1013.33000000,-3108.50400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3108.88900000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_biohazard_BC`,1010.90500000,-3102.80400000,-39.86461000,false,false,false)
	CreateObject(`ex_Prop_Crate_Wlife_BC`,1015.75500000,-3091.60400000,-35.74857000,false,false,false)
	CreateObject(`ex_Prop_Crate_biohazard_BC`,1003.63000000,-3108.50400000,-37.65561000,false,false,false)

	CreateObject(`ex_Prop_Crate_Elec_BC`,1008.48000000,-3096.954000000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,1006.05500000,-3108.50400000,-39.86242000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_RW`,1013.33000000,-3091.60400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Narc_SC`,1026.75500000,-3094.014000000,-37.65684000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_BC`,1015.75500000,-3108.50400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1010.90500000,-3096.95400000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Ammo_BC`,1013.33000000,-3102.80400000,-37.65427000,false,false,false)

	CreateObject(`ex_Prop_Crate_Money_BC`,1003.63000000,-3096.95400000,-39.86638000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1003.63000000,-3096.95400000,-37.65187000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1010.90500000,-3091.60400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_BC`,1013.33000000,-3091.60400000,-35.74885000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_BC`,1026.75500000,-3091.59400000,-35.74885000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_BC`,1026.75500000,-3094.0140000,-35.74885000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_BC`,1026.75500000,-3096.43400000,-35.74885000,false,false,false)
	CreateObject(`ex_Prop_Crate_clothing_SC`,1013.33000000,-3091.604000000,-39.86540000,false,false,false)
	CreateObject(`ex_Prop_Crate_biohazard_SC`,1006.05500000,-3108.50400000,-37.65576000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,993.35510000,-3106.60400000,-35.60529000,false,false,false)

	CreateObject(`ex_Prop_Crate_Closed_BC`,1026.75500000,-3111.38400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,1026.75500000,-3096.4340000,-39.86242000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1015.75500000,-3096.95400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_HighEnd_pharma_BC`,1003.63000000,-3091.60400000,-35.62571000,false,false,false)
	CreateObject(`ex_Prop_Crate_HighEnd_pharma_SC`,1015.75500000,-3091.60400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_BC`,1013.330000000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_SC`,1018.18000000,-3102.80400000,-37.65776000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_BC`,1013.33000000,-3108.50400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1018.18000000,-3108.50400000,-37.64234000,false,false,false)
	CreateObject(`ex_Prop_Crate_Tob_BC`,1010.90500000,-3108.50400000,-35.75240000,false,false,false)

	CreateObject(`ex_Prop_Crate_Med_SC`,1026.75500000,-3108.88900000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Money_SC`,1010.90500000,-3091.60400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Med_SC`,1008.48000000,-3091.60400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_BC`,1018.180000000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_SC_02`,1008.48000000,-3108.50400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_02_BC`,993.35510000,-3106.60400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1008.480000000,-3102.804000000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,993.35510000,-3111.30400000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_HighEnd_pharma_BC`,1018.18000000,-3091.60400000,-37.65572000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1015.75500000,-3102.80400000,-37.64234000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_racks_BC`,1003.63000000,-3102.80400000,-39.85903000,false,false,false)
	CreateObject(`ex_Prop_Crate_Money_SC`,1006.05500000,-3096.95400000,-39.86697000,false,false,false)

	CreateObject(`ex_Prop_Crate_Closed_BC`,1003.630000000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_furJacket_SC`,1006.05500000,-3102.80400000,-37.78544000,false,false,false)
	CreateObject(`ex_Prop_Crate_Expl_bc`,1010.90500000,-3102.80400000,-37.63982000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1006.05500000,-3096.9540000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1006.05500000,-3102.80400000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1010.90500000,-3108.50400000,-37.63529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Art_BC`,1015.75500000,-3096.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_BC`,1010.90500000,-3096.95400000,-37.64234000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1010.90500000,-3102.804000000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_BC`,1008.48000000,-3102.80400000,-35.60529000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,993.35510000,-3106.60400000,-37.65342000,false,false,false)
	CreateObject(`ex_Prop_Crate_Money_SC`,1015.75500000,-3091.604000000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Med_BC`,1026.75500000,-3106.52900000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_SC_02`,1015.75500000,-3096.95400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Tob_SC`,1010.905000000,-3091.60400000,-37.78240000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1006.05500000,-3091.60400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_pharma_SC`,1026.75500000,-3096.43400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1006.05500000,-3108.50400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_Gems_SC`,1015.75500000,-3108.504000000,-37.65776000,false,false,false)

	CreateObject(`ex_Prop_Crate_Tob_BC`,1018.18000000,-3102.80400000,-35.75240000,false,false,false)
	CreateObject(`ex_Prop_Crate_Tob_BC`,1008.48000000,-3108.50400000,-35.75240000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,993.35510000,-3111.30400000,-37.65342000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_racks_SC`,1026.75500000,-3111.384000000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_SC`,1006.05500000,-3102.80400000,-39.87020000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,1013.33000000,-3096.95400000,-39.86242000,false,false,false)

	CreateObject(`ex_Prop_Crate_Gems_SC`,1013.33000000,1013.33000000,1013.33000000,false,false,false)
	CreateObject(`ex_Prop_Crate_Jewels_BC`,1026.75500000,-3108.889000000,-39.85885000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_SC_02`,993.35510000,-3108.95400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_BC`,1008.48000000,-3091.60400000,-37.65797000,false,false,false)
	CreateObject(`ex_Prop_Crate_Elec_SC`,993.35510000,-3108.95400000,-35.62796000,false,false,false)
	CreateObject(`ex_Prop_Crate_XLDiam`,1026.75500000,-3094.01400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_watch`,1013.33000000,-3102.80400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_SHide`,1018.18000000,-3096.95400000,-39.87596000,false,false,false)
	CreateObject(`ex_Prop_Crate_Oegg`,1006.05500000,-3091.60400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_MiniG`,1018.18000000,-3108.50400000,-39.86697000,false,false,false)
	CreateObject(`ex_Prop_Crate_FReel`,11008.48000000,-3102.80400000,-39.85903000,false,false,false)
	CreateObject(`ex_Prop_Crate_Closed_SC`,1006.05500000,-3091.60400000,-37.64985000,false,false,false)
	CreateObject(`ex_Prop_Crate_Bull_BC_02`,1026.75500000,-3091.59400000,-39.86242000,false,false,false)


	local tool1 = CreateObject(-573669520,1022.6115112305,-3107.1694335938,-39.999912261963,false,false,false)
	local tool2 = CreateObject(-573669520,1022.5317382813,-3095.3305664063,-39.999912261963,false,false,false)
	local tool3 = CreateObject(-573669520,996.60125732422,-3099.2927246094,-39.999923706055,false,false,false)
	local tool4 = CreateObject(-573669520,1002.0411987305,-3108.3645019531,-39.999897003174,false,false,false)


	SetEntityHeading(tool1,GetEntityHeading(tool1)-130)
	SetEntityHeading(tool2,GetEntityHeading(tool2)-40)
	SetEntityHeading(tool3,GetEntityHeading(tool3)+90)
	SetEntityHeading(tool4,GetEntityHeading(tool4)-90)

end

RegisterNetEvent("hotel:loadWarehouse")
AddEventHandler("hotel:loadWarehouse", function()
    renderPropsWhereHouse()
end)

RegisterNetEvent("hotel:clearWarehouse")
AddEventHandler("hotel:clearWarehouse", function()
    CleanUpArea()
end)







function buildGarage(numMultiplier) -- This will be room '111'

	numMultiplier = garageNumber
	ingarage = true


	TriggerEvent("Garages:ToggleHouse",true)
	SetEntityCoords(PlayerPedId(),228.54,-999.84,-98.99) -- Default Garage location

	FreezeEntityPosition(PlayerPedId(),true)
	Citizen.Wait(5000)

	

	local generator = { x = 227.39 , y =-1035.0, z = -98.99} -- spawn location
	generator.x = (175.09986877441) + ((numMultiplier * 25.0))
	generator.y = (-774.7946166992) -- ((numMultiplier * 25.0))
	currentGarage = generator


	SetEntityCoords(PlayerPedId(), generator.x+9.5 , generator.y-12.7, generator.z+2.0)
	local building = CreateObject(`v_72_garagel_shell`,generator.x-0.32784650,generator.y+1.71953800,generator.z,false,false,false)
	FreezeEntityPosition(building,true)
	Citizen.Wait(100)
	FloatTilSafe(numMultiplier,roomType,building)




	

	
	CreateObject(`v_72_UnitLarge`,generator.x+4.19773900,generator.y+15.53382000,generator.z,false,false,false)
	CreateObject(`v_72_MirrorL`,generator.x-0.32785030,generator.y+1.71953800,generator.z,false,false,false)
	local shelf = CreateObject(`V_Ret_ML_ShelfRk`,generator.x-0.26511000,generator.y+27.23191000,generator.z,false,false,false)
	CreateObject(`V_72_CeilingLights02`,generator.x+0.25968170,generator.y-8.51434300,generator.z+3.81176300,false,false,false)
	CreateObject(`v_72_CeilingDet`,generator.x-0.11651610,generator.y+1.28138000,generator.z+3.89960800,false,false,false)
	CreateObject(`V_72_GaragePartition`,generator.x-4.77089700,generator.y+17.78751000,generator.z,false,false,false)
	local bmount = CreateObject(`V_72_BIKE_MOUNT01`,generator.x-8.36096200,generator.y+13.52185000,generator.z+1.89970200,false,false,false)
	local bmount2 = CreateObject(`V_72_BIKE_MOUNT002`,generator.x-8.36096200,generator.y+12.88856000,generator.z+1.89970200,false,false,false)
	local bmount3 = CreateObject(`V_72_BIKE_MOUNT003`,generator.x-8.36096200,generator.y+12.25526000,generator.z+1.89970200,false,false,false)
	CreateObject(`V_72_LED_FLOOR`,generator.x-8.10127200,generator.y+3.44487400,generator.z,false,false,false)
	local light = CreateObject(`V_72_LED_FLOOR001`,generator.x+7.84043900,generator.y-0.55789570,generator.z,false,false,false)
	local bmount4 = CreateObject(`V_72_BIKE_MOUNT010`,generator.x-8.36096200,generator.y+14.15514000,generator.z+1.89970200,false,false,false)
	local bmount5 = CreateObject(`V_72_BIKE_MOUNT011`,generator.x-8.36096200,generator.y+14.78843000,generator.z+1.89970200,false,false,false)
	local bmount6 = CreateObject(`V_72_BIKE_MOUNT012`,generator.x-8.36096200,generator.y+15.42173000,generator.z+1.89970200,false,false,false)
	CreateObject(`V_72_RailsDoor`,generator.x-0.41423040,generator.y-12.89453000,generator.z,false,false,false)
	local wall = CreateObject(`V_72_WallDetail003`,generator.x-8.35674300,generator.y+16.96778000,generator.z+0.67419500,false,false,false)
	CreateObject(`V_72_CARPET02`,generator.x+2.83528900,generator.y+14.97386000,generator.z,false,false,false)
	local carpet = CreateObject(`V_72_CARPET01`,generator.x+5.67560600,generator.y+14.28391000,generator.z,false,false,false)
	local jack = CreateObject(`V_72_MPGJackFrame`,generator.x-0.73751450,generator.y+22.85103000,generator.z-0.05,false,false,false)
	CreateObject(`V_72_Emis_only_L_Refl`,generator.x-0.14863590,generator.y+0.32452390,generator.z+3.45054200,false,false,false)
	CreateObject(`V_72_Emis_wall_L`,generator.x-0.14970400,generator.y+3.44487400,generator.z,false,false,false)
	CreateObject(`V_72_GarageL_Shell_Proxy`,generator.x-0.32785030,generator.y+1.71953800,generator.z,false,false,false)
	CreateObject(`V_72_Emis_only_L001`,generator.x-0.14863590,generator.y+0.32452390,generator.z,false,false,false)
	CreateObject(`V_72_GARDOOR_SM`,generator.x-0.40738680,generator.y-15.01338000,generator.z,false,false,false)
	local wallDetail = CreateObject(`V_72_WallDetaiPRX`,generator.x+8.25835000,generator.y-14.95063000,generator.z,false,false,false)
	local elev = CreateObject(`V_72_ELEVATOR`,generator.x+10.30572000,generator.y-12.76745000,generator.z,false,false,false)
	CreateObject(`V_72_CeilingLights03`,generator.x-0.13168340,generator.y+0.32551190,generator.z+3.94430300,false,false,false)
	CreateObject(`V_72_ELEVATOR_PANEL`,generator.x+10.56285000,generator.y-11.74362000,generator.z,false,false,false)
	CreateObject(`V_72_GarLCables01`,generator.x+7.02913700,generator.y-14.93177000,generator.z+1.39328500,false,false,false)
	CreateObject(`V_72_Emis_only_NoRefl`,generator.x-0.14863590,generator.y+0.32452390,generator.z+3.85054200,false,false,false)
	CreateObject(`prop_carjack`,generator.x-7.96900900,generator.y+22.44639000,generator.z,false,false,false)
	local toolChest = CreateObject(`prop_toolchest_03`,generator.x-7.94370600,generator.y+25.40939000,generator.z,false,false,false)
	local toolChest2 = CreateObject(`prop_toolchest_05`,generator.x+7.68719800,generator.y+12.78481000,generator.z,false,false,false)
	CreateObject(`prop_toolchest_03`,generator.x+1.24307300,generator.y+17.13576000,generator.z,false,false,false)
	local sackTruck = CreateObject(`prop_sacktruck_02a`,generator.x-8.07646200,generator.y+24.19437000,generator.z,false,false,false)
	CreateObject(`v_ind_cs_toolbox3`,generator.x-0.65444570,generator.y+27.24499000,generator.z,false,false,false)
	CreateObject(`v_ind_cs_toolbox4`,generator.x-0.57600400,generator.y+27.26014000,generator.z+1.20212900,false,false,false)
	CreateObject(`v_ind_cs_toolbox2`,generator.x-0.01528549,generator.y+27.23587000,generator.z+0.73185900,false,false,false)
	CreateObject(`v_ret_ta_box`,generator.x+0.13813780,generator.y+27.26524000,generator.z+1.70933000,false,false,false)
	CreateObject(`v_ind_rc_locker`,generator.x-7.91668000,generator.y+27.11429000,generator.z,false,false,false)
	local ladder = CreateObject(`v_ind_cm_ladder`,generator.x-8.23228100,generator.y+24.80355000,generator.z,false,false,false)
	local laptop = CreateObject(`prop_laptop_01a`,generator.x+7.22880600,generator.y+16.44059000,generator.z+1.05979200,false,false,false)
	local compress = CreateObject(`prop_compressor_02`,generator.x-7.68346800,generator.y+23.41258000,generator.z,false,false,false)
	CreateObject(`prop_oiltub_05`,generator.x+0.19534300,generator.y+27.35218000,generator.z+1.22948000,false,false,false)
	CreateObject(`prop_oiltub_04`,generator.x+0.26910780,generator.y+27.13628000,generator.z+1.23299500,false,false,false)
	CreateObject(`prop_compressor_03`,generator.x-2.65713100,generator.y+26.80330000,generator.z,false,false,false)
	CreateObject(`v_res_smallplasticbox`,generator.x+7.75391700,generator.y+12.37584000,generator.z+0.96130500,false,false,false)
	local carCreeper = CreateObject(`prop_carcreeper`,generator.x-3.15590700,generator.y+27.42420000,generator.z,false,false,false)
	local ebox1 = CreateObject(`prop_elecbox_20`,generator.x-0.89199060,generator.y-14.88680000,generator.z,false,false,false)
	local ebox2 = CreateObject(`prop_elecbox_20`,generator.x-7.34775500,generator.y-14.89939000,generator.z,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x-0.41422270,generator.y-14.95033000,generator.z+1.24588200,false,false,false)

	CreateObject(`prop_ducktape_01`,generator.x+4.40670800,generator.y+17.12280000,generator.z+1.04588700,false,false,false)
	CreateObject(`prop_ducktape_01`,generator.x+4.20057700,generator.y+17.27103000,generator.z+1.04588700,false,false,false)
	CreateObject(`Prop_EtricMotor_01`,generator.x+7.59630200,generator.y+15.25531000,generator.z+1.03267000,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+7.50463500,generator.y+17.40690000,generator.z+1.69612400,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+7.92913400,generator.y+16.99049000,generator.z+2.32103000,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+7.98337900,generator.y+16.77627000,generator.z+2.32103000,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+6.74674600,generator.y+17.28172000,generator.z+1.04092400,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+6.56789800,generator.y+17.31542000,generator.z+1.04092400,false,false,false)
	CreateObject(`prop_oiltub_04`,generator.x+6.24290100,generator.y+17.25886000,generator.z+1.05588700,false,false,false)
	CreateObject(`prop_oiltub_05`,generator.x+8.00838800,generator.y+16.87403000,generator.z+1.68083000,false,false,false)
	CreateObject(`prop_paint_spray01a`,generator.x+6.53995900,generator.y+17.43684000,generator.z+1.68593100,false,false,false)
	CreateObject(`prop_paint_spray01a`,generator.x+6.63757000,generator.y+17.45368000,generator.z+1.68593100,false,false,false)
	CreateObject(`prop_paint_spray01a`,generator.x+7.98122000,generator.y+15.91340000,generator.z+1.68593100,false,false,false)
	CreateObject(`prop_paint_spray01b`,generator.x+6.72750600,generator.y+17.43553000,generator.z+1.68593100,false,false,false)
	CreateObject(`prop_paints_can03`,generator.x+7.89661800,generator.y+16.06400000,generator.z+2.36213700,false,false,false)
	CreateObject(`prop_paints_can05`,generator.x+7.89883000,generator.y+17.31401000,generator.z+2.39608600,false,false,false)
	CreateObject(`prop_stool_01`,generator.x+7.17796700,generator.y+13.44759000,generator.z,false,false,false)
	CreateObject(`prop_tool_box_01`,generator.x+6.72750600,generator.y+17.33357000,generator.z+2.31103000,false,false,false)
	CreateObject(`prop_tool_box_02`,generator.x+7.08126400,generator.y+17.40779000,generator.z+1.68612400,false,false,false)
	CreateObject(`prop_tool_cable01`,generator.x+7.29851900,generator.y+17.33357000,generator.z+2.31403000,false,false,false)
	CreateObject(`prop_tool_cable01`,generator.x+7.57247500,generator.y+17.36197000,generator.z+2.31403000,false,false,false)
	CreateObject(`prop_tool_cable01`,generator.x+7.81509000,generator.y+13.19809000,generator.z+0.96284100,false,false,false)
	local toolbox = CreateObject(`v_ind_cs_toolbox4`,generator.x+7.90325500,generator.y+16.34276000,generator.z+1.70462000,false,false,false)
	CreateObject(`v_ret_ta_box`,generator.x+7.84934600,generator.y+17.23244000,generator.z+1.70842900,false,false,false)
	CreateObject(`prop_paint_spray01a`,generator.x+2.31462100,generator.y+17.4383300,generator.z+2.49709700,false,false,false)
	CreateObject(`prop_paint_spray01a`,generator.x+2.41223100,generator.y+17.45518000,generator.z+2.49709700,false,false,false)
	CreateObject(`prop_paint_spray01b`,generator.x+2.50216700,generator.y+17.43703000,generator.z+2.49709700,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+4.00710300,generator.y+17.40818000,generator.z+2.49729000,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+4.18595100,generator.y+17.37448000,generator.z+2.49729000,false,false,false)
	CreateObject(`prop_oiltub_05`,generator.x+7.95839000,generator.y+13.79140000,generator.z+2.49356400,false,false,false)
	CreateObject(`prop_compressor_02`,generator.x-1.41294500,generator.y+26.81413000,generator.z,false,false,false)
	CreateObject(`prop_toolchest_05`,generator.x-0.14379500,generator.y+17.11545000,generator.z,false,false,false)
	CreateObject(`prop_toolchest_03`,generator.x-1.98844500,generator.y+26.92768000,generator.z,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+4.37259700,generator.y+17.25935000,generator.z+1.02092400,false,false,false)
	CreateObject(`prop_tool_box_02`,generator.x+2.77144600,generator.y+17.26706000,generator.z+1.02023100,false,false,false)
	CreateObject(`Prop_Boombox_01`,generator.x+2.03641900,generator.y+17.18845000,generator.z+1.05717400,false,false,false)
	CreateObject(`v_ind_rc_locker`,generator.x-7.10683100,generator.y+27.11429000,generator.z,false,false,false)
	CreateObject(`v_ind_rc_locker`,generator.x-6.29698200,generator.y+27.11429000,generator.z,false,false,false)
	CreateObject(`prop_toolchest_05`,generator.x-4.93408200,generator.y+27.12215000,generator.z,false,false,false)
	CreateObject(`prop_carjack`,generator.x-3.43050400,generator.y+26.71018000,generator.z,false,false,false)
	local speaker1 = CreateObject(`v_res_fh_speaker`,generator.x-8.19913900,generator.y+9.47816500,generator.z+3.35892800,false,false,false)
	local speaker2 = CreateObject(`v_res_fh_speaker`,generator.x-8.19913900,generator.y+1.47923500,generator.z+3.35892800,false,false,false)
	local speaker3 = CreateObject(`v_res_fh_speaker`,generator.x-8.19913900,generator.y-6.53624900,generator.z+3.35892800,false,false,false)
	local speaker4 = CreateObject(`v_res_fh_speaker`,generator.x+7.90285900,generator.y+9.47816500,generator.z+3.35892800,false,false,false)
	local speaker5 = CreateObject(`v_res_fh_speaker`,generator.x+7.90285900,generator.y+1.47923500,generator.z+3.35892800,false,false,false)
	local speaker6 = CreateObject(`v_res_fh_speaker`,generator.x+7.90285900,generator.y-6.53624900,generator.z+3.35892800,false,false,false)
	CreateObject(`prop_engine_hoist`,generator.x-6.10173000,generator.y+21.65605000,generator.z,false,false,false)
	local locker1 = CreateObject(`v_ind_rc_locker`,generator.x+2.33318300,generator.y+27.07120000,generator.z,false,false,false)
	local locker2 =  CreateObject(`v_ind_rc_locker`,generator.x+2.33318300,generator.y+26.26135000,generator.z,false,false,false)


	FreezeEntityPosition(building,true)
	FreezeEntityPosition(shelf,true)
	FreezeEntityPosition(ebox1,true)
	FreezeEntityPosition(ebox2,true)
	SetEntityHeading(bmount,GetEntityHeading(bmount)+90)
	SetEntityHeading(bmount2,GetEntityHeading(bmount2)+90)
	SetEntityHeading(bmount3,GetEntityHeading(bmount3)+90)
	SetEntityHeading(bmount4,GetEntityHeading(bmount4)+90)
	SetEntityHeading(bmount5,GetEntityHeading(bmount5)+90)
	SetEntityHeading(bmount6,GetEntityHeading(bmount6)+90)
	SetEntityHeading(carpet,GetEntityHeading(carpet)+90)
	SetEntityHeading(jack,GetEntityHeading(jack)+90)
	SetEntityHeading(wall,GetEntityHeading(wall)+180)
	SetEntityHeading(elev,GetEntityHeading(elev)+180)
	SetEntityHeading(toolChest,GetEntityHeading(toolChest)+90)
	SetEntityHeading(wallDetail,GetEntityHeading(wallDetail)-90)
	SetEntityHeading(toolChest2,GetEntityHeading(toolChest2)-90)
	SetEntityHeading(sackTruck,GetEntityHeading(sackTruck)+90)
	SetEntityHeading(ladder,GetEntityHeading(ladder)-90)
	SetEntityHeading(laptop,GetEntityHeading(laptop)-50)
	SetEntityHeading(compress,GetEntityHeading(compress)+90)
	SetEntityHeading(carCreeper,GetEntityHeading(carCreeper)-90)
	SetEntityHeading(toolbox,GetEntityHeading(toolbox)-90)
	SetEntityHeading(locker1,GetEntityHeading(locker1)-90)
	SetEntityHeading(locker2,GetEntityHeading(locker2)-90)



	SetEntityRotation(speaker1,85.0,0.0,0.0,2,1)
	SetEntityRotation(speaker2,85.0,0.0,0.0,2,1)
	SetEntityRotation(speaker3,85.0,0.0,0.0,2,1)
	SetEntityRotation(speaker4,90.0,180.0,0.0,2,1)
	SetEntityRotation(speaker5,90.0,180.0,0.0,2,1)
	SetEntityRotation(speaker6,90.0,180.0,0.0,2,1)

	FreezeEntityPosition(PlayerPedId(),false)

	if garageNumber == myRoomNumber then
		TriggerEvent("Garages:SpawnHouseGarage",currentGarage)
	end
	TriggerEvent("attachWeapons")
end


function buildMansion() -- This will be room '4'
	SetEntityCoords(PlayerPedId(),-801.5,178.69,72.84) -- Default Garage location
	Citizen.Wait(5000)
  	SetEntityCoords(PlayerPedId(),-811.5,178.69,10.84)
  	
	local generator = { x = -811.5, y =178.69, z = 10.84} -- spawn location-
	local building = CreateObject(`v_44_shell`,generator.x+3.57921200,generator.y+3.70079500,generator.z-0.1,false,false,false)
	local building2 = CreateObject(`V_44_Shell2`,generator.x+3.57921200,generator.y+3.70079500,generator.z+4.54096300,false,false,false)
	CreateObject(`V_44_Shell_DT`,generator.x+3.53319000,generator.y+0.63158610,generator.z+0.05,false,false,false)
	CreateObject(`V_44_Shell_kitchen`,generator.x+10.43252000,generator.y+6.99729500,generator.z+0.50649800,false,false,false)
	CreateObject(`V_44_1_Hall_Deta`,generator.x+3.37417900,generator.y+1.67813900,generator.z+4.64078700,false,false,false)
	CreateObject(`V_44_Lounge_Deca`,generator.x+3.46935500,generator.y-2.95353700,generator.z+0.19696300,false,false,false)
	CreateObject(`V_44_Lounge_Items`,generator.x+3.51090600,generator.y-1.92194400,generator.z+0.99696300,false,false,false)
	CreateObject(`V_44_Lounge_DecaL`,generator.x+3.26119400,generator.y-2.95349700,generator.z+0.72649800,false,false,false)

	CreateObject(`v_res_m_armchair`,generator.x+2.39658700,generator.y-0.76810070,generator.z+0.68484200,false,false,false)
	local sofa = CreateObject(`v_ilev_m_sofa`,generator.x+2.49675000,generator.y-4.20500900,generator.z+0.67964300,false,false,false)
	SetEntityHeading(sofa,GetEntityHeading(sofa)+100)
	CreateObject(`v_res_m_lampstand2`,generator.x+1.48265400,generator.y-0.84137140,generator.z+0.67608500,false,false,false)
	CreateObject(`v_res_m_armchair`,generator.x+6.21690200,generator.y-6.11628200,generator.z+0.67484200,false,false,false)
	CreateObject(`v_res_m_armchair`,generator.x+2.39658700,generator.y-0.76810070,generator.z+0.68484200,false,false,false)


	CreateObject(`V_44_Lounge_Deta`,generator.x+3.51090600,generator.y-1.92194300,generator.z+0.04133500,false,false,false)
	CreateObject(`v_res_mplanttongue`,generator.x+6.71760400,generator.y-2.22743200,generator.z+0.67305700,false,false,false)
	CreateObject(`v_res_fashmag1`,generator.x+3.57820100,generator.y+1.92808700,generator.z+1.75578100,false,false,false)
	local projector =  CreateObject(`v_ilev_mm_scre_off`,generator.x+6.20400000,generator.y-3.86164200,generator.z+2.34300000,false,false,false)
	SetEntityHeading(projector,GetEntityHeading(projector)+90)
	CreateObject(`v_res_mountedprojector`,generator.x+1.57309300,generator.y-3.85972100,generator.z+4.10981500,false,false,false)
	CreateObject(`v_res_m_stool`,generator.x+3.44306000,generator.y-2.37584100,generator.z+0.67964300,false,false,false)
	local desk = CreateObject(`v_res_mconsolemod`,generator.x+3.34306000,generator.y+2.07584100,generator.z+0.67964300,false,false,false)
	FreezeEntityPosition(desk,true)

	CreateObject(`v_res_msidetblemod`,generator.x+1.61465700,generator.y-1.51442700,generator.z+0.67151600,false,false,false)
	CreateObject(`v_res_msidetblemod`,generator.x+6.15811500,generator.y-7.04496300,generator.z+0.67151600,false,false,false)
	CreateObject(`v_res_mconsoletrad`,generator.x+2.26189700,generator.y-8.03078800,generator.z+0.67178400,false,false,false)
	CreateObject(`v_res_m_l_chair1`,generator.x+1.85258000,generator.y+2.04241000,generator.z+0.68464200,false,false,false)
	CreateObject(`v_res_m_l_chair1`,generator.x+4.80667200,generator.y+2.04241000,generator.z+0.68464200,false,false,false)
	CreateObject(`v_res_mplanttongue`,generator.x+6.61146400,generator.y-5.48816700,generator.z+0.67305700,false,false,false)
	CreateObject(`v_res_m_lamptbl`,generator.x+6.15963000,generator.y-7.04415300,generator.z+1.51251600,false,false,false)
	CreateObject(`v_res_r_fighorsestnd`,generator.x+2.76621100,generator.y-8.16190900,generator.z+1.67301800,false,false,false)
	CreateObject(`v_res_m_palmplant1`,generator.x+0.08713913,generator.y-7.26929300,generator.z+0.3557600,false,false,false)
	CreateObject(`v_res_m_lamptbl`,generator.x+3.82970200,generator.y+2.15182300,generator.z+1.75605000,false,false,false)
	CreateObject(`v_res_m_candlelrg`,generator.x+6.27535300,generator.y-2.88023300,generator.z+0.70131200,false,false,false)
	CreateObject(`v_res_mpotpouri`,generator.x+1.89024700,generator.y-7.97319000,generator.z+1.67301800,false,false,false)
	CreateObject(`v_res_m_candlelrg`,generator.x+6.27901500,generator.y-4.86268600,generator.z+0.70131200,false,false,false)
	CreateObject(`v_res_fa_candle04`,generator.x+6.12360800,generator.y-6.89644600,generator.z+1.58551100,false,false,false)
	CreateObject(`v_res_fa_candle04`,generator.x+1.67240800,generator.y-7.95039100,generator.z+1.74601300,false,false,false)
	CreateObject(`v_res_m_spanishbox`,generator.x+2.31205000,generator.y-8.02846300,generator.z+1.67301800,false,false,false)

	CreateObject(`v_res_m_statue`,generator.x-1.27413000,generator.y-3.86254400,generator.z+2.98763400,false,false,false)
	CreateObject(`Prop_Cigar_pack_02`,generator.x+1.78793000,generator.y-1.69860600,generator.z+1.51857000,false,false,false)
	CreateObject(`prop_ashtray_01`,generator.x+1.67015600,generator.y-1.70531800,generator.z+1.53098900,false,false,false)
	CreateObject(`v_res_m_pot1`,generator.x-0.77471540,generator.y+0.12082960,generator.z+1.75637100,false,false,false)
	CreateObject(`v_res_m_pot1`,generator.x-0.84445380,generator.y-0.11595340,generator.z+1.75637100,false,false,false)
	CreateObject(`v_res_m_spanishbox`,generator.x-1.31776900,generator.y-1.91292500,generator.z+1.94832000,false,false,false)

	CreateObject(`v_res_mbronzvase`,generator.x-1.22181700,generator.y-5.85892400,generator.z+2.96991700,false,false,false)
	CreateObject(`v_res_mbronzvase`,generator.x-1.22181700,generator.y-1.93053400,generator.z+2.96991700,false,false,false)
	CreateObject(`P_CS_Lighter_01`,generator.x+1.65356500,generator.y-1.83352900,generator.z+1.51874300,false,false,false)
	CreateObject(`prop_cs_remote_01`,generator.x+1.91542400,generator.y-3.08195300,generator.z+1.17354000,false,false,false)
	CreateObject(`Prop_Cigar_03`,generator.x+1.69850500,generator.y-1.87285600,generator.z+1.51726400,false,false,false)
	CreateObject(`v_res_jewelbox`,generator.x-1.28456500,generator.y-1.86961300,generator.z+0.92229600,false,false,false)
	CreateObject(`v_res_sculpt_decb`,generator.x+6.35535900,generator.y-6.97679200,generator.z+1.51251600,false,false,false)
	CreateObject(`v_med_smokealarm`,generator.x+2.16099000,generator.y+0.16853520,generator.z+4.27092600,false,false,false)
	CreateObject(`Prop_MP3_Dock`,generator.x+3.01717900,generator.y+1.91097300,generator.z+1.82875200,false,false,false)
	CreateObject(`v_res_mplanttongue`,generator.x+6.22999700,generator.y+2.87820200,generator.z+0.67128700,false,false,false)
	CreateObject(`v_res_m_palmplant1`,generator.x+6.08580900,generator.y-7.32884600,generator.z+0.3557600,false,false,false)
	CreateObject(`v_res_mconsolemod`,generator.x-0.91939260,generator.y-0.08264160,generator.z+4.57637000,false,false,false)
	CreateObject(`v_res_jewelbox`,generator.x-0.82748790,generator.y-0.20085050,generator.z+5.66071400,false,false,false)
	local tbl = CreateObject(`v_res_mconsoletrad`,generator.x+8.11723000,generator.y+1.42394700,generator.z+4.57726500,false,false,false)
	SetEntityHeading(tbl,GetEntityHeading(tbl)+90)
	CreateObject(`v_res_m_lamptbl`,generator.x-1.62722200,generator.y-0.13789180,generator.z+5.65792500,false,false,false)
	CreateObject(`v_res_m_lamptbl`,generator.x+8.18071300,generator.y+2.04316300,generator.z+5.57849900,false,false,false)
	local chair = CreateObject(`v_res_m_l_chair1`,generator.x+7.99242500,generator.y+0.01499653,generator.z+4.57605400,false,false,false)
	CreateObject(`v_res_m_l_chair1`,generator.x+8.01060600,generator.y+2.76839300,generator.z+4.57605400,false,false,false)
	SetEntityHeading(chair,GetEntityHeading(chair)+180)
	CreateObject(`V_44_1_Hall_Deca`,generator.x+3.13426900,generator.y+1.57208700,generator.z+4.17700800,false,false,false)

	CreateObject(`v_res_rosevase`,generator.x-0.26545330,generator.y-0.10977080,generator.z+5.65792600,false,false,false)
	CreateObject(`v_res_sculpt_decb`,generator.x-0.53595730,generator.y-0.11254690,generator.z+5.64740600,false,false,false)
	CreateObject(`v_med_smokealarm`,generator.x+1.68776500,generator.y+0.42464830,generator.z+8.42701300,false,false,false)
	CreateObject(`V_44_1_Hall_Emis`,generator.x+3.07805800,generator.y+1.41576700,generator.z+4.67713900,false,false,false)
	CreateObject(`v_res_exoticvase`,generator.x+8.19652200,generator.y+0.84531020,generator.z+5.57848900,false,false,false)
	CreateObject(`v_res_wall_cornertop`,generator.x+5.75375900,generator.y+3.57656500,generator.z+4.64713100,false,false,false)
	CreateObject(`V_44_G_Hall_Stairs`,generator.x+2.20412200,generator.y+6.63279700,generator.z+0.0591100,false,false,false)
	CreateObject(`v_res_jewelbox`,generator.x+2.19403800,generator.y+6.81445700,generator.z+0.98931310,false,false,false)
	CreateObject(`V_44_G_Hall_Deca`,generator.x-1.17366600,generator.y+5.92338700,generator.z+0.0591100,false,false,false)

	CreateObject(`V_44_G_Hall_Detail`,generator.x-1.02243200,generator.y+6.13491800,generator.z-0.10022200,false,false,false)
	CreateObject(`v_res_m_h_console`,generator.x+1.82824500,generator.y+6.68009400,generator.z-0.01091900,false,false,false)
	CreateObject(`v_res_m_l_chair1`,generator.x+0.31978320,generator.y+6.61237500,generator.z-0.00766298,false,false,false)

	CreateObject(`v_res_m_lamptbl`,generator.x+2.53901100,generator.y+6.84344500,generator.z+0.98873800,false,false,false)
	CreateObject(`v_res_r_fighorse`,generator.x+1.51177400,generator.y+6.80384800,generator.z+0.98999990,false,false,false)
	local fakeWindow = CreateObject(`V_44_fakewindow2`,generator.x+4.21531000,generator.y+10.08412000,generator.z+4.87963000,false,false,false)
	SetEntityHeading(fakeWindow,GetEntityHeading(fakeWindow)+90)
	CreateObject(`V_44_G_Hall_Emis`,generator.x+2.20520900,generator.y+6.75564800,generator.z+0.08329000,false,false,false)
	CreateObject(`v_res_m_palmstairs`,generator.x+4.72221300,generator.y+8.98925600,generator.z+2.54000000,false,false,false)

	CreateObject(`V_44_CableMesh3833165_TStd`,generator.x+1.75523300,generator.y+6.39947000,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd001`,generator.x+1.78448500,generator.y+6.42844600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd002`,generator.x+1.74144700,generator.y+6.35389700,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd003`,generator.x+1.75072700,generator.y+6.30324000,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd004`,generator.x+1.78820400,generator.y+6.25723600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd005`,generator.x+1.84311200,generator.y+6.23637000,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd006`,generator.x+1.90750400,generator.y+6.24566200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd007`,generator.x+1.96734300,generator.y+6.28310200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd008`,generator.x+2.00246200,generator.y+6.34640700,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd009`,generator.x+2.00791500,generator.y+6.42378600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd010`,generator.x+1.97100100,generator.y+6.50082400,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd011`,generator.x+1.90181300,generator.y+6.55381400,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd012`,generator.x+1.81217900,generator.y+6.56836200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd013`,generator.x+1.72014100,generator.y+6.54205000,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd014`,generator.x+1.64590600,generator.y+6.47087100,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd015`,generator.x+1.61379000,generator.y+6.36883200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd016`,generator.x+1.62891000,generator.y+6.25810100,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd017`,generator.x+1.69617000,generator.y+6.16635900,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd018`,generator.x+1.80279100,generator.y+6.11314600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd019`,generator.x+1.92696300,generator.y+6.11514100,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd020`,generator.x+2.04181100,generator.y+6.17349800,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd021`,generator.x+2.12081100,generator.y+6.28245600,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd022`,generator.x+2.14047900,generator.y+6.41642200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd023`,generator.x+2.09283800,generator.y+6.55434200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd024`,generator.x+1.98836000,generator.y+6.65625400,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd025`,generator.x+1.84142900,generator.y+6.70009800,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd026`,generator.x+1.68961500,generator.y+6.67540200,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd027`,generator.x+1.56111200,generator.y+6.57634700,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd028`,generator.x+1.48924500,generator.y+6.42581500,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd029`,generator.x+1.49306700,generator.y+6.25427400,generator.z+4.76513900,false,false,false)
	CreateObject(`V_44_CableMesh3833165_TStd030`,generator.x+1.57488200,generator.y+6.10241900,generator.z+4.76513900,false,false,false)

	CreateObject(`prop_kettle_01`,generator.x+14.70269000,generator.y+5.80536400,generator.z+1.49509300,false,false,false)
	CreateObject(`v_res_mchopboard`,generator.x+14.36221000,generator.y+6.14473800,generator.z+1.44332300,false,false,false)
	CreateObject(`v_res_ovenhobmod`,generator.x+11.64079000,generator.y+9.26502400,generator.z+0.53966500,false,false,false)
	CreateObject(`v_res_mcofcupdirt`,generator.x+9.42801900,generator.y+6.43112200,generator.z+1.35738400,false,false,false)
	local chair3 = CreateObject(`v_res_kitchnstool`,generator.x+8.80919000,generator.y+6.47474700,generator.z+0.44114000,false,false,false)
	SetEntityHeading(chair3,GetEntityHeading(chair3)+90)
	local chair2 = CreateObject(`v_res_kitchnstool`,generator.x+10.91919000,generator.y+5.77998600,generator.z+0.44114000,false,false,false)
	SetEntityHeading(chair2,GetEntityHeading(chair2)-180)
	CreateObject(`v_res_mcofcupdirt`,generator.x+11.34266000,generator.y+6.24398800,generator.z+1.35738300,false,false,false)
	CreateObject(`v_res_cherubvase`,generator.x+14.63630000,generator.y+5.11709100,generator.z+3.49411800,false,false,false)
	local chalk2 = CreateObject(`v_res_mchalkbrd`,generator.x+13.66986000,generator.y+4.39613200,generator.z+1.55808300,false,false,false)
	SetEntityHeading(chalk2,GetEntityHeading(chalk2)-180)
	CreateObject(`V_44_G_Kitche_Deta`,generator.x+10.46560000,generator.y+5.93617800,generator.z+0.45652500,false,false,false)
	CreateObject(`V_44_Kitche_Units`,generator.x+8.25900000,generator.y+8.95200000,generator.z+0.46638600,false,false,false)
	CreateObject(`V_44_G_Kitche_Deca`,generator.x+10.32270000,generator.y+6.99725600,generator.z+0.19062300,false,false,false)
	CreateObject(`v_ilev_mm_fridge_r`,generator.x+8.25900000,generator.y+8.95199800,generator.z+0.60638600,false,false,false)
	CreateObject(`v_ilev_mm_fridge_l`,generator.x+6.88500100,generator.y+8.95199800,generator.z+0.60638600,false,false,false)
	local fau = CreateObject(`v_ilev_mm_faucet`,generator.x+14.71225000,generator.y+7.05411800,generator.z+1.44085800,false,false,false)
	SetEntityHeading(fau,GetEntityHeading(fau)-90)
	CreateObject(`v_res_ovenhobmod`,generator.x+10.74079000,generator.y+9.26502400,generator.z+0.53966500,false,false,false)
	CreateObject(`V_44_kitc_chand`,generator.x+10.41700000,generator.y+6.60862900,generator.z+3.18510400,false,false,false)

	CreateObject(`v_res_mcofcup`,generator.x+14.45970000,generator.y+9.07571200,generator.z+2.24126100,false,false,false)
	CreateObject(`v_res_mcofcup`,generator.x+14.54827000,generator.y+8.99532900,generator.z+2.24126100,false,false,false)
	CreateObject(`v_res_mcofcup`,generator.x+14.71489000,generator.y+9.00675800,generator.z+2.24126100,false,false,false)
	CreateObject(`v_res_mcofcup`,generator.x+14.83611000,generator.y+9.04519500,generator.z+2.24126100,false,false,false)

	CreateObject(`v_res_mmug`,generator.x+14.78669000,generator.y+9.03503600,generator.z+2.87347100,false,false,false)
	CreateObject(`v_res_mmug`,generator.x+14.63922000,generator.y+9.06091500,generator.z+2.87347100,false,false,false)
	CreateObject(`v_res_mmug`,generator.x+14.43891000,generator.y+9.05505500,generator.z+2.87347100,false,false,false)
	CreateObject(`v_res_mmug`,generator.x+14.42877000,generator.y+9.11096400,generator.z+2.55747100,false,false,false)
	CreateObject(`v_res_mmug`,generator.x+14.54221000,generator.y+9.00290800,generator.z+2.55747100,false,false,false)
	CreateObject(`v_res_mmug`,generator.x+14.68125000,generator.y+9.04880700,generator.z+2.55747100,false,false,false)
	CreateObject(`v_res_mmug`,generator.x+14.81833000,generator.y+9.06052600,generator.z+2.55747100,false,false,false)

	CreateObject(`v_res_mcofcup`,generator.x+14.75149000,generator.y+9.12099900,generator.z+2.24126100,false,false,false)
	CreateObject(`v_res_mcofcup`,generator.x+14.60091000,generator.y+9.11538300,generator.z+2.24126100,false,false,false)
	CreateObject(`v_res_bowl_dec`,generator.x+14.60194000,generator.y+5.59344000,generator.z+3.49420900,false,false,false)
	CreateObject(`prop_coffee_mac_02`,generator.x+14.66308000,generator.y+8.61713000,generator.z+1.68848500,false,false,false)
	CreateObject(`v_res_r_sugarbowl`,generator.x+14.78637000,generator.y+8.41123000,generator.z+1.44060400,false,false,false)
	CreateObject(`v_res_r_coffpot`,generator.x+14.53064000,generator.y+8.37244600,generator.z+1.44111000,false,false,false)
	local util = CreateObject(`v_res_mutensils`,generator.x+10.18923000,generator.y+9.27150500,generator.z+1.64567300,false,false,false)
	SetEntityHeading(util,GetEntityHeading(util)+90)

	CreateObject(`v_res_mkniferack`,generator.x+14.88481000,generator.y+5.59870400,generator.z+1.66517100,false,false,false)
	CreateObject(`v_res_r_pepppot`,generator.x+10.19567000,generator.y+9.20170600,generator.z+1.43884000,false,false,false)
	CreateObject(`v_res_r_pepppot`,generator.x+10.19869000,generator.y+9.06467400,generator.z+1.43884000,false,false,false)
	CreateObject(`v_res_cherubvase`,generator.x+14.64228000,generator.y+9.01812800,generator.z+3.49411800,false,false,false)

	CreateObject(`v_res_mpotpouri`,generator.x+14.55577000,generator.y+8.50598100,generator.z+3.49411800,false,false,false)
	local util2 = CreateObject(`v_res_mutensils`,generator.x+12.18506000,generator.y+9.27150500,generator.z+1.64567300,false,false,false)
	SetEntityHeading(util2,GetEntityHeading(util2)+90)
	CreateObject(`prop_micro_02`,generator.x+6.14397200,generator.y+9.10795800,generator.z+1.48797600,false,false,false)
	CreateObject(`prop_lime_jar`,generator.x+10.82650000,generator.y+6.78537100,generator.z+1.39791000,false,false,false)
	CreateObject(`prop_copper_pan`,generator.x+11.08923000,generator.y+9.36298200,generator.z+1.46961000,false,false,false)
	CreateObject(`prop_kitch_juicer`,generator.x+5.87455900,generator.y+7.72984300,generator.z+1.52251400,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+5.88074500,generator.y+7.55808400,generator.z+1.44086000,false,false,false)
	local chalk = CreateObject(`v_ilev_mchalkbrd_1`,generator.x+13.67297000,generator.y+4.37304300,generator.z+1.71720500,false,false,false)
	SetEntityHeading(chalk,GetEntityHeading(chalk)-180)
	CreateObject(`prop_metalfoodjar_01`,generator.x+14.50831000,generator.y+4.53625300,generator.z+2.24113200,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+14.50855000,generator.y+4.55157300,generator.z+2.55713100,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+14.49850000,generator.y+4.54775800,generator.z+2.87313100,false,false,false)
	CreateObject(`prop_metalfoodjar_01`,generator.x+14.66818000,generator.y+4.56423800,generator.z+2.87313100,false,false,false)

	CreateObject(`v_res_m_pot1`,generator.x+14.61287000,generator.y+4.86072500,generator.z+3.49455900,false,false,false)
	CreateObject(`v_res_m_pot1`,generator.x+14.65746000,generator.y+8.76475400,generator.z+3.49455900,false,false,false)
	CreateObject(`v_ilev_mm_fridgeint`,generator.x+7.57204700,generator.y+9.50173000,generator.z+1.59127800,false,false,false)
	CreateObject(`prop_cs_kitchen_cab_l`,generator.x+13.48880000,generator.y+9.39807700,generator.z+1.50317400,false,false,false)
	CreateObject(`prop_cs_kitchen_cab_r`,generator.x+9.14163700,generator.y+9.39807700,generator.z+1.50319300,false,false,false)
	CreateObject(`p_w_grass_gls_s`,generator.x+6.30300100,generator.y+8.03400000,generator.z+1.40800000,false,false,false)
	CreateObject(`v_res_mbronzvase`,generator.x+14.69197000,generator.y+9.00720200,generator.z+1.44086000,false,false,false)
	CreateObject(`v_res_mbronzvase`,generator.x+14.69197000,generator.y+4.55828000,generator.z+1.44086000,false,false,false)
	CreateObject(`v_med_smokealarm`,generator.x+12.91037000,generator.y+6.59943400,generator.z+4.12818200,false,false,false)
	CreateObject(`prop_foodprocess_01`,generator.x+5.95365100,generator.y+8.23214900,generator.z+1.44086000,false,false,false)
	CreateObject(`v_res_wall`,generator.x+9.48288900,generator.y+3.80587900,generator.z+0.49649800,false,false,false)

	CreateObject(`V_44_Kitche_Cables`,generator.x+15.13288000,generator.y+7.09520900,generator.z+2.93397100,false,false,false)

	CreateObject(`p_whiskey_bottle_s`,generator.x+9.76500100,generator.y+6.22099900,generator.z+1.49900000,false,false,false)
	CreateObject(`p_tumbler_cs2_s`,generator.x+9.51600000,generator.y+6.20100000,generator.z+1.40700000,false,false,false)
	CreateObject(`V_44_G_Kitche_Mirror`,generator.x+10.43927000,generator.y+6.61117700,generator.z+1.35984500,false,false,false)
	CreateObject(`V_44_Kitc_Emmi_Refl`,generator.x+14.88308000,generator.y+7.08548200,generator.z+1.71777900,false,false,false)

	CreateObject(`V_44_1_WC_Deta`,generator.x+1.17765600,generator.y-4.48131400,generator.z+4.63232000,false,false,false)
	CreateObject(`V_44_1_WC_Deca`,generator.x+1.59504700,generator.y-6.12709600,generator.z+4.63267900,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.70206260,generator.y-4.16378900,generator.z+5.71612900,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.68338590,generator.y-4.52617000,generator.z+5.71612900,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.72427940,generator.y-4.86893600,generator.z+5.71612900,false,false,false)
	CreateObject(`v_res_mbathpot`,generator.x+0.70345690,generator.y-4.35693900,generator.z+6.48056100,false,false,false)
	CreateObject(`v_res_glasspot`,generator.x+0.71698950,generator.y-4.14175200,generator.z+6.47866700,false,false,false)

	CreateObject(`v_res_mlaundry`,generator.x+0.76481630,generator.y-4.38597400,generator.z+4.68115500,false,false,false)
	CreateObject(`v_res_mbbin`,generator.x+0.77170370,generator.y-4.85373500,generator.z+4.68933400,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.71842000,generator.y-4.16739000,generator.z+6.09812900,false,false,false)
	CreateObject(`prop_toilet_shamp_02`,generator.x+0.68262770,generator.y-4.77760400,generator.z+6.60591400,false,false,false)
	CreateObject(`v_res_mpotpouri`,generator.x+0.72062970,generator.y-4.56955600,generator.z+6.47866700,false,false,false)

	CreateObject(`prop_toilet_shamp_02`,generator.x+0.78394590,generator.y-4.83148300,generator.z+6.60591400,false,false,false)
	CreateObject(`v_res_tissues`,generator.x+0.74644000,generator.y-4.58213100,generator.z+6.09788000,false,false,false)
	CreateObject(`v_res_fa_mag_rumor`,generator.x+0.71411900,generator.y-4.89627400,generator.z+6.19172800,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.70755580,generator.y-4.71013000,generator.z+5.40776400,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x+0.70206260,generator.y-4.31527900,generator.z+5.40776400,false,false,false)
	CreateObject(`v_res_m_wctoiletroll`,generator.x+1.05170400,generator.y-7.98192900,generator.z+5.28550600,false,false,false)

	CreateObject(`V_44_1_WC_Wall`,generator.x+0.58679010,generator.y-5.92510000,generator.z+4.64117100,false,false,false)
	local sink = CreateObject(`v_res_m_sinkunit`,generator.x+0.57028010,generator.y-6.54750800,generator.z+4.57696100,false,false,false)
	SetEntityHeading(sink,GetEntityHeading(sink)+90)
	CreateObject(`v_res_mbathpot`,generator.x+0.44344710,generator.y-5.86374200,generator.z+5.41919400,false,false,false)
	CreateObject(`v_res_mbaccessory`,generator.x+0.44116590,generator.y-5.68478200,generator.z+5.40682800,false,false,false)

	CreateObject(`v_res_fashmag1`,generator.x+0.53466320,generator.y-7.69714400,generator.z+5.40757800,false,false,false)
	CreateObject(`v_res_mpotpouri`,generator.x+0.46240810,generator.y-7.37532400,generator.z+5.40551200,false,false,false)
	CreateObject(`prop_toilet_brush_01`,generator.x+0.89410590,generator.y-7.78916400,generator.z+4.55693300,false,false,false)
	CreateObject(`prop_toothpaste_01`,generator.x+0.62113380,generator.y-6.03470400,generator.z+5.39733200,false,false,false)
	CreateObject(`prop_toilet_shamp_02`,generator.x+0.37264820,generator.y-6.11828800,generator.z+5.53571800,false,false,false)
	CreateObject(`prop_toilet_shamp_02`,generator.x+0.34396170,generator.y-6.26275800,generator.z+5.53571800,false,false,false)
	local mirror = CreateObject(`v_ret_mirror`,generator.x+0.31381230,generator.y-6.52928800,generator.z+5.64878300,false,false,false)
	SetEntityHeading(mirror,GetEntityHeading(mirror)+90)
	CreateObject(`v_res_desklamp`,generator.x-1.65334600,generator.y-8.03860100,generator.z+5.37723000,false,false,false)
	CreateObject(`V_44_son_clutter`,generator.x-2.72426300,generator.y-4.61612700,generator.z+4.70186500,false,false,false)
	CreateObject(`V_44_1_Son_Deta`,generator.x-2.38526100,generator.y-4.51695800,generator.z+4.60237100,false,false,false)
	CreateObject(`prop_speaker_06`,generator.x-4.37202500,generator.y-3.15667900,generator.z+5.40821800,false,false,false)

	CreateObject(`V_44_1_Son_Deca`,generator.x-2.38558800,generator.y-4.51694800,generator.z+4.70213800,false,false,false)
	local bed = CreateObject(`v_res_msonbed`,generator.x-1.28441200,generator.y-4.80573900,generator.z+4.57700000,false,false,false)
	FreezeEntityPosition(bed,true)
	SetEntityHeading(bed,GetEntityHeading(bed)-90)
	CreateObject(`des_tvsmash`,generator.x-4.65294700,generator.y-3.06008700,generator.z+6.08225600,false,false,false)
	CreateObject(`v_res_fa_mag_motor`,generator.x-0.39596750,generator.y-6.14882800,generator.z+4.65708300,false,false,false)
	CreateObject(`v_res_m_lampstand`,generator.x-0.12011430,generator.y-6.15963500,generator.z+4.57726500,false,false,false)
	CreateObject(`v_res_tt_pizzaplate`,generator.x-0.72473050,generator.y-6.00035400,generator.z+4.58975600,false,false,false)
	CreateObject(`v_res_tt_can03`,generator.x-0.07454681,generator.y-3.55089300,generator.z+4.64916200,false,false,false)
	CreateObject(`v_res_tt_pizzaplate`,generator.x-2.14520900,generator.y-3.73351100,generator.z+4.58975600,false,false,false)
	CreateObject(`v_res_tt_can03`,generator.x-0.12168120,generator.y-3.84719700,generator.z+4.64916200,false,false,false)
	CreateObject(`v_res_tt_can03`,generator.x-3.68282300,generator.y-1.50274500,generator.z+4.64916200,false,false,false)
	CreateObject(`v_res_tt_pizzaplate`,generator.x-3.79727100,generator.y-1.68703200,generator.z+4.58975600,false,false,false)
	CreateObject(`v_res_tt_can03`,generator.x-0.35707760,generator.y-6.58195200,generator.z+4.64916200,false,false,false)
	CreateObject(`v_club_roc_gstand`,generator.x-0.24508670,generator.y-6.91720400,generator.z+4.57714300,false,false,false)
	CreateObject(`v_res_fashmag1`,generator.x-1.77334100,generator.y-3.80492700,generator.z+4.60178600,false,false,false)
	CreateObject(`v_res_tt_can03`,generator.x-0.10475160,generator.y-0.74553110,generator.z+4.64916200,false,false,false)
	CreateObject(`V_44_fakewindow6`,generator.x-5.33984800,generator.y-6.60726400,generator.z+4.74075300,false,false,false)
	CreateObject(`V_44_1_Daught_Deta`,generator.x+5.15501400,generator.y-4.61960500,generator.z+4.65251100,false,false,false)
	CreateObject(`v_res_tissues`,generator.x+4.23728100,generator.y-7.78753900,generator.z+5.57759400,false,false,false)
	CreateObject(`V_44_M_Daught_Over`,generator.x+5.06478200,generator.y-4.51694800,generator.z+4.65251100,false,false,false)

	CreateObject(`v_res_mbchair`,generator.x+4.34751900,generator.y-6.83495000,generator.z+4.57700000,false,false,false)
	CreateObject(`v_res_jewelbox`,generator.x+5.60166200,generator.y-7.84856600,generator.z+5.57709100,false,false,false)
	CreateObject(`v_res_m_candle`,generator.x+5.63198000,generator.y-8.10918900,generator.z+5.58055000,false,false,false)
	local dresser = CreateObject(`v_res_mddresser`,generator.x+4.96540800,generator.y-7.90087300,generator.z+4.57736500,false,false,false)
	FreezeEntityPosition(dresser,true)
	SetEntityHeading(dresser,GetEntityHeading(dresser)+180)
	CreateObject(`v_res_mdbedlamp`,generator.x+3.43900000,generator.y-3.66071800,generator.z+5.27747500,false,false,false)
	local bed2 = CreateObject(`v_res_mdbed`,generator.x+4.26333300,generator.y-5.19171000,generator.z+4.57726400,false,false,false)
	FreezeEntityPosition(bed2,true)
	SetEntityHeading(bed2,GetEntityHeading(bed2)+90)
	local desk = CreateObject(`v_res_mddesk`,generator.x+3.52612600,generator.y-6.93888700,generator.z+4.57726500,false,false,false)
	FreezeEntityPosition(desk,true)
	SetEntityHeading(desk,GetEntityHeading(desk)+90)
	CreateObject(`v_res_fa_mag_rumor`,generator.x+3.25719700,generator.y-7.18534500,generator.z+5.75928800,false,false,false)
	CreateObject(`v_res_tre_cushionc`,generator.x+3.74167700,generator.y-5.04673700,generator.z+5.23786200,false,false,false)
	CreateObject(`v_res_jcushionc`,generator.x+3.47843300,generator.y-5.44828800,generator.z+5.34760300,false,false,false)
	CreateObject(`V_44_1_Daught_Deta_ns`,generator.x+5.15501400,generator.y-4.61960500,generator.z+4.63951100,false,false,false)
	CreateObject(`v_res_d_dressdummy`,generator.x+3.80953400,generator.y-7.96329600,generator.z+4.57726400,false,false,false)
	CreateObject(`v_club_vu_drawer`,generator.x+6.33438800,generator.y-7.96820100,generator.z+4.57700000,false,false,false)
	local flat = CreateObject(`prop_tv_flat_03b`,generator.x+7.02415300,generator.y-5.41506100,generator.z+6.39180400,false,false,false)
	SetEntityHeading(flat,GetEntityHeading(flat)-90)


	CreateObject(`V_44_D_chand`,generator.x+4.94644200,generator.y-5.37181500,generator.z+7.03764900,false,false,false)
	CreateObject(`v_club_dress1`,generator.x+6.10717800,generator.y-1.56363600,generator.z+6.50635300,false,false,false)
	CreateObject(`v_res_m_candle`,generator.x+4.30049800,generator.y-8.10229200,generator.z+5.58055000,false,false,false)
	CreateObject(`v_res_fa_book04`,generator.x+3.78683400,generator.y-7.22723100,generator.z+5.48160700,false,false,false)
	CreateObject(`v_res_fa_book03`,generator.x+3.78421300,generator.y-7.26617900,generator.z+5.43769900,false,false,false)
	CreateObject(`V_44_fakewindow007`,generator.x+5.43454700,generator.y-6.13995100,generator.z+5.70870800,false,false,false)
	CreateObject(`v_res_mdbedtable`,generator.x+3.50600100,generator.y-3.73348200,generator.z+4.57736500,false,false,false)
	CreateObject(`V_44_D_emis`,generator.x+5.06478000,generator.y-4.51694400,generator.z+4.57726800,false,false,false)

	CreateObject(`V_44_1_Daught_GeomL`,generator.x+6.32631400,generator.y-4.70905700,generator.z+4.66521900,false,false,false)

	CreateObject(`V_44_1_Master_Deca`,generator.x-3.69378700,generator.y+6.42393100,generator.z+4.70213800,false,false,false)
	CreateObject(`v_res_tissues`,generator.x-0.70506190,generator.y+8.35398300,generator.z+5.41244700,false,false,false)
	CreateObject(`v_res_fa_book03`,generator.x-5.56946900,generator.y+9.12105200,generator.z+5.19722600,false,false,false)
	CreateObject(`v_res_fa_book04`,generator.x-5.54973200,generator.y+9.12014800,generator.z+5.15438000,false,false,false)
	CreateObject(`v_res_fa_book02`,generator.x-6.50122700,generator.y+9.17851300,generator.z+4.59468800,false,false,false)
	CreateObject(`v_res_fashmagopen`,generator.x-0.98937320,generator.y+8.10803400,generator.z+5.41998300,false,false,false)
	CreateObject(`v_res_fa_mag_motor`,generator.x-6.78904000,generator.y+9.23604700,generator.z+4.67064800,false,false,false)
	CreateObject(`v_res_r_bublbath`,generator.x-0.67247480,generator.y+7.95763200,generator.z+5.41998300,false,false,false)

	CreateObject(`V_44_1_Master_Deta`,generator.x-3.78856900,generator.y+5.11689300,generator.z+4.69215000,false,false,false)
	CreateObject(`des_frenchdoor`,generator.x-8.08411000,generator.y+6.35292000,generator.z+4.54623800,false,false,false)
	CreateObject(`v_res_m_bananaplant`,generator.x-7.02282700,generator.y+4.15889300,generator.z+4.07726500,false,false,false)
	CreateObject(`v_res_m_bananaplant`,generator.x-6.98458900,generator.y+8.58176000,generator.z+4.07726500,false,false,false)
	CreateObject(`v_res_m_lamptbl`,generator.x-2.88499400,generator.y+9.32790300,generator.z+5.13576900,false,false,false)
	CreateObject(`v_res_m_lamptbl`,generator.x-5.67367400,generator.y+9.32790300,generator.z+5.13576900,false,false,false)
	CreateObject(`v_res_m_l_chair1`,generator.x-1.71462300,generator.y+7.92522600,generator.z+4.57605400,false,false,false)

	local mirr =  CreateObject(`v_ret_mirror`,generator.x-0.53916740,generator.y+7.97935500,generator.z+5.45417000,false,false,false)
	SetEntityHeading(mirr,GetEntityHeading(mirr)-90)
	CreateObject(`v_res_mconsoletrad`,generator.x-3.59876400,generator.y+3.85237200,generator.z+4.57726500,false,false,false)
	CreateObject(`V_44_1_Master_Chan`,generator.x-4.28273200,generator.y+8.01677900,generator.z+7.52571900,false,false,false)
	CreateObject(`v_res_mplanttongue`,generator.x-2.54529100,generator.y+3.77437800,generator.z+4.57856000,false,false,false)
	CreateObject(`v_res_mplanttongue`,generator.x-4.65680100,generator.y+3.87188100,generator.z+4.57856000,false,false,false)
	CreateObject(`v_res_mpotpouri`,generator.x-3.01684700,generator.y+3.81856100,generator.z+5.57820200,false,false,false)
	CreateObject(`v_res_fa_candle04`,generator.x-3.19362500,generator.y+3.93352300,generator.z+5.65119800,false,false,false)
	CreateObject(`v_res_fa_candle04`,generator.x-3.34104000,generator.y+3.87041400,generator.z+5.65119800,false,false,false)
	CreateObject(`v_res_fa_candle04`,generator.x-4.03105700,generator.y+3.95793800,generator.z+5.65119800,false,false,false)
	local dres =  CreateObject(`v_res_mbdresser`,generator.x-0.85383890,generator.y+7.96966400,generator.z+4.57766400,false,false,false)
	FreezeEntityPosition(dres,true)
	SetEntityHeading(dres,GetEntityHeading(dres)-90)
	CreateObject(`v_res_d_lampa`,generator.x-0.79797650,generator.y+8.74071700,generator.z+5.41998300,false,false,false)
	CreateObject(`v_res_d_lampa`,generator.x-0.77069570,generator.y+7.17489800,generator.z+5.41998300,false,false,false)
	CreateObject(`v_res_mbbedtable`,generator.x-2.89582400,generator.y+9.22972300,generator.z+4.58609800,false,false,false)
	CreateObject(`v_res_mbbedtable`,generator.x-5.67645700,generator.y+9.23738900,generator.z+4.58609800,false,false,false)
	CreateObject(`v_res_fashmag1`,generator.x-6.43877000,generator.y+9.22318300,generator.z+4.61232700,false,false,false)
	CreateObject(`V_44_fakewindow5`,generator.x-4.23272900,generator.y+10.06902000,generator.z+6.88756600,false,false,false)
	CreateObject(`prop_d_balcony_l_light`,generator.x-8.07400100,generator.y+7.33400000,generator.z+5.98500000,false,false,false)
	CreateObject(`prop_d_balcony_r_light`,generator.x-8.07500100,generator.y+5.36899900,generator.z+5.98200100,false,false,false)
	local sofa3 = CreateObject(`v_res_m_h_sofa_sml`,generator.x-0.04692268,generator.y+4.91675800,generator.z+4.57255100,false,false,false)
	SetEntityHeading(sofa3,GetEntityHeading(sofa3)-90)
	FreezeEntityPosition(sofa3,true)
	CreateObject(`V_44_1_Master_Refl`,generator.x-2.24256700,generator.y+6.12810900,generator.z+7.40200100,false,false,false)
	local flat = CreateObject(`prop_tv_flat_michael`,generator.x-3.60332300,generator.y+3.59323500,generator.z+6.69362700,false,false,false)
	SetEntityHeading(flat,GetEntityHeading(flat)+180)

	CreateObject(`V_44_Dine_Deca`,generator.x+11.95362000,generator.y+1.21796200,generator.z+0.73423600,false,false,false)
	CreateObject(`v_res_m_dinetble`,generator.x+11.65958000,generator.y+1.48803700,generator.z+0.67128700,false,false,false)
	CreateObject(`v_res_m_palmplant1`,generator.x+14.03610000,generator.y+3.36004000,generator.z+0.1157600,false,false,false)
	CreateObject(`v_res_m_bananaplant`,generator.x+14.03464000,generator.y-0.53919510,generator.z+0.1157600,false,false,false)
	CreateObject(`v_res_m_palmplant1`,generator.x+9.87301400,generator.y-0.91560370,generator.z+0.1157600,false,false,false)
	local dChair = CreateObject(`v_ilev_m_dinechair`,generator.x+11.07593000,generator.y+2.15326300,generator.z+0.67300000,false,false,false)
	SetEntityHeading(dChair,GetEntityHeading(dChair)+40)
	local dChair2 = CreateObject(`v_ilev_m_dinechair`,generator.x+12.21606000,generator.y+1.99956100,generator.z+0.67300000,false,false,false)
	SetEntityHeading(dChair2,GetEntityHeading(dChair2)-60)
	local dChair3 = CreateObject(`v_ilev_m_dinechair`,generator.x+12.21671000,generator.y+0.96316720,generator.z+0.67300000,false,false,false)
	SetEntityHeading(dChair3,GetEntityHeading(dChair3)+210)
	local dChair4 = CreateObject(`v_ilev_m_dinechair`,generator.x+10.97966000,generator.y+1.02813000,generator.z+0.67300000,false,false,false)
	SetEntityHeading(dChair4,GetEntityHeading(dChair4)+130)
	CreateObject(`V_44_Dine_Deta`,generator.x+12.00919000,generator.y+1.16270300,generator.z+0.49488500,false,false,false)

	CreateObject(`V_44_Dine_Detail`,generator.x+11.95362000,generator.y+1.21796200,generator.z+2.53423600,false,false,false)
	CreateObject(`V_44_G_Fron_Deta`,generator.x-6.02225700,generator.y+6.81935900,generator.z+0.12220800,false,false,false)
	CreateObject(`V_44_G_Fron_Deca`,generator.x-6.02163100,generator.y+6.55411300,generator.z+0.12220900,false,false,false)
	CreateObject(`v_res_m_bananaplant`,generator.x-6.39008700,generator.y+8.55775700,generator.z-0.39999999,false,false,false)
	CreateObject(`v_res_m_h_sofa`,generator.x-4.16015100,generator.y+9.05558000,generator.z-0.00826600,false,false,false)
	CreateObject(`v_res_mconsoletrad`,generator.x-6.08591400,generator.y+4.25902900,generator.z-0.01249600,false,false,false)
	CreateObject(`v_res_m_lamptbl`,generator.x-6.57136300,generator.y+4.19632500,generator.z+0.98873800,false,false,false)
	CreateObject(`v_res_m_statue`,generator.x-5.90549600,generator.y+4.21699500,generator.z+1.00457700,false,false,false)
	CreateObject(`v_res_mconsoletrad`,generator.x-2.32082600,generator.y+4.25408500,generator.z-0.01249600,false,false,false)
	CreateObject(`v_res_m_lamptbl`,generator.x-1.79376400,generator.y+4.19632500,generator.z+0.98873800,false,false,false)
	CreateObject(`v_res_m_horsefig`,generator.x-2.26889200,generator.y+4.23528100,generator.z+0.98709510,false,false,false)
	CreateObject(`v_res_rosevase`,generator.x-2.92113700,generator.y+4.18977400,generator.z+0.98873800,false,false,false)
	CreateObject(`v_med_smokealarm`,generator.x-2.08868800,generator.y+6.37618500,generator.z+4.25485000,false,false,false)
	CreateObject(`v_res_exoticvase`,generator.x-4.24948700,generator.y+3.70693700,generator.z+1.08849900,false,false,false)
	CreateObject(`v_res_picture_frame`,generator.x-4.14919900,generator.y+9.59165000,generator.z+1.83966000,false,false,false)

	CreateObject(`V_44_G_Fron_Refl`,generator.x-4.58479900,generator.y+6.54761000,generator.z+3.05482600,false,false,false)
	CreateObject(`v_res_mlaundry`,generator.x-4.80988900,generator.y+0.47404100,generator.z+4.57726400,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34144300,generator.y+0.43847470,generator.z+4.67645100,false,false,false)
	CreateObject(`v_res_mbbin`,generator.x-4.24965800,generator.y+2.95531300,generator.z+4.57726400,false,false,false)
	CreateObject(`V_44_1_Master_Ward`,generator.x-6.40655500,generator.y+1.73388900,generator.z+4.57834600,false,false,false)
	CreateObject(`V_44_1_Master_WCha`,generator.x-4.09320100,generator.y+1.72192600,generator.z+7.00458700,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34144300,generator.y+0.43847470,generator.z+4.79156300,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34144200,generator.y+0.43847560,generator.z+5.41287100,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34144200,generator.y+0.43847560,generator.z+5.29775800,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34144300,generator.y+0.43847470,generator.z+4.91203100,false,false,false)

	CreateObject(`v_res_mpotpouri`,generator.x-4.29746100,generator.y+0.48316380,generator.z+5.89753800,false,false,false)
	CreateObject(`prop_toilet_shamp_02`,generator.x-4.48238100,generator.y+0.62180140,generator.z+6.02429700,false,false,false)
	CreateObject(`prop_toilet_shamp_02`,generator.x-4.48615000,generator.y+0.49110990,generator.z+6.02429700,false,false,false)
	CreateObject(`v_res_mbathpot`,generator.x-2.87927600,generator.y+1.44019500,generator.z+6.19828700,false,false,false)
	CreateObject(`v_res_glasspot`,generator.x-2.94354800,generator.y+1.24733200,generator.z+6.19828700,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34144300,generator.y+0.41808890,generator.z+5.02752500,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34144200,generator.y+0.42529200,generator.z+5.52627400,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.35752500,generator.y+0.42529200,generator.z+5.64102000,false,false,false)
	CreateObject(`v_club_dress1`,generator.x-3.17459400,generator.y+2.65436600,generator.z+6.60635300,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34182500,generator.y+0.43845940,generator.z+6.61331000,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34182500,generator.y+0.43845940,generator.z+6.49819700,false,false,false)
	CreateObject(`v_res_mbtowelfld`,generator.x-4.34067500,generator.y+0.42532540,generator.z+6.72671200,false,false,false)
	CreateObject(`v_res_jewelbox`,generator.x-2.88840100,generator.y+1.73250300,generator.z+6.19802900,false,false,false)
	CreateObject(`v_ret_box`,generator.x-2.89328200,generator.y+2.04067000,generator.z+6.19828700,false,false,false)

	CreateObject(`V_44_1_Mast_WaDeca`,generator.x-5.12681000,generator.y+1.68215100,generator.z+4.53070600,false,false,false)
	local sofa5 = CreateObject(`v_res_m_h_sofa_sml`,generator.x-7.23159200,generator.y+1.74248200,generator.z+4.57207500,false,false,false)
	SetEntityHeading(sofa5,GetEntityHeading(sofa5)+90)
	FreezeEntityPosition(sofa5,true)
	CreateObject(`v_ret_ps_bag_01`,generator.x-3.61668600,generator.y+3.13254600,generator.z+4.99871100,false,false,false)
	CreateObject(`v_ret_ps_toiletbag`,generator.x-2.76861400,generator.y+1.39369200,generator.z+5.89606400,false,false,false)
	CreateObject(`v_ret_ps_box_01`,generator.x-2.97353500,generator.y+1.29670200,generator.z+5.89606400,false,false,false)
	CreateObject(`V_44_1_Master_WRefl`,generator.x-4.09332200,generator.y+1.72202400,generator.z+7.60138100,false,false,false)
	CreateObject(`v_ret_ps_bag_01`,generator.x-3.01495300,generator.y+0.96563630,generator.z+6.19942300,false,false,false)
	CreateObject(`v_ret_ps_toiletbag`,generator.x-3.46218600,generator.y+0.41771320,generator.z+6.19835800,false,false,false)
	CreateObject(`v_res_mbathpot`,generator.x-3.90824200,generator.y+0.45705510,generator.z+6.19828700,false,false,false)
	CreateObject(`v_ret_ps_cologne_01`,generator.x-3.73762700,generator.y+0.33720970,generator.z+6.19861200,false,false,false)
	CreateObject(`v_ret_ps_cologne`,generator.x-3.71301800,generator.y+0.51087090,generator.z+6.19861200,false,false,false)
	CreateObject(`v_ret_ps_toiletry_02`,generator.x-3.57097800,generator.y+0.58250620,generator.z+6.19861200,false,false,false)
	CreateObject(`V_44_1_Hall2_Deca`,generator.x+1.57198900,generator.y-2.18456100,generator.z+4.65403500,false,false,false)
	CreateObject(`V_44_1_Hall2_Deta`,generator.x+1.56736800,generator.y-2.06291400,generator.z+4.65576400,false,false,false)
	CreateObject(`V_44_1_Hall2_Emis`,generator.x+1.56687600,generator.y-2.20749900,generator.z+4.60605400,false,false,false)


	CreateObject(`v_ilev_mm_windowwc`,generator.x+1.62417000,generator.y-8.63196500,generator.z+5.1711000,false,false,false)
	CreateObject(`prop_laptop_01a`,generator.x+3.56317100,generator.y-6.85662900,generator.z+5.42643200,false,false,false)
	CreateObject(`Prop_MP3_Dock`,generator.x+6.60110600,generator.y-5.41524300,generator.z+5.74843500,false,false,false)
	CreateObject(`V_44_1_Daught_CDoor`,generator.x+6.38870800,generator.y-2.07008200,generator.z+4.67503500,false,false,false)
	CreateObject(`V_44_1_Daught_Item`,generator.x+5.15501400,generator.y-4.61960500,generator.z+4.70251100,false,false,false)
	CreateObject(`V_44_D_Items_Over`,generator.x+5.06478200,generator.y-4.51694800,generator.z+4.70226800,false,false,false)
	CreateObject(`v_club_brush`,generator.x+5.27156900,generator.y-7.82374500,generator.z+5.57799900,false,false,false)
	CreateObject(`v_club_comb`,generator.x+5.33156700,generator.y-7.92099000,generator.z+5.57799900,false,false,false)
	CreateObject(`v_club_roc_jacket1`,generator.x+5.99520300,generator.y-1.56453200,generator.z+6.49564800,false,false,false)
	CreateObject(`v_club_skirtflare`,generator.x+6.23020200,generator.y-1.56066700,generator.z+6.50772100,false,false,false)
	CreateObject(`v_club_skirtplt`,generator.x+6.15445000,generator.y-1.56480200,generator.z+6.51050600,false,false,false)
	CreateObject(`v_club_slip`,generator.x+6.51164300,generator.y-1.56346100,generator.z+6.50603100,false,false,false)
	CreateObject(`v_club_vu_bear`,generator.x+3.24126400,generator.y-6.64180100,generator.z+5.66661100,false,false,false)
	CreateObject(`v_club_vuhairdryer`,generator.x+4.60364600,generator.y-7.89662200,generator.z+4.57700000,false,false,false)
	CreateObject(`v_club_vumakeupbrsh`,generator.x+4.74676800,generator.y-7.83952300,generator.z+5.57799900,false,false,false)
	CreateObject(`v_club_vutongs`,generator.x+4.69820500,generator.y-7.88481200,generator.z+5.58364700,false,false,false)
	CreateObject(`v_club_vuvanity`,generator.x+6.33217200,generator.y-7.98365200,generator.z+5.50917400,false,false,false)
	CreateObject(`v_res_mbathpot`,generator.x+4.93267800,generator.y-8.07459300,generator.z+5.61459300,false,false,false)
	local chest =  CreateObject(`v_res_mdchest`,generator.x+6.66236100,generator.y-5.40825500,generator.z+4.57736500,false,false,false)
	SetEntityHeading(chest,GetEntityHeading(chest)-90)
	FreezeEntityPosition(chest,true)
	CreateObject(`v_res_r_bublbath`,generator.x+5.07845400,generator.y-8.04203800,generator.z+5.57799900,false,false,false)
	CreateObject(`v_res_r_perfume`,generator.x+4.75592900,generator.y-8.10680400,generator.z+5.57799900,false,false,false)
	CreateObject(`v_ret_box`,generator.x+3.56020000,generator.y-3.48869900,generator.z+5.27409700,false,false,false)

	CreateObject(`V_44_G_Cor_Blen`,generator.x+4.49310600,generator.y+8.63649000,generator.z+0.24844800,false,false,false)
	CreateObject(`V_44_G_Cor_Deta`,generator.x+4.49310600,generator.y+8.63649000,generator.z+0.24844800,false,false,false)
	CreateObject(`V_44_Garage_Shell`,generator.x+0.79177808,generator.y+13.23049000,generator.z+0.24844800,false,false,false)
	local shelf = CreateObject(`V_44_1_Mast_WaShel_M`,generator.x-3.78199100,generator.y+1.73383800,generator.z+4.57161100,false,false,false)
	FreezeEntityPosition(shelf,true)



	FreezeEntityPosition(building,true)
	FreezeEntityPosition(building2,true)
end


function buildOffice()

	SetEntityCoords(PlayerPedId(),-139.53950000,-629.07570000,167.82040000)
	--Citizen.Wait(2000)
  	SetEntityCoords(PlayerPedId(),-139.53950000,-629.07570000,-58.82040000)

  	local generator = { x = -139.53950000, y =-629.07570000, z = -60.82040000} -- spawn location-
	local building = CreateObject(`ex_office_03b_shell`,generator.x+0.82022000,generator.y+1.45879100,generator.z-4.22499600,false,false,false)



	CreateObject(`ex_mp_h_acc_vase_05`,generator.x+3.83883900,generator.y-1.44630700,generator.z+0.80139000,false,false,false)
	local easyChair1 = CreateObject(`ex_mp_h_off_easychair_01`,generator.x+0.50250100,generator.y-3.06935000,generator.z-0.00704300,false,false,false)
	local easyChair2 = CreateObject(`ex_mp_h_off_easychair_01`,generator.x+0.49876200,generator.y-4.32264400,generator.z-0.00705000,false,false,false)
	SetEntityHeading(easyChair1,GetEntityHeading(easyChair1)+90)
	SetEntityHeading(easyChair2,GetEntityHeading(easyChair2)+90)
	CreateObject(`ex_mp_h_acc_bowl_ceramic_01`,generator.x+0.35230600,generator.y+3.71305300,generator.z+0.95000000,false,false,false)
	CreateObject(`ex_office_03b_skirt1`,generator.x+0.82022000,generator.y+1.45879100,generator.z+0.08499600,false,false,false)
	CreateObject(`ex_off_03b_GEOMLIGHT_Reception`,generator.x+5.59351200,generator.y+0.97565800,generator.z+3.40000800,false,false,false)
	local mon = CreateObject(`ex_prop_trailer_monitor_01`,generator.x+3.99114800,generator.y+0.66242900,generator.z+0.86899500,false,false,false)
	SetEntityHeading(mon,GetEntityHeading(mon)+90)
	CreateObject(`ex_office_03b_recdesk`,generator.x+4.05373600,generator.y-0.02752400,generator.z+0.08000000,false,false,false)
	
	CreateObject(`prop_mouse_02`,generator.x+4.37081900,generator.y+0.82507800,generator.z+0.80046800,false,false,false)
	CreateObject(`prop_off_phone_01`,generator.x+4.10196800,generator.y-0.88896700,generator.z+0.80051900,false,false,false)
	local l1 = CreateObject(`v_serv_2socket`,generator.x-2.12396500,generator.y-2.06103500,generator.z+0.30746700,false,false,false)
	local l2 =CreateObject(`v_serv_switch_3`,generator.x-2.21688300,generator.y-2.06089200,generator.z+1.49840300,false,false,false)
	local l3 =CreateObject(`v_serv_switch_3`,generator.x-2.02786100,generator.y-2.06089200,generator.z+1.49840300,false,false,false)
	SetEntityHeading(l1,GetEntityHeading(l1)+90)
	SetEntityHeading(l2,GetEntityHeading(l2)+90)
	SetEntityHeading(l3,GetEntityHeading(l3)+90)

	local alarm = CreateObject(`v_res_tre_alarmbox`,generator.x-2.74074700,generator.y-1.48556800,generator.z+1.24797900,false,false,false)
	SetEntityHeading(alarm,GetEntityHeading(alarm)+90)
	CreateObject(`ex_office_03b_EdgesRecep`,generator.x+4.60805000,generator.y-1.47149300,generator.z+0.01280200,false,false,false)
	CreateObject(`ex_office_03b_WorldMap`,generator.x+7.09353500,generator.y+5.30796300,generator.z+1.66799300,false,false,false)
	CreateObject(`ex_office_03b_Shad_Recep`,generator.x+3.65794100,generator.y-0.10437700,generator.z+0.00000000,false,false,false)
	local pow = CreateObject(`ex_office_03b_sideboardPower_003`,generator.x+0.34884700,generator.y+3.70960600,generator.z+0.10705600,false,false,false)
	SetEntityHeading(pow,GetEntityHeading(pow)-90)
	
	CreateObject(`ex_officedeskcollision`,generator.x+4.00000000,generator.y+0.00000000,generator.z-0.10000000,false,false,false)
	CreateObject(`v_res_fh_speakerdock`,generator.x+10.04326000,generator.y+10.36692000,generator.z+1.08903000,false,false,false)
	CreateObject(`ex_office_03b_WinGlass00`,generator.x+17.59416000,generator.y+13.05352000,generator.z+0.51340900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass01`,generator.x+17.59416000,generator.y+11.13831000,generator.z+0.51340900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass02`,generator.x+17.59416000,generator.y+9.22329500,generator.z+0.51340900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass03`,generator.x+17.59416000,generator.y+7.30808600,generator.z+0.51340900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass08`,generator.x+17.59421000,generator.y+4.40942000,generator.z+0.51340900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass09`,generator.x+17.59416000,generator.y-7.16629200,generator.z+0.49340900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass10`,generator.x+17.59416000,generator.y-9.13228000,generator.z+0.49340900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass11`,generator.x+17.59416000,generator.y-11.09808000,generator.z+0.49340900,false,false,false)
	CreateObject(`v_res_paperfolders`,generator.x+15.23951000,generator.y+11.01277000,generator.z+0.90960600,false,false,false)

	CreateObject(`v_res_binder`,generator.x+15.18253000,generator.y+11.43653000,generator.z+0.82427700,false,false,false)
	CreateObject(`ex_office_03b_FloorLamp0104`,generator.x+16.83519000,generator.y+14.41163000,generator.z-0.00005500,false,false,false)
	CreateObject(`ex_office_03b_LampTable_01`,generator.x+12.73544000,generator.y+10.97619000,generator.z+0.79879500,false,false,false)
	CreateObject(`ex_Office_03b_hskirt3`,generator.x+13.31318000,generator.y+1.32258700,generator.z+0.05000100,false,false,false)
	CreateObject(`ex_off_03b_GEOLIGHT_FrontOffice`,generator.x+12.77866000,generator.y-11.67066000,generator.z+3.22427500,false,false,false)
	CreateObject(`ex_office_03b_FloorLamp0103`,generator.x+10.77528000,generator.y+14.41163000,generator.z-0.00005500,false,false,false)
	local flat = CreateObject(`ex_prop_ex_tv_flat_01`,generator.x+10.48212000,generator.y-0.02673700,generator.z+1.41501200,false,false,false)
	SetEntityHeading(flat,GetEntityHeading(flat)+90)
	local telescope = CreateObject(`prop_t_telescope_01b`,generator.x+16.81530000,generator.y+7.60000000,generator.z+0.03700000,false,false,false)
	SetEntityHeading(telescope,GetEntityHeading(telescope)+180)
	local c2 = CreateObject(`v_corp_offchair`,generator.x+14.77600000,generator.y+9.43131200,generator.z+0.00000000,false,false,false)
	local c1 = CreateObject(`v_corp_offchair`,generator.x+13.07700000,generator.y+9.39931100,generator.z+0.00000000,false,false,false)
	SetEntityHeading(c2,GetEntityHeading(c2)-180)
	SetEntityHeading(c1,GetEntityHeading(c1)-180)
	local mon = CreateObject(`ex_prop_monitor_01_ex`,generator.x+13.97009000,generator.y+11.27176000,generator.z+0.86899500,false,false,false)
	SetEntityHeading(mon,GetEntityHeading(mon)-180)
	CreateObject(`prop_mouse_02`,generator.x+13.54931000,generator.y+11.64707000,generator.z+0.80050400,false,false,false)
	CreateObject(`prop_off_phone_01`,generator.x+13.14856000,generator.y+11.42315000,generator.z+0.80050400,false,false,false)
	CreateObject(`prop_bar_cockshaker`,generator.x+9.50759800,generator.y+8.39425200,generator.z+0.94999900,false,false,false)
	local spirt = CreateObject(`spiritsrow`,generator.x+9.38967800,generator.y+9.29554300,generator.z+0.94999900,false,false,false)
	SetEntityHeading(spirt,GetEntityHeading(spirt)+90)
	
	CreateObject(`ex_office_03b_desk`,generator.x+13.97011000,generator.y+11.21162000,generator.z+0.06995700,false,false,false)
	local g1 = CreateObject(`v_res_fa_plant01`,generator.x+9.40017600,generator.y+8.24227200,generator.z+1.15825100,false,false,false)
	local g2 =CreateObject(`prop_glass_stack_05`,generator.x+9.37649400,generator.y+10.12211000,generator.z+1.80909900,false,false,false)
	local g3 =CreateObject(`prop_glass_stack_02`,generator.x+9.35501000,generator.y+8.88657900,generator.z+1.81202900,false,false,false)
	local g4 =CreateObject(`prop_glass_stack_06`,generator.x+9.35501000,generator.y+9.47272600,generator.z+1.54725900,false,false,false)
	local g5 =CreateObject(`prop_glass_stack_10`,generator.x+9.35501000,generator.y+9.96296000,generator.z+1.54725900,false,false,false)
	local g6 =CreateObject(`prop_glass_stack_10`,generator.x+9.35501000,generator.y+8.95143200,generator.z+1.54725900,false,false,false)
	local g7 =CreateObject(`prop_glass_stack_01`,generator.x+9.35501000,generator.y+9.47264200,generator.z+1.81202900,false,false,false)
	local g8 =CreateObject(`prop_glass_stack_10`,generator.x+9.35501000,generator.y+9.74093600,generator.z+2.08021800,false,false,false)
	local g9 =CreateObject(`prop_glass_stack_06`,generator.x+9.35501000,generator.y+9.13371200,generator.z+2.07399200,false,false,false)
	SetEntityHeading(g1,GetEntityHeading(g1)+90)
	SetEntityHeading(g2,GetEntityHeading(g2)+90)
	SetEntityHeading(g3,GetEntityHeading(g3)+90)
	SetEntityHeading(g4,GetEntityHeading(g4)+90)
	SetEntityHeading(g5,GetEntityHeading(g5)+90)
	SetEntityHeading(g6,GetEntityHeading(g6)+90)
	SetEntityHeading(g7,GetEntityHeading(g7)+90)
	SetEntityHeading(g8,GetEntityHeading(g8)+90)
	SetEntityHeading(g9,GetEntityHeading(g9)+90)

	
	CreateObject(`ex_mp_h_acc_bowl_ceramic_01`,generator.x+10.58087000,generator.y-0.98099200,generator.z+0.73129800,false,false,false)
	local winrow = CreateObject(`winerow`,generator.x+9.41506900,generator.y+10.32958000,generator.z+0.94999900,false,false,false)
	SetEntityHeading(winrow,GetEntityHeading(winrow)+90)
	CreateObject(`prop_champ_01a`,generator.x+9.46340900,generator.y+8.61231800,generator.z+0.94999900,false,false,false)

	CreateObject(`prop_champ_jer_01a`,generator.x+9.38967800,generator.y+8.51190000,generator.z+0.94999900,false,false,false)
	CreateObject(`prop_bar_stirrers`,generator.x+9.67305700,generator.y+10.51067000,generator.z+0.94999900,false,false,false)
	CreateObject(`ex_office_03b_Boardtable`,generator.x+13.69090000,generator.y-8.69550800,generator.z+0.00030500,false,false,false)
	CreateObject(`ex_mp_h_acc_plant_palm_01`,generator.x+16.49393000,generator.y+5.80993500,generator.z+0.00000000,false,false,false)

	CreateObject(`v_serv_2socket`,generator.x+10.21870000,generator.y+12.57842000,generator.z+0.30746700,false,false,false)
	CreateObject(`prop_box_ammo07a`,generator.x+11.91324000,generator.y+14.98271000,generator.z+1.54383200,false,false,false)
	CreateObject(`prop_box_ammo01a`,generator.x+12.08518000,generator.y+14.95856000,generator.z+1.54383200,false,false,false)
	CreateObject(`prop_box_ammo01a`,generator.x+12.20990000,generator.y+14.93168000,generator.z+1.54383200,false,false,false)
	CreateObject(`prop_box_ammo02a`,generator.x+12.01649000,generator.y+14.95856000,generator.z+1.18664200,false,false,false)
	CreateObject(`prop_box_guncase_02a`,generator.x+12.30792000,generator.y+14.77875000,generator.z+0.33298800,false,false,false)
	CreateObject(`Prop_Drop_ArmsCrate_01b`,generator.x+12.31815000,generator.y+14.97308000,generator.z+0.39096400,false,false,false)
	CreateObject(`prop_box_ammo07b`,generator.x+11.70625000,generator.y+14.89851000,generator.z+1.54383200,false,false,false)
	CreateObject(`prop_box_guncase_01a`,generator.x+12.31427000,generator.y+14.97308000,generator.z+0.94427500,false,false,false)
	CreateObject(`prop_box_ammo07a`,generator.x+11.51516000,generator.y+15.02956000,generator.z+1.54383200,false,false,false)
	CreateObject(`prop_box_ammo01a`,generator.x+12.46920000,generator.y+14.96635000,generator.z+1.54383200,false,false,false)
	CreateObject(`prop_box_ammo01a`,generator.x+12.34637000,generator.y+14.96635000,generator.z+1.54383200,false,false,false)

	CreateObject(`Prop_Drop_ArmsCrate_01b`,generator.x+12.31815000,generator.y+14.97308000,generator.z+0.75934600,false,false,false)
	CreateObject(`ex_office_03b_StripLamps`,generator.x+13.13106000,generator.y+11.69762000,generator.z+0.80118800,false,false,false)
	CreateObject(`prop_box_ammo02a`,generator.x+12.43525000,generator.y+14.95856000,generator.z+1.18664200,false,false,false)
	CreateObject(`prop_box_ammo02a`,generator.x+11.73945000,generator.y+14.92581000,generator.z+1.18664200,false,false,false)
	CreateObject(`prop_box_ammo02a`,generator.x+11.54390000,generator.y+14.92581000,generator.z+1.18664200,false,false,false)
	local safe = CreateObject(`ex_office_03b_Safes`,generator.x+10.49555000,generator.y+0.00422400,generator.z+0.00000000,false,false,false)
	SetEntityHeading(safe,GetEntityHeading(safe)-90)
	--CreateObject(`ex_prop_safedoor_office3a_l`,generator.x+11.41656000,generator.y+14.50558000,generator.z+1.05049900,false,false,false)
	CreateObject(`ex_office_03b_Edges_Main`,generator.x+13.61647000,generator.y+1.94954700,generator.z+0.01285300,false,false,false)
	--CreateObject(`ex_prop_safedoor_office3a_r`,generator.x+16.25136000,generator.y+14.50558000,generator.z+1.05049900,false,false,false)
	CreateObject(`ex_office_03b_FloorLamp0105`,generator.x+17.09381000,generator.y-11.74412000,generator.z-0.00005500,false,false,false)
	CreateObject(`ex_office_03b_FloorLamp0101`,generator.x+10.29999000,generator.y-11.74412000,generator.z-0.00005500,false,false,false)
	CreateObject(`ex_office_03b_tvtable`,generator.x+13.80864000,generator.y-0.14030900,generator.z-0.01227000,false,false,false)
	
	CreateObject(`ex_office_03b_MetalShelf`,generator.x+9.22459100,generator.y+9.78214800,generator.z+1.50955900,false,false,false)
	CreateObject(`ex_office_03b_Shad_Main`,generator.x+13.86071000,generator.y+0.08125000,generator.z+0.00000000,false,false,false)
	CreateObject(`ex_office_03b_TVUnit`,generator.x+10.57312000,generator.y-0.03527800,generator.z+0.00000000,false,false,false)
	CreateObject(`ex_mp_h_acc_vase_05`,generator.x+16.99567000,generator.y-5.02271800,generator.z+0.92395100,false,false,false)
	CreateObject(`ex_mp_h_acc_scent_sticks_01`,generator.x+10.47731000,generator.y-1.23041900,generator.z+0.73129800,false,false,false)
	local wframe =  CreateObject(`ex_office_03b_wFrame003`,generator.x+12.31777000,generator.y-5.44320100,generator.z+0.10772200,false,false,false)
	SetEntityHeading(wframe,GetEntityHeading(wframe)-90)
	
	CreateObject(`ex_office_03b_SoundBaffles1`,generator.x+14.50548000,generator.y-0.94601400,generator.z+3.39024900,false,false,false)
	local sc1 = CreateObject(`ex_Office_03b_stripChair1`,generator.x+12.03766000,generator.y+2.14166100,generator.z+0.00000000,false,false,false)
	local sc2 = CreateObject(`ex_Office_03b_stripChair2`,generator.x+11.96429000,generator.y-2.23546000,generator.z+0.00000000,false,false,false)
	local window =CreateObject(`ex_prop_office_louvres`,generator.x+18.06730000,generator.y-0.23932300,generator.z+0.10772200,false,false,false)
	local sc3 = CreateObject(`ex_mp_h_off_sofa_02`,generator.x+15.66240000,generator.y+0.03326700,generator.z+0.00000000,false,false,false)
	SetEntityHeading(window,GetEntityHeading(window)+90)
	SetEntityHeading(sc1,GetEntityHeading(sc1)+70)
	SetEntityHeading(sc2,GetEntityHeading(sc2)+110)
	SetEntityHeading(sc3,GetEntityHeading(sc3)-90)
	
	CreateObject(`ex_office_03b_GlassPane2`,generator.x+11.06012000,generator.y-5.40525200,generator.z+0.22725900,false,false,false)
	CreateObject(`ex_office_03b_GlassPane004`,generator.x+16.32030000,generator.y-5.41362200,generator.z+0.22725900,false,false,false)
	CreateObject(`ex_office_03b_GlassPane003`,generator.x+11.06012000,generator.y-5.41357300,generator.z+0.22725900,false,false,false)
	CreateObject(`ex_office_03b_GlassPane1`,generator.x+16.32030000,generator.y-5.40530200,generator.z+0.22725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass020`,generator.x+17.59421000,generator.y-2.51997600,generator.z+0.50725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass019`,generator.x+17.59421000,generator.y-4.25111800,generator.z+0.50725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass022`,generator.x+17.59421000,generator.y+0.94213700,generator.z+0.50725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass023`,generator.x+17.59421000,generator.y+2.67310600,generator.z+0.50725900,false,false,false)
	CreateObject(`ex_office_03b_WinGlass021`,generator.x+17.59421000,generator.y-0.78900700,generator.z+0.50725900,false,false,false)
	
	CreateObject(`ex_office_03b_sideboardPower_1`,generator.x+16.32105000,generator.y-5.01578000,generator.z+0.10705600,false,false,false)
	CreateObject(`ex_office_citymodel_01`,generator.x+13.74981000,generator.y-8.72368000,generator.z+0.80427800,false,false,false)
	CreateObject(`ex_prop_tv_settop_remote`,generator.x+10.71205000,generator.y+0.19141700,generator.z+0.47649700,false,false,false)
	CreateObject(`ex_prop_tv_settop_box`,generator.x+10.69669000,generator.y-0.02768300,generator.z+0.48917300,false,false,false)
	local iw1 = CreateObject(`ex_office_03b_WinGlass014`,generator.x+6.15745700,generator.y-5.41205300,generator.z+0.17772200,false,false,false)
	local iw2 = CreateObject(`ex_office_03b_WinGlass015`,generator.x+8.12344600,generator.y-5.41205300,generator.z+0.17772200,false,false,false)
	local iw3 = CreateObject(`ex_office_03b_WinGlass013`,generator.x+4.19166100,generator.y-5.41205300,generator.z+0.17772200,false,false,false)
	local frame2 = CreateObject(`ex_office_03b_wFrame2`,generator.x+6.14261300,generator.y-5.40933400,generator.z+0.00772200,false,false,false)
	SetEntityHeading(frame2,GetEntityHeading(frame2)-90)
	SetEntityHeading(iw1,GetEntityHeading(iw1)-90)
	SetEntityHeading(iw2,GetEntityHeading(iw2)-90)
	SetEntityHeading(iw3,GetEntityHeading(iw3)-90)
	
	CreateObject(`prop_printer_02`,generator.x+4.44948700,generator.y-5.72865900,generator.z+0.80441900,false,false,false)
	CreateObject(`prop_kettle`,generator.x+4.13300000,generator.y-11.87105000,generator.z+0.95783400,false,false,false)
	local micro = CreateObject(`prop_micro_02`,generator.x+3.64373400,generator.y-11.82465000,generator.z+1.09977400,false,false,false)
	local sink = CreateObject(`ex_office_03b_kitchen`,generator.x+4.23552100,generator.y-11.73340000,generator.z+0.06602100,false,false,false)
	local cm = CreateObject(`ex_mp_h_acc_coffeemachine_01`,generator.x+4.93680700,generator.y-11.69780000,generator.z+0.95783400,false,false,false)
	CreateObject(`ex_office_03b_skirt2`,generator.x+4.10593700,generator.y-8.57737300,generator.z+0.04999800,false,false,false)
	CreateObject(`ex_off_03b_GEOMLIGHT_WaitingArea`,generator.x+3.34384900,generator.y-10.12492000,generator.z+3.40000800,false,false,false)
	CreateObject(`ex_p_h_acc_artwallm_01`,generator.x+1.01400200,generator.y-11.41125000,generator.z+2.19531300,false,false,false)
	CreateObject(`ex_mp_h_tab_sidelrg_07`,generator.x-0.76488900,generator.y-10.34824000,generator.z-0.01339100,false,false,false)
	CreateObject(`prop_glass_stack_02`,generator.x-0.96651900,generator.y-10.26981000,generator.z+0.43167700,false,false,false)
	CreateObject(`ex_mp_h_acc_bottle_01`,generator.x-0.98562300,generator.y-10.59739000,generator.z+0.43070100,false,false,false)
	SetEntityHeading(sink,GetEntityHeading(sink)-90)
	SetEntityHeading(micro,GetEntityHeading(micro)-180)
	SetEntityHeading(cm,GetEntityHeading(cm)-180)
	
	CreateObject(`v_res_fashmag1`,generator.x-0.62925100,generator.y-6.73683400,generator.z+0.42972400,false,false,false)
	CreateObject(`v_res_fashmagopen`,generator.x+0.96242300,generator.y-8.98048600,generator.z+0.45161400,false,false,false)
	CreateObject(`v_res_r_silvrtray`,generator.x-0.93600100,generator.y-10.36643000,generator.z+0.43167700,false,false,false)
	CreateObject(`ex_mp_h_tab_sidelrg_07`,generator.x-0.76488900,generator.y-6.54443400,generator.z-0.01339100,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x+5.17286500,generator.y-9.76032300,generator.z+1.49840300,false,false,false)
	CreateObject(`v_serv_2socket`,generator.x+5.17288600,generator.y-9.76032300,generator.z+0.30746700,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x+3.34560200,generator.y-6.32599200,generator.z+1.49840300,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x+3.34560200,generator.y-6.13697000,generator.z+1.49840300,false,false,false)
	CreateObject(`v_serv_2socket`,generator.x+3.34574400,generator.y-6.23307400,generator.z+0.30746700,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x+4.03587600,generator.y-6.92667400,generator.z+1.49840300,false,false,false)

	local edges4 = CreateObject(`ex_office_03b_EdgesWait`,generator.x+9.14111600,generator.y-5.90339900,generator.z+0.00000400,false,false,false)
	SetEntityHeading(edges4,GetEntityHeading(edges4)-90)
	CreateObject(`ex_office_03b_FloorLamp0102`,generator.x-0.76488900,generator.y-11.02532000,generator.z+0.01312800,false,false,false)
	local gdesk = CreateObject(`ex_office_03b_desk004`,generator.x+1.10171100,generator.y-8.50667800,generator.z+0.03023800,false,false,false)
	SetEntityHeading(gdesk,GetEntityHeading(gdesk)+90)
	local iw4 = CreateObject(`ex_office_03b_WinGlass018`,generator.x+5.07940000,generator.y-5.42724400,generator.z+0.17772200,false,false,false)
	local iw5 =CreateObject(`ex_office_03b_WinGlass017`,generator.x+7.04538900,generator.y-5.42724400,generator.z+0.17772200,false,false,false)
	local iw6 =CreateObject(`ex_office_03b_WinGlass016`,generator.x+9.01118500,generator.y-5.42724400,generator.z+0.17772200,false,false,false)
	SetEntityHeading(iw4,GetEntityHeading(iw4)+90)
	SetEntityHeading(iw5,GetEntityHeading(iw5)+90)
	SetEntityHeading(iw6,GetEntityHeading(iw6)+90)
	CreateObject(`ex_office_03b_StripLamps_kitchen`,generator.x+4.25069000,generator.y-11.88272000,generator.z+1.67102200,false,false,false)
	local sof = CreateObject(`ex_mp_h_off_sofa_003`,generator.x-0.76884700,generator.y-8.46005400,generator.z+0.00000000,false,false,false)
	SetEntityHeading(sof,GetEntityHeading(sof)+90)
	local armChair = CreateObject(`ex_Office_03b_WaitRmChairs`,generator.x+1.84398500,generator.y-10.90230000,generator.z+0.00000000,false,false,false)
	SetEntityHeading(armChair,GetEntityHeading(armChair)+180)
	CreateObject(`prop_laptop_01a`,generator.x+6.83454500,generator.y-5.95000000,generator.z+0.80231100,false,false,false)
	CreateObject(`prop_laptop_01a`,generator.x+8.33620700,generator.y-5.95000000,generator.z+0.80231100,false,false,false)
	CreateObject(`prop_laptop_01a`,generator.x+5.30988200,generator.y-5.95000000,generator.z+0.80231100,false,false,false)
	
	CreateObject(`ex_office_03b_skirt4`,generator.x+5.87873900,generator.y+9.78554600,generator.z+0.04999900,false,false,false)
	CreateObject(`ex_office_03b_GEOMLIGHT_Bathroom`,generator.x+5.14397000,generator.y+8.93845400,generator.z+2.91470400,false,false,false)
	CreateObject(`v_serv_bs_foam1`,generator.x+9.68656100,generator.y+13.41801000,generator.z+0.93879600,false,false,false)
	CreateObject(`v_res_mlaundry`,generator.x+1.71013600,generator.y+7.30080300,generator.z+0.00000000,false,false,false)
	CreateObject(`v_res_fh_towelstack`,generator.x+8.67294200,generator.y+5.77780000,generator.z+0.76876200,false,false,false)
	CreateObject(`v_res_fh_towelstack`,generator.x+7.91499300,generator.y+5.81820500,generator.z+0.21617000,false,false,false)
	CreateObject(`v_res_fh_towelstack`,generator.x+8.71047600,generator.y+5.81699000,generator.z+0.21617000,false,false,false)

	CreateObject(`v_ret_ps_cologne`,generator.x+9.47080200,generator.y+12.13796000,generator.z+0.79701900,false,false,false)
	CreateObject(`ex_office_03b_LampTable_02`,generator.x+9.69349400,generator.y+11.74564000,generator.z+0.80134400,false,false,false)
	CreateObject(`ex_mp_h_acc_candles_01`,generator.x+8.90054500,generator.y+9.01688700,generator.z+0.94888600,false,false,false)
	CreateObject(`ex_mp_h_acc_candles_04`,generator.x+8.88957000,generator.y+8.72137000,generator.z+0.94888600,false,false,false)
	CreateObject(`ex_prop_offchair_exec_03`,generator.x+8.55600000,generator.y+13.13900000,generator.z+0.10198100,false,false,false)
	CreateObject(`ex_mp_h_acc_vase_05`,generator.x+10.03610000,generator.y+11.24539000,generator.z+0.80134400,false,false,false)
	CreateObject(`ex_mp_h_acc_scent_sticks_01`,generator.x+9.00073400,generator.y+8.85563500,generator.z+0.94888600,false,false,false)
	CreateObject(`v_serv_bs_gel`,generator.x+9.45322400,generator.y+13.29018000,generator.z+0.83455500,false,false,false)

	CreateObject(`ex_office_03b_FloorLamp01`,generator.x+2.87563600,generator.y+13.78156000,generator.z-0.00005500,false,false,false)
	local gshelf = CreateObject(`ex_office_03b_GlassShelves2`,generator.x+10.06959000,generator.y+12.40041000,generator.z+0.75042600,false,false,false)
	CreateObject(`ex_mp_h_acc_scent_sticks_01`,generator.x+10.10841000,generator.y+11.46752000,generator.z+0.80134400,false,false,false)
	CreateObject(`v_serv_tc_bin3_`,generator.x+9.63415500,generator.y+13.87192000,generator.z+0.25574800,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x+1.51790700,generator.y+6.78857800,generator.z+1.49840300,false,false,false)
	CreateObject(`v_serv_2socket`,generator.x+1.51944800,generator.y+6.78857800,generator.z+0.30746700,false,false,false)
	CreateObject(`v_serv_2socket`,generator.x+2.51535200,generator.y+12.63103000,generator.z+0.30746700,false,false,false)
	CreateObject(`v_serv_switch_3`,generator.x+2.51381100,generator.y+12.63103000,generator.z+1.49840300,false,false,false)
	CreateObject(`ex_office_03b_Edges_Chng`,generator.x+4.58213600,generator.y+10.05374000,generator.z+0.00000400,false,false,false)
	CreateObject(`v_club_brush`,generator.x+9.45322400,generator.y+13.54335000,generator.z+0.79894100,false,false,false)
	CreateObject(`ex_prop_exec_bed_01`,generator.x+5.50940000,generator.y+13.10000000,generator.z-0.00000300,false,false,false)
	CreateObject(`ex_office_03b_Shad_Bath`,generator.x+5.59655300,generator.y+12.34816000,generator.z+0.00000000,false,false,false)
	local art = CreateObject(`ex_Office_03b_bathroomArt`,generator.x+10.19056000,generator.y+12.57837000,generator.z+1.66302500,false,false,false)
	local power4 = CreateObject(`ex_office_03b_sideboardPower_004`,generator.x+8.81734200,generator.y+9.50928800,generator.z+0.10705600,false,false,false)
	SetEntityHeading(art,GetEntityHeading(art)-90)
	SetEntityHeading(gshelf,GetEntityHeading(gshelf)-180)
	SetEntityHeading(power4,GetEntityHeading(power4)+90)
	
	local plate = CreateObject(`ex_mp_h_acc_dec_plate_01`,generator.x-16.45605000,generator.y-0.05843100,generator.z+1.00123400,false,false,false)
	local art3 = CreateObject(`ex_p_h_acc_artwallm_03`,generator.x-16.69037000,generator.y-0.05843100,generator.z+1.76771000,false,false,false)
	local table0 = CreateObject(`ex_prop_ex_console_table_01`,generator.x-16.33744000,generator.y-0.05843100,generator.z+0.00000000,false,false,false)
	SetEntityHeading(art3,GetEntityHeading(art3)+90)
	SetEntityHeading(plate,GetEntityHeading(plate)+90)
	SetEntityHeading(table0,GetEntityHeading(table0)+90)

	
	CreateObject(`ex_office_03b_LIGHT_Foyer`,generator.x-3.82964100,generator.y+0.02804200,generator.z+3.10086700,false,false,false)
	CreateObject(`ex_office_03b_normalonly1`,generator.x-8.42918000,generator.y-0.02619600,generator.z+0.71280200,false,false,false)
	CreateObject(`ex_office_03b_foyerdetail`,generator.x-9.78775400,generator.y-0.02673700,generator.z+0.09000000,false,false,false)
	CreateObject(`ex_Office_03b_numbers`,generator.x-9.93670100,generator.y-0.02917200,generator.z+2.40085100,false,false,false)
	local detail = CreateObject(`ex_office_03b_elevators`,generator.x+10.49555000,generator.y+0.00422400,generator.z+0.08000000,false,false,false)
	CreateObject(`ex_office_03b_CARPETS`,generator.x+8.07606700,generator.y+1.32258800,generator.z+0.00198900,false,false,false)
	CreateObject(`ex_office_03b_Shower`,generator.x+0.34558600,generator.y+6.88265700,generator.z-0.06255700,false,false,false)
	CreateObject(`ex_p_mp_h_showerdoor_s`,generator.x-0.59146200,generator.y+7.00626500,generator.z+1.20006700,false,false,false)
	SetEntityHeading(detail,GetEntityHeading(detail)-90)
	

	CreateObject(`ex_p_mp_door_apart_doorbrown_s`,generator.x+1.44672400,generator.y+8.81843100,generator.z+1.24813200,false,false,false)
	CreateObject(`ex_Office_03b_Proxy_CeilingLight`,generator.x+3.33397300,generator.y-0.02675400,generator.z+3.68248700,false,false,false)
	CreateObject(`ex_Office_03b_ToiletSkirting`,generator.x+1.13302800,generator.y+11.37978000,generator.z+0.05000000,false,false,false)
	CreateObject(`ex_Office_03b_Toilet`,generator.x+1.08040800,generator.y+12.24717000,generator.z+0.48479800,false,false,false)

	CreateObject(`ex_Office_03b_ToiletArt`,generator.x+1.13303000,generator.y+12.73267000,generator.z+1.33258700,false,false,false)
	CreateObject(`prop_toilet_roll_02`,generator.x+0.56858000,generator.y+12.57573000,generator.z+0.58252000,false,false,false)
	CreateObject(`v_res_mlaundry`,generator.x+0.03584800,generator.y+12.02357000,generator.z+0.00000000,false,false,false)
	CreateObject(`prop_towel_rail_02`,generator.x-0.12948900,generator.y+11.68217000,generator.z+0.70703100,false,false,false)
	CreateObject(`v_res_tre_washbasket`,generator.x+2.09027800,generator.y+10.48882000,generator.z+0.00000000,false,false,false)
	CreateObject(`ex_office_03b_sinks001`,generator.x+0.28737900,generator.y+11.64389000,generator.z+1.19806000,false,false,false)
	CreateObject(`ex_Office_03b_ToiletTaps`,generator.x+0.01130900,generator.y+11.10180000,generator.z+1.01921500,false,false,false)
	CreateObject(`ex_office_03b_GEOMLIGHT_Toilet`,generator.x+0.38847900,generator.y+11.50150000,generator.z+2.69625500,false,false,false)
	CreateObject(`ex_p_mp_door_apart_doorbrown01`,generator.x+2.47054500,generator.y+10.99843000,generator.z+1.15000000,false,false,false)
	CreateObject(`P_CS_Lighter_01`,generator.x+14.20325000,generator.y+10.73750000,generator.z+0.80564200,false,false,false)
	CreateObject(`P_CS_Lighter_01`,generator.x+14.08056000,generator.y+0.25372600,generator.z+0.45519900,false,false,false)
	CreateObject(`prop_beer_stzopen`,generator.x+8.70215000,generator.y-5.71030500,generator.z+0.80369400,false,false,false)
	CreateObject(`ex_office_03b_room_blocker`,generator.x+6.21348800,generator.y+6.43969200,generator.z-0.29498500,false,false,false)

	

	CreateObject(`ex_prop_offchair_exec_01`,generator.x+14.25161000,generator.y+12.47272000,generator.z+0.02015500,false,false,false)

	local chair4 = CreateObject(`ex_prop_offchair_exec_02`,generator.x+16.08929000,generator.y-8.70579200,generator.z+0.09623700,false,false,false)
	local chair5 = CreateObject(`ex_prop_offchair_exec_02`,generator.x+5.29666500,generator.y-6.65300000,generator.z+0.09600000,false,false,false)
	local chair6 = CreateObject(`ex_prop_offchair_exec_02`,generator.x+6.82119500,generator.y-6.65300000,generator.z+0.09600000,false,false,false)
	local chair7 = CreateObject(`ex_prop_offchair_exec_02`,generator.x+8.34572400,generator.y-6.65300000,generator.z+0.09600000,false,false,false)

	local chair1 = CreateObject(`ex_prop_offchair_exec_02`,generator.x+14.92358000,generator.y-9.81548700,generator.z+0.09623700,false,false,false)
	local chair2 = CreateObject(`ex_prop_offchair_exec_02`,generator.x+13.73376000,generator.y-9.81548700,generator.z+0.09623700,false,false,false)
	local chair3 = CreateObject(`ex_prop_offchair_exec_02`,generator.x+12.53418000,generator.y-9.81548700,generator.z+0.09623700,false,false,false)
	CreateObject(`ex_prop_offchair_exec_02`,generator.x+12.56676000,generator.y-7.66744700,generator.z+0.09623700,false,false,false)
	CreateObject(`ex_prop_offchair_exec_02`,generator.x+13.73958000,generator.y-7.66744700,generator.z+0.09623700,false,false,false)
	CreateObject(`ex_prop_offchair_exec_02`,generator.x+14.95615000,generator.y-7.66744700,generator.z+0.09623700,false,false,false)


	SetEntityHeading(chair1,GetEntityHeading(chair1)+180)
	SetEntityHeading(chair2,GetEntityHeading(chair2)+180)
	SetEntityHeading(chair3,GetEntityHeading(chair3)+180)
	SetEntityHeading(chair4,GetEntityHeading(chair4)-90)
	SetEntityHeading(chair5,GetEntityHeading(chair5)+180)
	SetEntityHeading(chair6,GetEntityHeading(chair6)+180)
	SetEntityHeading(chair7,GetEntityHeading(chair7)+180)
	FreezeEntityPosition(building,true)
  	
end



isJudge = true
RegisterNetEvent("isJudge")
AddEventHandler("isJudge", function()
    isJudge = true
end)
RegisterNetEvent("isJudgeOff")
AddEventHandler("isJudgeOff", function()
    isJudge = false
end)



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

function logout()
    TransitionToBlurred(500)
    DoScreenFadeOut(500)
    Citizen.Wait(1000)
    CleanUpArea()
	Citizen.Wait(1000)
	myRoomType = 0   
	TriggerEvent('inhotel', false)
	TriggerEvent("wrp-base:clearStates")
	TriggerServerEvent('hotel:clearStates', exports['isPed']:isPed('cid'))
    exports["wrp-base"]:getModule("SpawnManager"):Initialize()

	Citizen.Wait(1000)
end

local canInteract = true

RegisterNetEvent('hotel:interactState')
AddEventHandler('hotel:interactState', function(state)
	canInteract = state
end)


RegisterNetEvent('newRoomType')
AddEventHandler('newRoomType', function(newRoomType)
	myRoomType = newRoomType
	TriggerEvent("hotel:myroomtype",myRoomType)
end)

local comparedst = 1000
function smallestDist(typeCheck)
	if typeCheck < comparedst then
		comparedst = typeCheck
	end
end

Controlkey = {
	["generalUse"] = {38,"E"},
	["housingMain"] = {74,"H"},
	["housingSecondary"] = {47,"G"}
} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["generalUse"] = table["generalUse"]
	Controlkey["housingMain"] = table["housingMain"]
	Controlkey["housingSecondary"] = table["housingSecondary"]

	if Controlkey["housingSecondary"] == nil or Controlkey["housingMain"] == nil or Controlkey["generalUse"] == nil then
		Controlkey = {["generalUse"] = {38,"E"},["housingMain"] = {74,"H"},["housingSecondary"] = {47,"G"}} 
	end
end)

RegisterNetEvent('character:isNew')
AddEventHandler('character:isNew', function(isNew)
	isnew = isNew
end)

Citizen.CreateThread(function()

 	while true do
		Citizen.Wait(0)

		comparedst = 1000

		local plyId = PlayerPedId()
		local plyCoords = GetEntityCoords(plyId)


		local entryUpgradesDst = #(vector3(-552.26, -193.66, 38.21) - plyCoords)
		-- local entry6th = #(vector3(apartments1[65]["x"],apartments1[65]["y"],apartments1[65]["z"]) - plyCoords)
		-- local entry5rd = #(vector3(apartments1[50]["x"],apartments1[50]["y"],apartments1[50]["z"]) - plyCoords)
		local entry4rd = #(vector3(apartments1[4]["x"],apartments1[4]["y"],apartments1[4]["z"]) -  plyCoords)
		local entry3rd = #(vector3(apartments1[3]["x"],apartments1[3]["y"],apartments1[3]["z"]) - plyCoords)
		local entry2nd = #(vector3(269.8034, -632.2916, 42.0198) - plyCoords)
		local entry1st = #(vector3(apartments1[1]["x"],apartments1[1]["y"],apartments1[1]["z"]) - plyCoords)
		local payTicketsDst = #(vector3(235.91, -416.43, -118.16) - plyCoords)

		smallestDist(payTicketsDst)
		smallestDist(entryUpgradesDst)
		-- smallestDist(entry6th)
		-- smallestDist(entry5rd)
		smallestDist(entry4rd)
		smallestDist(entry3rd)
		smallestDist(entry2nd)
		smallestDist(entry1st)

		if insideApartment or comparedst < 100 then

			if payTicketsDst < 5.0 then
				if payTicketsDst < 1.0 then
					DrawText3Ds(235.91, -416.43, -118.16, "Public Records")
					if IsControlJustReleased(1,Controlkey["generalUse"][1]) then
						TriggerEvent("phone:publicrecords")
						Citizen.Wait(2500)
					end	
				end

				if #(vector3(236.51, -414.43, -118.16) - plyCoords) < 1.0 then
					DrawText3Ds(236.51, -414.43, -118.16, "Property Records")
					if IsControlJustReleased(1, Controlkey["generalUse"][1]) then
						TriggerServerEvent("houses:PropertyListing")
						Citizen.Wait(2500)
					end	
				end

			end


			if entryUpgradesDst < 1.0 then
				DrawText3Ds(-552.26, -193.66, 38.21, "~g~"..Controlkey["generalUse"][2].."~s~ Upgrade Housing (25k for tier 2.)")
				if IsControlJustReleased(1,Controlkey["generalUse"][1]) then
					TriggerEvent("hotel:AttemptUpgrade")
					Citizen.Wait(2500)
				end		
			end

			if (entry4rd < 5 and myRoomType == 3) or (entry3rd < 5 and myRoomType == 3) or (entry1st < 35.0 and myRoomType == 1) or (entry2nd < 5 and myRoomType == 2) then
				if myRoomType == 1 then
					local myappdist = #(vector3(apartments1[myRoomNumber]["x"],apartments1[myRoomNumber]["y"],apartments1[myRoomNumber]["z"]) - plyCoords)
					if myappdist < 15.0 then
						DrawMarker(20,apartments1[myRoomNumber]["x"],apartments1[myRoomNumber]["y"],apartments1[myRoomNumber]["z"], 0, 0, 0, 0, 0, 0, 0.701,1.0001,0.3001, 0, 155, 255, 200, 0, 0, 0, 0)
						if myappdist < 3.0 then
							if myRoomLock then
								DrawText3Ds(apartments1[myRoomNumber]["x"],apartments1[myRoomNumber]["y"],apartments1[myRoomNumber]["z"], "~g~"..Controlkey["housingMain"][2].."~s~ to enter ~g~"..Controlkey["housingSecondary"][2].."~s~ to unlock (" .. myRoomNumber .. ")")
							else
								DrawText3Ds(apartments1[myRoomNumber]["x"],apartments1[myRoomNumber]["y"],apartments1[myRoomNumber]["z"], "~g~H~s~ to enter ~g~G~s~ to lock (" .. myRoomNumber .. ")")
							end
						end
					end
				end

				
				if myRoomType == 2 then
					DrawMarker(27,269.8034, -632.2916, 41.1198, 0, 0, 0, 0, 0, 0, 7.001, 7.0001, 0.3001, 0, 155, 255, 200, 0, 0, 0, 0)
					if myRoomLock then
						DrawText3Ds(269.8034, -632.2916, 41.1198, "~g~"..Controlkey["housingMain"][2].."~s~ to enter ~g~"..Controlkey["housingSecondary"][2].."~s~ to unlock (" .. myRoomNumber .. ")")
					else
						DrawText3Ds(269.8034, -632.2916, 41.1198, "~g~"..Controlkey["housingMain"][2].."~s~ to enter ~g~"..Controlkey["housingSecondary"][2].."~s~ to lock (" .. myRoomNumber .. ")")
					end
				end

				if myRoomType == 3 then
					if entry4rd < 5 then
						DrawMarker(27,apartments1[4]["x"],apartments1[4]["y"],apartments1[4]["z"], 0, 0, 0, 0, 0, 0, 7.001, 7.0001, 0.3001, 0, 155, 255, 200, 0, 0, 0, 0)
						if myRoomLock then
							DrawText3Ds(apartments1[4]["x"],apartments1[4]["y"],apartments1[4]["z"], "~g~"..Controlkey["housingMain"][2].."~s~ to enter ~g~"..Controlkey["housingSecondary"][2].."~s~ to unlock (" .. myRoomNumber .. ")")
						else
							DrawText3Ds(apartments1[4]["x"],apartments1[4]["y"],apartments1[4]["z"], "~g~"..Controlkey["housingMain"][2].."~s~ to enter ~g~"..Controlkey["housingSecondary"][2].."~s~ to lock (" .. myRoomNumber .. ")")
						end
					else
						DrawMarker(27,apartments1[3]["x"],apartments1[3]["y"],apartments1[3]["z"], 0, 0, 0, 0, 0, 0, 7.001, 7.0001, 0.3001, 0, 155, 255, 200, 0, 0, 0, 0)
						if myRoomLock then
							DrawText3Ds(apartments1[3]["x"],apartments1[3]["y"],apartments1[3]["z"], "~g~"..Controlkey["housingMain"][2].."~s~ to enter ~g~"..Controlkey["housingSecondary"][2].."~s~ to unlock (" .. myRoomNumber .. ")")
						else
							DrawText3Ds(apartments1[3]["x"],apartments1[3]["y"],apartments1[3]["z"], "~g~"..Controlkey["housingMain"][2].."~s~ to enter ~g~"..Controlkey["housingSecondary"][2].."~s~ to lock (" .. myRoomNumber .. ")")
						end
					end

				end

				if IsControlJustReleased(1,Controlkey["housingSecondary"][1]) then
					if #(vector3(apartments1[myRoomNumber]["x"],apartments1[myRoomNumber]["y"],apartments1[myRoomNumber]["z"]) - plyCoords) < 5 and myRoomType == 1 then	
						TriggerEvent("dooranim")
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'keydoors', 0.4)
						if myRoomLock then
							TriggerServerEvent("hotel:updatelocks", false)
						else
							TriggerServerEvent("hotel:updatelocks", true)
						end
						Citizen.Wait(500)
					elseif myRoomType ~= 1 then
						TriggerEvent("dooranim")
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'keydoors', 0.4)
						if myRoomLock then
							TriggerServerEvent("hotel:updatelocks", false)
						else
							TriggerServerEvent("hotel:updatelocks", true)
						end
						Citizen.Wait(500)
					end
				end


				if IsControlJustReleased(1,Controlkey["housingMain"][1]) then
					TriggerEvent("DoLongHudText","Please wait!",1)
					TriggerEvent("dooranim")
					Citizen.Wait(300)
					TriggerEvent("dooranim")
					TriggerEvent('InteractSound_CL:PlayOnOne','DoorOpen', 0.7)

					if #(vector3(269.8034, -632.2916, 42.0198) - plyCoords) < 5 and myRoomType == 2 then	
						processBuildType(myRoomNumber,myRoomType)
						TriggerServerEvent("hotel:getInfo")
						Citizen.Wait(500)
					elseif (#(vector3(apartments1[4]["x"],apartments1[4]["y"],apartments1[4]["z"]) - plyCoords) < 5 and myRoomType == 3) or entry4rd < 5 then
						processBuildType(myRoomNumber,myRoomType)
						TriggerServerEvent("hotel:getInfo")
						Citizen.Wait(500)					
					elseif #(vector3(apartments1[3]["x"],apartments1[3]["y"],apartments1[3]["z"]) - plyCoords) < 5 and myRoomType == 2 then
						processBuildType(myRoomNumber,myRoomType)
						TriggerServerEvent("hotel:getInfo")
						Citizen.Wait(500)
					else
						TriggerEvent("DoLongHudText","Moved too far away!",2)
					end			
				end
			end

			if #(vector3(myroomcoords.x-2, myroomcoords.y + 2.5, myroomcoords.z) - plyCoords) < 1.5 and curRoomType == 1 then
				DrawText3Ds(myroomcoords.x-2, myroomcoords.y + 2.5, myroomcoords.z+1.5, '~g~'..Controlkey["housingSecondary"][2]..'~s~ to swap char or /outfits.')
				if IsControlJustReleased(1,Controlkey["housingSecondary"][1]) then
					logout()
				end
			elseif #(vector3(myroomcoords.x+8, myroomcoords.y + 4, myroomcoords.z+0.4) - plyCoords) < 5.5 and curRoomType == 2 then
				DrawText3Ds(myroomcoords.x+8, myroomcoords.y + 4, myroomcoords.z+2.4, '~g~'..Controlkey["housingSecondary"][2]..'~s~ to swap char or /outfits.')
				if IsControlJustReleased(1, Controlkey["housingSecondary"][1]) then
					logout()
				end
			elseif #(vector3(myroomcoords.x + 6, myroomcoords.y + 6, myroomcoords.z) - plyCoords) < 2.5 and curRoomType == 3 then
				DrawText3Ds(myroomcoords.x + 6, myroomcoords.y + 6, myroomcoords.z+1.5, '~g~'..Controlkey["housingSecondary"][2]..'~s~ to swap char or /outfits.')
				if IsControlJustReleased(1, Controlkey["housingSecondary"][1]) then
					logout()
				end
			end	
			if 	(#(vector3(myroomcoords.x - 14.3, myroomcoords.y - 02.00, myroomcoords.z + 7.02) - plyCoords) < 3.0 and curRoomType == 3) or 
				(#(vector3(myroomcoords.x + 4.30, myroomcoords.y - 15.95, myroomcoords.z + 0.42) - plyCoords) < 3.0 and curRoomType == 2) or 
				(#(vector3(myroomcoords.x - 2.00, myroomcoords.y - 04.00, myroomcoords.z) - plyCoords) < 3.0 and curRoomType == 1) 
			then
				
				if curRoomType == 2 then
					DrawText3Ds(myroomcoords.x + 4.3,myroomcoords.y - 15.95,myroomcoords.z+2.42, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave')
				elseif curRoomType == 3 then
					DrawText3Ds(myroomcoords.x - 14.45,myroomcoords.y - 2.5,myroomcoords.z+7.3, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave or ~g~'..Controlkey["housingSecondary"][2]..'~s~ to enter garage.')				
				elseif curRoomType == 1 then
					DrawText3Ds(myroomcoords.x - 1.15,myroomcoords.y - 4.2,myroomcoords.z+1.20, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave')
				end

				if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
					TriggerEvent("dooranim")
					TriggerEvent('InteractSound_CL:PlayOnOne','DoorOpen', 0.7)
					Wait(330)
					CleanUpArea()
					isForced = false
					TriggerEvent("enabledamage",false)
					if curRoomType == 2 then
						SetEntityCoords(PlayerPedId(),267.48132324219,-638.818359375,42.020294189453)
					elseif curRoomType == 3 then
						SetEntityCoords(PlayerPedId(),160.26762390137,-641.96905517578,47.073524475098)
					elseif curRoomType == 1 then
						SetEntityCoords(PlayerPedId(),apartments1[myRoomNumber]["x"],apartments1[myRoomNumber]["y"],apartments1[myRoomNumber]["z"])
					end
					TriggerEvent("enabledamage",true)
					insideApartment = false
					Citizen.Wait(100)
					TriggerEvent("dooranim")
					TriggerEvent('InteractSound_CL:PlayOnOne','DoorClose', 0.7)
					curRoom = { x = 1420.0, y = 1420.0, z = -900.0 }
					TriggerEvent("attachWeapons")
				end

				if IsControlJustReleased(1, Controlkey["housingSecondary"][1]) and curRoomType == 3 then
					TriggerEvent("dooranim")
					TriggerEvent('InteractSound_CL:PlayOnOne','DoorOpen', 0.7)
					Wait(330)
					isForced = false
					insideApartment = false
					CleanUpArea()
					DoScreenFadeOut(1)
					buildGarage()
					Citizen.Wait(4500)
					DoScreenFadeIn(1)
				end
 
			end

			if 	(#(vector3(myroomcoords.x - 1.6, myroomcoords.y + 1.20, myroomcoords.z + 1.00) - plyCoords) < 2.0 and curRoomType == 1) or 
				(#(vector3(myroomcoords.x + 9.8, myroomcoords.y - 1.35, myroomcoords.z + 0.15) - plyCoords) < 5.0 and curRoomType == 2) or 
				(#(vector3(myroomcoords.x + 1.5, myroomcoords.y + 8.00, myroomcoords.z + 1.00) - plyCoords) < 5.0 and curRoomType == 3) 
				and canInteract 
			then
				if curRoomType == 2 then
					DrawText3Ds(myroomcoords.x+9.8, myroomcoords.y - 1.35, myroomcoords.z+2.15, '~g~'..Controlkey["housingMain"][2]..'~s~ to interact')
				elseif curRoomType == 3 then
					DrawText3Ds(myroomcoords.x + 1.5, myroomcoords.y + 8, myroomcoords.z+1, '~g~'..Controlkey["housingMain"][2]..'~s~ to interact')
				elseif curRoomType == 1 then
					DrawText3Ds(myroomcoords.x - 1.6,myroomcoords.y + 1.2, myroomcoords.z+1, '~g~'..Controlkey["housingMain"][2]..'~s~ to interact')
				end

				if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
					if inRoom() then
						canInteract = false
						TriggerEvent('InteractSound_CL:PlayOnOne','StashOpen', 0.6)
						maxRoomWeight = 100.0 * (curRoomType * 2)
						if not isForced then
							TriggerServerEvent('hotel:getID')
						end
						TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "motel"..curRoomType.."-"..hid)

						TriggerEvent("actionbar:setEmptyHanded")
					else
						TriggerEvent("DoLongHudText","This is not your stash!",2)
					end
					Citizen.Wait(1900)
				end
			end

		if 	(#(vector3(curRoom.x - 1.6, curRoom.y + 1.20, curRoom.z + 1.00) - plyCoords) < 2.0 and curRoomType == 1) or 
			(#(vector3(curRoom.x + 9.8, curRoom.y - 1.35, curRoom.z + 0.15) - plyCoords) < 2.0 and curRoomType == 2) or 
			(#(vector3(curRoom.x + 1.5, curRoom.y + 8.00, curRoom.z + 1.00) - plyCoords) < 2.0 and curRoomType == 3) and 
			canInteract 
		then

			if curRoomType == 2 then
				DrawText3Ds(curRoom.x+9.8, curRoom.y - 1.35, curRoom.z+2.15, '~g~'..Controlkey["housingMain"][2]..'~s~ to interact')
			elseif curRoomType == 3 then
				DrawText3Ds(curRoom.x + 1.5, curRoom.y + 8, curRoom.z+1, '~g~'..Controlkey["housingMain"][2]..'~s~ to interact')
			elseif curRoomType == 1 then
				DrawText3Ds(curRoom.x - 1.6,curRoom.y + 1.2, curRoom.z+1, '~g~'..Controlkey["housingMain"][2]..'~s~ to interact')
			end

			if IsControlJustReleased(1, Controlkey["housingMain"][1]) then

				local myJob = exports["isPed"]:isPed("job")
				local LEO = false
				if myJob == "Police" or myJob == "DOJ" then
					LEO = true
				end

				if LEO then
					canInteract = false
					TriggerEvent('InteractSound_CL:PlayOnOne','StashOpen', 0.6)
					maxRoomWeight = 500.0 * curRoomType
					TriggerServerEvent('hotel:getID')
					--TriggerServerEvent('hotel:GetInteract',maxRoomWeight,forcedID)

					TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "motel"..curRoomType.."-"..forcedID)

				else
					TriggerEvent("DoLongHudText","This is not your stash!",2)
				end
				Citizen.Wait(1900)
			end

		end



	
		if 	(#(vector3(curRoom.x - 14.3,curRoom.y - 2,curRoom.z+7.02) - plyCoords) < 3.0 and curRoomType == 3) or 
			(#(vector3(curRoom.x + 4.3,curRoom.y - 15.95,curRoom.z+0.42) - plyCoords) < 3.0 and curRoomType == 2) or 
			(#(vector3(curRoom.x - 2,curRoom.y - 4,curRoom.z) - plyCoords) < 3.0 and curRoomType == 1) 
		then
				if curRoomType == 2 then
					DrawText3Ds(curRoom.x + 4.3,curRoom.y - 15.95,curRoom.z+2.42, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave')
				elseif curRoomType == 3 then
					DrawText3Ds(curRoom.x - 14.45,curRoom.y - 2.5,curRoom.z+7.3, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave or ~g~'..Controlkey["housingSecondary"][2]..'~s~ to enter garage.')	
				elseif curRoomType == 1 then
					DrawText3Ds(curRoom.x - 1.15,curRoom.y - 4.2,curRoom.z+1.20, '~g~'..Controlkey["housingMain"][2]..'~s~ to leave')
				end

				if IsControlJustReleased(1, Controlkey["housingSecondary"][1]) and curRoomType == 3 then
					TriggerEvent("dooranim")
					TriggerEvent('InteractSound_CL:PlayOnOne','DoorOpen', 0.7)
					Wait(330)
					isForced = false
					insideApartment = false
					CleanUpArea()
					DoScreenFadeOut(1)
					buildGarage()
					Citizen.Wait(4500)
					DoScreenFadeIn(1)
				end


				if IsControlJustReleased(1, Controlkey["housingMain"][1]) then

					Wait(200)
					CleanUpArea()

					if curRoomType == 2 then
						SetEntityCoords(PlayerPedId(),267.48132324219,-638.818359375,42.020294189453)
					elseif curRoomType == 3 then
						SetEntityCoords(PlayerPedId(),160.26762390137,-641.96905517578,47.073524475098)
					elseif curRoomType == 1 then
						SetEntityCoords(PlayerPedId(),313.2561340332,-227.30776977539,54.221176147461)
					end

					Citizen.Wait(2000)
					curRoom = { x = 1420.0, y = 1420.0, z = -900.0 }
					TriggerEvent("attachWeapons")
				end

			end
		else
			if ingarage then
				if #(vector3(currentGarage.x+9.5 , currentGarage.y-12.7, currentGarage.z+1.0) - plyCoords) < 3.0 then
					DrawText3Ds(currentGarage.x+9.5, currentGarage.y-12.7, currentGarage.z+1.0, '~g~'..Controlkey["housingMain"][2]..'~s~ to Room ~g~'..Controlkey["housingSecondary"][2]..'~s~ to Garage Door')
					if IsControlJustReleased(1, Controlkey["housingMain"][1]) then
						TriggerEvent("Garages:ToggleHouse",false)
						Wait(200)
						CleanUpArea()
						processBuildType(garageNumber,3)
						ingarage = false
						TriggerEvent("attachWeapons")
					end
					if IsControlJustReleased(1, Controlkey["housingSecondary"][1]) then
						TriggerEvent("Garages:ToggleHouse",false)
						Wait(200)
						CleanUpArea()
						SetEntityCoords(PlayerPedId(),4.67, -724.85, 32.18)
						ingarage = false
						TriggerEvent("attachWeapons")
					end
				else
					DisplayHelpText('Press ~g~'..Controlkey["housingSecondary"][2]..'~s~ while in a vehicle to spawn it.')
					if IsControlJustReleased(1, Controlkey["housingSecondary"][1]) then
						if IsPedInAnyVehicle(PlayerPedId(), false) then
							local carcarbroombrooms = GetClosestVehicle(-41.43, -716.53, 32.54, 3.000, 0, 70)

							if not DoesEntityExist(carcarbroombrooms) then
								local vehmove = GetVehiclePedIsIn(PlayerPedId(), true)
								
								SetEntityCoords(vehmove,-41.43, -716.53, 32.54)
								SetEntityHeading(vehmove,170.0)
								Wait(200)
								CleanUpArea()
								SetPedIntoVehicle(PlayerPedId(), vehmove, - 1)
								TriggerEvent("Garages:HouseRemoveVehicle",vehmove)
								ingarage = false
								
							else
								TriggerEvent("DoShortHudText","Vehicle on spawn.",2)
							end

							--leaveappartment
						else
							TriggerEvent("DoShortHudText","Enter Vehicle First", 2)
						end
					end
				end
				local lights = plyCoords
				DrawLightWithRange(lights["x"],lights["y"],lights["z"]+3, 255, 197, 143, 100.0, 0.45)
				DrawLightWithRange(lights["x"],lights["y"],lights["z"]-3, 255, 197, 143, 100.0, 0.45)
			else
				Citizen.Wait(math.ceil(comparedst * 10))
			end
			
		end
	end
end)

function nearClothingMotel()
	if #(vector3(myroomcoords.x, myroomcoords.y + 3, myroomcoords.z) - GetEntityCoords(PlayerPedId())) < 5.5 and curRoomType == 1 then
		return true
	end
	if #(vector3(myroomcoords.x + 10, myroomcoords.y + 6, myroomcoords.z) - GetEntityCoords(PlayerPedId())) < 5.5 and curRoomType == 2 then
		return true
	end	
	if #(vector3(myroomcoords.x - 3, myroomcoords.y - 7, myroomcoords.z) - GetEntityCoords(PlayerPedId())) < 55.5 and curRoomType == 3 then
		return true
	end		

	if #(vector3(1782.86, 2494.95, 50.43) - GetEntityCoords(PlayerPedId())) < 8.5 then
		return true
	end	

	local myjob = exports["isPed"]:isPed("job")
	--missionrow locker room
	if myjob == "Police" then
		return true
	end

	if myjob == "EMS" then
		return true
	end
	return false
end






RegisterNetEvent('hotel:listSKINSFORCYRTHESICKFUCK')
AddEventHandler('hotel:listSKINSFORCYRTHESICKFUCK', function(skincheck)
	TriggerEvent('DoLongHudText', 'Here u can use /outfitadd, /outfituse or /outfitdel')
	for i = 1, #skincheck do
		TriggerEvent("DoLongHudText", skincheck[i].slot .. " | " .. skincheck[i].name,i)
	end
end)

RegisterNetEvent('hotel:outfit')
AddEventHandler('hotel:outfit', function(id, args,sentType)

	if nearClothingMotel() then
		local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
    	local Player = LocalPlayer:getCurrentCharacter()
		if sentType == 1 then
			local id = id
			table.remove(args, 1)
			local text = '' -- edit here if you want to change the language : EN: the person / FR: la personne
			for i = 1,#args do
				text = text .. '' .. args[i]
			end
			text = text .. ''
			TriggerEvent("raid_clothes:outfits", sentType, id, text)
		elseif sentType == 2 then
			local id = id
			TriggerEvent("raid_clothes:outfits", sentType, id)
		elseif sentType == 3 then
			local id = id
			TriggerEvent('item:deleteClothesDna')
			TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
			TriggerEvent("raid_clothes:outfits", sentType, id)
		else
			TriggerServerEvent("raid_clothes:list_outfits", Player.id)
		end
	end
end)

RegisterCommand('outfits', function(source, args)
	TriggerEvent('hotel:outfit', args[1], args)
	TriggerEvent('housing:outfit', args[1], args)
end)

RegisterCommand('outfitadd', function(source, args)
	TriggerEvent('hotel:outfit', args[1], args, 1)
	TriggerEvent('housing:outfit', args[1], args, 1)
end)

RegisterCommand('outfitdel', function(source, args)
	TriggerEvent('hotel:outfit', args[1], args, 2)
	TriggerEvent('housing:outfit', args[1], args, 2)
end)

RegisterCommand('outfituse', function(source, args)
	TriggerEvent('hotel:outfit', args[1], args, 3)
	TriggerEvent('housing:outfit', args[1], args, 3)
end)