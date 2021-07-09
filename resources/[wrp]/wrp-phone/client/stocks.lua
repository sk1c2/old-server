local serverstockvalues = {
  [1] = { ["name"] = "UCoin", ["value"] = 0.0, ["identifier"] = "CRYPIX", ["lastchange"] = 0.00, ["amountavailable"] = 0.0 },
  [2] = { ["name"] = "Ammunation", ["value"] = 1000.0, ["identifier"] = "STRAMM", ["lastchange"] = 0.00, ["amountavailable"] = 100.0 },
  [3] = { ["name"] = "LS Customs", ["value"] = 1000.0, ["identifier"] = "STRLSC", ["lastchange"] = 0.00, ["amountavailable"] = 100.0 },
  [4] = { ["name"] = "7/11", ["value"] = 1000.0, ["identifier"] = "STR711", ["lastchange"] = 0.00, ["amountavailable"] = 100.0 },
  [5] = { ["name"] = "Bank of America", ["value"] = 1000.0, ["identifier"] = "STRBOA", ["lastchange"] = 0.00, ["amountavailable"] = 100.0 },
  [6] = { ["name"] = "Clothing LS", ["value"] = 1000.0, ["identifier"] = "STRCLS", ["lastchange"] = 0.00, ["amountavailable"] = 100.0 },
}

clientstockamount = {
  [1] = { ["value"] = 5.00 },
  [2] = { ["value"] = 0.00 },
  [3] = { ["value"] = 0.00 },
  [4] = { ["value"] = 0.00 },
  [5] = { ["value"] = 0.00 },
  [6] = { ["value"] = 0.00 },
}
firstOpened = false

uneriumstockamount = 0.00

RegisterNetEvent('Crypto:GiveUnerium')
AddEventHandler('Crypto:GiveUnerium', function(amount)
  uneriumstockamount = uneriumstockamount + amount
  Citizen.Trace('Retreived Crypto')
  updateServerClientStocks(false)
  TriggerEvent("chatMessage", "EMAIL ", 2, "You have gained " .. amount .."  Ucoin!")
  TriggerServerEvent('pixadd', amount)
end)

RegisterNetEvent("Crypto:RemoveUnerium")
AddEventHandler("Crypto:RemoveUnerium", function(amount)
  uneriumstockamount = uneriumstockamount - amount
  removeServerClientStocks(false)
  Citizen.Trace("Lost crypto")
  TriggerEvent("chatMessage", "EMAIL ", 3, "You have lost " .. amount .."  Ucoin!")
  TriggerServerEvent('pixremove', amount)
  -- TriggerEvent('customNotification', 'You have lost ' .. amount .. ' Ucoin')
end)

RegisterNetEvent('stocks:payupdate');
AddEventHandler('stocks:payupdate', function()
  local payamount = 0
  for i = 2, #clientstockamount do
    local mystock = clientstockamount[i]["value"]
    if mystock > 0 then
      local currentlyPaying = serverstockvalues[i]["value"] / 200
      local totalpay = (currentlyPaying * mystock) / 100
      local mypayout = math.ceil(totalpay * 100)
      local haslost = 0.0
      payamount = payamount + mypayout
      if serverstockvalues[i]["value"] < 1000.0 then
        if mystock > 3 then
          if math.random(100) > 90 then
            local stockloss =  math.ceil(((mystock / 100) / 3) * 100) / 100
            clientstockamount[i]["value"] = mystock - stockloss
            TriggerServerEvent("stocks:bleedstocks",i,stockloss)
            haslost = haslost - stockloss
          end
        end
        if mystock > 20 then
          if math.random(100) > 90 then
            local stockloss =  math.ceil(((mystock / 100) / 3) * 100) / 100
            clientstockamount[i]["value"] = mystock - stockloss
            TriggerServerEvent("stocks:bleedstocks",i,stockloss)
            haslost = haslost - stockloss
          end
        end
      end
      if haslost < 0 then
        TriggerEvent("DoLongHudText", "Interest pay out of $" .. mypayout .. " for stock ID " .. serverstockvalues[i]["identifier"] .. ". The company also cut your shares by " .. haslost .. " to increase profits. ")
      else
        TriggerEvent("DoLongHudText", "Interest pay out of $" .. mypayout .. " for stock ID " .. serverstockvalues[i]["identifier"])
      end
    end
  end
  payamount = math.floor(payamount)
  if payamount > 0 then
    TriggerServerEvent("server:givepayJob", "Stock Payment", payamount)
  end
end)

