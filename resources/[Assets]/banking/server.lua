RegisterServerEvent('bank:givecashh')
AddEventHandler('bank:givecashh', function(toPlayer, amount)
    if amount ~= nil then
        TriggerClientEvent('prp-ac:checkforkick', toPlayer, amount)
    end
end)

RegisterServerEvent('prp-banking:pass')
AddEventHandler('prp-banking:pass', function(toPlayer, amount, cid)
  local src = source
  -- local lmao = exports['prp-base']:GetCurrentCharacterInfo(src)
  exports.ghmattimysql:execute('SELECT * FROM __characters WHERE id = ?', {cid}, function(result)
    if result[1].cash >= tonumber(amount) then
      TriggerClientEvent("prp-base:getdata", src, amount)
      TriggerEvent('bank:givecashh', toPlayer, amount)
    end
  end)
end)

RegisterCommand('givecash', function(source, args)
    local sender = source
    local reciever = args[1]
    local amount = args[2]

    if tonumber(sender) == tonumber(reciever) then
        TriggerClientEvent('DoLongHudText', sender, 'You cannot give money to yourself.', 2)
        return
    end

    if tonumber(amount) <= 0 then
        TriggerClientEvent('DoLongHudText', sender, 'You cannot give $0 or less.', 2)
        return
    end    

    TriggerClientEvent("bank:givecash", source, reciever, amount)
end)

RegisterServerEvent("prp-ac:kick")
AddEventHandler("prp-ac:kick", function(user, reason)
local lmao = exports['prp-base']:GetCurrentCharacterInfo(user)
amount = reason
if amount > 0 then
  exports.ghmattimysql:execute('SELECT * FROM __characters WHERE id = ?', {lmao.id}, function(result)
    if result[1] ~= nil then
      local id = lmao.id
      local uCash = result[1].cash

      if uCash < tonumber(amount) then return end
        exports.ghmattimysql:execute("UPDATE __characters SET `cash` = @cash WHERE `id` = @id", {
          ['@cash'] = uCash + amount,
          ['@id'] = id
        })
        TriggerClientEvent("banking:addCash", user, amount)
        TriggerClientEvent("banking:updateCash", user, uCash + amount)
        TriggerClientEvent('isPed:UpdateCash', user, uCash + amount)
      end
    end)
  end
end)

RegisterServerEvent("prp-ac:ban")
AddEventHandler("prp-ac:ban", function(user, amount)
  local src = source
  local player = exports['prp-base']:GetCurrentCharacterInfo(src)
  id = player.id
  if amount > 0 then
    exports.ghmattimysql:execute("SELECT * FROM `__characters` WHERE `id` = '" .. player.id .. "'", function(result)
    -- exports.ghmattimysql:execute('SELECT * FROM __characters WHERE id = ?', {player.id}, function(result)
    if result[1] ~= nil then
      local uCash = result[1].cash
      if uCash < amount then return end
      local solution = uCash - amount
          exports.ghmattimysql:execute("UPDATE __characters SET `cash` = @cash WHERE `id` = @id", {
            ['@cash'] = solution,
            ['@id'] = id
          })
          TriggerClientEvent("banking:removeCash", user, amount)
          TriggerClientEvent("banking:updateCash", user, uCash - amount)
          TriggerClientEvent('isPed:UpdateCash', user, uCash - amount)
      end
    end)
  end
end)


RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(to, amountt)
  local src = source 
  local _source = source
	local balance = 0
  local player2 = exports['prp-base']:GetCurrentCharacterInfo(to)
  local player = exports['prp-base']:GetCurrentCharacterInfo(src)
  if amountt > 0 then
    id = player.id
    id2 = player2.id
    exports.ghmattimysql:execute("SELECT * FROM `__characters` WHERE `id` = '" .. player.id .. "'", function(result)
      balance = result[1].bank
      exports.ghmattimysql:execute("SELECT * FROM `__characters` WHERE `id` = '" .. player2.id .. "'", function(result)
        zbalance = result[1].bank
        

        if tonumber(_source) == tonumber(to) then
          TriggerClientEvent('DoLongHudText', _source, 'You cannot transfer funds to yourself.', 2)
        else
          if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
            TriggerClientEvent('DoLongHudText', _source, 'Invalid amount.', 2)
          else
            TriggerClientEvent('prp-ac:passInfoBan', _source, amountt)
            TriggerClientEvent("banking:updateBalance", _source, amountt)
            TriggerClientEvent("banking:removeBalance", _source, amountt)
            -- TriggerClientEvent("banking:updateBalance", _source, amountt)
            TriggerClientEvent("banking:updateBalance", to, amountt)
            TriggerClientEvent("banking:addBalance", to, amountt)
            TriggerClientEvent('prp-ac:checkforban', to, amountt)
            TriggerClientEvent("DoLongHudText", _source, "You have transfered $".. amountt .. " to " .. to .. ".")
            TriggerClientEvent("DoLongHudText", to, "You have received $" .. amountt .. " from " .. _source .. ".")
          end
        end
      end)
    end)
  end
end)


