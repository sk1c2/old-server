fx_version 'cerulean'
games { 'gta5' }

--[[ dependencies {
  "np-polyzone",
  "np-lib",
  "np-ui"
} ]]--


client_scripts {
  'client/cl_*.lua',
  'client/cl_*.js',
  "@PolyZone/client.lua",
  "@PolyZone/ComboZone.lua",
}

shared_script {
  'shared/sh_*.*',
}

server_scripts {
  'server/sv_*.lua',
  'server/sv_*.js',
}
