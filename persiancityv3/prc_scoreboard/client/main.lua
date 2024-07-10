------------------------------------------------------------------
--                  Developed By MReza
--               For Persian City Fivem Server
--                 Discord: mrezaa
------------------------------------------------------------------
------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------
PRC = nil
local Visable = false
local IsPaused = false
local IsIdVisible = false
------------------------------------------------------------------
--                       Citizen Thread
------------------------------------------------------------------
Citizen.CreateThread(function()
	while PRC == nil do
		TriggerEvent('esx:getShMRezaaredObjMRezaect', function(obj) PRC = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	local time = 0
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, 57) and IsInputDisabled(0) then
			--ToggleScoreBoard()
		elseif IsControlJustReleased(0, 117) and IsInputDisabled(0) then
			if GetGameTimer() - time > 60000 then
				TriggerServerEvent("scoreboardproxi", GetPlayerName(PlayerId())," Be Id Ha Negah Kard")
				time = GetGameTimer()
				IsIdVisible = true
			else
				ShowNotification("Spam nakonid ! ")
			end
		end
		if IsIdVisible then
			if GetGameTimer() - time >= 3000 then
				IsIdVisible = false
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsIdVisible then
			local nearbyPlayers = GetNeareastPlayers()
			for k, v in pairs(nearbyPlayers) do
				local x, y, z = table.unpack(v.coords)
				Draw3DText(x, y, z + 1.1, v.playerId)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if(Visable and IsPauseMenuActive()) then
			SendNUIMessage({action = 'close'})
			Visable = false
		end
	end
end)
------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------
function ShowNotification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

function ToggleScoreBoard()
	if Visable then
		SendNUIMessage({action = 'toggle', show = false})
		Visable = false
	else
		UpdateData()
		SendNUIMessage({action = 'toggle', show = true})
		Visable = true
	end
end

function UpdateData()
	Citizen.CreateThread(function()
		SendNUIMessage({action = 'updateId', data =tostring(GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))))})
		while Visable do
			-- Update Players
			local Players = GetActivePlayers()
			SendNUIMessage({action = 'updatePlayers', count = #Players})
			-- Update Admins
			PRC.TriggerServerCallback('PRC_scoreboard:getOnlineAdmins', function(data)
				SendNUIMessage({action = 'updateAdmins', count = data})
			end)
			-- Update Jobs
			PRC.TriggerServerCallback('PRC_scoreboard:getPlayersJob', function(data)
				SendNUIMessage({action = 'updateInfo', data = data})
			end)

			PRC.TriggerServerCallback('PRC_scoreboard:getQueue',function(data)
				SendNUIMessage({action = 'updateQueue', data = data})
			end)
			Citizen.Wait(6000)
		end
	end)
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        local dist = GetDistanceBetweenCoords(GetGameplayCamCoords(), x, y, z, 1)
        local scale = 1.8 * (1 / dist) * (1 / GetGameplayCamFov()) * 100

        -- Draw text on screen
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextEdge(4, 0, 0, 0, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function GetNeareastPlayers()
	local playerPed = PlayerPedId()
	local playerlist = GetActivePlayers()
   --local players, _ = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), Config.DrawDistance)
    local players_clean = {}
    local found_players = false
    for i = 1, #playerlist, 1 do
        found_players = true
        table.insert(players_clean, { playerName = GetPlayerName(playerlist[i]), playerId = GetPlayerServerId(playerlist[i]), coords = GetEntityCoords(GetPlayerPed(playerlist[i])) })
    end
    return players_clean
end