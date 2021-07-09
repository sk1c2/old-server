fx_version 'adamant'
games { 'gta5' }

dependencies {
    "PolyZone"
}

ui_page('client/html/index.html')

files({
    'client/html/index.html',
    'client/html/script.js',
})

client_scripts {
    "@PolyZone/client.lua",
    'client.lua',
    "@wrp-errorlog/client/cl_errorlog.lua"
}
