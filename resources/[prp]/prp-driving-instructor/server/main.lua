RegisterServerEvent('prp-driving-instructor:check')
AddEventHandler('prp-driving-instructor:check', function(cid)
	local src = source
    exports.ghmattimysql:execute("UPDATE __characters SET drivlicense = @drivlicense WHERE id = @id", { 
        ['@id'] = cid,
        ['@drivlicense'] = true
    })
end)

RegisterServerEvent('prp-driving-instructor:remove')
AddEventHandler('prp-driving-instructor:remove', function(cid)
	local src = source
    exports.ghmattimysql:execute("UPDATE __characters SET drivlicense = @drivlicense WHERE id = @id", { 
        ['@id'] = cid,
        ['@drivlicense'] = false
    })
end)