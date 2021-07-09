userValues = {
  dead = false, -- Done
  handcuffed = false, -- Done
  handcuffedwalking = false, -- Done
  job = "police", -- Done
  firstname = "None", -- Done
  lastname = "None", -- Done
  bank = 0, -- Done
  curPolice = 0,
  rank = 0,
  cash = 0, -- Done
  gang = 0, -- Done
  cid = 34, -- Done
  weaponlicense = 0, -- Done
  licenses = {}, -- Done
  housekeys = {}, -- Unfinished (Think Of Way To Manage)
  carkeys = {}, -- Unfinished (Think Of Way To Manage)
}

local pedsused = {}


--[[

  carkeys = {'XDF34FD', 'DFFE"£$D'} - Plates
  l, 1, 6icenses = {'drive', 'drive_truck', 'drive_bike'} - License Identifiers
  housekeys = {23, 34} -- House Identifiers

]]

function GlobalObject(object)
  --  NetworkRegisterEntityAsNetworked(object)
 --   local netid = ObjToNet(object)
  --  SetNetworkIdExistsOnAllMachines(netid, true)
  --  NetworkSetNetworkIdDynamic(netid, true)
  --  SetNetworkIdCanMigrate(netid, false) 
  --  for i = 1, 32 do
  --    SetNetworkIdSyncToPlayer(netid, i, true)
  --  end
end

function IsPedNearCoords(x,y,z)
  local handle, ped = FindFirstPed()
  local pedfound = false
  local success
  repeat
      local pos = GetEntityCoords(ped)
      local distance = #(vector3(x,y,z) - pos)

      if distance < 5.0 then
        pedfound = true
      end
      success, ped = FindNextPed(handle)
  until not success
  EndFindPed(handle)
  if pedfound then
  else
    -- print("Nah mate")
  end
  return pedfound
end

function isPed(checkType)
  local check = string.lower(checkType)

  for index, value in pairs(userValues) do
    if index == checkType then
      return value
    end
  end
end

function GroupRank(job)
  local ranks = exports['prp-base']:GetRanks()
  local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
  local Player = LocalPlayer:getCurrentCharacter()
  for k, v in pairs(ranks) do
    if v.name == job then
      if Player.job == job then
        return tonumber(Player.rank)
      else
        return 0
      end
    end
  end
end

function GetClosestNPC()
  local playerped = PlayerPedId()
  local playerCoords = GetEntityCoords(playerped)
  local handle, ped = FindFirstPed()
  local success
  local rped = nil
  local distanceFrom
  repeat
      local pos = GetEntityCoords(ped)
      local distance = #(playerCoords - pos)
      if canPedBeUsed(ped) and distance < 5.0 and (distanceFrom == nil or distance < distanceFrom) then
          distanceFrom = distance
          rped = ped
          pedsused["conf"..rped] = true
      end
      success, ped = FindNextPed(handle)
  until not success
  EndFindPed(handle)
  return rped
end

function canPedBeUsed(ped)
  if ped == nil then
      return false
  end
  if pedsused["conf"..ped] then
    return false
  end
  if ped == PlayerPedId() then
      return false
  end

  if not DoesEntityExist(ped) then
      return false
  end

  if IsPedAPlayer(ped) then
      return false
  end

  if IsPedFatallyInjured(ped) then
      return false
  end

  if IsPedFleeing(ped) or IsPedRunning(ped) or IsPedSprinting(ped) then
      return false
  end

  if IsPedInCover(ped) or IsPedGoingIntoCover(ped) or IsPedGettingUp(ped) then
      return false
  end

  if IsPedInMeleeCombat(ped) then
      return false
  end

  if IsPedShooting(ped) then
      return false
  end

  if IsPedDucking(ped) then
      return false
  end

  if IsPedBeingJacked(ped) then
      return false
  end

  if IsPedSwimming(ped) then
      return false
  end

  if IsPedSittingInAnyVehicle(ped) or IsPedGettingIntoAVehicle(ped) or IsPedJumpingOutOfVehicle(ped) or IsPedBeingJacked(ped) then
      return false
  end

  if IsPedOnAnyBike(ped) or IsPedInAnyBoat(ped) or IsPedInFlyingVehicle(ped) then
      return false
  end

  local pedType = GetPedType(ped)
  if pedType == 6 or pedType == 27 or pedType == 29 or pedType == 28 then
      return false
  end

  return true
