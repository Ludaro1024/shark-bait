fx_version "cerulean"
game "gta5"
lua54 "yes"


name "shark-bait"
description "Makes Sharks attack you when you are in deep water."
author "Ludaro"
version "1"

client_scripts {
    "client/*.lua",
}

--server_scripts {
 --   "server/*.lua",
--}

shared_scripts {
    --'@ox_lib/init.lua',
    "shared/*.lua",
}
