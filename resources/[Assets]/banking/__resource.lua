resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'


ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/bank-icon.png',
	'html/logo.png',
	'html/cursor.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

server_scripts  {
	'@mysql-async/lib/MySQL.lua',
    'server.lua'
}

client_script "client.lua"
client_script "@prp-errorlog/client/cl_errorlog.lua"

