RegisterNetEvent('FinishMoneyCheckForVeh')
RegisterNetEvent('vehshop:spawnVehicle')
local vehshop_blips = {}
local financedPlates = {}
local buyPlate = {}
local inrangeofvehshop = false
local currentlocation = nil
local boughtcar = false
local vehicle_price = 0
local backlock = false
local firstspawn = 0
local commissionbuy = 0
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
local currentCarSpawnLocation = 0
local ownerMenu = false

local vehshopDefault = {
	opened = false,
	title = "Vehicle Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Vehicles", description = ""},
				{name = "Cycles", description = ""},
			}
		},
		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {
				{name = "Job Vehicles", description = ''},
			}
		},
		["jobvehicles"] = {
			title = "job vehicles",
			name = "job vehicles",
			buttons = {
				{name = "Taxi Cab", costs = 4000, description = {}, model = "taxi"},
				{name = "Flat Bed", costs = 4000, description = {}, model = "flatbed"},
				{name = "News Rumpo", costs = 4000, description = {}, model = "rumpo"},
			}
		},
		["cycles"] = {
			title = "cycles",
			name = "cycles",
			buttons = {
				{name = "BMX", costs = 150, description = {}, model = "bmx"},
				{name = "Cruiser", costs = 240, description = {}, model = "cruiser"},
				{name = "Fixter", costs = 270, description = {}, model = "fixter"},
				{name = "Scorcher", costs = 300, description = {}, model = "scorcher"},
				{name = "Pro 1", costs = 2500, description = {}, model = "tribike"},
				{name = "Pro 2", costs = 2600, description = {}, model = "tribike2"},
				{name = "Pro 3", costs = 2900, description = {}, model = "tribike3"},
			}
		},		
	}
}

