URP.Admin.Menu = {}
URP._Admin.Menu = {}
URP._Admin.Menu.PlayerOptions = {}
URP._Admin.Menu.SearchOptions = {
    type = nil,
    data = nil
}
URP._Admin.Menu.Target = {}

Citizen.CreateThread(function()
    Citizen.Wait(100)
    TriggerServerEvent('admin:getGroup')
end)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/setjob', '[CID] [ID] [JOB] [RANK]')
end)

local group = "user"
RegisterNetEvent('admin:setGroup')
AddEventHandler('admin:setGroup', function(g)
	group = g
end) 

RegisterNetEvent('wrp-requestJob')
AddEventHandler('wrp-requestJob', function(target, job, rank, id)
    LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
	Player = LocalPlayer:getCurrentCharacter()
    LocalPlayer:setJob(target, job)
    LocalPlayer:setRank(target, rank)
end)

RegisterCommand('setjob', function(source, args)
    if group == 'superadmin' then
        if args[1] and args[2] and args[3] and args[4] ~= nil then
            TriggerServerEvent('wrp-admin:requestJob', args[1], args[2], args[3], args[4])
        else
            TriggerEvent('DoLongHudText', '/setjob [CID] [ID] [JOB] [RANK]')
        end
    else
        TriggerEvent('DoLongHudText', 'You\'re not staff!')
    end
end)

RegisterCommand('reviveall', function()
    if group == 'superadmin' then
        for i = 0, 350 do
            TriggerServerEvent('admin:revivePlayer', i)
            TriggerEvent("Evidence:ClearDamageStates")
            TriggerEvent('client:lowerStress', 1000)
        end
    end
end)

function URP.Admin.Menu.Init(self)
    WarMenu.CreateMenu("amenu", "Admin Menu")
    WarMenu.SetSubTitle("amenu", "Options")

    WarMenu.SetMenuWidth("amenu", 0.5)
    WarMenu.SetMenuX("amenu", 0.71)
    WarMenu.SetMenuY("amenu", 0.017)
    WarMenu.SetMenuMaxOptionCountOnScreen("amenu", 30)
    WarMenu.SetTitleColor("amenu", 135, 206, 250, 255)
    WarMenu.SetTitleBackgroundColor("amenu", 0 , 0, 0, 150)
    WarMenu.SetMenuBackgroundColor("amenu", 0, 0, 0, 100)
    WarMenu.SetMenuSubTextColor("amenu", 255, 255, 255, 255)

    local function SetDefaultSubMenuProperties(menu)
        WarMenu.SetMenuWidth(menu, 0.5)
        WarMenu.SetTitleColor(menu, 135, 206, 250, 255)
        WarMenu.SetTitleBackgroundColor(menu, 0 , 0, 0, 150)
        WarMenu.SetMenuBackgroundColor(menu, 0, 0, 0, 100)
        WarMenu.SetMenuSubTextColor(menu, 255, 255, 255, 255)
    end

    WarMenu.CreateSubMenu("aplayers", "amenu", "Player List")
    SetDefaultSubMenuProperties("aplayers")

    WarMenu.CreateSubMenu("adplayers", "amenu", "Disconnected Player List")
    SetDefaultSubMenuProperties("adplayers")

    WarMenu.CreateSubMenu("aplayeropts", "amenu", "Player Info")
    SetDefaultSubMenuProperties("aplayeropts")

    WarMenu.CreateSubMenu("acommands", "amenu", "Commands")
    SetDefaultSubMenuProperties("acommands")

    WarMenu.CreateSubMenu("acategories", "amenu", "Categories")
    SetDefaultSubMenuProperties("acategories")

    WarMenu.CreateSubMenu("targetmenu", "amenu", "Available Targets")
    SetDefaultSubMenuProperties("targetmenu")

    WarMenu.CreateSubMenu("ranklist", "amenu", "Ranks")
    SetDefaultSubMenuProperties("ranklist")

    WarMenu.CreateSubMenu("command", "amenu", "Command Options")
    SetDefaultSubMenuProperties("command")
end