RegisterNetEvent('stocks:servervalueupdate');
AddEventHandler('stocks:servervalueupdate', function(sentvalues)
    serverstockvalues = sentvalues
end)

RegisterNetEvent('stocks:clientvalueupdate');
AddEventHandler('stocks:clientvalueupdate', function(sentvalues)
    uneriumstockamount = sentvalues
end)

RegisterNetEvent('stocks:jailed');
AddEventHandler('stocks:jailed', function()
    for i=2,#clientstockamount do
      if clientstockamount[i]["value"] > 1.0 then
        local loss = math.floor((clientstockamount[i]["value"] / 20) * 100) / 100
        TriggerServerEvent("stocks:reducestock",i,loss)
      end
    end
end)

RegisterNetEvent('stocks:retrieve')
AddEventHandler('stocks:retrieve', function(cid)
  TriggerServerEvent('stocks:retrieve', cid)
end)

RegisterNetEvent('stocks:newstocks');
AddEventHandler('stocks:newstocks', function(amountBuying,identifier)
  uneriumstockamount = uneriumstockamount - amountBuying
  updateServerClientStocks()
end)

RegisterNetEvent('stocks:losestocks');
AddEventHandler('stocks:losestocks', function(amountBuying,identifier)
  clientstockamount[identifier] = clientstockamount[identifier] - amountBuying
  updateServerClientStocks()
end)

function updateServerClientStocks(isupdate)
    TriggerServerEvent("stocks:clientvalueupdate",exports['isPed']:isPed('cid'), isupdate, uneriumstockamount)
end

function removeServerClientStocks(isupdate)
  TriggerServerEvent("stocks:clientvalueremove",exports['isPed']:isPed('cid'), isupdate, uneriumstockamount)
end

RegisterNetEvent('unerium:checkrobbery:decrypt1')
AddEventHandler('unerium:checkrobbery:decrypt1', function()

  if uneriumstockamount >= 3 then
    uneriumstockamount = uneriumstockamount - 3
    updateServerClientStocks(false)
    TriggerServerEvent('robbery:decrypt')
  else
    TriggerEvent("chatMessage", "EMAIL ", 8, "You need " .. costs .."  Unerium!")
  end
end)

RegisterNetEvent('unerium:checkrobbery:decrypt2')
AddEventHandler('unerium:checkrobbery:decrypt2', function()

  if uneriumstockamount >= 3 then
    uneriumstockamount = uneriumstockamount - 3
    updateServerClientStocks(false)
    TriggerServerEvent('robbery:decrypt2')
  else
    TriggerEvent("chatMessage", "EMAIL ", 8, "You need " .. costs .."  Unerium!")
  end
end)

RegisterNetEvent('unerium:checkrobbery:decrypt3')
AddEventHandler('unerium:checkrobbery:decrypt3', function()

  if uneriumstockamount >= 3 then
    uneriumstockamount = uneriumstockamount - 3
    updateServerClientStocks(false)
    TriggerServerEvent('robbery:decrypt3')
  else
    TriggerEvent("chatMessage", "EMAIL ", 8, "You need " .. costs .."  Unerium!")
  end
end)

RegisterNetEvent('pixerium:check');
AddEventHandler('pixerium:check', function(costs,functionCall,server)

  if uneriumstockamount >= costs then
    uneriumstockamount = uneriumstockamount - costs
    updateServerClientStocks()
    if server then
      TriggerServerEvent(functionCall)
    else
      TriggerEvent(functionCall)
    end    
  else
    TriggerEvent("chatMessage", "EMAIL ", 8, "You need " .. costs .."  Unerium!")
  end

end)





RegisterNetEvent('stocks:buyitem');
AddEventHandler('stocks:buyitem', function(typeSent)
  local costs = 15

  if typeSent == "weapon" then
    costs = 5
  end

  if typeSent == "bigweapon" then
    costs = 25
  end

  if typeSent == "crack" then
    costs = 10
  end 

  if clientstockamount[1]["value"] >= costs then
    clientstockamount[1]["value"] = clientstockamount[1]["value"] - costs
    updateServerClientStocks()
    TriggerEvent("stocks:timedEvent",typeSent)   
  else
    TriggerEvent("chatMessage", "EMAIL ", 8, "You need 25 pixerium for big guns or 5 for small, come back when you have it, Pepega.")
    print("not enough crypto")
  end

end)

