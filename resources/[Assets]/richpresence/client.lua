-- SetDiscordAppId(759084867936976918)

-- SetDiscordRichPresenceAsset('logo-white')



-- local WaitTime = 1000 -- How often do you want to update the status (In MS)



-- -- Citizen.CreateThread(function()

-- -- 	while true do

-- -- 		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))

-- -- 		local StreetHash = GetStreetNameAtCoord(x, y, z)



-- -- 	    local onlinePlayers = 0

-- -- 		for i = 0, 255 do

-- -- 			if NetworkIsPlayerActive(i) then

-- -- 				onlinePlayers = onlinePlayers+1.5

-- -- 			end

-- -- 		end

-- -- 		Citizen.Wait(WaitTime)

-- -- 		if StreetHash ~= nil then

-- -- 			StreetName = GetStreetNameFromHashKey(StreetHash)

-- -- 			if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
-- -- 				  if not IsEntityInArea(PlayerPedId(),2631.851,2572.982,45.096,-2449.445,711.613,264.987,false,false,0) then
-- -- 				  end
-- -- 				end
-- -- 			end

-- --            if IsPedSprinting(PlayerPedId()) then
-- -- 				SetRichPresence(onlinePlayers.."/50 | Eating Chicken")

-- -- 		   elseif IsPedRunning(PlayerPedId()) then
-- -- 				SetRichPresence(onlinePlayers.."/50 | Roleplaying")

-- -- 		   elseif IsPedWalking(PlayerPedId()) then
-- -- 				SetRichPresence(onlinePlayers.."/50 | Hardcore ERP\'ing")

-- -- 		   elseif IsPedStill(PlayerPedId()) then
-- -- 				SetRichPresence(onlinePlayers.."/50 | Having Fun")
-- -- 		   end
-- -- 		end
-- -- 	end
-- -- end)

-- -- Citizen.CreateThread(function()
-- --     SetDiscordAppId(759084867936976918)

-- -- 	SetDiscordRichPresenceAsset('logo-white')
-- -- 	while true do
-- -- 		local onlinePlayers = 0

-- -- 		for i = 0, 255 do

-- -- 			if NetworkIsPlayerActive(i) then

-- -- 				onlinePlayers = onlinePlayers+1

-- -- 			end

-- -- 		end
-- --         local player = GetPlayerPed(-1)
-- --         Citizen.Wait(5*1000)

-- --         -- Where the player is located
-- --         SetRichPresence(onlinePlayers.."/100 | Eating Chicken")
-- -- 		Citizen.Wait(2000)
-- -- 		SetRichPresence(onlinePlayers.."/100 | Roleplaying")
-- -- 		Citizen.Wait(2000)
-- -- 		SetRichPresence(onlinePlayers.."/100 | Hardcore ERP\'ing")
-- -- 		Citizen.Wait(2000)
-- -- 		SetRichPresence(onlinePlayers.."/100 | Having Fun")

-- --         SetDiscordRichPresenceAssetSmall("logo") -- The name of the small picture you added in the application.
-- --         SetDiscordRichPresenceAssetSmallText("Discord: discord.me/unityrp")
-- -- 		SetDiscordRichPresenceAction(0, "Join Now", "https://discord.gg/quB8t8m4XY")

-- -- 	end
-- -- end)

-- RegisterNetEvent("wrp-scoreboard:playerscount")
-- AddEventHandler("wrp-scoreboard:playerscount", function(a)
--     SetRichPresence(a .. "/128 | Eating Chicken")
--     SetDiscordAppId(759084867936976918)
--     SetDiscordRichPresenceAsset('logo-white')
-- 	SetDiscordRichPresenceAssetSmall("logo") -- The name of the small picture you added in the application.
-- 	SetDiscordRichPresenceAssetSmallText("Discord: discord.gg/HjVxvhJRzc")
-- 	SetDiscordRichPresenceAction(0, "Join Now", "https://discord.gg/HjVxvhJRzc")
-- 	Citizen.Wait(2000)
-- 	SetRichPresence(a .."/128 | Roleplaying")
-- 	Citizen.Wait(2000)
-- 	SetRichPresence(a .."/128 | Hardcore ERP\'ing")
-- 	Citizen.Wait(2000)
-- 	SetRichPresence(a .."/128 | Having Fun")
-- end)

