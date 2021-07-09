local webhook = 'https://discord.com/api/webhooks/793696544632864778/HYgBQ2FkKQdOqh1uIvNFRCAZ7CyMh4F3BY_8lz_dsFRAwn3BF0wBB76cL1DX2Adjxdah'
local webhook = ''

RegisterNetEvent('wrp-coords:server')
AddEventHandler('wrp-coords:server', function(x, y, z , heading)

    -- print('dick')

    -- print(json.encode(data))
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = 'Coords Dick', content = '`' .. string.format('x = %s, y = %s, z = %s, h = %s', tostring(x), tostring(y), tostring(z), tostring(heading)) .. '`', tts = false}), { ['Content-Type'] = 'application/json' })

end)