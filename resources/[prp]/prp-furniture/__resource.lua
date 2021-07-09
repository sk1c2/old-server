client_script "@prp-errorlog/client/cl_errorlog.lua"

ui_page 'index.html'

files {
  "index.html",
  "scripts.js",
  "css/style.css"
}
client_script {
  "client.lua",
  "objectList.lua",
}

server_script {
  "server.lua"
}