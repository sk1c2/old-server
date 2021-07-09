local inCasino = false
local carOnShow = `elegy`
local polyEntryTimeout = false
local enterFirstTime = true
local entranceTeleportCoords = vector3(1089.73,206.36,-48.99 + 0.05)
local exitTeleportCoords = vector3(934.46, 45.83, 81.1 + 0.05)
CasinoOpen = true
local spinningObject = nil
local spinningCar = nil

RegisterNetEvent('wrp-casino:unlock')
AddEventHandler('wrp-casino:unlock', function()
  CasinoOpen = true
end)

RegisterNetEvent('wrp-casino:lock')
AddEventHandler('wrp-casino:lock', function()
  CasinoOpen = false
end)

RegisterCommand('casino', function()
  if exports['isPed']:isPed('job') == 'DiamondCasino' then
    if CasinoOpen then
      TriggerServerEvent('wrp-casino:lock')
      TriggerEvent('DoLongHudText', 'The Casino Is Now Closed!')
    else
      TriggerServerEvent('wrp-unlock:casino')
      TriggerEvent('DoLongHudText', 'The Casino Is Now Open!')
    end
  else
    TriggerEvent('DoLongHudText', 'You\'re not whitelisted to use this command!', 2)
  end
end)

AddEventHandler('onClientGameTypeStart', function()
  TriggerServerEvent('wrp-casino:CheckIfOpen')
end)

-- CAR FOR WINS
function drawCarForWins()
  if DoesEntityExist(spinningCar) then
    DeleteEntity(spinningCar)
  end
  RequestModel(carOnShow)
	while not HasModelLoaded(carOnShow) do
		Citizen.Wait(0)
  end
  SetModelAsNoLongerNeeded(carOnShow)
  spinningCar = CreateVehicle(carOnShow, 1100.0, 220.0, -51.0 + 0.05, 0.0, 0, 0)
  Wait(0)
  SetVehicleDirtLevel(spinningCar, 0.0)
  SetVehicleOnGroundProperly(spinningCar)
  Wait(0)
  FreezeEntityPosition(spinningCar, 1)
end
-- END CAR FOR WINS

AddEventHandler("wrp-casino:elevatorEnterCasino", function()
  enterCasino(true, true)
end)
AddEventHandler("wrp-casino:elevatorExitCasino", function()
  enterCasino(false, true)
end)

function DrawText3D(x,y,z, text)
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

Citizen.CreateThread(function()
  while true do
    if CasinoOpen then
      if #(GetEntityCoords(PlayerPedId()) - vector3(1089.678, 205.7735, -48.99973)) < 1 then
        DrawText3D(1089.678, 205.7735, -48.99973, '[E] Exit The Casino')
        if IsControlJustPressed(0, 38) then
          if exports['wrp-inventory']:hasEnoughOfItem('casinokey', 1) then
            inCasino = false
            SetEntityCoords(PlayerPedId(), 934.46, 45.83, 81.1 + 0.05, 0.0, 0.0, 0.0, 0)
            SetEntityHeading(PlayerPedId(), 155.6763916)
          end
        end
      else
        Citizen.Wait(2000)
      end
    else
      Citizen.Wait(2000)
    end
    Wait(4)
    end
end)

Citizen.CreateThread(function()
  while true do
    if CasinoOpen then
      if #(GetEntityCoords(PlayerPedId()) - vector3(935.9739, 47.14355, 81.09579)) < 1 then
        DrawText3D(935.9739, 47.14355, 81.09579, '[E] Enter The Casino')
        if IsControlJustPressed(0, 38) then
          if exports['wrp-inventory']:hasEnoughOfItem('casinokey', 1) then
            inCasino = true
            DoScreenFadeIn(1000)
            SetEntityCoords(PlayerPedId(), 1089.73,206.36,-48.99 + 0.05 + 0.05, 0.0, 0.0, 0.0, 0)
            SetEntityHeading(PlayerPedId(), 155.6763916)
            Citizen.Wait(1000)
            showDiamondsOnScreenBaby()
            spinMeRightRoundBaby()
            playSomeBackgroundAudioBaby()
            inCasino = true
            if DoesEntityExist(spinningCar) then
              DeleteEntity(spinningCar)
            end
          end
        end
      else
        Citizen.Wait(2000)
      end
    else
      Citizen.Wait(2000)
    end
    Wait(4)
    end
end)


function enterCasino(pIsInCasino, pFromElevator, pCoords, pHeading)
  if pIsInCasino == inCasino then return end
  if DoesEntityExist(spinningCar) then
    DeleteEntity(spinningCar)
  end
  local function doInitStuff()
    spinMeRightRoundBaby()
    showDiamondsOnScreenBaby()
    playSomeBackgroundAudioBaby()
  end
  inCasino = true
  DoScreenFadeIn(500)
  showDiamondsOnScreenBaby()
  SetEntityCoords(PlayerPedId(), 1089.73,206.36,-48.99 + 0.05, 0.0, 0.0, 0.0, 0)
  doInitStuff()
  if not pFromElevator then
    inCasino = true
    DoScreenFadeOut(500)
    Wait(500)
    NetworkFadeOutEntity(PlayerPedId(), true, true)
    Wait(300)
    SetPedCoordsKeepVehicle(PlayerPedId(), pCoords)
    SetEntityHeading(PlayerPedId(), pHeading)
    
    SetEntityCoords(PlayerPedId(), 1089.73,206.36,-48.99 + 0.05, 0.0, 0.0, 0.0, 0)

    Citizen.CreateThread(function()
      ClearPedTasksImmediately(PlayerPedId())
      SetGameplayCamRelativeHeading(0.0)
      NetworkFadeInEntity(PlayerPedId(), true)
      if inCasino then
        doInitStuff()
      end
      Citizen.Wait(500)
      DoScreenFadeIn(500)
    end)
  end
  if pFromElevator and inCasino then
    local pedCoords = GetEntityCoords(PlayerPedId())
    doInitStuff()
  end
  TriggerEvent("wrp-casino:casinoEnteredEvent")
  TriggerServerEvent('wrp-infinity:scopes:casino', true)