vehshop = vehshopDefault
local vehshopOwner = {
	opened = false,
	title = "Vehicle Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Vehicles", description = ""},
				{name = "Motorcycles", description = ""},
				{name = "Cycles", description = ""},
			}
		},
		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {
				{name = "Job Vehicles", description = ''},
				{name = "Compacts", description = ''},
				{name = "Coupes", description = ''},
				{name = "Sedans", description = ''},
				{name = "Sports", description = ''},
				{name = "Sports Classics", description = ''},
				{name = "Muscle", description = ''},
				{name = "Off-Road", description = ''},
				{name = "SUVs", description = ''},
				{name = "Vans", description = ''},
			}
		},
		["jobvehicles"] = {
			title = "job vehicles",
			name = "job vehicles",
			buttons = {
				{name = "Taxi Cab", costs = 400, description = {}, model = "taxi"},
				{name = "Flat Bed", costs = 10000, description = {}, model = "flatbed"},
				{name = "Towtruck", costs = 10000, description = {}, model = "towtruck"},
				{name = "Towtruck 2", costs = 10000, description = {}, model = "towtruck2"},
				{name = "News Rumpo", costs = 400, description = {}, model = "rumpo"},
				{name = "Taco Truck", costs = 1000, description = {}, model = "taco2"},
			}
		},
		["compacts"] = {
			title = "compacts",
			name = "compacts",
			buttons = {			
				{name = "Blista", costs = 3500, description = {}, model = "blista"},
				{name = "Brioso R/A", costs = 6500, description = {}, model = "brioso"},
				{name = "Dilettante", costs = 2000, description = {}, model = "Dilettante"},
				{name = "Issi", costs = 5600, description = {}, model = "issi2"},
				{name = "Panto", costs = 1500, description = {}, model = "panto"},
				{name = "Prairie", costs = 1500, description = {}, model = "prairie"},
				{name = "Rhapsody", costs = 500, description = {}, model = "rhapsody"},
				{name = "Caddy 1", costs = 1000, description = {}, model = "caddy"},
				{name = "Caddy 2", costs = 1000, description = {}, model = "caddy2"},
				{name = "Caddy 3", costs = 1000, description = {}, model = "caddy3"},
	
			}
		},
		["coupes"] = {
			title = "coupes",
			name = "coupes",
			buttons = {
				{name = "Cognoscenti Cabrio", costs = 10000, description = {}, model = "cogcabrio"},
				{name = "Exemplar", costs = 14500, description = {}, model = "exemplar"},
				{name = "F620", costs = 15500, description = {}, model = "f620"},
				{name = "Felon", costs = 13500, description = {}, model = "felon"},
				{name = "Felon GT", costs = 1550, description = {}, model = "felon2"},
				{name = "Jackal", costs = 18500, description = {}, model = "jackal"},
				{name = "Oracle", costs = 12500, description = {}, model = "oracle"},
				{name = "Oracle XS", costs = 12500, description = {}, model = "oracle2"},
				{name = "Sentinel", costs = 17500, description = {}, model = "sentinel"},
				{name = "Sentinel XS", costs = 17500, description = {}, model = "sentinel2"},
				{name = "Windsor", costs = 45000, description = {}, model = "windsor"},
				{name = "Windsor Drop", costs = 45000, description = {}, model = "windsor2"},
				{name = "Zion", costs = 20000, description = {}, model = "zion"},
				{name = "Zion Cabrio", costs = 15000, description = {}, model = "zion2"},
			}
		},
		["sports"] = {
			title = "sports",
			name = "sports",
			buttons = {
				{name = "9F", costs = 60000, description = {}, model = "ninef"},
				{name = "9F Cabrio", costs = 60000, description = {}, model = "ninef2"},
				{name = "Alpha", costs = 15000, description = {}, model = "alpha"},
				{name = "Banshee", costs = 75000, description = {}, model = "banshee"},
				{name = "Bestia GTS", costs = 48000, description = {}, model = "bestiagts"},
				{name = "Buffalo", costs = 15000, description = {}, model = "buffalo"},
				{name = "Buffalo S", costs = 30000, description = {}, model = "buffalo2"},
				{name = "Carbonizzare", costs = 125000, description = {}, model = "carbonizzare"},
				{name = "Comet", costs = 65000, description = {}, model = "comet2"},
				{name = "Coquette", costs = 60000, description = {}, model = "coquette"},
				{name = "GB200", costs = 25000, description = {}, model = "gb200"},
				{name = "Jester 3", costs = 50000, description = {}, model = "jester3"}, 
				{name = "Feltzer", costs = 75000, description = {}, model = "feltzer2"}, 
				{name = "Furore GT", costs = 30000, description = {}, model = "furoregt"},
				{name = "Fusilade", costs = 15000, description = {}, model = "fusilade"},
				{name = "Itali GTO", costs = 125000, description = {}, model = "italigto"},
				{name = "Schlagen GT", costs = 85000, description = {}, model = "schlagen"}, 
				{name = "Jester", costs = 135000, description = {}, model = "jester"}, 
				{name = "Kuruma", costs = 35000, description = {}, model = "kuruma"},
				{name = "Penetrator", costs = 75000, description = {}, model = "penetrator"},
				{name = "Reaper", costs = 85000, description = {}, model = "reaper"}, 
				{name = "Lynx", costs = 55000, description = {}, model = "lynx"}, 
				{name = "Massacro", costs = 60000, description = {}, model = "massacro"},
				{name = "Omnis", costs = 125000, description = {}, model = "omnis"},
				{name = "Penumbra", costs = 12500, description = {}, model = "penumbra"},
				{name = "Rapid GT", costs = 37500, description = {}, model = "rapidgt"},
				{name = "Rapid GT Convertible", costs = 37500, description = {}, model = "rapidgt2"},
				{name = "Schafter V12", costs = 45000, description = {}, model = "schafter3"},
				{name = "Sultan", costs = 22000, description = {}, model = "sultan"},
				{name = "SultanRS", costs = 350000, description = {}, model = "sultanrs"},
				{name = "Surano", costs = 65000, description = {}, model = "surano"},
				{name = "Tropos", costs = 25000, description = {}, model = "tropos"},
				{name = "Verkierer", costs = 43500, description = {}, model = "verlierer2"},
				{name = "Comet SR", costs = 110000, description = {}, model = "comet5"},
				{name = "Sentinel Classic", costs = 36500, description = {}, model = "sentinel3"},
				{name = "Streiter", costs = 75000, description = {}, model = "streiter"},
				{name = "Comet Safari", costs = 96500, description = {}, model = "comet4"},
				{name = "Pariah", costs = 75000, description = {}, model = "pariah"},
				{name = "Elegy", costs = 175000, description = {}, model = "elegy2"},
				{name = "Adder", costs = 200000, description = {}, model = "adder"},
				{name = "Bullet", costs = 125000, description = {}, model = "bullet"},
				{name = "Cheetah", costs = 165000, description = {}, model = "cheetah"},
			}
		},
		["sportsclassics"] = {
			title = "sports classics",
			name = "sportsclassics",
			buttons = {
				{name = "Casco", costs = 182500, description = {}, model = "casco"},
				{name = "Coquette Classic", costs = 60000, description = {}, model = "coquette2"},
				{name = "JB 700", costs = 55000, description = {}, model = "jb700"},
				{name = "Pigalle", costs = 10000, description = {}, model = "pigalle"},
				{name = "Stinger", costs = 148000, description = {}, model = "stinger"},
				{name = "Stinger GT", costs = 125000, description = {}, model = "stingergt"},
				{name = "Stirling GT", costs = 65000, description = {}, model = "feltzer3"},
				{name = "Rapid GT Classic", costs = 45000, description = {}, model = "rapidgt3"},
				{name = "Retinue", costs = 115500, description = {}, model = "retinue"},
				{name = "Viseris", costs = 102000, description = {}, model = "viseris"}, 
				{name = "Omnis", costs = 95000, description = {}, model = "omnis"}, 
				{name = "190z", costs = 85000, description = {}, model = "z190"}, 
				{name = "btype", costs = 188069, description = {}, model = "btype"},
				{name = "GT500", costs = 100000, description = {}, model = "gt500"},
				{name = "Savestra", costs = 98500, description = {}, model = "savestra"},
				{name = "Elegy Retro Custom", costs = 450000, description = {}, model = "elegy"},
			}
		},
		["casino"] = {
			title = "casino",
			name = "casino",
			buttons = {
--				{name = "Jugular", costs = 175000, description = {}, model = "jugular"},
--				{name = "Peyote", costs = 75000, description = {}, model = "peyote2"},
--				{name = "Gauntlet 4", costs = 150000, description = {}, model = "gauntlet4"},
--				{name = "Caracara", costs = 190000, description = {}, model = "caracara2"},
--				{name = "Novak", costs = 140000, description = {}, model = "Novak"},
--				{name = "Issi 7", costs = 200000, description = {}, model = "issi7"},
--				{name = "Hellion", costs = 110000, description = {}, model = "hellion"},
--				{name = "Dynasty", costs = 110000, description = {}, model = "Dynasty"},
--				{name = "Gauntlet 3", costs = 130000, description = {}, model = "gauntlet3"},
--				{name = "Nebula", costs = 83000, description = {}, model = "nebula"},
--				{name = "Zion 3", costs = 75000, description = {}, model = "zion3"},
--				{name = "Drafter", costs = 140000, description = {}, model = "drafter"},
--				{name = "Komoda", costs = 195000, description = {}, model = "komoda"},
--				{name = "Rebla", costs = 110000, description = {}, model = "rebla"},
--				{name = "Retinue", costs = 80000, description = {}, model = "retinue2"},
--				{name = "Sugoi", costs = 105000, description = {}, model = "sugoi"},
--				{name = "Sultan 2", costs = 155000, description = {}, model = "sultan2"},
--				{name = "VSTR", costs = 186000, description = {}, model = "vstr"},



			}
		},
		
		["muscle"] = {
			title = "muscle",
			name = "muscle",
			buttons = {
				{name = "Blade", costs = 22000, description = {}, model = "blade"},
				{name = "Buccaneer", costs = 24000, description = {}, model = "buccaneer"},
				{name = "Chino", costs = 26000, description = {}, model = "chino"},
				{name = "Coquette BlackFin", costs = 46500, description = {}, model = "coquette3"},
				{name = "Dominator", costs = 28500, description = {}, model = "dominator"},
				{name = "Dukes", costs = 36500, description = {}, model = "dukes"},
				{name = "Gauntlet", costs = 26500, description = {}, model = "gauntlet"},
				{name = "Faction", costs = 20000, description = {}, model = "faction"},
				{name = "Picador", costs = 10000, description = {}, model = "picador"},
				{name = "Sabre Turbo", costs = 24000, description = {}, model = "sabregt"},
				{name = "Nightshade", costs = 100000, description = {}, model = "nightshade"},
				{name = "Tampa", costs = 18500, description = {}, model = "tampa"}, 
				{name = "Virgo", costs = 22000, description = {}, model = "virgo"},
				{name = "Vigero", costs = 23000, description = {}, model = "vigero"},
				{name = "Elliie", costs = 49500, description = {}, model = "ellie"},
				{name = "Phoenix", costs = 12500, description = {}, model = "phoenix"},
				{name = "Slam Van", costs = 30000, description = {}, model = "slamvan"},
				{name = "Yosemite", costs = 33500, description = {}, model = "yosemite"},
				{name = "Tulip", costs = 27600, description = {}, model = "tulip"},
				{name = "Vamos", costs = 27600, description = {}, model = "vamos"},
			}
		},
		["offroad"] = {
			title = "off-road",
			name = "off-road",
			buttons = {
				{name = "Bifta", costs = 15000, description = {}, model = "bifta"},
				{name = "Blazer", costs = 7000, description = {}, model = "blazer"},
				{name = "Brawler", costs = 40000, description = {}, model = "brawler"},
				{name = "Dune Buggy", costs = 10000, description = {}, model = "dune"},
				{name = "Rebel", costs = 12500, description = {}, model = "rebel2"},
				{name = "Sandking", costs = 26500, description = {}, model = "sandking"},
				{name = "Kamacho", costs = 46500, description = {}, model = "kamacho"},
				{name = "Dubsta 6x6", costs = 95000, description = {}, model = "dubsta3"}, 
			}
		},
		["suvs"] = {
			title = "suvs",
			name = "suvs",
			buttons = {
				{name = "Cavalcade", costs = 15000, description = {}, model = "cavalcade2"},
				{name = "Granger", costs = 23500, description = {}, model = "granger"},
				{name = "Huntley S", costs = 8500, description = {}, model = "huntley"},
				{name = "Landstalker", costs = 26700, description = {}, model = "landstalker"},
				{name = "Radius", costs = 8500, description = {}, model = "radi"},
				{name = "Rocoto", costs = 24000, description = {}, model = "rocoto"},
				{name = "Seminole", costs = 10500, description = {}, model = "seminole"},
				{name = "XLS", costs = 51500, description = {}, model = "xls"},
				{name = "Dubsta", costs = 42500, description = {}, model = "dubsta"},
				{name = "Patriot", costs = 36500, description = {}, model = "patriot"},
				{name = "Gresley", costs = 12500, description = {}, model = "gresley"},
				{name = "Toros", costs = 250000, description = {}, model = "toros"},
			}
		},
		["vans"] = {
			title = "vans",
			name = "vans",
			buttons = {
				{name = "Bison", costs = 2500, description = {}, model = "bison"},
				{name = "Bobcat XL", costs = 9500, description = {}, model = "bobcatxl"},
				{name = "Gang Burrito", costs = 8500, description = {}, model = "gburrito"},
				{name = "Journey", costs = 6500, description = {}, model = "journey"},
				{name = "Minivan", costs = 850, description = {}, model = "minivan"},
				{name = "Paradise", costs = 13765, description = {}, model = "paradise"},
				{name = "Surfer", costs = 9500, description = {}, model = "surfer"},
				{name = "Youga", costs = 14500, description = {}, model = "youga"},
				{name = "Moonbeam", costs = 12500, description = {}, model = "moonbeam"},
				{name = "Camper", costs = 13500, description = {}, model = "camper"},
			}
		},
		["sedans"] = {
			title = "sedans",
			name = "sedans",
			buttons = {
				{name = "Emperor", costs = 7000, description = {}, model = "emperor2"},
				{name = "Tornado", costs = 9000, description = {}, model = "tornado3"},
				{name = "Bodhi", costs = 5000, description = {}, model = "bodhi2"},		
				{name = "Asea", costs = 9500, description = {}, model = "asea"},
				{name = "Asterope", costs = 10000, description = {}, model = "asterope"},
				{name = "Fugitive", costs = 30000, description = {}, model = "fugitive"},
				{name = "Glendale", costs = 7500, description = {}, model = "glendale"},
				{name = "Intruder", costs = 25000, description = {}, model = "intruder"},
				{name = "Premier", costs = 9000, description = {}, model = "premier"},
				{name = "Regina", costs = 32000, description = {}, model = "regina"},
				{name = "Schafter", costs = 32500, description = {}, model = "schafter2"},
				{name = "Stanier", costs = 10000, description = {}, model = "stanier"},
				{name = "Stratum", costs =35260, description = {}, model = "stratum"},
				{name = "Super Diamond", costs = 50000, description = {}, model = "superd"},
				{name = "Warrener", costs = 36500, description = {}, model = "warrener"},
				{name = "Washington", costs = 18000, description = {}, model = "washington"},
				{name = "Tailgater", costs = 36500, description = {}, model = "tailgater"},
				{name = "Cognoscenti", costs = 30000, description = {}, model = "cognoscenti"},
			}
		},
		["motorcycles"] = {
			title = "MOTORCYCLES",
			name = "motorcycles",
			buttons = {		
				{name = "Akuma", costs = 9650, description = {}, model = "AKUMA"},
				{name = "Bagger", costs = 2750, description = {}, model = "bagger"},
				{name = "Bati 801", costs = 16500, description = {}, model = "bati"},
				{name = "BF400", costs = 8750, description = {}, model = "bf400"},
				{name = "Carbon RS", costs = 17500, description = {}, model = "carbonrs"},
				{name = "Daemon", costs = 12650, description = {}, model = "daemon"},
				{name = "Enduro", costs = 8950, description = {}, model = "enduro"},
				{name = "Faggio", costs = 250, description = {}, model = "faggio"},
				{name = "Gargoyle", costs = 18500, description = {}, model = "gargoyle"},
				{name = "Hexer", costs = 10500, description = {}, model = "hexer"},
				{name = "Innovation", costs = 10000, description = {}, model = "innovation"},
				{name = "Nemesis", costs = 5000, description = {}, model = "nemesis"},
				{name = "PCJ-600", costs = 1500, description = {}, model = "pcj"},
				{name = "Ruffian", costs = 7950, description = {}, model = "ruffian"},
				{name = "Sanchez", costs = 2650, description = {}, model = "sanchez"},
				{name = "Sovereign", costs = 12500, description = {}, model = "sovereign"},
				{name = "Zombiea", costs = 8659, description = {}, model = "zombiea"},
				{name = "Hakuchou 2", costs = 45000, description = {}, model = "hakuchou2"},
				{name = "Vespa", costs = 800, description = {}, model = "faggio2"}, 
				{name = "Manchez", costs = 3560, description = {}, model = "manchez"},
				{name = "Vortex", costs = 5697, description = {}, model = "vortex"},
				{name = "Avarus", costs = 16354, description = {}, model = "avarus"},
				{name = "Vader", costs = 12500, description = {}, model = "vader"},
				{name = "Esskey", costs = 16500, description = {}, model = "esskey"},
				{name = "Defiler", costs = 6485, description = {}, model = "defiler"},
				{name = "Chimera", costs = 16500, description = {}, model = "chimera"},
				{name = "Daemon", costs = 13500, description = {}, model = "daemon"},
				{name = "DaemonHigh", costs = 13500, description = {}, model = "daemon2"},
			}
		},
		["cycles"] = {
			title = "cycles",
			name = "cycles",
			buttons = {
				{name = "BMX", costs = 550, description = {}, model = "bmx"},
				{name = "Cruiser", costs = 240, description = {}, model = "cruiser"},
				{name = "Fixter", costs = 270, description = {}, model = "fixter"},
				{name = "Scorcher", costs = 300, description = {}, model = "scorcher"},
				{name = "Pro 1", costs = 600, description = {}, model = "tribike"},
				{name = "Pro 2", costs = 600, description = {}, model = "tribike2"},
				{name = "Pro 3", costs = 600, description = {}, model = "tribike3"},
			}
		},
	}
}




