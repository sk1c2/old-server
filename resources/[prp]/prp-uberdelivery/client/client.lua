Keys = {
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

local PlayerData              = {}
--[[
	Locals Located Here
]]
starteduber = false
local hasdelivery = false
local deliveryactive = false
local dropingpackage = false
local disablepressE = false
local disablepressH = false
--
local deliverydoor1 = false -- This is simply to display if they are on that delivery
local deliveryporch1 = false
local ispedhome1 = true -- Set True by default
local doorknocked1 = false  -- if player has knocked on the door 
local blipdestination1 = false --- Set the Blip & Desitation
	----
local deliverydoor2 = false -- This is simply to display if they are on that delivery
local deliveryporch2 = false
local ispedhome2 = true -- Set True by default
local doorknocked2 = false -- if player has knocked on the door 
local blipdestination2 = false -- Set the Blip & Destination
	--
local deliverydoor3 = false -- This is simply to display if they are on that delivery
local deliveryporch3 = false
local ispedhome3 = true -- Set True by Default
local doorknocked3 = false
local blipdestination3 = false -- Set the Blip & Destination
	--
local deliverydoor4 = false -- This is simply to display if they are on that delivery
local deliveryporch4 = false
local ispedhome4 = true -- Set True by Default
local doorknocked4 = false
local blipdestination4 = false -- Set the Blip & Destination
	--
local deliverydoor5 = false -- This is simply to display if they are on that delivery
local deliveryporch5 = false
local ispedhome5 = true -- Set True by Default
local doorknocked5 = false
local blipdestination5 = false -- Set the Blip & Destination

	--
local deliverydoor6 = false -- This is simply to display if they are on that delivery
local deliveryporch6 = false
local ispedhome6 = true -- Set True by Default
local doorknocked6 = false
local blipdestination6 = false -- Set the Blip & Destination

	--
local deliverydoor7 = false -- This is simply to display if they are on that delivery
local deliveryporch7 = false
local ispedhome7 = true -- Set True by Default
local doorknocked7 = false
local blipdestination7 = false -- Set the Blip & Destination

	--
local deliverydoor8 = false -- This is simply to display if they are on that delivery
local deliveryporch8 = false
local ispedhome8 = true -- Set True by Default
local doorknocked8 = false
local blipdestination8 = false -- Set the Blip & Destination

	--
local deliverydoor9 = false -- This is simply to display if they are on that delivery
local deliveryporch9 = false
local ispedhome9 = true -- Set True by Default
local doorknocked9 = false
local blipdestination9 = false -- Set the Blip & Destination

	--
local deliverydoor10 = false -- This is simply to display if they are on that delivery
local deliveryporch10 = false
local ispedhome10 = true -- Set True by Default
local doorknocked10 = false
local blipdestination10 = false -- Set the Blip & Destination

	--
local deliverydoor11 = false -- This is simply to display if they are on that delivery
local deliveryporch11 = false
local ispedhome11 = true -- Set True by Default
local doorknocked11 = false
local blipdestination11 = false -- Set the Blip & Destination
	--
local deliverydoor12 = false -- This is simply to display if they are on that delivery
local deliveryporch12 = false
local ispedhome12 = true -- Set True by Default
local doorknocked12 = false
local blipdestination12 = false -- Set the Blip & Destination
	--
local deliverydoor13 = false -- This is simply to display if they are on that delivery
local deliveryporch13 = false
local ispedhome13 = true -- Set True by Default
local doorknocked13 = false
local blipdestination13 = false -- Set the Blip & Destination
	--
local deliverydoor14 = false -- This is simply to display if they are on that delivery
local deliveryporch14 = false
local ispedhome14 = true -- Set True by Default
local doorknocked14 = false
local blipdestination14 = false -- Set the Blip & Destination

function Draw3DText2(x,y,z,text,size)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35,0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    --DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 100)
end

local uberdeliveryamount = 0

--[[[ Delivery Giveout System ]]
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if starteduber and not hasdelivery then
		cooldown = math.random(30000,60000)
		Citizen.Wait(cooldown) -- [Debug]
	--	print('Delivery Sent')  -- [Debug]
		TriggerEvent('InteractSound_CL:PlayOnOne', 'pager', 0.4)
		TriggerEvent('DoLongHudText', 'New Delivery GPS Updated', 1)
		hasdelivery = true
		deliv = math.random(1,14) -- All Deliveries
	--	print(starteduber)
	--	print(hasdelivery)
		-- print(deliv) -- [Debug]
		elseif starteduber == false then
		hasdelivery = true

		end

	end

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if deliv == 1 and not blipdestination1 then
		deliverydoor1 = true
		SetDestination1() --- This is going to be a issue 
		elseif deliv == 1 and blipdestination1 then
		deliverydoor1 = true
		end
		if deliv == 2 and not blipdestination2 then 
		deliverydoor2 = true
		SetDestination2()
		elseif deliv == 2 and blipdestination2 then
		deliverydoor2 = true
		end
		if deliv == 3 and not blipdestination3 then
		deliverydoor3 = true
		SetDistnation3()
		elseif deliv == 3 and blipdestination3 then
		deliverydoor3 = true
		end
		if deliv == 4 and not blipdestination4 then
		deliverydoor4 = true
		SetDistnation4()
		elseif deliv == 4 and blipdestination4 then
		deliverydoor4 = true
		end
		if deliv == 5 and not blipdestination5 then
		deliverydoor5 = true
		SetDistnation5()
		elseif deliv == 5 and blipdestination5 then
		deliverydoor5 = true
		end
		if deliv == 6 and not blipdestination6 then
		deliverydoor6 = true
		SetDistnation6()
		elseif deliv == 6 and blipdestination6 then
		deliverydoor6 = true
		end
		if deliv == 7 and not blipdestination7 then
		deliverydoor7 = true
		SetDistnation7()
		elseif deliv == 7 and blipdestination7 then
		deliverydoor7 = true
		end
		if deliv == 8 and not blipdestination8 then
		deliverydoor8 = true
		SetDistnation8()
		elseif deliv == 8 and blipdestination8 then
		deliverydoor8 = true
		end
		if deliv == 9 and not blipdestination9 then
		deliverydoor9 = true
		SetDistnation9()
		elseif deliv == 9 and blipdestination9 then
		deliverydoor9 = true
		end
		if deliv == 10 and not blipdestination10 then
		deliverydoor10 = true
		SetDistnation10()
		elseif deliv == 10 and blipdestination10 then
		deliverydoor10 = true
		end
		if deliv == 11 and not blipdestination11 then
		deliverydoor11 = true
		SetDistnation11()
		elseif deliv == 11 and blipdestination11 then
		deliverydoor11 = true
		end
		if deliv == 12 and not blipdestination12 then
		deliverydoor12 = true
		SetDistnation12()
		elseif deliv == 12 and blipdestination12 then
		deliverydoor12 = true
		end
		if deliv == 13 and not blipdestination13 then
		deliverydoor13 = true
		SetDistnation13()
		elseif deliv == 13 and blipdestination13 then
		deliverydoor13 = true
		end
		if deliv == 14 and not blipdestination14 then
		deliverydoor14 = true
		SetDistnation14()
		elseif deliv == 14 and blipdestination14 then
		deliverydoor14 = true
		end
	end

end)


