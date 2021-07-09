RegisterServerEvent('wrp-driving-instructor:check')
AddEventHandler('wrp-driving-instructor:check', function(cid)
	local src = source
    exports.ghmattimysql:execute("UPDATE __characters SET drivlicense = @drivlicense WHERE id = @id", { 
        ['@id'] = cid,
        ['@drivlicense'] = true
    })
end)

RegisterServerEvent('wrp-driving-instructor:remove')
AddEventHandler('wrp-driving-instructor:remove', function(cid)
	local src = source
    exports.ghmattimysql:execute("UPDATE __characters SET drivlicense = @drivlicense WHERE id = @id", { 
        ['@id'] = cid,
        ['@drivlicense'] = false
    })
end)