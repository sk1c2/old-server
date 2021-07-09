local carOnShow = `ztype`
local spinningCar = nil
local spinningObject = nil
local inCasino = true
local storeDist3 = GetDistanceBetweenCoords(plyCoords, 569.04, 2796.67, 42.01)

function drawCarForWins()
    if DoesEntityExist(spinningCar) then
      DeleteEntity(spinningCar)
    end
    RequestModel(carOnShow)
      while not HasModelLoaded(carOnShow) do
          Citizen.Wait(0)
    end
    SetModelAsNoLongerNeeded(carOnShow)
    spinningCar = CreateVehicle(carOnShow, -478.19, 40.69, 52.60 + 0.05, 0.0, 0, 0)
    Wait(0)
    SetVehicleDirtLevel(spinningCar, 0.0)
    SetVehicleOnGroundProperly(spinningCar)
    Wait(0)
    FreezeEntityPosition(spinningCar, 1)
  end

RegisterCommand('show', function()
  drawCarForWins()
end)

RegisterNetEvent('gallery:stash')
AddEventHandler('gallery:stash', function()
	local rank = exports["isPed"]:GroupRank("Gallery")
	if rank > 3 then
		TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "storage-Gallery")	
	end
end)

RegisterNetEvent('gallery:table')
AddEventHandler('gallery:table', function()
	TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "gem_counter")
end)

RegisterNetEvent('gallery:table2')
AddEventHandler('gallery:table2', function()
	TriggerEvent("wrp-ac:triggeredItemSpawn", "1", "gem_counter2")
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(5)
      local plyCords = GetEntityCoords(PlayerPedId())
      local dis = GetDistanceBetweenCoords(plyCords, -573.03, -441.81, 34.35, true)
        if dis <= 5 then
            if IsControlJustReleased(0, 38) then
              local rank = exports["isPed"]:GroupRank("Gallery")
              if rank > 4 then
                if exports["wrp-inventory"]:hasEnoughOfItem("gemstoneamethyst",10,false) then 
                    TriggerEvent("inventory:removeItem", "gemstoneamethyst", 10)
                    local finished = exports["wrp-taskbar"]:taskBar(2000,"Selling Gems",true,false,playerVeh)
                    if finished == 100 then
                        SellGems(math.random(6000,7000))
                    end
                elseif exports['wrp-inventory']:hasEnoughOfItem('gemstoneruby',10, false) then
                    TriggerEvent("inventory:removeItem", "gemstoneruby", 10)
                    exports["wrp-taskbar"]:taskBar(2000,"Selling Gems",true,false,playerVeh)
                    local ItemSell = math.random(7000,8500)
                    SellGems(ItemSell)
                    TriggerEvent('DoLongHudText', 'You have sold ten Ruby for $' .. ItemSell .. '!')
                elseif exports['wrp-inventory']:hasEnoughOfItem('gemstoneemerald',10, false) then
                    TriggerEvent("inventory:removeItem", "gemstoneemerald", 10)
                    exports["wrp-taskbar"]:taskBar(2000,"Selling Gems",true,false,playerVeh)
                    local ItemSell = math.random(11000,13500)
                    SellGems(ItemSell)
                    TriggerEvent('DoLongHudText', 'You have sold ten Emerald for $' .. ItemSell .. '!')
                elseif exports['wrp-inventory']:hasEnoughOfItem('gemstonesapphire',10, false) then
                    TriggerEvent("inventory:removeItem", "gemstonesapphire", 10)
                    exports["wrp-taskbar"]:taskBar(2000,"Selling Gems",true,false,playerVeh)
                    local ItemSell = math.random(19000,22000)
                    SellGems(ItemSell)
                    TriggerEvent('DoLongHudText', 'You have sold ten Sapphire for $' .. ItemSell .. '!')
                elseif exports['wrp-inventory']:hasEnoughOfItem('gemstoneaqua',10, false) then
                    TriggerEvent("inventory:removeItem", "gemstoneaqua", 10)
                    exports["wrp-taskbar"]:taskBar(2000,"Selling Gems",true,false,playerVeh)
                    local ItemSell = math.random(24000,28000)
                    SellGems(ItemSell)
                    TriggerEvent('DoLongHudText', 'You have sold ten AquaMarine for $' .. ItemSell .. '!')
                elseif exports['wrp-inventory']:hasEnoughOfItem('gemstonediamond',10, false) then
                    TriggerEvent("inventory:removeItem", "gemstonediamond", 10)
                    exports["wrp-taskbar"]:taskBar(2000,"Selling Gems",true,false,playerVeh)
                    local ItemSell = math.random(42000,47000)
                    SellGems(ItemSell)
                    TriggerEvent('DoLongHudText', 'You have sold ten Diamonds for $' .. ItemSell .. '!')
                else 
                    TriggerEvent('DoLongHudText', 'You dont have enough gems to sell!', 2)
                end
              end
          end
      end
  end
end)

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

function SellGems(sellgems)
  TriggerServerEvent('gems:returnDepo', sellgems)
  if sellgems > 50000 then
      TriggerServerEvent('wrp-ac:sort')
  end
end