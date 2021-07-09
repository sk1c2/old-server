BlacklistedWeapons = { -- BL Weapons
	"WEAPON_BALL",
	"WEAPON_RAILGUN",
	"weapon_raypistol",
	"weapon_marksmanpistol",
	"weapon_revolver",
	"weapon_revolver_mk2",
	"weapon_doubleaction",
	"weapon_navyrevolver",
	"weapon_raycarbine",
	"weapon_musket",
	"weapon_heavysniper",
	"weapon_heavysniper_mk2",
	"weapon_marksmanrifle",
	"weapon_marksmanrifle_m",
	"weapon_rpg",
	"weapon_grenadelauncher",
	"weapon_grenadelauncher_smoke",
	"weapon_minigun",
	"weapon_firework",
	"weapon_hominglauncher",
	"weapon_compactlauncher",
	"weapon_rayminigun",
	"weapon_grenade",

}


CageObjs = {
	"prop_gold_cont_01",
	"p_cablecar_s",
	"stt_prop_stunt_tube_l",
	"stt_prop_stunt_track_dwuturn",
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if GetPedArmour(GetPlayerPed(-1)) > 60 then
			SetPedArmour(PlayerPedId(-1), 60)
			Citizen.Wait(1000)
			TriggerServerEvent('prp-ac:sort', source)
			-- TriggerServerEvent('armourlog or something mortal pls')
		end
		ped = GetPlayerPed(-1)
		hash=GetSelectedPedWeapon(ped)
		if GetEntityHealth(GetPlayerPed(-1)) > 200 then
			TriggerServerEvent('prp-ac:sort', source)
			-- TriggerServerEvent('health log over limit or something mortal pls')
		end
		if not IsEntityVisible(PlayerPedId()) then
			SetEntityVisible(PlayerPedId(), true) 
			-- TriggerServerEvent('prp-ac:sort', source)
			-- TriggerServerEvent('invis log or something mortal pls')
		end
		if GetPlayerInvincible(PlayerId()) then
			SetPlayerInvincible(PlayerId(), false)
			-- TriggerServerEvent('prp-ac:sort', source)
			-- TriggerServerEvent('godmode log or something mortal pls')
		end
		-- SetPedInfiniteAmmoClip(PlayerPedId(), false)
		SetEntityInvincible(PlayerPedId(), false)
		SetEntityCanBeDamaged(PlayerPedId(), true)
		ResetEntityAlpha(PlayerPedId())
		local fallin = IsPedFalling(PlayerPedId())
		local ragg = IsPedRagdoll(PlayerPedId())
		local parac = GetPedParachuteState(PlayerPedId())
		if parac >= 0 or ragg or fallin then
			SetEntityMaxSpeed(PlayerPedId(), 80.0)
		else
			SetEntityMaxSpeed(PlayerPedId(), 7.1)
		end
		for _,theWeapon in ipairs(BlacklistedWeapons) do
			Wait(1)
			if HasPedGotWeapon(PlayerPedId(),GetHashKey(theWeapon),false) == 1 then
					TriggerServerEvent('prp-ac:sort', source)
					-- blacklisted weapon log or something mortal pls
					break
			end
		end
	end
end)

RegisterNetEvent("payslip:call")
AddEventHandler("payslip:call", function(cid, amount)
	TriggerServerEvent("payslip:add", cid, amount)
end)	

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        SetRadarBigmapEnabled(false, false) 
    end
end)

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		local plyCoords = GetEntityCoords(PlayerPedId())
		local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z, -1082.81, -248.19, 36.77 ,false)
		if distance <= 1.2 then
            drawTxt('Push ~b~E~s~ to pick up your paycheck!',0,1,0.5,0.8,0.35,255,255,255,255)
            DrawMarker(27,-1082.81, -248.19, 36.77, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0) 
            if IsControlJustReleased(0, 38) then
                local cid = exports["isPed"]:isPed("cid")
                TriggerServerEvent('payslip:get', cid)
			end
		else
			if distance >= 1.2 then
				Citizen.Wait(1000)
				
			end
		end
	end
end)