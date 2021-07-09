fx_version 'adamant'
game 'gta5'

server_script '@mysql-async/lib/MySQL.lua'
server_script 'sv_hunting.lua'
client_script "warmenu.lua"
client_script "cl_hunting.lua"


files{
    'html/*'
}

ui_page('html/index.html')