local fakecar = {model = '', car = nil}
local vehshop_locations = {
	{
		entering = {-33.737,-1102.322,26.422},
		inside = {-61.166320800781,-1107.8854980469,26.43579864502,76.141090393066},
		outside = {-61.166320800781,-1107.8854980469,26.43579864502,76.141090393066},
	}
}

local carspawns = {
	[1] =  { ['x'] = -38.25,['y'] = -1104.18,['z'] = 26.43,['h'] = 14.46, ['info'] = ' Car Spot 1' },
	[2] =  { ['x'] = -36.36,['y'] = -1097.3,['z'] = 26.43,['h'] = 109.4, ['info'] = ' Car Spot 2' },
	[3] =  { ['x'] = -43.11,['y'] = -1095.02,['z'] = 26.43,['h'] = 67.77, ['info'] = ' Car Spot 3' },
	[4] =  { ['x'] = -50.45,['y'] = -1092.66,['z'] = 26.43,['h'] = 116.33, ['info'] = ' Car Spot 4' },
	[5] =  { ['x'] = -56.24,['y'] = -1094.33,['z'] = 26.43,['h'] = 157.08, ['info'] = ' Car Spot 5' },
	[6] =  { ['x'] = -49.73,['y'] = -1098.63,['z'] = 26.43,['h'] = 240.99, ['info'] = ' Car Spot 6' },
	[7] =  { ['x'] = -45.58,['y'] = -1101.4,['z'] = 26.43,['h'] = 287.3, ['info'] = ' Car Spot 7' },
}

