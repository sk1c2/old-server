fx_version 'adamant'

games {'gta5'}

ui_page('ui/index.html')

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua'
}

client_scripts {
    'client/client.lua'
}

files({
    'ui/index.html',
    'ui/app.js',
    'ui/style.css',
})