function removeblips()
	--[[ Remove Blips Specified on SetDestination# ]]
		RemoveBlip(uberdelivery1blip)
		RemoveBlip(uberdelivery2blip)
		RemoveBlip(uberdelivery3blip)
		RemoveBlip(uberdelivery4blip)
		RemoveBlip(uberdelivery5blip)
		RemoveBlip(uberdelivery6blip)
		RemoveBlip(uberdelivery7blip)
		RemoveBlip(uberdelivery8blip)
		RemoveBlip(uberdelivery9blip)
		RemoveBlip(uberdelivery10blip)
		RemoveBlip(uberdelivery11blip)
		RemoveBlip(uberdelivery12blip)
		RemoveBlip(uberdelivery13blip)
		RemoveBlip(uberdelivery14blip)
		starteduber = false
end
---[[[[[ Reward ]]]]]


function enditall()
		blipdestination1 = false
		blipdestination2 = false
		blipdestination3 = false
		blipdestination4 = false
		blipdestination5 = false
		blipdestination6 = false
		blipdestination7 = false
		blipdestination8 = false
		blipdestination9 = false
		blipdestination10 = false
		blipdestination11 = false
		blipdestination12 = false
		blipdestination13 = false
		blipdestination14 = false
		doorknocked1 = false
		doorknocked2 = false
		doorknocked3 = false
		doorknocked4 = false
		doorknocked5 = false
		doorknocked6 = false
		doorknocked7 = false
		doorknocked8 = false
		doorknocked9 = false
		doorknocked10 = false
		doorknocked11 = false
		doorknocked12 = false
		doorknocked13 = false
		doorknocked14 = false
end

function rewarduber()
	if ispedhomechance == 1 then
		chanceofcivstick = math.random(1,6)
		price = math.random(80,100)
        TriggerServerEvent( 'wrp-uber:pay', 82 )
		TriggerEvent('DoLongHudText', 'Package Delivered', 1)
		TriggerEvent('DoLongHudText', 'Recieved Tip', 2)
		removeblips()
		hasdelivery = false
		disablepressE = false
		disablepressH = false
		deliv = nil
		enditall()
		elseif ispedhomechance ~= 1 then
		price = math.random(60,80)
		TriggerServerEvent( 'wrp-uber:pay', 82 )
		TriggerEvent('DoLongHudText', 'Package Delivered', 1)
		removeblips()
		hasdelivery = false
		disablepressE = false
		disablepressH = false
		deliv = nil
		enditall()
	end
end
--[[ Set Destination Blips & Markers ]]
function SetDestination1()
		uberdelivery1blip = AddBlipForCoord(DeliveryLocations[1]["x"], DeliveryLocations[1]["y"],DeliveryLocations[1]["z"])
		SetBlipSprite(uberdelivery1blip,1)
		SetBlipColour(uberdelivery1blip,16742399)
		SetBlipScale(uberdelivery1blip,0.5)
		SetNewWaypoint(DeliveryLocations[1]["x"], DeliveryLocations[1]["y"])
		blipdestination1 = true
		deliverydoor2 = false
		deliverydoor3 = false
		blipdestination2 = false
end

function SetDestination2()
--[[ Set Marker & Blip ]]
		uberdelivery2blip = AddBlipForCoord(DeliveryLocations[2]["x"], DeliveryLocations[2]["y"],DeliveryLocations[2]["z"])
		SetBlipSprite(uberdelivery2blip,1)
		SetBlipColour(uberdelivery2blip,16742399)
		SetBlipScale(uberdelivery2blip,0.5)
		SetNewWaypoint(DeliveryLocations[2]["x"], DeliveryLocations[2]["y"])
		blipdestination2 = true
end

function SetDistnation3()
	--[[ Set Marker & Blip ]]
		uberdelivery3blip = AddBlipForCoord(DeliveryLocations[3]["x"], DeliveryLocations[3]["y"],DeliveryLocations[3]["z"])
		SetBlipSprite(uberdelivery3blip,1)
		SetBlipColour(uberdelivery3blip,16742399)
		SetBlipScale(uberdelivery3blip,0.5)
		SetNewWaypoint(DeliveryLocations[3]["x"], DeliveryLocations[3]["y"])
		--[[ Make sure other markers/blips are removed ]]
		blipdestination3 = true
end
function SetDistnation4()
	--[[ Set Marker & Blip ]]
		uberdelivery4blip = AddBlipForCoord(DeliveryLocations[4]["x"], DeliveryLocations[4]["y"],DeliveryLocations[4]["z"])
		SetBlipSprite(uberdelivery4blip,1)
		SetBlipColour(uberdelivery4blip,16742399)
		SetBlipScale(uberdelivery4blip,0.5)
		SetNewWaypoint(DeliveryLocations[4]["x"], DeliveryLocations[4]["y"])
		--[[ Make sure other markers/blips are removed ]]
		blipdestination4 = true
end


function SetDistnation5()
	--[[ Set Marker & Blip ]]
		uberdelivery5blip = AddBlipForCoord(DeliveryLocations[5]["x"], DeliveryLocations[5]["y"],DeliveryLocations[5]["z"])
		SetBlipSprite(uberdelivery5blip,1)
		SetBlipColour(uberdelivery5blip,16742399)
		SetBlipScale(uberdelivery5blip,0.5)
		SetNewWaypoint(DeliveryLocations[5]["x"], DeliveryLocations[5]["y"])
		--[[ Make sure other markers/blips are removed ]]
		blipdestination5 = true
end


function SetDistnation6()
	--[[ Set Marker & Blip ]]
		uberdelivery6blip = AddBlipForCoord(DeliveryLocations[6]["x"], DeliveryLocations[6]["y"],DeliveryLocations[6]["z"])
		SetBlipSprite(uberdelivery6blip,1)
		SetBlipColour(uberdelivery6blip,16742399)
		SetBlipScale(uberdelivery6blip,0.5)
		SetNewWaypoint(DeliveryLocations[6]["x"], DeliveryLocations[6]["y"])
		--[[ Make sure other markers/blips are removed ]]
		blipdestination6 = true
end

function SetDistnation7()
	--[[ Set Marker & Blip ]]
		uberdelivery7blip = AddBlipForCoord(DeliveryLocations[7]["x"], DeliveryLocations[7]["y"],DeliveryLocations[7]["z"])
		SetBlipSprite(uberdelivery7blip,1)
		SetBlipColour(uberdelivery7blip,16742399)
		SetBlipScale(uberdelivery7blip,0.5)
		SetNewWaypoint(DeliveryLocations[7]["x"], DeliveryLocations[7]["y"])
		--[[ Make sure other markers/blips are removed ]]
		blipdestination7 = true
end


function SetDistnation8()
	--[[ Set Marker & Blip ]]
		uberdelivery8blip = AddBlipForCoord(DeliveryLocations[8]["x"], DeliveryLocations[8]["y"], DeliveryLocations[8]["z"])
		SetBlipSprite(uberdelivery8blip,1)
		SetBlipColour(uberdelivery8blip,16742399)
		SetBlipScale(uberdelivery8blip,0.5)
		SetNewWaypoint(DeliveryLocations[8]["x"], DeliveryLocations[8]["y"])
		--[[ Make sure other markers/blips are removed ]]
		blipdestination8 = true
end

function SetDistnation9()
	--[[ Set Marker & Blip ]]
		uberdelivery9blip = AddBlipForCoord(DeliveryLocations[9]["x"], DeliveryLocations[9]["y"], DeliveryLocations[9]["z"])
		SetBlipSprite(uberdelivery9blip,1)
		SetBlipColour(uberdelivery9blip,16742399)
		SetBlipScale(uberdelivery9blip,0.5)
		SetNewWaypoint(DeliveryLocations[9]["x"], DeliveryLocations[9]["y"])
		--[[ Make sure other markers/blips are removed ]]
		blipdestination9 = true
end

function SetDistnation10()
	--[[ Set Marker & Blip ]]
		uberdelivery10blip = AddBlipForCoord(DeliveryLocations[10]["x"], DeliveryLocations[10]["y"], DeliveryLocations[10]["z"])
		SetBlipSprite(uberdelivery10blip,1)
		SetBlipColour(uberdelivery10blip,16742399)
		SetBlipScale(uberdelivery10blip,0.5)
		SetNewWaypoint(DeliveryLocations[10]["x"], DeliveryLocations[10]["y"])
		--[[ Make sure other markers/blips are removed ]]
		blipdestination10 = true
end


function SetDistnation11()
	--[[ Set Marker & Blip ]]
		uberdelivery11blip = AddBlipForCoord(DeliveryLocations[11]["x"], DeliveryLocations[11]["y"], DeliveryLocations[11]["z"])
		SetBlipSprite(uberdelivery11blip,1)
		SetBlipColour(uberdelivery11blip,16742399)
		SetBlipScale(uberdelivery11blip,0.5)
		SetNewWaypoint(DeliveryLocations[11]["x"], DeliveryLocations[11]["y"])
		--[[ Make sure other markers/blips are removed ]]
		blipdestination11 = true
end

function SetDistnation12()
	--[[ Set Marker & Blip ]]
		uberdelivery12blip = AddBlipForCoord(DeliveryLocations[12]["x"], DeliveryLocations[12]["y"], DeliveryLocations[12]["z"])
		SetBlipSprite(uberdelivery12blip,1)
		SetBlipColour(uberdelivery12blip,16742399)
		SetBlipScale(uberdelivery12blip,0.5)
		SetNewWaypoint(DeliveryLocations[12]["x"], DeliveryLocations[12]["y"])
		--[[ Make sure other markers/blips are removed ]]
		blipdestination12 = true
end

function SetDistnation13()
	--[[ Set Marker & Blip ]]
		uberdelivery13blip = AddBlipForCoord(DeliveryLocations[13]["x"], DeliveryLocations[13]["y"], DeliveryLocations[13]["z"])
		SetBlipSprite(uberdelivery13blip,1)
		SetBlipColour(uberdelivery13blip,16742399)
		SetBlipScale(uberdelivery13blip,0.5)
		SetNewWaypoint(DeliveryLocations[13]["x"], DeliveryLocations[13]["y"])
		--[[ Make sure other markers/blips are removed ]]
		blipdestination13 = true
end

function SetDistnation14()
	--[[ Set Marker & Blip ]]
		uberdelivery14blip = AddBlipForCoord(DeliveryLocations[14]["x"], DeliveryLocations[14]["y"], DeliveryLocations[14]["z"])
		SetBlipSprite(uberdelivery14blip,1)
		SetBlipColour(uberdelivery14blip,16742399)
		SetBlipScale(uberdelivery14blip,0.5)
		SetNewWaypoint(DeliveryLocations[14]["x"], DeliveryLocations[14]["y"])
		--[[ Make sure other markers/blips are removed ]]
		blipdestination14 = true
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()

		if droppingpackage then
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, Keys['W'], true) -- W
			DisableControlAction(0, Keys['A'], true) -- A
			DisableControlAction(0, 31, true) -- S (fault in Keys table!)
			DisableControlAction(0, 30, true) -- D (fault in Keys table!)

			DisableControlAction(0, Keys['R'], true) -- Reload
			DisableControlAction(0, Keys['Q'], true) -- Cover
			DisableControlAction(0, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(0, Keys['F'], true) -- Also 'enter'?

			DisableControlAction(0, Keys['F2'], true) -- Inventory
			DisableControlAction(0, Keys['F3'], true) -- Animations
			DisableControlAction(0, Keys['F6'], true) -- Job

			DisableControlAction(0, Keys['V'], true) -- Disable changing view
			DisableControlAction(0, Keys['C'], true) -- Disable looking behind
			DisableControlAction(0, Keys['X'], true) -- Disable clearing animation
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

DeliveryLocations = {  --- Coords [x] = Door Coords [x2] = package drop location if need be
    [1] = {["x"] = 8.91, ["y"] = -242.82, ["z"] = 51.86, ["x2"] = 9.99, ["y2"] = -243.67, ["z2"] = 51.86, ["isHome"] = math.random(1,2)},
    [2] = {["x"] = 113.74, ["y"] = -277.95, ["z"] = 54.51, ["x2"] = 112.59, ["y2"] = -278.71, ["z2"] = 54.51, ["isHome"] = math.random(1,2)},
    [3] = {["x"] = 201.56, ["y"] = -148.76, ["z"] = 61.47, ["x2"] = 201.55, ["y2"] = -150.31, ["z2"] = 60.48, ["isHome"] = math.random(1,2)},
    [4] = {["x"] = -206.84, ["y"] = 159.49, ["z"] = 74.08, ["x2"] = -208.98, ["y2"] = 161.16, ["z2"] = 73.19, ["isHome"] = math.random(1,2)},
    [5] = {["x"] = 38.83, ["y"] = -71.64, ["z"] = 63.83, ["x2"] = 38.75, ["y2"] = -70.58, ["z2"] = 63.16, ["isHome"] = math.random(1,2)},
    [6] = {["x"] = 47.84, ["y"] = -29.16, ["z"] = 73.71, ["x2"] = 47.76, ["y2"] = -28.01, ["z2"] = 73.24, ["isHome"] = math.random(1,2)},
    [7] = {["x"] = -264.41, ["y"] = 98.82, ["z"] = 69.27, ["x2"] = -263.97, ["y2"] = 97.78, ["z2"] = 68.85, ["isHome"] = math.random(1,2)},
    [8] = {["x"] = -419.34, ["y"] = 221.12, ["z"] = 83.6, ["x2"] = -418.33, ["y2"] = 221.3, ["z2"] = 83.13, ["isHome"] = math.random(1,2)},
    [9] = {["x"] = -998.43, ["y"] = 158.42, ["z"] = 62.31, ["x2"] = -998.7, ["y2"] = 157.24, ["z2"] = 61.65, ["isHome"] = math.random(1,2)},
    [10] = {["x"] = -1026.57, ["y"] = 360.64, ["z"] = 71.36, ["x2"] = -1026.37, ["y2"] = 359.52, ["z2"] = 70.83, ["isHome"] = math.random(1,2)},
    [11] = {["x"] = -967.06, ["y"] = 510.76, ["z"] = 82.07, ["x2"] = -968.07, ["y2"] = 510.76, ["z2"] = 81.31, ["isHome"] = math.random(1,2)},
    [12] = {["x"] = -1009.64, ["y"] = 478.93, ["z"] = 79.41, ["x2"] = -1008.37, ["y2"] = 478.9, ["z2"] = 78.79, ["isHome"] = math.random(1,2)},
    [13] = {["x"] = -1308.05, ["y"] = 448.59, ["z"] = 100.86, ["x2"] = -1309.12, ["y2"] = 449.41, ["z2"] = 100.57, ["isHome"] = math.random(1,2)},
    [14] = {["x"] = 557.39, ["y"] = -1759.57, ["z"] = 29.31, ["x2"] = 557.52, ["y2"] = -1760.54, ["z2"] = 28.89, ["isHome"] = math.random(1,2)},
}


Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		if starteduber then
			--[[ Door 1 ]]
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[1]["x"], DeliveryLocations[1]["y"], DeliveryLocations[1]["z"], true ) < 1.2 and deliverydoor1 and hasdelivery then --and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
					if doorknocked1 == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[1]["x"], DeliveryLocations[1]["y"], DeliveryLocations[1]["z"], true ) < 1.2 then
					 Draw3DText2(DeliveryLocations[1]["x"], DeliveryLocations[1]["y"], DeliveryLocations[1]["z"] + 0.3, tostring("~w~~g~[E]~w~ Knock on door"))
					end 
				
					if(IsControlJustPressed(1, Keys["E"])) and not deliveryporch1 and not disablepressE then
						local ped2 = GetPlayerPed(-1)
						disablepressE = true
						PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
						Citizen.Wait(1000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
						Citizen.Wait(2000)
						doorknocked1 = true
						ispedhomechance = math.random(1,2) -- math.random(1,2)
						-- print(ispedhomechance)
						if ispedhomechance == 1 then
							
							
							-- magic 
							TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
							droppingpackage = true
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Giving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							delivery1 = false
							deliverydoor1 = false
							hasdelivery = false
							RemoveBlip(uberdelivery1blip)
							rewarduber()
							droppingpackage = false

						end
						if ispedhomechance ~= 1 then
							doorknocked1 = true
							ispedhome1 = false
							deliveryporch1 = true
						end
					end
					--[[ Drop Package 1 ]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[1]["x2"], DeliveryLocations[1]["y2"], DeliveryLocations[1]["z2"], true ) < 4.0 and deliveryporch1 and hasdelivery then
					Draw3DText2(DeliveryLocations[1]["x2"], DeliveryLocations[1]["y2"], DeliveryLocations[1]["z2"] + 0.3, tostring("~w~~g~[H]~w~ Leave Package"))
				 if(IsControlJustPressed(1, Keys["H"])) and not disablepressH then
					 disablepressH = true  -- and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
				 	local player = PlayerId()
					local plyPed = GetPlayerPed(player)
					local plyPos = GetEntityCoords(plyPed, false) ---- --240.05, -1168.83, 22.98
				 	 -- [Debug]
				 	droppingpackage = true
				 	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
							exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Leaving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), plyPos.x, plyPos.y, plyPos.z, true)
							PlaceObjectOnGroundProperly(PackageDeliveryObject)
							RemoveBlip(uberdelivery1blip)
						--	deliv = 2 -- math.random(1,2) [Debug]
							rewarduber()
							deliveryporch1 = false
							droppingpackage = false
					 end
				end
			end
			--[[ Door 2 ]]
							if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[2]["x"], DeliveryLocations[2]["y"], DeliveryLocations[2]["z"], true ) < 1.2 and deliverydoor2 and hasdelivery then --and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
					if doorknocked2 == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[2]["x"], DeliveryLocations[2]["y"], DeliveryLocations[2]["z"], true ) < 1.2 then
					 Draw3DText2(DeliveryLocations[2]["x"], DeliveryLocations[2]["y"], DeliveryLocations[2]["z"] + 0.3, tostring("~w~~g~[E]~w~ Knock on door"))
					end 
				
					if(IsControlJustPressed(1, Keys["E"])) and not deliveryporch2 and not disablepressE then
						disablepressE = true
						local ped2 = GetPlayerPed(-1)
						PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
						Citizen.Wait(1000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
						Citizen.Wait(2000)
						doorknocked2 = true
						ispedhomechance = math.random(1,2) -- [Debug]
						-- print(ispedhomechance)
						if ispedhomechance == 1 then
							-- print(deliv) -- [Debug]
							-- magic 
							droppingpackage = true
							TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
							exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Giving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
						--	deliv = math.random(1,2)
							RemoveBlip(uberdelivery2blip)
							-- print(deliv) -- [Debug]
							rewarduber()
							droppingpackage = false

						end
						if ispedhomechance ~= 1 then
							doorknocked2 = true
							ispedhome2 = false
							deliveryporch2 = true
							-- print('The Ped result is' .. ispedhomechance) -- [Debug]
						end
					end
					--[[ Drop Package 2 ]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[2]["x2"], DeliveryLocations[2]["y2"], DeliveryLocations[2]["z2"], true ) < 4.0 and deliveryporch2 == true and hasdelivery then
					Draw3DText2(DeliveryLocations[2]["x2"], DeliveryLocations[2]["y2"], DeliveryLocations[2]["z2"] + 0.3, tostring("~w~~g~[H]~w~ Leave Package"))
				 if(IsControlJustPressed(1, Keys["H"])) and not disablepressH then -- and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
				 	disablepressH = true
				 	deliveryporch2 = false
				 	local player = PlayerId()
					local plyPed = GetPlayerPed(player)
					local plyPos = GetEntityCoords(plyPed, false) ---- --240.05, -1168.83, 22.98
				 	
				 	droppingpackage = true
				 	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
							exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Leaving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), plyPos.x, plyPos.y, plyPos.z, true)
							PlaceObjectOnGroundProperly(PackageDeliveryObject)
						--	deliv = math.random(1,2)
							RemoveBlip(uberdelivery2blip)
							-- print(deliv) -- [Debug]
							rewarduber()
							deliveryporch2 = false
							doorknocked2 = false
							droppingpackage = false
					 end
				end
			end
			--[[ Door 3 ]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[3]["x"], DeliveryLocations[3]["y"], DeliveryLocations[3]["z"], true ) < 1.2 and deliverydoor3 and hasdelivery then --and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
					if doorknocked3 == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[3]["x"], DeliveryLocations[3]["y"], DeliveryLocations[3]["z"], true ) < 1.2 then
					 Draw3DText2(DeliveryLocations[3]["x"], DeliveryLocations[3]["y"], DeliveryLocations[3]["z"] + 0.3, tostring("~w~~g~[E]~w~ Knock on door"))
					end 
				
					if(IsControlJustPressed(1, Keys["E"])) and not deliveryporch3 and not disablepressE then
						local ped2 = GetPlayerPed(-1)
						disablepressE = true
						PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
						Citizen.Wait(1000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
						Citizen.Wait(2000)
						doorknocked3 = true
						ispedhomechance = math.random(1,2) -- math.random(1,2)
						-- print(ispedhomechance)
						if ispedhomechance == 1 then
							
							
							-- magic 
							TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
							droppingpackage = true
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Giving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							delivery3 = false
							deliverydoor3 = false
							hasdelivery = false
							RemoveBlip(uberdeliver3blip)
						--	deliv = 2 -- math.random(2,2) [Debug]
							-- -- print('Delivery is ' .. deliv) -- [Debug]
							rewarduber()
							droppingpackage = false

						end
						if ispedhomechance ~= 1 then
							doorknocked3 = true
							ispedhome3 = false
							deliveryporch3 = true
						end
					end
					--[[ Drop Package 3 ]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[3]["x2"], DeliveryLocations[3]["y2"], DeliveryLocations[3]["z2"], true ) < 4.0 and deliveryporch3 and hasdelivery then
					Draw3DText2(DeliveryLocations[3]["x2"], DeliveryLocations[3]["y2"], DeliveryLocations[3]["z2"] + 0.3, tostring("~w~~g~[H]~w~ Leave Package"))
				 if(IsControlJustPressed(1, Keys["H"])) and not disablepressH then -- and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
				 	local player = PlayerId()
					local plyPed = GetPlayerPed(player)
					local plyPos = GetEntityCoords(plyPed, false) ---- --240.05, -1168.83, 22.98
				 	 -- [Debug]
				 	 disablepressH = true
				 	droppingpackage = true
				 	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Leaving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), plyPos.x, plyPos.y, plyPos.z, true)
							PlaceObjectOnGroundProperly(PackageDeliveryObject)
							RemoveBlip(uberdelivery3blip)
						--	deliv = 2 -- math.random(1,2) [Debug]
							rewarduber()
							deliveryporch3 = false
							droppingpackage = false
					 end
				end
			end
			--[[ Door 4 ]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[4]["x"], DeliveryLocations[4]["y"], DeliveryLocations[4]["z"], true ) < 1.2 and deliverydoor4 and hasdelivery then --and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
					if doorknocked4 == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[4]["x"], DeliveryLocations[4]["y"], DeliveryLocations[4]["z"], true ) < 1.2 then
					 Draw3DText2(DeliveryLocations[4]["x"], DeliveryLocations[4]["y"], DeliveryLocations[4]["z"] + 0.3, tostring("~w~~g~[E]~w~ Knock on door"))
					end 
				
					if(IsControlJustPressed(1, Keys["E"])) and not deliveryporch4 and not disablepressE then
						disablepressE = true
						local ped2 = GetPlayerPed(-1)
						PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
						Citizen.Wait(1000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
						Citizen.Wait(2000)
						doorknocked4 = true
						ispedhomechance = math.random(1,2) -- [Debug]
						-- print(ispedhomechance)
						if ispedhomechance == 1 then
							-- print(deliv) -- [Debug]
							-- magic 
							droppingpackage = true
							TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Giving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
						--	deliv = math.random(1,2)
							RemoveBlip(uberdelivery4blip)
							-- print(deliv) -- [Debug]
							rewarduber()
							droppingpackage = false

						end
						if ispedhomechance ~= 1 then
							doorknocked4 = true
							ispedhome4 = false
							deliveryporch4 = true
							-- print('The Ped result is' .. ispedhomechance) -- [Debug]
						end
					end
					--[[ Drop Package 4 ]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[4]["x2"], DeliveryLocations[4]["y2"], DeliveryLocations[4]["z2"], true ) < 4.0 and deliveryporch4 == true and hasdelivery then
					Draw3DText2(DeliveryLocations[4]["x"], DeliveryLocations[4]["y"], DeliveryLocations[4]["z"] + 0.3, tostring("~w~~g~[H]~w~ Leave Package"))
				 if(IsControlJustPressed(1, Keys["H"])) and not disablepressH then -- and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
				 	deliveryporch4 = false
				 	disablepressH = true
				 	local player = PlayerId()
					local plyPed = GetPlayerPed(player)
					local plyPos = GetEntityCoords(plyPed, false) ---- --240.05, -1168.83, 22.98
				 	
				 	droppingpackage = true
				 	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Leaving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), plyPos.x, plyPos.y, plyPos.z, true)
							PlaceObjectOnGroundProperly(PackageDeliveryObject)
						--	deliv = math.random(1,2)
							RemoveBlip(uberdelivery4blip)
							-- print(deliv) -- [Debug]
							rewarduber()
							deliveryporch4 = false
							doorknocked4 = false
							droppingpackage = false
					 end
				end
			end
			--[[ Door 5 ]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[5]["x"], DeliveryLocations[5]["y"], DeliveryLocations[5]["z"], true ) < 1.2 and deliverydoor5 and hasdelivery then --and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
					if doorknocked5 == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[5]["x"], DeliveryLocations[5]["y"], DeliveryLocations[5]["z"], true ) < 1.2 then
					 Draw3DText2(DeliveryLocations[5]["x"], DeliveryLocations[5]["y"], DeliveryLocations[5]["z"] + 0.3, tostring("~w~~g~[E]~w~ Knock on door"))
					end 
				
					if(IsControlJustPressed(1, Keys["E"])) and not deliveryporch5 and not disablepressE then
						local ped2 = GetPlayerPed(-1)
						disablepressE = true
						PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
						Citizen.Wait(1000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
						Citizen.Wait(2000)
						doorknocked5 = true
						ispedhomechance = math.random(1,2) -- math.random(1,2)
						-- print(ispedhomechance)
						if ispedhomechance == 1 then
							
							
							-- magic 
							TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
							droppingpackage = true
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Giving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							delivery5 = false
							deliverydoor5 = false
							hasdelivery = false
							RemoveBlip(uberdeliver5blip)
						--	deliv = 2 -- math.random(2,2) [Debug]
							-- -- print('Delivery is ' .. deliv) -- [Debug]
							rewarduber()
							droppingpackage = false

						end
						if ispedhomechance ~= 1 then
							doorknocked5 = true
							ispedhome5 = false
							deliveryporch5 = true
						end
					end
					---[[ Drop Package 5 ]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[5]["x2"], DeliveryLocations[5]["y2"], DeliveryLocations[5]["z2"], true ) < 4.0 and deliveryporch5 and hasdelivery then
					Draw3DText2(DeliveryLocations[5]["x2"], DeliveryLocations[5]["y2"], DeliveryLocations[5]["z2"] + 0.3, tostring("~w~~g~[H]~w~ Leave Package"))
				 if(IsControlJustPressed(1, Keys["H"])) and not disablepressH then -- and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
				 	local player = PlayerId()
					local plyPed = GetPlayerPed(player)
					local plyPos = GetEntityCoords(plyPed, false) ---- --240.05, -1168.83, 22.98
				 	 -- [Debug]
				 	 disablepressH = true
				 	droppingpackage = true
				 	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Leaving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), plyPos.x, plyPos.y, plyPos.z, true)
							PlaceObjectOnGroundProperly(PackageDeliveryObject)
							RemoveBlip(uberdelivery5blip)
						--	deliv = 2 -- math.random(1,2) [Debug]
							rewarduber()
							deliveryporch5 = false
							droppingpackage = false
					 end
				end
			end
			--[[ Door 6 ]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[6]["x"], DeliveryLocations[6]["y"], DeliveryLocations[6]["z"], true ) < 1.2 and deliverydoor6 and hasdelivery then --and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
					if doorknocked6 == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[6]["x"], DeliveryLocations[6]["y"], DeliveryLocations[6]["z"], true ) < 1.2 then
					 Draw3DText2(DeliveryLocations[6]["x"], DeliveryLocations[6]["y"], DeliveryLocations[6]["z"] + 0.3, tostring("~w~~g~[E]~w~ Knock on door"))
					end 
				
					if(IsControlJustPressed(1, Keys["E"])) and not deliveryporch6 and not disablepressE then
						local ped2 = GetPlayerPed(-1)
						disablepressE = true
						PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
						Citizen.Wait(1000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
						Citizen.Wait(2000)
						doorknocked6 = true
						ispedhomechance = math.random(1,2) -- math.random(1,2)
						-- print(ispedhomechance)
						if ispedhomechance == 1 then
							
							
							-- magic 
							TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
							droppingpackage = true
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Giving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							delivery6 = false
							deliverydoor6 = false
							hasdelivery = false
							RemoveBlip(uberdeliver6blip)
						--	deliv = 2 -- math.random(2,2) [Debug]
							-- -- print('Delivery is ' .. deliv) -- [Debug]
							rewarduber()
							droppingpackage = false

						end
						if ispedhomechance ~= 1 then
							doorknocked6 = true
							ispedhome6 = false
							deliveryporch6 = true
						end
					end
					--[[ Drop package 6 ]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[6]["x2"], DeliveryLocations[6]["y2"], DeliveryLocations[6]["z2"], true ) < 4.0 and deliveryporch6 and hasdelivery then
					Draw3DText2(DeliveryLocations[6]["x2"], DeliveryLocations[6]["y2"], DeliveryLocations[6]["z2"] + 0.3, tostring("~w~~g~[H]~w~ Leave Package"))
				 if(IsControlJustPressed(1, Keys["H"])) and not disablepressH then -- and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
				 	local player = PlayerId()
					local plyPed = GetPlayerPed(player)
					local plyPos = GetEntityCoords(plyPed, false) ---- --240.05, -1168.83, 22.98
				 	 -- [Debug]
				 	 disablepressH = true
				 	droppingpackage = true
				 	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Leaving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), plyPos.x, plyPos.y, plyPos.z, true)
							PlaceObjectOnGroundProperly(PackageDeliveryObject)
							RemoveBlip(uberdelivery6blip)
						--	deliv = 2 -- math.random(1,2) [Debug]
							rewarduber()
							deliveryporch6 = false
							droppingpackage = false
					 end
				end
			end
			--[[ Door 7 ]]
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[7]["x"], DeliveryLocations[7]["y"], DeliveryLocations[7]["z"], true ) < 1.2 and deliverydoor7 and hasdelivery then --and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
					if doorknocked7 == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[7]["x"], DeliveryLocations[7]["y"], DeliveryLocations[7]["z"], true ) < 1.2 then
					 Draw3DText2(DeliveryLocations[7]["x"], DeliveryLocations[7]["y"], DeliveryLocations[7]["z"] + 0.3, tostring("~w~~g~[E]~w~ Knock on door"))
					end 
				
					if(IsControlJustPressed(1, Keys["E"])) and not deliveryporch7 and not disablepressE then
						local ped2 = GetPlayerPed(-1)
						disablepressE = true
						PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
						Citizen.Wait(1000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
						Citizen.Wait(2000)
						doorknocked7 = true
						ispedhomechance = math.random(1,2) -- math.random(1,2)
						-- print(ispedhomechance)
						if ispedhomechance == 1 then
							
							
							-- magic 
							TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
							droppingpackage = true
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Giving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							delivery7 = false
							deliverydoor7 = false
							hasdelivery = false
							RemoveBlip(uberdeliver7blip)
						--	deliv = 2 -- math.random(2,2) [Debug]
							-- -- print('Delivery is ' .. deliv) -- [Debug]
							rewarduber()
							droppingpackage = false
						end
						if ispedhomechance ~= 1 then
							doorknocked7 = true
							ispedhome7 = false
							deliveryporch7 = true
						end
					end
					--[[ Drop package 7 ]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[7]["x2"], DeliveryLocations[7]["y2"], DeliveryLocations[7]["z2"], true ) < 4.0 and deliveryporch7 and hasdelivery then
					Draw3DText2(DeliveryLocations[7]["x2"], DeliveryLocations[7]["y2"], DeliveryLocations[7]["z2"] + 0.3, tostring("~w~~g~[H]~w~ Leave Package"))
				 if(IsControlJustPressed(1, Keys["H"])) and not disablepressH then -- and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
				 	local player = PlayerId()
					local plyPed = GetPlayerPed(player)
					local plyPos = GetEntityCoords(plyPed, false) ---- --240.05, -1168.83, 22.98
				 	 -- [Debug]
				 	 disablepressH = true
				 	droppingpackage = true
				 	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Leaving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), plyPos.x, plyPos.y, plyPos.z, true)
							PlaceObjectOnGroundProperly(PackageDeliveryObject)
							RemoveBlip(uberdelivery7blip)
						--	deliv = 2 -- math.random(1,2) [Debug]
							rewarduber()
							deliveryporch7 = false
							droppingpackage = false
					 end
				end
			end
			--[[ Door 8 ]]
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[8]["x"], DeliveryLocations[8]["y"], DeliveryLocations[8]["z"], true ) < 1.2 and deliverydoor8 and hasdelivery then --and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
					if doorknocked8 == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[8]["x"], DeliveryLocations[8]["y"], DeliveryLocations[8]["z"], true ) < 1.2 then
					 Draw3DText2(DeliveryLocations[8]["x"], DeliveryLocations[8]["y"], DeliveryLocations[8]["z"] + 0.3, tostring("~w~~g~[E]~w~ Knock on door"))
					end 
				
					if(IsControlJustPressed(1, Keys["E"])) and not deliveryporch8 and not disablepressE then
						local ped2 = GetPlayerPed(-1)
						disablepressE = true
						PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
						Citizen.Wait(1000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
						Citizen.Wait(2000)
						doorknocked8 = true
						ispedhomechance = math.random(1,2) -- math.random(1,2)
						-- print(ispedhomechance)
						if ispedhomechance == 1 then
							
							
							-- magic 
							TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
							droppingpackage = true
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Giving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							delivery8 = false
							deliverydoor8 = false
							hasdelivery = false
							RemoveBlip(uberdeliver8blip)
						--	deliv = 2 -- math.random(2,2) [Debug]
							-- -- print('Delivery is ' .. deliv) -- [Debug]
							rewarduber()
							droppingpackage = false

						end
						if ispedhomechance ~= 1 then
							doorknocked8 = true
							ispedhome8 = false
							deliveryporch8 = true
						end
					end
					--[[ Drop Package 8  ]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[8]["x2"], DeliveryLocations[8]["y2"], DeliveryLocations[8]["z2"], true ) < 4.0 and deliveryporch8 and hasdelivery then
					Draw3DText2(DeliveryLocations[8]["x2"], DeliveryLocations[8]["y2"], DeliveryLocations[8]["z2"] + 0.3, tostring("~w~~g~[H]~w~ Leave Package"))
				 if(IsControlJustPressed(1, Keys["H"])) and not disablepressH then -- and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
				 	local player = PlayerId()
					local plyPed = GetPlayerPed(player)
					local plyPos = GetEntityCoords(plyPed, false) ---- --240.05, -1168.83, 22.98
				 	 -- [Debug]
				 	 disablepressH = true
				 	droppingpackage = true
				 	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Leaving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), plyPos.x, plyPos.y, plyPos.z, true)
							PlaceObjectOnGroundProperly(PackageDeliveryObject)
							RemoveBlip(uberdelivery8blip)
						--	deliv = 2 -- math.random(1,2) [Debug]
							rewarduber()
							deliveryporch8 = false
							droppingpackage = false
					 end
				end
			end
			--[[ Door 9 ]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[9]["x"], DeliveryLocations[9]["y"], DeliveryLocations[9]["z"], true ) < 1.2 and deliverydoor9 and hasdelivery then --and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
					if doorknocked9 == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[9]["x"], DeliveryLocations[9]["y"], DeliveryLocations[9]["z"], true ) < 1.2 then
					 Draw3DText2(DeliveryLocations[9]["x"], DeliveryLocations[9]["y"], DeliveryLocations[9]["z"] + 0.3, tostring("~w~~g~[E]~w~ Knock on door"))
					end 
				
					if(IsControlJustPressed(1, Keys["E"])) and not deliveryporch9 and not disablepressE then
						local ped2 = GetPlayerPed(-1)
						disablepressE = true
						PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
						Citizen.Wait(1000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
						Citizen.Wait(2000)
						doorknocked9 = true
						ispedhomechance = math.random(1,2) -- math.random(1,2)
						-- print(ispedhomechance)
						if ispedhomechance == 1 then
							
							
							-- magic 
							TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
							droppingpackage = true
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Giving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							delivery9 = false
							deliverydoor9 = false
							hasdelivery = false
							RemoveBlip(uberdeliver9blip)
						--	deliv = 2 -- math.random(2,2) [Debug]
							-- -- print('Delivery is ' .. deliv) -- [Debug]
							rewarduber()
							droppingpackage = false

						end
						if ispedhomechance ~= 1 then
							doorknocked9 = true
							ispedhome9 = false
							deliveryporch9 = true
						end
					end
					--[[ Drop package 9]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[9]["x2"], DeliveryLocations[9]["y2"], DeliveryLocations[9]["z2"], true ) < 4.0 and deliveryporch9 and hasdelivery then
					Draw3DText2(DeliveryLocations[9]["x2"], DeliveryLocations[9]["y2"], DeliveryLocations[9]["z2"] + 0.3, tostring("~w~~g~[H]~w~ Leave Package"))
				 if(IsControlJustPressed(1, Keys["H"])) and not disablepressH then -- and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
				 	local player = PlayerId()
					local plyPed = GetPlayerPed(player)
					local plyPos = GetEntityCoords(plyPed, false) ---- --240.05, -1168.83, 22.98
				 	 -- [Debug]
				 	 disablepressH = true
				 	droppingpackage = true
				 	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Leaving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), plyPos.x, plyPos.y, plyPos.z, true)
							PlaceObjectOnGroundProperly(PackageDeliveryObject)
							RemoveBlip(uberdelivery9blip)
						--	deliv = 2 -- math.random(1,2) [Debug]
							rewarduber()
							deliveryporch9 = false
							droppingpackage = false
					 end
				end
			end
			--[[ Door 10 ]]
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[10]["x"], DeliveryLocations[10]["y"], DeliveryLocations[10]["z"], true ) < 1.2 and deliverydoor10 and hasdelivery then --and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
					if doorknocked10 == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[10]["x"], DeliveryLocations[10]["y"], DeliveryLocations[10]["z"], true ) < 1.2 then
					 Draw3DText2(DeliveryLocations[10]["x"], DeliveryLocations[10]["y"], DeliveryLocations[10]["z"] + 0.3, tostring("~w~~g~[E]~w~ Knock on door"))
					end 
				
					if(IsControlJustPressed(1, Keys["E"])) and not deliveryporch10 and not disablepressE then
						local ped2 = GetPlayerPed(-1)
						disablepressE = true
						PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
						Citizen.Wait(1000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
						Citizen.Wait(2000)
						doorknocked10 = true
						ispedhomechance = math.random(1,2) -- math.random(1,2)
						-- print(ispedhomechance)
						if ispedhomechance == 1 then
							
							
							-- magic 
							TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
							droppingpackage = true
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Giving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							delivery10 = false
							deliverydoor10 = false
							hasdelivery = false
							RemoveBlip(uberdeliver10blip)
						--	deliv = 2 -- math.random(2,2) [Debug]
							-- -- print('Delivery is ' .. deliv) -- [Debug]
							rewarduber()
							droppingpackage = false

						end
						if ispedhomechance ~= 1 then
							doorknocked10 = true
							ispedhome10 = false
							deliveryporch10 = true
						end
					end
					--[[ Drop Package 10]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[10]["x2"], DeliveryLocations[10]["y2"], DeliveryLocations[10]["z2"], true ) < 4.0 and deliveryporch10 and hasdelivery then
					Draw3DText2(DeliveryLocations[10]["x2"], DeliveryLocations[10]["y2"], DeliveryLocations[10]["z2"] + 0.3, tostring("~w~~g~[H]~w~ Leave Package"))
				 if(IsControlJustPressed(1, Keys["H"])) and not disablepressH then -- and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
				 	local player = PlayerId()
					local plyPed = GetPlayerPed(player)
					local plyPos = GetEntityCoords(plyPed, false) ---- --240.05, -1168.83, 22.98
				 	 -- [Debug]
				 	 disablepressH = true
				 	droppingpackage = true
				 	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Leaving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), plyPos.x, plyPos.y, plyPos.z, true)
							PlaceObjectOnGroundProperly(PackageDeliveryObject)
							RemoveBlip(uberdelivery10blip)
						--	deliv = 2 -- math.random(1,2) [Debug]
							rewarduber()
							deliveryporch10 = false
							droppingpackage = false
					 end
				end
			end
			--[[ Door 11 ]]
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[11]["x"], DeliveryLocations[11]["y"], DeliveryLocations[11]["z"], true ) < 1.2 and deliverydoor11 and hasdelivery then --and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
					if doorknocked11 == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[11]["x"], DeliveryLocations[11]["y"], DeliveryLocations[11]["z"], true ) < 1.2 then
					 Draw3DText2(DeliveryLocations[11]["x"], DeliveryLocations[11]["y"], DeliveryLocations[11]["z"] + 0.3, tostring("~w~~g~[E]~w~ Knock on door"))
					end 
				
					if(IsControlJustPressed(1, Keys["E"])) and not deliveryporch11 and not disablepressE then
						local ped2 = GetPlayerPed(-1)
						disablepressE = true
						PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
						Citizen.Wait(1000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
						Citizen.Wait(2000)
						doorknocked11 = true
						ispedhomechance = math.random(1,2) -- math.random(1,2)
						-- print(ispedhomechance)
						if ispedhomechance == 1 then
							
							
							-- magic 
							TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
							droppingpackage = true
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Giving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							delivery11 = false
							deliverydoor11 = false
							hasdelivery = false
							RemoveBlip(uberdeliver11blip)
						--	deliv = 2 -- math.random(2,2) [Debug]
							-- -- print('Delivery is ' .. deliv) -- [Debug]
							rewarduber()
							droppingpackage = false

						end
						if ispedhomechance ~= 1 then
							doorknocked11 = true
							ispedhome11 = false
							deliveryporch11 = true
						end
					end
					--[[ Drop Package 11]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[11]["x2"], DeliveryLocations[11]["y2"], DeliveryLocations[11]["z2"], true ) < 4.0 and deliveryporch11 and hasdelivery then
					Draw3DText2(DeliveryLocations[11]["x2"], DeliveryLocations[11]["y2"], DeliveryLocations[11]["z2"] + 0.3, tostring("~w~~g~[H]~w~ Leave Package"))
				 if(IsControlJustPressed(1, Keys["H"])) and not disablepressH then -- and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
				 	local player = PlayerId()
					local plyPed = GetPlayerPed(player)
					local plyPos = GetEntityCoords(plyPed, false) ---- --240.05, -1168.83, 22.98
				 	 -- [Debug]
				 	 disablepressH = true
				 	droppingpackage = true
				 	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Leaving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), plyPos.x, plyPos.y, plyPos.z, true)
							PlaceObjectOnGroundProperly(PackageDeliveryObject)
							RemoveBlip(uberdelivery11blip)
						--	deliv = 2 -- math.random(1,2) [Debug]
							rewarduber()
							deliveryporch11 = false
							droppingpackage = false
					 end
				end
			end
						--[[ Door 12 ]]
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[12]["x"], DeliveryLocations[12]["y"], DeliveryLocations[12]["z"], true ) < 1.2 and deliverydoor12 and hasdelivery then --and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
					if doorknocked12 == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[12]["x"], DeliveryLocations[12]["y"], DeliveryLocations[12]["z"], true ) < 1.2 then
					 Draw3DText2(DeliveryLocations[12]["x"], DeliveryLocations[12]["y"], DeliveryLocations[12]["z"] + 0.3, tostring("~w~~g~[E]~w~ Knock on door"))
					end 
				
					if(IsControlJustPressed(1, Keys["E"])) and not deliveryporch12 and not disablepressE then
						local ped2 = GetPlayerPed(-1)
						disablepressE = true
						PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
						Citizen.Wait(1000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
						Citizen.Wait(2000)
						doorknocked12 = true
						ispedhomechance = math.random(1,2) -- math.random(1,2)
						-- print(ispedhomechance)
						if ispedhomechance == 1 then
							
							
							-- magic 
							TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
							droppingpackage = true
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Giving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							delivery12 = false
							deliverydoor12 = false
							hasdelivery = false
							RemoveBlip(uberdeliver12blip)
						--	deliv = 2 -- math.random(2,2) [Debug]
							-- -- print('Delivery is ' .. deliv) -- [Debug]
							rewarduber()
							droppingpackage = false

						end
						if ispedhomechance ~= 1 then
							doorknocked12 = true
							ispedhome12 = false
							deliveryporch12 = true
						end
					end
					--[[ Drop Package 12]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[12]["x2"], DeliveryLocations[12]["y2"], DeliveryLocations[12]["z2"], true ) < 4.0 and deliveryporch12 and hasdelivery then
					Draw3DText2(DeliveryLocations[12]["x2"], DeliveryLocations[12]["y2"], DeliveryLocations[12]["z2"] + 0.3, tostring("~w~~g~[H]~w~ Leave Package"))
				 if(IsControlJustPressed(1, Keys["H"])) and not disablepressH then -- and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
				 	local player = PlayerId()
					local plyPed = GetPlayerPed(player)
					local plyPos = GetEntityCoords(plyPed, false) ---- --240.05, -1168.83, 22.98
				 	 -- [Debug]
				 	 disablepressH = true
				 	droppingpackage = true
				 	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Leaving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), plyPos.x, plyPos.y, plyPos.z, true)
							PlaceObjectOnGroundProperly(PackageDeliveryObject)
							RemoveBlip(uberdelivery12blip)
						--	deliv = 2 -- math.random(1,2) [Debug]
							rewarduber()
							deliveryporch12 = false
							droppingpackage = false
					 end
				end
			end
			---
									--[[ Door 13 ]]
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[13]["x"], DeliveryLocations[13]["y"], DeliveryLocations[13]["z"], true ) < 1.2 and deliverydoor13 and hasdelivery then --and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
					if doorknocked13 == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[13]["x"], DeliveryLocations[13]["y"], DeliveryLocations[13]["z"], true ) < 1.2 then
					 Draw3DText2(DeliveryLocations[13]["x"], DeliveryLocations[13]["y"], DeliveryLocations[13]["z"] + 0.3, tostring("~w~~g~[E]~w~ Knock on door"))
					end 
				
					if(IsControlJustPressed(1, Keys["E"])) and not deliveryporch13 and not disablepressE then
						local ped2 = GetPlayerPed(-1)
						disablepressE = true
						PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
						Citizen.Wait(1000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
						Citizen.Wait(2000)
						doorknocked13 = true
						ispedhomechance = math.random(1,2) -- math.random(1,2)
						-- print(ispedhomechance)
						if ispedhomechance == 1 then
							
							
							-- magic 
							TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
							droppingpackage = true
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Giving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							delivery13 = false
							deliverydoor13 = false
							hasdelivery = false
							RemoveBlip(uberdeliver13blip)
						--	deliv = 2 -- math.random(2,2) [Debug]
							-- -- print('Delivery is ' .. deliv) -- [Debug]
							rewarduber()
							droppingpackage = false

						end
						if ispedhomechance ~= 1 then
							doorknocked13 = true
							ispedhome13 = false
							deliveryporch13 = true
						end
					end
					--[[ Drop Package 13]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[13]["x2"], DeliveryLocations[13]["y2"], DeliveryLocations[13]["z2"], true ) < 4.0 and deliveryporch13 and hasdelivery then
					Draw3DText2(DeliveryLocations[13]["x2"], DeliveryLocations[13]["y2"], DeliveryLocations[13]["z2"] + 0.3, tostring("~w~~g~[H]~w~ Leave Package"))
				 if(IsControlJustPressed(1, Keys["H"])) and not disablepressH then -- and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
				 	local player = PlayerId()
					local plyPed = GetPlayerPed(player)
					local plyPos = GetEntityCoords(plyPed, false) ---- --240.05, -1168.83, 22.98
				 	 -- [Debug]
				 	 disablepressH = true
				 	droppingpackage = true
				 	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Leaving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), plyPos.x, plyPos.y, plyPos.z, true)
							PlaceObjectOnGroundProperly(PackageDeliveryObject)
							RemoveBlip(uberdelivery13blip)
						--	deliv = 2 -- math.random(1,2) [Debug]
							rewarduber()
							deliveryporch13 = false
							droppingpackage = false
					 end
				end
			end
			---
									--[[ Door 14 ]]
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[14]["x"], DeliveryLocations[14]["y"], DeliveryLocations[14]["z"], true ) < 1.2 and deliverydoor14 and hasdelivery then --and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
					if doorknocked14 == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[14]["x"], DeliveryLocations[14]["y"], DeliveryLocations[14]["z"], true ) < 1.2 then
					 Draw3DText2(DeliveryLocations[14]["x"], DeliveryLocations[14]["y"], DeliveryLocations[14]["z"] + 0.3, tostring("~w~~g~[E]~w~ Knock on door"))
					end 
				
					if(IsControlJustPressed(1, Keys["E"])) and not deliveryporch14 and not disablepressE then
						local ped2 = GetPlayerPed(-1)
						disablepressE = true
						PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")
						Citizen.Wait(1000)
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'doorknock', 0.5)
						Citizen.Wait(2000)
						doorknocked14 = true
						ispedhomechance = math.random(1,2) -- math.random(1,2)
						-- print(ispedhomechance)
						if ispedhomechance == 1 then
							
							
							-- magic 
							TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
							droppingpackage = true
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Giving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							delivery14 = false
							deliverydoor14 = false
							hasdelivery = false
							RemoveBlip(uberdeliver14blip)
						--	deliv = 2 -- math.random(2,2) [Debug]
							-- -- print('Delivery is ' .. deliv) -- [Debug]
							rewarduber()
							droppingpackage = false

						end
						if ispedhomechance ~= 1 then
							doorknocked14 = true
							ispedhome14 = false
							deliveryporch14 = true
						end
					end
					--[[ Drop Package 13]]
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), DeliveryLocations[14]["x2"], DeliveryLocations[14]["y2"], DeliveryLocations[14]["z2"], true ) < 4.0 and deliveryporch14 and hasdelivery then
					Draw3DText2(DeliveryLocations[14]["x2"], DeliveryLocations[14]["y2"], DeliveryLocations[14]["z2"] + 0.3, tostring("~w~~g~[H]~w~ Leave Package"))
				 if(IsControlJustPressed(1, Keys["H"])) and not disablepressH then -- and PlayerData.job ~= nil and PlayerData.job.name == 'mecano'
				 	local player = PlayerId()
					local plyPed = GetPlayerPed(player)
					local plyPos = GetEntityCoords(plyPed, false) ---- --240.05, -1168.83, 22.98
				 	 -- [Debug]
				 	 disablepressH = true
				 	droppingpackage = true
				 	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Because IT FITSSSSSSS - 99kr
					 		Citizen.Wait(0)
					 		exports["wrp-taskbar"]:taskBar(math.random(5000,10000), "Leaving Package...")
							ClearPedTasks(PlayerPedId())
							ClearPedTasks(PlayerPedId(-1))
							local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), plyPos.x, plyPos.y, plyPos.z, true)
							PlaceObjectOnGroundProperly(PackageDeliveryObject)
							RemoveBlip(uberdelivery14blip)
						--	deliv = 2 -- math.random(1,2) [Debug]
							rewarduber()
							deliveryporch14 = false
							droppingpackage = false
					 end
				end
			end
		end
	end