local carTable = {
	[1] = { ["model"] = "gauntlet", ["baseprice"] = 100000, ["commission"] = 15 }, 
	[2] = { ["model"] = "dubsta3", ["baseprice"] = 100000, ["commission"] = 15 },
	[3] = { ["model"] = "landstalker", ["baseprice"] = 100000, ["commission"] = 15 },
	[4] = { ["model"] = "bobcatxl", ["baseprice"] = 100000, ["commission"] = 15 },
	[5] = { ["model"] = "surfer", ["baseprice"] = 100000, ["commission"] = 15 },
	[6] = { ["model"] = "glendale", ["baseprice"] = 100000, ["commission"] = 15 },
	[7] = { ["model"] = "washington", ["baseprice"] = 100000, ["commission"] = 15 },
}

function updateCarTable(model,price,name)
	carTable[currentCarSpawnLocation]["model"] = model
	carTable[currentCarSpawnLocation]["baseprice"] = price
	carTable[currentCarSpawnLocation]["name"] = name
	TriggerServerEvent("carshop:table",carTable)
end

local myspawnedvehs = {}

RegisterNetEvent("car:testdrive")
AddEventHandler("car:testdrive", function()
	local myJob = exports['isPed']:isPed('job')
	if myJob == 'PDM' or #(vector3(-51.51, -1077.96, 26.92) - GetEntityCoords(PlayerPedId())) > 50.0 then

	local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.000, 0, 70)
	if not DoesEntityExist(veh) then
		TriggerEvent('DoLongHudText', 'Could not locate vehicle!', 2)
		return
	end

	local model = GetEntityModel(veh)
	local veh = GetClosestVehicle(-51.51, -1077.96, 26.92, 3.000, 0, 70)

	if not DoesEntityExist(veh) then

		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model,-51.51, -1077.96, 26.92,80.0,true,false)
		local vehplate = "CAR"..math.random(10000,99999)
		SetVehicleNumberPlateText(veh, vehplate)
		local plate = GetVehicleNumberPlateText(veh, vehplate)
		Citizen.Wait(100)
		TriggerServerEvent('garage:addKeys', plate)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)

		TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
		myspawnedvehs[veh] = true
		end
	else
		TriggerEvent('DoLongHudText', 'A car is on the spawn point.', 2)
	end
