fx_version 'cerulean'
games { 'gta5' }

name 'keep-backpack'
description 'a backpack script that allows players to carry more items within their inventory'
version '2.0.0'
author "Swkeep#7049"
repository 'https://github.com/swkeep/keep-backpack'

shared_scripts {
     'locale/en.lua',
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

dependency 'oxmysql'

lua54 'yes'
