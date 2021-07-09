URP.Core = URP.Core or {}

function URP.Core.ConsoleLog(self, msg, mod)
    if not tostring(msg) then return end
    if not tostring(mod) then mod = "No Module" end
    
    local pMsg = string.format("[URP LOG - %s] %s", mod, msg)
    if not pMsg then return end

    -- print(pMsg)
end

RegisterNetEvent("wrp-base:consoleLog")
AddEventHandler("wrp-base:consoleLog", function(msg, mod)
    URP.Core:ConsoleLog(msg, mod)
end)

function getModule(module)
    if not URP[module] then print("Warning: '" .. tostring(module) .. "' module doesn't exist") return false end
    return URP[module]
end

function addModule(module, tbl)
    if URP[module] then print("Warning: '" .. tostring(module) .. "' module is being overridden") end
    URP[module] = tbl
end

URP.Core.ExportsReady = false

function URP.Core.WaitForExports(self)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(3)
            if exports and exports["wrp-base"] then
                TriggerEvent("wrp-base:exportsReady")
                URP.Core.ExportsReady = true
                return
            end
        end
    end)
end

URP.Core:WaitForExports()