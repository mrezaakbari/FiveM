fx_version "adamant"
game "gta5"

author 'mreza'
description 'Persian Taxi Job'
version '2.0'

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config/*.lua',
	'client/*.lua'
}

server_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config/*.lua',
	'server/*.lua'
}

dependencys {'essentialmode', 'prc_zonemanager', 'prc_helpnui'}