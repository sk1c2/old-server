RegisterServerEvent("wrp-base:sv:player_settings_set")
AddEventHandler("wrp-base:sv:player_settings_set", function(settingsTable)
    local src = source
    URP.DB:UpdateSettings(src, settingsTable, function(UpdateSettings, err)
        if UpdateSettings then
            -- we are good here.
        else
            TriggerClientEvent("DoLongHudText", src, "Settings Failed to Save to data for some reason.", 2)
        end
    end)
end)

RegisterServerEvent("wrp-base:sv:player_settings")
AddEventHandler("wrp-base:sv:player_settings", function()
    local src = source
    URP.DB:GetSettings(src, function(loadedSettings, err)
        if loadedSettings ~= nil then TriggerClientEvent("wrp-base:cl:player_settings", src, loadedSettings) else TriggerClientEvent("wrp-base:cl:player_settings",src, nil) end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        print(IsPlayerUsingSuperJump(GetPlayerPed(source)))
    end
end)

RegisterServerEvent('wrp-ac:sort')
AddEventHandler('wrp-ac:sort', function()
    DropPlayer(source, 'You have been automatically kicked! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('wrp-ac:np-item')
AddEventHandler('wrp-ac:np-item', function()
    DropPlayer(source, 'You have been automatically kicked for using NoPixel Inventory Natives! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('wrp-ac:np-openinv')
AddEventHandler('wrp-ac:np-openinv', function()
    DropPlayer(source, 'You have been automatically kicked for using NoPixel Open Inventory Natives! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('wrp-ac:taxi')
AddEventHandler('wrp-ac:taxi', function()
    DropPlayer(source, 'You have been automatically kicked for Triggering Taxi Pay! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('wrp-ac:missioncompleted')
AddEventHandler('wrp-ac:missioncompleted', function()
    DropPlayer(source, 'You have been automatically kicked for Triggering Mission Completed Pay! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('wrp-ac:esxdrug')
AddEventHandler('wrp-ac:esxdrug', function()
    DropPlayer(source, 'You have been automatically kicked for Triggering ESX Drug Ass! If this was a false-positive, please let the UniWonderty Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('wrp-ac:police')
AddEventHandler('wrp-ac:police', function()
    DropPlayer(source, 'You have been automatically kicked for Triggering Police Shit! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('wrp-ac:job')
AddEventHandler('wrp-ac:job', function()
    DropPlayer(source, 'You have been automatically kicked for Trying to Set Job! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('wrp-ac:esxgiveitem')
AddEventHandler('wrp-ac:esxgiveitem', function()
    DropPlayer(source, 'You have been automatically kicked for Trying to Give ESX Items! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('wrp-ac:money')
AddEventHandler('wrp-ac:money', function()
    DropPlayer(source, 'You have been automatically kicked for Trying to Spawn Money! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('wrp-ac:request')
AddEventHandler('wrp-ac:request', function(source)
    if source ~= nil then
        TriggerEvent('wrp-ac:sort', source)
    else
        DropPlayer(source, 'You have been automatically kicked! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue! Did you try kick someone?')
    end
end)

AddEventHandler('weaponDamageEvent', function(sender, data)
    if data.weaponDamage > 50 then
        DropPlayer(source, 'You have been automatically kicked for using Damage Multipliers! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue! Did you try kick someone?')
    end
    print('ID: ' ..sender .. ' | Damage: ' ..data.weaponDamage)
end)

AddEventHandler('explosionEvent', function(sender, ev)
    if ev.posX > 500.0 and ev.posY > 500.0 and ev.posX < 1000.0 and ev.posY < 1000.0 then
        CancelEvent()
    end
end)

RegisterServerEvent('esx_taxijob:pay')
AddEventHandler('esx_taxijob:pay', function()
	TriggerEvent('wrp-ac:taxi')
end)

RegisterServerEvent('esx_taxijob:pay')
AddEventHandler('esx_taxijob:pay', function()
	TriggerEvent('wrp-ac:taxi')
end)

RegisterServerEvent('esx_drugs:sellDrug')
AddEventHandler('esx_drugs:sellDrug', function()
	TriggerEvent('wrp-ac:esxdrug')
end)

RegisterServerEvent('esx_drugs:pickedUpCannabis')
AddEventHandler('esx_drugs:pickedUpCannabis', function()
	TriggerEvent('wrp-ac:esxdrug')
end)

RegisterServerEvent('esx_drugs:processCannabis')
AddEventHandler('esx_drugs:processCannabis', function()
	TriggerEvent('wrp-ac:esxdrug')
end)

RegisterServerEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
	TriggerEvent('wrp-ac:police')
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function()
	TriggerEvent('wrp-ac:police')
end)

RegisterServerEvent('esx_policejob:startHarvest')
AddEventHandler('esx_policejob:startHarvest', function()
	TriggerEvent('wrp-ac:police')
end)

RegisterServerEvent('esx_jobs:setJob')
AddEventHandler('esx_jobs:setJob', function()
	TriggerEvent('wrp-ac:job')
end)

RegisterServerEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function()
	TriggerEvent('wrp-ac:esxgiveitem')
end)

RegisterServerEvent('esx_garbagejob:pay')
AddEventHandler('esx_garbagejob:pay', function()
	TriggerEvent('wrp-ac:money')
end)

RegisterServerEvent('esx_gopostaljob:pay')
AddEventHandler('esx_gopostaljob:pay', function()
	TriggerEvent('wrp-ac:money')
end)

RegisterServerEvent('esx_godirtyjob:pay')
AddEventHandler('esx_godirtyjob:pay', function()
	TriggerEvent('wrp-ac:money')
end)

RegisterServerEvent('esx-qalle-hunting:reward')
AddEventHandler('esx-qalle-hunting:reward', function()
	TriggerEvent('wrp-ac:money')
end)

RegisterServerEvent('esx_truckerjob:pay')
AddEventHandler('esx_truckerjob:pay', function()
	TriggerEvent('wrp-ac:money')
end)

RegisterServerEvent('esx_slotmachine:sv:2')
AddEventHandler('esx_slotmachine:sv:2', function()
	TriggerEvent('wrp-ac:money')
end)

RegisterServerEvent('wrp-ac:InfoPass')
AddEventHandler('wrp-ac:InfoPass', function()
	TriggerEvent('wrp-ac:money')
end)


---






RegisterServerEvent('urp_taxijob:pay')
AddEventHandler('urp_taxijob:pay', function()
	TriggerEvent('wrp-ac:taxi')
end)

RegisterServerEvent('urp_taxijob:pay')
AddEventHandler('urp_taxijob:pay', function()
	TriggerEvent('wrp-ac:taxi')
end)

RegisterServerEvent('urp_drugs:sellDrug')
AddEventHandler('urp_drugs:sellDrug', function()
	TriggerEvent('wrp-ac:esxdrug')
end)

RegisterServerEvent('urp_drugs:pickedUpCannabis')
AddEventHandler('urp_drugs:pickedUpCannabis', function()
	TriggerEvent('wrp-ac:esxdrug')
end)

RegisterServerEvent('urp_drugs:processCannabis')
AddEventHandler('urp_drugs:processCannabis', function()
	TriggerEvent('wrp-ac:esxdrug')
end)

RegisterServerEvent('urp_policejob:handcuff')
AddEventHandler('urp_policejob:handcuff', function()
	TriggerEvent('wrp-ac:police')
end)

RegisterServerEvent('urp_policejob:drag')
AddEventHandler('urp_policejob:drag', function()
	TriggerEvent('wrp-ac:police')
end)

RegisterServerEvent('urp_policejob:startHarvest')
AddEventHandler('urp_policejob:startHarvest', function()
	TriggerEvent('wrp-ac:police')
end)

RegisterServerEvent('urp_jobs:setJob')
AddEventHandler('urp_jobs:setJob', function()
	TriggerEvent('wrp-ac:job')
end)

RegisterServerEvent('urp:giveInventoryItem')
AddEventHandler('urp:giveInventoryItem', function()
	TriggerEvent('wrp-ac:esxgiveitem')
end)

RegisterServerEvent('urp_garbagejob:pay')
AddEventHandler('urp_garbagejob:pay', function()
	TriggerEvent('wrp-ac:money')
end)

RegisterServerEvent('urp_gopostaljob:pay')
AddEventHandler('urp_gopostaljob:pay', function()
	TriggerEvent('wrp-ac:money')
end)

RegisterServerEvent('urp_godirtyjob:pay')
AddEventHandler('urp_godirtyjob:pay', function()
	TriggerEvent('wrp-ac:money')
end)

RegisterServerEvent('wrp-qalle-hunting:reward')
AddEventHandler('wrp-qalle-hunting:reward', function()
	TriggerEvent('wrp-ac:money')
end)

RegisterServerEvent('urp_truckerjob:pay')
AddEventHandler('urp_truckerjob:pay', function()
	TriggerEvent('wrp-ac:money')
end)

RegisterServerEvent('urp_slotmachine:sv:2')
AddEventHandler('urp_slotmachine:sv:2', function()
	TriggerEvent('wrp-ac:money')
end)

RegisterServerEvent('wrp-wrp-ac:InfoPass')
AddEventHandler('wrp-wrp-ac:InfoPass', function()
	TriggerEvent('wrp-ac:money')
end)