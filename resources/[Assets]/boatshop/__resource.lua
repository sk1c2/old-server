resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'


client_script "@np-errorlog/client/cl_errorlog.lua"


server_scripts {
	'server.lua',
	'boatshop_s.lua',
	"@mysql-async/lib/MySQL.lua"
}
client_script {
	'client.lua',
	'GUI.lua',
	'boatshop.lua'
}
