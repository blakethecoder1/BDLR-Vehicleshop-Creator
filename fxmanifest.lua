fx_version 'cerulean'
game 'gta5'

author 'BLDR Team'
description 'Vehicleshop Creator - QBCore + ox_lib'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@qb-core/server/import.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

lua54 'yes'

dependencies {
    'qb-core',
    'ox_lib',
    'oxmysql'
}

provides {
    'vehicleshop'
}
