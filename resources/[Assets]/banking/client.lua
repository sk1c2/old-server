-- Settings
local depositAtATM = false -- Allows the player to deposit at an ATM rather than only in banks (Default: false)
local giveCashAnywhere = false -- Allows the player to give CASH to another player, no matter how far away they are. (Default: false)
local withdrawAnywhere = false -- Allows the player to withdraw cash from bank account anywhere (Default: false)
local depositAnywhere = false -- Allows the player to deposit cash into bank account anywhere (Default: false)
local displayBankBlips = true -- Toggles Bank Blips on the map (Default: true)
local displayAtmBlips = false -- Toggles ATM blips on the map (Default: false) // THIS IS UGLY. SOME ICONS OVERLAP BECAUSE SOME PLACES HAVE MULTIPLE ATM MACHINES. NOT RECOMMENDED
local enableBankingGui = true -- Enables the banking GUI (Default: true) // MAY HAVE SOME ISSUES

inBank = false

RegisterNetEvent('wrp-base:loadPlayerData')
AddEventHandler('wrp-base:loadPlayerData', function()
  local cid = exports['isPed']:isPed('cid')
  TriggerEvent('Evidence:ClearDamageStates')
  exports['pma-voice']:removePlayerFromRadio()
  exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
  TriggerEvent('wrp-obtainAmountP')
  TriggerEvent('Igotitbaby')
  TriggerEvent('urp:base:loadplayer')
  TriggerEvent('reviveFunction')
  TriggerEvent('wrp-hospital:client:RemoveBleed')
  TriggerServerEvent("wrp-scoreboard:AddPlayer")
  TriggerServerEvent('wrp-admin:AddPlayer')
  TriggerServerEvent('Server:GetHandle')
  TriggerServerEvent('getYP')
  TriggerEvent('wrp-bennys:craft:active')
  TriggerEvent('wrp-base:playerSpawned')
  TriggerEvent('wrp-hospital:client:RemoveBleed')
  TriggerEvent('urp:base:loadplayer')
end)




-- ATMS
local atms = {
  [1] = -1126237515,
  [2] = 506770882,
  [3] = -870868698,
  [4] = 150237004,
  [5] = -239124254,
  [6] = -1364697528,  
}


v_5_b_atm1=150237004 
v_5_b_atm2=-239124254 

prop_atm_03=-1364697528 

RegisterNetEvent('bank:OpenATM')
AddEventHandler('bank:OpenATM', function()
  atmOpen = true
  openGui()
  bankOpen = true
end)

RegisterNetEvent('bank:openGUI')
AddEventHandler('bank:openGUI', function()
  openGui()
end)


RegisterNetEvent('bank:getbanknumber')
AddEventHandler('bank:getbanknumber', function(n)
  SendNUIMessage({updatebanknumber = true , bank = n})
end)

RegisterNetEvent('bank:checkATM')
AddEventHandler('bank:checkATM', function()
  if IsNearATM() then
    atmOpen = true
    openGui(true)
    SendNUIMessage({atm = true})
    bankOpen = true
  else
    TriggerEvent("DoLongHudText","No ATM.",2)
  end
end)

function IsNearATM()
  for i = 1, #atms do
    local objFound = GetClosestObjectOfType( GetEntityCoords(PlayerPedId()), 0.75, atms[i], 0, 0, 0)

    if DoesEntityExist(objFound) then
      TaskTurnPedToFaceEntity(PlayerPedId(), objFound, 3.0)
      return true
    end
  end
  if exports['wrp-inventory']:hasEnoughOfItem('portableatm', 1, false) then
    return true
  end

  return false
end
-- Banks
local banks = {
  {name="Bank", id=108, x=150.266, y=-1040.203, z=29.374},
  {name="Bank", id=108, x=-1212.980, y=-330.841, z=37.787},
  {name="Bank", id=108, x=-2962.582, y=482.627, z=15.703},

  {name="Bank", id=108, x=314.187, y=-278.621, z=54.170},
  {name="Bank", id=108, x=-351.534, y=-49.529, z=49.042},
  {name="Bank", id=108, x=241.727, y=220.706, z=106.286},
  {name="Bank", id=108, x=1176.0833740234, y=2706.3386230469, z=38.157722473145},

}