end)

RegisterNetEvent("finance")
AddEventHandler("finance", function()
	if #(vector3(-51.51, -1077.96, 26.92) - GetEntityCoords(PlayerPedId())) > 50.0 then
		return
	end

	local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.000, 0, 70)
	if not DoesEntityExist(veh) then
		TriggerEvent('DoLongHudText', 'Could not locate vehicle!', 2)
		return
	end
	local vehplate = GetVehicleNumberPlateText(veh)
	TriggerServerEvent("finance:enable",vehplate)
end)

RegisterNetEvent("buyEnable")
AddEventHandler("buyEnable", function()
	local myJob = exports['isPed']:isPed('job')
	if #(vector3(-51.51, -1077.96, 26.92) - GetEntityCoords(PlayerPedId())) > 50.0 and myJob == 'PDM' then
		return
	end

	local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.000, 0, 70)
	if not DoesEntityExist(veh) then
		TriggerEvent('DoLongHudText', 'Could not locate vehicle!', 2)
		return
	end
	local vehplate = GetVehicleNumberPlateText(veh)
	TriggerServerEvent("buy:enable",vehplate)
end)

RegisterNetEvent("finance:enableOnClient")
AddEventHandler("finance:enableOnClient", function(addplate)
	financedPlates[addplate] = true
	Citizen.Wait(60000)
	financedPlates[addplate] = nil
end)

RegisterNetEvent("buy:enableOnClient")
AddEventHandler("buy:enableOnClient", function(addplate)
	buyPlate[addplate] = true
	Citizen.Wait(60000)
	buyPlate[addplate] = nil
end)

RegisterNetEvent("commission")
AddEventHandler("commission", function(newAmount)
	local myJob = exports['isPed']:isPed('job')
	if myJob == 'PDM' or #(vector3(-51.51, -1077.96, 26.92) - GetEntityCoords(PlayerPedId())) > 50.0 then
	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			carTable[i]["commission"] = 15
			TriggerServerEvent("carshop:table",carTable)
			end
		end
	end
end)

RegisterNetEvent("veh_shop:returnTable")
AddEventHandler("veh_shop:returnTable", function(newTable)
	carTable = newTable
	DespawnSaleVehicles()
	SpawnSaleVehicles()
end)

local hasspawned = false
local spawnedvehicles = {}
local vehicles_spawned = false

function BuyMenu()
	for i = 1, #carspawns do

		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			local veh = GetClosestVehicle(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], 3.000, 0, 70)
			local addplate = GetVehicleNumberPlateText(veh)
			if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= nil and GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 then
				ClearPedTasksImmediately(PlayerPedId())
			end
			DisableControlAction(0,23)
			if IsControlJustReleased(0,47) and buyPlate[addplate] ~= nil then
				TriggerEvent('DoLongHudText', 'Attempting Purchase', 1)
				AttemptBuy(i,false)
			end

			if IsControlJustReleased(0,23) or IsDisabledControlJustReleased(0,23) then
				if financedPlates[addplate] ~= nil then
					TriggerEvent('DoLongHudText', 'Attempting Purchase', 1)
					AttemptBuy(i,true)
				end
			end
		end
	end
end

function GetClosestPlayer()
	local entity = GetNearestPlayerToEntity(GetPlayerPed(PlayerId()))
	if entity ~= nil then
		return GetPlayerServerId(entity)
	else
		return -1
	end
end

function AttemptBuy(tableid,financed)

	local veh = GetClosestVehicle(carspawns[tableid]["x"],carspawns[tableid]["y"],carspawns[tableid]["z"], 3.000, 0, 70)
	if not DoesEntityExist(veh) then
		TriggerEvent('DoLongHudText', 'Could not locate vehicle!', 2)
		return
	end

	if financed then
--		print("financed")
	end

	local model = carTable[tableid]["model"]
	local commission = carTable[tableid]["commission"]
	local baseprice = carTable[tableid]["baseprice"]
	local name = carTable[tableid]["name"]
	local price = baseprice + (baseprice * commission/ 100)

	currentlocation = vehshop_blips[1]
	local pdmdealer = GetClosestPlayer()
	Citizen.Wait(100)
	TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
	TriggerServerEvent('CheckMoneyForVeh',name, model, price, financed, exports['isPed']:isPed('cid'), pdmdealer)
	commissionbuy = (baseprice * commission / 200)
end

function OwnerMenu()
	if not vehshop.opened then
		currentCarSpawnLocation = 0
		ownerMenu = false
	end
	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			ownerMenu = true
			currentCarSpawnLocation = i
			if IsControlJustReleased(0,38) then
				TriggerEvent('DoLongHudText', 'We Opened', 1)
				if vehshop.opened then
					CloseCreator()
				else
					OpenCreator()
				end
			end
		end
	end
end

