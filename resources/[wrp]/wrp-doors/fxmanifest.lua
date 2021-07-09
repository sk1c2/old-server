fx_version 'bodacious'
games { 'rdr3', 'gta5' }

author 'PixelRez'
description 'Wonder Doors'
version '1.0.0'

-- dependency "np-base"
dependency "ghmattimysql"

shared_script "shared/sh_doors.lua"

server_script "server/sv_doors.lua"
client_script "client/cl_doors.lua"

server_export 'isDoorLocked'