local ClosedBanks = {}



RegisterNetEvent("bank:addlogstoclient")
AddEventHandler("bank:addlogstoclient" ,function(log)
  SendNUIMessage({
    updatelogs = 'yes' ,
    logs = log
  })
end)

RegisterNetEvent('robbery:shutdownBank')
AddEventHandler('robbery:shutdownBank', function(bankid,status)
  if status then
    ClosedBanks[bankid] = true
  else
    ClosedBanks[bankid] = nil
  end
end)

-- Display Map Blips
Citizen.CreateThread(function()
  if (displayBankBlips == true) then
    for _, item in pairs(banks) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipScale(item.blip, 0.75)
      SetBlipColour(item.blip, 2)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
      TriggerEvent('chat:addSuggestion', '/givecash', "/givecash [id] [amount]")
    end
  end
end)

local jobs = {["Police"] = 6 ,["EMS"] = 4 , ["PDM"] = 4 , ["RealEstate"] = 4 , ["Mechanic"] = 4 , ["DriftSchool"] = 3 ,  ["tuner_carshop"] = 3 ,  ["HarmonyRepairs"] = 4 , ["DOJ"] = 3, ["Gallery"] = 2, ["VanillaUnicorn"] = 3, ['DiamondCasino'] = 4}
-- Open Gui and Focus NUI
function openGui(a)

  for k,v in pairs(jobs) do
    local rank = exports["isPed"]:GroupRank(k)
    if(rank ~= nil) then
      if rank >= v then
        local job = exports['isPed']:isPed('job')
        SendNUIMessage({bussiness = true , jobname = job})
        TriggerServerEvent("bank:getbussinesscash" , job)
      end
    end
  end
  local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
  local Player = LocalPlayer:getCurrentCharacter()
  TriggerServerEvent("bank:getDetails")
  bankanimation()
  inBank = true
  Citizen.Wait(1400)
  TriggerServerEvent('bank:getlogs', exports['isPed']:isPed('cid'))
  SetNuiFocus(true, true)
  local cid = exports["isPed"]:isPed("cid")
  if(a == nil) then
    a = false
  end
  local d = GetEntityCoords(PlayerPedId())
  local s = GetStreetNameAtCoord(d.x , d.y , d.z)
  local a = GetStreetNameFromHashKey(s)
  SendNUIMessage({openBank = true , cash = Player.cash , atm = a , street = a})
  TriggerEvent('banking:updateCash', exports['wrp-base']:getModule("LocalPlayer"):getCurrentCharacter().cash, true)
  TriggerEvent('banking:updateBalance')
  TriggerEvent("banking:viewCash")
  TriggerServerEvent("bank:active")
  TriggerServerEvent("bank:cashbal")
end

-- Close Gui and disable NUI
function closeGui()
  SetNuiFocus(false, false)
  SendNUIMessage({openBank = false})
  bankOpen = false
  atmOpen = false
  bankanimation()
  Citizen.Wait(1400)
  inBank = false
end


atmuse = false
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 
function bankanimation()
    local player = GetPlayerPed( -1 )
    if IsNearATM() then
      if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 

            loadAnimDict( "amb@prop_human_atm@male@enter" )
            loadAnimDict( "amb@prop_human_atm@male@exit" )
            loadAnimDict( "amb@prop_human_atm@male@idle_a" )

          if ( atmuse ) then 
              ClearPedTasks(PlayerPedId())
              TaskPlayAnim( player, "amb@prop_human_atm@male@exit", "exit", 1.0, 1.0, -1, 49, 0, 0, 0, 0 )
              atmuse = false
              local finished = exports["wrp-taskbar"]:taskBar(3000,"Retrieving Card")
              ClearPedTasks(PlayerPedId())
          else
              atmuse = true
              TaskPlayAnim( player, "amb@prop_human_atm@male@idle_a", "idle_b", 1.0, 1.0, -1, 49, 0, 0, 0, 0 )
          end
      end
    else
        if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 

            loadAnimDict( "mp_common" )

            if ( atmuse ) then 
                ClearPedTasks(PlayerPedId())
                TaskPlayAnim( player, "mp_common", "givetake1_a", 1.0, 1.0, -1, 49, 0, 0, 0, 0 )
                atmuse = false
                local finished = exports["wrp-taskbar"]:taskBar(1000,"Retrieving Card")
                ClearPedTasks(PlayerPedId())
            else
                atmuse = true
                TaskPlayAnim( player, "mp_common", "givetake1_a", 1.0, 1.0, -1, 49, 0, 0, 0, 0 )
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
            end
        end
    end
