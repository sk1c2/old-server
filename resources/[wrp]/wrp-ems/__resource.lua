resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'EMS'

version '1.2.0'

server_scripts {
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua',
	'client/job.lua'
}