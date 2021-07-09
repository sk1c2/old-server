RegisterServerEvent('police:setEmoteData')
AddEventHandler('police:setEmoteData', function(currentKeys, cid)
    exports.ghmattimysql:execute('SELECT emote_data FROM __emotes WHERE cid = ?', {cid}, function(data)
        if data[1].emote_data == nil then
            exports.ghmattimysql:execute('INSERT INTO __emotes(cid, emote_data) VALUES(?, ?)', {cid, json.encode(currentKeys)})
        else
            exports.ghmattimysql:execute('UPDATE __emotes SET `emote_data`= ? WHERE `cid`= ?', {cid, json.encode(currentKeys)})
        end
    end)
end)