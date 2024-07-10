------------------------------------------------------------------
--                  Developed By MReza
--               For Persian City Fivem Server
--                 Discord: mrezaa
------------------------------------------------------------------
------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------
ESX = nil
local connectedPlayers = {0}
local OnlinePlayersJob = {police = 0, sheriff = 0, ambulance = 0, mecano = 0, taxi = 0, justice = 0 }
local OnlineAdmins  = 0
local queueCount = 0
TriggerEvent('esx:getShMRezaaredObjMRezaect', function(obj) ESX = obj end)
------------------------------------------------------------------
--                          Server Call back
------------------------------------------------------------------
ESX.RegisterServerCallback('PRC_scoreboard:getPlayersJob', function(source, cb)
	cb(OnlinePlayersJob)
end)

ESX.RegisterServerCallback('PRC_scoreboard:getOnlineAdmins', function(source, cb)
	cb(OnlineAdmins)

end)

ESX.RegisterServerCallback('PRC_scoreboard:getQueue', function(source,cb)
	cb(queueCount)
end)
------------------------------------------------------------------
--                       Citizen Thread
------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		--UpdatePing()
		AddPlayerToScoreboard()
	end
end)
------------------------------------------------------------------
--                          Event Handler
------------------------------------------------------------------
AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			Citizen.Wait(1500)
			AddPlayerToScoreboard()
		end)
	end
end)

RegisterServerEvent('scoreboardproxi')
AddEventHandler('scoreboardproxi', function(playerName, message)
    local _source = source
    TriggerClientEvent("sendProximityMessage", -1, source, playerName, message)
end)
------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------
function AddPlayerToScoreboard()
	OnlinePlayersJob = {police = 0,sheriff = 0,ambulance = 0,mecano = 0,taxi = 0, justice = 0}
	OnlineAdmins = 0
	--exports:["connectqueue"]:GetQueueExports()
	for _,v in pairs(GetPlayers()) do
		xPlayer = ESX.GetPlayerFromId(v)
		if xPlayer then
		if xPlayer.job.label == "Police" or xPlayer.job.label == "Swat" or xPlayer.job.label == "fbi"  then
			OnlinePlayersJob.police = OnlinePlayersJob.police + 1
		elseif xPlayer.job.label == "Sheriff" or xPlayer.job.label == "Army" and xPlayer.job.grade >= 0 then
			OnlinePlayersJob.sheriff = OnlinePlayersJob.sheriff + 1
		elseif xPlayer.job.label == "Ambulance" and xPlayer.job.grade >= 0 then
			OnlinePlayersJob.ambulance = OnlinePlayersJob.ambulance + 1
		elseif xPlayer.job.label == "Mechanic" and xPlayer.job.grade >= 0 then
			OnlinePlayersJob.mecano = OnlinePlayersJob.mecano + 1
		elseif xPlayer.job.label == "Taxi" and xPlayer.job.grade >= 0 then
			OnlinePlayersJob.taxi = OnlinePlayersJob.taxi + 1
		elseif xPlayer.job.label == "Justice" and xPlayer.job.grade >= 0 then
			OnlinePlayersJob.justice = OnlinePlayersJob.justice + 1
		end
		if xPlayer.permission_level > 0  and xPlayer.aduty then
       	    OnlineAdmins = OnlineAdmins + 1
		end
	end
	end
end

function UpdatePing()
	for k,v in pairs(connectedPlayers) do
		v.ping = GetPlayerPing(k)
		TriggerClientEvent('status:updatePing', k, v.ping)
	end
	TriggerClientEvent('esx_scoreboard:updatePing', -1, connectedPlayers)
end
------------------------------------------------------------------
--                          Commands
------------------------------------------------------------------
RegisterCommand('screfresh', function(source, args, user)

	local xPlayer = ESX.GetPlayerFromId(source)

		if xPlayer.permission_level > 1 then

			AddPlayerToScoreboard()

		else

			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")

		end

end, false)

RegisterCommand('sctoggle', function(source, args, user)

	local xPlayer = ESX.GetPlayerFromId(source)

		if xPlayer.permission_level > 1 then

			TriggerClientEvent('esx_scoreboard:toggleID', source)
			
		else

			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")

		end

end, false)