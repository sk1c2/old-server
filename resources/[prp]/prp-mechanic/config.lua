Config                              = {}
Config.Blipname                     = "Chop Shop"
Config.BlipSprite                   = 620
Config.BlipScale                    = 0.7
Config.BlipColor                    = 1
    
Config.NPCName                      = "mp_m_waremech_01"
Config.NPCLocation	                = { x = 2342.054, y = 3056.188, z = 47.15184, h = 180.73937988281 }
Config.NPCScenerioCurrent           = 'WORLD_HUMAN_SMOKING'
Config.NPCScenerioInProg            = 'WORLD_HUMAN_CLIPBOARD'
    
Config.DrawDistance                 = 20.0
Config.MarkerColorOnFoot            = { r = 255, g = 0, b = 0, a = 100 }
Config.MarkerColorInVehicle         = { r = 0, g = 255, b = 0, a = 100 }
Config.MarkerFadeTimer              = 3
    
Config.MarkerPos                    = { x = 2341.149, y = 3052.248, z = 47.15185}
Config.MarkerSize                   = { x = 3.0, y = 3.0, z = 3.0 }
Config.MarkerType                   = 6

Config.reward                       = 'cash'

Config.ActionMsg                    = 'Press [E] to start Chopping the vehicle.'
Config.ActionButton                 = 38

Config.Cars                         = {
    --  [Car Model]                     = Price Of Chopping Car  --
        ['rebel']                      = math.random(100, 250),
        ['sadler']                     = math.random(100, 250),
        ['sandking']                     = math.random(100, 250),
        ['sultan']                    = math.random(100, 250),
        ['sanchez']                    = math.random(100, 250),
        ['emperor']                    = math.random(100, 250),
        ['voodoo2']                    = math.random(100, 250),
        ['surfer2']                    = math.random(100, 250),
        ['bison']                    = math.random(100, 250),
        ['blazer']                    = math.random(100, 250),
        ['regina']                    = math.random(100, 250),
        ['phoenix']                    = math.random(100, 250),
        ['bfinjection']                    = math.random(100, 250),
        ['patriot']                    = math.random(100, 250),
        ['buccaneer2']                    = math.random(100, 250)
}

Config.ProgressDelay                = 0
Config.Progress                     = {
    -- [Seconds] = "TEXT" --
    {
        [30]                         = "Checking Vehicle Model"
    },
    {
        [30]                         = "Verifying Vehicle Info"
    },
    {
        [20]                         = "Checking paint n scrap prices"
    },
    {
        [15]                         = "Chopping Parts, Please wait.."
    },
}

Config.FailLeft                     = 'Failed: Not in Vehicle / Left Vehicle'
Config.Success                      = "You sold scraps of '%car%' for $%money%"
Config.FailDead                     = "Rest in peace my dear, just rest in peace.."
Config.FailSeat                     = "Get into the driver seat and then try maybe?"
Config.FailChop                     = "We are not interested in that vehicle right now"
Config.FailOwn                      = "This %car% doesnt belong to anyone."

Config.DisableMouse                 = false
Config.DisableMovement              = true
Config.DisableCarMovement           = true
Config.DisableCombat                = true

Config.SQLOwnedVehicleTable         = 'owned_vehicles'
Config.SQLVehiclePlateColoumn       = 'plate'
Config.SQLVehicleOwnerColoumn       = 'owner'

Config.EnableirpCoreIdentity            = false
Config.SQLPlayerInfoTable           = 'users'
Config.SQLPlayerNameColoumn         = 'name'
Config.SQLPlayerIdentifierColoumn   = 'identifier'
Config.SQLPlayerFirstNameColoumn    = 'firstname'
Config.SQLPlayerLastNameColoumn     = 'lastname'
Config.SQLPlayerIsDeadColoumn       = 'is_dead'

Config.SQLChopInfoTable             = 'chopped_vehicles'
Config.SQLChopPlateColoumn          = 'plate'
Config.SQLChopCarOwnerColoumn       = 'ownername'
Config.SQLChopCarModelColoumn       = 'choppedcar'
Config.SQLChoppperNameColoumn       = 'choppername'
Config.SQLChoppperIdentifierColoumn = 'chopperidentifier'