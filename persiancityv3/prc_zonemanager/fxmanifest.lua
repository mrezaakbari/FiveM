fx_version "adamant"

game "gta5"
author "Mreza"
description "Persian City blip and marker manager"
version '0.1.0'

client_scripts {
    'client/*.lua'
}

exports {
	'AddBlip',
    'AddMarkerZone',
    'RemoveBlip',
    'RemoveMarkerZone'
}
