safeLocations = {
    [1] = {x = 1959.2476806641, y = 3748.8317871094, z = 32.343784332275, h = 28.119842529297, robbed = false},
    [2] = {x = 546.35992431641, y = 2662.9340820312, z = 42.156490325928, h = 190.7907409668, robbed = false},
    [3] = {x = 2549.2868652344, y = 384.92218017578, z = 108.62294769287, h = 79.970840454102, robbed = false},
    [4] = {x = -1829.0267333984, y = 798.95819091797, z = 138.18653869629, h = 130.54249572754, robbed = false},
    [5] = {x = -709.6171875, y = -904.21710205078, z = 19.215591430664, h = 84.96849822998, robbed = false},
    [6] = {x = 28.248321533203, y = -1339.2667236328, z = 29.497024536133, h = 358.12371826172, robbed = false},
    [7] = {x = -43.278358459473, y = -1748.4860839844, z = 29.421016693115, h = 46.865802764893, robbed = false},
    [8] = {x = 378.19577026367, y = 333.39080810547, z = 103.56645202637, h = 341.65612792969, robbed = false},
    [9] = {x = 1734.8654785156, y = 6420.84765625, z = 35.037273406982, h = 332.01058959961, robbed = false},
    [10] = {x = 1707.8552246094, y = 4920.3173828125, z = 42.063632965088, h = 319.1520690918, robbed = false}
}

storeLocations = {
    [1] = {x = 1959.8237304688, y = 3740.5344238281, z = 32.343746185303, h = 301.94995117188, recent = false},
    [2] = {x = 549.17236328125, y = 2671.0297851562, z = 42.156532287598, h = 98.538436889648, recent = false},
    [3] = {x = 2556.6574707031, y = 380.72537231445, z = 108.62294769287, h = 1.8275666236877, recent = false},
    [4] = {x = -1819.5952148438, y = 793.84417724609, z = 138.08393859863, h = 131.23713684082, recent = false},
    [5] = {x = -705.96209716797, y = -914.01135253906, z = 19.215604782104, h = 87.027084350586, recent = false},
    [6] = {x = 24.478902816772, y = -1346.6854248047, z = 29.497020721436, h = 273.12100219727, recent = false},
    [7] = {x = -46.944438934326, y = -1758.2592773438, z = 29.42099571228, h = 53.93285369873, recent = false},
    [8] = {x = 372.67413330078, y = 327.03234863281, z = 103.56639099121, h = 259.80465698242, recent = false},
    [9] = {x = 1728.0157470703, y = 6415.7255859375, z = 35.037220001221, h = 250.05892944336, recent = false},
    [10] = {x = 1697.6986083984, y = 4923.0517578125, z = 42.06364440918, h = 321.22326660156, recent = false}
}

storeId = 0
isLockpicking = false

RegisterNetEvent('wrp-robbery:advLockpickUse')
AddEventHandler('wrp-robbery:advLockpickUse', function()
	if exports['isPed']:isPed('curPolice') >= 2 then
		if isLockpicking then return end
		local cStoreId = GetStoreId()


		if cStoreId ~= false then
			local sCoords = safeLocations[cStoreId]

			if #(vector3(sCoords['x'], sCoords['y'], sCoords['z']) - GetEntityCoords(PlayerPedId())) < 3.0 then
				TriggerServerEvent('wrp-robbery:attemptSafeRobbery', cStoreId)
				return
			end

			local pCoords = GetEntityCoords(PlayerPedId())

			local rObject = GetClosestObjectOfType(pCoords, 2.0, 303280717, 0, 0, 0)
			local rSpot = GetOffsetFromEntityInWorldCoords(rObject, 0.0, -0.6, 0.0)

			if #(rSpot - pCoords) > 1.0 then
				TriggerEvent('DoLongHudText', 'You must be facing the front of the register to do this.')
				isLockpicking = false
				return
			end

			if rObject then
				local oHeading = GetEntityHeading(rObject)
				local pHeading = GetEntityHeading(PlayerPedId())
				if oHeading - pHeading > 20.0 and oHeading - pHeading < 340.0 then
					TriggerEvent('DoLongHudText', 'You must be facing register to do this.')
					isLockpicking = false
					return
				end
				TriggerServerEvent('wrp-robbery:attemptRegisterRobbery', cStoreId, rObject)
				TriggerEvent('urp:alert:storerobbery')
				return
			end
		end
	else
		TriggerEvent('DoLongHudText', 'Not enough cops online', 2)
	end
end)