RegisterNUICallback('stocksTradeToPlayer', function(data, cb)
  local index = 0
  local amount = 0
  local sending = math.ceil(tonumber(data.amount) * 100) / 100
  for i=1,#serverstockvalues do
    if data.identifier == serverstockvalues[i]["identifier"] then
      index = i
      amount = uneriumstockamount
    end
  end
  if index == 0 then
    -- not enough to do the trade
    TriggerEvent("DoLongHudText","Incorrect Identifier.",2)
    TriggerEvent("stocks:refreshstocks")
    return
  end
  if amount < tonumber(data.amount) then
    -- not enough to do the trade
    TriggerEvent("DoLongHudText","Not enough stock.",2)
    TriggerEvent("stocks:refreshstocks")
    return
  end
  uneriumstockamount = uneriumstockamount - sending
  Citizen.Trace("removing " .. sending .. " shares from index " .. index )
  TriggerServerEvent('phone:stockTradeAttempt', index, data.playerid, sending, data.playertarget)
  Citizen.Wait(500)
  local stocksData = {}
  for i = 1, #serverstockvalues do
    table.insert(stocksData, {
      identifier = serverstockvalues[i]["identifier"],
      name = serverstockvalues[i]["name"],
      value = serverstockvalues[i]["value"],
      change = serverstockvalues[i]["lastchange"],
      available = serverstockvalues[i]["amountavailable"],
      clientStockValue = uneriumstockamount
    })
    SendNUIMessage({ openSection = "addStocks", stocksData = stocksData})
    updateServerClientStocks(false)
  end

end)

RegisterNetEvent('stocks:refreshstocks');
AddEventHandler('stocks:refreshstocks', function()
    --[[for i = 1, #serverstockvalues do
      local colortype = 1
      if i == 1 or i == 3 or i == 5 then
        colortype = 2
      end
      local lastchangestock = "<div class='change stockred'>▼" .. serverstockvalues[i]["lastchange"] .. "</div>"
      if serverstockvalues[i]["lastchange"] > -0.01 then
        lastchangestock = "<div class='change stockgreen'>▲" .. serverstockvalues[i]["lastchange"] .. "</div>"
      end 

      SendNUIMessage({
        openSection = "addstock",
        namesent = serverstockvalues[i]["name"],
        identifier = serverstockvalues[i]["identifier"],
        lastchange = lastchangestock,
        valuesent = serverstockvalues[i]["value"],
        amountsold = serverstockvalues[i]["amountsold"],
        clientstock = clientstockamount[i]["value"],
        colorsent = colortype,
        available = serverstockvalues[i]["amountavailable"]
      })
    end--]]
    sendStocksToPhone(true);
end)

function sendStocksToPhone(isRefresh)
  local stocksData = {}
  for i = 1, #serverstockvalues do
    table.insert(stocksData, {
      identifier = serverstockvalues[i]["identifier"],
      name = serverstockvalues[i]["name"],
      value = serverstockvalues[i]["value"],
      change = serverstockvalues[i]["lastchange"],
      available = serverstockvalues[i]["amountavailable"],
      clientStockValue = uneriumstockamount
    })
  end

  SendNUIMessage({ openSection = "addStocks", stocksData = stocksData})
  if isRefresh then
    updateServerClientStocks(true)
  end
end

RegisterNUICallback('btnStocks', function()
  --[[
    for i = 1, #serverstockvalues do
      local colortype = 1
      if i == 1 or i == 3 or i == 5 then
        colortype = 2
      end
      local lastchangestock = "<div class='change stockred'>▼" .. serverstockvalues[i]["lastchange"] .. "</div>"
      if serverstockvalues[i]["lastchange"] > -0.01 then
        lastchangestock = "<div class='change stockgreen'>▲" .. serverstockvalues[i]["lastchange"] .. "</div>"
      end 

      SendNUIMessage({
        openSection = "addstock",
        namesent = serverstockvalues[i]["name"],
        identifier = serverstockvalues[i]["identifier"],
        lastchange = lastchangestock,
        valuesent = serverstockvalues[i]["value"],
        amountsold = serverstockvalues[i]["amountsold"],
        clientstock = clientstockamount[i]["value"],
        colorsent = colortype,
        available = serverstockvalues[i]["amountavailable"]
      })
    end--]]
    if firstOpened == false then
      sendStocksToPhone(true);
      TriggerEvent('DoLongHudText', "Gathering info, please re-open stocks.")
      firstOpened = true
    else
      sendStocksToPhone(true);
    end
end)

function requestUpdate()
  TriggerServerEvent("stocks:retrieve")
end
