local plyId
local plyCoords
local blnPlySpawned = false
local crops = {

}

inhouse = false

RegisterNetEvent('prp-weed:inhouse')
AddEventHandler('prp-weed:inhouse', function(st)
if st then 
inhouse = true
TriggerServerEvent('prp-weed:requestTable')
else
inhouse = false
end
end)

local cropstatus = {
	[1] = { ["info"] = "Looks Healthy.", ["itemid"] = 0 },
	[2] = { ["info"] = "Needs Water.", ["itemid"] = 0 },
	[3] = { ["info"] = "Needs Fertiliser.", ["itemid"] = 0 },
}
Controlkey = {["generalUse"] = {38,"E"},["generalUseSecondaryWorld"] = {23,"F"}} 
local tohum

RegisterNetEvent('urp:base:loadplayer')
AddEventHandler('urp:base:loadplayer', function()
 
	TriggerServerEvent("prp-weed:requestTable")
    blnPlySpawned = true
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
    TriggerServerEvent("prp-weed:setStatus2")
    blnPlySpawned = true
    end
  end)

Citizen.CreateThread( function()
	while not blnPlySpawned
	do
		Citizen.Wait(100)
	end
	while true do 
		plyId = PlayerPedId()
		plyCoords = GetEntityCoords(plyId)
		Citizen.Wait(200)
	end
end)

function createTreeObject(num)
	local treeModel = `bkr_prop_weed_med_01b`
	local zm = 3.55
	if (crops[num]["growth"] < 33) then
		zm = 1
		treeModel = `bkr_prop_weed_01_small_01b`
	elseif (crops[num]["growth"] > 66) then
		treeModel = `bkr_prop_weed_lrg_01b`
	end

	RequestModel(treeModel)
	while not HasModelLoaded(treeModel) do
		Citizen.Wait(100)
	end

	local newtree = CreateObject(treeModel,crops[num]["x"],crops[num]["y"],crops[num]["z"]-zm,true,false,false)
	SetEntityCollision(newtree,false,false)
	crops[num]["object"] = newtree
end

function nearMale()

	local answer = false
    local plyId = PlayerPedId()
    local plyCoords = GetEntityCoords(plyId)
	for i = 1, #crops do
    	local dst = #(vector3(crops[i]["x"],crops[i]["y"],crops[i]["z"]) - plyCoords)
    	if dst < 10.0 and crops[i]["strain"] == "Male" then
    		answer = true
    	end
	end
	return answer

end

function canGrown()
local saat =	GetClockHours()
local dk =	GetClockMinutes()
   if saat == 9 and dk == 0 then	
	TriggerServerEvent("prp-weed:setStatus2")
   end
  

end


function InsertPlant(seed)
	if inhouse == true then
		plyId = PlayerPedId()
		local strain = seed
    	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(plyId, 0.0, 0.4, 0.0))
    	TriggerServerEvent("prp-weed:createplant",x,y,z,strain, exports['isPed']:isPed('cid'))
	else
		TriggerEvent('DoLongHudText', 'You cannot do this outside!', 2)
	end
end

function DeleteTrees()
	for i = 1, #crops do
		local ObjectFound = crops[i]["object"]
		if ObjectFound then
			DeleteObject(ObjectFound)
		end
	end
end

RegisterNetEvent("prp-weed:currentcrops")
AddEventHandler("prp-weed:currentcrops", function(result)
	local newcrops = {}
	for i = 1, #result do
        local table = result[i]
        newcrops[i] = {  ["x"] = tonumber(table.x), ["y"] = tonumber(table.y), ["z"] = tonumber(table.z), ["growth"] = tonumber(table.growth), ["strain"] = table.strain, ["status"] = tonumber(table.status), ["dbID"] = tonumber(table.id) }
    end
    DeleteTrees()
  
    crops = newcrops
end)