function DrawPrices()
	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.5 then
			local commission = carTable[i]["commission"]
			local baseprice = carTable[i]["baseprice"]
			local price = baseprice + (baseprice * commission/100)
			local myJob = exports['isPed']:isPed('job')
			local veh = GetClosestVehicle(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], 3.000, 0, 70)
			local addplate = GetVehicleNumberPlateText(veh)
			if myJob == 'PDM' then
				if financedPlates[addplate] ~= nil and buyPlate[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " | Com: %" ..commission.. " | [E] to change | [G] to buy | [F] to Finance ")
				elseif financedPlates[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], "$" .. math.ceil(price/1.5) .. " upfront, $" .. math.ceil(price) .. " | Com: %" ..commission.. " | [E] to change | [F] to Finance ")
				elseif buyPlate[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " | Com: %" ..commission.. " | [E] to change | [G] to buy. ")
				else
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " | Com: %" ..commission.. " | [E] to change")
				end
			else
				if financedPlates[addplate] ~= nil and buyPlate[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " [G] to buy | $" .. math.ceil(price/1.5) .. " upfront, $" .. math.ceil(price) .. " over 10 weeks, [F] to finance. ")
				elseif financedPlates[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], "$" .. math.ceil(price/1.5) .. " upfront, $" .. math.ceil(price) .. " over 10 weeks, [F] to finance. ")
				elseif buyPlate[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " [G] to buy. ")
				else
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"Buy Price: $" .. math.ceil(price) .. " ")
				end
			end
		end
	end
end

function DrawText3D(x,y,z, text)
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
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function SpawnSaleVehicles()
	if not hasspawned then
		TriggerServerEvent("carshop:requesttable")
		Citizen.Wait(1500)
	end
	DespawnSaleVehicles(true)
	hasspawned = true
	for i = 1, #carTable do
		local model = GetHashKey(carTable[i]["model"])
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model,carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]-1,carspawns[i]["h"],false,false)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)

		FreezeEntityPosition(veh,true)
		spawnedvehicles[#spawnedvehicles+1] = veh
		SetVehicleNumberPlateText(veh, i .. "CARSALE")
	end
	vehicles_spawned = true
end

function DespawnSaleVehicles(pDontWait)
	if pDontWait == nil and not pDontWait then
		Wait(15000)
	end
	for i = 1, #spawnedvehicles do
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(spawnedvehicles[i]))
	end
	vehicles_spawned = false
end

Controlkey = {["generalUse"] = {38,"E"},["generalUseSecondary"] = {191,"Enter"}}
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["generalUse"] = table["generalUse"]
	Controlkey["generalUseSecondary"] = table["generalUseSecondary"]
end)

--[[Functions]]--

function LocalPed()
	return PlayerPedId()
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function IsPlayerInRangeOfVehshop()
	return inrangeofvehshop
end

function ShowVehshopBlips(bool)
	if bool and #vehshop_blips == 0 then
		for station,pos in pairs(vehshop_locations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			-- 60 58 137
			SetBlipSprite(blip,326)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Vehicle Shop')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			SetBlipScale(blip, 0.6)
			SetBlipColour(blip, 3)
			vehshop_blips[#vehshop_blips+1]= {blip = blip, pos = loc}
		end
		Citizen.CreateThread(function()
			while #vehshop_blips > 0 do
				Citizen.Wait(1)
				local inrange = false
				local myJob = exports['isPed']:isPed('job')
				if myJob == 'PDM' then
					if #(vector3(-45.98,-1082.97, 26.27) - GetEntityCoords(LocalPed())) < 5.0 then
						local veh = GetVehiclePedIsUsing(LocalPed())
							DrawText3D(-45.98,-1082.97, 26.27,"["..Controlkey["generalUse"][2].."] Return Vehicle")
							DrawMarker(36,-45.98,-1082.97, 26.27, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255,105,180, 35, 1, 1, 2, 0, 0, 0, 0)
							if IsControlJustReleased(0,Controlkey["generalUse"][1]) then
								Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
							end
					end
				end

				for i,b in ipairs(vehshop_blips) do
					if #(vector3(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]) - GetEntityCoords(LocalPed())) < 50 then
						currentlocation = b
						if not vehicles_spawned then
--							print("Spawning Display Vehicles?")
							SpawnSaleVehicles()
						end
						if #(vector3(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]) - GetEntityCoords(LocalPed())) < 25 then
							DrawPrices()
						end

						if myJob == 'PDM' then
							OwnerMenu()
						end
						BuyMenu()
					else
						if vehicles_spawned then
--							print("Despawning Display ?")
							DespawnSaleVehicles()
						end
						Citizen.Wait(1000)
					end
				end
				inrangeofvehshop = inrange
			end
		end)
	elseif bool == false and #vehshop_blips > 0 then
		for i,b in ipairs(vehshop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		vehshop_blips = {}
	end
end

function f(n)
	return n + 0.0001
end

function try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function OpenCreator()
	boughtcar = false
	if ownerMenu then
		vehshop = vehshopOwner
	else
		vehshop = vehshopDefault
	end

	local ped = LocalPed()
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])

	vehshop.currentmenu = "main"
	vehshop.opened = true
	vehshop.selectedbutton = 0
end

function CloseCreator(name, veh, price, financed)
	Citizen.CreateThread(function()
		local ped = LocalPed()
		local pPrice = price
		if not boughtcar then
			local pos = currentlocation.pos.entering
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
		else
			local name = name	
			local vehicle = veh
			local price = price		
			local veh = GetVehiclePedIsUsing(ped)
			local model = GetEntityModel(veh)
			local colors = table.pack(GetVehicleColours(veh))
			local extra_colors = table.pack(GetVehicleExtraColours(veh))

			local mods = {}
			for i = 0,24 do
				mods[i] = GetVehicleMod(veh,i)
			end
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
			local pos = currentlocation.pos.outside

			FreezeEntityPosition(ped,false)
			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(0)
			end
			personalvehicle = CreateVehicle(model,pos[1],pos[2],pos[3],pos[4],true,false)
			SetModelAsNoLongerNeeded(model)

			if name == "rumpo" then
				SetVehicleLivery(personalvehicle,0)
			end

			if name == "taxi" then
				SetVehicleExtra(personalvehicle, 8, 0)
				SetVehicleExtra(personalvehicle, 9, 0)
				SetVehicleExtra(personalvehicle, 5, 1)
			end



			for i,mod in pairs(mods) do
				SetVehicleModKit(personalvehicle,0)
				SetVehicleMod(personalvehicle,i,mod)
			end

			SetVehicleOnGroundProperly(personalvehicle)

			local plate = GetVehicleNumberPlateText(personalvehicle)
			SetVehicleHasBeenOwnedByPlayer(personalvehicle,true)
			local id = NetworkGetNetworkIdFromEntity(personalvehicle)
			SetNetworkIdCanMigrate(id, true)
			Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
			SetVehicleColours(personalvehicle,colors[1],colors[2])
			SetVehicleExtraColours(personalvehicle,extra_colors[1],extra_colors[2])
			TaskWarpPedIntoVehicle(PlayerPedId(),personalvehicle,-1)
			SetEntityVisible(ped,true)			
			local primarycolor = colors[1]
			local secondarycolor = colors[2]	
			local pearlescentcolor = extra_colors[1]
			local wheelcolor = extra_colors[2]
			local VehicleProps = exports['wrp-base']:FetchVehProps(personalvehicle)
			local model = GetEntityModel(personalvehicle)
			print(model)
			TriggerServerEvent('garage:addKeys', plate)
			local LocalPlayer = exports["wrp-base"]:getModule("LocalPlayer")
			local Player = LocalPlayer:getCurrentCharacter()
			local firstname = Player.first_name .. ' ' .. Player.last_name
			TriggerServerEvent('BuyForVeh', plate, name, model, vehicle, price, VehicleProps, financed, firstname, exports['isPed']:isPed('cid'))
			DespawnSaleVehicles()
			SpawnSaleVehicles()
		end
		vehshop.opened = false
		vehshop.menu.from = 1
		vehshop.menu.to = 10
	end)
end


RegisterNetEvent("carshop:failedpurchase")
AddEventHandler("carshop:failedpurchase", function()
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	TaskLeaveVehicle(PlayerPedId(),veh,0)
end)


function drawMenuButton(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,255,55,55,220)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,250)
	DrawText(0.255, 0.254)
