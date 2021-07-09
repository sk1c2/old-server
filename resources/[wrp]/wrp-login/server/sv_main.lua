RegisterNetEvent('wrp-login:getUserId')
AddEventHandler('wrp-login:getUserId', function()
    local src = source
    local steam = GetPlayerIdentifiers(src)[1]


    exports.ghmattimysql:execute('SELECT uid FROM __users WHERE steam = ?', {steam}, function(data)
        TriggerClientEvent('wrp-login:updateUId', src, data)
    end)

end)

RegisterNetEvent('wrp-login:updateCharacters')
AddEventHandler('wrp-login:updateCharacters', function(uid)
    local src = source
    local uId = uid
    

    exports.ghmattimysql:execute('SELECT * FROM __characters WHERE uid= ?', {uId}, function(data)
        TriggerClientEvent('wrp-login:updateChars', src, data)
    end)

end)

RegisterNetEvent('wrp-login:createCharacter')
AddEventHandler('wrp-login:createCharacter', function(data, userid, pn)
    local src = source
    local phone = pn

    exports.ghmattimysql:execute('INSERT INTO __characters(first_name, last_name, dob, gender, phone_number, story, uid) VALUES(?, ?, ?, ?, ?, ?, ?)', {data.firstname, data.lastname, data.dob, data.gender, phone, data.story, userid})

end)

RegisterNetEvent('wrp-login:deleteCharacter')
AddEventHandler('wrp-login:deleteCharacter', function(data)
    local src = source

    exports.ghmattimysql:execute('DELETE FROM __characters WHERE id = ? LIMIT 1', {data})

end)

RegisterNetEvent("wrp-login:disconnectPlayer")
AddEventHandler("wrp-login:disconnectPlayer", function()
    local src = source

    DropPlayer(src, 'Later Cunt!')

end)