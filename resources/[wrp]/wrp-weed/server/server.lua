--MADE BY URP Development Team 

local st
local iden
RegisterServerEvent("wrp-weed:createplant")
AddEventHandler("wrp-weed:createplant", function(x, y, z, strain, cid)
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
            TriggerClientEvent("wrp-weed:currentcrops", -1, weeds)  
            end
        end)
    end)
end)

RegisterServerEvent("wrp-weed:requestTable")
AddEventHandler("wrp-weed:requestTable", function()
    _source = source
     exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `weeds` ORDER BY `id`) sub ORDER BY `id`", {}, function(weeds)
        for c = 1, #weeds do
         TriggerClientEvent("wrp-weed:currentcrops", -1, weeds)  
        end
end)
end)

RegisterServerEvent("wrp-weed:setStatus2")
AddEventHandler("wrp-weed:setStatus2", function()
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
           TriggerEvent("wrp-weed:requestTable")
          end)
       end
   end)
end)

RegisterServerEvent("wrp-weed:killplant")
AddEventHandler("wrp-weed:killplant", function(id)
   _source = source
    exports.ghmattimysql:execute('DELETE FROM `weeds` WHERE `id` = @id', {
    ['@id'] = id,
     }, function(lol) 
    TriggerClientEvent('wrp-weed:updateplantwithID', -1, id, '0', "remove")
     end)
end)
    

RegisterServerEvent("wrp-weed:UpdateWeedGrowth")
AddEventHandler("wrp-weed:UpdateWeedGrowth", function(id, new)
    _source = source
    print(id)
    exports.ghmattimysql:execute('UPDATE `weeds` SET `growth` = @growth,  `status` = @status WHERE `id` = @id', {
        ['@id'] = id,
        ['@status'] = 1,
        ['@growth'] = new
    }, function(lol) 
      TriggerClientEvent('wrp-weed:updateplantwithID', -1, id, new, "alter")
  end)
end)

RegisterServerEvent("wrp-weed:UpdateWeedStatus")
AddEventHandler("wrp-weed:UpdateWeedStatus", function(id, status)
    _source = source
    print(id)
    exports.ghmattimysql:execute('UPDATE `weeds` SET `status` = @status WHERE `id` = @id', {
        ['@id'] = id,
        ['@status'] = 1
    }, function(lol) 
      TriggerClientEvent('wrp-weed:updateplantwithID', -1, id, new, 'alter')

end)
end)