function URP.Admin.Menu.SetSubMenuProperties(self, menu)
    WarMenu.SetMenuWidth(menu, 0.5)
    WarMenu.SetTitleColor(menu, 135, 206, 250, 255)
    WarMenu.SetTitleBackgroundColor(menu, 0 , 0, 0, 150)
    WarMenu.SetMenuBackgroundColor(menu, 0, 0, 0, 100)
    WarMenu.SetMenuSubTextColor(menu, 255, 255, 255, 255)
end

function URP.Admin.Menu.DrawCommand(self, cmd)
    if not cmd or not URP.Admin:CommandExists(cmd) then return end

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(3)
            if WarMenu.IsMenuOpened("command") then URP.Admin:GetCommandData(cmd).drawcommand() else return end
            if WarMenu.MenuButton("Back", "acommands") then return end
        end
    end)
end

function URP.Admin.Menu.DrawTargets(self, cmd, cb)
    WarMenu.OpenMenu("targetmenu")

    Citizen.CreateThread(function()
        while WarMenu.IsMenuOpened("targetmenu") do
            Citizen.Wait(5)
            for k,v in spairs(URP._Admin.Players, function(t, a, b) return t[a].src < t[b].src end) do
                if WarMenu.MenuButton("[" .. v.src .. "] " .. v.name, "command") then self:DrawCommand(cmd) cb(v) URP.Admin:GetCommandData(cmd).drawcommand() return end
            end
            if WarMenu.MenuButton("Back", "command") then self:DrawCommand(cmd) URP.Admin:GetCommandData(cmd).drawcommand() return end
        end
    end)
end

function URP.Admin.Menu.DrawTextInput(self, defaultText, cb)
    Citizen.CreateThread(function()
        DisplayOnscreenKeyboard(6, "FMMC_KEY_TIP8", "", "", defaultText and defaultText or "" , "", "", 99)

        while true do
            Citizen.Wait(5)
            DisableAllControlActions(0)

            if UpdateOnscreenKeyboard() == 1 then cb(GetOnscreenKeyboardResult()) return
            elseif UpdateOnscreenKeyboard() == 2 or UpdateOnscreenKeyboard == 3 then return end
        end
    end)
end

local textEntryCb

local function nuiCallBack(data)
    if data.textEntry then
        textEntryCb(data.text and data.text or nil)
    end

    if data.close then
        SetNuiFocus(false, false)
    end

    if data.showcursor or data.showcursor == false then SetNuiFocus(data.showcursor, data.showcursor) end
end

RegisterNUICallback("nuiMessage", nuiCallBack)

function URP.Admin.Menu.ShowTextEntry(self, title, subMsg, cb)
    SendNUIMessage({open = true, textEntry = true, title = title, submsg = subMsg and subMsg or ""})
    textEntryCb = function(text) cb(text) end
end

function URP.Admin.Menu.DrawRanks(self, cmd, cb)
    WarMenu.OpenMenu("ranklist")

    Citizen.CreateThread(function()
        while WarMenu.IsMenuOpened("ranklist") do
            Citizen.Wait(5)
            for k,v in spairs(URP.Admin:GetRanks(), function(t, a, b) return t[a].grant < t[b].grant end) do
                if WarMenu.MenuButton(k, "command") then self:DrawCommand(cmd) cb(k) URP.Admin:GetCommandData(cmd).drawcommand() return end
            end
            if WarMenu.MenuButton("Back", "command") then self:DrawCommand(cmd) URP.Admin:GetCommandData(cmd).drawcommand() return end
        end
    end)
end

local viewingIp = false
local viewingLicense = false
local cat = nil

