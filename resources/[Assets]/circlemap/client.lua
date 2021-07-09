Citizen.CreateThread(function()
    RequestStreamedTextureDict("circlemap", false)
    while not HasStreamedTextureDictLoaded("circlemap") do
        Wait(0)
    end
    
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
    AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "circlemap", "radarmasksm")

    SetBlipAlpha(GetNorthRadarBlip(), 0.0)
    SetBlipScale(GetMainPlayerBlipId(), 0.7)

    local screenX, screenY = GetScreenResolution()
    local modifier = screenY / screenX

    local baseXOffset = 0.0046875
    local baseYOffset = 0.74

    local baseSize    = 0.20 -- 20% of screen

    local baseXWidth  = 0.1313 -- baseSize * modifier -- %
    local baseYHeight = baseSize -- %

    local baseXNumber = screenX * baseSize  -- 256
    local baseYNumber = screenY * baseSize  -- 144

    local radiusX     = baseXNumber / 2     -- 128
    local radiusY     = baseYNumber / 2     -- 72
        
    local innerSquareSideSizeX = math.sqrt(radiusX * radiusX * 2) -- 181.0193
    local innerSquareSideSizeY = math.sqrt(radiusY * radiusY * 2) -- 101.8233

    local innerSizeX = ((innerSquareSideSizeX / screenX) - 0.01) * modifier
    local innerSizeY = innerSquareSideSizeY / screenY

    local innerOffsetX = (baseXWidth - innerSizeX) / 2
    local innerOffsetY = (baseYHeight - innerSizeY) / 2

    local innerMaskOffsetPercentX = (innerSquareSideSizeX / baseXNumber) * modifier

    local function setPos(type, posX, posY, sizeX, sizeY)
        SetMinimapComponentPosition(type, "I", "I", posX, posY, sizeX, sizeY)
    end
    
    setPos("minimap",       baseXOffset - (0.025 * modifier), baseYOffset - 0.025, baseXWidth + (0.05 * modifier), baseYHeight + 0.05)
    setPos("minimap_blur",  baseXOffset - 0.005, baseYOffset - 0.030, baseXWidth + 0.090, baseYHeight + 0.090)
    setPos("minimap_mask", 0.1, 0.95, 0.09, 0.15)

    SetMinimapClipType(1)
    DisplayRadar(0)
    SetRadarBigmapEnabled(true, false)
    Citizen.Wait(0)
    SetRadarBigmapEnabled(false, false)
    DisplayRadar(1)
end)


Citizen.CreateThread(function()
    while true do
        --DontTiltMinimapThisFrame()
        HideMinimapInteriorMapThisFrame()
        SetRadarZoom(1000)
        Citizen.Wait(0)
    end
end)

local pauseActive = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local player = PlayerPedId()
        SetRadarZoom(1000)
        SetRadarBigmapEnabled(false, false)
        local isPMA = IsPauseMenuActive()
        if isPMA and not pauseActive or IsRadarHidden() then 
            pauseActive = true 
            SendNUIMessage({
                action = "hideUI"
            })
            uiHidden = true
        elseif not isPMA and pauseActive then
            pauseActive = false
            SendNUIMessage({
                action = "displayUI"
            })
            uiHidden = false
        end
    Citizen.Wait(0)
    end
end)