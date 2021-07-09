URP.Player = URP.Player or {}
URP.Player.Characters = URP.Player.Characters or {}
URP.LocalPlayer = URP.LocalPlayer or {}

-- need to implement Tax set at 15%

local function GetUser()
    return URP.Player
end

function URP.Player.InsertCharacter(self, data)
    if not data then return end

    table.insert(URP.Player.Characters, data)

end

function URP.Player.RemoveCharacter(self, uid)
    if not uid then return end

    for k, v in pairs(URP.Player.Characters) do
        if v.uid == uid then table.remove(URP.Player.Characters, k) end
    end

end

function URP.Player.setVar(self, var, data)
    GetUser()[var] = data
end

function URP.Player.getVar(self, var)
    return GetUser()[var]
end

function URP.Player.getCurrentCharacter(self, uid)
    for k, v in pairs(URP.Player.Characters) do
        if v.uid == uid then return v end
    end
end

local function getUserId(source)
    src = srouce 
end

function URP.Player.setCurrentCharacter(self, data, source)
    local _src = source
    if not data then return end
    GetUser():setVar("character", data)
    GetUser():setVar("source", _src)
end

function URP.Player.getCharacterFromCid(self, cid)
    for k, v in pairs(URP.Player.Characters) do
        if v.id == cid then return v, k end
    end
end

function URP.Player.getCharacterNameFromSource(self, source)
    for k, v in pairs(URP.Player.Characters) do
        if v.playerSrc == tonumber(source) then return v.first_name, v.last_name, v.id end
    end
end

function GetCurrentCharacterInfo(source) 
    local steam = GetPlayerIdentifiers(source)[1]
    local result = MySQL.Sync.fetchAll("SELECT __users.uid FROM __users WHERE steam = @steam", {['@steam'] = steam})
    if result[1] ~= nil then
        local userData = promise:new()
        userData:resolve(result)
        local uid = Citizen.Await(userData)
        local user = exports['prp-base']:getModule("Player")
        char = user:getCurrentCharacter(uid[1].uid)
        exports.ghmattimysql:execute('SELECT * FROM character_current WHERE cid = ?', {char.id}, function(result)
            if result[1] == nil then
                local steam = GetPlayerIdentifiers(source)[1]
                exports.ghmattimysql:execute('SELECT `uid` FROM __users WHERE steam = ?', {steam}, function(data)
                    playeruid = data[1].uid
                    print(playeruid)
                    exports.ghmattimysql:execute('SELECT `id` FROM __characters WHERE uid = ?', {playeruid}, function(player)
                        if result[1] ~= nil then
                            char = user:getCurrentCharacter(player.id)
                            print('prp-BASE::GetCurrentCharacterInfo: Grabbed character ' .. json.encode(char))
                            return char
                        end
                    end)
                end)
            else
                print('prp-BASE::GetCurrentCharacterInfo: Grabbed character ' .. json.encode(char))
                return char
            end
        end)
        print('prp-BASE::GetCurrentCharacterInfo: Grabbed character ' .. json.encode(char))
        return char
    end
    return nil
end

RegisterNetEvent('prp-base:updateJobLogs')
AddEventHandler('prp-base:updateJobLogs', function(tSource, nRank, jId)
    -- print('dick')
    local tSource = tSource

    local tFirstName, tLastName, tCid = URP.Player:getCharacterNameFromSource(tSource)

    -- print(tFirstName, tLastName, tCid)

    if not tFirstName or not tLastName then return end

    exports.ghmattimysql:execute('INSERT INTO __employees VALUES(?, ?, ?, ?, ?)', {tCid, tFirstName .. ' ' .. tLastName, 'Government', nRank, jId})

    TriggerClientEvent("DoLongHudText", tSource, "You have been apointed a new job.", 1)

end)

RegisterNetEvent('prp-base:updateCharacterBank')
AddEventHandler('prp-base:updateCharacterBank', function(nBank, uCid, tStatus, cAmount)
    local tCharacter, tCharacterIndex = URP.Player:getCharacterFromCid(tonumber(uCid))

    if not tCharacter then return end

    local cSource = tCharacter.playerSrc

    TriggerClientEvent('prp-phone:groupManageUpdateBank', cSource, uCid, nBank)
    if tStatus then
        TriggerClientEvent('banking:addBalance', cSource, cAmount)
    else
        TriggerClientEvent('banking:removeBalance', cSource, cAmount)
    end

end)

RegisterNetEvent('prp-base:setServerCharacter')
AddEventHandler('prp-base:setServerCharacter', function(data)

    local source = source
    data['playerSrc'] = source

    -- print(json.encode(data))
    local character = data
    local _src = source
    URP.Player:InsertCharacter(data)

    exports.ghmattimysql:execute('SELECT `emote_data` FROM __emotes WHERE cid= ?', {data.id}, function(result)
        if result[1] ~= nil then
            TriggerClientEvent('emote:setEmotesFromDB', _src, result[1].emote_data)
        end
    end)

end)

RegisterServerEvent('player:setServerMeta')
AddEventHandler('player:setServerMeta', function(armor, thirst, hunger)

    local src = source
    local steam = GetPlayerIdentifiers(src)[1]
    local userData = promise:new()
    -- print(armor)

    exports.ghmattimysql:execute('SELECT uid FROM __users WHERE steam = ?', {steam}, function(data)
        userData:resolve(data)
    end)

    local uid = Citizen.Await(userData)
    local user = URP.Player
    local char = user:getCurrentCharacter(uid[1].uid)
    -- local characterId = char.id

    -- exports.ghmattimysql:execute('UPDATE __characters SET armor= ?,SET health= ?, water= ?, food= ? WHERE id= ?', {armor, health, thirst, hunger, characterId})
end)

AddEventHandler("onResourceStart", function(resourceName)
	if ("prp-base" == resourceName) then
        URP.Player.Characters = {}
    end
end)

AddEventHandler('playerDropped', function (reason)
    local source = source
    local steam = GetPlayerIdentifiers(source)[1]
    print('\27[32m[prp-base]\27[0m: Saved ' .. GetPlayerName(source) .. ' |  Disconnected (Reason: ' .. reason .. ')')

    local userData = promise:new()

    exports.ghmattimysql:execute('SELECT uid FROM __users WHERE steam = ?', {steam}, function(data)
        userData:resolve(data)
    end)
    TriggerClientEvent('hud:saveCurrentMeta', source)

    local uid = Citizen.Await(userData)
    Citizen.Wait(2500)
    URP.Player:RemoveCharacter(tonumber(uid[1].uid))
end)