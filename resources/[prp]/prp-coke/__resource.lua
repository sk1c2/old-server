-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'T1GER New Drugs'

author 'T1GER#9080'

client_scripts {
    "config.lua",
    "client.lua",
    "drilling.lua",
    'client/classes/String.lua',
    'client/classes/Blip.lua',
    'client/classes/Marker.lua',
    'client/classes/Scenes.lua',
    'client/cl_rapey.lua',
    'client/classes/Vector.lua',
    'client/classes/Vehicle.lua',
    'client/classes/Scaleforms.lua',
  
    'client/scripts/BlipHandler.lua',
    'client/scripts/MarkerHandler.lua',
    'client/scripts/Networking.lua',
    'client/scripts/Streaming.lua',
    'client/scripts/Teleporter.lua',
    'client/scripts/Notifications.lua',
    'client/scripts/Controls.lua',
    'client/scripts/VehicleProperties.lua'
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server.lua",
    'server/classes/String.lua',  
    'server/classes/Table.lua',  
    'server/classes/Json.lua',  
    'server/sv_rapey.lua',
  
    'server/scripts/Utilities.lua',
    'server/scripts/_.lua'
}

exports {
    "Scaleforms"
}