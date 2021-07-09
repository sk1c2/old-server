AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local rank = 'None'
    local sPlayerSrc = source
    local sPlayerName = GetPlayerName(sPlayerSrc)
    local setKickReason = setKickReason
    local connecting = true
    
    deferrals.defer()

    Citizen.CreateThread(function()
        while connecting do
            Citizen.Wait(100)
            if not connecting then return end
            deferrals.update('Your information is currently being proccessed, stand by.')
        end
    end)

    Citizen.Wait(250)

    local identity = GetPlayerIdentifiers(sPlayerSrc)

    if (not string.find(identity[1], 'steam')) then
        connecting = false
        deferrals.done('\n\nIt doesn\'t look like you have steam open.\nPlease restart your FiveM client with steam open.')
        CancelEvent()
    end

    if (not string.find(identity[2], 'license')) then
        connecting = false
        deferrals.done('\n\nIt doesn\'t look like you have steam open.\nPlease restart your FiveM client with steam open.')
        CancelEvent()
    end

    local userData = promise:new()

    exports.ghmattimysql:execute('SELECT * FROM __users WHERE steam = ?', {identity[1]}, function(data)
        userData:resolve(data)
    end)

    local userValues = Citizen.Await(userData)

    if (#userValues <= 0) then
        exports.ghmattimysql:execute('INSERT INTO __users(steam, license) VALUES(?, ?)', {identity[1], identity[2]}, function(data)end)
    end

    Wait(0)

    --[[if (userValues[1].whitelist == 0) then
        connecting = false
        deferrals.done('\n\nIt doesn\'t look like you are whitelisted.\nFeel free to apply on our discord!s')
        CancelEvent()
    end]]--

    connecting = false
    deferrals.done()

end)

Citizen.CreateThread(function()
    print('\27[32m[prp-base]\27[0m: prp-base has been loaded successfully!')
end)