resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

dependencies {
    "PolyZone"
}

ui_page('client/html/index.html')

files({
    'client/html/index.html',
    'client/html/script.js',
})

server_script { 
    '@mysql-async/lib/MySQL.lua',
    'vehshop_s.lua',
}

client_script {
    "vehshop.lua",
    'client.lua',
}