end


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

Controlkey = {["generalUse"] = {38,"E"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
  Controlkey["generalUse"] = table["generalUse"]
end)


-- If GUI setting turned on, listen for INPUT_PICKUP keypress
local lastTrigger = 0
if enableBankingGui then
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(1)

      local ply = PlayerPedId()
      local plyCoords = GetEntityCoords(ply, 0)
      local closestbank = 1000.0
      local scanid = 0

      if not (IsInVehicle()) and not bankOpen then
        for i = 1, #banks do
          local distance = #(vector3(banks[i].x, banks[i].y, banks[i].z) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
          if(distance < closestbank) then
            scanid = i
            closestbank = distance
          end
        end
      end



      if(closestbank < 5.5 and scanid ~= 0) then

          if lastTrigger == 0 then
            lastTrigger = scanid
            TriggerEvent("robbery:scanbank",scanid)
          end

          local cdst = closestbank
          -- if cdst > 1.5 and cdst < 30 then
          --   exports['wrp-interaction']:hideInteraction()
          -- end
          while cdst < 1.5 do
            Citizen.Wait(1)

            local plyCoords = GetEntityCoords(ply, 0)
            cdst = #(vector3(banks[scanid].x, banks[scanid].y, banks[scanid].z) -  vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
            
            
              if ClosedBanks[scanid] then
                DrawText3D(banks[scanid].x, banks[scanid].y, banks[scanid].z,"This bank is closed.")
              else
                if inBank == false then
                  DrawText3D(banks[scanid].x, banks[scanid].y, banks[scanid].z,"["..Controlkey["generalUse"][2].."] to use Bank.")
                  -- exports['wrp-interaction']:showInteraction('[E] to use Bank.')
                -- if not IsInVehicle() then exports["np-base"]:getModule("Util"):MissionText("Press '~b~Context Action Key~w~' (Default: ~b~E~w~) to view your account", 500) else exports["np-base"]:getModule("Util"):MissionText("You ~r~cannot~w~~w~ use the bank in a vehicle", 500) end
                  atBank = true
                  if IsControlJustPressed(1, Controlkey["generalUse"][1])  then -- IF INPUT_PICKUP Is pressed
                      openGui()
                      -- exports['wrp-interaction']:hideInteraction()
                      bankOpen = true
                  end
                  if bankOpen then
                    Citizen.Wait(1000)
                  end
                end
              end

            end
        else

          
          if atBank then
            atBank = false
          end
          if lastTrigger ~= 0 and closestbank > 25.0 then
            TriggerEvent("robbery:disablescans")
            lastTrigger = 0
          end
          Citizen.Wait(math.ceil(closestbank*5))
        end
      end
    end)
  end


-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNUICallback('balance', function(data, cb)
  SendNUIMessage({openSection = "balance"})
  cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
  SendNUIMessage({openSection = "withdraw"})
  cb('ok')
end)

RegisterNUICallback('deposit', function(data, cb)
  SendNUIMessage({openSection = "deposit"})
  cb('ok')
end)

RegisterNUICallback('transfer', function(data, cb)
  SendNUIMessage({openSection = "transfer"})
  cb('ok')
end)

RegisterNUICallback('quickCash', function(data, cb)
  TriggerEvent('bank:withdraw', data)
  cb('ok')
end)