end

function spinMeRightRoundBaby()
  Citizen.CreateThread(function()
    while inCasino do
      if not spinningObject or spinningObject == 0 or not DoesEntityExist(spinningObject) then
        spinningObject = GetClosestObjectOfType(1100.0, 220.0, -51.0, 10.0, -1561087446, 0, 0, 0)
        drawCarForWins()
      end
      if spinningObject ~= nil and spinningObject ~= 0 then
        local curHeading = GetEntityHeading(spinningObject)
        local curHeadingCar = GetEntityHeading(spinningCar)
        if curHeading >= 360 then
          curHeading = 0.0
          curHeadingCar = 0.0
        elseif curHeading ~= curHeadingCar then
          curHeadingCar = curHeading
        end
        SetEntityHeading(spinningObject, curHeading + 0.075)
        SetEntityHeading(spinningCar, curHeadingCar + 0.075)
      end
      Wait(0)
    end
    spinningObject = nil
  end)
end

-- Casino Screens
local Playlists = {
  "CASINO_DIA_PL", -- diamonds
  "CASINO_SNWFLK_PL", -- snowflakes
  "CASINO_WIN_PL", -- win
  "CASINO_HLW_PL", -- skull
}
-- Render
function CreateNamedRenderTargetForModel(name, model)
  local handle = 0
  if not IsNamedRendertargetRegistered(name) then
      RegisterNamedRendertarget(name, 0)
  end
  if not IsNamedRendertargetLinked(model) then
      LinkNamedRendertarget(model)
  end
  if IsNamedRendertargetRegistered(name) then
      handle = GetNamedRendertargetRenderId(name)
  end

  return handle
end
-- render tv stuff
function showDiamondsOnScreenBaby()
  Citizen.CreateThread(function()
    inCasino = true
    local model = GetHashKey("vw_vwint01_video_overlay")
    local timeout = 21085 -- 5000 / 255

    local handle = CreateNamedRenderTargetForModel("CasinoScreen_01", model)

    RegisterScriptWithAudio(0)
    SetTvChannel(-1)
    SetTvVolume(0)
    SetScriptGfxDrawOrder(4)
    SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
    SetTvChannel(2)
    EnableMovieSubtitles(1)
    SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
    SetTvChannel(2)
    function doAlpha()
      Citizen.SetTimeout(timeout, function()
        SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
        SetTvChannel(2)
        doAlpha()
      end)
    end
    doAlpha()

    Citizen.CreateThread(function()
      while inCasino do
        SetTextRenderId(handle)
        DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
        SetTextRenderId(GetDefaultScriptRendertargetRenderId())
        Citizen.Wait(0)
      end
      SetTvChannel(-1)
      ReleaseNamedRendertarget(GetHashKey("CasinoScreen_01"))
      SetTextRenderId(GetDefaultScriptRendertargetRenderId())
    end)
  end)
end

function playSomeBackgroundAudioBaby()
  Citizen.CreateThread(function()
    local function audioBanks()
      while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_GENERAL", false, -1) do
        Citizen.Wait(0)
      end
      while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_01", false, -1) do
        Citizen.Wait(0)
      end
      while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_02", false, -1) do
        Citizen.Wait(0)
      end
      while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_03", false, -1) do
        Citizen.Wait(0)
      end
      -- while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_INTERIOR_STEMS", false, -1) do
      --   print('load 5')
      --   Wait(0)
      -- end
    end
    audioBanks()
    while inCasino do
      if not IsStreamPlaying() and LoadStream("casino_walla", "DLC_VW_Casino_Interior_Sounds") then
        PlayStreamFromPosition(1111, 230, -47)
      end
      if IsStreamPlaying() and not IsAudioSceneActive("DLC_VW_Casino_General") then
        StartAudioScene("DLC_VW_Casino_General")
      end
      Citizen.Wait(1000)
    end
    if IsStreamPlaying() then
      StopStream()
    end
    if IsAudioSceneActive("DLC_VW_Casino_General") then
      StopAudioScene("DLC_VW_Casino_General")
    end
  end)
end

