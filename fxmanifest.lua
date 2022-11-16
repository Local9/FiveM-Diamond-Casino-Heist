fx_version "cerulean"
game "gta5"

author "Niels"
description "Diamond Casino Heist"
version "1.0.0"

lua54 "yes"

client_scripts {
    "client/rappel.lua",
    "client/anim.lua",
    "client/sewer.lua",
    "client/test.lua",
    "client/keycard.lua",
    "client/aggressive-ent.lua",
    "client/functions.lua",
    "client/main.lua", 
    "client/staff.lua",
    "client/security.lua",
    "client/mantrap.lua",
    "client/ipl.lua",
    "client/vault.lua",
    "client/hud.lua",
    "client/arcade.lua",
    "client/heist-entry.lua",
    "client/heist-casino.lua",
    "client/heist-vault.lua",
    "client/heist-drilling.lua",
    "client/heist-hacking.lua",
    "client/heist-exit.lua"
}

server_scripts { 
    "server/main.lua",
    "server/security.lua",
    "server/mantrap.lua",
    "server/hud.lua",
    "server/heist-casino.lua",
    "server/heist-entry.lua",
    "server/heist-vault.lua",
}

shared_scripts {
    "shared/*.lua"
}

escrow_ignore {
    "shared/*.lua"
}

dependencies {
    "/gameBuild:h4",
    "baseevents"
}