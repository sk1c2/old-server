local robbableItems = {
 [1] = {chance = 3, id = 0, quantity = math.random(50, 200)}, -- really common
 [2] = {chance = 5, id = 'plastic', quantity = math.random(3, 10)}, -- rare
 [3] = {chance = 5, id = 'aluminium', quantity = math.random(3, 10)}, -- really common
 [4] = {chance = 5, id = 'copper', quantity = math.random(3, 10)}, -- rare
 [5] = {chance = 5, id = 'electronics', quantity = math.random(3, 10)}, -- rare
 [6] = {chance = 5, id = 'rubber', quantity = math.random(3, 10)}, -- rare
 [7] = {chance = 5, id = 'scrapmetal', quantity = math.random(3, 10)}, -- rare
 [8] = {chance = 5, id = 'steel', quantity = math.random(3, 10)}, -- rare
 [9] = {chance = 5, id = 'joint', quantity = math.random(1,5)}, -- rare
 [10] = {chance = 5, id = 'watch', quantity = math.random(1,3)}, -- rare
 [11] = {chance = 6, id = 'gemstoneamethyst', quantity = math.random(1,4)}, -- rare
 [12] = {chance = 10, id = 'gemstoneruby', quantity = math.random(1,2)}, -- rare
 [13] = {chance = 4, id = 'sandwich', quantity = 1},
 [14] = {chance = 4, id = 'water', quantity = math.random(1)},
 [15] = {chance = 5, id = 'rolexwatch', quantity = math.random(1, 8)},
 --[6] = {chance = 14, id = 'keycard', name = 'Keycard', quantity = 1}, -- rare
 --[7] = {chance = 13, id = 'keycard2', name = 'Keycard', quantity = 1}, -- rare
 --[8] = {chance = 11, id = 'keycard3', name = 'Keycard', quantity = 1}, -- rare
 --[12] = {chance = 10, id = 'drugItem', name = 'Black USB-C', quantity = 1}, -- rare
 --[13] = {chance = 8, id = 'drugbags', name = 'Baggies', quantity = math.random(1, 6)},
 --[15] = {chance = 6, id = 'rolex', name = 'Rolex', quantity = math.random(1, 5)},
}

--[[chance = 1 is very common, the higher the value the less the chance]]--

RegisterServerEvent('houseRobberies:removeLockpick')
AddEventHandler('houseRobberies:removeLockpick', function()
 local source = tonumber(source)
 TriggerClientEvent('inventory:removeItem', source, 'advlockpick', 1)
 TriggerClientEvent('DoLongHudText',  source, 'The lockpick bent out of shape' , 1)
end)

RegisterServerEvent('houseRobberies:giveMoney')
AddEventHandler('houseRobberies:giveMoney', function()
 local source = tonumber(source)
 local cash = math.random(50, 200)
 TriggerClientEvent('wrp-ac:InfoPass',cash)
 TriggerClientEvent('DoLongHudText',  source, 'You found $'..cash , 1)
end)


RegisterServerEvent('houseRobberies:searchItem')
AddEventHandler('houseRobberies:searchItem', function()
 local source = tonumber(source)
 local item = {}
 local gotID = {}

 for i=1, math.random(1, 2) do
  item = robbableItems[math.random(1, #robbableItems)]
  if math.random(1, 15) >= item.chance then
    if tonumber(item.id) == 0 and not gotID[item.id] then
        gotID[item.id] = true
        TriggerClientEvent('wrp-ac:InfoPass', source, item.quantity)
        TriggerClientEvent('DoLongHudText',  source, 'You found $'..item.quantity , 1)
    elseif not gotID[item.id] then
        gotID[item.id] = true
        TriggerClientEvent('wrp-banned:getID', source, item.id, item.quantity)
        TriggerClientEvent('DoLongHudText', source, 'Item Added!', 1)
    end
  else
    TriggerClientEvent('DoLongHudText', source, 'You found nothing', 1)
  end
end
end)
