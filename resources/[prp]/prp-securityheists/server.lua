
local license = 0

local licenseArray = {}

job = nil

RegisterServerEvent('sec:checkRobbed')
AddEventHandler('sec:checkRobbed', function(license)

local _source = source

if licenseArray[#licenseArray] ~= nil then
    for k, v in pairs(licenseArray) do
        if v == license then
        --print('Bitch')
        return
        end
    end
end

licenseArray[#licenseArray+1] = license

    TriggerClientEvent('sec:AllowHeist', _source)
end)

RegisterServerEvent('prp-securityheists:gatherjob')
AddEventHandler('prp-securityheists:gatherjob', function(jobname)
    job = jobname
    --print(job)
end)