local function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

local Keys = {
    [289] = "F2", [170] = "F3", [166] = "F5", [167] = "F6", [168] = "F7" ,[56] = "F9", [57] = "F10" 
}

local p_anims = {}
local favorites = {}
local currentKeys = {
    {["key"] = {170},["anim"] = ""},
    {["key"] = {166},["anim"] = ""},
    {["key"] = {167},["anim"] = ""},
    {["key"] = {168},["anim"] = ""},
    {["key"] = {56},["anim"] = ""},
    {["key"] = {57},["anim"] = ""},

    {["key"] = {170,21},["anim"] = ""},
    {["key"] = {166,21},["anim"] = ""},
    {["key"] = {167,21},["anim"] = ""},
    {["key"] = {168,21},["anim"] = ""},
    {["key"] = {56,21},["anim"] = ""},
    {["key"] = {57,21},["anim"] = ""},
}
WarMenu.CreateMenu("emotes", "Emotes")
WarMenu.SetSubTitle("emotes", "Emote List")

WarMenu.SetMenuWidth("emotes", 0.5)
WarMenu.SetMenuX("emotes", 0.71)
WarMenu.SetMenuY("emotes", 0.017)
WarMenu.SetMenuMaxOptionCountOnScreen("emotes", 15)
WarMenu.SetTitleColor("emotes", 135, 206, 250, 255)
WarMenu.SetTitleBackgroundColor("emotes", 0 , 0, 0, 150)
WarMenu.SetMenuBackgroundColor("emotes", 0, 0, 0, 100)
WarMenu.SetMenuSubTextColor("emotes", 255, 255, 255, 255)

WarMenu.CreateSubMenu("walkingstyles", "emotes", "Select a walking style")
WarMenu.SetMenuWidth("walkingstyles", 0.5)
WarMenu.SetMenuMaxOptionCountOnScreen("walkingstyles", 30)
WarMenu.SetTitleColor("walkingstyles", 135, 206, 250, 255)
WarMenu.SetTitleBackgroundColor("walkingstyles", 0 , 0, 0, 150)
WarMenu.SetMenuBackgroundColor("walkingstyles", 0, 0, 0, 100)
WarMenu.SetMenuSubTextColor("walkingstyles", 255, 255, 255, 255)

WarMenu.CreateSubMenu("favorites", "emotes", "Favorites (Press F to remove a favorite)")
WarMenu.SetMenuWidth("favorites", 0.5)
WarMenu.SetMenuMaxOptionCountOnScreen("favorites", 30)
WarMenu.SetTitleColor("favorites", 135, 206, 250, 255)
WarMenu.SetTitleBackgroundColor("favorites", 0 , 0, 0, 150)
WarMenu.SetMenuBackgroundColor("favorites", 0, 0, 0, 100)
WarMenu.SetMenuSubTextColor("favorites", 255, 255, 255, 255)

local selected_page = 1

