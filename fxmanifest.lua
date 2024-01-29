fx_version "cerulean"
game "gta5"
lua54 "yes"


name "Boilerplate"
description "Boilerplate"
author "Ludaro"
version "0"

client_scripts {
    "client/*.lua",
}

server_scripts {
    "server/*.lua",
}

shared_scripts {
    --'@ox_lib/init.lua',
    "shared/*.lua",
}
