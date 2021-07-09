resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'


client_script "@wrp-errorlog/client/cl_errorlog.lua"
-- server_script "@np-fml/server/lib.lua"

server_script "server.lua"
client_script "truckerjob.lua"
server_export 'AddJob' 

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/background.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
}