Citizen.CreateThread(function()
    Citizen.Wait(10)
    local function DrawMain()
        if WarMenu.Button("Commands") then
            WarMenu.OpenMenu("acategories")
        end
        
        if WarMenu.Button("Player List") then
            WarMenu.OpenMenu("aplayers")
        end

        if WarMenu.Button("Close") then
            WarMenu.CloseMenu()
        end
    end

    local function DrawPlayers()        
        for k,v in spairs(URP._Admin.Players, function(t, a, b) return t[a].src < t[b].src end) do
            if WarMenu.Button("[" .. v.src .. "] " .. v.name .. (v.sessioned and " - SESSIONED?" or ""), v.status, v.sessioned and {r = 255, g = 0, b = 0, a = 255} or nil) then URP._Admin.Menu.PlayerOptions = v viewingIp = false viewingLicense = false WarMenu.OpenMenu("aplayeropts") end
        end
        if WarMenu.MenuButton("Disconnected Players", "adplayers") then end
        if WarMenu.MenuButton("Back", "amenu") then return end
    end

    local function DrawDiscPlayers()
        for k,v in spairs(URP._Admin.DiscPlayers, function(t, a, b) return t[a].src < t[b].src end) do
            if WarMenu.MenuButton("[" .. v.src .. "] " .. v.name, "aplayeropts") then URP._Admin.Menu.PlayerOptions = v viewingIp = false end
        end
        if WarMenu.MenuButton("Back", "aplayers") then return end
    end

    local function DrawPlayerOptions()
        local options = URP._Admin.Menu.PlayerOptions

        if options then
            for k,v in pairs(options) do
                if not v or v == "" then options[k] = "Unknown" end
            end

            if WarMenu.Button("User:", options.name) then end
            if WarMenu.Button("Source:", options.src) then end
            if WarMenu.Button("Steam ID:", options.steamid) then end
            if WarMenu.Button("Hex ID:", options.comid) then end

            local license = string.gsub(options.license, "license:", "")
            if not viewingLicense then if WarMenu.Button("License:", "Press enter to view") then viewingLicense = true end else if WarMenu.Button("", license) then viewingLicense = false end end

            if URP.Admin:IsSuperAdmin() then
                if WarMenu.Button("Ping:", options.ping .. " ms") then end
                if not viewingIp then if WarMenu.Button("IP:", "Press enter to view") then viewingIp = true end else if WarMenu.Button("IP:", options.ip) then viewingIp = false end end
            end
            if options.sessioned then if WarMenu.Button("SESSIONED?", nil, {r = 255, g = 0, b = 0, a = 255}) then end end
        end
        if WarMenu.MenuButton("Back", "aplayers") then return end
    end

    local function DrawCommands()
        local userRank = URP.Admin:GetPlayerRank()

        if cat then
            for k,v in spairs(URP.Admin:GetCommands(), function(t, a, b) return t[a].title < t[b].title end) do
                if v.category == cat then
                    if URP.Admin:RankHasCommand(userRank, v.command) then if WarMenu.Button(v.title) then WarMenu.OpenMenu("command") URP.Admin.Menu:DrawCommand(v.command) end end
                end
            end
        end
        if WarMenu.MenuButton("Back", "acategories") then return end
    end

    local function DrawCategories()
        for k,v in spairs(URP.Admin:GetCategories(), function(t, a, b) return a < b end) do
            if WarMenu.Button(k) then
                cat = k
                WarMenu.SetSubTitle("acommands", "COMMANDS - " .. cat)
                WarMenu.OpenMenu("acommands")
            end
        end
        if WarMenu.MenuButton("Back", "amenu") then return end
    end

    local function DrawSearching()
        local userRank = URP.Admin:GetPlayerRank()
        if WarMenu.MenuButton("Ban Search", "searchopts") then URP._Admin.Menu.SearchOptions.type = "ban" end
        if WarMenu.MenuButton("Character Search", "searchopts") then URP._Admin.Menu.SearchOptions.type = "character" end
        if WarMenu.MenuButton("Steam ID Search", "searchopts") then URP._Admin.Menu.SearchOptions.type = "steamid" end
    end

    searchTypes = {
        ["ban"] = {},
        ["character"] = {},
        ["steamid"] = {steamid = false}
    }

    local searching = false

    local function DrawSearchOptions()
        local type = URP._Admin.Menu.SearchOptions.type
        if not type then return end

        if WarMenu.Button("Search Type:", type) then end

        type = searchTypes[type]

        local function openTextEntry(title)
            if searching then return end
            
            URP.Admin.Menu:ShowTextEntry(title, "", function(result)
                if result then
                    searching = true

                    if string.gsub(result, " ", "") == "" or result == "" then result = nil end
                end

                TriggerServerEvent("wrp-admin:searchRequest", URP._Admin.SearchOptions.type, result)
            end)
        end

        if type.steamid ~= false and WarMenu.Button("Search with Steam ID") then openTextEntry("Enter a Steam ID") end
        if type.cid ~= false and WarMenu.Button("Search with Character ID") then openTextEntry("Enter a Character ID") end
        if type.src ~= false and WarMenu.Button("Search with Source Number") then openTextEntry("Enter a Source Number") end
        if type.phone ~= false and WarMenu.Button("Search with Phone Number") then openTextEntry("Enter a Phone Number") end
        if WarMenu.MenuButton("Back", "asearch") then end
    end

    URP._Admin.Menu.Menus = {
        ["amenu"] = DrawMain,
        ["asearch"] = DrawSearching,
        ["searchopts"] = DrawSearchOptions,
        ["aplayers"] = DrawPlayers,
        ["adplayers"] = DrawDiscPlayers,
        ["aplayeropts"] = DrawPlayerOptions,
        ["acommands"] = DrawCommands,
        ["acategories"] = DrawCategories,
        ["command"] = false,
        ["targetmenu"] = false,
        ["ranklist"] = false
    }

    while true do
        Citizen.Wait(3)

        for k,v in pairs(URP._Admin.Menu.Menus) do
            if v ~= false and WarMenu.IsMenuOpened(k) then
                v()
            end
        end

        WarMenu.Display()
    end
end)