RegisterNetEvent("prp-weed:startcrop")
AddEventHandler("prp-weed:startcrop", function(seedType)
	print('ok')
    local plyId = PlayerPedId()
    local plyCoords = GetEntityCoords(plyId)
    local Seed = "Kush"
	if seedType == "female" and nearMale() then
		Seed = "Seeded"
	end

	if seedType == "male" then
		Seed = "Male"
	end
    local success = true

    for i = 1, #crops do
    	local dst = #(vector3(crops[i]["x"],crops[i]["y"],crops[i]["z"]) - plyCoords)
		if dst < 1.0 then
			success = false
			
    	end
    end

	if success and Seed == "Male" then
		--TriggerServerEvent("prp-weed:RemoveItem", Config.MaleSeed, 1)
	  -- TriggerServerEvent("prp-weed:RemoveItem", Config.Pot, 1)
	else
	--	TriggerServerEvent("prp-weed:RemoveItem", Config.FemaleSeed, 1)
	   --TriggerServerEvent("prp-weed:RemoveItem", Config.Pot, 1)
	end

	if success then
        InsertPlant(Seed)
    end

end)

RegisterNetEvent("prp-weed:updateplantwithID")
AddEventHandler("prp-weed:updateplantwithID", function(ids,newPercent,status)
	if status == "alter" then
		for i = 1, #crops do
			if(crops[i] ~= nil) then
				if crops[i]["dbID"] == ids then
					crops[i]["growth"] = newPercent
					crops[i]["status"] = 1
				end
			end
		end		
	elseif status == "remove" then

		for i = 1, #crops do
			if(crops[i] ~= nil) then
                if crops[i]["dbID"] == ids then
                  
					table.remove(crops,i)
				end
			end
        end
        
    elseif status == "status" then

        for i = 1, #crops do
            if(crops[i] ~= nil) then
				if crops[i]["dbID"] == ids then
					crops[i]["status"] = newPercent
				end
			end
		end		

	elseif status == "convert" then
		for d = 1, #ids do
			for i = 1, #crops do
				if(crops[i] ~= nil) then
					if crops[i]["dbID"] == ids then
						crops[i]["strain"] = "seeded"
					end
				end
			end
		end
	elseif status == "new" then
		crops[#crops+1] = ids
	end
end)


RegisterNetEvent("weed:giveitems")
AddEventHandler("weed:giveitems", function(strain)

	if strain == "Seeded" then
		TriggerEvent("prp-banned:getID", Config.FemaleSeed,math.random(1,10))
		if math.random(100) < 10 then
	        TriggerEvent("prp-banned:getID",Config.MaleSeed, 1)
	    end    
	else
		if strain == "Male" then
			TriggerEvent("prp-banned:getID", Config.Weed,math.random(3,8))
		else
			TriggerEvent("prp-banned:getID", Config.Weedoz,math.random(1,4))
			Citizen.Wait(500)
			TriggerEvent("prp-banned:getID", Config.Weed,math.random(10,30))
		end
	end
end)

Citizen.CreateThread( function()
    local counter = 0
    local perc = 0
	while true do 

	
		if not inhouse then
			Citizen.Wait(3000)
		else
			Citizen.Wait(0)
			local close = 0
            local dst = 1000.0
			local plyId = PlayerPedId()
	        local plyCoords = GetEntityCoords(plyId)
			for i = 1, #crops do
				local storagedist = #(vector3(crops[i]["x"],crops[i]["y"],crops[i]["z"]) - plyCoords)
				if storagedist < 80.0 then
					if storagedist < dst then
						dst = storagedist
						close = i
					end
					if crops[i]["object"] == nil then
						createTreeObject(i)
					elseif crops[i]["object"] then
						if not DoesEntityExist(crops[i]["object"]) then
							createTreeObject(i)
						end					
					end
				else
					if crops[i]["object"] then
						DeleteObject(crops[i]["object"])
						crops[i]["object"] = nil
					end
				end
			end

			if counter > 0 then
				counter = counter - 1
			end
			if dst > 80.0 then
				if counter > 0 or counter < 0 then
					counter = 0
				end
				Citizen.Wait(math.ceil(dst*3))
			else
				if #(vector3(crops[close]["x"],crops[close]["y"],crops[close]["z"]-0.3) - plyCoords) < 1.0 then
                    local num = tonumber(crops[close]["status"])
                    if crops[close]["strain"] == "Male" then
                        tohum = "Male"
                    elseif crops[close]["strain"] == "Seeded" then
                        tohum = "Male and Female"
                    elseif crops[close]["strain"] == "Female" then
                        tohum = "Female"
                    elseif crops[close]["strain"] == "Kush" then
                        tohum = "Parsley"
                    end
                    if crops[close]["growth"] > 100 then
                        perc = 100
                    else
                        perc = crops[close]["growth"]
                    end
					DrawText3Ds( crops[close]["x"],crops[close]["y"], crops[close]["z"] , "["..Controlkey["generalUse"][2].."] " .. tohum .. " Seed @ " .. perc .. "% - " .. cropstatus[num]["info"])
					if IsControlJustReleased(2, Controlkey["generalUse"][1]) and #(vector3(crops[close]["x"],crops[close]["y"],crops[close]["z"]-0.3) - plyCoords) < 2.0 and counter == 0 then
						if crops[close]["growth"] >= 100 then
							local plyPed = GetPlayerPed(-1)
							exports["prp-taskbar"]:taskBar(20000,"Harvesting")
							TaskStartScenarioInPlace(plyPed, "PROP_HUMAN_BUM_BIN", 0, true)
							TaskStartScenarioInPlace(plyPed, "PROP_HUMAN_BUM_BIN", 0, false)
							Wait(100)
							ClearPedTasksImmediately(plyPed)
                            TriggerServerEvent("prp-weed:requestTable")
							TriggerServerEvent("prp-weed:killplant",crops[close]["dbID"])
							TriggerEvent("weed:giveitems",crops[close]["strain"])
						else
							if crops[close]["status"] == 1 then
								TriggerEvent("DoLongHudText", "This plant does not need any further attention!", 1)
							else
								if crops[close]["strain"] == "Seeded" then
									if exports['prp-inventory']:hasEnoughOfItem('fertilizer', 1) then
										TriggerEvent('inventory:removeItem', 'fertilizer', 1)
											if exports['prp-inventory']:hasEnoughOfItem('fertilizer', 1) then 
											ClearPedSecondaryTask(PlayerPedId())
											loadAnimDict( "mp_arresting" ) 
                        					TaskPlayAnim( PlayerPedId(), "mp_arresting", "a_uncuff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
											local finished = exports["prp-taskbar"]:taskBar(5000,"Fertilising the Plant")
											Citizen.Wait(100)
											ClearPedTasks(PlayerPedId())    
											if math.random(100) > 85 then
											TriggerEvent("DoLongHudText", "You fertilised the plant!", 1)
											end
											local new = crops[close]["growth"] + math.random(25,45)
											TriggerServerEvent("prp-weed:UpdateWeedGrowth",crops[close]["dbID"],new)
											TriggerServerEvent('prp-weed:Use-Fertiliser')
										else
											TriggerEvent("DoLongHudText", "You need fertiliser to do this!", 1)
                                    end
                                end
                                else
									if exports['prp-inventory']:hasEnoughOfItem('water', 1) then
                                    -- if qtty >= 1 then  
									TriggerEvent('inventory:removeItem', 'water', 1)
									loadAnimDict( "mp_arresting" ) 
									TaskPlayAnim( PlayerPedId(), "mp_arresting", "a_uncuff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
									local finished = exports["prp-taskbar"]:taskBar(5000,"Giving Plant Water")
									Citizen.Wait(100)
									ClearPedTasks(PlayerPedId())    
									local new = crops[close]["growth"] + math.random(14,17)
									TriggerServerEvent("prp-weed:UpdateWeedGrowth",crops[close]["dbID"],new)
									TriggerServerEvent('prp-weed:Use-Water')
									else
									TriggerEvent("DoLongHudText", "You need 1 bottle of water to do this!", 1)
                                    end
                                end
							end
						end
						counter = 200
					end
				end
			end
		end
	
	end
end)
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end


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