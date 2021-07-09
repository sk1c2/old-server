fx_version 'adamant'
games { 'gta5' }

client_script "@wrp-errorlog/client/cl_errorlog.lua"

ui_page 'index.html'

files {
  "index.html",
  "scripts.js",
  "css/style.css"
}
client_script {
  "client.lua",
}

export "taskBar"
export "closeGuiFail"