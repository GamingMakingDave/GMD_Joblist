fx_version 'cerulean'
game {'gta5'}
author 'GMD-Scripts'
description 'GMD_Joblists'

version '1.0.0'
lua54 'no'

shared_script 'config.lua'

ui_page('nui/index.html')

files {
    'nui/index.html',
    'nui/media/fonts/*.ttf',
    'nui/media/fonts/*.otf',
    'nui/script/*.js',
    'nui/style/style.css'
}

client_scripts {
    'client/*.lua'
}

server_script {
'@oxmysql/lib/MySQL.lua',
'server/*.lua'
}