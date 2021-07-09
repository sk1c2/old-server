dmv = 0
strike = 0
part1 = 0
vehicle = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2)
		DrawMarkers()
	end
end)

Citizen.CreateThread(function() 

	local blips = {
		{title="Driving School", colour=17, id=380, x = -814.5725, y = -1347.639, z = 5.219998}
	}

	for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.9)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		RequestModel(GetHashKey('a_f_m_soucentmc_01'))
		RequestModel(GetHashKey('a_f_y_business_01'))
		RequestModel(GetHashKey('a_m_m_prolhost_01'))
		RequestModel(GetHashKey('sultan'))
	end
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

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function DrawMarkers()
	local x,y,z = -804.3062, -1349.024, 5.218776
	local Playermate = PlayerPedId()
	local plyCoords = GetEntityCoords(Playermate)
	local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
	if distance < 2.5 and part1 == 0 then
		DrawMarker(36, -804.3062, -1349.024, 5.218776,0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 15, 255, 255, 100, false, true, 2, false, false, false, false)
		DrawText3Ds(x,y,z+0.5, 'Press [E] to book a driving lesson.')
		if IsControlJustReleased(0, 38) then
			local hehehe = math.random(1,3)
			if hehehe == 1 then
				hash = 'a_f_m_soucentmc_01'
			end
			if hehehe == 2 then
				hash = 'a_f_y_business_01'
			end
			if hehehe == 3 then
				hash = 'a_m_m_prolhost_01'
			end
			while dmv == 0 do
				Citizen.Wait(100)
				dmv = CreatePed(4, hash, -803.5156, -1349.922, 5.218639, 43.30, false, true)
				SetEntityAsMissionEntity(dmv, true, true)
			end
			part1 = 1
			Citizen.Wait(1000)
			DrawPart2()
		end
	end
end

function DrawPart2()
	while true do
		Citizen.Wait(3)
		local x,y,z = -804.3062, -1349.024, 5.218776
		local Playermate = PlayerPedId()
		local plyCoords = GetEntityCoords(Playermate)
		local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)

		if distance < 2 then
			DrawText3Ds(x,y,z, '[E] To Book The Driving Lesson. Costs $250.')
			if IsControlJustReleased(0, 38) then
				TriggerEvent('wrp-ac:removeban', 250)
				loadAnimDict('friends@laf@ig_5')
				TaskPlayAnim(dmv, 'friends@laf@ig_5', 'nephew', 5.0, 1.0, 5.0, 48, 0.0, 0, 0, 0)
				Citizen.Wait(1000)
				SetEntityCoords(dmv, -806.372, -1351.286, 5.22024, 309.7050)	
				loadAnimDict('friends@frj@ig_1')
				TaskPlayAnim(dmv, 'friends@frj@ig_1', 'wave_a', 5.0, 1.0, 5.0, 48, 0.0, 0, 0, 0)
				Citizen.Wait(500)
				loadAnimDict('gestures@m@standing@fat')
				TaskPlayAnim(dmv, 'gestures@m@standing@fat', 'gesture_come_here_hard', 5.0, 1.0, 5.0, 48, 0.0, 0, 0, 0)
				Citizen.Wait(1000)
				RequestModel('sultan')
				vehicle = CreateVehicle('sultan', -815.5163, -1318.327, 5.000382, 0, 0)
				TaskWarpPedIntoVehicle(dmv, vehicle, 0)
				TaskWarpPedIntoVehicle(Playermate, vehicle, -1)
				local plate = GetVehicleNumberPlateText(vehicle)
				TriggerServerEvent('garage:addKeys', plate)
				Citizen.Wait(1000)
				TriggerEvent('DoLongHudText', 'Lets start with the basics. Rev your Engine up to 5,000 RPM.')
				while true do
					Citizen.Wait(15)
					local rpm = GetVehicleCurrentRpm(vehicle)
					if rpm >= 0.55 then
						TriggerEvent('wrp-driving-instructor:phase2')
						break
					end
				end
			end
		end
	end
end