RegisterNetEvent("wrp-admin:openMenu")
AddEventHandler("wrp-admin:openMenu", function()
    WarMenu.OpenMenu("amenu")
end)

RegisterCommand("tpm", function(source)
    if group == 'superadmin' then
        TeleportToWaypoint()
    else
        TriggerEvent('DoLongHudText', "You are not an admin", 2)
    end
end)

function TeleportToWaypoint()
    local WaypointHandle = GetFirstBlipInfoId(8)

	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end

            Citizen.Wait(5)
        end
        TriggerEvent('DoLongHudText', "Teleported.")
    else
        TriggerEvent('DoLongHudText', "Please place your waypoint.")
    end
end

-- RegisterCommand('setjob', function(source, args)
--     if group ~= "user" then
--         if args[1] ~= nil then
--             for k, v in pairs(exports['wrp-base']:GetJobs()) do
--                 if args[2] == v then
--                     TriggerServerEvent('wrp-base:setJob', tonumber(args[1]), args[2])
--                     for k, v in pairs(exports['wrp-base']:GetRanks()) do
--                         if v.name == args[2] then
--                             local ranks = json.encode(v.ranks)
--                             if args[3] ~= nil then
--                                 TriggerServerEvent('wrp-base:setRank', tonumber(args[1]), args[3])
--                             else
--                                 TriggerEvent('DoLongHudText', "Provide a rank.", 2)
--                             end
--                         end
--                     end
--                     if #args < 3 then return end
--                     TriggerEvent('DoLongHudText', "Set server id: "..args[1].."'s job to: " .. args[2] .. " with the rank of: " .. args[3])

--                     local jId = 0
--                     local jobs = exports['wrp-base']:GetJobs()

--                     for i = 1, #jobs do
--                         if jobs[i] == args[2] then jId = i end
--                     end

--                     TriggerServerEvent('wrp-base:updateJobLogs', args[1], args[3], jId)
--                 end
--             end
--         else
--             TriggerEvent('DoLongHudText', "Provide an id of a player.", 2)
--         end
--     else
--         TriggerEvent('DoLongHudText', "You are not an admin", 2)
--     end
-- end)

-- /setjob source, job, ran

RegisterCommand('menu', function()
    -- print(group)
    if group == "superadmin" then
        TriggerEvent('wrp-admin:openMenu')
    else
        TriggerEvent('DoLongHudText', "You are not an admin", 2)
    end
end)