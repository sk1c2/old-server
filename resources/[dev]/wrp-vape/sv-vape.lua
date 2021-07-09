RegisterNetEvent("Vape:Coil")
RegisterServerEvent("eff_smokes")

-- if Config.VapePermission == true then
-- 	RegisterCommand("vape", function(source, args, rawCommand)
-- 		if IsPlayerAceAllowed(source, Config.PermissionsGroup) then
-- 			if (tostring(args[1]) == "start") then
-- 				TriggerClientEvent("Vape:StartVaping", source, 0)
-- 			elseif (tostring(args[1]) == "stop") then
-- 				TriggerClientEvent("Vape:StopVaping", source, 0)
-- 			elseif (tostring(args[1])) ~= nil then
-- 				TriggerClientEvent("chatMessage", source, "^1 Vaping: Error, Wrong Command must use /vape <start/stop>")
-- 			end
-- 			if Config.Debug then
-- 				if (tostring(args[1]) == "fix") then
-- 					TriggerClientEvent("Vape:VapeAnimFix", source, 0)
-- 				elseif (tostring(args[1]) == "drag") then
-- 					TriggerClientEvent("Vape:Drag", source, 0)
-- 				end
-- 			end
-- 		else
-- 			TriggerClientEvent("chatMessage", source, Config.InsufficientMessage)
-- 		end
-- 	end)
-- else
-- 	RegisterCommand("vape", function(source, args, rawCommand)
-- 		if (tostring(args[1]) == "start") then
-- 			TriggerClientEvent("Vape:StartVaping", source, 0)
-- 		elseif (tostring(args[1]) == "stop") then
-- 			TriggerClientEvent("Vape:StopVaping", source, 0)
-- 		elseif (tostring(args[1])) ~= nil then
-- 			TriggerClientEvent("chatMessage", source, "^1 Vaping: Error, Wrong Command must use /vape <start/stop>")
-- 		end
-- 		if Config.Debug then
-- 			if (tostring(args[1]) == "fix") then
-- 				TriggerClientEvent("Vape:VapeAnimFix", source, 0)
-- 			elseif (tostring(args[1]) == "drag") then
-- 				TriggerClientEvent("Vape:Drag", source, 0)
-- 			end
-- 		end
-- 	end)
-- end

AddEventHandler("eff_smokes", function(entity)
	TriggerClientEvent("c_eff_smokes", -1, entity)
end)