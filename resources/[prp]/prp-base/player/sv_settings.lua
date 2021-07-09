RegisterServerEvent("prp-base:sv:player_settings_set")
AddEventHandler("prp-base:sv:player_settings_set", function(settingsTable)
    local src = source
    URP.DB:UpdateSettings(src, settingsTable, function(UpdateSettings, err)
        if UpdateSettings then
            -- we are good here.
        else
            TriggerClientEvent("DoLongHudText", src, "Settings Failed to Save to data for some reason.", 2)
        end
    end)
end)

RegisterServerEvent("prp-base:sv:player_settings")
AddEventHandler("prp-base:sv:player_settings", function()
    local src = source
    URP.DB:GetSettings(src, function(loadedSettings, err)
        if loadedSettings ~= nil then TriggerClientEvent("prp-base:cl:player_settings", src, loadedSettings) else TriggerClientEvent("prp-base:cl:player_settings",src, nil) end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        print(IsPlayerUsingSuperJump(GetPlayerPed(source)))
    end
end)

RegisterServerEvent('prp-ac:sort')
AddEventHandler('prp-ac:sort', function()
    DropPlayer(source, 'You have been automatically kicked! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('prp-ac:np-item')
AddEventHandler('prp-ac:np-item', function()
    DropPlayer(source, 'You have been automatically kicked for using NoPixel Inventory Natives! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('prp-ac:np-openinv')
AddEventHandler('prp-ac:np-openinv', function()
    DropPlayer(source, 'You have been automatically kicked for using NoPixel Open Inventory Natives! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('prp-ac:taxi')
AddEventHandler('prp-ac:taxi', function()
    DropPlayer(source, 'You have been automatically kicked for Triggering Taxi Pay! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('prp-ac:missioncompleted')
AddEventHandler('prp-ac:missioncompleted', function()
    DropPlayer(source, 'You have been automatically kicked for Triggering Mission Completed Pay! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('prp-ac:esxdrug')
AddEventHandler('prp-ac:esxdrug', function()
    DropPlayer(source, 'You have been automatically kicked for Triggering ESX Drug Ass! If this was a false-positive, please let the UniWonderty Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('prp-ac:police')
AddEventHandler('prp-ac:police', function()
    DropPlayer(source, 'You have been automatically kicked for Triggering Police Shit! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('prp-ac:job')
AddEventHandler('prp-ac:job', function()
    DropPlayer(source, 'You have been automatically kicked for Trying to Set Job! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('prp-ac:esxgiveitem')
AddEventHandler('prp-ac:esxgiveitem', function()
    DropPlayer(source, 'You have been automatically kicked for Trying to Give ESX Items! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('prp-ac:money')
AddEventHandler('prp-ac:money', function()
    DropPlayer(source, 'You have been automatically kicked for Trying to Spawn Money! If this was a false-positive, please let the Wonder Staff Team know so they can fix this issue!')
end)

RegisterServerEvent('prp-ac:request')
AddEventHandler('prp-ac:request', function(source)
    if source ~= nil then
        TriggerEvent('prp-ac:sort', source)
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
	TriggerEvent('prp-ac:taxi')
end)

RegisterServerEvent('esx_taxijob:pay')
AddEventHandler('esx_taxijob:pay', function()
	TriggerEvent('prp-ac:taxi')
end)

RegisterServerEvent('esx_drugs:sellDrug')
AddEventHandler('esx_drugs:sellDrug', function()
	TriggerEvent('prp-ac:esxdrug')
end)

RegisterServerEvent('esx_drugs:pickedUpCannabis')
AddEventHandler('esx_drugs:pickedUpCannabis', function()
	TriggerEvent('prp-ac:esxdrug')
end)

RegisterServerEvent('esx_drugs:processCannabis')
AddEventHandler('esx_drugs:processCannabis', function()
	TriggerEvent('prp-ac:esxdrug')
end)

RegisterServerEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
	TriggerEvent('prp-ac:police')
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function()
	TriggerEvent('prp-ac:police')
end)

RegisterServerEvent('esx_policejob:startHarvest')
AddEventHandler('esx_policejob:startHarvest', function()
	TriggerEvent('prp-ac:police')
end)

RegisterServerEvent('esx_jobs:setJob')
AddEventHandler('esx_jobs:setJob', function()
	TriggerEvent('prp-ac:job')
end)

RegisterServerEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function()
	TriggerEvent('prp-ac:esxgiveitem')
end)

RegisterServerEvent('esx_garbagejob:pay')
AddEventHandler('esx_garbagejob:pay', function()
	TriggerEvent('prp-ac:money')
end)

RegisterServerEvent('esx_gopostaljob:pay')
AddEventHandler('esx_gopostaljob:pay', function()
	TriggerEvent('prp-ac:money')
end)

RegisterServerEvent('esx_godirtyjob:pay')
AddEventHandler('esx_godirtyjob:pay', function()
	TriggerEvent('prp-ac:money')
end)

RegisterServerEvent('esx-qalle-hunting:reward')
AddEventHandler('esx-qalle-hunting:reward', function()
	TriggerEvent('prp-ac:money')
end)

RegisterServerEvent('esx_truckerjob:pay')
AddEventHandler('esx_truckerjob:pay', function()
	TriggerEvent('prp-ac:money')
end)

RegisterServerEvent('esx_slotmachine:sv:2')
AddEventHandler('esx_slotmachine:sv:2', function()
	TriggerEvent('prp-ac:money')
end)

RegisterServerEvent('prp-ac:InfoPass')
AddEventHandler('prp-ac:InfoPass', function()
	TriggerEvent('prp-ac:money')
end)


---






RegisterServerEvent('urp_taxijob:pay')
AddEventHandler('urp_taxijob:pay', function()
	TriggerEvent('prp-ac:taxi')
end)

RegisterServerEvent('urp_taxijob:pay')
AddEventHandler('urp_taxijob:pay', function()
	TriggerEvent('prp-ac:taxi')
end)

RegisterServerEvent('urp_drugs:sellDrug')
AddEventHandler('urp_drugs:sellDrug', function()
	TriggerEvent('prp-ac:esxdrug')
end)

RegisterServerEvent('urp_drugs:pickedUpCannabis')
AddEventHandler('urp_drugs:pickedUpCannabis', function()
	TriggerEvent('prp-ac:esxdrug')
end)

RegisterServerEvent('urp_drugs:processCannabis')
AddEventHandler('urp_drugs:processCannabis', function()
	TriggerEvent('prp-ac:esxdrug')
end)

RegisterServerEvent('urp_policejob:handcuff')
AddEventHandler('urp_policejob:handcuff', function()
	TriggerEvent('prp-ac:police')
end)

RegisterServerEvent('urp_policejob:drag')
AddEventHandler('urp_policejob:drag', function()
	TriggerEvent('prp-ac:police')
end)

RegisterServerEvent('urp_policejob:startHarvest')
AddEventHandler('urp_policejob:startHarvest', function()
	TriggerEvent('prp-ac:police')
end)

RegisterServerEvent('urp_jobs:setJob')
AddEventHandler('urp_jobs:setJob', function()
	TriggerEvent('prp-ac:job')
end)

RegisterServerEvent('urp:giveInventoryItem')
AddEventHandler('urp:giveInventoryItem', function()
	TriggerEvent('prp-ac:esxgiveitem')
end)

RegisterServerEvent('urp_garbagejob:pay')
AddEventHandler('urp_garbagejob:pay', function()
	TriggerEvent('prp-ac:money')
end)

RegisterServerEvent('urp_gopostaljob:pay')
AddEventHandler('urp_gopostaljob:pay', function()
	TriggerEvent('prp-ac:money')
end)

RegisterServerEvent('urp_godirtyjob:pay')
AddEventHandler('urp_godirtyjob:pay', function()
	TriggerEvent('prp-ac:money')
end)

RegisterServerEvent('prp-qalle-hunting:reward')
AddEventHandler('prp-qalle-hunting:reward', function()
	TriggerEvent('prp-ac:money')
end)

RegisterServerEvent('urp_truckerjob:pay')
AddEventHandler('urp_truckerjob:pay', function()
	TriggerEvent('prp-ac:money')
end)

RegisterServerEvent('urp_slotmachine:sv:2')
AddEventHandler('urp_slotmachine:sv:2', function()
	TriggerEvent('prp-ac:money')
end)

RegisterServerEvent('prp-prp-ac:InfoPass')
AddEventHandler('prp-prp-ac:InfoPass', function()
	TriggerEvent('prp-ac:money')
end)