local function DrawMenu()
    if WarMenu.Button("Page:", selected_page.."/"..#p_anims, {r = 135, g = 206, b = 250, a = 150}) then ClearPedTasks(PlayerPedId()) playing_emote = false end
    if WarMenu.Button("Walking styles", "", {r = 135, g = 206, b = 250, a = 150}) then WarMenu.OpenMenu("walkingstyles") end
    if WarMenu.Button("Favorites", "Press F to favorite an emote", {r = 135, g = 206, b = 250, a = 150}) then WarMenu.OpenMenu("favorites") end
    local key = ""
    for i,v in ipairs(currentKeys) do
        if v.key[2] ~= nil and "Cancel Emote" == v.anim then
             key = "Shift+"..Keys[v.key[1]]
        elseif v.key[1] ~= nil and "Cancel Emote" == v.anim then
           key = Keys[v.key[1]]
        end
    end 
    if WarMenu.Button("Cancel Emote",key, {r = 135, g = 206, b = 250, a = 150}) then ClearPedTasks(PlayerPedId()) playing_emote = false end

    for k,v in spairs(p_anims[selected_page], function(t, a, b) return string.lower(tostring(a)) < string.lower(tostring(b)) end) do
    local msg = ""
        for i,v in ipairs(currentKeys) do
            if v.key[2] ~= nil and k == v.anim then
                 msg = "Shift+"..Keys[v.key[1]]
            elseif v.key[1] ~= nil and k == v.anim then
               msg = Keys[v.key[1]]
            end
        end 
        if WarMenu.Button(k,msg) then TriggerEvent("animation:PlayAnimation", k) end
    end
end

local function DrawWalkingStyles()
    if WarMenu.Button("Reset Walking Style", nil, {r = 0, g = 0, b = 0, a = 150}) then ResetPedMovementClipset(PlayerPedId()) end
    -----------------------------------------
    if WarMenu.Button("Alien", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@alien') end
    if WarMenu.Button("Armored", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('anim_group_move_ballistic') end
    if WarMenu.Button("Arrogant", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_f@arrogant@a') end
    if WarMenu.Button("Brave", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@brave') end
    if WarMenu.Button("Casual", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@casual@a') end
    if WarMenu.Button("Casual2", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@casual@b') end
    if WarMenu.Button("Casual3", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@casual@c') end
    if WarMenu.Button("Casual4", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@casual@d') end
    if WarMenu.Button("Casual5", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@casual@e') end
    if WarMenu.Button("Casual6", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@casual@f') end
    if WarMenu.Button("Chichi", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_f@chichi') end
    if WarMenu.Button("Confident", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@confident') end
    if WarMenu.Button("Cop", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@business@a') end
    if WarMenu.Button("Cop2", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@business@b') end
    if WarMenu.Button("Cop3", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@business@c') end
    if WarMenu.Button("Default Female", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_f@multiplayer') end
    if WarMenu.Button("Default Male", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@multiplayer') end
    if WarMenu.Button("Drunk", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@drunk@a') end
    if WarMenu.Button("Drunk1", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@drunk@slightlydrunk') end
    if WarMenu.Button("Drunk2", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@buzzed') end
    if WarMenu.Button("Drunk3", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@drunk@verydrunk') end
    if WarMenu.Button("Femme", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_f@femme@') end
    if WarMenu.Button("Fire", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_characters@franklin@fire') end
    if WarMenu.Button("Fire2", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_characters@michael@fire') end
    if WarMenu.Button("Fire3", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@fire') end
    if WarMenu.Button("Flee", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_f@flee@a') end
    if WarMenu.Button("Franklin", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_p_m_one') end
    if WarMenu.Button("Gangster", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@gangster@generic') end
    if WarMenu.Button("Gangster2", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@gangster@ng') end
    if WarMenu.Button("Gangster3", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@gangster@var_e') end
    if WarMenu.Button("Gangster4", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@gangster@var_f') end
    if WarMenu.Button("Gangster5", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@gangster@var_i') end
    if WarMenu.Button("Grooving", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('anim@move_m@grooving@') end
    if WarMenu.Button("Guard", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@prison_gaurd') end
    if WarMenu.Button("Handcuffs", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@prisoner_cuffed') end
    if WarMenu.Button("Heels", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_f@heels@c') end
    if WarMenu.Button("Heels2", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_f@heels@d') end
    if WarMenu.Button("Hiking", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@hiking') end
    if WarMenu.Button("Hipster", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@hipster@a') end
    if WarMenu.Button("Hobo", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@hobo@a') end
    if WarMenu.Button("Hurry", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_f@hurry@a') end
    if WarMenu.Button("Janitor", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_p_m_zero_janitor') end
    if WarMenu.Button("Janitor2", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_p_m_zero_slow') end
    if WarMenu.Button("Jog", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@jog@') end
    if WarMenu.Button("Lemar", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('anim_group_move_lemar_alley') end
    if WarMenu.Button("Lester", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_heist_lester') end
    if WarMenu.Button("Lester2", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_lester_caneup') end
    if WarMenu.Button("Maneater", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_f@maneater') end
    if WarMenu.Button("Michael", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_ped_bucket') end
    if WarMenu.Button("Money", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@money') end
    if WarMenu.Button("Muscle", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@muscle@a') end
    if WarMenu.Button("Posh", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@posh@') end
    if WarMenu.Button("Posh2", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_f@posh@') end
    if WarMenu.Button("Quick", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@quick') end
    if WarMenu.Button("Runner", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('female_fast_runner') end
    if WarMenu.Button("Sad", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@sad@a') end
    if WarMenu.Button("Sassy", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@sassy') end
    if WarMenu.Button("Sassy2", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_f@sassy') end
    if WarMenu.Button("Scared", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_f@scared') end
    if WarMenu.Button("Sexy", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_f@sexy@a') end
    if WarMenu.Button("Shady", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@shadyped@a') end
    if WarMenu.Button("Slow", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_characters@jimmy@slow@') end
    if WarMenu.Button("Swagger", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@swagger') end
    if WarMenu.Button("Tough", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@tough_guy@') end
    if WarMenu.Button("Tough2", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_f@tough_guy@') end
    if WarMenu.Button("Trash", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('clipset@move@trash_fast_turn') end
    if WarMenu.Button("Trash2", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('missfbi4prepp1_garbageman') end
    if WarMenu.Button("Trevor", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_p_m_two') end
    if WarMenu.Button("Wide", nil, {r = 0, g = 0, b = 0, a = 150}) then WalkMenuStart('move_m@bag') end
    -----------------------------------------
    if WarMenu.MenuButton("Back", "emotes", {r = 135, g = 206, b = 250, a = 150}) then end
end

local function DrawFavorites()
    if WarMenu.Button("Cancel Emote", nil, {r = 135, g = 206, b = 250, a = 150}) then ClearPedTasks(PlayerPedId()) playing_emote = false end
    if WarMenu.MenuButton("Back", "emotes", {r = 135, g = 206, b = 250, a = 150}) then end

    for k,v in spairs(favorites, function(t, a, b) return string.lower(tostring(t[a])) < string.lower(tostring(t[b])) end) do
        if WarMenu.Button(v) then TriggerEvent("animation:PlayAnimation", v) end
    end
end

function addKey(anim,keys)
    if anim == "Page:" or anim == "Favorites" or anim == "Back" then return end
    for i,v in ipairs(currentKeys) do
        if keys[2] ~= nil then
            if v.key[1] == keys[1] and v.key[2] == 21 then
                v.anim = anim
            end
        else 
            if v.key[1] == keys[1] and v.key[2] == nil then
                v.anim = anim
            end
        end
    end
    local LocalPlayer = exports["prp-base"]:getModule("LocalPlayer")
    local Player = LocalPlayer:getCurrentCharacter()
    TriggerServerEvent("police:setEmoteData", currentKeys, Player.id)
end


local function addFavorite(anim)
    if not anims[anim] then return end
    for k,v in pairs(favorites) do if v == anim then return end end

    local key = 0

    for k,v in pairs(favorites) do
        local c = tonumber(string.match(k, "%d+"))
        if c >= key then key = c end
    end

    key = key + 1

    favorites["fav:"..key] = anim
    SetResourceKvp("fav:"..key, anim)
end

local function removeFavorite(anim)
    for k,v in pairs(favorites) do
        if v == anim then
            DeleteResourceKvp(k)
            favorites[k] = nil
        end
    end
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)

end

Citizen.CreateThread(function()
    local c = 0
    local page = 1

    for k,v in spairs(anims, function(t, a, b) return string.lower(tostring(a)) < string.lower(tostring(b)) end) do
        p_anims[page] = p_anims[page] and p_anims[page] or {}
        p_anims[page][k] = v
        c = c + 1
        if c >= 7 then c = 0 page = page + 1 end
    end

    local KvpHandle = StartFindKvp("fav:")

    repeat
        local key = FindKvp(KvpHandle)
        if key then
            favorites[key] = GetResourceKvpString(key)
        end
    until not key

    while true do
        Citizen.Wait(1)
        if WarMenu.IsMenuOpened("emotes") then
            DrawMenu()

            WarMenu.Display()
            local plyCoords = GetEntityCoords(PlayerPedId())
            DrawText3Ds(plyCoords["x"],plyCoords["y"],plyCoords["z"]+0.5,"~g~Enter~s~ Plays Emote")
            DrawText3Ds(plyCoords["x"],plyCoords["y"],plyCoords["z"]+0.4,"~g~Arrows~s~ Navigate Pages")
            DrawText3Ds(plyCoords["x"],plyCoords["y"],plyCoords["z"]+0.3,"~g~Backspace~s~ Exits")
            DrawText3Ds(plyCoords["x"],plyCoords["y"],plyCoords["z"]+0.2,"~g~F3-F10~s~ Saves Emote")
            DrawText3Ds(plyCoords["x"],plyCoords["y"],plyCoords["z"],"~g~Shift~s~ with F keys saves also. (F8 Doesnt Save)")
            DrawText3Ds(plyCoords["x"],plyCoords["y"],plyCoords["z"]+0.1,"You can also type ~g~/e emotename~s~ in chat to perform them")
            if IsControlJustReleased(0, 174) then
                selected_page = selected_page > 1 and selected_page - 1 or #p_anims
            elseif IsControlJustReleased(0, 175) then
                selected_page = selected_page < #p_anims and selected_page + 1 or 1
            elseif IsControlJustReleased(0, 26) then
                for i,v in ipairs(currentKeys) do
                    local curButton = WarMenu.GetCurrentButton()
                    if v.anim == curButton.text then
                        v.anim = ""
                    end
                end
            elseif IsControlJustPressed(0, 23) then
                local curButton = WarMenu.GetCurrentButton()
                if curButton then
                    addFavorite(curButton.text)
                end
            end

            
            for i,v in ipairs(currentKeys) do
                if v.key[2] ~= nil then
                    if IsControlPressed(0,21) and IsControlJustReleased(0, v.key[1]) then
                       local curButton = WarMenu.GetCurrentButton()
                        if curButton then
                            addKey(curButton.text,{v.key[1],21})
                        end
                    end
                else
                    if not IsControlPressed(0,21) and IsControlJustReleased(0, v.key[1]) then
                       local curButton = WarMenu.GetCurrentButton()
                        if curButton then
                            addKey(curButton.text,{v.key[1]})
                        end
                    end
                end
            end
            
        elseif WarMenu.IsMenuOpened("walkingstyles") then
            DrawWalkingStyles()
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened("favorites") then
            DrawFavorites()
            WarMenu.Display()

            if IsControlJustPressed(0, 23) then
                local curButton = WarMenu.GetCurrentButton()
                if curButton then
                    removeFavorite(curButton.text)
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

RegisterNetEvent("emotes:OpenMenu")
AddEventHandler("emotes:OpenMenu", function()
    WarMenu.OpenMenu("emotes")
end)

RegisterNetEvent("emote:setEmotesFromDB");
AddEventHandler("emote:setEmotesFromDB", function(emotesResult)
    local data = json.decode(emotesResult)
    currentKeys = data
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1)
--         if IsControlJustReleased(0, 244) then
--             if exports['prp-deathmanager']:GetDeath() then
--                 TriggerEvent('DoLongHudText', "You're dead...", 2)
--             else
--                 TriggerEvent('emotes:OpenMenu')
--             end
--         end
--         for i,v in ipairs(currentKeys) do
--             if v.key[2] ~= nil then
--                 if IsControlPressed(0,21) and IsControlJustReleased(0, v.key[1]) then
--                     if v.anim == "Cancel Emote" then
--                         ClearPedTasks(PlayerPedId()) playing_emote = false
--                     else
--                         TriggerEvent("animation:PlayAnimation", v.anim)
--                     end
--                 end
--             else
--                 if not IsControlPressed(0,21) and IsControlJustReleased(0, v.key[1]) then
--                     if v.anim == "Cancel Emote" then
--                         ClearPedTasks(PlayerPedId()) playing_emote = false
--                     else
--                         TriggerEvent("animation:PlayAnimation", v.anim)
--                     end
--                 end
--             end
--         end
--     end
-- end)

--[walkingstyles]
function WalkMenuStart(name)
    RequestWalking(name)
    SetPedMovementClipset(PlayerPedId(), name, 0.2)
    RemoveAnimSet(name)
  end
  
  function RequestWalking(set)
    RequestAnimSet(set)
    while not HasAnimSetLoaded(set) do
      Citizen.Wait(1)
    end 
  end
  
  function WalksOnCommand(source, args, raw)
    local WalksCommand = ""
    for a in pairsByKeys(DP.Walks) do
      WalksCommand = WalksCommand .. ""..string.lower(a)..", "
    end
    EmoteChatMessage(WalksCommand)
    EmoteChatMessage("To reset do /walk reset")
  end
  
  function WalkCommandStart(source, args, raw)
    local name = firstToUpper(args[1])
  
    if name == "Reset" then
        ResetPedMovementClipset(PlayerPedId()) return
    end
  
    local name2 = table.unpack(DP.Walks[name])
    if name2 ~= nil then
      WalkMenuStart(name2)
    else
      EmoteChatMessage("'"..name.."' is not a valid walk")
    end
  end
