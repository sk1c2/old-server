Config = {}

Config.MinPolice                 = 4       -- Min number of police needed to rob jewelry store.
Config.ResetTime                 = 120        -- Number of Minutes the store will reset after first case is broken

Config.Closed                    =  false      -- Sets store to closed if the police online is less then MinPolice
Config.AllowPoliceStoreClose     =  true     -- Allows any job set in Config.PoliceJobs to Close the store after a robbery until next store reset.

Config.PoliceNotifyBroken        =  100       -- The chance breaking a case will notify the police.  Setting to 100 will notify first broken case..
Config.PoliceNotifyNonBroken     =  0       -- The chance attempting to break a case will notify the police.  Setting to 100 will notify every attempt.

Config.PlayFailSound             =  true    -- Uses sound for failed attempt to break.

-- AllowedWewapons lists all weapons that are able to be used to break cases with the chance percent it has of breaking glass.
Config.AllowedWeapons = {
   { name = 'WEAPON_CROWBAR', chance = 75 },
   { name = 'WEAPON_ADVANCEDRIFLE', chance = 100 },
   { name = 'WEAPON_ASSAULTRIFLE', chance = 100 },
   { name = 'WEAPON_ASSAULTSHOTGUN', chance = 100 },
   { name = 'WEAPON_ASSAULTSMG', chance = 100 },
   { name = 'WEAPON_BULLPUPSHOTGUN', chance = 100 },
   { name = 'WEAPON_CARBINERIFLE', chance = 100 },
   { name = 'WEAPON_COMBATMG', chance = 100 },
   { name = 'WEAPON_COMBATPISTOL', chance = 100 },
   { name = 'WEAPON_COMPACTRIFLE', chance = 100 },
   { name = 'WEAPON_DBSHOTGUN', chance = 100 },
   { name = 'WEAPON_GUSENBERG', chance = 100 },
   { name = 'WEAPON_HEAVYPISTOL', chance = 30 },
   { name = 'WEAPON_MACHINEPISTOL', chance = 100 },
   { name = 'WEAPON_MG', chance = 100 },
   { name = 'WEAPON_MICROSMG', chance = 100 },
   { name = 'WEAPON_MINISMG', chance = 100 },
   { name = 'WEAPON_MICROSMG', chance = 100 },
   { name = 'WEAPON_PISTOL', chance = 65 },
   { name = 'WEAPON_PISTOL50', chance = 50 },
   { name = 'WEAPON_PISTOL_MK2', chance = 100 },
   { name = 'WEAPON_PUMPSHOTGUN', chance = 100 },
   { name = 'WEAPON_REVOLVER', chance = 100 },
   { name = 'WEAPON_SAWNOFFSHOTGUN', chance = 100 },
   { name = 'WEAPON_SMG', chance = 100 },
   { name = 'WEAPON_VINTAGEPISTOL', chance = 60 },
}

-- List of all jobs that are law enforcement in your server.
Config.PoliceJobs =  {
   'Police',
}

--  These jobs will not be able to rob the jewelry store at all.
Config.UnAuthJobs = {
   'Police',
   'EMS',  
}

--  These are the items you can recieve from breaking a case - need to be listed from lowest chance to highest chance.
--  If you have the highest chance set to less then 100 - will have a chance to not recieve any items from box.
--  You will need to change the names of these items to items in your database or enter these items into your database.
Config.ItemDrops  = {
   { name = 'jewels', max = 10, chance = 100 },
}


