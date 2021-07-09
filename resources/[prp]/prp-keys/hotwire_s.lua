local vehicleKeys = {}
local myVehicleKeys = {}

local robbableItems = {
  [1] = {chance = 3, id = 0, quantity = math.random(25, 75)}, -- really common
  [2] = {chance = 4, id = '2578778090', quantity = math.random(1, 1)}, -- rare
  [3] = {chance = 3, id = 'mobilephone', quantity = math.random(1, 1)}, -- really common
  [4] = {chance = 7, id = 'rubber', quantity = math.random(1,2)}, -- rare
  [5] = {chance = 8, id = 'rolexwatch', quantity = 1},
  [6] = {chance = 8, id = 'highgradefemaleseed', quantity = math.random(1, 3)},
  [7] = {chance = 6, id = 'highgrademaleseed', quantity = math.random(1, 4)},
  [8] = {chance = 4, id = 'rubber', quantity = math.random(1, 5)},
  [9] = {chance = 5, id = 'oxy', quantity = math.random(1,2)},


}

RegisterServerEvent('garage:searchItem')
AddEventHandler('garage:searchItem', function(plate)
 local source = tonumber(source)
 local item = {}
 local ident = GetPlayerIdentifiers(source)[1]

  item = robbableItems[math.random(1, #robbableItems)]
  if math.random(1, 9) >= item.chance then
   if tonumber(item.id) == 0 then
    TriggerClientEvent('prp-ac:InfoPass', source, item.quantity)
    TriggerClientEvent("DoLongHudText", source, 'You found $'..item.quantity)
   elseif tonumber(item.id) == 1 then
    TriggerClientEvent("DoLongHudText", source, 'You have found the keys to the vehicle!')
    vehicleKeys[plate] = {}
    table.insert(vehicleKeys[plate], {id = ident})
    TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident)
    TriggerClientEvent('vehicle:start', source)
   else
    TriggerClientEvent('prp-banned:getID', source, item.id, item.quantity)
    TriggerClientEvent("DoLongHudText", source, 'Item Added!')
   end
  else
    TriggerClientEvent("DoLongHudText", source, 'You found nothing', 2)
  end
end)

RegisterServerEvent('garage:giveKey')
AddEventHandler('garage:giveKey', function(target, plate)
 local targetSource = tonumber(target)
 local ident = GetPlayerIdentifiers(targetSource)[1]
 local ident2 = GetPlayerIdentifiers(source)[1]
 local plate = tostring(plate)

 vehicleKeys[plate] = {}
 table.insert(vehicleKeys[plate], {id = ident})
 --TriggerClientEvent('chatMessage', targetSource, 'You just recieved keys to a vehicle')
 TriggerClientEvent("DoLongHudText", targetSource, 'You just recieved keys to a vehicle')
 TriggerClientEvent('garage:updateKeys', targetSource, vehicleKeys, ident)
 --re-enable to only have one set of keys
 --TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident2)
end)

RegisterServerEvent('garage:addKeys')
AddEventHandler('garage:addKeys', function(plate)
 local source = tonumber(source)
 local ident = GetPlayerIdentifiers(source)[1]
 while plate == nil do
  Citizen.Wait(5)
 end

 if vehicleKeys[plate] ~= nil then
  table.insert(vehicleKeys[plate], {id = ident})
  TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident)
 else
  vehicleKeys[plate] = {}
  table.insert(vehicleKeys[plate], {id = ident})
  TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident)
 end
end)


RegisterServerEvent('garage:removeKeys')
AddEventHandler('garage:removeKeys', function(plate)
 local source = tonumber(source)
 local ident = GetPlayerIdentifiers(source)[1]
 if vehicleKeys[plate] ~= nil then
  for id,v in pairs(vehicleKeys[plate]) do
   if v.id == ident then
    table.remove(vehicleKeys[plate], id)
   end
  end
 end
 TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident)
end)

RegisterServerEvent('removelockpick')
AddEventHandler('removelockpick', function()
 local source = tonumber(source)
 if math.random(1, 20) == 1 then
  TriggerClientEvent('prp-banned:getID', source, "lockpick", 1)
  TriggerClientEvent("DoLongHudText", source, 'The lockpick bent out of shape.')
 end
end)

RegisterServerEvent('prp-transferveh')
AddEventHandler('prp-transferveh', function(owner, plate, playercid)
  print(owner)
  print(plate)
  print(playercid)
  local src = source
  exports.ghmattimysql:execute('SELECT * FROM __vehicles WHERE `cid`= ? AND `plate`= ?', {owner, plate}, function(data)
    if data[1]~= nil then
      exports.ghmattimysql:execute("UPDATE __vehicles SET `cid` = @cid WHERE `plate` = @plate", {
        ['@cid'] = playercid,
        ['@plate'] = plate
      })
      TriggerClientEvent('DoShortHudText', src, 'Vehicle Transferred to CID: ' .. playercid .. ' With the plate of: '..plate)
    else
      TriggerClientEvent('DoLongHudText', src, 'ERROR: Vehicle does not belong to you!', 2)
    end
  end)
end)