end

-- Status Management (Set | Dead + Hardcuffed + Softcuffed)
RegisterNetEvent('isPed:setAllData')
AddEventHandler('isPed:setAllData', function(cid, job, firstname, lastname, cash, bank)
  userValues.cid = cid
  userValues.job = job
  userValues.firstname = firstname
  userValues.lastname = lastname
  userValues.cash = math.ceil(cash)
  userValues.bank = math.ceil(bank)
end)


RegisterNetEvent('isPed:updateDead')
AddEventHandler('isPed:updateDead', function(dead)
	userValues.dead = dead
end)

RegisterNetEvent('isPed:updateHandcuffed')
AddEventHandler('isPed:updateHandcuffed', function(handcuffed, handcuffedwalking)
  userValues.handcuffed = handcuffed
  userValues.handcuffedwalking = handcuffedwalking
end)

RegisterNetEvent('isPed:updateRank')
AddEventHandler('isPed:updateRank', function(rank)
  userValues.rank = rank
end)

RegisterNetEvent('isPed:updateJob')
AddEventHandler('isPed:updateJob', function(job)
  userValues.job = job
end)

-- Identity Management (Set | Name + CID + Current Gang)

RegisterNetEvent('isPed:updateName')
AddEventHandler('isPed:updateName', function(firstname, lastname)
  userValues.firstname = firstname
  userValues.lastname = lastname
end)

RegisterNetEvent('isPed:updateCid')
AddEventHandler('isPed:updateCid', function(cid)
  userValues.cid = cid
end)

RegisterNetEvent('isPed:updateGang')
AddEventHandler('isPed:updateGang', function(gang)
	userValues.gang = gang
end)
-- Financial Management (Add/Remove/Set | Cash + Bank)
RegisterNetEvent('isPed:setBank')
AddEventHandler('isPed:setBank', function(bank)
	userValues.bank = math.ceil(bank)
end)

RegisterNetEvent('isPed:addBank')
AddEventHandler('isPed:addBank', function(bank)
	userValues.bank = userValues.bank + math.ceil(bank)
end)

RegisterNetEvent('isPed:removeBank')
AddEventHandler('isPed:removeBank', function(bank)
	userValues.bank = userValues.bank - math.ceil(bank)
end)

RegisterNetEvent('isPed:setCash')
AddEventHandler('isPed:setCash', function(cash)
	userValues.cash = math.ceil(cash)
end)

RegisterNetEvent('isPed:addCash')
AddEventHandler('isPed:addCash', function(cash)
	userValues.cash = userValues.cash + math.ceil(cash)
end)

RegisterNetEvent('isPed:removeCash')
AddEventHandler('isPed:removeCash', function(cash)
	userValues.cash = userValues.cash - math.ceil(cash)
end)

-- License Management (Set | General Licenses + Weapon License)

RegisterNetEvent('isPed:updateLicenses')
AddEventHandler('isPed:updateLicenses', function(licenses)
	userValues.licenses = licenses
end)

RegisterNetEvent('isPed:updateWLicense')
AddEventHandler('isPed:updateWLicense', function(wLicenses)
	userValues.weaponlicense = wLicenses
end)

RegisterNetEvent("job:policecount")
AddEventHandler("job:policecount", function(activePolice)
  userValues.curPolice = activePolice
end)

AddEventHandler('onClientGameTypeStart', function()
  TriggerServerEvent('prp-police:obtain-count')
end)