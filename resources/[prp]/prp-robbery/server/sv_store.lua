safeLocations = {
    [1] = {x = 1959.2476806641, y = 3748.8317871094, z = 32.343784332275, h = 28.119842529297, robbed = false},
    [2] = {x = 546.35992431641, y = 2662.9340820312, z = 42.156490325928, h = 190.7907409668, robbed = false},
    [3] = {x = 2549.2868652344, y = 384.92218017578, z = 108.62294769287, h = 79.970840454102, robbed = false},
    [4] = {x = -1829.0267333984, y = 798.95819091797, z = 138.18653869629, h = 130.54249572754, robbed = false},
    [5] = {x = -709.6171875, y = -904.21710205078, z = 19.215591430664, h = 84.96849822998, robbed = false},
    [6] = {x = 28.248321533203, y = -1339.2667236328, z = 29.497024536133, h = 358.12371826172, robbed = false},
    [7] = {x = -43.278358459473, y = -1748.4860839844, z = 29.421016693115, h = 46.865802764893, robbed = false},
    [8] = {x = 378.19577026367, y = 333.39080810547, z = 103.56645202637, h = 341.65612792969, robbed = false},
    [9] = {x = 1734.8654785156, y = 6420.84765625, z = 35.037273406982, h = 332.01058959961, robbed = false},
    [10] = {x = 1707.8552246094, y = 4920.3173828125, z = 42.063632965088, h = 319.1520690918, robbed = false}
}

storeLocations = {
    [1] = {x = 1959.8237304688, y = 3740.5344238281, z = 32.343746185303, h = 301.94995117188, recent = false, registers = {}},
    [2] = {x = 549.17236328125, y = 2671.0297851562, z = 42.156532287598, h = 98.538436889648, recent = false, registers = {}},
    [3] = {x = 2556.6574707031, y = 380.72537231445, z = 108.62294769287, h = 1.8275666236877, recent = false, registers = {}},
    [4] = {x = -1819.5952148438, y = 793.84417724609, z = 138.08393859863, h = 131.23713684082, recent = false, registers = {}},
    [5] = {x = -705.96209716797, y = -914.01135253906, z = 19.215604782104, h = 87.027084350586, recent = false, registers = {}},
    [6] = {x = 24.478902816772, y = -1346.6854248047, z = 29.497020721436, h = 273.12100219727, recent = false, registers = {}},
    [7] = {x = -46.944438934326, y = -1758.2592773438, z = 29.42099571228, h = 53.93285369873, recent = false, registers = {}},
    [8] = {x = 372.67413330078, y = 327.03234863281, z = 103.56639099121, h = 259.80465698242, recent = false, registers = {}},
    [9] = {x = 1728.0157470703, y = 6415.7255859375, z = 35.037220001221, h = 250.05892944336, recent = false, registers = {}},
    [10] = {x = 1697.6986083984, y = 4923.0517578125, z = 42.06364440918, h = 321.22326660156, recent = false, registers = {}}
}

RegisterNetEvent('wrp-robbery:attemptRegisterRobbery')
AddEventHandler('wrp-robbery:attemptRegisterRobbery', function(sId, rId)
    if storeLocations[sId].recent or #storeLocations[sId].registers >= 2 then 
        TriggerClientEvent('DoLongHudText', source, 'This store has been robbed recently.', 2)
        return
    end
    
    for i = 1, #storeLocations[sId].registers do
        --print('Register: ' .. tostring(storeLocations[sId].registers[i]))
        if storeLocations[sId].registers[i] == rId then
            TriggerClientEvent('DoLongHudText', source, 'This register has been robbed already.', 2)
            return
        end
    end

    table.insert(storeLocations[sId].registers, rId)

    TriggerClientEvent('wrp-robbery:regSuccess', source)
end)

RegisterNetEvent('wrp-robbery:attemptSafeRobbery')
AddEventHandler('wrp-robbery:attemptSafeRobbery', function(sId)
    --print('Debug!')
    if safeLocations[sId].robbed then 
        TriggerClientEvent('DoLongHudText', source, 'This safe has been robbed recently.', 2)
        return
    end

    safeLocations[sId].robbed = true

    TriggerClientEvent('wrp-robbery:safeSuccess', source)
end)

RegisterServerEvent('store:give')
AddEventHandler('store:give', function(money)
    local source = source
    local LocalPlayer = exports['wrp-base']:getModule('LocalPlayer')
    if money ~= nil then
       TriggerClientEvent('wrp-ac:InfoPass', source, money)
       TriggerClientEvent('DoLongHudText', source, 'You got $'.. money .. ' from the Register!', 1)
    end
end)