RegisterNetEvent("banmk;dsl:check")
AddEventHandler("banmk;dsl:check" , function(amt)
  local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
  local Player = LocalPlayer:getCurrentCharacter()
  LocalPlayer:addBank(Player.id, amt)
  TriggerEvent("banking:updateCash", Player.cash + amt)

end)

RegisterNUICallback('depositBussinessSubmit', function(data, cb)

  if tonumber(data.amount) < 0 then
    TriggerEvent('DoLongHudText', 'You cannot afford this!', 2)
  else
    local cid = exports["isPed"]:isPed("cid")
    local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    if  Player.bank <  tonumber(data.amount) then return end
    local job = exports['isPed']:isPed('job')

    TriggerServerEvent('bank:depositbussiness', job,data, exports['isPed']:isPed('cid'))
    TriggerEvent("banking:updateBalance",Player.bank + data.amount)
    TriggerEvent("banking:updateCash", Player.cash - data.amount)
    LocalPlayer:removeBank(Player.id, data.amount)
    Citizen.Wait(400)
    TriggerServerEvent("bank:getbussinesscash" , job)
  end
end)

RegisterNUICallback('withdrawSubmit', function(data, cb)
  if tonumber(data.amount) < 0 then
    TriggerEvent('DoLongHudText', 'You cannot afford this!', 2)
  else
    local cid = exports["isPed"]:isPed("cid")
    if(data.reason == '') then
      data.reason = "Non reason specificed"
    end
    TriggerEvent("bank:withdraw" , data)
    TriggerEvent("banking:updateBalance",data.amount)
  end
end)



RegisterNUICallback('withdrawBussinessSubmit', function(data, cb)
  if tonumber(data.amount) < 0 then
    TriggerEvent('DoLongHudText', 'You cannot afford this!', 2)
  else
    local cid = exports["isPed"]:isPed("cid")
    if(data.reason == '') then
      data.reason = "Non reason specificed"
    end


    local job = exports['isPed']:isPed('job')
    TriggerServerEvent('bank:withdrawfromsociety',job,data, exports['isPed']:isPed('cid'))

    Citizen.Wait(200)
    TriggerServerEvent("bank:getbussinesscash" , job)
    
  end
end)

RegisterNetEvent("withdraw:sks:ss" , function(am)
  local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
  local Player = LocalPlayer:getCurrentCharacter()
  local job = exports['isPed']:isPed('job')
  for k,v in ipairs(jobs) do
    if(v ~= job) then
      return
    end
  end
  LocalPlayer:addBank(Player.id, am)
end)


RegisterNUICallback('depositSubmit', function(data, cb)
  if tonumber(data.amount) < 0 then
    TriggerEvent('DoLongHudText', 'You cannot afford this!', 2)
  else
    local cid = exports["isPed"]:isPed("cid")
    if(data.reason == '') then
      data.reason = "Non reason specificed"
    end
    TriggerEvent('bank:deposit', data)
    cb('ok')
  end
end)

RegisterNUICallback('transferSubmit', function(data, cb)
  local fromPlayer = GetPlayerServerId();
  if tonumber(data.amount) < 0 then
    TriggerEvent('DoLongHudText', 'You cannot afford this!', 2)
  else
    local cid = exports["isPed"]:isPed("cid")

    TriggerServerEvent("bank:addlog" , cid,data.amount , data.reason , false)
    TriggerEvent('bank:transfer',tonumber(fromPlayer), tonumber(data.toPlayer), tonumber(data.amount))
    cb('ok')
  end
end)

-- Check if player is near an atm


-- Check if player is in a vehicle
function IsInVehicle()
  local ply = PlayerPedId()
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

-- Check if player is near a bank
function IsNearBank()
  local ply = PlayerPedId()
  local plyCoords = GetEntityCoords(ply, 0)
  for _, item in pairs(banks) do
    local distance = #(vector3(item.x, item.y, item.z) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
    if(distance <= 2) then
      return true
    end
  end
end

-- Check if player is near another player
function IsNearPlayer(player)
  local ply = PlayerPedId()
  local plyCoords = GetEntityCoords(ply, 0)
  local ply2 = GetPlayerPed(GetPlayerFromServerId(player))
  local ply2Coords = GetEntityCoords(ply2, 0)
  local distance = Vdist2(plyCoords, ply2Coords)
  if(distance <= 5) then
    return true
  end
