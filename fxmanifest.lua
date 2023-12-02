fx_version 'cerulean'
games { 'gta5' }

name 'keep-bags'
description 'a bag script that allows players to carry more items within their inventory'
version '2.1.0'
author "Swkeep#7049"
repository 'https://github.com/swkeep/keep-bags'

shared_scripts {
     'shared/harmony.lua',
     'locale/en.lua',
     'locale/de.lua',
     'shared/props.lua',
     'config.lua',
     'shared/shared.lua',
}

client_scripts {
     'client/client_main.lua',
     'client/functions.lua',
     'client/clothing.lua',
     'client/backpacks.lua',
     'client/inventory.lua',
}

server_script {
     '@oxmysql/lib/MySQL.lua',
     'server/server_main.lua',
     'server/lockpick.lua',
}

dependencies {
     'oxmysql',
     'keep-harmony'
}

lua54 'yes'
