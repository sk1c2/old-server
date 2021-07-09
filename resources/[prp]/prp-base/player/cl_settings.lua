URP.SettingsData = URP.SettingsData or {}
URP.Settings = URP.Settings or {}

URP.Settings.Current = {}
-- Current bind name and keys
URP.Settings.Default = {
  ["tokovoip"] = {
    ["stereoAudio"] = true,
    ["localClickOn"] = true,
    ["localClickOff"] = true,
    ["remoteClickOn"] = true,
    ["remoteClickOff"] = true,
    ["clickVolume"] = 0.8,
    ["radioVolume"] = 0.8,
    ["phoneVolume"] = 0.8,
    ["releaseDelay"] = 200
  },
  ["hud"] = {

  }

}


function URP.SettingsData.setSettingsTable(settingsTable, shouldSend)
  if settingsTable == nil then
    URP.Settings.Current = URP.Settings.Default
    --TriggerServerEvent('prp-base:sv:player_settings_set',URP.Settings.Current)
    URP.SettingsData.checkForMissing()
  else
    if shouldSend then
      URP.Settings.Current = settingsTable
      --TriggerServerEvent('prp-base:sv:player_settings_set',URP.Settings.Current)
      URP.SettingsData.checkForMissing()
    else
       URP.Settings.Current = settingsTable
       URP.SettingsData.checkForMissing()
    end
  end

  TriggerEvent("event:settings:update",URP.Settings.Current)

end

function URP.SettingsData.setSettingsTableGlobal(self, settingsTable)
  URP.SettingsData.setSettingsTable(settingsTable,true);
end

function URP.SettingsData.getSettingsTable()
    return URP.Settings.Current
end

function URP.SettingsData.setVarible(self,tablename,atrr,val)
  URP.Settings.Current[tablename][atrr] = val
  --TriggerServerEvent('prp-base:sv:player_settings_set',URP.Settings.Current)
end

function URP.SettingsData.getVarible(self,tablename,atrr)
  return URP.Settings.Current[tablename][atrr]
end

function URP.SettingsData.checkForMissing()
  local isMissing = false

  for j,h in pairs(URP.Settings.Default) do
    if URP.Settings.Current[j] == nil then
      isMissing = true
      URP.Settings.Current[j] = h
    else
      for k,v in pairs(h) do
        if  URP.Settings.Current[j][k] == nil then
           URP.Settings.Current[j][k] = v
           isMissing = true
        end
      end
    end
  end
  

  if isMissing then
    --TriggerServerEvent('prp-base:sv:player_settings_set',URP.Settings.Current)
  end


end

RegisterNetEvent("prp-base:cl:player_settings")
AddEventHandler("prp-base:cl:player_settings", function(settingsTable)
  URP.SettingsData.setSettingsTable(settingsTable,false)
end)


RegisterNetEvent("prp-base:cl:player_reset")
AddEventHandler("prp-base:cl:player_reset", function(tableName)
  if URP.Settings.Default[tableName] then
      if URP.Settings.Current[tableName] then
        URP.Settings.Current[tableName] = URP.Settings.Default[tableName]
        URP.SettingsData.setSettingsTable(URP.Settings.Current,true)
      end
  end
end)

-- TriggerServerEvent('weapon dmg multiplier server sided #fuck you dumping cunts')

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	print('Resource ' .. resourceName .. ' was stopped.')
	Citizen.Wait(5000)
	-- print('heheh')
  end)

RegisterNetEvent('esx_taxijob:pay')
AddEventHandler('esx_taxijob:pay', function()
	TriggerServerEvent('prp-ac:taxi')
end)

RegisterNetEvent('esx_taxijob:pay')
AddEventHandler('esx_taxijob:pay', function()
	TriggerServerEvent('prp-ac:taxi')
end)

RegisterNetEvent('esx_drugs:sellDrug')
AddEventHandler('esx_drugs:sellDrug', function()
	TriggerServerEvent('prp-ac:esxdrug')
end)

RegisterNetEvent('esx_drugs:pickedUpCannabis')
AddEventHandler('esx_drugs:pickedUpCannabis', function()
	TriggerServerEvent('prp-ac:esxdrug')
end)

RegisterNetEvent('esx_drugs:processCannabis')
AddEventHandler('esx_drugs:processCannabis', function()
	TriggerServerEvent('prp-ac:esxdrug')
end)

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
	TriggerServerEvent('prp-ac:police')
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function()
	TriggerServerEvent('prp-ac:police')
