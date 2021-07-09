RegisterServerEvent('urp:infinity:player:ready')
AddEventHandler('urp:infinity:player:ready', function()
    local sexinthetube = GetEntityCoords(GetPlayerPed(source))
    
    TriggerClientEvent('urp:infinity:player:coords', -1, sexinthetube)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        local sexinthetube = GetEntityCoords(source)

        TriggerClientEvent('urp:infinity:player:coords', -1, sexinthetube)
        TriggerEvent("wrp-core:updatecoords", sexinthetube.x, sexinthetube.y, sexinthetube.z)
       -- print("[^2wrp-infinity^0]^3 Sync Successful.^0")
    end
end)

RegisterServerEvent('player:setJob')
AddEventHandler('player:setJob', function(cid, job)

    local src = source

    exports.ghmattimysql:execute('UPDATE __characters SET job= ? WHERE id= ?', {job, cid})
end)

RegisterServerEvent('player:setRank')
AddEventHandler('player:setRank', function(cid, rank)

    local src = source

    exports.ghmattimysql:execute("UPDATE __characters SET rank = @rank WHERE id = @id", { 
        ['@id'] = cid,
        ['@rank'] = tonumber(rank)
    })
    -- exports.ghmattimysql:execute('UPDATE __characters SET rank= ? WHERE `id`= ?', {tonumber(rank), cid})
end)

RegisterServerEvent('player:removeCash')
AddEventHandler('player:removeCash', function(cid, amount)

    local src = source

    exports.ghmattimysql:execute('UPDATE __characters SET cash= ? WHERE id= ?', {amount, cid})
end)

RegisterServerEvent('player:addCash')
AddEventHandler('player:addCash', function(cid, amount)

    local src = source

    exports.ghmattimysql:execute('UPDATE __characters SET cash= ? WHERE id= ?', {amount, cid})
end)

RegisterServerEvent('player:setCash')
AddEventHandler('player:setCash', function(cid, amount)

    local src = source

    exports.ghmattimysql:execute('UPDATE __characters SET cash= ? WHERE id= ?', {amount, cid})
end)

RegisterServerEvent('player:removeBank')
AddEventHandler('player:removeBank', function(cid, amount)

    local src = source

    exports.ghmattimysql:execute('UPDATE __characters SET bank= ? WHERE id= ?', {amount, cid})
end)

RegisterServerEvent('player:addBank')
AddEventHandler('player:addBank', function(cid, amount)

    local src = source

    exports.ghmattimysql:execute('UPDATE __characters SET bank= ? WHERE id= ?', {amount, cid})
end)

RegisterServerEvent('player:setBank')
AddEventHandler('player:setBank', function(cid, amount)

    local src = source

    exports.ghmattimysql:execute('UPDATE __characters SET bank= ? WHERE id= ?', {amount, cid})
end)