RegisterNetEvent('wrp-robbery:registerRobbery')
AddEventHandler('wrp-robbery:registerRobbery', function()
    isLockpicking = true
    local finished = exports['wrp-taskbar']:taskBar(2500, 'Robbing Register')

    if finished == 100 then
        isLockpicking = false
        storeRegisterLoot()
    end

end)

RegisterNetEvent('wrp-robbery:safeRobbery')
AddEventHandler('wrp-robbery:safeRobbery', function()
    isLockpicking = true
    local finished = exports['wrp-taskbar']:taskBar(4000, 'Robbing Safe')

    if finished == 100 then
        isLockpicking = false
        storeSafeLoot()
		TriggerEvent('urp:alert:storerobbery')
    end

end)



function storeRegisterLoot()
    TriggerEvent("wrp-banned:getID", "rollcash", math.random(15))
end

function storeSafeLoot()
	TriggerEvent('urp:alert:storerobbery')
    if math.random(20) > 15 then
        if math.random(100) > 70 then
            TriggerEvent("wrp-banned:getID", "Gruppe6Card", 1)
        else
            TriggerServerEvent('store:give', math.random(40,60))
        end
    else
        TriggerEvent("wrp-banned:getID", "band", math.random(5,20))
    end

    if math.random(30) > 16 then
        TriggerEvent("wrp-banned:getID", "securityblue", 1)
    end

	if math.random(30) > 15 then
        TriggerEvent("wrp-banned:getID", "Gruppe6Card3", 1)
    end

    TriggerEvent("wrp-banned:getID", "rollcash", math.random(20))
end

function GetStoreId()
    local dMin = 999.0

    for i = 1, #storeLocations do
        local dst = #(GetEntityCoords(PlayerPedId()) - vector3(storeLocations[i]['x'], storeLocations[i]['y'], storeLocations[i]['z']))
        if dst < dMin then
            dMin = dst
            storeId = i
        end
    end

    if dMin < 20.0 then
        return storeId
    else
        return false
    end
end



RegisterNetEvent('giveLootSafe')
AddEventHandler('giveLootSafe', function()
    storeSafeLoot()
end)

RegisterNetEvent('wrp-robbery:regSuccess')
AddEventHandler('wrp-robbery:regSuccess', function()
    TriggerEvent('safecracking:loop', 3, 'giveLootReg')
end)

RegisterNetEvent('giveLootReg')
AddEventHandler('giveLootReg', function()
    storeRegisterLoot()
end)

RegisterNetEvent('wrp-robbery:safeSuccess')
AddEventHandler('wrp-robbery:safeSuccess', function()
    TriggerEvent('safecracking:loop', 6, 'giveLootSafe')
	TriggerEvent('urp:alert:storerobbery')
end)

-- Shit Code Below This Point, Beware