local myPeds = {}
function handlePedCoordsBaby(pPedCoords)
  if not pPedCoords or not inCasino then return end
  for _, pedData in pairs(pPedCoords) do
    RequestModel(pedData.model)
    while not HasModelLoaded(pedData.model) do
      Wait(0)
    end
    SetModelAsNoLongerNeeded(pedData.model)
    local ped = CreatePed(pedData._pedType, pedData.model, pedData.coords, pedData.heading, 1, 1)
    while not DoesEntityExist(ped) do
      Wait(0)
    end
    SetPedRandomComponentVariation(ped, 0)
    local pedNetId = 0
    while NetworkGetNetworkIdFromEntity(ped) == 0 do
      Wait(0)
    end
    TaskSetBlockingOfNonTemporaryEvents(ped, true)
    pedNetId = NetworkGetNetworkIdFromEntity(ped)
    SetNetworkIdCanMigrate(ped, true)
    myPeds[#myPeds + 1] = { entity = ped, scenario = pedData.scenario, netId = pedNetId }
    Wait(0)
  end
  -- RPC.execute("wrp-casino:handoffPedData", myPeds)
  Citizen.CreateThread(function()
    while inCasino do
      for _, ped in pairs(myPeds) do
        if math.random() < 0.01 then
          TaskWanderStandard(ped.entity)
        elseif not IsPedActiveInScenario(ped.entity) then
          ClearPedTasks(ped.entity)
          TaskStartScenarioInPlace(ped.entity, ped.scenario, 0, 1)
        end
      end
      Wait(15000)
    end
  end)
  -- debug
  -- Citizen.CreateThread(function()
  --   while inCasino do
  --     for _, ped in pairs(myPeds) do
  --       if #(GetEntityCoords(ped.entity) - GetEntityCoords(PlayerPedId())) < 1.2 then
  --         print(ped.entity, ped.scenario)
  --       end
  --     end
  --     Wait(1000)
  --   end
  -- end)
end

-- RegisterCommand("incas", function()
--   inCasino = not inCasino
-- end)

-- Citizen.CreateThread(function()
--   -- StartScreenEffect("SwitchOpenNeutralFIB5", 2000, 0)
--   -- Wait(400)
--   -- StartScreenEffect("PeyoteOut", 4000, 0)
--   -- Wait(1600)
--   -- StopScreenEffect("SwitchOpenNeutralFIB5")
--   -- Wait(3000)
--   -- StopScreenEffect("PeyoteOut")
--   SetTimecycleModifier("BarryFadeOut")
--   Wait(4000)
--   local idx = 1.0
--   while idx > 0 do
--     Wait(32)
--     SetTimecycleModifierStrength(idx)
--     idx = idx - 0.02
--   end
--   ClearTimecycleModifier()
-- end)

--testing and setup
-- local casinoEntranceCoords = vector3(1089.73, 206.36, -48.99)
-- local coordsBro = {}
-- RegisterCommand("+addCasinoCoords", function()
--   local coords = GetEntityCoords(PlayerPedId())
--   local heading = GetEntityHeading(PlayerPedId())
--   print('regular', coords, heading)
--   -- local interior = GetInteriorAtCoords(1100.000, 220.000, -50.000)
--   -- local offset = GetOffsetFromInteriorInWorldCoords(interior, coords)
--   local entity = GetClosestObjectOfType(1100.0, 220.0, -51.0, 10.0, -1561087446, 0, 0, 0) -- spinny boi
--   print(entity)
--   SetEntityHeading(entity, 0.0)
--   local offset = GetOffsetFromEntityGivenWorldCoords(entity, coords)
--   print('offset', offset)
--   coordsBro[#coordsBro + 1] = {
--     entityExists = entity ~= 0,
--     coords = coords,
--     offset = offset,
--     heading = heading,
--     flag = 0,
--   }
--   print(json.encode(coordsBro))
--   print(json.encode(coordsBro[#coordsBro]))
-- end, false)
-- RegisterCommand("-addCasinoCoords", function() end, false)

-- -- 1 = FILM SHOCKING
-- -- 2 = BROWSE
-- -- 3 = RANDOM
-- -- 4 = SIT
-- RegisterCommand("doflag", function(src, args)
--   print(src, json.encode(args))
--   coordsBro[#coordsBro].flag = args[1]
--   print(json.encode(coordsBro[#coordsBro]))
-- end, false)
-- Citizen.CreateThread(function()
--   exports["wrp-keybinds"]:registerKeyMapping("", "Casino", "Add Coords", "+addCasinoCoords", "-addCasinoCoords")
-- end)

-- Citizen.CreateThread(function()
--   for _, v in pairs(exports["wrp-casino"]:getPedCoordsC()) do
--     if #(vector3(v.coords.x, v.coords.y, v.coords.z) - vector3(1094.15,220.64,-48.99) ) < 2.5 then
--       print(v.coords.x, v.coords.y, v.coords.z)
--       SetEntityCoords(PlayerPedId(), v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0)
--       Wait(1000)
--     end
--   end
-- end)





local coords = {
  { x = 926.33270263672, y = 50.53105545044, z = 81.106346130372, h = 61.063388824462, model = GetHashKey("S_M_Y_Casino_01"), anim = nil, lib = nil},
  { x = 921.33660888672, y = 42.039409637452, z = 81.096099853516, h = 105.19635772706, model = GetHashKey("s_m_y_waiter_01"), anim = "WORLD_HUMAN_SMOKING", lib = nil},
  { x = 920.53686523438, y = 40.84984588623, z = 81.096115112304, h = 11.492302894592, model = GetHashKey("a_m_m_paparazzi_01"), anim = "WORLD_HUMAN_SMOKING", lib = nil},
  { x = 919.56420898438, y = 42.164630889892, z = 81.096130371094, h = 238.3455505371, model = GetHashKey("a_f_y_bevhills_04"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 915.474609375, y = 59.522361755372, z = 80.895309448242, h = 188.88311767578, model = GetHashKey("a_f_y_hipster_02"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 914.62158203125, y = 58.063289642334, z = 80.89535522461, h = 292.25811767578, model = GetHashKey("a_f_y_genhot_01"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1088.1118164062, y = 221.1591796875, z = -49.200401306152, h = 179.07611083984, model = GetHashKey("S_M_Y_Casino_01"), anim = nil, lib = nil},
  { x = 1113.2401123046, y = 207.32516479492, z = -49.440128326416, h = 232.06127929688, model = GetHashKey("S_M_Y_Casino_01"), anim = nil, lib = nil},
  { x = 1111.8663330078, y = 209.58251953125, z = -49.440128326416, h = 354.55651855468, model = GetHashKey("S_F_Y_Casino_01"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1110.6451416016, y = 207.32397460938, z = -49.440128326416, h = 111.82973480224, model = GetHashKey("S_M_Y_Casino_01"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1100.69921875, y = 195.5161743164, z = -49.440074920654, h = 313.71264648438, model = GetHashKey("u_f_m_miranda_02"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1117.5845947266, y = 219.54907226562, z = -49.435111999512, h = 79.745155334472, model = GetHashKey("S_F_Y_Casino_01"), anim = "base", lib = "amb@prop_human_bum_shopping_cart@male@base"},
  { x = 1101.7528076172, y = 249.64517211914, z = -50.440746307374, h = 263.28268432618, model = GetHashKey("S_M_Y_Casino_01"), anim = nil, lib = nil},
  { x = 1139.4091796875, y = 234.80795288086, z = -50.440803527832, h = 45.778419494628, model = GetHashKey("S_M_Y_Casino_01"), anim = nil, lib = nil},
  { x = 1107.4212646484, y = 255.19960021972, z = -50.440776824952, h = 202.38905334472, model = GetHashKey("S_M_Y_Casino_01"), anim = nil, lib = nil},
  { x = 1123.076538086, y = 252.75128173828, z = -50.040843963624, h = 62.128601074218, model = GetHashKey("S_M_Y_Casino_01"), anim = nil, lib = nil},
  { x = 1134.726196289, y = 240.93083190918, z = -50.040786743164, h = 213.48844909668, model = GetHashKey("S_M_Y_Casino_01"), anim = nil, lib = nil},
  { x = 1139.203491211, y = 270.1647644043, z = -51.440818786622, h = 151.17344665528, model = GetHashKey("S_M_Y_Casino_01"), anim = nil, lib = nil},
  { x = 1152.525024414, y = 257.12759399414, z = -51.440799713134, h = 90.272407531738, model = GetHashKey("S_M_Y_Casino_01"), anim = nil, lib = nil},
  { x = 1084.7447509766, y = 221.31216430664, z = -49.200374603272, h = 231.98306274414, model = GetHashKey("S_F_Y_Casino_01"), anim = nil, lib = nil},
  { x = 1119.0314941406, y = 214.37855529786, z = -49.440074920654, h = 114.95320892334, model = GetHashKey("S_M_Y_Casino_01"), anim = nil, lib = nil},
  { x = 1087.730102539, y = 209.90563964844, z = -49.000183105468, h = 345.16372680664, model = GetHashKey("ig_taostranslator"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1087.8247070312, y = 210.9969177246, z = -49.000183105468, h = 148.59184265136, model = GetHashKey("ig_molly"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1094.701538086, y = 221.94158935546, z = -48.994998931884, h = 249.87202453614, model = GetHashKey("ig_milton"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  {x = 1129.1798095704, y = 235.1319732666, z = -50.440818786622, h = 319.06478881836, model = GetHashKey("ig_milton"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1097.8903808594, y = 225.22456359864, z = -48.994995117188, h = 199.26055908204, model = GetHashKey("ig_djtalignazio"), anim = "world_human_tourist_mobile", lib = nil},
  { x = 1106.0510253906, y = 239.01390075684, z = -49.840797424316, h = 206.40699768066, model = GetHashKey("ig_djsolmanager"), anim = "owner_idle", lib = "anim@heists@fleeca_bank@ig_7_jetski_owner"},
  { x = 1120.4401855468, y = 258.97180175782, z = -50.440711975098, h = 228.21603393554, model = GetHashKey("ig_djsolmanager"), anim = "owner_idle", lib = "anim@heists@fleeca_bank@ig_7_jetski_owner"},
  { x = 1109.4263916016, y = 210.63626098632, z = -49.44013595581, h = 228.0699005127, model = GetHashKey("ig_car3guy1"), anim = "base", lib = "amb@prop_human_bum_shopping_cart@male@base"},
  { x = 1092.570678711, y = 217.13481140136, z = -49.200359344482, h = 112.46558380126, model = GetHashKey("a_f_m_bevhills_02"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1091.4907226562, y = 217.74900817872, z = -49.200359344482, h = 225.67277526856, model = GetHashKey("a_f_y_bevhills_03"), anim = "idle_b", lib = 'amb@world_human_hang_out_street@female_hold_arm@idle_a'},
  { x = 1091.8024902344, y = 216.47998046875, z = -49.200374603272, h = 319.34759521484, model = GetHashKey("a_m_y_beachvesp_02"), anim = "base", lib = 'amb@world_human_hang_out_street@male_c@base'},
  { x = 1102.3162841796, y = 214.84544372558, z = -48.994995117188, h = 20.17435836792, model = GetHashKey("mp_f_boatstaff_01"), anim = "idle_reject_loop_a", lib = 'mini@hookers_spcokehead'},
  { x = 1103.1042480468, y = 215.25611877442, z = -48.994918823242, h = 34.57954788208, model = GetHashKey("u_m_m_jewelsec_01"), anim = "WORLD_HUMAN_COP_IDLES", lib = nil},
  { x = 1106.2315673828, y = 220.5295715332, z = -48.994937896728, h = 88.68659210205, model = GetHashKey("u_m_y_chip"), anim = "WORLD_HUMAN_MOBILE_FILM_SHOCKING", lib = nil},
  { x = 1112.289428711, y = 211.54219055176, z = -49.440132141114, h = 173.7571105957, model = GetHashKey("u_m_y_gunvend_01"), anim = "idle_a", lib = 'anim@amb@clubhouse@bar@drink@base'},
  { x = 1115.1496582032, y = 209.59790039062, z = -49.440132141114, h = 299.9878540039, model = GetHashKey("u_m_y_tattoo_01"), anim = "base_bartender", lib = 'anim@amb@clubhouse@bar@bartender@'},
  { x = 1108.5438232422, y = 208.83781433106, z = -49.440086364746, h = 90.024894714356, model = GetHashKey("u_m_y_smugmech_01"), anim = "base", lib = 'amb@world_human_leaning@male@wall@back@foot_up@base'},
  { x = 1108.9083251954, y = 206.16261291504, z = -49.440086364746, h = 304.02127075196, model = GetHashKey("u_f_y_princess"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  { x = 1111.6861572266, y = 204.49493408204, z = -49.440086364746, h = 3.7979333400726, model = GetHashKey("u_f_y_spyactress"), anim = "idle_a", lib = 'anim@amb@clubhouse@bar@drink@base'},
  { x = 1114.4895019532, y = 205.60066223144, z = -49.440086364746, h = 45.58916091919, model = GetHashKey("u_f_y_jewelass_01"), anim = "base", lib = 'amb@prop_human_bum_shopping_cart@male@base'},
  { x = 1101.8717041016, y = 226.83073425292, z = -48.999729156494, h = 250.48944091796, model = GetHashKey("s_m_y_doorman_01"), anim = "base", lib = 'amb@world_human_leaning@male@wall@back@foot_up@base'},
  { x = 1115.5576171875, y = 222.28282165528, z = -49.435108184814, h = 237.63806152344, model = GetHashKey("s_m_y_dealer_01"), anim = "CODE_HUMAN_CROSS_ROAD_WAIT", lib = nil},
  { x = 1105.8818359375, y = 214.5785369873, z = -49.44013595581, h = 236.1162109375, model = GetHashKey("s_m_m_hairdress_01"), anim = "WORLD_HUMAN_HANG_OUT_STREET", lib = nil},
  { x = 1106.7518310546, y = 214.32290649414, z = -49.44013595581, h = 77.781219482422, model = GetHashKey("a_f_y_vinewood_04"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1116.441772461, y = 248.25189208984, z = -50.440719604492, h = 317.20477294922, model = GetHashKey("a_f_y_vinewood_04"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1127.4829101562, y = 256.54837036132, z = -50.440826416016, h = 146.6262512207, model = GetHashKey("a_f_y_tourist_02"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1108.3166503906, y = 219.45585632324, z = -49.440128326416, h = 202.77284240722, model = GetHashKey("a_f_y_tourist_02"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1108.7375488282, y = 218.135055542, z = -49.440128326416, h = 2.6883318424224, model = GetHashKey("a_m_m_malibu_01"), anim = "WORLD_HUMAN_HANG_OUT_STREET", lib = nil},
  { x = 1109.3825683594, y = 219.1626586914, z = -49.440128326416, h = 92.90966796875, model = GetHashKey("a_m_y_beachvesp_02"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1096.0826416016, y = 207.71138000488, z = -48.999816894532, h = 342.25402832032, model = GetHashKey("a_m_y_bevhills_01"), anim = "WORLD_HUMAN_LEANING", lib = nil},
  { x = 1100.4816894532, y = 206.73020935058, z = -49.440074920654, h = 300.8337097168, model = GetHashKey("a_m_y_hipster_01"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1101.6794433594, y = 206.32473754882, z = -49.440074920654, h = 81.415405273438, model = GetHashKey("a_m_y_genstreet_01"), anim = "WORLD_HUMAN_HANG_OUT_STREET", lib = nil},
  { x = 1100.875, y = 201.49240112304, z = -49.440078735352, h = 47.41083908081, model = GetHashKey("a_f_y_vinewood_02"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  { x = 1103.7026367188, y = 195.42013549804, z = -49.440078735352, h = 220.57640075684, model = GetHashKey("a_f_y_vinewood_02"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  { x = 1110.5168457032, y = 199.61912536622, z = -49.43983078003, h = 35.346942901612, model = GetHashKey("a_f_y_scdressy_01"), anim = "base", lib = 'timetable@ron@ig_3_couch'},
  { x = 1112.87890625, y = 201.07264709472, z = -49.440143585206, h = 20.638647079468, model = GetHashKey("a_m_y_clubcust_03"), anim = "base", lib = 'timetable@ron@ig_3_couch'},
  { x = 1109.9499511718, y = 200.76585388184, z = -49.440147399902, h = 206.50035095214, model = GetHashKey("a_m_y_hipster_01"), anim = "WORLD_HUMAN_HANG_OUT_STREET", lib = nil},
  { x = 1113.0399169922, y = 202.31575012208, z = -49.440143585206, h = 185.72970581054, model = GetHashKey("a_m_y_hipster_03"), anim = "CODE_HUMAN_CROSS_ROAD_WAIT", lib = nil},
  { x = 1111.3000488282, y = 201.42584228516, z = -49.440143585206, h = 261.39938354492, model = GetHashKey("a_m_y_hipster_02"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1112.7646484375, y = 218.5271911621, z = -49.440086364746, h = 187.39511108398, model = GetHashKey("a_f_y_hipster_02"), anim = "CODE_HUMAN_CROSS_ROAD_WAIT", lib = nil},
  { x = 1113.2957763672, y = 217.66007995606, z = -49.440086364746, h = 23.888305664062, model = GetHashKey("a_f_y_hipster_01"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1110.1495361328, y = 213.9571685791, z = -49.440086364746, h = 295.1508178711, model = GetHashKey("cs_dale"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1110.5064697266, y = 214.61933898926, z = -49.440086364746, h = 201.2684020996, model = GetHashKey("cs_chengsr"), anim = "WORLD_HUMAN_HANG_OUT_STREET", lib = nil},
  { x = 1111.2890625, y = 214.28991699218, z = -49.440090179444, h = 109.4663696289, model = GetHashKey("cs_jimmyboston"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  { x = 1110.8735351562, y = 213.43058776856, z = -49.440090179444, h = 21.7202835083, model = GetHashKey("cs_gurk"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1119.0744628906, y = 210.2978515625, z = -49.440090179444, h = 85.048988342286, model = GetHashKey("cs_lazlow_2"), anim = "WORLD_HUMAN_PARTYING", lib = nil},
  { x = 1119.4295654296, y = 211.25352478028, z = -49.44013595581, h = 97.073272705078, model = GetHashKey("cs_jimmydisanto"), anim = "WORLD_HUMAN_MOBILE_FILM_SHOCKING", lib = nil},
  { x = 1117.8083496094, y = 211.24374389648, z = -49.4401512146, h = 258.77465820312, model = GetHashKey("cs_carbuyer"), anim = "CODE_HUMAN_CROSS_ROAD_WAIT", lib = nil},
  { x = 1118.7680664062, y = 206.79531860352, z = -49.440132141114, h = 101.99925231934, model = GetHashKey("cs_fbisuit_01"), anim = "base", lib = 'timetable@ron@ig_3_couch'},
  { x = 1116.4266357422, y = 202.75718688964, z = -49.440139770508, h = 37.840324401856, model = GetHashKey("cs_lazlow"), anim = "base", lib = 'timetable@ron@ig_3_couch'},
  { x = 1116.5494384766, y = 205.5652923584, z = -49.440128326416, h = 49.62559890747, model = GetHashKey("cs_movpremmale"), anim = "WORLD_HUMAN_PARTYING", lib = nil},
  { x = 1114.421875, y = 214.01695251464, z = -49.440124511718, h = 104.07958221436, model = GetHashKey("cs_stevehains"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1108.181640625, y = 223.53260803222, z = -49.793521881104, h = 18.68741607666, model = GetHashKey("cs_paper"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1107.6862792968, y = 224.6951751709, z = -49.84075164795, h = 203.7003479004, model = GetHashKey("cs_tom"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  { x = 1121.8559570312, y = 226.17976379394, z = -49.840797424316, h = 77.099090576172, model = GetHashKey("ig_djsolmanager"), anim = "owner_idle", lib = "anim@heists@fleeca_bank@ig_7_jetski_owner"},
  { x = 1121.1066894532, y = 228.54165649414, z = -49.840797424316, h = 359.15673828125, model = GetHashKey("cs_siemonyetarian"), anim = "WORLD_HUMAN_CHEERING", lib = nil},
  { x = 1099.2228271484, y = 252.25634155274, z = -50.840950012208, h = 21.399730682374, model = GetHashKey("s_m_y_airworker"), anim = "WORLD_HUMAN_HAMMERING", lib = nil},
  { x = 1104.5671386718, y = 257.4889831543, z = -50.84094619751, h = 73.700790405274, model = GetHashKey("s_m_y_airworker"), anim = "WORLD_HUMAN_HAMMERING", lib = nil},
  { x = 1100.8072509766, y = 265.75598144532, z = -51.24087524414, h = 324.1028137207, model = GetHashKey("s_m_y_airworker"), anim = "WORLD_HUMAN_HAMMERING", lib = nil},
  { x = 1104.7365722656, y = 264.34991455078, z = -50.840858459472, h = 44.932250976562, model = GetHashKey("s_m_m_dockwork_01"), anim = "WORLD_HUMAN_HAMMERING", lib = nil},
  { x = 1093.1435546875, y = 254.54629516602, z = -51.240867614746, h = 147.45317077636, model = GetHashKey("s_m_m_dockwork_01"), anim = "WORLD_HUMAN_HAMMERING", lib = nil},
  { x = 1094.0794677734, y = 260.13485717774, z = -51.240871429444, h = 20.8503780365, model = GetHashKey("s_m_m_dockwork_01"), anim = "WORLD_HUMAN_WELDING", lib = nil},
  { x = 1090.6103515625, y = 263.45626831054, z = -51.240871429444, h = 54.287101745606, model = GetHashKey("s_m_m_dockwork_01"), anim = "WORLD_HUMAN_WELDING", lib = nil},
  { x = 1111.5848388672, y = 253.52276611328, z = -50.440856933594, h = 135.2487335205, model = GetHashKey("s_m_m_dockwork_01"), anim = "owner_idle", lib = "anim@heists@fleeca_bank@ig_7_jetski_owner"},
  { x = 1101.5947265625, y = 244.5637512207, z = -50.440753936768, h = 45.782859802246, model = GetHashKey("s_m_m_hairdress_01"), anim = "owner_idle", lib = "anim@heists@fleeca_bank@ig_7_jetski_owner"},
  { x = 1098.0649414062, y = 239.08195495606, z = -50.440753936768, h = 323.11743164062, model = GetHashKey("s_m_m_fiboffice_02"), anim = "owner_idle", lib = "anim@heists@fleeca_bank@ig_7_jetski_owner"},
  { x = 1102.1484375, y = 235.29586791992, z = -49.840747833252, h = 229.45254516602, model = GetHashKey("s_m_m_hairdress_01"), anim = "WORLD_HUMAN_LEANING", lib = nil},
  { x = 1111.5794677734, y = 237.19116210938, z = -49.84075164795, h = 7.1221842765808, model = GetHashKey("s_m_m_autoshop_01"), anim = "WORLD_HUMAN_CHEERING", lib = nil},
  { x = 1115.9565429688, y = 238.73756408692, z = -49.840755462646, h = 267.87698364258, model = GetHashKey("s_m_m_lifeinvad_01"), anim = "WORLD_HUMAN_SMOKING", lib = nil},
  { x = 1117.1931152344, y = 237.48654174804, z = -49.840759277344, h = 7.6725339889526, model = GetHashKey("s_f_y_shop_low"), anim = "WORLD_HUMAN_SMOKING", lib = nil},
  { x = 1120.0593261718, y = 234.20481872558, z = -49.840808868408, h = 89.032974243164, model = GetHashKey("s_f_y_bartender_01"), anim = "WORLD_HUMAN_SMOKING", lib = nil},
  { x = 1117.1477050782, y = 240.3937072754, z = -50.440711975098, h = 311.78479003906, model = GetHashKey("s_m_m_lifeinvad_01"), anim = "WORLD_HUMAN_SMOKING", lib = nil},
  { x = 1116.7313232422, y = 241.88082885742, z = -50.440711975098, h = 177.8970489502, model = GetHashKey("s_f_y_clubbar_01"), anim = "WORLD_HUMAN_SMOKING", lib = nil},
  { x = 1124.1864013672, y = 235.0325164795, z = -50.440719604492, h = 46.788021087646, model = GetHashKey("s_m_m_doctor_01"), anim = "CODE_HUMAN_MEDIC_TEND_TO_DEAD", lib = nil},
  { x = 1123.6042480468, y = 235.70350646972, z = -50.440727233886, h = 129.27153015136, model = GetHashKey("s_f_y_sweatshop_01"), anim = "WORLD_HUMAN_SUNBATHE_BACK", lib = nil},
  { x = 1123.3104248046, y = 244.49044799804, z = -50.440784454346, h = 163.50486755372, model = GetHashKey("s_m_y_barman_01"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1126.1030273438, y = 242.20681762696, z = -50.440788269042, h = 118.04579925538, model = GetHashKey("s_m_y_dealer_01"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1122.2630615234, y = 249.85026550292, z = -50.040851593018, h = 230.0336303711, model = GetHashKey("cs_jimmydisanto"), anim = "WORLD_HUMAN_MOBILE_FILM_SHOCKING", lib = nil},
  { x = 1125.3696289062, y = 252.09078979492, z = -50.04084777832, h = 147.58512878418, model = GetHashKey("cs_fbisuit_01"), anim = "base", lib = 'timetable@ron@ig_3_couch'},
  { x = 1126.6879882812, y = 250.8588104248, z = -50.040843963624, h = 101.32151031494, model = GetHashKey("cs_lazlow"), anim = "base", lib = 'timetable@ron@ig_3_couch'},
  { x = 1126.1923828125, y = 248.89428710938, z = -50.040843963624, h = 88.825912475586, model = GetHashKey("cs_movpremmale"), anim = "WORLD_HUMAN_PARTYING", lib = nil},
  { x = 1131.6889648438, y = 240.03800964356, z = -50.040790557862, h = 18.210039138794, model = GetHashKey("cs_jimmydisanto"), anim = "WORLD_HUMAN_MOBILE_FILM_SHOCKING", lib = nil},
  { x = 1134.2785644532, y = 243.27833557128, z = -50.04084777832, h = 113.45347595214, model = GetHashKey("cs_fbisuit_01"), anim = "base", lib = 'timetable@ron@ig_3_couch'},
  { x = 1131.8524169922, y = 244.87306213378, z = -50.02530670166, h = 169.28451538086, model = GetHashKey("cs_lazlow"), anim = "base", lib = 'timetable@ron@ig_3_couch'},
  { x = 1130.5439453125, y = 243.75675964356, z = -50.040790557862, h = 209.62516784668, model = GetHashKey("cs_movpremmale"), anim = "WORLD_HUMAN_PARTYING", lib = nil},
  { x = 1133.7504882812, y = 249.92268371582, z = -51.035724639892, h = 118.3296585083, model = GetHashKey("s_f_y_hooker_03"), anim = "WORLD_HUMAN_CHEERING", lib = nil},
  { x = 1132.8123779296, y = 256.23333740234, z = -51.035732269288, h = 315.92041015625, model = GetHashKey("s_f_y_hooker_02"), anim = "WORLD_HUMAN_CHEERING", lib = nil},
  { x = 1129.5539550782, y = 256.68243408204, z = -51.040798187256, h = 346.48342895508, model = GetHashKey("s_f_y_hooker_01"), anim = "owner_idle", lib = "anim@heists@fleeca_bank@ig_7_jetski_owner"},
  { x = 1137.7536621094, y = 256.3706665039, z = -51.035785675048, h = 148.82174682618, model = GetHashKey("s_m_y_dealer_01"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1136.2303466796, y = 250.35260009766, z = -51.035785675048, h = 42.495178222656, model = GetHashKey("cs_dale"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1135.2712402344, y = 250.26078796386, z = -51.035781860352, h = 317.00582885742, model = GetHashKey("cs_chengsr"), anim = "WORLD_HUMAN_HANG_OUT_STREET", lib = nil},
  { x = 1135.7280273438, y = 251.44345092774, z = -51.035781860352, h = 204.36491394042, model = GetHashKey("cs_jimmyboston"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  { x = 1133.448852539, y = 253.17956542968, z = -51.035781860352, h = 246.52224731446, model = GetHashKey("a_m_y_hipster_01"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1133.7673339844, y = 252.6283569336, z = -51.035781860352, h = 10.484577178956, model = GetHashKey("a_f_y_hipster_01"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  { x = 1138.5260009766, y = 245.47497558594, z = -50.440795898438, h = 131.91996765136, model = GetHashKey("a_f_y_hipster_01"), anim = "WORLD_HUMAN_LEANING", lib = nil},
  { x = 1142.6199951172, y = 254.5503692627, z = -51.441284179688, h = 282.5180053711, model = GetHashKey("s_f_y_clubbar_01"), anim = "WORLD_HUMAN_SMOKING", lib = nil},
  { x = 1142.9422607422, y = 255.49067687988, z = -51.442440032958, h = 208.05438232422, model = GetHashKey("s_m_m_lifeinvad_01"), anim = "WORLD_HUMAN_SMOKING", lib = nil},
  { x = 1137.2374267578, y = 260.8165588379, z = -51.441905975342, h = 135.03169250488, model = GetHashKey("a_m_m_paparazzi_01"), anim = "WORLD_HUMAN_PARTYING", lib = nil},
  { x = 1136.4453125, y = 260.37084960938, z = -51.440811157226, h = 309.88494873046, model = GetHashKey("a_m_m_malibu_01"), anim = "WORLD_HUMAN_PARTYING", lib = nil},
  {x = 1139.6691894532, y = 261.45889282226, z = -51.440822601318, h = 232.63442993164, model = GetHashKey("a_m_y_bevhills_01"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  {x = 1140.316040039, y = 261.11599731446, z = -51.440822601318, h = 57.27950668335, model = GetHashKey("u_f_y_spyactress"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  {x = 1144.712890625, y = 270.55331420898, z = -51.840824127198, h = 284.3157043457, model = GetHashKey("a_m_m_bevhills_02"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  {x = 1145.5831298828, y = 270.54998779296, z = -51.840824127198, h = 97.176879882812, model = GetHashKey("a_f_m_business_02"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  {x = 1142.7232666016, y = 267.61892700196, z = -51.840824127198, h = 316.02542114258, model = GetHashKey("a_f_y_bevhills_02"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  {x = 1143.4125976562, y = 268.49368286132, z = -51.840824127198, h = 139.87689208984, model = GetHashKey("a_f_y_bevhills_03"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  { x = 1148.8698730468, y = 266.0330505371, z = -51.840831756592, h = 45.648777008056, model = GetHashKey("a_m_y_busicas_01"), anim = "WORLD_HUMAN_STAND_IMPATIENT", lib = nil},
  { x = 1148.0423583984, y = 266.14901733398, z = -51.840831756592, h = 314.4123840332, model = GetHashKey("a_m_m_soucent_02"), anim = "WORLD_HUMAN_HANG_OUT_STREET", lib = nil},
  { x = 1148.0189208984, y = 266.8080444336, z = -51.840831756592, h = 229.38090515136, model = GetHashKey("a_f_y_business_02"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  { x = 1148.7935791016, y = 266.79452514648, z = -51.840831756592, h = 142.29901123046, model = GetHashKey("a_f_y_bevhills_04"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1148.8022460938, y = 261.6181640625, z = -51.840839385986, h = 342.93759155274, model = GetHashKey("a_m_y_gay_01"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  { x = 1149.0766601562, y = 262.41891479492, z = -51.840839385986, h = 156.49407958984, model = GetHashKey("a_m_y_gay_02"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1152.303100586, y = 263.66244506836, z = -51.840839385986, h = 136.08438110352, model = GetHashKey("a_f_y_business_03"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  { x = 1151.7239990234, y = 263.05950927734, z = -51.840839385986, h = 313.24829101562, model = GetHashKey("a_f_y_business_04"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1145.2999267578, y = 263.58041381836, z = -51.840827941894, h = 140.10317993164, model = GetHashKey("a_f_y_clubcust_02"), anim = "WORLD_HUMAN_MOBILE_FILM_SHOCKING", lib = nil},
  { x = 1143.2174072266, y = 252.02227783204, z = -51.035774230958, h = 228.96563720704, model = GetHashKey("a_f_y_business_04"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1143.1245117188, y = 250.9208984375, z = -51.035774230958, h = 308.03094482422, model = GetHashKey("a_f_y_business_01"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1149.6876220704, y = 247.43537902832, z = -51.035774230958, h = 2.2500143051148, model = GetHashKey("cs_bankman"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  { x = 1149.7448730468, y = 248.66799926758, z = -51.035774230958, h = 175.08432006836, model = GetHashKey("cs_gurk"), anim = "WORLD_HUMAN_HANG_OUT_STREET", lib = nil},
  { x = 1132.5057373046, y = 260.59860229492, z = -51.035778045654, h = 343.58792114258, model = GetHashKey("cs_bankman"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1133.6719970704, y = 260.90658569336, z = -51.035778045654, h = 44.58012008667, model = GetHashKey("cs_gurk"), anim = "WORLD_HUMAN_STAND_MOBILE", lib = nil},
  { x = 1128.8416748046, y = 266.77731323242, z = -51.035778045654, h = 297.9507446289, model = GetHashKey("a_f_y_business_03"), anim = "WORLD_HUMAN_WINDOW_SHOP_BROWSE", lib = nil},
  { x = 1129.6135253906, y = 267.21600341796, z = -51.035778045654, h = 122.01964569092, model = GetHashKey("a_f_y_business_02"), anim = "WORLD_HUMAN_HANG_OUT_STREET", lib = nil},
  { x = 1116.9844970704, y = 264.94412231446, z = -51.040664672852, h = 269.04556274414, model = GetHashKey("S_M_Y_Casino_01"), anim = nil, lib = nil},
  { x = 1111.6571044922, y = 241.01651000976, z = -45.840980529786, h = 178.75732421875, model = GetHashKey("S_M_Y_Casino_01"), anim = nil, lib = nil},
  { x = 1109.2875976562, y = 240.99969482422, z = -45.840980529786, h = 184.82081604004, model = GetHashKey("S_F_Y_Casino_01"), anim = nil, lib = nil},
  { x = 2747.26, y = 3472.99, z = 55.67, h = 247.23, model = GetHashKey("s_m_m_lathandy_01"), anim = "WORLD_HUMAN_CLIPBOARD", lib = nil},---UTOOL STORE PED
  { x = 46.76, y = -1749.68, z = 29.63, h = 52.36, model = GetHashKey("s_m_m_lathandy_01"), anim = "WORLD_HUMAN_CLIPBOARD", lib = nil},--- Mega Mall STORE PED
  { x = -1820.32, y = -1220.2, z = 13.02, h = 38.02, model = GetHashKey("s_m_m_lathandy_01"), anim = "WORLD_HUMAN_CLIPBOARD", lib = nil},---Master Baiters STORE PED
}

Citizen.CreateThread(function()
  for _,v in pairs(coords) do
      if IsModelInCdimage(v.model) then
          RequestModel(v.model)
          while not HasModelLoaded(v.model) do
              Wait(5)
          end
          RequestAnimDict("mini@strip_club@idles@bouncer@base")
          while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
              Wait(5)
          end
          ped =  CreatePed(4, v.model,v.x,v.y,v.z-1, 3374176, false, true)
          SetEntityHeading(ped, v.h)
          FreezeEntityPosition(ped, true)
          SetEntityInvincible(ped, true)
          SetBlockingOfNonTemporaryEvents(ped, true)
          if v.anim == nil then
              TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
          else
              if v.lib == nil then
                  -- scenario
                  TaskStartScenarioInPlace(ped, v.anim, 0, true)
              else
                  -- anim
                  RequestAnimDict(v.lib)
                  while not HasAnimDictLoaded(v.lib) do
                      RequestAnimDict(v.lib)
                      Citizen.Wait(10)
                  end
                  TaskPlayAnim(ped, v.lib, v.anim, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
              end
          end
      end
  end
end)
