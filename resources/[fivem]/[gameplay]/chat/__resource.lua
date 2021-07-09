resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/index.css',
  'html/config.js',
  'html/App.js',
  'html/Message.js',
  'html/Suggestions.js',
  'html/vendor/vue.2.3.3.min.js',
  'html/vendor/flexboxgrid.6.3.1.min.css',
  'html/vendor/animate.3.5.2.min.css',
  'html/vendor/latofonts.css',
  'html/vendor/fonts/LatoRegular.woff2',
  'html/vendor/fonts/LatoRegular2.woff2',
  'html/vendor/fonts/LatoLight2.woff2',
  'html/vendor/fonts/LatoLight.woff2',
  'html/vendor/fonts/LatoBold.woff2',
  'html/vendor/fonts/LatoBold2.woff2',
  'html/image/CID.png',
  'html/image/F.png',
  'html/image/M.png',
}

client_scripts {
  'client/cl_chat.lua',
  'client/commands.lua',
}

server_scripts {
  'server/utils.lua',
  'server/commands.lua',
  'server/sv_chat.lua',
  'server/main.lua',
}