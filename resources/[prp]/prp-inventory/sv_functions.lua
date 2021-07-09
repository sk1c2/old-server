Citizen.CreateThread(function()
    Citizen.Wait(2000)
    print('[prp-inventory]: Authorized.')
end)

RegisterServerEvent('server-inventory-request-identifier')
AddEventHandler('server-inventory-request-identifier', function()
    local src = source
    TriggerClientEvent('inventory-client-identifier', src)
end)

RegisterServerEvent('prp-inventory:openInventorySteal')
AddEventHandler('prp-inventory:openInventorySteal', function(target)
    local src = source
    -- print(source)
    if target ~= nil then
        local steam = GetPlayerIdentifiers(target)[1]
        local userData = promise:new()

        exports.ghmattimysql:execute('SELECT uid FROM __users WHERE steam = ?', {steam}, function(data)
            userData:resolve(data)
        end)

        local uid = Citizen.Await(userData)
        local user = exports['prp-base']:getModule("Player")
        local char = user:getCurrentCharacter(uid[1].uid)
        TriggerClientEvent('prp-inventory:openInventorySteal', src, char)
        TriggerClientEvent('DoLongHudText', src, 'You\'re being searched')
        exports.ghmattimysql:execute('SELECT `cash` FROM __characters WHERE id = ?', {char.id}, function(data)
            TriggerClientEvent('prp-ac:removeban', target, data[1].cash)
            Citizen.Wait(100)
            TriggerClientEvent('prp-ac:InfoPass', src, data[1].cash)
        end)
    end
end)

RegisterServerEvent('prp-inventory:openInventorySteal2')
AddEventHandler('prp-inventory:openInventorySteal2', function(target)
    local source = source
    -- print(source)
    if target ~= nil then
        -- print(target)
        local steam = GetPlayerIdentifiers(target)[1]
        local userData = promise:new()

        exports.ghmattimysql:execute('SELECT uid FROM __users WHERE steam = ?', {steam}, function(data)
            userData:resolve(data)
        end)

        local uid = Citizen.Await(userData)
        local user = exports['prp-base']:getModule("Player")
        local char = user:getCurrentCharacter(uid[1].uid)
--        print(json.encode(char)) 
        TriggerClientEvent('prp-inventory:openInventorySteal', src, char)
        TriggerClientEvent('DoLongHudText', target, 'You\'re being searched')
    end
end)

RegisterServerEvent('prp-inventory:openInventorySteal3')
AddEventHandler('prp-inventory:openInventorySteal3', function(target)
    local src = source
    -- print(source)
    if target ~= nil then
        -- print(target)
        local steam = GetPlayerIdentifiers(target)[1]
        local userData = promise:new()

        exports.ghmattimysql:execute('SELECT uid FROM __users WHERE steam = ?', {steam}, function(data)
            userData:resolve(data)
        end)

        local uid = Citizen.Await(userData)
        local user = exports['prp-base']:getModule("Player")
        local char = user:getCurrentCharacter(uid[1].uid)
--        print(json.encode(char)) 
        TriggerClientEvent('prp-inventory:openInventorySteal', src, char)
    end
end)

RegisterServerEvent('loot:useItem')
AddEventHandler('loot:useItem', function(itemid)
    TriggerClientEvent('prp-banned:getID', source, '-771403250', math.random(6,8))
end)

RegisterServerEvent('loot:redpack')
AddEventHandler('loot:redpack', function(itemid)
    TriggerClientEvent('prp-banned:getID', source, 'ciggy', 10)
end)

RegisterServerEvent('idcard:run')
AddEventHandler('idcard:run', function(data)
    local data = json.decode(data)
    local firstname = data.Name
    local lastname = data.Surname
    local sex = data.Sex
    local dob = data.DOB
    local Identifier = data.Identifier
    local src = source
    local myPed = GetPlayerPed(src)
    local sourcePlayer = tonumber(source)
    local players = GetPlayers()
    local myPos = GetEntityCoords(myPed)
    if firstname ~= nil and lastname ~= nil and sex ~= nil and dob ~= nil then
        TriggerClientEvent('chat:addMessage', source, {
            color = 9,
            multiline = false,
            templateId = "defaultAlt",
            args = {DOB = dob, Name = firstname, Surname = lastname, Sex = sex, Identifier = Identifier, pref = "None"}
        })
    end
    for k, v in ipairs(players) do
        if v ~= src then
            local xTarget = GetPlayerPed(v)
            local tPos = GetEntityCoords(xTarget)
            local dist = #(vector3(tPos.x, tPos.y, tPos.z) - myPos)
            if dist < 2 then 
                if firstname ~= nil and lastname ~= nil and sex ~= nil and dob ~= nil then
                    TriggerClientEvent('chat:addMessage', v, {
                        color = 9,
                        multiline = false,
                        templateId = "defaultAlt",
                        args = {DOB = dob, Name = firstname, Surname = lastname, Sex = sex, Identifier = Identifier, pref = "None"}
                    })
                end
            end
        end
    end
end)

