fx_version 'adamant'
games { 'gta5' }

ui_page "nui/radar.html"

files {
	"nui/digital-7.regular.ttf", 
	"nui/radar.html",
	"nui/radar.css",
	"nui/radar.js"
}

client_script 'cl_radar.lua'
client_script "@prp-errorlog/client/cl_errorlog.lua"