end

-- Remove from cash, add to bank
RegisterNetEvent('bank:deposit')
AddEventHandler('bank:deposit', function(data)
    if (IsInVehicle()) then
      exports["wrp-base"]:getModule("Util"):MissionText("You ~r~cannot~w~ use the ATM in a vehicle", 500)
    else
      local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
      local Player = LocalPlayer:getCurrentCharacter()

      wAmount = tonumber(data.amount)

      -- print(wAmount)
      if Player.cash < wAmount then return end


      LocalPlayer:addBank(Player.id, wAmount)
      TriggerServerEvent("bank:addlog" , exports['isPed']:isPed('cid'),data.amount , data.reason , true)
      TriggerEvent("banking:updateBalance", Player.bank + wAmount)
      
      LocalPlayer:removeCash(Player.id, wAmount)
      TriggerEvent("banking:updateCash", Player.cash - wAmount)
    end
  
end)

-- Process withdraw if conditions met
RegisterNetEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(data)
  if(IsNearATM() == true or IsNearBank() == true) then
    if (IsInVehicle()) then
      exports["wrp-base"]:getModule("Util"):MissionText("You ~r~cannot~w~ use the bank in a vehicle", 500)
    else

      local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
      local Player = LocalPlayer:getCurrentCharacter()

      wAmount = tonumber(data.amount)

      -- print(wAmount)


      if Player.bank < wAmount then return end
      TriggerServerEvent("bank:addlog" , exports['isPed']:isPed('cid'),data.amount , data.reason , false)
        LocalPlayer:removeBank(Player.id, wAmount)
        TriggerEvent("banking:updateBalance", Player.bank - wAmount)
        
        LocalPlayer:addCash(Player.id, wAmount)
        TriggerEvent("banking:updateCash", Player.cash + wAmount)
    end
  end
end)



-- Process give dm if conditions met
RegisterNetEvent('dirtyMoney:givedm')
AddEventHandler('dirtyMoney:givedm', function(toPlayer, amount)
  if not IsNearPlayer(toPlayer) then TriggerEvent('chatMessage', "", {255, 0, 0}, "^1You are not near this player!") return end

  local target = GetPlayerFromServerId(tonumber(toPlayer))
  local targetPos = GetEntityCoords(GetPlayerPed(target))

  local userCoords = GetEntityCoords(PlayerPedId())

  if Vdist2(targetPos, userCoords) > 15.0 then
      TriggerEvent('chatMessage', "", {255, 0, 0}, "^1You are not near this player!")
      return
  end

  local player2 = GetPlayerFromServerId(tonumber(toPlayer))
  local playing = IsPlayerPlaying(player2)
  
  if (playing ~= false) then
    TriggerServerEvent("dirtyMoney:givedm", toPlayer, tonumber(amount))
  else
    TriggerEvent('chatMessage', "", {255, 0, 0}, "^1This player is not online!");
  end
end)

-- Process give cash if conditions met
RegisterNetEvent('bank:givecash')
AddEventHandler('bank:givecash', function(toPlayer, amount, source)
  if not IsNearPlayer(toPlayer) then 
    TriggerEvent("DoLongHudText", "You are not near this player", 2)
    return 
  end

  local target = GetPlayerFromServerId(tonumber(toPlayer))
  local targetPos = GetEntityCoords(GetPlayerPed(target))

  local userCoords = GetEntityCoords(PlayerPedId())

  if Vdist2(targetPos, userCoords) > 15.0 then
    TriggerEvent("DoLongHudText", "You are not near this player", 2)
      return
  end


  local player2 = GetPlayerFromServerId(tonumber(toPlayer))
  local playing = IsPlayerPlaying(player2)
  
  if (playing ~= false) then
    TriggerServerEvent('wrp-banking:pass', toPlayer, amount, exports['isPed']:isPed('cid'))
    TriggerEvent("animation:PlayAnimation","id")
  else
    TriggerEvent("DoLongHudText", "This player is not online", 2)
  end
end)

