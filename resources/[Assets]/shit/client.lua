local msgCount2 = 0
local scary2 = 0
local scaryloop2 = false
local dicks2 = 0
local dicks3 = 0
local dicks = 0
local timer = 0 --in minutes - Set the time during the player is outlaw
local showOutlaw = false --Set if show outlaw act on map
local gunshotAlert = true --Set if show alert when player use gun
local carJackingAlert = true --Set if show when player do carjacking
local meleeAlert = true --Set if show when player fight in melee
local blipGunTime = 60 --in second
local blipMeleeTime = 60 --in second
local blipJackingTime = 60 -- in second
local blipDeathTime = 360 -- in second
local isInService = false
--End config

local origin = false --Don't touche it
local timing = timer * 60000 --Don't touche i


isCop = false


local ped = PlayerPedId()
local isInVehicle = IsPedInAnyVehicle(ped, true)
Citizen.CreateThread( function()
    while true do
        Wait(1000)
        ped = PlayerPedId()
        isInVehicle = IsPedInAnyVehicle(ped, true)
    end
end)



Citizen.CreateThread( function()
    local origin = false
    local w = `WEAPON_PetrolCan`
    local w1 = `WEAPON_FIREEXTINGUISHER`
    local w2 = `WEAPON_FLARE`
    local curw = GetSelectedPedWeapon(PlayerPedId())
    local armed = false
    local timercheck = 0
    while true do
        Wait(50)
        

        if not armed then
            if IsPedArmed(ped, 7) and not IsPedArmed(ped, 1) then
             --   print("detect weapon")
                curw = GetSelectedPedWeapon(ped)
                armed = true
                timercheck = 15
            end
        end

        if armed then

            if w == curw then
                TriggerEvent("Evidence:StateSet",9,1200)
            end

            if w2 == curw then
                TriggerEvent("Evidence:StateSet",10,1200)
            end

            if not isCop and IsPedShooting(ped) and curw ~= w and curw ~= w2 and curw ~= w1 and not origin then

              --  print("shot")
                local inArea = false
                for i,v in ipairs(exlusionZones) do
                    local playerPos = GetEntityCoords(ped)
                    if #(vector3(v[1],v[2],v[3]) - vector3(playerPos.x,playerPos.y,playerPos.z)) < v[4] then
                        --if `WEAPON_COMBATPDW` == curw then
                            inArea = true
                        --end
                    end
                end
                if not inArea then
                    origin = true
                    if IsPedCurrentWeaponSilenced(ped) then
                        TriggerEvent("civilian:alertPolice",15.0,"gunshot",0,true)
                    elseif isInVehicle then
                        TriggerEvent("civilian:alertPolice",150.0,"gunshotvehicle",0,true)
                    else
                        TriggerEvent("civilian:alertPolice",550.0,"gunshot",0,true)
                    end

                    Wait(60000)
                    origin = false
                end
            end

            if timercheck == 0 then
               -- print("weapon disabled")
                armed = false
            else
                timercheck = timercheck - 1
            end

        else


             Citizen.Wait(5000)


        end
    end
end)