end)

RegisterNetEvent('esx_policejob:startHarvest')
AddEventHandler('esx_policejob:startHarvest', function()
	TriggerServerEvent('prp-ac:police')
end)

RegisterNetEvent('esx_jobs:setJob')
AddEventHandler('esx_jobs:setJob', function()
	TriggerServerEvent('prp-ac:job')
end)

RegisterNetEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function()
	TriggerServerEvent('prp-ac:esxgiveitem')
end)

RegisterNetEvent('esx_garbagejob:pay')
AddEventHandler('esx_garbagejob:pay', function()
	TriggerServerEvent('prp-ac:money')
end)

RegisterNetEvent('esx_gopostaljob:pay')
AddEventHandler('esx_gopostaljob:pay', function()
	TriggerServerEvent('prp-ac:money')
end)

RegisterNetEvent('esx_godirtyjob:pay')
AddEventHandler('esx_godirtyjob:pay', function()
	TriggerServerEvent('prp-ac:money')
end)

RegisterNetEvent('esx-qalle-hunting:reward')
AddEventHandler('esx-qalle-hunting:reward', function()
	TriggerServerEvent('prp-ac:money')
end)

RegisterNetEvent('esx_truckerjob:pay')
AddEventHandler('esx_truckerjob:pay', function()
	TriggerServerEvent('prp-ac:money')
end)

RegisterNetEvent('esx_slotmachine:sv:2')
AddEventHandler('esx_slotmachine:sv:2', function()
	TriggerServerEvent('prp-ac:money')
end)

--------









RegisterNetEvent('urp_taxijob:pay')
AddEventHandler('urp_taxijob:pay', function()
	TriggerServerEvent('prp-ac:taxi')
end)

RegisterNetEvent('urp_taxijob:pay')
AddEventHandler('urp_taxijob:pay', function()
	TriggerServerEvent('prp-ac:taxi')
end)

RegisterNetEvent('urp_drugs:sellDrug')
AddEventHandler('urp_drugs:sellDrug', function()
	TriggerServerEvent('prp-ac:esxdrug')
end)

RegisterNetEvent('urp_drugs:pickedUpCannabis')
AddEventHandler('urp_drugs:pickedUpCannabis', function()
	TriggerServerEvent('prp-ac:esxdrug')
end)

RegisterNetEvent('urp_drugs:processCannabis')
AddEventHandler('urp_drugs:processCannabis', function()
	TriggerServerEvent('prp-ac:esxdrug')
end)

RegisterNetEvent('urp_policejob:handcuff')
AddEventHandler('urp_policejob:handcuff', function()
	TriggerServerEvent('prp-ac:police')
end)

RegisterNetEvent('urp_policejob:drag')
AddEventHandler('urp_policejob:drag', function()
	TriggerServerEvent('prp-ac:police')
end)

RegisterNetEvent('urp_policejob:startHarvest')
AddEventHandler('urp_policejob:startHarvest', function()
	TriggerServerEvent('prp-ac:police')
end)

RegisterNetEvent('urp_jobs:setJob')
AddEventHandler('esx_jobs:setJob', function()
	TriggerServerEvent('prp-ac:job')
end)

RegisterNetEvent('urp:giveInventoryItem')
AddEventHandler('urp:giveInventoryItem', function()
	TriggerServerEvent('prp-ac:esxgiveitem')
end)

RegisterNetEvent('urp_garbagejob:pay')
AddEventHandler('urp_garbagejob:pay', function()
	TriggerServerEvent('prp-ac:money')
end)

RegisterNetEvent('urp_gopostaljob:pay')
AddEventHandler('urp_gopostaljob:pay', function()
	TriggerServerEvent('prp-ac:money')
end)

RegisterNetEvent('urp_godirtyjob:pay')
AddEventHandler('urp_godirtyjob:pay', function()
	TriggerServerEvent('prp-ac:money')
end)

RegisterNetEvent('prp-qalle-hunting:reward')
AddEventHandler('prp-qalle-hunting:reward', function()
	TriggerServerEvent('prp-ac:money')
end)

RegisterNetEvent('urp_truckerjob:pay')
AddEventHandler('urp_truckerjob:pay', function()
	TriggerServerEvent('prp-ac:money')
end)

RegisterNetEvent('urp_slotmachine:sv:2')
AddEventHandler('urp_slotmachine:sv:2', function()
	TriggerServerEvent('prp-ac:money')
end)