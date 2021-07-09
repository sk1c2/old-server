fx_version 'cerulean'
games { 'gta5' }

client_script "@wrp-errorlog/client/cl_errorlog.lua"
client_script 'carhud.lua'
server_script 'carhud_server.lua'
client_script 'cl_autoKick.lua'
server_script 'sr_autoKick.lua'
client_script 'newsStands.lua'

ui_page('html/index.html')

files({
	"html/script.js",
	"html/jquery.min.js",
	"html/jquery-ui.min.js",
	"html/debounce.min.js",
	"html/styles.css",
	"html/img/*.svg",
	"html/img/*.png",
	"html/index.html",
	"html/fonts/Roboto-Bold.ttf",
	"html/fonts/Roboto-Bold.woff",
	"html/fonts/Roboto-Bold.woff2",
	"html/fonts/Roboto-Regular.ttf",
	"html/fonts/Roboto-Regular.woff",
	"html/fonts/Roboto-Regular.woff2",
	"html/fonts/upbolters.otf",
})

exports {
	"playerLocation",
	"playerZone",
	"GetStress",
	"GetFood",
	"GetThirst"
}