end)


PlayAnimation = function(ped, dict, anim, settings)
    if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
      end

      if settings == nil then
        TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
      else 
        local speed = 1.0
        local speedMultiplier = -1.0
        local duration = 1.0
        local flag = 0
        local playbackRate = 0

        if settings["speed"] ~= nil then
          speed = settings["speed"]
        end

        if settings["speedMultiplier"] ~= nil then
          speedMultiplier = settings["speedMultiplier"]
        end

        if settings["duration"] ~= nil then
          duration = settings["duration"]
        end

        if settings["flag"] ~= nil then
          flag = settings["flag"]
        end

        if settings["playbackRate"] ~= nil then
          playbackRate = settings["playbackRate"]
        end

        TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
      end
      
      RemoveAnimDict(dict)
        end)
    else
        TaskStartScenarioInPlace(ped, anim, 0, true)
    end
end




RegisterNetEvent('wrp-uberdelivery:start')
AddEventHandler('wrp-uberdelivery:start', function()
 local pedxd = GetPlayerPed( -1 )
 	if not starteduber and uerdeliveryamount ~= 10 then
		TriggerEvent('DoLongHudText', 'Uber Delivery: Active [Wait for Delivery]', 1)
	 	starteduber = true
	 	hasdelivery = false
	end
end)

RegisterNetEvent('wrp-uberdelivery:end')
AddEventHandler('wrp-uberdelivery:end', function()
 local pedxd = GetPlayerPed( -1 )
 	if starteduber then
		TriggerEvent('DoLongHudText', 'Uber Delivery: Deactivated', 1)
		starteduber = false
		hasdelivery = true
		removeblips()
	end
end)