Config              = {}

Config.DrawDistance = 100.0

Config.Marker = {
	Type = 1,
	x = 1.5, y = 1.5, z = 1.0,
	r = 255, g = 55, b = 55
}

Config.Pads = {

	MartinHouseIn = {
		Text = 'Press ~INPUT_CONTEXT~ to enter ~y~house~s~.',
		Marker = { x = 480.5, y = -1316.96, z = 28.2 },
		TeleportPoint = { x = -1081.95, y = 4925.42, z = 213.54, h = 121.5 },
		auth = {'Alpha', 'police', 'swat','army', 'sheriff', 'fbi'}
	},
	MartinHouseOut = {
		Text = 'Press ~INPUT_CONTEXT~ to leave the ~y~house~s~.',
		Marker = { x = -1073.99, y = 4932.05, z = 211.63 },
		TeleportPoint = { x = 489.36, y = -1313.15, z = 29.26, h = 290.71 },
		auth = {'Alpha', 'police', 'swat','army', 'sheriff', 'fbi'}
	},
	IslandHouseIn = {
		Text = 'Press ~INPUT_CONTEXT~ to enter ~y~house~s~.',
		Marker = { x = 4981.6, y = -5709.96, z = 18.89 },
		TeleportPoint = { x = 4991.19, y = -5718.52, z = 19.88, h = 229.55 },
		auth = {'freemason', 'police', 'swat','army', 'sheriff', 'fbi'}
	},
	IslandHouseOut = {
		Text = 'Press ~INPUT_CONTEXT~ to leave the ~y~house~s~.',
		Marker = { x = 4989.72, y = -5717.39, z = 18.88 },
		TeleportPoint = { x = 4979.33, y = -5708.97, z = 19.89, h = 47.77 },
		auth = {'freemason', 'police', 'swat','army', 'sheriff', 'fbi'}
	},
}