-- RegisterServerEvent("paycheck:SV")
-- AddEventHandler("paycheck:SV", function(cid)
--     local src = source
--     while true do 
--         Citizen.Wait(1800000)
--         print('Paycheck given!')
--         local playercid = cid
--         exports.ghmattimysql:execute('SELECT * FROM __characters WHERE `id`= ?', {playercid}, function(data)
--             if data[1].job == 'None' and data[1].rank == 0 then
--                 TriggerClientEvent("payslip:call", src, playercid, 20)
--                 Citizen.Wait(10000)
--                 -- Police --
--             -- elseif data[1].job == 'Police' and data[1].rank == 0 then
--             --     TriggerClientEvent("payslip:call", src, playercid, 100)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'Police' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 120)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'Police' and data[1].rank == 2 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 140)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'Police' and data[1].rank == 3 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 160)
--             --     Citizen.Wait(10000) 
--             -- elseif data[1].job == 'Police' and data[1].rank == 4 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 180)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'Police' and data[1].rank == 5 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 200)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'Police' and data[1].rank == 6 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 220)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'Police' and data[1].rank == 7 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 240)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'Police' and data[1].rank == 8 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 260)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'Police' and data[1].rank == 9 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 280)
--             --     Citizen.Wait(10000)
--             --     -- Off Duty PD
--             -- elseif data[1].job == 'OffPolice' and data[1].rank == 0 then
--             --     TriggerClientEvent("payslip:call", src, playercid, 30)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffPolice' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 40)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffPolice' and data[1].rank == 2 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 50)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffPolice' and data[1].rank == 3 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 60)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffPolice' and data[1].rank == 4 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 70)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffPolice' and data[1].rank == 5 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 80)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffPolice' and data[1].rank == 6 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 90)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffPolice' and data[1].rank == 7 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 100)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffPolice' and data[1].rank == 8 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 110)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffPolice' and data[1].rank == 9 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 120)
--             --     Citizen.Wait(10000)
--                 -- Barber Payments --
--             elseif data[1].job == 'Barber' and data[1].rank == 0 then
--                 TriggerClientEvent("payslip:call", src, playercid, 140)
--                 Citizen.Wait(10000)
--             elseif data[1].job == 'Barber' and data[1].rank == 1 then 
--                 TriggerClientEvent("payslip:call", src, playercid, 150)
--                 Citizen.Wait(10000)
--             elseif data[1].job == 'Barber' and data[1].rank == 2 then 
--                 TriggerClientEvent("payslip:call", src, playercid, 160)
--                 Citizen.Wait(10000)
--             elseif data[1].job == 'Barber' and data[1].rank == 3 then 
--                 TriggerClientEvent("payslip:call", src, playercid, 170)
--                 Citizen.Wait(10000)
--             elseif data[1].job == 'Barber' and data[1].rank == 4 then 
--                 TriggerClientEvent("payslip:call", src, playercid, 180)
--                 Citizen.Wait(10000)
--                 -- Taxi Payments --
--             elseif data[1].job == 'Taxi' and data[1].rank == 0 then
--                 TriggerClientEvent("payslip:call", src, playercid, 140)
--                 Citizen.Wait(10000)
--             elseif data[1].job == 'Taxi' and data[1].rank == 1 then 
--                 TriggerClientEvent("payslip:call", src, playercid, 150)
--                 Citizen.Wait(10000)
--             elseif data[1].job == 'Taxi' and data[1].rank == 2 then 
--                 TriggerClientEvent("payslip:call", src, playercid, 160)
--                 Citizen.Wait(10000)
--             elseif data[1].job == 'Taxi' and data[1].rank == 3 then 
--                 TriggerClientEvent("payslip:call", src, playercid, 170)
--                 Citizen.Wait(10000)
--             elseif data[1].job == 'Taxi' and data[1].rank == 4 then 
--                 TriggerClientEvent("payslip:call", src, playercid, 180)
--                 Citizen.Wait(10000)
--                 -- Prozy Payments --
--             elseif data[1].job == 'Prostitute' and data[1].rank == 0 then
--                 TriggerClientEvent("payslip:call", src, playercid, 140)
--                 Citizen.Wait(10000)
--             elseif data[1].job == 'Prostitute' and data[1].rank == 1 then 
--                 TriggerClientEvent("payslip:call", src, playercid, 150) 
--                 Citizen.Wait(10000)
--             elseif data[1].job == 'Prostitute' and data[1].rank == 2 then 
--                 TriggerClientEvent("payslip:call", src, playercid, 160) 
--                 Citizen.Wait(10000)
--             elseif data[1].job == 'Prostitute' and data[1].rank == 3 then 
--                 TriggerClientEvent("payslip:call", src, playercid, 170) 
--                 Citizen.Wait(10000)
--             elseif data[1].job == 'Prostitute' and data[1].rank == 4 then 
--                 TriggerClientEvent("payslip:call", src, playercid, 180) 
--                 Citizen.Wait(10000)
--                 -- On duty EMS Payment shit --
--             -- elseif data[1].job == 'EMS' and data[1].rank == 0 then
--             --     TriggerClientEvent("payslip:call", src, playercid, 180)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'EMS' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 200) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'EMS' and data[1].rank == 2 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 220) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'EMS' and data[1].rank == 3 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 240) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'EMS' and data[1].rank == 4 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 260) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'EMS' and data[1].rank == 5 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 280) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'EMS' and data[1].rank == 6 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 300)
--             --     Citizen.Wait(10000) 
--                 -- Off Duty EMS Payment --
--             -- elseif data[1].job == 'OffEMS' and data[1].rank == 0 then
--             --     TriggerClientEvent("payslip:call", src, playercid, 120)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffEMS' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 120) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffEMS' and data[1].rank == 2 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 130)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffEMS' and data[1].rank == 3 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 140) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffEMS' and data[1].rank == 4 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 150) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffEMS' and data[1].rank == 5 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 160) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'OffEMS' and data[1].rank == 6 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 180) 
--             --     Citizen.Wait(10000)
--                 -- PDM Payment --
--             -- elseif data[1].job == 'PDM' and data[1].rank == 0 then
--             --     TriggerClientEvent("payslip:call", src, playercid, 150)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'PDM' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 160) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'PDM' and data[1].rank == 2 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 170) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'PDM' and data[1].rank == 3 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 180) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'PDM' and data[1].rank == 4 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 190) 
--             --     Citizen.Wait(10000)
--                 -- Real Estate Payment --
--             -- elseif data[1].job == 'RealEstate' and data[1].rank == 0 then
--             --     TriggerClientEvent("payslip:call", src, playercid, 150)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'RealEstate' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 160) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'RealEstate' and data[1].rank == 2 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 170) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'RealEstate' and data[1].rank == 3 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 180) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'RealEstate' and data[1].rank == 4 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 190) 
--             --     Citizen.Wait(10000)
--                 -- Harmony Repair Payment --
--             -- elseif data[1].job == 'HarmonyRepairs' and data[1].rank == 0 then
--             --     TriggerClientEvent("payslip:call", src, playercid, 160)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'HarmonyRepairs' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 180) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'HarmonyRepairs' and data[1].rank == 2 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 200)
--             --     Citizen.Wait(10000) 
--             -- elseif data[1].job == 'HarmonyRepairs' and data[1].rank == 3 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 210) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'HarmonyRepairs' and data[1].rank == 4 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 215) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'HarmonyRepairs' and data[1].rank == 5 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 230) 
--             --     Citizen.Wait(10000)
--                 -- Basic Mechanic Job --
--             -- elseif data[1].job == 'Mechanic' and data[1].rank == 0 then
--             --     TriggerClientEvent("payslip:call", src, playercid, 160)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'Mechanic' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 180) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'Mechanic' and data[1].rank == 2 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 200)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'Mechanic' and data[1].rank == 3 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 210) 
--             --     Citizen.Wait(10000) 
--             -- elseif data[1].job == 'Mechanic' and data[1].rank == 4 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 215)
--             --     Citizen.Wait(10000) 
--             -- elseif data[1].job == 'Mechanic' and data[1].rank == 5 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 230) 
--             --     Citizen.Wait(10000)
--                 -- Uber Delivery Payment --
--             -- elseif data[1].job == 'uberdelivery' and data[1].rank == 0 then
--             --     TriggerClientEvent("payslip:call", src, playercid, 125)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'uberdelivery' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 125) 
--             --     Citizen.Wait(10000)
--                 -- Drift School Payment --
--             -- elseif data[1].job == 'DriftSchool' and data[1].rank == 0 then
--             --     TriggerClientEvent("payslip:call", src, playercid, 220)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'DriftSchool' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 220) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'DriftSchool' and data[1].rank == 2 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 240)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'DriftSchool' and data[1].rank == 3 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 260)
--             --     Citizen.Wait(10000)
--                 -- tuner_carshop --
--             -- elseif data[1].job == 'tuner_carshop' and data[1].rank == 0 then
--             --     TriggerClientEvent("payslip:call", src, playercid, 200)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'tuner_carshop' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 210) 
--             --     Citizen.Wait(10000) 
--             -- elseif data[1].job == 'tuner_carshop' and data[1].rank == 2 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 220)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'tuner_carshop' and data[1].rank == 3 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 230)
--             --     Citizen.Wait(10000)
--             --     -- Tuner Car Shop Payment (Think this is the Repair Vehicle One)
--             -- elseif data[1].job == 'illegal_carshop' and data[1].rank == 0 then
--             --     TriggerClientEvent("payslip:call", src, playercid, 200)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'illegal_carshop' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 210)
--             --     Citizen.Wait(10000)    
--             -- elseif data[1].job == 'illegal_carshop' and data[1].rank == 2 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 220)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'illegal_carshop' and data[1].rank == 3 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 230)   
--             --     Citizen.Wait(10000)  
--             --     -- BurgerShot
--             -- elseif data[1].job == 'BurgerShot' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 200)
--             --     Citizen.Wait(10000) 
--                 -- Bakery --
--             -- elseif data[1].job == 'Bakery' and data[1].rank == 0 then
--             --     TriggerClientEvent("payslip:call", src, playercid, 175)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'Bakery' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 180) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'Bakery' and data[1].rank == 2 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 190) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'Bakery' and data[1].rank == 3 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 205) 
--             --     Citizen.Wait(10000)
--             --     --CamelTowing
--             -- elseif data[1].job == 'CamelTowing' and data[1].rank == 1 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 180) 
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'CamelTowing' and data[1].rank == 2 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 200)
--             --     Citizen.Wait(10000)
--             -- elseif data[1].job == 'CamelTowing' and data[1].rank == 3 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 210) 
--             --     Citizen.Wait(10000) 
--             -- elseif data[1].job == 'CamelTowing' and data[1].rank == 4 then 
--             --     TriggerClientEvent("payslip:call", src, playercid, 215)
--             --     Citizen.Wait(10000) 
--             end
--         end)
--     end
-- end)