local changeYourJob, inMenu = vector3(478.79, -107.85, 63.15), false
local plyPed, plyCoords = PlayerPedId(), vector3(0, 0, 0)
OnGoingHuntSession = false
local timer = 0
TempLicense = 0
local Blips = {
  ['hunting'] = {
    ['blips'] = {
      [1] = {['blip'] = 0, ['title'] = 'Hunting Office', ['coords'] = vector3(-675.4431, 5836.979, 17.34016), ['type'] = 141, ['colour'] = 31},
      [2] = {['blip'] = 0, ['title'] = 'Hunting Trading', ['coords'] = vector3(569.04, 2796.67, 42.01), ['type'] = 628, ['colour'] = 2},
    }
  }
}

RegisterNetEvent('wrp-hunting:obtainLicense')
AddEventHandler('wrp-hunting:obtainLicense', function()
    TempLicense = 1
end)

function DrawText3Ds(coords, text)
  if coords then
    local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = #text / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
  end
end

CreateThread(function()
  local blipInfo = Blips['hunting']['blips'][1]
  blipInfo.blip = AddBlipForCoord(blipInfo.coords)
  SetBlipSprite(blipInfo.blip, blipInfo.type)
  SetBlipDisplay(blipInfo.blip, 4)
  SetBlipScale(blipInfo.blip, 0.7)
  SetBlipColour(blipInfo.blip, blipInfo.colour)
  SetBlipAsShortRange(blipInfo.blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(blipInfo.title)
  EndTextCommandSetBlipName(blipInfo.blip)
  TriggerEvent('chat:addSuggestion', '/checkhunting', '/checkhunting CID. Check hunting license status')
end)

-- Hunting and other jobs:

local huntingAnimals = {
  [`a_c_boar`] = {
    ['time'] = math.random(90000, 110000),
    ['pelt'] = {['item'] = 'pelt20', ['quant'] = 1},
    ['meat'] = {['item'] = 'rawmeat', ['quant'] = math.random(3,6)},
    ['trophy'] = {['item'] = 'fangs', ['quant'] = 1}
  },
  [`a_c_coyote`] = {
    ['time'] = math.random(50000, 80000),
    ['pelt'] = {['item'] = 'pelt10', ['quant'] = 1},
    ['meat'] = {['item'] = 'rawmeat', ['quant'] = math.random(2,4)},
    ['trophy'] = {['item'] = 'animalteeth', ['quant'] = 1}
  },
  [`a_c_deer`] = {
    ['time'] = math.random(90000, 110000),
    ['pelt'] = {['item'] = 'pelt15', ['quant'] = 1},
    ['meat'] = {['item'] = 'rawmeat', ['quant'] = math.random(3,7)},
    ['trophy'] = {['item'] = 'antlers', ['quant'] = 1}
  },
  [`a_c_mtlion`] = {
    ['time'] = math.random(110000, 140000),
    ['pelt'] = {['item'] = 'pelt15', ['quant'] = 1},
    ['meat'] = {['item'] = 'rawmeat', ['quant'] = math.random(3,5)},
    ['trophy'] = {['item'] = 'fangs', ['quant'] = 1}
  },
  [`a_c_rabbit_01`] = {
    ['time'] = math.random(50000, 80000),
    ['pelt'] = {['item'] = 'pelt2', ['quant'] = 1},
    ['meat'] = {['item'] = 'rawmeat', ['quant'] = math.random(1,2)},
  },
  [`a_c_chickenhawk`] = {
    ['time'] = math.random(50000, 80000),
    ['pelt'] = {['item'] = 'pelt2', ['quant'] = 1},
    ['meat'] = {['item'] = 'rawmeat', ['quant'] = 1},
  },
  [`a_c_cormorant`] = {
    ['time'] = math.random(50000, 80000),
    ['pelt'] = {['item'] = 'feather', ['quant'] = math.random(3)},
    ['meat'] = {['item'] = 'rawmeat', ['quant'] = 1},
  },
}

local currentHuntingStatus = 0

CreateThread(function()
  while true do
    plyPed = PlayerPedId()
    plyCoords = GetEntityCoords(plyPed)
    Wait(1000)
  end
end)

CreateThread(function()

  WarMenu.CreateMenu('huntmenu', 'Hunting')
  WarMenu.SetSubTitle("huntmenu", "Sell your legal hunting items here.")

  WarMenu.SetMenuWidth("huntmenu", 0.5)
  WarMenu.SetMenuX("huntmenu", 0.71)
  WarMenu.SetMenuY("huntmenu", 0.017)
  WarMenu.SetMenuMaxOptionCountOnScreen("huntmenu", 30)
  WarMenu.SetTitleColor("huntmenu", 250, 135, 135, 255)
  WarMenu.SetTitleBackgroundColor("huntmenu", 0 , 0, 0, 150)
  WarMenu.SetMenuBackgroundColor("huntmenu", 0, 0, 0, 100)
  WarMenu.SetMenuSubTextColor("huntmenu", 255, 255, 255, 255)

  local showMenu = false

  local items = {
    {name="Hunting Sniper", id="100416529"},
    {name="Cougar Pelt", id="cpelt"},
    {name="Cougar Tooth", id="ctooth"},
    {name="Animal Carcass Tier 1", id="huntingcarcass1"},
    {name="Animal Carcass Tier 2 ", id="huntingcarcass2"},
    {name="Animal Carcass Tier 3", id="huntingcarcass3"},
    {name="Animal Carcass Tier 4", id="huntingcarcass4"},
    {name="Rabbit Pelt", id ="rpelt"},
    {name="Hunting Pelt Tier 1", id='huntingpelt1'},
    {name="Hunting Pelt Tier 2", id='huntingpelt2'},
    {name="Hunting Pelt Tier 3", id='huntingpelt3'},
  }

  while true do
    Wait(0)

        local officeDist = GetDistanceBetweenCoords(plyCoords, -675.4431, 5836.979, 17.34016)
        local storeDist = GetDistanceBetweenCoords(plyCoords, 569.04, 2796.67, 42.01)
        local storeDist2 = GetDistanceBetweenCoords(plyCoords, -676.0071, 5834.161, 17.34014)
        if officeDist < 2 and currentHuntingStatus == 0 then
          DrawText3Ds(vector3(-675.4431, 5836.979, 17.34016), '[~b~E~w~] Hunting Clock-In')
          if officeDist < 1 then
            if IsControlJustReleased(0, 38) then
              TriggerServerEvent('wrp-hunting:hasLicense', exports['isPed']:isPed('cid'))
              Wait(1000)
            end
          end
        -- elseif storeDist2 < 2 and currentHuntingStatus == 1 then
        --   DrawText3Ds(vector3(-676.0071, 5834.161, 17.34014), '[~y~E~w~] Buy Hunting Ammo x50')
        --   if IsControlJustPressed(0, 38) then
        --     SetAmmoInClip(PlayerPedId(), 'WEAPON_SNIPERRIFLE', 50)
        --   end
        elseif officeDist < 2 and currentHuntingStatus == 2 then
          DrawText3Ds(vector3(-675.4431, 5836.979, 17.34016), '[~g~E~w~] Hunting License')
          if officeDist < 1 then
            if IsControlJustReleased(0, 38) then
              TriggerEvent('wrp-hunting:PurchaseHuntingLicense', exports['isPed']:isPed('cid'))
              TriggerEvent('DoShortHudText', 'Signing up to a hunting license. Please wait.')
              Wait(5000)
            end
          end
        elseif officeDist < 2 and currentHuntingStatus == 1 then
          DrawText3Ds(vector3(-675.4431, 5836.979, 17.34016), '[~y~E~w~] Hunting Clock-Off')
          if officeDist < 1 then
            if IsControlJustReleased(0, 38) then
              currentHuntingStatus = 0
              TriggerServerEvent('wrp-hunting:removeloadout')
              Wait(100)
              SetPedInfiniteAmmo(PlayerPedId(), false)
              RemoveWeaponFromPed(PlayerPedId(), GetHashKey('WEAPON_SNIPERRIFLE'))
              OnGoingHuntSession = false
              Wait(1000)
            end
          end
        elseif storeDist < 2 and currentHuntingStatus == 1 then
          DrawText3Ds(vector3(569.04, 2796.67, 42.01), '[~y~E~w~] Hunting Trading')
          if storeDist < 1 then
            if IsControlJustReleased(0, 38) then
              showMenu = not showMenu
              WarMenu.OpenMenu('huntmenu')
              CreateThread(function()
                while true do
                  Wait(0)
                  if WarMenu.CurrentMenu() and showMenu then
                    for i=1, #items do
                      if WarMenu.Button(items[i]['name']) then 
                        TriggerServerEvent('wrp-hunting:sellItem', items[i]['id'], exports['wrp-inventory']:getQuantity(items[i]['id']))
                        Wait(5000)
                      end
                    end
                    WarMenu.Display()
                  else
                    return
                  end
                end
              end)
            end
          else
            if showMenu then showMenu = false end;
          end
        else
          Wait(1000)
          WarMenu.CloseMenu()
        end
     -- else
       -- Wait(1111)
      --end
    --else
     -- Wait(2222)
    --end
  end
end)

local huntingBusy = false

local HuntingKnives = {
  [`weapon_knife`] = true,
  [`weapon_dagger`] = true,
  [`weapon_hatchet`] = true,
  [`weapon_machete`] = true,
  [`weapon_switchblade`] = true,
  [`weapon_battleaxe`] = true
}

CreateThread(function()
  while true do Wait(0)
    --local job = 'hunting'--exports["isPed"]:isPed('myjob')
    --if job then
      --if job == 'hunting' then
        if not huntingBusy then
          local otherped = GetPedInFront()
          if DoesEntityExist(otherped) then
            if GetPedType(otherped) == 28 then
              if huntingAnimals[GetEntityModel(otherped)] then
                if IsPedFatallyInjured(otherped) then
                  local animalCoords = GetEntityCoords(otherped)
                  DrawText3Ds(animalCoords, '[~o~E~w~] Skin Animal')
                  if IsControlJustReleased(0, 38) then
                    if #(plyCoords - animalCoords) < 1.3 then
                      if HuntingKnives[GetSelectedPedWeapon(plyPed)]  then
                        huntingBusy = true
                        TriggerServerEvent('wrp-hunting:cacheAnimal', NetworkGetNetworkIdFromEntity(otherped))
                        local animOn = true
                        CreateThread(function()
                          TaskTurnPedToFaceEntity(plyPed, otherped, -1)
                          Wait(2500)
                          RequestAnimDict('amb@medic@standing@timeofdeath@enter')
                          while not HasAnimDictLoaded("amb@medic@standing@timeofdeath@enter") do Wait(100) end
                          TaskPlayAnim(PlayerPedId(), "amb@medic@standing@timeofdeath@enter", "enter", 8.0, -8, -1, 2, 0, 0, 0, 0)
                          Wait(5500)
                        
                          RequestAnimDict('amb@medic@standing@timeofdeath@base')
                          while not HasAnimDictLoaded("amb@medic@standing@timeofdeath@base") do Wait(100) end
                          TaskPlayAnim(PlayerPedId(), "amb@medic@standing@timeofdeath@base", "base", 8.0, -8, -1, 2, 0, 0, 0, 0)
                          Wait(6500)
                        
                          RequestAnimDict('amb@medic@standing@timeofdeath@exit')
                          while not HasAnimDictLoaded("amb@medic@standing@timeofdeath@exit") do Wait(100) end
                          TaskPlayAnim(PlayerPedId(), "amb@medic@standing@timeofdeath@exit", "exit", 8.0, -8, -1, 2, 0, 0, 0, 0)
                          Wait(7000)

                          if animOn then
                            RequestAnimDict('amb@medic@standing@tendtodead@enter')
                            while not HasAnimDictLoaded("amb@medic@standing@tendtodead@enter") do Wait(100) end
                            TaskPlayAnim(PlayerPedId(), "amb@medic@standing@tendtodead@enter", "enter", 8.0, -8, -1, 2, 0, 0, 0, 0)
                            Wait(GetAnimDuration("amb@medic@standing@tendtodead@enter", "enter") * 1000 + 200)
                          end
                          
                          if animOn then
                            Wait(100)
                            RequestAnimDict('amb@medic@standing@tendtodead@idle_a')
                            while not HasAnimDictLoaded("amb@medic@standing@tendtodead@idle_a") do Wait(100) end
                            TaskPlayAnim(PlayerPedId(), "amb@medic@standing@tendtodead@idle_a", "idle_a", 8.0, -8, -1, 2, 0, 0, 0, 0)
                            Wait(GetAnimDuration("amb@medic@standing@tendtodead@exit", "exit") * 1000 + 200)
                          end

                          if animOn then
                            RequestAnimDict('amb@medic@standing@kneel@base')
                            while not HasAnimDictLoaded("amb@medic@standing@kneel@base") do Wait(100) end
                            TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base", "base", 8.0, -8, -1, 2, 0, 0, 0, 0)
                          end

                          Wait(5000)
                          if animOn then
                            RequestAnimDict('amb@medic@standing@tendtodead@idle_a')
                            while not HasAnimDictLoaded("amb@medic@standing@tendtodead@idle_a") do Wait(100) end
                            TaskPlayAnim(PlayerPedId(), "amb@medic@standing@tendtodead@idle_a", "idle_a", 8.0, -8, -1, 2, 0, 0, 0, 0)
                            Wait(GetAnimDuration("amb@medic@standing@tendtodead@exit", "exit") * 1000 + 200)
                          end

                          while animOn do
                            Wait(100)
                            if not IsEntityPlayingAnim(PlayerPedId(), "amb@medic@standing@kneel@base", "base", 3) then
                              TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base", "base", 8.0, -8, -1, 2, 0, 0, 0, 0)
                            end
                          end

                          return
                        end)
                        
                        local finished = exports["wrp-taskbar"]:taskBar(huntingAnimals[GetEntityModel(otherped)]['time'],"Skinning Animal", true, true, true)
                        if (finished == 100) then
                          animOn = false

                          Wait(100)
                          RequestAnimDict('amb@medic@standing@tendtodead@exit')
                          while not HasAnimDictLoaded("amb@medic@standing@tendtodead@exit") do Wait(100) end
                          TaskPlayAnim(PlayerPedId(), "amb@medic@standing@tendtodead@exit", "exit", 8.0, -8, -1, 2, 0, 0, 0, 0)
                          Wait(GetAnimDuration("amb@medic@standing@tendtodead@exit", "exit") * 1000 + 200)
                          ClearPedTasks(plyPed)
                          TriggerServerEvent('wrp-hunting:getReward', GetEntityModel(otherped), huntingAnimals[GetEntityModel(otherped)])
                          NetworkFadeOutEntity(otherped, false, true)
                          Citizen.Wait(800)
                          DeleteEntity(otherped)
                        else
                          animOn = false
                          Wait(100)
                          RequestAnimDict('amb@medic@standing@tendtodead@exit')
                          while not HasAnimDictLoaded("amb@medic@standing@tendtodead@exit") do Wait(100) end
                          TaskPlayAnim(PlayerPedId(), "amb@medic@standing@tendtodead@exit", "exit", 8.0, -8, -1, 2, 0, 0, 0, 0)
                          Wait(GetAnimDuration("amb@medic@standing@tendtodead@exit", "exit") * 1000 + 200)
                          ClearPedTasks(plyPed)
                        end
                        huntingBusy = false
                      end
                    end
                  end
                else
                  Wait(690)
                end
              else
                Wait(1222)
              end
            else
              Wait(1320)
            end
          else
            Wait(1234)
          end
        else
          Wait(500)
        end
      --end
   -- end
  end
end)

Citizen.CreateThread(function()
  while true do
    SetAmmoInClip(PlayerPedId(), 'WEAPON_SNIPERRIFLE', 10)
    SetPedInfiniteAmmo(PlayerPedId(), true, 'WEAPON_SNIPERRIFLE')
    Citizen.Wait(1000)
  end
end)

RegisterNetEvent("wrp-hunting:hasLicense")
AddEventHandler("wrp-hunting:hasLicense", function(hasLicense)
  if tonumber(hasLicense) == 1 then
    currentHuntingStatus = 1
    TriggerEvent('DoLongHudText', 'You have a hunting license in our system, feel free to go legally hunting, go find animals', 1)
    local blipInfo = Blips['hunting']['blips'][2]
    TriggerServerEvent('wrp-GiveLoadOutForHunting')
    -- TriggerEvent('wrp-banned:getID', source, '100416529', 1)
    GiveWeaponToPed(PlayerPedId(), GetHashKey('WEAPON_SNIPERRIFLE'), 0, 0, 1)
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_SNIPERRIFLE'), 1)
    SetAmmoInClip(PlayerPedId(), 'WEAPON_SNIPERRIFLE', 10)
    SetPedInfiniteAmmo(PlayerPedId(), true, 'WEAPON_SNIPERRIFLE')
    blipInfo.blip = AddBlipForCoord(blipInfo.coords)
    SetBlipSprite(blipInfo.blip, blipInfo.type)
    SetBlipDisplay(blipInfo.blip, 4)
    SetBlipScale(blipInfo.blip, 0.7)
    SetBlipColour(blipInfo.blip, blipInfo.colour)
    SetBlipAsShortRange(blipInfo.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipInfo.title)
    EndTextCommandSetBlipName(blipInfo.blip)
    Citizen.Wait(1000)
    RemoveWeaponFromPed(PlayerPedId(), GetHashKey('WEAPON_SNIPERRIFLE'))
    OnGoingHuntSession = true
  else
    CreateThread(function() currentHuntingStatus = 2 Wait(5000) if currentHuntingStatus == 2 then currentHuntingStatus = 0 end end)
    TriggerEvent('DoLongHudText', 'Missing hunting license, press E to purchase one.', 2)
  end
end)

function GetPedInFront()
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyCoords.x, plyCoords.y, plyCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end

RegisterNetEvent('wrp-hunting:sellItems')
AddEventHandler('wrp-hunting:sellItems', function(amount)
    local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    LocalPlayer:addCash(Player.id, amount)
end)

RegisterNetEvent('wrp-hunting:PurchaseHuntingLicense')
AddEventHandler('wrp-hunting:PurchaseHuntingLicense', function()
    local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    if Player.cash >= 1500 then
        LocalPlayer:removeCash(Player.id, 1500)
        TriggerServerEvent('wrp-hunting:obtainLicense', exports['isPed']:isPed('cid'))
    else
        TriggerEvent('DoLongHudText', 'You do not have enough money to purchase a hunting license.')
    end
end)

RegisterCommand('checkhunting', function(source, args)
    if tostring(args[1]) == nil then
        TriggerEvent('DoLongHudText', 'Input a CID')
        return
    else
        if args[1] ~= nil then
            local argh = args[1]
            if exports['isPed']:isPed('job') == 'Police' then
                TriggerServerEvent('checkhunting', argh)
            end
        end
    end
end)

RegisterNetEvent('wrp-hunting:license:check')
AddEventHandler('wrp-hunting:license:check', function(license, cid)
    if license == (1 or '1') then
        license = 'True'
    else
        license = 'False'
    end
    TriggerEvent('DoLongHudText', 'Player CID : ' ..cid.. ' | Hunting License Status = ' ..license)
end)
local aim = false

Citizen.CreateThread(function()
	while true do
		local sleep = 250
    Citizen.Wait(sleep)
    if IsPlayerFreeAiming(PlayerId()) == false and HasPedGotWeapon(PlayerPedId(), GetHashKey('WEAPON_SNIPERRIFLE')) then 
          DisablePlayerFiring(PlayerPedId(), true)
      if IsPlayerFreeAiming(PlayerId()) == 1 and HasPedGotWeapon(PlayerPedId(), GetHashKey('WEAPON_SNIPERRIFLE')) then

        DisablePlayerFiring(PlayerPedId(), false)

      end

    end
    if IsControlJustPressed(0,25) and HasPedGotWeapon(PlayerPedId(), GetHashKey('WEAPON_SNIPERRIFLE'))  then
      SendNUIMessage({
        display = true,
      })
      HideHudComponentThisFrame(14)
    elseif IsControlJustReleased(0,25) and HasPedGotWeapon(PlayerPedId(), GetHashKey('WEAPON_SNIPERRIFLE'))   then
      SendNUIMessage({
        display = false,
      })
    end
    local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())

    if IsPedAPlayer(targetPed) and HasPedGotWeapon(PlayerPedId(), GetHashKey('WEAPON_SNIPERRIFLE')) then
      RemoveWeaponFromPed(PlayerPedId(), GetHashKey('WEAPON_SNIPERRIFLE'))
          
      TriggerEvent('DoLongHudText', 'Hunting Humans is illegal!', 2)
      Citizen.Wait(1000)
    end
        
    sleep = 0
    timer = timer + 1
    SetAmmoInClip(PlayerPedId(), 'WEAPON_SNIPERRIFLE', 10)
    SetPedInfiniteAmmo(PlayerPedId(), true, GetHashKey('WEAPON_SNIPERRIFLE'))
    if timer > 180000 then 
      TriggerServerEvent('wrp-hunting:removeloadout')
      TriggerEvent('DoLongHudText', 'Uh oh! you ran out of time, yoink!', 2)
      timer = 0
      OnGoingHuntSession = false
        if HasPedGotWeapon(PlayerPedId(), GetHashKey('WEAPON_SNIPERRIFLE'), false) then
          RemoveWeaponFromPed(PlayerPedId(), GetHashKey('WEAPON_SNIPERRIFLE'))
          SetPedInfiniteAmmo(PlayerPedId(), false, GetHashKey('WEAPON_SNIPERRIFLE'))
        end
      end
    end
end)
    --
