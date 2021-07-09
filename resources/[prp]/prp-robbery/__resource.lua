resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'


server_scripts {'server/sv_store.lua', 'server/sv_sBank.lua', 'server/nRobbery_server.lua'}
client_scripts {'client/cl_store.lua', 'client/cl_sBank.lua', 'client/nRobbery_client.lua', 'client/nRobbery_list.lua'}


ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/button.png',
	'html/electronic.png',
	'html/gruppe622.png',
	'html/gruppe62.png',
	'html/lockpick.png',
	'html/thermite.png',
	'html/airlock.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}