end

function drawMenuRight(txt,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.2, 0.2)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(250,250,250, 255)
	end

	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 + 0.025, y - menu.height/3 + 0.0002)

	if selected then
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,255,255,255,255)
	else
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,255,55,55,220)
	end
end

function drawMenuTitle(txt,x,y)
	local menu = vehshop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)

	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,250)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function ButtonSelected(button)
	local ped = PlayerPedId()
	local this = vehshop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Vehicles" then
			OpenMenu('vehicles')
		elseif btn == "Motorcycles" then
			OpenMenu('motorcycles')
		elseif btn == "Cycles" then
			OpenMenu('cycles')
		end
	elseif this == "vehicles" then
		if btn == "Sports" then
			OpenMenu('sports')
		elseif btn == "Sedans" then
			OpenMenu('sedans')
		elseif btn == "Job Vehicles" then
			OpenMenu('jobvehicles')
		elseif btn == "Compacts" then
			OpenMenu('compacts')
		elseif btn == "Coupes" then
			OpenMenu('coupes')
		elseif btn == "Sports Classics" then
			OpenMenu("sportsclassics")
		elseif btn == "casino" then
			OpenMenu('casino')
		elseif btn == "Muscle" then
			OpenMenu('muscle')
		elseif btn == "Off-Road" then
			OpenMenu('offroad')
		elseif btn == "SUVs" then
			OpenMenu('suvs')
		elseif btn == "Vans" then
			OpenMenu('vans')
		end
	elseif this == "jobvehicles" or this == "compacts" or this == "coupes" or this == "sedans" or this == "sports" or this == "sportsclassics" or this == "casino" or this == "muscle" or this == "offroad" or this == "suvs" or this == "vans" or this == "industrial" or this == "cycles" or this == "motorcycles" then
		if ownerMenu then
			updateCarTable(button.model,button.costs,button.name)
		else
			TriggerServerEvent('CheckMoneyForVeh',button.name, button.model, button.costs)
		end
	end
end

