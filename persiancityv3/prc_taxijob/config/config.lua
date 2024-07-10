Config                            = {}

Config.DrawDistance               = 100.0

Config.MaxInService               = -1
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false

Config.Locale                     = 'en'

Config.AuthorizedVehicles = {

	{
		model = 'superd',
		label = 'Superd'
	},
	{
		model = 'taxi2',
		label = 'Mercedes Benz C CLASS'
	},
	
	{
		model = 'bmcitaxi',
		label = 'BMW Taxi'
	},
	{
        model = 'mersedestaxi', 
	    label = 'Mercedes Benz CLA'
    },
	{
        model = 'stretch', 
		label = 'Lemosen'
	}
}

Config.Zones = {
	VehicleSpawnPoint = {
		Pos     = {x = 911.108, y = -177.867, z = 74.283},
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Type    = -1, Rotate = false,
		Heading = 225.0
	},
	blip = {
		Pos     = {x = 907.73, y = -172.35, z = 74.283}
	}
}