--MADE BY URP Development Team 

local st
local iden
RegisterServerEvent("prp-weed:createplant")
AddEventHandler("prp-weed:createplant", function(x, y, z, strain, cid)
    _source = source
    iden =  cid
    if strain == "Seeded" then
        st = 3
    else
        st = 2
    end
        exports.ghmattimysql:execute('INSERT INTO `weeds` (`identifier`, `x`, `y`, `z`, `strain`, `status`) VALUES (@identifier, @x, @y, @z, @strain, @status)', {
            ['@identifier'] = iden,
            ['@x']  = x,
            ['@y']  = y,
            ['@z']  = z,
            ['@strain']  = strain,
            ['@status']  = st
            

        }, function(lol)
        exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `weeds` ORDER BY `id`) sub ORDER BY `id`", {}, function(weeds)
            for c = 1, #weeds do
            TriggerClientEvent("prp-weed:currentcrops", -1, weeds)  
            end
        end)
    end)
end)

RegisterServerEvent("prp-weed:requestTable")
AddEventHandler("prp-weed:requestTable", function()
    _source = source
     exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `weeds` ORDER BY `id`) sub ORDER BY `id`", {}, function(weeds)
        for c = 1, #weeds do
         TriggerClientEvent("prp-weed:currentcrops", -1, weeds)  
        end
end)
end)

RegisterServerEvent("prp-weed:setStatus2")
AddEventHandler("prp-weed:setStatus2", function()
    _source = source
    local status
     exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `weeds` ORDER BY `id`) sub ORDER BY `id`", {}, function(weeds)
        for c = 1, #weeds do
    if weeds[c].strain == "Seeded" then
        status = 3
    else
        status = 2 
    end

         exports.ghmattimysql:execute('UPDATE `weeds` SET `status` = @status WHERE `id` = @id', {
            ['@id'] = weeds[c].id,
            ['@status'] = status
        }, function(lol) 
           TriggerEvent("prp-weed:requestTable")
          end)
       end
   end)
end)

RegisterServerEvent("prp-weed:killplant")
AddEventHandler("prp-weed:killplant", function(id)
   _source = source
    exports.ghmattimysql:execute('DELETE FROM `weeds` WHERE `id` = @id', {
    ['@id'] = id,
     }, function(lol) 
    TriggerClientEvent('prp-weed:updateplantwithID', -1, id, '0', "remove")
     end)
end)
    

RegisterServerEvent("prp-weed:UpdateWeedGrowth")
AddEventHandler("prp-weed:UpdateWeedGrowth", function(id, new)
    _source = source
    print(id)
    exports.ghmattimysql:execute('UPDATE `weeds` SET `growth` = @growth,  `status` = @status WHERE `id` = @id', {
        ['@id'] = id,
        ['@status'] = 1,
        ['@growth'] = new
    }, function(lol) 
      TriggerClientEvent('prp-weed:updateplantwithID', -1, id, new, "alter")
  end)
end)

RegisterServerEvent("prp-weed:UpdateWeedStatus")
AddEventHandler("prp-weed:UpdateWeedStatus", function(id, status)
    _source = source
    print(id)
    exports.ghmattimysql:execute('UPDATE `weeds` SET `status` = @status WHERE `id` = @id', {
        ['@id'] = id,
        ['@status'] = 1
    }, function(lol) 
      TriggerClientEvent('prp-weed:updateplantwithID', -1, id, new, 'alter')

end)
end)