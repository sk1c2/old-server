fx_version 'adamant'

game 'gta5'

server_scripts {
	'server/main.lua',
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua'
}

client_scripts {
	'client/main.lua',
	"@prp-errorlog/client/cl_errorlog.lua"
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/logo.png',
	'html/dmv.png',
	'html/styles.css',
	'html/questions.js',
	'html/scripts.js',
	'html/debounce.min.js'
}

