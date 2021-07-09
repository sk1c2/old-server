local menuOpen = false
local setDate = 0

local uId = {}
local characters = {}
userId = 0

local isnew = false

RegisterNetEvent('wrp-login:updateUId')
AddEventHandler('wrp-login:updateUId', function(uid)
    uId = uid
    userId = uid[1].uid
end)

RegisterNetEvent('wrp-login:updateChars')
AddEventHandler('wrp-login:updateChars', function(chardata)
    characters = chardata
end)

function getCharacter(id)
    for k,v in pairs(characters) do 
        if v.id == id then
            return v
        end
    end
end

local function sendMessage(data)
    SendNUIMessage(data)
end

local function openMenu()
    menuOpen = true
    sendMessage({open = true})
    SetNuiFocus(true, true)
    TriggerEvent("resetinhouse")
    Citizen.CreateThread(function()
        while menuOpen do
            Citizen.Wait(0)
            HideHudAndRadarThisFrame()
            DisableAllControlActions(0)
            TaskSetBlockingOfNonTemporaryEvents(PlayerPedId(), true)
        end
    end)
end

local function closeMenu()
    menuOpen = false
    EnableAllControlActions(0)
    TaskSetBlockingOfNonTemporaryEvents(PlayerPedId(), false)
    SetNuiFocus(false, false)
end

local function disconnect()
    TriggerServerEvent("wrp-login:disconnectPlayer")
end

local function nuiCallBack(data)
    Citizen.Wait(60)

    if data.close then closeMenu() end
    if data.disconnect then disconnect() end
    if data.showcursor or data.showcursor == false then SetNuiFocus(true, data.showcursor) end
    if data.setcursorloc then SetCursorLocation(data.setcursorloc.x, data.setcursorloc.y) end
    
    if data.fetchdata then
        if type(uId) == 'table' then
            sendMessage({playerdata = uId})
        end
    end

    if data.newchar then
        if not data.chardata then return end
        isnew = data.newchar
        TriggerServerEvent('wrp-login:createCharacter', data.chardata, userId, getPhoneRandomNumber())
        TriggerEvent('character:isNew', true)
        TriggerEvent('chatMessage', "Hey", 2, "^1Welcome to Wonder! If you would like to get started press T and type /help! All information is held there.")
        Citizen.Wait(1000)
        sendMessage({createCharacter = 'penis'})
    end

    if data.fetchcharacters then

        TriggerServerEvent('wrp-login:updateCharacters', userId)

        Citizen.Wait(2000)
        sendMessage({playercharacters = characters})
    end

    if data.deletecharacter then
        if not data.deletecharacter then return end

        TriggerServerEvent('wrp-login:deleteCharacter', data.deletecharacter)
        sendMessage({reload = true})
    end

    if data.selectcharacter then
        local char = getCharacter(data.selectcharacter)
        TriggerServerEvent('wrp-base:setServerCharacter', char)

        local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
        LocalPlayer:setCurrentCharacter(char)
        local Player = LocalPlayer:getCurrentCharacter()

        TriggerEvent('isPed:updateCid', char.id)

        Citizen.Wait(2500)
        -- print(json.encode(LocalPlayer:getCurrentCharacter()))
        
        Citizen.Wait(2500)
        sendMessage({close = true})
        SetPlayerInvincible(PlayerPedId(), true)

        TriggerEvent("wrp-base:firstSpawn")
        closeMenu()
        Citizen.Wait(5000)
        SetPlayerInvincible(PlayerPedId(), false)
        TriggerEvent('wrp-login:loadCharData', Player.food, Player.water, Player.armor, Player.stress)
        TriggerEvent('isPed:setAllData', Player.id, Player.job, Player.first_name, Player.last_name, Player.cash, Player.bank)
        if Player.jail ~= nil and Player.jail > 5 then
            TriggerServerEvent('wrp-jailhehe', source, Player.jail, Player.first_name .. ' ' .. Player.last_name, Player.id)
        end
        TriggerEvent('stocks:retrieve', Player.id)
        local _source = source
        TriggerServerEvent('wrp-weapons:updateAmmo', Player.id, true)
        --add players to scoreboard
        SetNuiFocus(false, false)
        TriggerEvent('wrp-base:loadPlayerData')
    end
end

RegisterNUICallback("nuiMessage", nuiCallBack)

AddEventHandler("wrp-base:spawnInitialized", function()
    TriggerServerEvent('wrp-login:getUserId', source)
    Citizen.Wait(500)
    openMenu()
end)

RegisterNetEvent("updateTimeReturn")
AddEventHandler("updateTimeReturn", function()
    setDate = "" .. 0 .. ""
    sendMessage({date = setDate})
end)

function getPhoneRandomNumber()
    local numBase0 = 4
    local numBase1 = math.random(10,99)
    local numBase2 = math.random(100,999)
    local numBase3 = math.random(1000,9999)
    local num = string.format(numBase0 .. "" .. numBase1 .. "" .. numBase2 .. "" .. numBase3)
    return num
end