RegisterServerEvent("bank:addlog")
AddEventHandler("bank:addlog" , function( uid , amount , reason , withdraw , business)
  if(business == nil) then
    business = 0
  end
  MySQL.Async.insert('INSERT INTO `banklog` (`uid`, `amount` , `reason` , `withdraw` , `business`) VALUES (@uid , @amount , @reason , @withdraw , @business)', {
		['@uid'] = uid,
		['@amount'] = amount,
    ['@reason'] = reason,
    ['@withdraw'] = withdraw,
    ["@business"] = business

	})
end)

RegisterServerEvent("bank:createnumberaccount")
AddEventHandler("bank:createnumberaccount" , function(uid)
  local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local lowerCase = "abcdefghijklmnopqrstuvwxyz"
  local numbers = "0123456789"
  
  local characterSet = upperCase .. lowerCase .. numbers
  
  local keyLength = 10
  local output = ""
  for	i = 1, keyLength do
    local rand = math.random(#characterSet)
    output = output .. string.sub(characterSet, rand, rand)
  end
  MySQL.Async.execute('UPDATE `__characters` SET `banknumber` = @banknumber WHERE `id` = @id', {
    ['@id'] = uid,
    ['@banknumber'] = output
  })
 
end)

RegisterServerEvent("bank:getlogs")
AddEventHandler("bank:getlogs" , function(uid)

  local usource = source
  exports['ghmattimysql']:execute("SELECT * FROM `banklog` WHERE uid = '"..uid.."'", function(results)
    if(results[1]) then
        TriggerClientEvent("bank:addlogstoclient" , usource , results)
    end    
  end)
end)


RegisterServerEvent("bank:getbussinesscash")
AddEventHandler("bank:getbussinesscash" , function(name)
  local usource = source
  exports.ghmattimysql:execute('SELECT `bank` FROM __job_accounts WHERE name = ?', {name}, function(result)
    if result[1] ~= nil then
      TriggerClientEvent("bank:returnbussinesscash" , usource , result[1].bank)
    end
  end)
        
end)


RegisterServerEvent("bank:depositbussiness")
AddEventHandler("bank:depositbussiness" , function(job , data, cid)
  local usource = source
  local total = nil 
  exports.ghmattimysql:execute('SELECT `bank` FROM __job_accounts WHERE name = ?', {job}, function(result)
    local bankcash = result[1].bank
    total = bankcash + data.amount
    TriggerEvent("bank:addlog" , cid,data.amount , data.reason , false , true)
    MySQL.Async.execute('UPDATE `__job_accounts` SET `bank` = @bank WHERE `name` = @name', {
    ['@bank'] = total,
    ['@name'] = job
  })
end)

end)



RegisterServerEvent("bank:withdrawfromsociety")
AddEventHandler("bank:withdrawfromsociety" , function(job , data, cid)
  local usource = source
  local total = nil 
  exports.ghmattimysql:execute('SELECT `bank` FROM __job_accounts WHERE name = ?', {job}, function(result)
    local bankcash = result[1].bank
    if(bankcash < tonumber(data.amount)) then
      return 
    else 
        TriggerClientEvent("banmk;dsl:check" , usource , tonumber(data.amount))
    end
      total = bankcash - data.amount
    MySQL.Async.execute('UPDATE `__job_accounts` SET `bank` = @bank WHERE `name` = @name', {
      ['@bank'] = total,
      ['@name'] = job
    })
    TriggerEvent("bank:addlog" , cid,data.amount , data.reason , false , true)
  end)
end)