RegisterNetEvent('wrp-driving-instructor:phase2')
AddEventHandler('wrp-driving-instructor:phase2', function()
	Citizen.Wait(5000)
	SetNewWaypoint(-193.8802, -1979.213)
	TriggerEvent('DoLongHudText', 'Okay, I think you\'re ready. Drive to the marker on your GPS.')
	while true do
		Citizen.Wait(100)
		local x3,y3,z3 = -192.8651, -1979.011, 27.62041
		local Playermate3 = PlayerPedId(-1)
		local plyCoords3 = GetEntityCoords(Playermate3)
		local distance3 = GetDistanceBetweenCoords(plyCoords3.x,plyCoords3.y,plyCoords3.z,x3,y3,z3,false)
		local speed = GetEntitySpeed(PlayerPedId(-1))
		if speed >= 25 then
			TriggerEvent('Update-Strike')
			TriggerEvent('DoLongHudText', 'You are speeding! Slow down. Strike ' ..strike.. ' / 5.', 2)
			Citizen.Wait(3000)
			TriggerEvent('DoLongHudText', 'The Speed Limit is 45MPH')
			if strike >= 5 then
				TriggerEvent('wrp-drivinginstructor:fail')
				break
			end
			Citizen.Wait(5000)
		end
		if distance3 < 10 then
			TriggerEvent('wrp-driving-instructor:stage3')
			Citizen.Wait(10000000000000000)
		end
	end 
end)

RegisterNetEvent('wrp-driving-instructor:stage3')
AddEventHandler('wrp-driving-instructor:stage3', function()
	local whatnext = math.random(1,4)
	if whatnext == 1 then
		whatshallidonexttime = 'go a little more easy on the brakes'
	end
	if whatnext == 2 then
		whatshallidonexttime = 'slow down more when going around corners'
	end
	if whatnext == 3 then
		whatshallidonexttime = 'check your mirrors more'
	end
	if whatnext == 4 then
		whatshallidonexttime = 'be aware of your surroundings'
	end
	TriggerEvent('DoLongHudText', 'Congratulations, you have done your first driving lesson! Good driving. Remember next time to ' .. whatshallidonexttime .. '! I am just ticking the checklist off, then I will drive you back.')
	Citizen.Wait(4000)
	TriggerEvent('DoLongHudText', 'Switching Seats.')
	TaskWarpPedIntoVehicle(PlayerPedId(-1), vehicle, 2)
	Citizen.Wait(50)
	TaskWarpPedIntoVehicle(dmv, vehicle, -1)
	TaskVehicleDriveToCoord(dmv, vehicle, -817.8578, -1331.007, 5.00037, 500.0, 0.0, 'sultan', 1074528293, 15)
	while true do
		Citizen.Wait(20)
		local x4,y4,z4 = -817.8578, -1331.007, 5.00037
		local Playermate4 = PlayerPedId(-1)
		local plyCoords4 = GetEntityCoords(Playermate4)
		local distance4 = GetDistanceBetweenCoords(plyCoords4.x,plyCoords4.y,plyCoords4.z,x4,y4,z4,false)
		if distance4 <= 10 then
			SetVehicleFuelLevel(vehicle, 0)
			Citizen.Wait(2000)
			DeleteVehicle(vehicle)
			local cid = exports['isPed']:isPed('cid')
			TriggerServerEvent('wrp-driving-instructor:check', cid)
			TriggerEvent('DoLongHudText', 'Congrats, you have obtained a Provisional License.')
           Citizen.Wait(100000000000000000000000)
		end
	end
end)

RegisterNetEvent('Update-Strike')
AddEventHandler('Update-Strike', function()
	strike = strike+1
end)

RegisterNetEvent('wrp-drivinginstructor:fail')
AddEventHandler('wrp-drivinginstructor:fail', function()
	TriggerEvent('DoLongHudText', 'You have failed the driving test for Speeding. Head Back to the DMV or the Police Will be called.')
	SetNewWaypoint(-814.5725, -1347.639)
	TaskVehicleDriveToCoord(PlayerPedId(-1), vehicle, -817.8578, -1331.007, 5.00037, 500.0, 0.0, 'sultan', 1074528293, 15)
	while true do
		Citizen.Wait(20)
		local x4,y4,z4 = -817.8578, -1331.007, 5.00037
		local Playermate4 = PlayerPedId(-1)
		local plyCoords4 = GetEntityCoords(Playermate4)
		local distance4 = GetDistanceBetweenCoords(plyCoords4.x,plyCoords4.y,plyCoords4.z,x4,y4,z4,false)
		if distance4 <= 10 then
			SetVehicleFuelLevel(vehicle, 0)
			Citizen.Wait(2000)
			DeleteVehicle(vehicle)
		end
	end
end)