-- Process bank transfer if player is online
RegisterNetEvent('bank:transfer')
AddEventHandler('bank:transfer', function(fromPlayer, toPlayer, amount)
  local isActive = GetActivePlayers(toPlayer)
  local player2 = GetPlayerFromServerId(tonumber(toPlayer))
  local playing = IsPlayerPlaying(player2)

  if (isActive ~= false) then
    TriggerServerEvent("bank:transfer", toPlayer, tonumber(amount))
  else
    TriggerEvent('chatMessage', "", {255, 0, 0}, "^1This player is not online!");
  end
end)

-- Send NUI message to update bank balance
RegisterNetEvent('banking:updateBalance')
AddEventHandler('banking:updateBalance', function(balance, show)
  local id = PlayerId()
  local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer"):getCurrentCharacter()
  local name = LocalPlayer.first_name .. " " .. LocalPlayer.last_name;
  if (name == false) then
    name = GetPlayerName(id)
  end
  
	SendNUIMessage({
		updateBalance = true,
		balance = LocalPlayer.bank,
    name = name,
    show = show
	})
end)

RegisterNetEvent('banking:updateCash')
AddEventHandler('banking:updateCash', function(balance, show)
  local id = PlayerId()
	SendNUIMessage({
		updateCash = true,
		cash = balance,
    show = show
	})
  
end)

RegisterNetEvent("banking:viewBalance")
AddEventHandler("banking:viewBalance", function()
  SendNUIMessage({
    viewBalance = true
  })
end)

-- Send NUI Message to display add balance popup
RegisterNetEvent("banking:addBalance")
AddEventHandler("banking:addBalance", function(amount)
	SendNUIMessage({
		addBalance = true,
		amount = amount
	})
end)

RegisterNetEvent("banking:removeBalance")
AddEventHandler("banking:removeBalance", function(amount)
	SendNUIMessage({
		removeBalance = true,
		amount = amount
	})
end)

RegisterNetEvent("banking:addCash")
AddEventHandler("banking:addCash", function(amount)
	SendNUIMessage({
		addCash = true,
		amount = amount
	})
end)

-- Send NUI Message to display remove balance popup
RegisterNetEvent("banking:removeCash")
AddEventHandler("banking:removeCash", function(amount)
	SendNUIMessage({
		removeCash = true,
		amount = amount
	})
end)

RegisterNetEvent("wrp-base:addedMoney")
AddEventHandler("wrp-base:addedMoney", function(amt, total)
    TriggerEvent("banking:updateCash", total)
    TriggerEvent("banking:addCash", amt)
end)

RegisterNetEvent("wrp-base:removedMoney")
AddEventHandler("wrp-base:removedMoney", function(amt, total)
    TriggerEvent("banking:updateCash", total)
    TriggerEvent("banking:removeCash", amt)
end)


RegisterNetEvent("banking:viewCash")
AddEventHandler("banking:viewCash", function()
  SendNUIMessage({
		viewCash = true
	})
end)

-- RegisterCommand('bank', function(source, args)
--   TriggerEvent('banking:updateBalance')
-- end)

RegisterCommand('cash', function(source, args)
  TriggerEvent('banking:updateCash', exports['wrp-base']:getModule("LocalPlayer"):getCurrentCharacter().cash, true)
  TriggerEvent('banking:viewCash')
end)

RegisterCommand("atm", function(src, args, raw)
  TriggerEvent('bank:checkATM')
end)

function SetCustomNuiFocus(hasKeyboard, hasMouse)
  HasNuiFocus = hasKeyboard or hasMouse

  SetNuiFocus(hasKeyboard, hasMouse)
  SetNuiFocusKeepInput(HasNuiFocus)

  TriggerEvent("pma-voice:focus:set", HasNuiFocus, hasKeyboard, hasMouse)
end

RegisterNetEvent("bank:returnbussinesscash")
AddEventHandler("bank:returnbussinesscash" , function(cash)
  SendNUIMessage({getBussinessCashBal = true , cash = cash})
end)
