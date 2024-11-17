fx_version 'cerulean'
game 'gta5'

description 'QB-CarRentals - Vehicle Rental System'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page {
    'html/index.html'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/images/*.jpg',
    'html/images/*.png'
}

lua54 'yes'
use_fxv2_oal 'yes'
