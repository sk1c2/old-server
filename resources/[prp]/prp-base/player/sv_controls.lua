RegisterServerEvent("wrp-base:sv:player_control_set")
AddEventHandler("wrp-base:sv:player_control_set", function(controlTable)
	local src = source
	URP.DB:UpdateControls(src,controlTable,function(updatedControls, err)
		if updatedControls then
			-- we are good here.
		end
	end)
end)

RegisterServerEvent("wrp-base:sv:player_control")
AddEventHandler("wrp-base:sv:player_control", function()
	local src = source
	URP.DB:GetControls(src,function(LoadedControls, err)
		if loadedControls ~= nil then TriggerClientEvent("wrp-base:cl:player_control",src,json.decode(loadedControls)) else TriggerClientEvent("wrp-base:cl:player_control",src,nil) end
	end)
end)