Citizen.CreateThread( function()

    local origin2 = false
    while true do
        Wait(1)
        local plyPos = GetEntityCoords(PlayerPedId(),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
        local w = `WEAPON_PetrolCan`
        local w1 = `WEAPON_FIREEXTINGUISHER`
        local w2 = `WEAPON_FLARE`
        local curw = GetSelectedPedWeapon(PlayerPedId())

        local targetCoords = GetEntityCoords(PlayerPedId(), 0)

        if math.random(100) > 77 and not isCop and not isInVehicle and IsPedArmed(PlayerPedId(), 7) and not IsPedArmed(PlayerPedId(), 1) and curw ~= w and curw ~= w2 and curw ~= w1 and not origin2 then
            origin2 = true

            TriggerEvent("civilian:alertPolice",35.0,"PDOF",0)
            Wait(60000)
            origin2 = false
        else
            if isCop then
                Wait(60000)
            else
                Wait(5000)
            end
        end

    end
end)

local gasStations = {
    {264.47033691406,-1261.2421875,29.29295539856},
    {-320.13858032227,-1471.3533935547,30.548488616943},
    {-526.69915771484,-1210.8858642578,18.184833526611},
    {-724.63739013672,-934.99969482422,19.213779449463},
    {1208.9411621094,-1402.3977050781,35.224239349365},
    {819.65350341797,-1028.7437744141,26.404289245605},
    {-70.216720581055,-1761.7586669922,29.552667617798},
    {1181.3813476563,-330.79992675781,69.301834106445},
    {620.84295654297,269.13439941406,103.0856552124},
    {-1437.6204833984,-276.74166870117,46.212665557861},
    {-2096.2429199219,-320.27899169922,13.164064407349},
    {2581.3210449219,362.05072021484,108.46426391602},
    {-1800.3715820313,803.67309570313,138.64669799805},
    {-2554.9643554688,2334.4987792969,33.077770233154},
    {2539.0300292969,2594.3547363281,37.96667098999},
    {2679.9538574219,3263.9755859375,55.235542297363},
    {1785.4615478516,3330.3972167969,41.382518768311},
    {1207.3582763672,2660.1997070313,38.37427520752},
    {1040.25,2671.1923828125,39.550861358643},
    {263.99612426758,2606.4821777344,44.982532501221},
    {49.521022796631,2778.8117675781,58.049034118652},
    {2005.2669677734,3773.830078125,32.403442382813},
    {1701.4376220703,6416.0341796875,32.763523101807},
    {180.12121582031,6602.83203125,31.868190765381},
    {154.82797241211,6628.8154296875,31.73567199707},
    {-94.501037597656,6419.6235351563,31.485576629639},
}


Citizen.CreateThread( function()
    local origin3 = false
    while true do
        Wait(1)
        local plyPos = GetEntityCoords(PlayerPedId(),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        local dstcheck = 1000.0
        for i,v in ipairs(gasStations) do
            local scandst = #(vector3(v[1],v[2],v[3]) - vector3(plyPos.x, plyPos.y, plyPos.z))
            if scandst < 10 and scandst < dstcheck then
                dstcheck = scandst
                if IsExplosionInSphere(9,v[1],v[2],v[3],60.0)  then
                    origin3 = true
                    TriggerServerEvent('dispatch:svNotify', {
                        dispatchCode = "10-70",
                        firstStreet = street1,
                        secondStreet = street2,
                        origin = {
                            x = plyPos.x,
                            y = plyPos.y,
                            z = plyPos.z
                        }
                    })
                    Wait(9000)
                    origin3 = false
                end
            end
        end
        if dstcheck > 50 then
            Citizen.Wait(math.ceil(dstcheck*10))
        end
    end
end)


function getRandomNpc(basedistance)
    local basedistance = basedistance
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom

    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if ped ~= PlayerPedId() and distance < basedistance and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
        end
        success, ped = FindNextPed(handle)
    until not success

    EndFindPed(handle)

    return rped
end

function DrawText3DTest(x,y,z, text, dicks,power)

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    if dicks > 255 then
        dicks = 255
    end
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 155)
        SetTextEdge(1, 0, 0, 0, 250)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
         SetTextColour(255, 255, 255, dicks)

        DrawText(_x,_y)
        local factor = (string.len(text)) / 250
        if dicks < 115 then
             DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 11, 1, 11, dicks)
        else
             DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 11, 1, 11, 115)
        end

    end
end


Citizen.CreateThread( function()
    local origin3 = false
    while true do
        Wait(1)
        if GetVehiclePedIsUsing(PlayerPedId()) == 0 then
            if IsPedInMeleeCombat(PlayerPedId()) and not origin3 and getRandomNpc(3.0) then
                origin3 = true
                TriggerEvent("civilian:alertPolice",15.0,"fight",0)
                TriggerEvent("Evidence:StateSet",1,300)
                Wait(20000)
                origin3 = false
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

local ped = PlayerPedId()
local isInVehicle = IsPedInAnyVehicle(ped, true)
Citizen.CreateThread( function()
    while true do
        Wait(1000)
        ped = PlayerPedId()
        isInVehicle = IsPedInAnyVehicle(ped, true)
    end
end)