function OpenMenu(menu)
	fakecar = {model = '', car = nil}
	vehshop.lastmenu = vehshop.currentmenu
	if menu == "vehicles" then
		vehshop.lastmenu = "main"
	elseif menu == "bikes"  then
		vehshop.lastmenu = "main"
	elseif menu == 'race_create_objects' then
		vehshop.lastmenu = "main"
	elseif menu == "race_create_objects_spawn" then
		vehshop.lastmenu = "race_create_objects"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "main" then
		CloseCreator()
	elseif vehshop.currentmenu == "jobvehicles" or vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "casino" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
		if DoesEntityExist(fakecar.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
		end
		fakecar = {model = '', car = nil}
		OpenMenu(vehshop.lastmenu)
	else
		OpenMenu(vehshop.lastmenu)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ( IsControlJustPressed(1,Controlkey["generalUse"][1]) or IsControlJustPressed(1, Controlkey["generalUseSecondary"][1]) ) and IsPlayerInRangeOfVehshop() then
			if vehshop.opened then
				CloseCreator()
			else
				OpenCreator()
			end
		end
		if vehshop.opened then

			local ped = LocalPed()
			local menu = vehshop.menu[vehshop.currentmenu]
			local y = vehshop.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false
			local myJob = exports['isPed']:isPed('job')
			for i,button in pairs(menu.buttons) do
				--local br = button.rank ~= nil and button.rank or 0
				if myJob == 'PDM' and i >= vehshop.menu.from and i <= vehshop.menu.to then

					if i == vehshop.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,vehshop.menu.x,y,selected)

					if button.costs ~= nil then
						drawMenuRight("$"..button.costs,vehshop.menu.x,y,selected)
					end

					y = y + 0.04
					if vehshop.currentmenu == "jobvehicles" or vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "casino" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
						if selected then
							if fakecar.model ~= button.model then
								if DoesEntityExist(fakecar.car) then
									Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
								end
								local pos = currentlocation.pos.inside
								local hash = GetHashKey(button.model)
								RequestModel(hash)
								while not HasModelLoaded(hash) do
									Citizen.Wait(0)


								end
								local veh = CreateVehicle(hash,pos[1],pos[2],pos[3],pos[4],false,false)
								SetModelAsNoLongerNeeded(hash)
								local timer = 9000
								while not DoesEntityExist(veh) and timer > 0 do
									timer = timer - 1
									Citizen.Wait(1)
								end
								TriggerEvent("vehsearch:disable",veh)

								FreezeEntityPosition(veh,true)
								SetEntityInvincible(veh,true)
								SetVehicleDoorsLocked(veh,4)
								--SetEntityCollision(veh,false,false)
								TaskWarpPedIntoVehicle(LocalPed(),veh,-1)
								for i = 0,24 do
									SetVehicleModKit(veh,0)
									RemoveVehicleMod(veh,i)
								end
								fakecar = { model = button.model, car = veh}
								local topspeed = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel') / 2)
								local handling = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock') * 2)
								local braking = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce') * 100)
								local accel = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce') * 100) 
								if button.model == "rumpo" then
									SetVehicleLivery(veh,2)
								end
							end
						end
					end
					if selected and ( IsControlJustPressed(1,Controlkey["generalUse"][1]) or IsControlJustPressed(1, Controlkey["generalUseSecondary"][1])  ) then
						ButtonSelected(button)
					end
				end
			end

			if DoesEntityExist(fakecar.car) then
				if vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
					daz = 6.0
					if fakecar.model == "Chimera" then
						daz = 8.0
					end
					if fakecar.model == "bmx" then
						daz = 8.0
					end
					 x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, -1.5, daz))
		        	Citizen.InvokeNative(0x87D51D72255D4E78,scaleform, x,y,z, 0.0, 180.0, 100.0, 1.0, 1.0, 1.0, 7.0, 7.0, 7.0, 0)
				else
		       		x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, -1.5, 10.0))
		       		Citizen.InvokeNative(0x87D51D72255D4E78,scaleform, x,y,z, 0.0, 180.0, 100.0, 1.0, 1.0, 1.0, 10.0, 10.0, 10.0, 0)		
				end
				TaskWarpPedIntoVehicle(LocalPed(),fakecar.car,-1)
		    end

		end
		if vehshop.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if vehshop.selectedbutton > 1 then
					vehshop.selectedbutton = vehshop.selectedbutton -1
					if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
						vehshop.menu.from = vehshop.menu.from -1
						vehshop.menu.to = vehshop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if vehshop.selectedbutton < buttoncount then
					vehshop.selectedbutton = vehshop.selectedbutton +1
					if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
						vehshop.menu.to = vehshop.menu.to + 1
						vehshop.menu.from = vehshop.menu.from + 1
					end
				end
			end
		end

	end
end)

AddEventHandler('FinishMoneyCheckForVeh', function(name, vehicle, price,financed)
	local name = name
	local vehicle = vehicle
	local price = price
	boughtcar = true
	CloseCreator(name, vehicle, price,financed)
end)

ShowVehshopBlips(true)
AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		--326 car blip 227 225
		ShowVehshopBlips(true)
		firstspawn = 1
	end
end)

AddEventHandler('vehshop:spawnVehicle', function(v)
	local car = GetHashKey(v)
	local playerPed = PlayerPedId()
	if playerPed and playerPed ~= -1 then
		RequestModel(car)
		while not HasModelLoaded(car) do
			Citizen.Wait(0)
		end
		local playerCoords = GetEntityCoords(playerPed)
		veh = CreateVehicle(car, playerCoords, 0.0, true, false)
		SetModelAsNoLongerNeeded(car)
		TaskWarpPedIntoVehicle(playerPed, veh, -1)
		SetEntityInvincible(veh, true)
	end
end)

local firstspawn = 0

AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		RemoveIpl('v_carshowroom')
		RemoveIpl('shutter_open')
		RemoveIpl('shutter_closed')
		RemoveIpl('shr_int')
		RemoveIpl('csr_inMission')
		RequestIpl('v_carshowroom')
		RequestIpl('shr_int')
		RequestIpl('shutter_closed')
		firstspawn = 1
	end
end)


RegisterCommand('finance', function(source, args, raw)
	local myJob = exports['isPed']:isPed('job')
	if exports['isPed']:isPed('job') == 'PDM' then
		TriggerEvent('finance')
	elseif myJob == 'tuner' then
		TriggerEvent('finance_tuner')
	else
		TriggerEvent('DoLongHudText', 'You dont have permissions for this!', 2)
	end
end)

RegisterCommand('commission', function(source, args, raw)
	local myJob = exports['isPed']:isPed('job')
	if exports['isPed']:isPed('job') == 'PDM' then
		local amount = args[1]
		if amount ~= nil then
			TriggerEvent('commission', amount)
		else
			TriggerEvent('DoLongHudText', 'Invalid amount "/commision [amount]', 1)
		end
	elseif myJob == 'tuner' then
		local amount = args[1]
		if amount ~= nil then
			TriggerEvent('commission_tuner', amount)
		else
			TriggerEvent('DoLongHudText', 'Invalid amount "/commision [amount]', 1)
		end
	else
		TriggerEvent('DoLongHudText', 'You dont have permissions for this!', 2)
	end
end)

RegisterCommand('testdrive', function(source, args, raw)
	local myJob = exports['isPed']:isPed('job')
	if exports['isPed']:isPed('job') == 'PDM' then
		TriggerEvent('car:testdrive')
	elseif myJob == 'tuner' then
		TriggerEvent('car:testdrive_tuner')
	else
		TriggerEvent('DoLongHudText', 'You dont have permissions for this!', 2)
	end
end)

RegisterCommand('enableBuy', function(source, args, raw)
	local myJob = exports['isPed']:isPed('job')
	if exports['isPed']:isPed('job') == 'PDM' then
		TriggerEvent('buyEnable')
	elseif myJob == 'tuner' then
		TriggerEvent('tuner:enable_buy')
	else
		TriggerEvent('DoLongHudText', 'You dont have permissions for this!', 2)
	end
end)
