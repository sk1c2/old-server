resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'



ui_page 'html/index.html'

files {
	'html/index.html',
	'html/*'
}

client_script 'client.lua'
server_script 'server.lua'

exports {
	 'AddButton' , 'SetTitle'
}