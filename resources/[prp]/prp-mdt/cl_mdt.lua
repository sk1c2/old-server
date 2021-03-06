local isVisible = false
local tabletObject = nil
local callBip = nil
local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }


TriggerServerEvent("prp-mdt:getOffensesAndOfficer")

RegisterNetEvent("prp-mdt:toggleVisibilty")
AddEventHandler("prp-mdt:toggleVisibilty", function(reports, warrants, officer, job)
    local playerPed = PlayerPedId()
    if not isVisible then
        local dict = "amb@world_human_seat_wall_tablet@female@base"
        RequestAnimDict(dict)
        if tabletObject == nil then
            tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
            AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        end
        while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
        if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
            TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
        end
    else
        DeleteEntity(tabletObject)
        ClearPedTasks(playerPed)
        tabletObject = nil
    end
    if #warrants == 0 then warrants = false end
    if #reports == 0 then reports = false end
    SendNUIMessage({
        type = "recentReportsAndWarrantsLoaded",
        reports = reports,
        warrants = warrants,
        officer = officer,
        department = job
    })
    ToggleGUI()
    TriggerServerEvent("prp-mdt:getOffensesAndOfficer")
end)

RegisterNetEvent("prp-mdt:hotKeyOpen")
AddEventHandler("prp-mdt:hotKeyOpen", function()
    TriggerServerEvent('prp-mdt:Open', exports['isPed']:isPed('cid'))
end)

RegisterNUICallback("close", function(data, cb)
    local playerPed = PlayerPedId()
    DeleteEntity(tabletObject)
    ClearPedTasks(playerPed)
    tabletObject = nil
    ToggleGUI(false)
    cb('ok')
end)

RegisterNUICallback("checklogin", function(data, cb)
    local cid = exports["isPed"]:isPed("cid")
    TriggerServerEvent("prp-mdt:checkloginsql" , data.username , data.password , cid)
end)


RegisterNUICallback("updatepass", function(data, cb)
    local cid = exports["isPed"]:isPed("cid")
    TriggerServerEvent("prp-mdt:updatepass" , data.password , cid)
    print(data.password)
end)


RegisterNetEvent("prp-mdt:openmdt")
AddEventHandler("prp-mdt:openmdt" , function()
    SendNUIMessage({
        type = "loginin"
    })
end)

RegisterNetEvent("prp-mdt:movepagetologin")
AddEventHandler("prp-mdt:movepagetologin" , function()
    SendNUIMessage({
        type = "loginin"
    })
end)


