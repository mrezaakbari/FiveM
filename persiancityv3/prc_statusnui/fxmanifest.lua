fx_version 'adamant'
games { 'gta5' }


author "mreza"
discription "Player Status scritp"
version "1.0"

client_script {
	'client/*.lua'
}

server_script {
	'server/*.lua'
}

ui_page('html/index.html')

exports{
	"ShowIdCard"
}

files({
	"html/icons/*.png",
	"html/fonts/*.ttf",
	"html/*.png",
	"html/*.js",
	"html/*.css",
	"html/*.html"
})