resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

files {
    'client/dist/index.html',
    'client/dist/js/app.js',
    'client/dist/css/app.css',
}

client_scripts {
	'config.lua',
	'client/*.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua',

}

ui_page 'client/dist/index.html'