Config = {}

-- Police count and name
Config.MinPoliceCount  = 0
Config.Cooldown = 120 * 60000

-- Minutes
Config.CookTimerA = 4 -- prepare ingredients
Config.CookTimerB = 4 -- cook meth
Config.CookTimerC = 4 -- cool meth
Config.CookTimerD = 4 -- package meth

-- T
Config.HintLocation = vector3(-1487.062, -909.8878, 10.02359)
Config.HintHeading = 319.303802

-- Possible spawns
Config.TruckLocations = {
	{pos = vector3(981.26, 3613.09, 32.78), heading = 0.71},
	{pos = vector3(1417.77, 3740.65, 32.6), heading = 194.96},
	{pos = vector3(2506.39, 4215.37, 39.92), heading = 327.72},
	{pos = vector3(1939.94, 4637.87, 40.58), heading = 9268.84},
	{pos = vector3(1724.83, 4702.96, 42.52), heading = 89.8},
	{pos = vector3(1713.46, 4803.74, 41.77), heading = 104.36},
	{pos = vector3(2010.95, 4984.54, 41.2), heading = 224.75},
	{pos = vector3(2350.6, 4877.86, 41.82), heading = 45.46},
	{pos = vector3(289.42, 6791.77, 15.7), heading = 211.52},
	{pos = vector3(168.95, 6359.24, 31.44), heading = 296.49},
	{pos = vector3(-66.77, 6496.32, 31.49), heading = 140.57},
	{pos = vector3(-439.25, 6142.06, 34.48), heading = 228.23},
	{pos = vector3(1060.2, -2409.2, 29.9), heading = 90.0},
	{pos = vector3(-1102.3, -2039.8, 13.2), heading = 311.65},
	{pos = vector3(123.3, -2580.8, 6.0), heading = 0.0}
}

-- Possible dropoffs
Config.DropoffLocations = {
	vector3(-944.8, -897.76, 2.16),
	vector3(-1079.51, -2175.16, 13.28),
	vector3(91.85, -2212.83, 6.04),
	vector3(535.9, -1803.67, 28.44),
	vector3(192.46, -1847.06, 27.2),
	vector3(1568.23, -1847.52, 92.44),
	vector3(-446.43, -2445.19, 6),
	vector3(3324.19, 5147, 18.29),
	vector3(2461.03, 3446.71, 49.86),
	vector3(790.83, 1282.01, 360.3),
	vector3(2787.54, -725.76, 6.16),
	vector3(1051.86, -2468, 28.5),
	vector3(-1832.25, 4810.16, 4.56)
}

Config.DestroyLocations = {
	vector3(-313.2, -1539.5, 27.8)
}

-- Models
Config.TruckModels = {
	'speedo'
}

-- Draw text at this distance
Config.DrawTextDistance = 30.0

-- How long the note hangs around for (when knocking on door)
Config.NotificationTime = 10

-- How long police have to track a notification (seconds)
Config.TrackableNotifyTimer = 120

-- Spawn truck at x meters
Config.TruckSpawnDistance = 50.0

-- Veh speed
Config.MinSpeedtoCook = 80.00

-- Vehicle can stop for x amount of seconds before police get notified
Config.MaxVehicleStopTime = 60
