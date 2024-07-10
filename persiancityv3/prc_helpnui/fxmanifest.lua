fx_version 'adamant'

game 'gta5'

author 'mreza'
description 'nui manager'
version '1.0'

client_script {
	'client/*.lua'
}

ui_page('html/index.html')

files({
	"html/*.js",
	"html/*.css",
	"html/*.html",
	"html/fonts/*.ttf"
})

exports {
	'ShowHelpPrompet',
	'HideHelpPrompet'
}
