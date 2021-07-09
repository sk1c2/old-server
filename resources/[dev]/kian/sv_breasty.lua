RegisterServerEvent("payslip:getamount")
AddEventHandler("payslip:getamount", function(cid)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM __characters WHERE `id`= ?', {cid}, function(data)
        if data[1].payslips ~= tonumber(0) then
            local payslipamount = data[1].payslips
            local mathpay = payslipamount * 0.15
            local withouttaxpayslip = payslipamount + mathpay
            -- TriggerClientEvent('obtainPaycheckForBlip', src, payslipamount, withouttaxpayslip)
            TriggerClientEvent("obtainPaycheckForBlip", src, payslipamount, withouttaxpayslip)
        end
    end)
end)

RegisterServerEvent("payslip:get")
AddEventHandler("payslip:get", function(cid)
    local src = source
    exports.ghmattimysql:execute('SELECT * FROM __characters WHERE `id`= ?', {cid}, function(data)
        if data[1].payslips ~= tonumber(0) then
            TriggerClientEvent('prp-ac:checkforkick', src, data[1].payslips)
            exports.ghmattimysql:execute("UPDATE __characters SET `payslips` = @payslips WHERE id = @id", {
                ['payslips'] = "0", 
                ['id'] = cid
            })
        else
            TriggerClientEvent('DoLongHudText', src, 'You dont have a paycheck ready', 2)
        end
    end)
end)

RegisterServerEvent('prp-license:givelicense')
AddEventHandler('prp-license:givelicense', function(target, cb)
	local src = source
    exports.ghmattimysql:execute("UPDATE __characters SET license = @license WHERE id = @id", { 
        ['@id'] = target,
        ['@license'] = true
    })
end)

RegisterServerEvent('prp-license:givedrivinglicense')
AddEventHandler('prp-license:givedrivinglicense', function(target, cb)
	local src = source
    exports.ghmattimysql:execute("UPDATE __characters SET license = @license WHERE id = @id", { 
        ['@id'] = target,
        ['@license'] = true
    })
end)

RegisterServerEvent('prp-license:removelicense')
AddEventHandler('prp-license:removelicense', function(target, cb)
	local src = source
    exports.ghmattimysql:execute("UPDATE __characters SET license = @license WHERE id = @id", { 
        ['@id'] = target,
        ['@license'] = false
    })
end)

RegisterNetEvent('prp-license:ObtainLicenses')
AddEventHandler('prp-license:ObtainLicenses', function(cid)
	local src = source
    exports.ghmattimysql:execute("SELECT * FROM __characters WHERE id = ?", {cid}, function(result)
		local leggy = result[1].license
		return leggy
    end)
end)

RegisterServerEvent('server:GroupPayment')
AddEventHandler('server:GroupPayment', function(job, amount)
    TriggerClientEvent('client:GroupPayment', -1, job, amount)
end)

RegisterNetEvent('prp-license:addLicense')
AddEventHandler('prp-license:addLicense', function(target, type, cb)
	AddLicense(target, type, cb)
end)

RegisterNetEvent('prp-license:removeLicense')
AddEventHandler('prp-license:removeLicense', function(target, type, cb)
	RemoveLicense(target, type, cb)
end)

AddEventHandler('prp-license:getLicense', function(type, cb)
	GetLicense(type, cb)
end)

AddEventHandler('prp-license:getLicenses', function(target, cb)
	GetLicenses(target, cb)
end)
RegisterServerEvent('prp-license:checkLicense')
AddEventHandler('prp-license:checkLicense', function(target, type, cb)
	CheckLicense(target, type, cb)
end)

AddEventHandler('prp-license:getLicensesList', function(cb)
	GetLicensesList(cb)
end)

RegisterServerEvent("payslip:add")
AddEventHandler("payslip:add", function(cid, amount)
    local src = source
    local update = amount
    local tax = tonumber(amount * 0.15)
    exports.ghmattimysql:execute('SELECT * FROM __characters WHERE `id`= ?', {cid}, function(data)
        exports.ghmattimysql:execute("UPDATE __characters SET `payslips` = @payslips WHERE id = @id", {
            ['payslips'] = tonumber(data[1].payslips + update - tax), 
            ['id'] = cid
		})
		local newbal  = tonumber(data[1].payslips + update)
		TriggerClientEvent('DoLongHudText', src, 'A payslip of $'.. update ..' making a total of $' ..newbal ..' with $'.. tax .. ' tax withheld on your last payment.', 1)
    end)
end)