RegisterServerEvent("prp-weapons:updateAmmo")
AddEventHandler('prp-weapons:updateAmmo', function(cid,newammo,ammoType,ammoTable, firstLoad)
    local source = source
    if firstLoad == false then
        exports.ghmattimysql:execute('SELECT `ammoTable` FROM __ammo WHERE id = @id', {
            ['@id'] = cid,
        }, function(results)
            if #results == 0 then
                exports.ghmattimysql:execute('INSERT INTO __ammo (id, newammo, ammoTable) VALUES (@id, @newammo, @ammoTable)', {
                    ['@id'] = cid,
                    ['@newammo'] = newammo,
                    ['@ammoTable'] = json.encode(ammoTable)
                })
            else
                exports.ghmattimysql:execute('UPDATE __ammo SET newammo = @newammo, ammoTable = @ammoTable WHERE id = @id', {
                    ['@id'] = cid,
                    ['@newammo'] = newammo,
                    ['@ammoTable'] = json.encode(ammoTable)
                })
            end
        end)
    else
        exports.ghmattimysql:execute('SELECT `ammoTable` FROM __ammo WHERE id = @id', {
            ['@id'] = cid,
        }, function(results)
            if #results == 0 then
                --Do nothing
            else
                -- print(results[1].ammoTable)
                TriggerClientEvent('prp-items:SetAmmo', source, json.decode(results[1].ammoTable))
            end
        end)
    end
end)