function sendToDiscord(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Developed with ❤️ by Breasty and Leggy",
              },
          }
      }
    PerformHttpRequest('https://discord.com/api/webhooks/842048960713457664/HFhDD-se8I0TTzJyihN068_QLM7GQ2Wn9PcSOQyqwL_o8AjvQZw2A6GFfKWAqTNE1VyP', function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end

  function sendToDiscord2(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Developed with ❤️ by Breasty and Leggy",
              },
          }
      }
    PerformHttpRequest('https://discord.com/api/webhooks/808807726088060928/Kr8Y5i0_8VmfL4wL0I7lieXKAOfYVe7vcP27Aa8nqYtVnjLOUVsKbHByrXfUU9PR7tIv', function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end

  function sendToDiscord3(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Developed with ❤️ by Breasty and Leggy",
              },
          }
      }
    PerformHttpRequest('https://discord.com/api/webhooks/811585639996194867/qTMu17AZTvSgfJX-j8_fNn-zJOy7_0ovjYeC4yC14s3gPaKc3tLw1kymXpdacHszNdxH', function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end

  function sendToDiscord4(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Developed with ❤️ by Breasty and Leggy",
              },
          }
      }
    PerformHttpRequest('https://discord.com/api/webhooks/812728373050474527/Z-BlTTKTyhaYxr9oSNXQp3OSq_B-rjiS8DEj9LmsrrX23A8Fgg2DLgmReCdSgiP85QS7', function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end

  function sendToDiscord5(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Developed with ❤️ by Breasty and Leggy",
              },
          }
      }
    PerformHttpRequest('https://discord.com/api/webhooks/813011573541961730/tt9bQl5_4hJeZanf1dPsQOnedot3WD834-ZzCQ4KJuZjQT6x3spt0fJJKm8ihWfM8q01', function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end

  function sendToDiscord6(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Developed with ❤️ by Breasty and Leggy",
              },
          }
      }
    PerformHttpRequest('https://discord.com/api/webhooks/814050271923404810/JePrG92ULkoq1SFRRz6gI_DT9bQpCBeom682qooSaIGgASunucgdnmkOdxENLPsbwyoS', function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end

  function sendToDiscord7(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Developed with ❤️ by Keiron",
              },
          }
      }
    PerformHttpRequest('https://discord.com/api/webhooks/810646986034380810/3Htzcy0v-w5ZETmOiewsREtHppmrX43EqFjZxbnjlLReDsFyI897oT4Kf34HxqQOje2V', function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end

  function sendToDiscord8(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Developed with ❤️ by Keiron",
              },
          }
      }
    PerformHttpRequest('https://discord.com/api/webhooks/824366073536315423/lLQPSyFj9EVoBDYn3xNDHpUbYPPUhgx0ah-FbMo2D_wYL6xlqzI89gXEJlvOkNH_0A2g', function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end

  function sendToDiscord9(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Developed with ❤️ by Keiron",
              },
          }
      }
    PerformHttpRequest('https://discord.com/api/webhooks/841689127899627590/9WxzLcb4L3Gdj7ATqd1YsSeu1z9lhdzsMNcphlDMlGgFwE53B72vn6QG0Z-hodYt9liT', function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end

  function sendToDiscord11(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Developed with ❤️ by Keiron",
              },
          }
      }
    PerformHttpRequest('https://discord.com/api/webhooks/849346215098712125/zMcOzes0zSV5qLtt1_cJCjTlomGGDCBZgxRd1dQ8Z77UrI-GafaKxEezL1BhJ8DVK8y2', function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end



RegisterServerEvent('prp-inventory:logItem')
AddEventHandler('prp-inventory:logItem', function(itemdata, amount)
    sendToDiscord("Item Received", "**" .. GetPlayerName(source) .. "** has received an item. \n\n**Item ID : **" .. itemdata .. " \n\n**Amount : **" .. amount, 65280)
end)

RegisterServerEvent('prp-inventory:logInventoryOpen')
AddEventHandler('prp-inventory:logInventoryOpen', function(cid, target, name)
    sendToDiscord11("Inventory Opened", "**" .. GetPlayerName(source) .. "** with cid: ".. cid.. " has opened an inventory. \n\n**Name : **" .. name .. " \n\n**Target : **" .. target, 65280)
end)

RegisterServerEvent('prp-inventory:logCash')
AddEventHandler('prp-inventory:logCash', function(cash)
    sendToDiscord2("Cash Received", "**" .. GetPlayerName(source) .. "** has received cash (GLOBALLY). \n\n**Cash : $**" .. cash, 65280)
end)

RegisterServerEvent('prp-inventoryLog')
AddEventHandler('prp-inventoryLog', function(cash)
    sendToDiscord3("Opened Players Inventory", "**" .. GetPlayerName(source) .. "** has opened an inventory through admin menu. \n\n**Inventory Opened : **" .. cash, 65280)
end)

RegisterServerEvent('prp-DeleteGunLog')
AddEventHandler('prp-DeleteGunLog', function(cash)
    sendToDiscord3("Enabled Delete Gun", "**" .. GetPlayerName(source) .. "** enabled the delete gun through admin menu. \n\n**Delete Gun Enabled : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('prp-NoReloadLog')
AddEventHandler('prp-NoReloadLog', function(cash)
    sendToDiscord3("Enabled No Reload", "**" .. GetPlayerName(source) .. "** enabled no reload through admin menu. \n\n**No Reload Enabled : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('prp-InfLog')
AddEventHandler('prp-InfLog', function(cash)
    sendToDiscord3("Enabled Infinite Ammo", "**" .. GetPlayerName(source) .. "** enabled infinite ammo through admin menu. \n\n**Infinite Ammo Enabled : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('prp-speclog')
AddEventHandler('prp-speclog', function(cash)
    sendToDiscord3("Started Spectating Player", "**" .. GetPlayerName(source) .. "** is spectating player through admin menu. \n\n**Spectating Player : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('prp-swatlog')
AddEventHandler('prp-swatlog', function(cash)
    sendToDiscord3("Enabled Swat on Everyone", "**" .. GetPlayerName(source) .. "** enabled spawn swat on everyone through admin menu. \n\n**Swat on Everyone : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('prp-vehspeedboost')
AddEventHandler('prp-vehspeedboost', function(cash)
    sendToDiscord3("Enabled Vehicle Speed Boost", "**" .. GetPlayerName(source) .. "** enabled vehicle speed boost through admin menu. \n\n**Enabled Vehicle Speed Boost : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('prp-explosivepunch')
AddEventHandler('prp-explosivepunch', function(cash)
    sendToDiscord3("Enabled Explosive Punch", "**" .. GetPlayerName(source) .. "** enabled explosive punch through admin menu. \n\n**Enabled Explosive Punch : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('superjumplog')
AddEventHandler('superjumplog', function(cash)
    sendToDiscord3("Enabled Super Jump", "**" .. GetPlayerName(source) .. "** enabled super jump through admin menu. \n\n**Enabled Super Jump : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('superrunlog')
AddEventHandler('superrunlog', function(cash)
    sendToDiscord3("Enabled Super Run", "**" .. GetPlayerName(source) .. "** enabled super run through admin menu. \n\n**Enabled Super Run : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('aimbotlog')
AddEventHandler('aimbotlog', function(cash)
    sendToDiscord3("Enabled Aimbot", "**" .. GetPlayerName(source) .. "** enabled aimbot through admin menu. \n\n**Enabled Aimbot : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('explosiveshotlog')
AddEventHandler('explosiveshotlog', function(cash)
    sendToDiscord3("Enabled Explosive Shot", "**" .. GetPlayerName(source) .. "** enabled explosive shot through admin menu. \n\n**Enabled Explosive Shot : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('weapondmglog')
AddEventHandler('weapondmglog', function(cash)
    sendToDiscord3("Enabled 2x Weapon Damage", "**" .. GetPlayerName(source) .. "** enabled 2x weapon damage through admin menu. \n\n**Enabled 2x Weapon Damage : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('godmodelog')
AddEventHandler('godmodelog', function(cash)
    sendToDiscord3("Enabled Godmode", "**" .. GetPlayerName(source) .. "** enabled godmode through the admin menu. \n\n**Enabled Godmode : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('demigodlog')
AddEventHandler('demigodlog', function(cash)
    sendToDiscord3("Enabled Demi-Godmode", "**" .. GetPlayerName(source) .. "** enabled demi-godmode through the admin menu. \n\n**Enabled Demi-Godmode : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('oxylog')
AddEventHandler('oxylog', function(cash)
    sendToDiscord3("Entered / Exited Oxy", "**" .. GetPlayerName(source) .. "** Entered / Exited Oxy Building. \n\n**Entered / Exited Oxy Building : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('removelog')
AddEventHandler('removelog', function(itemdata, amount)
    sendToDiscord4("Item Removed", "**" .. GetPlayerName(source) .. "** has removed an item. \n\n**Item ID : **" .. itemdata .. " \n\n**Amount : **" .. amount, 65280)
end)

RegisterServerEvent('pixremove')
AddEventHandler('pixremove', function(amount)
    sendToDiscord5("U-Coin Removed", "**" .. GetPlayerName(source) .. "** has lost U-Coin. \n\n**Amount : **" .. amount, 65280)
end)

RegisterServerEvent('pixadd')
AddEventHandler('pixadd', function(amount)
    sendToDiscord5("U-Coin Added", "**" .. GetPlayerName(source) .. "** has gained U-Coin. \n\n**Amount : **" .. amount, 65280)
end)

RegisterServerEvent('prp-weed:Use-Water')
AddEventHandler('prp-weed:Use-Water', function(amount)
    sendToDiscord6("Plant Water", "**" .. GetPlayerName(source) .. "** has gave a plant water. \n\n**Player : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('prp-weed:Use-Fertiliser')
AddEventHandler('prp-weed:Use-Fertiliser', function(amount)
    sendToDiscord6("Plant Fertiliser", "**" .. GetPlayerName(source) .. "** has gave a plant fertiliser. \n\n**Player : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('prp-meth:pass')
AddEventHandler('prp-meth:pass', function(cash)
    sendToDiscord3("Knocked on Meth Door", "**" .. GetPlayerName(source) .. "** Knocked on the Meth Door. \n\n**Knocked on the Meth Door : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('prp-meth:pseudo')
AddEventHandler('prp-meth:pseudo', function(amount)
    sendToDiscord3("Dumped Pseudophedrine", "**" .. GetPlayerName(source) .. "** Dumped Pseudophedrine. \n\n**Dumped Pseudophedrine Amount: **" .. amount, 65280)
end)

RegisterServerEvent('prp-meth:hintObtain')
AddEventHandler('prp-meth:hintObtain', function(amount)
    sendToDiscord3("Found and Obtained the Hint", "**" .. GetPlayerName(source) .. "** Found and Obtained the Hint. \n\n**Found and Obtained the Hint: **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('prp-business:log')
AddEventHandler('prp-business:log', function(amount, total, job)
    sendToDiscord7('Business Name: ' ..job.. ' \nGained: $' ..amount.. " and now have a total of: $" ..total)
end)

RegisterServerEvent('prp-business:logr')
AddEventHandler('prp-business:logr', function(amount, total, job)
    sendToDiscord7('Business Name: ' ..job.. ' \nLost: $' ..amount.. " and now have a total of: $" ..total)
end) -- sendToDiscord8

RegisterServerEvent('prp-mine:autoclicker')
AddEventHandler('prp-mine:autoclicker', function()
    local src = source
    sendToDiscord9("Player:", "**" .. GetPlayerName(source) .. "** Is Either Using an Autoclicker or is Spamming Left Click At Mining. \n\n**Does not mean ban / just spectate / watch - if is autoclicking please punish : **" .. GetPlayerName(source), 65280)
end)

RegisterServerEvent('prp-pedLog:logAllInfo')
AddEventHandler('prp-pedLog:logAllInfo', function(fullname, cid, model, hairColor, headBlend, headOverlay, headStructure)
    local src = source
    local hairColor = json.encode(hairColor)
    local headBlend = json.encode(headBlend)
    local headOverlay = json.encode(headOverlay)
    local headStructure = json.encode(headStructure)
    sendToDiscord8('Steam Name: ' ..GetPlayerName(src).. ' \nPlayer Name: ' ..fullname.. " \nCID: " ..cid.. ' \nHead Model: ' ..headBlend)
    sendToDiscord8(' Hair Color: ' ..hairColor.. ' \nModel: ' ..model)
end)
