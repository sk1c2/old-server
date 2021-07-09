Config                            = {}

Config.DrawDistance               = 100.0

Config.Marker                     = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }

Config.ReviveReward               = 50  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = false -- enable anti-combat logging?
Config.LoadIpl                    = false -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'en'

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer          = 5 * minute  -- Time til respawn is available
Config.BleedoutTimer              = 15 * minute -- Time til the player bleeds out

Config.EnablePlayerManagement     = true

Config.RemoveWeaponsAfterRPDeath  = false
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = true
Config.EarlyRespawnFineAmount     = 3000

Config.RespawnPoint = { coords = vector3(309.2561, -577.3947, 44.20394), heading = 48.5}

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(295.7, -583.3, 42.4),
			sprite = 61,
			scale  = 1.2,
			color  = 2
		}, 

		AmbulanceActions = {
			--vector3(305.9, -597.8, 42.4)
			vector3(304.43, -600.76, 42.29)
		},

		Pharmacies = {
			vector3(316.7, -588.1, 42.2)
		},

		Vehicles = {
			{
				Spawner = vector3(295.87, -602.074, 42.33),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 27, x = 1.0, y = 1.0, z = 1.0, r = 225, g = 0, b = 0, a = 200, rotate = true },
				SpawnPoints = {
					{ coords = vector3(288.5, -612.3, 43.3), heading = 74.4, radius = 4.0 },
					{ coords = vector3(288.5, -605.9, 43.3), heading = 74.4, radius = 4.0 },
					{ coords = vector3(277.6, -607.8, 43.3), heading = 100.9, radius = 6.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(343.27694702148,-580.04455566406,73.20),
				InsideShop = vector3(305.6, -1419.7, 41.5),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 255, g = 0, b = 0, a = 200, rotate = true },
				SpawnPoints = {
					{ coords = vector3(351.6, -587.9, 74.1), heading = 102.1, radius = 10.0 }
				}
			}
		},

		FastTravels = {
			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 138.6 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = "Fast Travel"
			},

			{
				From = vector3(349.7, -594.4, 66.1),
				To = { coords = vector3(349.7, -594.4, 66.1), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = "Fast Travel"
			}
		}

	}
}

Config.AuthorizedVehicles = {

	ambulance = {
		{ model = 'ambulance', label = 'Ambulance Van', price = 5},
		{ model = 'newhoe3', label = 'Tahoe', price = 5}
	},

	doctor = {
		{ model = 'ambulance', label = 'Ambulance Van', price = 5},
		{ model = 'newhoe3', label = 'Tahoe', price = 5}
	},

	chief_doctor = {
		{ model = 'ambulance', label = 'Ambulance Van', price = 5},
		{ model = 'newhoe3', label = 'Tahoe', price = 5}
	},

	boss = {
		{ model = 'ambulance', label = 'Ambulance Van', price = 5},
		{ model = 'newhoe3', label = 'Tahoe', price = 5}
	}

}

Config.AuthorizedHelicopters = {

	ambulance = {},

	doctor = {
		{ model = 'supervolito', label = 'EMS Chopper', price = 5 }
	},

	chief_doctor = {
		{ model = 'supervolito', label = 'EMS Chopper', price = 5 },
	},

	boss = {
		{ model = 'supervolito', label = 'EMS Chopper', price = 5 },
	}

}