-- Do Not Edit -- This list is just the general information for each of the 20 cases.
Config.CaseLocations = {
   [1] = {
      Pos = { x = -626.3253, y = -239.0511, z = 37.64523 },
      Prop = 'des_jewel_cab2_end',
      Prop1 = 'des_jewel_cab2_start',
      Broken = false,
   },
   [2] = {
      Pos = { x = -625.2751, y = -238.2881, z = 37.64523 },
      Prop = 'des_jewel_cab3_end',
      Prop1 = 'des_jewel_cab3_start',
      Broken = false,
   },
   [3] = {
      Pos = { x = -627.2115, y = -234.8942, z = 37.64523 },
      Prop = 'des_jewel_cab3_end',
      Prop1 = 'des_jewel_cab3_start',
      Broken = false,
   },
   [4] = {
      Pos = { x = -626.1613, y = -234.1315, z = 37.64523 },
      Prop = 'des_jewel_cab4_end',
      Prop1 = 'des_jewel_cab4_start',
      Broken = false,
   },
   [5] = {
      Pos = { x = -626.5439 , y = -233.6047 , z = 37.64523 },
      Prop = 'des_jewel_cab_end',
      Prop1 = 'des_jewel_cab_start',
      Broken = false,
   },
   [6] = {
      Pos = { x = -627.5945 , y = -234.3678, z = 37.64523 },
      Prop = 'des_jewel_cab_end',
      Prop1 = 'des_jewel_cab_start',
      Broken = false,
   },
   [7] = {
      Pos = { x = -622.6159, y = -232.5636, z = 37.64523 },
      Prop = 'des_jewel_cab_end',
      Prop1 = 'des_jewel_cab_start',
      Broken = false,
   },
   [8] = {
      Pos = { x = -620.5214, y = -232.8823, z = 37.64523 },
      Prop = 'des_jewel_cab4_end',
      Prop1 = 'des_jewel_cab4_start',
      Broken = false,
   },
   [9] = {
      Pos = { x = -620.1764, y =-230.7865 , z = 37.64523 },
      Prop = 'des_jewel_cab_end',
      Prop1 = 'des_jewel_cab_start',
      Broken = false,
   },
   [10] = {
      Pos = { x = -621.5175, y = -228.9474, z = 37.64523 },
      Prop = 'des_jewel_cab3_end',
      Prop1 = 'des_jewel_cab3_start',
      Broken = false,
   },
   [11] = {
      Pos = { x = -623.6147, y = -228.6247, z = 37.64523 },
      Prop = 'des_jewel_cab2_end',
      Prop1 = 'des_jewel_cab2_start',
      Broken = false,
   },
   [12] = {
      Pos = { x = -623.9558, y = -230.7263, z = 37.64523 },
      Prop = 'des_jewel_cab4_end',
      Prop1 = 'des_jewel_cab4_start',
      Broken = false,
   },
   [13] = {
      Pos = { x = -619.8483, y = -234.9137, z = 37.64523 },
      Prop = 'des_jewel_cab_end',
      Prop1 = 'des_jewel_cab_start',
      Broken = false,
   },
   [14] = {
      Pos = { x = -618.7984, y = -234.1509, z = 37.64523 },
      Prop = 'des_jewel_cab3_end',
      Prop1 = 'des_jewel_cab3_start',
      Broken = false,
   },
   [15] = {
      Pos = { x = -624.2796, y = -226.6066, z = 37.64523 },
      Prop = 'des_jewel_cab4_end',
      Prop1 = 'des_jewel_cab4_start',
      Broken = false,
   },
   [16] = {
      Pos = { x = -625.3300, y = -227.3697, z = 37.64523 },
      Prop = 'des_jewel_cab3_end',
      Prop1 = 'des_jewel_cab3_start',
      Broken = false,
   },
   
   [17] = {
      Pos = { x = -619.2031, y = -227.2482, z = 37.64523 },
      Prop = 'des_jewel_cab2_end',
      Prop1 = 'des_jewel_cab2_start',
      Broken = false,
   },
   [18] = {
      Pos = { x = -619.9662, y = -226.198, z = 37.64523 },
      Prop = 'des_jewel_cab_end',
      Prop1 = 'des_jewel_cab_start',
      Broken = false,
   },
   [19] = {
      Pos = { x = -617.0856, y = -230.1627, z = 37.64523 },
      Prop = 'des_jewel_cab2_end',
      Prop1 = 'des_jewel_cab2_start',
      Broken = false,
   },
   [20] = {
      Pos = { x = -617.8492, y = -229.1128, z = 37.64523 },
      Prop = 'des_jewel_cab3_end',
      Prop1 = 'des_jewel_cab3_start',
      Broken = false,
   },
 }