RegisterNUICallback("register", function(data, cb)
    local cid = exports["isPed"]:isPed("cid")

    TriggerServerEvent("prp-mdt:register", data.username , data.password , cid)
    print('d')
end)
RegisterNUICallback("performOffenderSearch", function(data, cb)
    TriggerServerEvent("prp-mdt:performOffenderSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("viewOffender", function(data, cb)
    
    TriggerServerEvent("prp-mdt:getOffenderDetails", data.offender)
    cb('ok')
end)

RegisterNUICallback("saveOffenderChanges", function(data, cb)
    TriggerServerEvent("prp-mdt:saveOffenderChanges", data.id, data.changes, data.identifier)
    cb('ok')
end)

RegisterNUICallback("submitNewReport", function(data, cb)
    TriggerServerEvent("prp-mdt:submitNewReport", data)
    cb('ok')
end)

RegisterNUICallback("performReportSearch", function(data, cb)
    TriggerServerEvent("prp-mdt:performReportSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("getOffender", function(data, cb)
    TriggerServerEvent("prp-mdt:getOffenderDetailsById", data.char_id)
    print(data.char_id)
    cb('ok')
end)

RegisterNUICallback("deleteReport", function(data, cb)
    TriggerServerEvent("prp-mdt:deleteReport", data.id)
    cb('ok')
end)

RegisterNUICallback("evFile", function(data, cb)
    TriggerServerEvent("vrpLockers:sendCaseFileID", data.id)
    cb('ok')
end)

RegisterNUICallback("saveReportChanges", function(data, cb)
    TriggerServerEvent("prp-mdt:saveReportChanges", data)
    cb('ok')
end)

RegisterNUICallback("vehicleSearch", function(data, cb)
    TriggerServerEvent("prp-mdt:performVehicleSearch", data.plate)
    cb('ok')
end)

RegisterNUICallback("getVehicle", function(data, cb)
    TriggerServerEvent("prp-mdt:getVehicle", data.vehicle)
    cb('ok')
end)

RegisterNUICallback("getWarrants", function(data, cb)
    TriggerServerEvent("prp-mdt:getWarrants")
end)

RegisterNUICallback("submitNewWarrant", function(data, cb)
    TriggerServerEvent("prp-mdt:submitNewWarrant", data)
    cb('ok')
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    TriggerServerEvent("prp-mdt:deleteWarrant", data.id)
    cb('ok')
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    TriggerServerEvent("prp-mdt:deleteWarrant", data.id)
    cb('ok')
end)

RegisterNUICallback("getReport", function(data, cb)
    TriggerServerEvent("prp-mdt:getReportDetailsById", data.id)
    cb('ok')
end)

RegisterNUICallback("getCalls", function(data, cb)
    TriggerServerEvent("prp-mdt:getCalls")
end)

RegisterNUICallback("attachToCall", function(data, cb)
    TriggerServerEvent("prp-mdt:attachToCall", data.index)
    if not callBlip then
        callBlip = AddBlipForCoord(data.coords[1], data.coords[2], data.coords[3])
        SetBlipSprite(callBlip, 304)
        SetBlipDisplay(callBlip, 2)
        SetBlipScale(callBlip, 1.2)
        SetBlipColour(callBlip, 29)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("911 Call")
        EndTextCommandSetBlipName(callBlip)
    end
    cb('ok')
end)

RegisterNUICallback("detachFromCall", function(data, cb)
    TriggerServerEvent("prp-mdt:detachFromCall", data.index)
    if callBlip then
        RemoveBlip(callBlip)
        callBlip = nil
    end
    cb('ok')
end)

RegisterNUICallback("setCallWaypoint", function(data, cb)
    SetNewWaypoint(data.coords[1], data.coords[2])
    cb('ok')
end)

RegisterNUICallback("editCall", function(data, cb)
    TriggerServerEvent("prp-mdt:editCall", data.index, data.details)
    cb('ok')
end)

RegisterNUICallback("deleteCall", function(data, cb)
    TriggerServerEvent("prp-mdt:deleteCall", data.index)
    cb('ok')
end)

RegisterNUICallback("deleteCallBlip", function(data, cb)
    if callBlip then
        RemoveBlip(callBlip)
        callBlip = nil
    end
end)

RegisterNUICallback("saveVehicleChanges", function(data, cb)
    TriggerServerEvent("prp-mdt:saveVehicleChanges", data)
    cb('ok')
end)

RegisterNetEvent("prp-mdt:returnOffenderSearchResults")
AddEventHandler("prp-mdt:returnOffenderSearchResults", function(results)
    SendNUIMessage({
        type = "returnedPersonMatches",
        matches = results
    })
end)

RegisterNetEvent("prp-mdt:closeModal")
AddEventHandler("prp-mdt:closeModal", function()
    SendNUIMessage({
        type = "closeModal"
    })
end)

RegisterNetEvent("prp-mdt:returnOffenderDetails")
AddEventHandler("prp-mdt:returnOffenderDetails", function(data)
    for i = 1, #data.vehicles do
        data.vehicles[i].model = GetLabelText(GetDisplayNameFromVehicleModel(data.vehicles[i].model))
    end
    SendNUIMessage({
        type = "returnedOffenderDetails",
        details = data
    })
end)

RegisterNetEvent("prp-mdt:returnOffensesAndOfficer")
AddEventHandler("prp-mdt:returnOffensesAndOfficer", function(data, name)
    SendNUIMessage({
        type = "offensesAndOfficerLoaded",
        offenses = data,
        name = name
    })
end)

RegisterNetEvent("prp-mdt:returnReportSearchResults")
AddEventHandler("prp-mdt:returnReportSearchResults", function(results)
    SendNUIMessage({
        type = "returnedReportMatches",
        matches = results
    })
end)

RegisterNetEvent("prp-mdt:returnVehicleSearchInFront")
AddEventHandler("prp-mdt:returnVehicleSearchInFront", function(results, plate)
    SendNUIMessage({
        type = "returnedVehicleMatchesInFront",
        matches = results,
        plate = plate
    })
end)

RegisterNetEvent("prp-mdt:returnVehicleSearchResults")
AddEventHandler("prp-mdt:returnVehicleSearchResults", function(results)
    SendNUIMessage({
        type = "returnedVehicleMatches",
        matches = results
    })
end)

RegisterNetEvent("prp-mdt:returnVehicleDetails")
AddEventHandler("prp-mdt:returnVehicleDetails", function(data)
    if type(data.model) == 'number' then
        data.model = GetLabelText(GetDisplayNameFromVehicleModel(data.model))
    end
    SendNUIMessage({
        type = "returnedVehicleDetails",
        details = data
    })
end)

RegisterNetEvent("prp-mdt:returnWarrants")
AddEventHandler("prp-mdt:returnWarrants", function(data)
    SendNUIMessage({
        type = "returnedWarrants",
        warrants = data
    })
end)

RegisterNetEvent("prp-mdt:completedWarrantAction")
AddEventHandler("prp-mdt:completedWarrantAction", function(data)
    SendNUIMessage({
        type = "completedWarrantAction"
    })
end)

RegisterNetEvent("prp-mdt:returnReportDetails")
AddEventHandler("prp-mdt:returnReportDetails", function(data)
    SendNUIMessage({
        type = "returnedReportDetails",
        details = data
    })
end)

RegisterNetEvent("prp-mdt:sendNUIMessage")
AddEventHandler("prp-mdt:sendNUIMessage", function(messageTable)
    SendNUIMessage(messageTable)
end)

RegisterNetEvent("prp-mdt:sendNotification")
AddEventHandler("prp-mdt:sendNotification", function(message)
    SendNUIMessage({
        type = "sendNotification",
        message = message
    })
end)

RegisterNetEvent("prp-mdt:getNewCallCoords")
AddEventHandler("prp-mdt:getNewCallCoords", function(details, callid)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("prp-mdt:newCall", details, callid, coords)
end)

RegisterNetEvent("prp-mdt:newCall")
AddEventHandler("prp-mdt:newCall", function(details, callid, coords, index)
    local x, y, z = table.unpack(coords)
    local var1, var2 = GetStreetNameAtCoord(x, y, z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local location = GetStreetNameFromHashKey(var1)..', '..zones[GetNameOfZone(x, y, z)]
    SendNUIMessage({
        type = "newCall",
        details = details,
        source = callid,
        coords = {x, y, z},
        location = location,
        id = index
    })
end)

RegisterNetEvent("prp-mdt:newCallAttach")
AddEventHandler("prp-mdt:newCallAttach", function(index, charname)
    SendNUIMessage({
        type = "newCallAttach",
        call = index,
        charname = charname
    })
end)

RegisterNetEvent("prp-mdt:newCallDetach")
AddEventHandler("prp-mdt:newCallDetach", function(index, charname)
    SendNUIMessage({
        type = "newCallDetach",
        call = index,
        charname = charname
    })
end)

RegisterNetEvent("prp-mdt:editCall")
AddEventHandler("prp-mdt:editCall", function(index, details)
    SendNUIMessage({
        type = "editCall",
        call = index,
        details = details
    })
end)

RegisterNetEvent("prp-mdt:deleteCall")
AddEventHandler("prp-mdt:deleteCall", function(index)
    SendNUIMessage({
        type = "deleteCall",
        call = index
    })
end)

function ToggleGUI(explicit_status)
  if explicit_status ~= nil then
    isVisible = explicit_status
  else
    isVisible = not isVisible
  end
  SetNuiFocus(isVisible, isVisible)
  SendNUIMessage({
    type = "enable",
    isVisible = isVisible
  })
end

function getVehicleInFront()
    local playerPed = PlayerPedId()
    local coordA = GetEntityCoords(playerPed, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 10.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end

RegisterCommand("mdt", function()
	if exports['isPed']:isPed('job') == 'Police' then
        TriggerEvent('prp-mdt:hotKeyOpen')
	end
    if exports['isPed']:isPed('job') == 'DOJ' then
        TriggerEvent('prp-mdt:hotKeyOpen')
    end
    if exports['isPed']:isPed('job') == 'FIB' then
        TriggerEvent('prp-mdt:hotKeyOpen')
    end
end)