cracking = false
RegisterNetEvent("safecracking:loop")
AddEventHandler("safecracking:loop", function(difficulty,functionName)
	loadSafeTexture()
	loadSafeAudio()
	difficultySetting = {}
	for z = 1, difficulty do
		difficultySetting[z] = 1
	end
	curLock = 1
	factor = difficulty
	i = 0.0
	safelock = 0
	desirednum = math.floor(math.random(99))
	if desirednum == 0 then desirednum = 1 end
	openString = "lock_open"
	closedString = "lock_closed"
	cracking = true
	mybasepos = GetEntityCoords(PlayerPedId())
	dicks = 1
	local pinfall = false

	TriggerEvent("DoLongHudText","Press Shift+F or F to rotate, H to crack!")

	while cracking do

		 
		DisableControlAction(38, 0, true)
		DisableControlAction(44, 0, true)
		DisableControlAction(74, 0, true)

		if IsControlPressed(1, 21) and IsControlPressed(1, 23) then
			if dicks > 1 then
				i = i + 1.8
				PlaySoundFrontend( 0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", true );

				dicks = 0
				crackingsafeanim(1)
			end
		end

		if IsControlPressed(1, 23) then

			if dicks > 1 then
				i = i - 1.8
				PlaySoundFrontend( 0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", true );
				dicks = 0
				crackingsafeanim(1)
			end
		end

		dicks = dicks + 0.2
		Citizen.Wait(1)

		if i < 0.0 then i = 360.0 end
		if i > 360.0 then i = 0.0 end

		safelock = math.floor(100-(i / 3.6))

		if #(mybasepos - GetEntityCoords(PlayerPedId())) > 1 or curLock > difficulty then
			cracking = false
		end

		if IsDisabledControlPressed(1, 74) and safelock ~= desirednum then
			Citizen.Wait(1000)
		end

		if safelock == desirednum then

			if not pinfall then
				PlaySoundFrontend( 0, "TUMBLER_PIN_FALL", "SAFE_CRACK_SOUNDSET", true );
				pinfall = true
			end

			if IsDisabledControlPressed(1, 74) then
				pinfall = false
				PlaySoundFrontend( 0, "TUMBLER_RESET", "SAFE_CRACK_SOUNDSET", true );
				factor = factor / 2
				i = 0.0
				safelock = 0
				desirednum = math.floor(math.random(99))
				crackingsafeanim(3)
				if desirednum == 0 then desirednum = 1 end
				difficultySetting[curLock] = 0
				curLock = curLock + 1
			end

		else
			pinfall = false
		end

		DrawSprite( "MPSafeCracking", "Dial_BG", 0.65, 0.5, 0.18, 0.32, 0, 255, 255, 211, 255 )
		DrawSprite( "MPSafeCracking", "Dial", 0.65, 0.5, 0.09, 0.16, i, 255, 255, 211, 255 )



		addition = 0.45
		xaddition = 0.58
		for x = 1, difficulty do

			if difficultySetting[x] ~= 1 then
				DrawSprite( "MPSafeCracking", openString, xaddition, addition, 0.012, 0.024, 0, 255, 255, 211, 255 )
			else
				DrawSprite( "MPSafeCracking", closedString, xaddition, addition, 0.012, 0.024, 0, 255, 255, 211, 255 )
			end

			addition = addition + 0.05

			if x == 10 or x == 20 or x == 30 then
				addition = 0.25
				xaddition = xaddition + 0.05
			end

		end

		--factor = factor / factor
		-- if factor < 1 then factor = 0.5 end

	end

	if curLock > difficulty then
		TriggerEvent(functionName)
	end
	TriggerEvent("robbery:register:finishedLockpick")
	resetAnim()

end)

RegisterNetEvent("safecracking:loop2")
AddEventHandler("safecracking:loop2", function(difficulty,functionName)
	loadSafeTexture()
	loadSafeAudio()
	difficultySetting = {}
	for z = 1, difficulty do
		difficultySetting[z] = 1
	end
	curLock = 1
	factor = difficulty
	i = 0.0
	safelock = 0
	desirednum = math.floor(math.random(99))
	if desirednum == 0 then desirednum = 1 end
	openString = "lock_open"
	closedString = "lock_closed"
	cracking = true
	mybasepos = GetEntityCoords(PlayerPedId())
	dicks = 1
	local pinfall = false

	TriggerEvent("DoLongHudText","Press Shift+F or F to rotate, H to crack!")

	while cracking do

		 
		DisableControlAction(38, 0, true)
		DisableControlAction(44, 0, true)
		DisableControlAction(74, 0, true)

		if IsControlPressed(1, 21) and IsControlPressed(1, 23) then
			if dicks > 1 then
				i = i + 1.8
				PlaySoundFrontend( 0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", true );

				dicks = 0
				crackingsafeanim(1)
			end
		end

		if IsControlPressed(1, 23) then

			if dicks > 1 then
				i = i - 1.8
				PlaySoundFrontend( 0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", true );
				dicks = 0
				crackingsafeanim(1)
			end
		end

		dicks = dicks + 0.2
		Citizen.Wait(1)

		if i < 0.0 then i = 360.0 end
		if i > 360.0 then i = 0.0 end

		safelock = math.floor(100-(i / 3.6))

		if #(mybasepos - GetEntityCoords(PlayerPedId())) > 1 or curLock > difficulty then
			cracking = false
		end

		if IsDisabledControlPressed(1, 74) and safelock ~= desirednum then
			Citizen.Wait(1000)
		end

		if safelock == desirednum then

			if not pinfall then
				PlaySoundFrontend( 0, "TUMBLER_PIN_FALL", "SAFE_CRACK_SOUNDSET", true );
				pinfall = true
			end

			if IsDisabledControlPressed(1, 74) then
				pinfall = false
				PlaySoundFrontend( 0, "TUMBLER_RESET", "SAFE_CRACK_SOUNDSET", true );
				factor = factor / 2
				i = 0.0
				safelock = 0
				desirednum = math.floor(math.random(99))
				crackingsafeanim(3)
				if desirednum == 0 then desirednum = 1 end
				difficultySetting[curLock] = 0
				curLock = curLock + 1
			end

		else
			pinfall = false
		end

		DrawSprite( "MPSafeCracking", "Dial_BG", 0.65, 0.5, 0.18, 0.32, 0, 255, 255, 211, 255 )
		DrawSprite( "MPSafeCracking", "Dial", 0.65, 0.5, 0.09, 0.16, i, 255, 255, 211, 255 )



		addition = 0.45
		xaddition = 0.58
		for x = 1, difficulty do

			if difficultySetting[x] ~= 1 then
				DrawSprite( "MPSafeCracking", openString, xaddition, addition, 0.012, 0.024, 0, 255, 255, 211, 255 )
			else
				DrawSprite( "MPSafeCracking", closedString, xaddition, addition, 0.012, 0.024, 0, 255, 255, 211, 255 )
			end

			addition = addition + 0.05

			if x == 10 or x == 20 or x == 30 then
				addition = 0.25
				xaddition = xaddition + 0.05
			end

		end

		--factor = factor / factor
		-- if factor < 1 then factor = 0.5 end

	end

	FreezeEntityPosition(GetPlayerPed(-1), false)
	local luckhehe = math.random(1,5)
	if luckhehe == 1 then
		TriggerEvent('wrp-ac:InfoPass', math.random(50,250))
	end
	if luckhehe == 2 then
		TriggerEvent( "wrp-banned:getID", "453432689", 1 )
	end
	if luckhehe == 3 then
		TriggerEvent( "wrp-banned:getID", "joint", math.random(1,2))
	end
	if luckhehe == 4 then
		TriggerEvent( "wrp-banned:getID", "oxy", math.random(1,2) )
	end
	if luckhehe == 5 then
		TriggerEvent( "wrp-banned:getID", "pistolammo", math.random(1,2) )
	end
	resetAnim()

end)

animsIdle = {}
animsIdle[1] = "idle_base"
animsIdle[2] = "idle_heavy_breathe"
animsIdle[3] = "idle_look_around"

animsSucceed = {}
animsSucceed[1] = "dial_turn_succeed_1"
animsSucceed[2] = "dial_turn_succeed_2"
animsSucceed[3] = "dial_turn_succeed_3"
animsSucceed[4] = "dial_turn_succeed_4"


function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function resetAnim()
	 local player = GetPlayerPed( -1 )
	ClearPedSecondaryTask(player)
end

function crackingsafeanim(animType)
    local player = GetPlayerPed( -1 )
  	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
        loadAnimDict( "mini@safe_cracking" )


        if animType == 1 then

			if IsEntityPlayingAnim(player, "mini@safe_cracking", "dial_turn_anti_fast_1", 3) then
				--ClearPedSecondaryTask(player)
			else
				TaskPlayAnim(player, "mini@safe_cracking", "dial_turn_anti_fast_1", 8.0, -8, -1, 49, 0, 0, 0, 0)
			end	

	    end

        if animType == 2 then
	        TaskPlayAnim( player, "mini@safe_cracking", animsIdle[math.floor(math.ceil(4))], 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
	    end

        if animType == 3 then
	        TaskPlayAnim( player, "mini@safe_cracking", animsSucceed[math.floor(math.ceil(4))], 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
	    end	

    end
end

function loadSafeTexture()
	RequestStreamedTextureDict( "MPSafeCracking", false );
	while not HasStreamedTextureDictLoaded( "MPSafeCracking" ) do
		Citizen.Wait(0)
	end
end

function loadSafeAudio()
	RequestAmbientAudioBank( "SAFE_CRACK", false )
end