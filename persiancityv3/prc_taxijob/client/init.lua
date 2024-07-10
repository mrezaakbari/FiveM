------------------------------------------------------------------
--                  Developed By MReza
--               For Persian City Fivem Server
--                 Discord: mrezaa
------------------------------------------------------------------
------------------------------------------------------------------
--                       Citizen Thread
------------------------------------------------------------------
Citizen.CreateThread(function()
	exports["prc_zonemanager"]:AddMarkerZone("taxivehiclespawner", 903.41, -172.95, 73.1, 1.5, 1.5, 1.5, true)
	exports["prc_zonemanager"]:AddMarkerZone("taxivehiclesdeleter", 908.317, -183.070, 73.201, 3.0, 3.0, 0.25, true)
	exports["prc_zonemanager"]:AddMarkerZone("taxibossaction", 908.26, -152.74, 73.2, 1.5, 1.5, 1.5, true)
	exports["prc_zonemanager"]:AddMarkerZone("taxiclockroom", 897.69, -170.89, 73.2, 1.5, 1.5, 1.5, true)
end)